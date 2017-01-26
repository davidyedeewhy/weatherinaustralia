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
