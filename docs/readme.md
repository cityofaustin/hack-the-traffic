# ATX Hack the Traffic Docs

#### How does the City of Austin use the Bluetooth travel sensor data?
The data enables transportation engineers to better understand short and long-term trends in Austin’s traffic patterns, supporting decisions about systems planning and traffic signal timing.

#### What information does the data contain?
The sensor data is available in three datasets:

[Individual Address Records](https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Individual-Addresses/qnpj-zrb9/data)

Each row in this dataset represents a Bluetooth device that was detected by one of our sensors. Each record contains a detected device’s anonymized Media Access Control (MAC) address along with the time and location the device was detected. These records alone are not traffic data but can be post-processed to measure the movement of detected devices through the roadway network

[Individual Traffic Matches]( https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Individual-Traffic-Matche/x44q-icha/data)

Each row in this dataset represents one Bluetooth enabled device that detected at two locations in the roadway network. Each record contains a detected device’s anonymized Media Access Control (MAC) address along with contain information about origin and destination points at which the device was detected, as well the time, date, and distance traveled.

[Traffic Summary Records](https://data.austintexas.gov/dataset/Bluetooth-Travel-Sensors-Match-Summary-Records/v7zg-5jg9)

The traffic summary records contain aggregate travel time and speed summaries based on the individual traffic match records. Each row in the dataset summarizes average travel time and speed along a sensor-equipped roadway segment in 15 minute intervals.

#### Does this data contain personally identifiable information?
No. The Media Access Control (MAC) addresses in these datasets are randomly generated.