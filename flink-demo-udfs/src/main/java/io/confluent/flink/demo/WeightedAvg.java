package io.confluent.flink.demo;

import org.apache.flink.table.functions.AggregateFunction;

public class WeightedAvg {
    public static class Accumulator {
        public long sum = 0;
        public int count = 0;
    }

    public static class Function extends AggregateFunction<Long, Accumulator> {
        @Override
        public Accumulator createAccumulator() {
            return new Accumulator();
        }

        @Override
        public Long getValue(Accumulator acc) {
            if (acc.count == 0) {
                return null;
            } else {
                return acc.sum / acc.count;
            }
        }

        public void accumulate(Accumulator acc, Long iValue, Integer iWeight) {
            acc.sum += iValue * iWeight;
            acc.count += iWeight;
        }

        public void retract(Accumulator acc, Long iValue, Integer iWeight) {
            acc.sum -= iValue * iWeight;
            acc.count -= iWeight;
        }

        public void merge(Accumulator acc, Iterable<Accumulator> it) {
            for (Accumulator a : it) {
                acc.count += a.count;
                acc.sum += a.sum;
            }
        }

        public void resetAccumulator(Accumulator acc) {
            acc.count = 0;
            acc.sum = 0L;
        }
    }
}