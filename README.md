# Wasteagram

### Description
The context given for this application by our instructor was: "A restaurant owner wants to be able to track the number of wasted items the restaurant has to throw away at the end of each night and he wants an mobile application in order to achieve that." From that, Wasteagram is a mobile application that is sets out to achieve that goal. When one first starts up the app, they are presented with a timeline that shows an ordered list of posts from most recently posted at the top to the oldest at the bottom. Each post in the time line displays a thumbnail of the photo taken of the waste, the date it was posted and the number of wasted items. One can press on an inidiviual post where it will get its own page and display all that same information, but with a bigger picture and the location the the person took the picture from in latitude and longitude. All data for each post is stored in a Google Firestore database as well as Google Firestore storage for each image. This requires some api and MySql work to store and retrieve data. The application will need the user's permission to get access to their camera for pictures and to get access to their location. 
