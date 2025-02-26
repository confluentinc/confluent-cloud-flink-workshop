package io.confluent.flink.examples.table;

import io.confluent.flink.plugin.ConfluentSettings;

import org.apache.flink.table.api.*;

import static org.apache.flink.table.api.Expressions.$;
import static org.apache.flink.table.api.Expressions.lit;

public class WindowedAggregation {

    public static void main(String[] args) throws Exception {

        // Use ConfluentSettings as the entrypoint for configuration
        ConfluentSettings.Builder settings = ConfluentSettings.newBuilderFromResource("/prod.properties");
        settings.setOption("sql.local-time-zone", "UTC");
        settings.setContextName("table-api-demo");

        TableEnvironment env = TableEnvironment.create(settings.build());

        env.useCatalog("prod");
        env.useDatabase("marketplace");

        env.from("clicks")
                .window(Tumble.over(lit(10).minutes()).on($("$rowtime")).as("w"))
                .groupBy($("w"))
                .select($("w").start(), $("w").end(), $("user_id").count())
                .execute()
                .print();
    }
}
