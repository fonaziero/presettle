package io.github.fonaziero.presettle;

import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModules;

/**
 * Fails the build when a module reaches into another module's internals or modules form a cycle
 * (see ADR 0005).
 */
class ModularityTests {

    private final ApplicationModules modules = ApplicationModules.of(PresettleApplication.class);

    @Test
    void verifiesModuleBoundaries() {
        modules.verify();
    }
}
