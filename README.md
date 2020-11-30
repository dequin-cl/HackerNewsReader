# HackerNewsReader
A demo app that consumes Hacker News information

This app was built using a TDD aproach to develop. Uses [Swift-Clean](https://clean-swift.com) as the base arquitecture for the code.

Extra information regarding the API can be found here: [https://hn.algolia.com/api](https://hn.algolia.com/api)

# iOS
The iOS target is 14.0

# Xcode
The app was builded with Xcode 12.2

# Infrastructure
It has 3 main folder:

* Scenes: contains the scenes that are used by the user
* Utils: a few object to help on the development
* Data: All the files related to the management of network and local data

# Scenes
1. Hits
	
	This is a UITableViewController, that uses two objects to fetch the data, one for the CoreData and one for the Network  
	The fetch of core data it's limited to 20 elements  
	The list have a refresh command and when you scroll to the bottom the business logic goes to the core data to fetch older objects.  
	
2. HitStory

   This is a WebView, recieves a URL and loads its content. Shows a progress bar and inform the user whether the URL is secure or not.
