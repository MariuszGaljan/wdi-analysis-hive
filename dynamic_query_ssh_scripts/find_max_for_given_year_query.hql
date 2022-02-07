USE galjanmari;


SELECT country_code, country_name, indicator_value, record_year
    FROM Filtered_Sorted_Data
    WHERE record_year = ${checked_year} and country_code not in (${previous_countries})
    LIMIT 1;
