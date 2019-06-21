# Setting Up

1. Install [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) from
   the Mac App Store
2. Open XCode and select *Clone an existing project*
3. In the search bar, enter [the project URL](https://github.com/iShuttleTracker/iShuttleTracker)
4. Select where to clone to
5. Done!


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

## History
There is an additional `/history` endpoint that stores entries of all the
update batches received for the last 30 days. The iOS app currently doesn't
utilize historical data at all.


# Data Parsing

There are four classes that we use to represent data from endpoints: Vehicle,
Route, Stop, and Update, as well as Point for representing pairs of latitude
and longitude values. These four classes each have static init functions that
are used to fetch and initialize data from the corresponding endpoint. For
routes and stops, however, data is cached after being initialized and will not
be fetched again until the cached data is deleted. (TODO: check for new data)
```
Vehicle ---> initVehicles() ---------> deserializes the data from the endpoint
                 \                     and populates the vehicles dictionary
                  \                    with objects
                   \                        /
                    ---> fetchVehicles() ---
                   grabs the JSON data from the
                   /vehicles endpoint
```
```
Route ---> initRoutes() ---------------> deserializes the data from either
                 \                       the endpoint or cache and populates
              not cached                 the routes dictionary with objects
                    \                        /
                     ---> fetchVehicles() ---
                   grabs the JSON data from the
                   /routes endpoint and caches it
```
```
Stop ---> initStops() ----------> deserializes the data from either the
               \                  endpoint or the cache and populates the
           not cached             stops dictionary with objects
                 \                     /
                  ---> fetchStops() ---
                grabs the JSON data from the
                /stops ednpoint and caches it
```
```
Update ---> initUpdates(): ----------> deserializes the data from the endpoint,
                  \                    populates the updates list with objects,
                   \                   and propogates the updates to vehicles
                    \                       /
                     ---> fetchUpdates() ---
                    grabs the JSON data from
                    the /updates endpoint
```
The first three of these init fuctions (`initVehicles()`, `initRoutes()`, and
`initStops()`) are called by `initData()` in the ViewController, which is
called only when the view first loads. `initUpdates()` is called every 10
seconds on a timer.

Vehicles are stored in the global `vehicles` dictionary [id:vehicle], routes
are stored in the global `routes` dictionary [id:route], stops are stored in
the global `stops` dictionary [id:stop] as well as in their route, and updates
are stored in the global `updates` list as well as in their vehicle.


# View

Currently, all frontend code exists in the ViewController and a few supporting
classes such as:
- Shuttle: An annotation for shuttle markers displayed on the map. Stores most
  of the same data as vehicles.
- ShuttleArrow: overrides the default MapKit annotatation for markers, i.e. the
  red pin. Responsible for resizing, coloring, and rotating shuttle markers.
- RouteView: Routes to be displayed on the map, represented by a polyline.
- StopView: An annotation for stops to be displayed on the map. Contains the
  static function `initStopViews()`, called in ViewController's `initData()`
  when the view loads.
- CustomPolyline: Overrides the default MapKit polyline and allows it to be
  recolored.
- CustomTabBar: Overrides the default tab bar controller to change the default
  index.

As for the ViewController itself, the lifecycle is as such:
```
          viewDidLoad()               mapViewDidFinishLoadingMap(mapview)
             /    \                         /        |       \
            /      \                       /         |        \
           /        \                     /          |         \
          /          \             displayRoutes()   |    displayStops()
  initMapView()    initData()                        |
                     /    \                  displayVehicles()
                    /      \                          \
                   /        \                          \
                  /          \                          \
              initStops()     initRouteViews()       timer(10s)
              initRoutes()    initStopViews()            |
              initVehicles()                             |
              initUpdates()                           update()
                                                         |
                                                         |
                                                    initUpdates()
                                                         |
                                                    (new updates?)
                                                         |
                                                     newUpdates()
                                                         
```
The key points in this lifecycle are:
- The order that init functions are called from `initData()` are important, as
  routes depend on stops and updates depend on vehicles.
- `initUpdates()` is called every 10 seconds on a timer, and if the new batch
  of updates differs from the previous, each shuttle annotation on the map is
  updated.
