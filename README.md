

# What next ?

<p float="left">
  
<img src="./assets/whatnext_logo.png" width="400" height="160"> 
   <a href='https://play.google.com/store/apps/details?id=app.zepplaud.whatnext'><img alt='Get it on Google Play' width="40%" src='https://play.google.com/intl/en_gb/badges/static/images/badges/en_badge_web_generic.png'/></a>
</p>

 

What next is a social platform to track your movie and tv shows consumption and socialize with your friends to see their watchlists.
 
 <br/>

 ---
 
 <br/>

## ** NOTICE ** 

Thank you to the people who downloaded this app from playstore and those who starred my repo. I started this project to be a way for me to learn more about firebase related stuff like firestore, fcm, dynamic links etc. I still see this project as such. 

But I am going to put development of this project on an indefinite hiatus as I don't really have time to maintain Whatnext? anymore. I am however planning to push one last maintenance commit to whatnext to make it compatible with flutter v3.7.5 which is the latest version as of Feb 2023 and update the playstore version with the same.

I will probably wait some time before archiving this project. That said I still think Whatnext? is still valid for someone getting started with flutter to use as a reference but as this project was made when I was starting out with flutter, there might me some things which are more of a hack than a solve so take it with a grain of salt.

If anyone is willing to maintain Whatnext? in the future contact me or open an issue stating the same and we can work out the details.

 <br/>

 ---
 
 <br/>

## Tech Stack:

- Flutter
- Dart
- Firebase

## Features:

This project is still in development stage. So, feature requests are welcome. Feel free to open an issue if you have something in mind or if something is not working right. it might make a large impact 💓

- [x] Make watch lists with watching status.
- [x] Movies and Tv Shows listing (popular ones are shown cuurrently)
- [x] Search for a movie or TV show.
- [x] Search, view and follow other users.
- [X] Themes 
- [ ] UI polishing to look decent.
- [ ] Send suggestions and messages to other users.
- [ ] Invite people to the app via other mediums.
- [x] Share a movie/Tv show to other apps.
- [ ] Add comments or thoughts to the watchlist items visible to user's friends or all.
- [x] Create a feed with the updates from people's watchlists.




## How to setup locally ?

1. Fork the repo.

2. Clone the repo using the forked repo.

3. Open the code in your favorite code editor.

4. Install the dependencies using the following command:

```
$ flutter pub get
```
5. Add your TMDB API keys in a file named 'api_keys.dart' and place it inside /lib/constants 
 
```
const String v3 = "XXXXXXXXX";
const String v4 = "XXXXXXXXX";

```

6. Setup up a project in firebase using structure specified (details will be provided soon) and link your app with firebase. (google-services.json) 

7. Build the app using the following command:

```
$ flutter run
```

## Interested in contributing ?

See the [contributor's guide!](contributing.md)


## Screenshots
 <img src="./Screenshots/home.png" width="250"> | <img src="./Screenshots/feed.png" width="250"> |  <img src="./Screenshots/feed2.png" width="250">


  <img src="./Screenshots/drawer.png" width="250"> | <img src="./Screenshots/watchlist.png" width="250"> |  <img src="./Screenshots/add.png" width="250">  


  <img src="./Screenshots/search.png" width="250"> | <img src="./Screenshots/profile.png" width="250"> |  <img src="./Screenshots/themes.png" width="250">  






## Questions or issues ?

If you have general question about the project. Feel free to open an issue regarding your query/issue.

### Learn Flutter ?

Follow this [link](https://flutter.dev/)
