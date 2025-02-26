package io.confluent.flink.demo;

import org.apache.flink.table.functions.ScalarFunction;

public class HashFunction extends ScalarFunction {

    // take any data type and return INT
    public int eval(String o) {
        return o.hashCode();
    }

    // take any data type and return INT
    public int eval(Integer o) {
        return o.hashCode();
    }
}
