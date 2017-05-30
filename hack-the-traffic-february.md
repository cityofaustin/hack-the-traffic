# ATX Hack the Traffic

Thanks for visiting ATX Hack the Traffic!

Our next hack event will be taking place at [ATX Hack for Change](https://www.google.com/search?q=hack4change&ie=utf-8&oe=utf-8) from June 2-4. In the meantime, feel free to find us on Slack at [#HackTheTraffic](https://open-austin.slack.com/messages/hackthetraffic/) or drop us a line at [transportation.data@austintexas.gov](mailto:transportation.data@austintexas.gov).

## Sponsors

City of Austin Transportation Department and the UT Center for Transportation Research
[Galvanize Austin](http://www.galvanize.com/campuses/austin-2nd-street-district/)  
[data.world](http://data.world)  
[Open Austin](http://open-austin.org)  
[The Texas Advanced Computing Center (TACC)](http://tacc.utexas.edu)  
[Data Rodeo](http://datarodeo.org)  


## Schedule

11:45AM Grab a sandwhich  
12:00PM Opening Remarks and Breakout  
1:15PM Bashing Bluetooth Workshop (45 min)  
1:30PM Cookies and Robots Workshop #1 (2 hrs)  
2:15PM Map the Traffic Workshop (45 min)  
3:30PM Cookies and Robotos Workshop #2 (2 hrs)  
5:00PM Reconvene and Report Out  
6:00PM Data Lovers' Happy Hour at TBD

## Communicate with Your Fellow Hackers

Add yourself to [Open Austin's Slack Team](http://slack.open-austin.org) and join the [#HackTheTraffic](https://open-austin.slack.com/messages/hackthetraffic/) channel

## Data and Documentation
Data documentation and download links are available in the [docs folder](https://github.com/cityofaustin/hack-the-traffic/tree/master/docs)

## Project Ideas

#### SBC Traffic Sensor

Write a vehicle detection program to run on an SBC (single board computer) such as a Raspberry Pi, an Arduino, or an Edison. You can use Bluetooth, WiFi, or any other sensor technology that your SBC supports. The software should produce data that can be easily consumed for processing and analysis.


#### Bluetooth Data Aggregator

The Austin Transportation Department (ATD) currently has a network of Bluetooth sensors deployed which sends all of its data to a single Windows-only service application which logs and processes this information. Write an open-source, Unix-compatible alternative to this software which is compatible with the ATD Bluetooth sensors. Ideally this could be used in parallel with the vendor-supplied host software.


#### Data Processing

This hackathon is centered around a number of data files produced by a growing network of Bluetooth sensors which has been deployed by the Austin Transportation Department. Write a library in your favorite programming language to process these data files and derive useful information.


#### Mapping and Visualization

The traffic data in this hackathon is fundamentally geospatial in nature. Write a web-application to visualize the Austin transportation network in a way that incorporates the sensor data. Feel free to include other geospatial datasets to tell an interesting story. Also feel free to integrate other forms of data visualization such as charts or graphs.


#### Write Docs, Open Issues, Ask Questions

We need your help writing documentation about our data. What is the best way to organize information about our Bluetooth Data? What questions do you have about the data that the City can help you with? Are there data quality issues or holes? Open a new issue on our github page, or send us a pull request to add content.