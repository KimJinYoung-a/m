<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim evt_code , sqlStr , referer
	Dim fbuname , fbuphoto , fbsubopt1 , fbsubopt2 , uname , uphone
	evt_code = requestCheckVar(Request("eventid"),32)		'이벤트 가상 하드코딩
	fbuname	  = requestCheckVar(Request("fbuname"),32)		'fb uname
	fbuphoto = requestCheckVar(Request("fbuphoto"),100)		'fb 사용자 프로필 사진
	fbsubopt1 = requestCheckVar(Request("spoint"),1)		'fb 옵션1
	fbsubopt2 = requestCheckVar(Request("txtcomm"),200)		'fb 옵션2
	uname = requestCheckVar(Request("uname"),30)		'개인정보 이름
	uphone = requestCheckVar(Request("uphone"),13)		'개인정보 연락처

	referer = request.ServerVariables("HTTP_REFERER")

	sqlStr = "Insert into db_event.dbo.tbl_event_facebook " &_
			" (fbevtcode, fbuname, fbuphoto, fbsubopt1 , fbsubopt2 , uname , uphone) values " &_
			" (" & evt_code &_
			",'" & fbuname & "'" &_
			",'" & fbuphoto & "'" &_
			",'" & fbsubopt1 & "'" &_
			",'" & fbsubopt2 & "'" &_
			",'" & uname & "'" &_
			",'" & uphone & "')"
	dbget.execute(sqlStr)

	response.write "<script type='text/javascript'>alert('이벤트에 참여 하셨습니다.');</script>"
	response.write "<script>location.replace('" + Cstr(referer) + "');</script>"

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->