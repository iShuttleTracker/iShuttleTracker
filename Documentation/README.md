# Endpoints

Data in the app is gathered from four main endpoints on the Shuttle Tracker
website:

```
shuttles.rpi.edu/vehicles
                /routes
                /stops
                /updates
```

Each endpoint stores JSON data, the entries of which are summarized below.

## Vehicles
```
{
  "id": 1,
  "name": "Bus 95",
  "created": "2018-09-14T16:18:01.427041Z",
  "updated": "2018-09-14T16:18:01.427041Z",
  "enabled": true,
  "tracker_id": "1831394663"
}
```
`id`: The id of the vehicle, from 1 to 11
`name`: The name of the vehicle (ex. `Bus 95` or `Van 87`)
`created`: The timestamp of when this vehicle entry was created
`updated`: The timestamp of when this entry was last updated
`enabled`: Seems to always be true
`tracker_id`: Unknown what this represents

## Routes
```
{
  "id": 1,
  "name": "West Campus",
  "description": "",
  "enabled": true,
  "color": "#0080FF",
  "width": 6,
  "stop_ids": [
   1,
   2,
   8,
   11,
   12,
   1
  ],
  "created": "2018-09-14T17:04:49.250185Z",
  "updated": "2019-02-23T16:50:54.637024Z",
  "points": [
   {
    "latitude": 42.730628,
    "longitude": -73.676352
   },
   ...
   ],
  "active": true,
  "schedule": []
 }
```
`id`: The id of the route (1 for West Campus, 2 for East Campus, 3 for
Weekend/Late Night, 4 for East Inclement Weather Route, 5 for West Inclement
Weather Route, 10 for Arch East Campus)
`name`: The name of the route
`description`: Appears to be always empty
`enabled`: Whether or not this route is currently enabled (ex. typically only
West Campus and East Campus are enabled)
`color`: The hex color of the route outline on the map
`width`: The width of the route outline on the map
`stop_ids`: A list of the ids of stops in this route
`created`: The timestamp of when this route entry was created
`updated`: The timestamp of when this entry was last updated
`points`: A list of points (a pair of `latitude` and `longitude` values) that
make up the route
`active`: Appears to always be true
`schedule`: Appears to always be empty

## Stops
```
{
  "id": 1,
  "latitude": 42.73029109316892,
  "longitude": -73.67655873298646,
  "created": "2018-09-14T18:06:36.80459Z",
  "updated": "2018-09-14T18:06:36.80459Z",
  "name": "Student Union",
  "description": "Shuttle stop in front of the Student Union"
}
```
`id`: The id of the stop, from 1 to 21
`latitude`: The latitude of the stop
`longitude`: The longitude of the stop
`created`: The timestamp of when this stop entry was created
`updated`: The timestamp of when this entry was last updated
`name`: The name of the stop
`description`: The description of where the stop is

## Updates
```
{
  "id": 1204867,
  "tracker_id": "1831394663",
  "latitude": 42.7392,
  "longitude": -73.684,
  "heading": 285,
  "speed": 0,
  "time": "2019-06-16T21:04:07Z",
  "created": "2019-06-16T21:04:09.783084Z",
  "vehicle_id": 1,
  "route_id": null
}
```
`id`: The id of the update
`tracker_id`: Unknown what this represents
`latitude`: The latitude of vehicle at this update
`longitude`: The longitude of the vehicle at this update
`heading`: The angle of the vehicle with north at this update
`speed`: The speed of the vehicle at this update, in km/h
`time`: The timestamp of when this update was sent
`created`: The timestamp of when this update was received
`vehicle_id`: The id of the vehicle this update is for
`route_id`: The id of the route the vehicle is on

