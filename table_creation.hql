SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=3000;
SET hive.exec.max.dynamic.partitions.pernode=500;


-- setting db we're using and variables specified in the task
USE galjanmari;

SET hivevar:year_range_floor=1990;
SET hivevar:year_range_ceiling=2010;

SET hivevar:researched_indicator='EG.USE.PCAP.KG.OE';
SET hivevar:aggregate_countries=('MNA','CEB','EAR','EAS','TEA','EAP','EMU','ECS','ECA','EUU','FCS','HPC','HIC','IBD','IDX','IDA','LTE','LCN','LAC','TLA','LMY','LIC','LMC','MEA','TMN','MIC','NAC','INX','OED','OSS','PSS','PST','PRE','SST','ZAF','SAS','TSA','SSF','TSS','SSA','UMC','WLD');


-- reading the csv file
DROP TABLE IF EXISTS Temp_Energy_Consumption PURGE;

CREATE TEMPORARY EXTERNAL TABLE IF NOT EXISTS Temp_Energy_Consumption(
    record_year		  SMALLINT,
    country_name      STRING,
    country_code      STRING,
    indicator_name    STRING,
    indicator_code    STRING,
    indicator_value   FLOAT
    )
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/input/assignments/worldbank_wdi'
    TBLPROPERTIES ('skip.header.line.count'='1');


-- filtering and partitioning data from original file to use only the rows and columns we're interested in
DROP TABLE IF EXISTS Filtered_Data PURGE;

CREATE TABLE Filtered_Data (
    country_name STRING,
    country_code STRING,
    indicator_value FLOAT
    )
    PARTITIONED BY (record_year SMALLINT);


INSERT OVERWRITE TABLE Filtered_Data PARTITION(record_year)
    SELECT country_name, country_code, indicator_value, record_year
        FROM Temp_Energy_Consumption
        WHERE indicator_code = ${researched_indicator} 
            AND (record_year >= ${year_range_floor} AND record_year <= ${year_range_ceiling})
            AND country_code NOT IN ${aggregate_countries};


DESCRIBE FORMATTED Filtered_Data;
