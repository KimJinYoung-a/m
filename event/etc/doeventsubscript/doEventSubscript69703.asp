<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : [오프라인 이벤트] 할인 나우 
' History : 2016-03-15 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 
<%
dim vQuery, eCode, userid, mode, vTotalCount , myCount

	userid = GetEncLoginUserID
	mode = requestcheckvar(request("mode"),255)

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66065
	Else
		eCode   =  69703
	End If

	''// 로그인 체크
	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

	''//이벤트 기간 체크
	If date() >"2016-12-31" Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If

'---------------------------------------------------------------------------------------------------------
If mode = "getoffcoupon" Then

	'//쿠폰발급(응모)내역체크
	vQuery = "SELECT count(*) FROM db_event.dbo.tbl_event_subscript WHERE userid = '" & userid & "' And evt_code='"&eCode&"' And sub_opt1='1' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	''//이미 발급(응모)됨
	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""22"""		'' 이미 발급 되었습니다.
		response.write "}"
		dbget.close()
		response.end
	End If

	'//오늘 사용 안했으면 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO db_event.dbo.tbl_event_subscript(evt_code, userid, sub_opt1) VALUES('" & eCode & "', '" & userid & "', '1')"
	dbget.Execute vQuery
	Response.Write "{ "
	response.write """resultcode"":""11"""
	response.write "}"
	dbget.close()
	response.End
elseif mode = "useoffcoupon" Then
	'//쿠폰발급(응모)내역체크
	vQuery = "SELECT count(*) FROM db_event.dbo.tbl_event_subscript WHERE userid = '" & userid & "' And evt_code='"&eCode&"' And sub_opt2='1' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	''//이미 사용됨
	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""33"""		'' 이미 쿠폰을 사용 하셨습니다.
		response.write "}"
		dbget.close()
		response.end
	End If

	'//오늘 사용 안했으면 사용처리
	vQuery = "update db_event.dbo.tbl_event_subscript set sub_opt2='1' where evt_code='" & eCode & "' and userid= '" & userid & "' "
	dbget.Execute vQuery
	Response.Write "{ "
	response.write """resultcode"":""77"""	''직원에게 보여주고 할인받으세요
	response.write "}"
	dbget.close()
	response.End
else
	Response.Write "{ "
	response.write """resultcode"":""66""" 	''잘못된 접속 입니다.
	response.write "}"
	dbget.close()
	response.end
End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->