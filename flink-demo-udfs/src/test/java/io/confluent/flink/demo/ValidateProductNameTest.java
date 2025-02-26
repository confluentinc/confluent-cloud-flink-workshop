package io.confluent.flink.demo;

import static org.assertj.core.api.Assertions.*;

import org.junit.jupiter.api.Test;

class ValidateProductNameTest {

    @Test
    public void testValidProductName() {
        boolean isValid = new ValidateProductName().eval("Practical Iron Shirt");

        assertThat(isValid).isEqualTo(true);

    }

    @Test
    public void testInValidProductName() {
        boolean isValid = new ValidateProductName().eval("Quite Practical Iron Shirt");

        assertThat(isValid).isEqualTo(false);

    }
}