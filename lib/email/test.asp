<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<% Response.Addheader "P3P","policyref=""/w3c/p3p.xml"", CP=""CONi NOI DSP LAW NID PHY ONL OUR IND COM"""%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incNaverOpenDate.asp" -->
<!-- #INCLUDE Virtual="/lib/inc/incDaumOpenDate.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #INCLUDE Virtual="/lib/email/maillib2.asp" -->
<!-- #include virtual="/lib/util/base64_u.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<%
dim osms
dim iorderserial : iorderserial = "21102984567"
dim helpmail : helpmail = "tozzinet@10x10.co.kr"
dim testuserid : testuserid = "tozzinet"
dim reqhp : reqhp="010-9177-8708"
dim title : title="[텐바이텐]LMS제목 테스트임."
dim smstext : smstext="[텐바이텐]LMS내용 테스트임."
dim callback : callback="1644-6030"
if iorderserial = "" then iorderserial = "17121288279"

'call SendMailNewUser(helpmail,testuserid)
'call SendNormalLMS(reqhp, title, callback, smstext)
'set osms = new CSMSClass
'    osms.SendJumunOkMsg reqhp, iorderserial

%>

