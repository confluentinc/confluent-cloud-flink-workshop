package io.confluent.flink.demo;

import org.apache.flink.table.functions.ScalarFunction;

public class ValidateProductName extends ScalarFunction {
    public static final String NAME = "VALIDATE_PRODUCT_NAME";

    public boolean eval(String text) {
        var words = text.split("\\W+");

        return words.length == 3;

    }
}