<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 마니또 장바구니 이벤트
' History : 2021-03-17 정태훈
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	dim currenttime, refer, amountLimit
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, cartTotalAmount
	dim oJson
	'object 초기화
	Set oJson = jsObject()

	IF application("Svr_Info") = "Dev" THEN
        eCode = "104328"
    Else
        eCode = "110079"
    End If

	mode = request("mode")

	currenttime 	= date()
	LoginUserid		= getencLoginUserid()
	refer 			= request.ServerVariables("HTTP_REFERER")
	cartTotalAmount = 0
	amountLimit = 300000
    if isapp then 
        device = "A"
    else
        device = "M"
    end if 
	
	if LoginUserid <> "" then cartTotalAmount = getCartTotalAmount(LoginUserid)

	if date() < Cdate("2021-03-29") then
		amountLimit = 300000
	end if

	if application("Svr_Info") <> "Dev" then 
		If InStr(refer, "10x10.co.kr") < 1 or eCode = "" Then
			oJson("response") = "err"
			oJson("message") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	end if

	if mode = "add" Then

		if Not(IsUserLoginOK) Then
			oJson("response") = "err"
			oJson("message") = "로그인을 해주세요."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		end if

		if cartTotalAmount < amountLimit Then
			oJson("response") = "err"
			oJson("message") = "장바구니에 상품 300,000원 이상 담은 후 이벤트 참여가 가능합니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End	
		end if

		sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt1 = '1' "
		rsget.Open sqlstr, dbget, 1
			cnt = rsget("cnt")
		rsget.close

		If cnt < 1 Then
			sqlStr = ""
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1)" & vbCrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '1')"
			dbget.execute sqlstr

			oJson("response") = "ok"
			oJson("message") = ""
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		Else				
			oJson("response") = "err"
			oJson("message") = "이미 신청하셨습니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	elseif mode = "pushadd" then

		dim vQuery, pushDate
		''푸시 신청
		if Not(IsUserLoginOK) Then
			oJson("response") = "err"
			oJson("faildesc") = "로그인 후 알림 신청이 가능합니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		end if

		pushDate = cdate("2021-03-31")

		'// 다음날 푸쉬 신청을 했는지 확인한다.
		vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_pickUpEvent_Push7] WITH (NOLOCK) WHERE userid='"&LoginUserid&"' And convert(varchar(10), SendDate, 120) = '"&Left(pushDate, 10)&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			If rsget(0) > 0 Then
				oJson("response") = "err"
				oJson("faildesc") = "이미 신청되었습니다."
				oJson.flush
				Set oJson = Nothing
				dbget.close() : Response.End
			End If
		End IF
		rsget.close

		vQuery = " INSERT INTO [db_temp].[dbo].[tbl_pickUpEvent_Push7](userid, SendDate, Sendstatus, RegDate) VALUES('" & LoginUserid & "', '"&Left(pushDate, 10)&"', 'N', getdate())"
		dbget.Execute vQuery

		oJson("response") = "ok"
		oJson("sendCount") = 0
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	elseif mode = "cart" Then
		oJson("response") = "ok"
		oJson("message") = ""
		oJson("cartTotalAmount") = cartTotalAmount
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->