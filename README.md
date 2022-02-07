# Table of Contents
- [Table of Contents](#table-of-contents)
- [Task description](#task-description)
  - [Requirements](#requirements)
  - [Desired Output](#desired-output)
- [Solution description](#solution-description)
  - [Files](#files)
- [Output](#output)


# Task description

For this project we decided to use the dataset:
https://console.cloud.google.com/marketplace/product/the-world-bank/wdi?pli=1

I was tasked with finding top 21 unique countries for years 1990-2010 which had the biggest energy consumption per capita indicator.

So, for each year, I had to find a country with the biggest indicator value **that did not appear in any of the previous years**.


## Requirements

1. The inspected indicator code is *indicator_code = EG.USE.PCAP.KG.OE*
2. The discussed year window is [1990, 2010]
3. We omit artificially created countries used as aggregates for real countries


## Desired Output

The desired output should contain exactly 21 lines. Each line must contain following data:
1. year
2. country name
3. country code
4. energy consumption per capita value in the given year


# Solution description

For the purposes of this task, we processed our data using **Apache Hive**, therefore our data was stored on a **remote Hadoop Server using JDBC**.

My solution includes many **HPL/SQL** scripts used to create database schemas and query them. I also use a **bash script launched via SSH** to iterate over each year.


## Files
- **table_creation.sql**: HPL/SQL script launched via Ambari Views to create a partitioned and filtered table

- **dynamic_query_script.sh**: Bash script used to run multiple queries and store their results
- **sort_data_for_each_year_query**: Creates a new table with countries sorted by indicator value for given year
- **find_max_for_given_year_query**: parameterized query that finds the next unique country for a given year
- **table_cleanup.hql**: Cleans the memory after operations are completed


# Output

The achieved end result looks as follows:

| Year | Country code | Country name         | Indicator value | 
| ---- | ------------ | -------------------- | --------------- | 
| 1990 | QAT          | Qatar                | 13697.338       | 
| 1991 | ARE          | United Arab Emirates | 12276.816       | 
| 1992 | BHR          | Bahrain              | 10844.755       | 
| 1993 | LUX          | Luxembourg           | 9266.942        | 
| 1994 | CUW          | Curacao              | 8992.359        | 
| 1995 | KWT          | Kuwait               | 9084.983        | 
| 1996 | ISL          | Iceland              | 8847.785        | 
| 1997 | CAN          | Canada               | 7965.5195       | 
| 1998 | USA          | United States        | 7803.6978       | 
| 1999 | TTO          | Trinidad and Tobago  | 7348.5103       | 
| 2000 | BRN          | Brunei Darussalam    | 7213.6655       | 
| 2001 | FIN          | Finland              | 6395.882        | 
| 2002 | SWE          | Sweden               | 5802.11         | 
| 2003 | SGP          | Singapore            | 6216.713        | 
| 2004 | NOR          | Norway               | 5770.9546       | 
| 2005 | BEL          | Belgium              | 5606.2188       | 
| 2006 | OMN          | Oman                 | 6032.004        | 
| 2007 | AUS          | Australia            | 5868.347        | 
| 2008 | SAU          | Saudi Arabia         | 5853.5356       | 
| 2009 | GIB          | Gibraltar            | 5655.5728       | 
| 2010 | NLD          | Netherlands          | 5020.9985       | 