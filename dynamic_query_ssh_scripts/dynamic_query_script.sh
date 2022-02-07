#! /bin/bash

# Script Global variables ==================================================

result=""
previous_country_codes="''"

# Functions ================================================================

# splits given country record from database
# and returns the country_code field value
get_country_code_from_record() {
    local country_record=$1
    echo $country_record | cut -d " " -f 1
}

# appends given record to the result variable
# and appends its country code to the previous_country_codes variable
add_record_to_results() {
    local country_record="$1"

    result="${result}${country_record}"
    if [ -n "$country_record" ]; then
        result="$result"$'\n'
    fi

    local country_code=$(get_country_code_from_record $country_record)
    previous_country_codes="'$country_code',$previous_country_codes"
}

# Script execution ===========================================================================

# creating a new table with sorted values for each year
hive -f sort_data_for_each_year_query.hql

# looping over year
for act_year in {1990..2010}; do
    echo $'\n\n\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    echo "Searching for the country in the year $act_year"

    # querying hive for the data of given year
    act_record=$(hive \
        --hivevar checked_year=$act_year \
        --hivevar previous_countries="$previous_country_codes" \
        -f find_max_for_given_year_query.hql)

    add_record_to_results "$act_record"

    echo "Found record: \"$act_record\""
    echo "Used countries:"
    echo "$previous_country_codes"$'\n\n'
done

echo $'\nPerforming cleanup'
# removing the sorted table
hive -f table_cleanup.hql

echo $'\n\n\n\n=================================================================='
echo "Finished searching for all countries."
echo "Used countries:"
echo "$previous_country_codes"$'\n\n'

echo "Final results:"
echo "$result"
