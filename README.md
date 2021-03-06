##############################
System requirement

Implement an iOS native app using Swift 3 to demonstrate your skills, ability to write clean and maintainable code and attention to details.
Requirement:
- Use a UITableViewController to display weather information of Sydney, Melbourne and Brisbane.
- Each cell should display two pieces of info: Name of city on the left, temperature on the right.
- Get real time weather information using https://openweathermap.org/current - You can register and get your API key for free.
- A sample request to get weather info for one city:
http://api.openweathermap.org/data/2.5/weather?id=4163971&units=
metric&APPID=your_registered_API_key
- City ID of Sydney, Melbourne and Brisbane are: 4163971, 2147714, 2174003
- Use Storyboard.
- It is fine to use 3rd party libraries via CocoaPods or by other means.
Brownie Points:
- Use an activity indicator to provide some feedback to user while waiting for network response.
- Allow user to tap on a cell to open a new “detail screen”, to show more information about the city such as current weather summary, min and max temperature, humidity, etc.
- In the “detail screen”, implement animations to enhance the user experience.
Submission:
- Creaet a public project in GitHub or BitBucket and send the link back to us for review.
##############################

##############################
Issues need to fixed

- 1. use optional check in condition, don't use '=nil'
- 2. replace measurement 'uiscreen.main.bounds' with 'view.bounds'
- 3. create customized view

##############################


##############################
Development notes
- 1. create project and remote git repository (https://github.com/davidyedeewhy/weatherinaustralia.git). Push the project to git
- 2. sign up to OpenWeatherMap and get an api key
- 3. create unit test for web service consume
- 4. setup app transport security, add exception for domain (api.openweathermap.org)
- 5. add file group for MVC
- 6. create models for project
- 7. create controller 
- 8. consume web service with model
- 9. update and style table cell
##############################


##############################
About the project:
- 1. according to the requirement, the app should display some cities weather. One city ID is Melbourne in U.S, not in Australia. I have to request Google Map Service and setup timezone for city. otherwise, the sunrise and sunset time looks so funny.
- 2. OpenWeatherMap provides current weather service with max and min temperature at the moment, not daily. I try to consume the other forecast service, but the response is still weird. Finally, I just display current max and min temperature at the location
- 3. OpenWeatherMap also provides a group weather request service, but sometimes it's really slow. so I choose the webservice to request city weather one by one.
- 4. I add a segment control for user. so the user can switch the unit system between Metric and Imperial.
##############################



