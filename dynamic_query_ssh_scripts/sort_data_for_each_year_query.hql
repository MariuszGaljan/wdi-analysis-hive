SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=3000;
SET hive.exec.max.dynamic.partitions.pernode=500;

USE galjanmari;


DROP TABLE IF EXISTS Filtered_Sorted_Data PURGE;

-- creates a non-temporary (so it persists between hive query executions) table
CREATE TABLE Filtered_Sorted_Data (
    country_name STRING,
    country_code STRING,
    indicator_value FLOAT,
    row_in_year INT
    )
    PARTITIONED BY (record_year SMALLINT);


INSERT OVERWRITE TABLE Filtered_Sorted_Data PARTITION(record_year)
    SELECT country_name, country_code, indicator_value,
            ROW_NUMBER() OVER (PARTITION BY record_year ORDER BY indicator_value DESC) as row_in_year,
            record_year
        FROM Filtered_Data;


SELECT * FROM Filtered_Sorted_Data;
