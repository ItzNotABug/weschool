import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

// Common theme / ui components
const kSerif = 'Serif';
const kWeSchoolThemeColor = Color(0xff58397C);
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  labelStyle: TextStyle(fontFamily: kSerif),
  hintStyle: TextStyle(fontFamily: kSerif),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);

// App Strings

const kAboutInfoTitle = "About";

const kAboutInfoMessage = "WeSchool App helps you check some common info. "
    "available on Elearn Portal without having to access the Portal by login again & again!"
    "\n\nOther Info:"
    "\nThe elearn portal does not have any specific API to show the data in the app, hence the same classical method of HTML parsing is widely used in the app."
    "\nWeSchool App is built with Flutter for cross platform (iOS/Android) support."
    "\n\nDocuments are shown Online with Microsoft & Google Doc. Viewer.";

const kAboutInfoFooter = "Portal by IT @ Welingkar\n"
    "App by DarShan Pandya";

const kLogoutTitle = 'Logout';

const kLogoutConfirmation = "Are you sure you want to Logout?"
    "\nYou can always Login back anytime.";

const kLogoutCancel = 'Cancel';

const kPasswordResetSuccessMessage = 'Password Successfully Changed!'
    '\n\nRedirecting you to Login Screen...';

// Elearn Portal Urls
const kPrimaryDomain = 'https://elearn.welingkar.org';
const kAuthorizeLoginUrl = '$kPrimaryDomain/authenticate.php';
const kPasswordResetUrl = '$kPrimaryDomain/ds_forgotpassword.php';
const kScheduleUrl = '$kPrimaryDomain/adc_new/ds_studtimetable.php';
const kAttendanceUrl = '$kPrimaryDomain/adc_new/ds_studattendance.php';
const kNoticesUrl = '$kPrimaryDomain/adc_new/ds_stud_notices.php';
const kAttendanceReviewUrl =
    'https://elearn.welingkar.org/adc_new/ds_stud_debarred.php';
const kCoursePlanUrl = '$kPrimaryDomain/adc_new/ds_tlp_create_student.php';

// Password Reset Url parts
const kPasswordResetInvalidUrlPart =
    'message=Username%20is%20not%20matched.%20Please%20enter%20correct%20Username...&success=1';
const kPasswordResetSuccessUrlPart =
    'message=Password%20changed%20successfully...&success=0';

// HTML View Styling
Style kBodyStyle15 = Style(fontFamily: kSerif, fontSize: FontSize(15));
Style kBodyStyle16 = Style(fontFamily: kSerif, fontSize: FontSize(16));
Style kCoursePlanBodyStyle = Style(
  fontFamily: kSerif,
  fontSize: FontSize(18),
  color: kWeSchoolThemeColor,
  fontWeight: FontWeight.bold,
  verticalAlign: VerticalAlign.SUPER,
);

// HTML CSS
const kHtmlHead = """
        <head>
          <meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport">
          <style>
            table{
              width:100%;
            }
            td {
              font-size: 14px;
              text-align: center;
              padding: 6px;
            }
            th {
              font-size: 14px;
              padding: 4px;
              color: white;
              background-color: #58397C;
            }
            tr:nth-child(even) {background-color: #f2f2f2;}
            body {
               font-family: serif;
               -webkit-touch-callout: none;
               -webkit-user-select: none;
               -khtml-user-select: none;
               -moz-user-select: none;
               -ms-user-select: none;
               user-select: none;
            }
          </style>
      </head>
""";
const kScheduleFooter = """
      <font color="red" size="2px">
        <b>Same Remark: 
        </font>
        <font size="2px">
        <br>1. Attendance is Compulsory.
        <br>2. Be ready before 10 minutes of the lecture.
        <br>3. The Session will be conducted on Webex Platform.
        <br>
        <br>
        <font color="red" size="2px"><b>Note:</b></font>
        <br>'Feedback' column has been removed as it breaks the Table format & looks ugly.
        <br>If you want to give feedback, head over to portal from your browser!
        </font>
        </b>
        <br>
        <br>
    """;
const kPasswordResetJS = """
                        document.getElementsByClassName("main-header")[0].remove();
                        document.getElementsByClassName("content-header")[0].remove();
                        document.getElementsByClassName("main-footer")[0].remove();
                        document.getElementsByClassName("box-header with-border")[0].remove();
                        document.getElementsByClassName("box box-primary")[0].removeAttribute("class");
                        document.getElementsByClassName("box-footer")[0].style.backgroundColor = "transparent";
                        document.getElementsByClassName("content-wrapper")[0].style.backgroundColor = "white";
                        """;
const kPasswordResetInvalidJS = """
                        document.body.getElementsByTagName('h3')[0].textContent = "Email Address not found";
                        document.getElementsByClassName("main-header")[0].remove();
                        document.getElementsByClassName("content-header")[0].remove();
                        document.getElementsByClassName("content-wrapper")[0].style.backgroundColor = "white";
                        """;
const kRemoveBodyJS = 'document.body.remove();';