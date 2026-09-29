#!/bin/sh
# Generates a Presettle screening API key and the SHA-256 hash to put in the configuration.
# See docs/adr/0009-screening-api-authentication-with-api-keys.md.
#
# Usage:
#   ./scripts/generate-api-key.sh
#
# Output:
#   key   pst_<43 characters>   give this to the client system; it is shown only once
#   hash  <64 hex characters>   put this in Presettle's configuration, next to the client id
#
# Key format: "pst_" followed by 32 random bytes (256 bits) encoded as base64url without padding.
# The hash is the SHA-256 of the whole key, including the prefix, in lowercase hex.
#
# Requirements: POSIX sh and OpenSSL (on Windows, run it in Git Bash).
# Never commit the key, paste it into tickets or chats, or pass it on a command line.

set -eu

if ! command -v openssl >/dev/null 2>&1; then
    echo "error: openssl is required" >&2
    exit 1
fi

random=$(openssl rand 32 | openssl base64 -A | tr '+/' '-_' | tr -d '=')
key="pst_${random}"
hash=$(printf '%s' "$key" | openssl dgst -sha256 -r | cut -d ' ' -f 1)

echo "key   $key"
echo "hash  $hash"
