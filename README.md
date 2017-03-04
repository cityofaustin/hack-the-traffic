# ATX Hack the Traffic
Sat, March 4, 2017
12:00 PM – 6:00 PM CST
@ (Galvanize Austin](http://www.galvanize.com/campuses/austin-2nd-street-district/) - 118 Nueces Street, Austin, TX 78701
[Registration Page](https://www.eventbrite.com/e/atx-hack-the-traffic-registration-31722953207?)


## Schedule

 * 11:45AM Grab a sandwhich
 * 12:00PM Opening Remarks and Breakout
 * 1:15PM Bashing Bluetooth Workshop with Itamar Gal (45 min)
 * 1:30PM Cookies and Robots Workshop #1 (2 hrs)
 * 2:15PM Map the Traffic Workshop (45 min)
 * 3:30PM Cookies and Robotos Workshop #2 (2 hrs)
 * 5:00PM Reconvene and Report Out
 * 6:00PM Goodbye!

## Communicate with Your Fellow Hackers

1. Add yourself to [Open Austin's Slack Team](http://slack.open-austin.org)

2. Join the [#HackTheTraffic](https://open-austin.slack.com/messages/hackthetraffic/) channel

## Data Download and Documentation
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


#### O/D Data and Simulation

Traffic planning analysis frequently requires what is called an origin-destination (OD) matrix, which specifies the travel demands between the origin and destination nodes in the transportation network. Derive a dynamic OD matrix from the Bluetooth data in a format than can be input to a FOSS microsimulator.
