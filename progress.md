# Summer 2019 Progress

### Notifications
- [x] Add interface to schedule trips through
  - A new panel has been added to the storyboard, accessed through the settings
    panel, where trips can be scheduled by selecting a starting point,
    destination, and arrival time for a certain route
- [ ] Switch nearby notification units from meters to minutes
- [ ] Look into keeping track of nearby shuttles and sending notifications when
  the app is in the background

### Shuttle Prediction
- [ ] Rework the algorithm to be more reliable, possibly using machine learning
- [x] Use the algorithm to make ETA predictions for shuttles and display these
  over stops when a shuttle is selected
  - Rather than using the shuttle prediction algorithm, it was determined to be
    more optimal to use a separate algorithm that predicts how many seconds it
    will take a shuttle to reach a certain latitude and longitude if they
    continue moving at their last recorded velocity. This algorithm will need
    to be improved in the future to account for corner cases such as a velocity
    of 0, unsustainably high recorded velocities, etc.
- [ ] Look into constantly updating position of shuttle markers on the map

### Schedule
- [ ] Finish the dynamic schedule display
  - The heatmap schedule that was worked on in spring 2019 was abandoned in
    favor of a schedule view that's more easily readable at a glance. Currently
    in progress.

### Settings Panel
- [ ] Finish the settings panel backend, making switches and buttons functional
- [ ] Display scheduled trips in the main settings panel and add a new panel to
  schedule trips through
  - In progress

### Tests
- [ ] Add unit tests to verify that the frontend and backend are working as
  intended

### Documentation
- [x] Rewrite the project's sparse documentation with enough information to let
  new contributors get a sense of how things work
  - The very minimalistic documentation was replaced with information on:
    - Setting up the project
    - Data endpoints
    - Data parsing
    - The view (class structure and lifecycle)
  - Notifications (function and lifecycle)

### Refactoring
- [x] Refactor the entire project to use MVC pattern or alternative
  - After beginning to refactor the project to MVC, it was determined that an
    unnecessary amount of abstraction would be needed and it wouldn't make
    sense to refactor the entire project to MVC. Instead, code was logically
    reorganized (i.e. removing all data manipulation code from the view
    controller, making some classes singletons vs. static classes, renaming
    classes and functions, etc.) without using a single architectural pattern.

### Deployment
- [ ] Get iShuttleTracker on the App Store

### Extras
- [ ] VR/AR
- [ ] Bus button

