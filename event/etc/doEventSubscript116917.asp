<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 더블 마일리지
' History : 2021-05-27 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, eventStartDate, eventEndDate, i, refer
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, eventobj
	dim result, oJson, mktTest, vItemID, cnt
	dim vQuery , vIsExistItem , vWishCheck
	dim item1, item2, item3, item4, wish1, wish2, wish3, wish4

    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
	Set oJson = jsObject()
	mode = request("mode")
	vItemID = request("itemcode")
	IF application("Svr_Info") = "Dev" THEN
	else
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	End If

	mktTest = False

    IF application("Svr_Info") = "Dev" THEN
        eCode = "109486"
        mktTest = True
		item1 = "3279814"
		item2 = "3204557"
		item3 = "3262244"
		item4 = "3308296"
    ElseIf application("Svr_Info")="staging" Then
        eCode = "116917"
        mktTest = True
		item1 = "4406119"
		item2 = "4406118"
		item3 = "4406117"
		item4 = "4406116"
    Else
        eCode = "116917"
        mktTest = False
		item1 = "4406119"
		item2 = "4406118"
		item3 = "4406117"
		item4 = "4406116"
    End If

	eventStartDate	= cdate("2022-02-11")		'이벤트 시작일
	eventEndDate	= cdate("2022-02-16")		'이벤트 종료일 + 1

	LoginUserid		= getencLoginUserid()

	if mktTest then
		currentDate = cdate("2022-02-11")
	else
		currentDate = date()
	end if
    if isApp="1" then
	    device = "A"
    else
        device = "M"
    end if

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if Not(currentDate >= eventStartDate And currentDate < eventEndDate) then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	if getevent_subscriptexistscount(eCode, LoginUserid, "", "", "try") < 1 then
		sqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code, userid, sub_opt1, sub_opt3, device)" & vbcrlf
		sqlStr = sqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '0', 'try','"& device &"')"
		dbget.execute sqlStr
    else
		oJson("response") = "err"
		oJson("faildesc") = "이미 응모 완료되었어요!\n당첨자는 2/16에 확인해 주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	oJson("response") = "ok"
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "wish" then

	vQuery = "select count(itemid) from db_my10x10.dbo.tbl_myfavorite with(nolock)"
	vQuery = vQuery & "where userid = '" & LoginUserid & "' and itemid = '"& vItemID &"' and fidx=0"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		vIsExistItem = True
	else
		vIsExistItem = false
	end if
	rsget.close
	
	If vIsExistItem Then	'### 상품 있으면 삭제
		vQuery = " delete from [db_my10x10].[dbo].[tbl_myfavorite]"
		vQuery = vQuery & " where userid = '"& LoginUserid &"' and fidx = 0"
		vQuery = vQuery & " and itemid = '"& vItemID &"' "
		dbget.execute vQuery
	Else
		'### 위시 저장
		vQuery = "insert into db_my10x10.dbo.tbl_myfavorite(userid, itemid, regdate, fidx, viewIsUsing) values ('" & LoginUserid & "', " & vItemID & ", getdate(), 0, 'N')"
		dbget.execute vQuery
	End If

	vQuery = "select count(itemid) from db_my10x10.dbo.tbl_myfavorite with(nolock)"
	vQuery = vQuery & "where userid = '" & LoginUserid & "' and itemid in (" & item1 & "," & item2 & "," & item3 & "," & item4 &") and fidx=0"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		vWishCheck = true
	else
		vWishCheck = false
	end if
	rsget.close

	oJson("response") = "ok"
	oJson("wishcheck") = vWishCheck
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "wishload" then

	vQuery = "select count(itemid) from db_my10x10.dbo.tbl_myfavorite with(nolock)"
	vQuery = vQuery & "where userid = '" & LoginUserid & "' and itemid = '"& item1 &"' and fidx=0"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		wish1 = True
	else
		wish1 = false
	end if
	rsget.close
	vQuery = "select count(itemid) from db_my10x10.dbo.tbl_myfavorite with(nolock)"
	vQuery = vQuery & "where userid = '" & LoginUserid & "' and itemid = '"& item2 &"' and fidx=0"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		wish2 = True
	else
		wish2 = false
	end if
	rsget.close
	vQuery = "select count(itemid) from db_my10x10.dbo.tbl_myfavorite with(nolock)"
	vQuery = vQuery & "where userid = '" & LoginUserid & "' and itemid = '"& item3 &"' and fidx=0"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		wish3 = True
	else
		wish3 = false
	end if
	rsget.close
	vQuery = "select count(itemid) from db_my10x10.dbo.tbl_myfavorite with(nolock)"
	vQuery = vQuery & "where userid = '" & LoginUserid & "' and itemid = '"& item4 &"' and fidx=0"
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		wish4 = True
	else
		wish4 = false
	end if
	rsget.close

	if getevent_subscriptexistscount(eCode, LoginUserid, "", "", "try") < 1 then
		vWishCheck = True
	else
		vWishCheck = false
	end if

	oJson("response") = "ok"
	oJson("wishitem1") = item1
	oJson("wishitem2") = item2
	oJson("wishitem3") = item3
	oJson("wishitem4") = item4
	oJson("wish1") = wish1
	oJson("wish2") = wish2
	oJson("wish3") = wish3
	oJson("wish4") = wish4
	oJson("wishcheck") = vWishCheck
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode="alarm" then
    sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode & " and sub_opt3='alarm'"
    rsget.Open sqlstr, dbget, 1
        cnt = rsget("cnt")
    rsget.close

    If cnt < 1 Then
        sqlStr = ""
        sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt3)" & vbCrlf
        sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '" & device & "', 'alarm')"
        dbget.execute sqlstr

        oJson("response") = "ok"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    Else
        oJson("response") = "retry"
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->