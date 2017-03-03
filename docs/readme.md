# ATX Hack the Traffic Docs

- [Download Data](#dowload-data)

- [Column Descriptions](#column-descriptions)

- [Data Portal (Socrata) Query Examples](#query-examples)

## Download Data
The sensor data is available in three datasets:

[Individual Address Records](https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Individual-Addresses/qnpj-zrb9/data)

Each row in this dataset represents a Bluetooth device that was detected by one of our sensors. Each record contains a detected device’s anonymized Media Access Control (MAC) address along with the time and location the device was detected. These records alone are not traffic data but can be post-processed to measure the movement of detected devices through the roadway network

[Individual Traffic Matches]( https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Individual-Traffic-Matche/x44q-icha/data)

Each row in this dataset represents one Bluetooth enabled device that detected at two locations in the roadway network. Each record contains a detected device’s anonymized Media Access Control (MAC) address along with contain information about origin and destination points at which the device was detected, as well the time, date, and distance traveled.

[Traffic Summary Records](https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Match-Summary-Records/v7zg-5jg9)

The traffic summary records contain aggregate travel time and speed summaries based on the individual traffic match records. Each row in the dataset summarizes average travel time and speed along a sensor-equipped roadway segment in 15 minute intervals.

## Column Descriptions

### Individual Traffic Matches

**record_id**: The unique record identifer generated as an MD5 hash of the row contents

**device_address**: The unique address of the device that was read by the field software. For security, the source MAC address is discarded and replaced with a random address.

**origin_reader_identifier**: The unique identifier assigned to origin sensor that recorded a device address match.

**destination_reader_identifier**: The unique identifier assigned to destination sensor that recorded a device address match.

**start_time**: The time the device address was recorded at the origin sensor.

**end_time**: The time the device address was recorded at the destination sensor.

**day_of_week**: The name of the day of the week at the time the device address was recorded at the origin sensor. 

**travel_time_seconds**: The travel time in seconds from the origin to the destination sensor.

**speed_miles_per_hour**: The speed in miles per hour between the origin and the destination sensors.

**match_validity**: Indicates whether the sensor server classified the traffic data sample as being valid or invalid based on the filtering algorithm and minimum/maximum allowable speeds applied to the roadway segment. Values are valid or invalid.

**filter_identifier**: The numeric code of the filtering algorithm used in the outlier filter for the roadway segment. See the host documentation section titled “Algorithm Configuration” for more information.



## Query Examples
A few sample queries to get you started with Austin's Bluetooth data. These queries use the Socrata Open Data API (SODA) to fetch data from the City of Austin's [data portal](http://data.austinetxas.gov).

1. Return top 10 most recent rows from weekdays 
    ```sql
    https://data.austintexas.gov/resource/922j-6afw.json?
    $query=SELECT * WHERE UPPER(day_of_week) NOT IN('SATURDAY', 'SUNDAY') ORDER BY start_time DESC LIMIT 10
    ```
    
2. Return the maximum 'valid' speed for each origin reader
    ```sql
    https://data.austintexas.gov/resource/922j-6afw.json?
    $query=SELECT origin_reader_identifier, MAX(speed_miles_per_hour) WHERE match_validity='valid' GROUP BY origin_reader_identifier
    ```

3. Count all unique segments by concatenating orgin and destination reader names
    ```sql
    https://data.austintexas.gov/resource/922j-6afw.json?
    $query=SELECT origin_reader_identifier || "$" || destination_reader_identifier as segment_name, COUNT(segment_name) as count GROUP BY segment_name
    ```

4. Return all rows with start_time at 4:30PM
    ```sql
    https://data.austintexas.gov/resource/922j-6afw.json?
    $query=SELECT origin_reader_identifier, start_time WHERE start_time LIKE('%25T16:30%25')
    ```

5. Compute average speed for all northbound segments where start time is between 4PM and 7PM
    ```sql
    https://data.austintexas.gov/resource/922j-6afw.json?
    $query=SELECT origin_reader_identifier || "$" || destination_reader_identifier as segment_name, start_time, day_of_week, speed_miles_per_hour WHERE match_validity='valid' AND segment_name in ("tx71_silvermine$us290_tx71","us290_tx71$us290_wm_cannon","us290_wm_cannon$lamar_panther","lamar_panther$Lamar_and_Manchca_Barton_skyway","Lamar_and_Manchca_Barton_skyway$Lamar_Blue_Bonnet","Lamar_Blue_Bonnet$lamar_oltorf","lamar_oltorf$lamar_lamar_square","lamar_lamar_square$lamar_barton_springs","lamar_barton_springs$lamar_riverside","lamar_riverside$lamar_5th","lamar_5th$lamar_6th","lamar_6th$lamar_12th","lamar_12th$lamar_mlk","lamar_mlk$lamar_24th","lamar_24th$lamar_29th","lamar_29th$lamar_38th","lamar_38th$lamar_45th","lamar_45th$lamar_51st","lamar_51st$lamar_koenig","lamar_koenig$lamar_airport","lamar_airport$lamar_morrow","lamar_morrow$lamar_payton_gin","lamar_payton_gin$lamar_rundberg","lamar_rundberg$lamar_braker","lamar_braker$lamar_parmer","congress_slaughter$congress_wm_cannon","congress_wm_cannon$congress_stassney","congress_stassney$congress_benwhite","congress_benwhite$congress_oltorf","congress_oltorf$congress_elizabeth","congress_elizabeth$riverside_congress","riverside_congress$congress_cesar_chavez","congress_cesar_chavez$congress_5th","congress_5th$congress_6th","congress_6th$congress_11th","guadalupe_15th$mlk_guadalupe","mlk_guadalupe$guadalupe_21st","guadalupe_21st$guadalupe_24th","guadalupe_24th$guadalupe_26th","guadalupe_26th$guadalupe_27th","south_1st_slaughter$south_1st_wm_cannon","south_1st_wm_cannon$south_1st_stassney","south_1st_stassney$south_1st_st_elmo","south_1st_st_elmo$south_1st_benwhite","south_1st_benwhite$south_1st_oltorf","south_1st_oltorf$south_1st_barton_spring","south_1st_barton_spring$cesar_chavez_lavaca","cesar_chavez_lavaca$lavaca_5th","lavaca_5th$lavaca_6th")
    |> SELECT start_time, day_of_week, speed_miles_per_hour, segment_name where UPPER(day_of_week) NOT IN('SATURDAY', 'SUNDAY')
    |> SELECT start_time, day_of_week, speed_miles_per_hour, segment_name WHERE start_time LIKE('%25T16:%25')  OR start_time LIKE('%25T17:%25') OR start_time LIKE('%25T18:%25') 
    |> SELECT segment_name, AVG(speed_miles_per_hour), COUNT(*) GROUP BY segment_name
    ```

6. Compute percentage of valid matches for all sensors with matches
    ```sql
    https://data.austintexas.gov/resource/922j-6afw.json?
    $query=SELECT origin_reader_identifier, CASE(match_validity='valid', 1, true, 0) AS valid
    |> SELECT origin_reader_identifier, COUNT(origin_reader_identifier) AS total, SUM(valid) AS total_valid GROUP BY origin_reader_identifier
    |> SELECT origin_reader_identifier, total_valid/total AS pct_valid ORDER BY pct_valid ASC
    ```

## Routes
You can plug these route objects into [queries](#query-examples) to find traffic matches along specific routes. The `segment_name` field in the example query outputs is a concatenation of the origin and rdestination reader IDs, and can be used to join data to the `segment_name` field in the [route geoJSON](http://github.com/cityofaustin/hack-the-traffic/mapping_workshop/data/austin_bt_routes.csv) file.

#### Guadalupe Northbound
```
("guadalupe_15th$mlk_guadalupe","mlk_guadalupe$guadalupe_21st","guadalupe_21st$guadalupe_24th","guadalupe_24th$guadalupe_26th","guadalupe_26th$guadalupe_27th")
```

#### Guadalupe Southbound
```
("guadalupe_27th$guadalupe_26th","guadalupe_26th$guadalupe_24th","guadalupe_24th$guadalupe_21st","guadalupe_21st$mlk_guadalupe","mlk_guadalupe$guadalupe_15th")
```

#### Congress Northbound
```
("congress_slaughter$congress_wm_cannon","congress_wm_cannon$congress_stassney","congress_stassney$congress_benwhite","congress_benwhite$congress_oltorf","congress_oltorf$congress_elizabeth","congress_elizabeth$riverside_congress","riverside_congress$congress_cesar_chavez","congress_cesar_chavez$congress_5th","congress_5th$congress_6th","congress_6th$congress_11th")
```

#### Congress Southbound
```
("congress_11th$congress_6th","congress_6th$congress_5th","congress_5th$congress_cesar_chavez","congress_cesar_chavez$riverside_congress","riverside_congress$congress_elizabeth","congress_elizabeth$congress_oltorf","congress_oltorf$congress_benwhite","congress_benwhite$congress_stassney","congress_stassney$congress_wm_cannon","congress_wm_cannon$congress_slaughter")
```

#### Lamar Northbound
```
("tx71_silvermine$us290_tx71","us290_tx71$us290_wm_cannon","us290_wm_cannon$lamar_panther","lamar_panther$Lamar_and_Manchca_Barton_skyway","Lamar_and_Manchca_Barton_skyway$Lamar_Blue_Bonnet","Lamar_Blue_Bonnet$lamar_oltorf","lamar_oltorf$lamar_lamar_square","lamar_lamar_square$lamar_barton_springs","lamar_barton_springs$lamar_riverside","lamar_riverside$lamar_5th","lamar_5th$lamar_6th","lamar_6th$lamar_12th","lamar_12th$lamar_mlk","lamar_mlk$lamar_24th","lamar_24th$lamar_29th","lamar_29th$lamar_38th","lamar_38th$lamar_45th","lamar_45th$lamar_51st","lamar_51st$lamar_koenig","lamar_koenig$lamar_airport","lamar_airport$lamar_morrow","lamar_morrow$lamar_payton_gin","lamar_payton_gin$lamar_rundberg","lamar_rundberg$lamar_braker","lamar_braker$lamar_parmer")
```

#### Lamar Southbound
```
("lamar_parmer$lamar_braker","lamar_braker$lamar_rundberg","lamar_rundberg$lamar_payton_gin","lamar_payton_gin$lamar_morrow","lamar_morrow$lamar_airport","lamar_airport$lamar_koenig","lamar_koenig$lamar_51st","lamar_51st$lamar_45th","lamar_45th$lamar_38th","lamar_38th$lamar_29th","lamar_29th$lamar_24th","lamar_24th$lamar_mlk","lamar_mlk$lamar_12th","lamar_12th$lamar_6th","lamar_6th$lamar_5th","lamar_5th$lamar_riverside","lamar_riverside$lamar_barton_springs","lamar_barton_springs$lamar_lamar_square","lamar_lamar_square$lamar_oltorf","lamar_oltorf$Lamar_Blue_Bonnet","Lamar_Blue_Bonnet$Lamar_and_Manchca_Barton_skyway","Lamar_and_Manchca_Barton_skyway$lamar_panther","lamar_panther$us290_wm_cannon","us290_wm_cannon$us290_tx71","us290_tx71$tx71_silvermine")
```

#### South 1st Northbound
```
("south_1st_slaughter$south_1st_wm_cannon","south_1st_wm_cannon$south_1st_stassney","south_1st_stassney$south_1st_st_elmo","south_1st_st_elmo$south_1st_benwhite","south_1st_benwhite$south_1st_oltorf","south_1st_oltorf$south_1st_barton_spring","south_1st_barton_spring$cesar_chavez_lavaca","cesar_chavez_lavaca$lavaca_5th","lavaca_5th$lavaca_6th")
```

#### South 1st Southbound
```
("lavaca_6th$lavaca_5th","lavaca_5th$cesar_chavez_lavaca","cesar_chavez_lavaca$south_1st_barton_spring","south_1st_barton_spring$south_1st_oltorf","south_1st_oltorf$south_1st_benwhite","south_1st_benwhite$south_1st_st_elmo","south_1st_st_elmo$south_1st_stassney","south_1st_stassney$south_1st_wm_cannon","south_1st_wm_cannon$south_1st_slaughter")
```

#### All Northbound Routes
```
("tx71_silvermine$us290_tx71","us290_tx71$us290_wm_cannon","us290_wm_cannon$lamar_panther","lamar_panther$Lamar_and_Manchca_Barton_skyway","Lamar_and_Manchca_Barton_skyway$Lamar_Blue_Bonnet","Lamar_Blue_Bonnet$lamar_oltorf","lamar_oltorf$lamar_lamar_square","lamar_lamar_square$lamar_barton_springs","lamar_barton_springs$lamar_riverside","lamar_riverside$lamar_5th","lamar_5th$lamar_6th","lamar_6th$lamar_12th","lamar_12th$lamar_mlk","lamar_mlk$lamar_24th","lamar_24th$lamar_29th","lamar_29th$lamar_38th","lamar_38th$lamar_45th","lamar_45th$lamar_51st","lamar_51st$lamar_koenig","lamar_koenig$lamar_airport","lamar_airport$lamar_morrow","lamar_morrow$lamar_payton_gin","lamar_payton_gin$lamar_rundberg","lamar_rundberg$lamar_braker","lamar_braker$lamar_parmer","congress_slaughter$congress_wm_cannon","congress_wm_cannon$congress_stassney","congress_stassney$congress_benwhite","congress_benwhite$congress_oltorf","congress_oltorf$congress_elizabeth","congress_elizabeth$riverside_congress","riverside_congress$congress_cesar_chavez","congress_cesar_chavez$congress_5th","congress_5th$congress_6th","congress_6th$congress_11th","guadalupe_15th$mlk_guadalupe","mlk_guadalupe$guadalupe_21st","guadalupe_21st$guadalupe_24th","guadalupe_24th$guadalupe_26th","guadalupe_26th$guadalupe_27th","south_1st_slaughter$south_1st_wm_cannon","south_1st_wm_cannon$south_1st_stassney","south_1st_stassney$south_1st_st_elmo","south_1st_st_elmo$south_1st_benwhite","south_1st_benwhite$south_1st_oltorf","south_1st_oltorf$south_1st_barton_spring","south_1st_barton_spring$cesar_chavez_lavaca","cesar_chavez_lavaca$lavaca_5th","lavaca_5th$lavaca_6th")
```

#### All Southbound Routes
```
("guadalupe_27th$guadalupe_26th","guadalupe_26th$guadalupe_24th","guadalupe_24th$guadalupe_21st","guadalupe_21st$mlk_guadalupe","mlk_guadalupe$guadalupe_15th","congress_11th$congress_6th","congress_6th$congress_5th","congress_5th$congress_cesar_chavez","congress_cesar_chavez$riverside_congress","riverside_congress$congress_elizabeth","congress_elizabeth$congress_oltorf","congress_oltorf$congress_benwhite","congress_benwhite$congress_stassney","congress_stassney$congress_wm_cannon","congress_wm_cannon$congress_slaughter","lamar_parmer$lamar_braker","lamar_braker$lamar_rundberg","lamar_rundberg$lamar_payton_gin","lamar_payton_gin$lamar_morrow","lamar_morrow$lamar_airport","lamar_airport$lamar_koenig","lamar_koenig$lamar_51st","lamar_51st$lamar_45th","lamar_45th$lamar_38th","lamar_38th$lamar_29th","lamar_29th$lamar_24th","lamar_24th$lamar_mlk","lamar_mlk$lamar_12th","lamar_12th$lamar_6th","lamar_6th$lamar_5th","lamar_5th$lamar_riverside","lamar_riverside$lamar_barton_springs","lamar_barton_springs$lamar_lamar_square","lamar_lamar_square$lamar_oltorf","lamar_oltorf$Lamar_Blue_Bonnet","Lamar_Blue_Bonnet$Lamar_and_Manchca_Barton_skyway","Lamar_and_Manchca_Barton_skyway$lamar_panther","lamar_panther$us290_wm_cannon","us290_wm_cannon$us290_tx71","us290_tx71$tx71_silvermine","lavaca_6th$lavaca_5th","lavaca_5th$cesar_chavez_lavaca","cesar_chavez_lavaca$south_1st_barton_spring","south_1st_barton_spring$south_1st_oltorf","south_1st_oltorf$south_1st_benwhite","south_1st_benwhite$south_1st_st_elmo","south_1st_st_elmo$south_1st_stassney","south_1st_stassney$south_1st_wm_cannon","south_1st_wm_cannon$south_1st_slaughter")
```