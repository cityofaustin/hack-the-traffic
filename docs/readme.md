# ATX Hack the Traffic Docs

### Contents

[Download Data](#dowload-data)

[Column Descriptions](#column-descriptions)

#### Download Data
The sensor data is available in three datasets:

[Individual Address Records](https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Individual-Addresses/qnpj-zrb9/data)

Each row in this dataset represents a Bluetooth device that was detected by one of our sensors. Each record contains a detected device’s anonymized Media Access Control (MAC) address along with the time and location the device was detected. These records alone are not traffic data but can be post-processed to measure the movement of detected devices through the roadway network

[Individual Traffic Matches]( https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Individual-Traffic-Matche/x44q-icha/data)

Each row in this dataset represents one Bluetooth enabled device that detected at two locations in the roadway network. Each record contains a detected device’s anonymized Media Access Control (MAC) address along with contain information about origin and destination points at which the device was detected, as well the time, date, and distance traveled.

[Traffic Summary Records](https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Match-Summary-Records/v7zg-5jg9)

The traffic summary records contain aggregate travel time and speed summaries based on the individual traffic match records. Each row in the dataset summarizes average travel time and speed along a sensor-equipped roadway segment in 15 minute intervals.

#### Column Descriptions

##### Individual Traffic Matches

record_id: The unique record identifer generated as an MD5 hash of the row contents

device_address: The unique address of the device that was read by the field software. For security, the source MAC address is discarded and replaced with a random address.

origin_reader_identifier: The unique identifier assigned to origin sensor that recorded a device address match.

destination_reader_identifier: The unique identifier assigned to destination sensor that recorded a device address match.

start_time: The time the device address was recorded at the origin sensor.

end_time: The time the device address was recorded at the destination sensor.

day_of_week: The name of the day of the week at the time the device address was recorded at the origin sensor. 

travel_time_seconds: The travel time in seconds from the origin to the destination sensor.

speed_miles_per_hour: The speed in miles per hour between the origin and the destination sensors.

match_validity: Indicates whether the sensor server classified the traffic data sample as being valid or invalid based on the filtering algorithm and minimum/maximum allowable speeds applied to the roadway segment. Values are valid or invalid.

filter_identifier: The numeric code of the filtering algorithm used in the outlier filter for the roadway segment. See the host documentation section titled “Algorithm Configuration” for more information.



