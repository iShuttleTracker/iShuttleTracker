# iShuttleTracker

A native iOS port of the RPI Shuttle Tracker web app (shuttles.rpi.edu) that
aims to add functionality past what the web app is able to offer, such as
smooth shuttle movement and precise ETAs, notifications for nearby shuttles
and scheduled trips, dynamic schedule display, and a settings panel to toggle
views.

[Link to Documentation](https://github.com/iShuttleTracker/iShuttleTracker/tree/master/Documentation)

## Summer 2019 Goals
### Notifications
- [ ] Add interface to schedule trips through
- [ ] Switch nearby notification units from meters to minutes
- [ ] Look into keeping track of nearby shuttles and sending notifications when
  the app is in the background

### Shuttle Prediction
- [ ] Rework the algorithm to be more reliable, possibly using machine learning
- [ ] Use the algorithm to make ETA predictions for shuttles and display these
  over stops when a shuttle is selected
- [ ] Look into constantly updating position of shuttle markers on the map

### Schedule
- [ ] Finish the dynamic schedule display

### Settings Panel
- [ ] Finish the settings panel backend, making switches and buttons functional
- [ ] Display scheduled trips in the main settings panel and add a new panel to
  schedule trips through

### Tests
- [ ] Add unit tests to verify that the frontend and backend are working as
  intended

### Refactoring
- [ ] Refactor the entire project to use MVC pattern or alternative

### Deployment
- [ ] Get iShuttleTracker on the App Store

### Extras
- [ ] VR/AR
- [ ] Bus button

[Link to Progress Report](https://github.com/iShuttleTracker/iShuttleTracker/blob/master/progress.md)

## Spring 2019 Accomplishments
- [x] Rewrite frontend to be dynamic (i.e. infinite routes and vehicles)
- [x] Update shuttle markers with proper rotation
- [x] Arrow shuttle icons in direction of movement
- [x] Location/stop descriptions
- [x] Settings panel front-end
- [x] Improved and tested shuttle prediction algorithm
- [x] Finished backend for nearby notifications
- [x] Made significant progress on scheduled notifications backend
- [x] Switch from MapBox to MapKit
- [x] Look into Cocoapods or alternatives to manage packages better
- [x] Sideload onto an iOS device for testing
- [x] 100% useable as an alternative to the web app

## Fall 2018 Accomplishments
- [x] Fetch, parse, and cache all relevant data from the web app
- [x] Display baseline information on frontend
- [x] Toggle route views
- [x] Early attempt at shuttle prediction algorithm
- [x] Added a blank view for schedule display
- [x] Test various frameworks for map and schedule display

