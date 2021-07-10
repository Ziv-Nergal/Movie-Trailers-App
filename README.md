# Movie-Trailers-App

> An app for displaying movies from the TMDB API

All data is fetched from https://api.themoviedb.org

## Screens

- Main Screen - shows a list of movies with an option to filter by Upcoming, Top Rated, Now Playing.
- Movie Details - shows details about the selected movie from the main screen. This screen also has a play button which 
  plays the movie trailer if fetched successfuly from the API.
- Favorite Movies - shows a list of movies that the user marked as favorites. Movies can be added to favorites
  from the movie details screen, by swiping a movie in the main screen to the right and also by long pressing a movie in the 
  main screen

## App Architecture

- **Coordinator Pattern**: for navigating between screens i used Coordinator pattern.

  First, I declared the Coordinator protocol which contains an array of child coordinators, a navigationController
  and a start method.
  
  Then, in my Main TabBar ViewController i instanciated a coordinator that takes a navigation controller for each 
  tab in my tab bar controller and called it's start method which sets the root view controller for each tab.
  
  Both coordinators derive from a MainCoordinator class which holds a method for navigating to the movie details screen.
  
  Lastly, I added both navigation controllers as the viewControllers for my main tab bar controller.
  
  This approach helps to move boilerplate code from ViewControllers and helps decouple ViewControllers from one to other.
  
- **MVVM**: I Used through the entire app the model-view-view model pattern. Each view controller has it's view model,
  responsible for all buisness logic related code like fetching data from server, parsing data, formatting and sorting
  data and so on. This helps seperate UI from buisness logic and maintain reusable, testable clean viewControllers and views.
  
- **Observer Pattern**: For observing changes in objects, i used the observer pattern.

  The Observer pattern starts with the Observer Protocol, It contains an identifier which helps distinguish between 
  concrete observers and it also contains an update method which is responsible of notifying all subscribers of an update
  to the observable value.
  
  The Observable Protocol contians an associatedtype T, a value of type T, a list of subsribers (Observers) and 
  methods for adding/removing/notfying subscribers with new values.
  
  Last part of this pattern is the generic class ObservableField with implemnents the Observable Protocol.
  It is a concrete implementation of the observable protocol and can be used with any Equatable type.
  
  In this app, is use this pattern to notify the Movies list vc when another batch of movies is being loaded and
  with that, showing/hiding the movie list spinner at the botom of the tableview
  
- **Networking Layer**: For all networking related handling, i created an Endpoint protocol.

  It declated a base url, a path, a URLRequest, a HTTPMethod type and an UrlComponents variable.

  Then i declared a TMDB protocol which conforms to Endpoint protocol and extended it to hold base logic 
  for all TMDB networking calls.

  The TMDBEndpoint extension has the api key, a concrete base url for TMDB API, 
  a default get type for the HTTP request and a concrete UrlRequest variable.

  After that, each concrete endPoint implementation for requesting data from TMDB conforms to TMDBEndpoint protocol and
  has to provide a concrete path and url for the request.
  
## Unimplemented Features

- **Localization**: Given more time, i would have used BartyCrouch library for localazing the app, this library, with the help
  of a couple of build pahses, makes localization super easy and intuitive with swift.
  It removes all boilerplate code related to localiztion into a seperate file and manages it automatically each time you build the project.

  Reference to thr article about it: https://jeehut.medium.com/localization-in-swift-like-a-pro-48164203afe2

## Third Party Libraries

- **Alamofire**: For handling HTTP networking.

- **SDWebImage**: For handling downloading, displaying and caching photos given an url i used SDWebImage. - https://github.com/SDWebImage/SDWebImage

- **Hero**: For managing the shared element transition when navigation from a movie cell to the movie details screen. - https://github.com/HeroTransitions/Hero
  
- **YouTubePlayer**: For playing movie trailers in a video player inside movie details screen. - https://github.com/gilesvangruisen/Swift-YouTube-Player
