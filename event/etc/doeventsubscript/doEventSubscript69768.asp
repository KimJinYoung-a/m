<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description :  [2016 S/S 웨딩] Wedding Membership 쿠폰사용고객 응모이벤트 69768 MA
' History : 2016.03.24 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 
<%
dim eCode, userid, mode, vTotalCount, device, imgfile1, optname, myArea3
Dim vQuery

userid = GetEncLoginUserID
mode = requestcheckvar(request("mode"),32)
myArea3	= requestCheckVar(request("myArea3"),10)	''결혼예정일
imgfile1	= requestCheckVar(request("imgfile1"),255)	''청첨장 이미지
optname	= html2db(requestCheckVar(request("optname"),20))	'내이름,배우자이름

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66081
	Else
		eCode   =  69916
	End If

	if isapp then
		device="A"
	else
		device="M"
	end if

	''// 로그인 체크
	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44"""
		response.write "}"
		dbget.close()
		response.end
	End If

	''//이벤트 기간 체크
	If Now() > #04/28/2016 23:59:59# Then
		Response.Write "{ "
		response.write """resultcode"":""88"""
		response.write "}"
		dbget.close()
		response.end
	End If 
'---------------------------------------------------------------------------------------------------------
'//응모
If mode = "daily" Then 
	'// 이벤트 응모 내역
	vQuery = "SELECT count(*) FROM db_event.dbo.tbl_event_subscript WHERE userid = '" & userid & "' And evt_code='"&eCode&"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		vTotalCount = rsget(0)
	End If
	rsget.close()

	''//응모 했으면 종료
	If vTotalCount > 0 Then
		Response.Write "{ "
		response.write """resultcode"":""22"""
		response.write "}"
		dbget.close()
		response.end
	End If

	'//응모 안했으면 테이블에 내역을 남긴다.
	vQuery = "INSERT INTO db_event.dbo.tbl_event_subscript(evt_code, userid, sub_opt1, device) VALUES('" & eCode & "', '" & userid & "', 'Y', " & device & "')"
	dbget.Execute vQuery
	Response.Write "{ "
	response.write """resultcode"":""11"""
	response.write "}"
	dbget.close()
	response.End
elseif mode="addreg" then
	vQuery = "Insert into db_event.dbo.tbl_event_subscript " &_
			"(evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device) values " &_
			"('" & ecode & "'" &_
			",'" & userid & "'" &_
			",'" & optname & "'" &_
			",'" & myArea3 & "'" &_
			",'" & imgfile1 & "'" &_
			",'" & device & "')"
	dbget.Execute vQuery
else
	Response.Write "{ "
	response.write """resultcode"":""66"""	''잘못된 접속 입니다.
	response.write "}"
	dbget.close()
	response.end
end if
'---------------------------------------------------------------------------------------------------------
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->