<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 10초의 기적 모바일 페이지
' History : 2015.02.09 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
Dim eCode, userid, sqlstr, refer, procAccessUser, vQuery, vTotalCount, EventTotalChk, mode
	userid = getloginuserid()
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)


	IF application("Svr_Info") = "Dev" Then
		eCode = "21466"
	Else
		eCode = "59261"
	End If


	'//앱실행 메인배너 클릭 카운트
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES("& eCode &", '"& mode &"')" + vbcrlf
	dbget.execute sqlstr

	Response.write "OK"
	dbget.close()	:	response.end




%>
<!-- #include virtual="/lib/db/dbclose.asp" -->