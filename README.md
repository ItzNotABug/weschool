# WeSchool

A Flutter version of Welingkar Institution's Elearn Portal app.\
This is a side project and is **NOT** a product from the Welingkar's IT Department.\
Currently tested on iOS, Android requires more tests.

### But Why?
Well, I was bored and the portal also isn't that great (well, in terms of usability).\
You gotta login again and again everytime you have to check something, say Lecture Schedule.\
So I built this.

The earlier versions were separately built for Android as well iOS.\
But then why handle 2 different codebase, so here we are.

### Data Retrieval & Authentication:
As the Portal does not have any known API on its end to retrieve data,
therefore the app uses the same old HTML Parsing techniques & displays the formatted data.\
This is done using a flutter plugin called **Requests** which saves **Sessions Cookies** when the user logs in
& the same cookies are then used for all the https requests in the app.
##### The flaw
The portal has a very vague **Password Reset** strategy.\
No cross checks are implemented, there is no Email Authentication done and therefore anyone,\
like **ANYONE** having your login email address can reset your password.\
So **DO NOT SHARE YOUR LOGIN EMAIL ADDRESS WITH ANYONE!**


### Features:
1. Schedule (with Offline support)
2. Attendance
3. Attendance Review
4. Course Plan
5. Notices


### TODO:
1. **Improve code quality**
2. **Add Case Study support**\
   Not added currently because there aren't any available on the portal & therefore I cannot parse the HTML.
3. **Background schedule & notices check**\
   This can be easily achieved on Android via **AlarmManager** or **WorkManager**
    but iOS has complete different strategy which does not guarantee background task execution.
    (The non flutter Android version hosted on https://weschool-mms.web.app already has this feature).
4. **Add support for Bangalore Campus.**\
   The current implementation has **Mumbai** campus hardcoded,
   coz I have no idea about the Bangalore campus.
     
