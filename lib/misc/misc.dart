import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:requests/requests.dart';

class Misc {
  static Future<Document> getHtmlContent(String url) async {
    var response = await Requests.get(url);
    var html = parse(response.content());
    return html;
  }


  // for Schedule
  static String replaceScheduleFields(String html) {
    bool sameRemark = false;
    String cssified = html;
    cssified = cssified.replaceAll('<fieldset><legend><font color="maroon"><b>',
        '<table border="1" width="100%"><tbody><tr bgcolor="#58397C" height="35"> <td colspan="6" align="center" style="font-size: 18px; color: #ffffff; font-family: serif">');
    cssified = cssified.replaceAll(
        "</b></font></legend></fieldset>", '</td></tr></tbody></table> ');
    cssified = cssified.replaceAll(
        '<div class="box-body table-responsive no-padding">',
        '<div class="box-body">');
    cssified = cssified.replaceAll('</table></div>', '</table><br></div>');
    cssified = cssified.replaceAll(
        '<table class="table table-hover">', '<table border="1" width="100%">');

    cssified = cssified.replaceAll('<th>#</th>', '<th width="5%">#</th>');

    if (cssified.contains(
        'The Session will be conducted on Webex Platform. Attendance is Compulsory. Be ready before 10 minutes of the lecture'))
      sameRemark = true;

    cssified = cssified.replaceAll(
        'The Session will be conducted on Webex Platform. Attendance is Compulsory. Be ready before 10 minutes of the lecture',
        'Same<br>Remark');

    cssified = cssified.replaceAll(
        '<td colspan="6" align="center"><font color="blue"><b>Self Study</b></font></td>',
        '<td colspan="6" align="center" style="padding-top: 8px; padding-bottom: 8px;">'
            '<font color="#58397C" size="3px">'
            '<b>Self Study</b>'
            '</font>'
            '</td>');

    cssified = cssified.replaceAll(
        '<td colspan="6" align="center"><font color="blue"><b>No lecture scheduled</b></font></td>',
        '<td colspan="6" align="center" style="padding-top: 8px; padding-bottom: 8px;">'
            '<font color="#58397C" size="3px">'
            '<b>No lecture scheduled</b>'
            '</font>'
            '</td>');

    cssified = cssified.replaceAll('Subject Name', 'Subject');
    cssified = cssified.replaceAll('Faculty Name', 'Faculty');
    cssified = cssified.replaceAll('Room No', 'Room');

    if (sameRemark) cssified = cssified.replaceAll("""</body>
      </html>
    """, """
    $kScheduleFooter
    <br>
    </body>
    </html>""");

    return cssified;
  }

  // for Attendance
  static String replaceAttendanceFields(String html) {
    String cssified = html;

    cssified = cssified.replaceAll('<th>', '<th height="35">');
    cssified = cssified.replaceAll('Course', 'Name');
    cssified = cssified.replaceAll('Faculty Name', 'Faculty');
    cssified = cssified.replaceAll('Allocated Sessions', 'T.S');
    cssified = cssified.replaceAll('No of Lecture conducted', 'C');
    cssified = cssified.replaceAll('No of Lectures attended by me', 'A');
    cssified = cssified.replaceAll('Leave Type', 'Leave');
    return cssified;
  }
}
