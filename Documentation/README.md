#  Classes

Class structure for Route, Update, Vehicle, Point, and Stop are implemented the same as in
https://godoc.org/github.com/wtg/shuttletracker


# Data

To retrieve the data, we use a few main data endpoints, 
```
shuttles.rpi.edu/
                 vehicles
                 routes
                 updates
                 stops
```

The data is received as a Swift:Data object and we use JSONSerialization to conver Swift:Data to an NSArray object.

Each specific different endpoint has a different way of parsing the data, but the convention for the JSON initialization is using switch cases.

```
switch(param){
  case "id":
    this.id=param as! <Insert Variable Type>
  case "name":
    this.name=param as! <Insert Variable Type>
  ...
```

The reasoning for the ``` as! <Insert Variable Type>``` is because every object inside of the NSArray being parsed is of type ```Any```.

There is then fetchUpdates(), fetchVehicles(), fetchRoutes(), fetchStops() to retrieve the parsed elements.


# Frontend

On the frontend, we use Mapbox and their API for iOS. Currently all relevant information to the frontend is found in View.swift



