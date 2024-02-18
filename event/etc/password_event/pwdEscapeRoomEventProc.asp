<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 2020 방탈출 비밀번호 이벤트
' History : 2020-03-05 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/event/password_event/PasswordEventCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate, i
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, couponidx, pwdEvent, code, selectedPdt, numOfItems
	dim result, oJson, md5userid, winItemid
	dim firstPasswordCode
	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

	Set oJson = jsObject()

	If InStr(refer, "10x10.co.kr") < 1 Then
		oJson("response") = "err"
		oJson("faildesc") = "잘못된 접속입니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode = "100915"
		couponidx = 2896
	Else
		eCode = "101180"
		couponidx = 1312
	End If

	'// 이벤트 상품 노출은 2020년 3월 9일부터 10일.
	'// 실제 이벤트 응모 시작일자는 2020-03-11로 셋팅
	eventStartDate  = cdate("2020-03-11")		'이벤트 시작일
	eventEndDate 	= cdate("2020-03-20")		'이벤트 종료일
	currentDate 	= date()
    'currentDate		= cdate("2020-03-13")'테스트
	LoginUserid		= getencLoginUserid()

	mode 			= request("mode")
	snsType			= request("snsnum")
	code			= request("code")
	selectedPdt 	= request("selectedPdt")

	device = "A"
	numOfItems = 1  '개별 상품 처리

if mode = "add" then
	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("faildesc") = "로그인 후 참여하실 수 있습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if
	if Not(currentDate >= eventStartDate And currentDate <= eventEndDate) then	'이벤트 참여기간
		oJson("response") = "err"
		oJson("faildesc") = "이벤트 참여기간이 아닙니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	set pwdEvent = new PasswordEventCls
	pwdEvent.evtCode = eCode							'이벤트코드
	pwdEvent.password = code 						'입력 패스워드
	pwdEvent.userid = LoginUserid					'사용자id
	pwdEvent.device = device							'기기
	pwdEvent.selectedPdt = selectedPdt
	pwdEvent.numOfItems = numOfItems

	pwdEvent.testMode = false
	pwdEvent.execPasswordEvent()
	result = pwdEvent.totalResult

	'디버깅용 리턴코드명세
	Select Case result
		Case "A01"
			returntext = "금일 응모"
		Case "A02"
			returntext = "공유 후 응모"
		Case "B01"
			returntext = "당첨자와 동일한 정보"
		Case "B02"
			returntext = "스태프 필터"
		Case "B03"
			returntext = "당첨자 필터"
		Case "B04"
			returntext = "당첨자 LIMIT도달"
		Case "B06"
			returntext = "일반적인 꽝처리"
		Case "C01"
			returntext = "당첨"
		Case Else
			returntext = "에러"
	End select

	if result = "C01" Then
		winItemid = Replace(selectedPdt, ",", "")
	else
		winItemid = "00000"
	end if

	if pwdEvent.isParticipationDayBase(2) then
		'//쿠폰 발급
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
		sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(hh, +24, getdate()),couponmeaipprice,validsitename" & vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
		sqlstr = sqlstr & " 	where idx in ("& couponidx &")"

		dbget.execute sqlstr
	end if

	oJson("response") = "ok"
	oJson("result") = result
	oJson("winItemid") = winItemid
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "snschk" then
	if Not(IsUserLoginOK) Then
		Response.write "ok|"& snsType
		response.end
	end if
	set pwdEvent = new PasswordEventCls
	pwdEvent.evtCode = eCode		'이벤트코드
	pwdEvent.userid = LoginUserid'사용자id
	pwdEvent.device = device		'기기
	pwdEvent.snsType = snsType	'sns종류

	pwdEvent.snsShare()
	Response.write "ok|" & snsType
	response.end
elseif mode = "evtobj" then
	dim itemList
	dim openDate, itemName, password, winner, itemcode, itemIdx, imgCode

	set pwdEvent = new PasswordEventCls
	itemList = pwdEvent.getEventPrizeList(eCode)

	Set oJson("data") = jsArray()

	if isArray(itemList) then
		for i = 0 to ubound(itemList,2)
			Set oJson("data")(null) = jsObject()

			openDate = itemList(0, i)
			itemName = itemList(2, i)
			password = itemList(3, i)
			winner = itemList(4, i)
			itemcode = itemList(6, i)
			imgCode = itemList(5, i)
			firstPasswordCode = itemList(7,i)

			oJson("data")(null)("openDate") = openDate
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("password") = password
			oJson("data")(null)("winner") = winner
			oJson("data")(null)("itemcode") = itemcode
			oJson("data")(null)("imgCode") = imgCode
			oJson("data")(null)("firstPasswordCode") = firstPasswordCode			
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "winner" then
	Set oJson("data") = jsArray()	
	
    sqlStr = " SELECT "
	sqlStr = sqlstr & "  e.sub_idx "
	sqlStr = sqlstr & "  , e.evt_code "
	sqlStr = sqlstr & "  , e.userid "
	sqlStr = sqlstr & "  , e.sub_opt1 "
	sqlStr = sqlstr & "  , e.sub_opt2 "
	sqlStr = sqlstr & "  , e.sub_opt3 "
	sqlStr = sqlstr & "  , e.regdate "
	sqlStr = sqlstr & "  , e.device "
	sqlStr = sqlstr & "  , o.open_date "
	sqlStr = sqlstr & "  , o.option1 "
	sqlStr = sqlstr & "  , o.option2 "
	sqlStr = sqlstr & "  , o.option3 "
	sqlStr = sqlstr & "  , o.option4 "
	sqlStr = sqlstr & "  , o.option5 "
	sqlStr = sqlstr & "  FROM [db_event].[dbo].[tbl_event_subscript] e WITH(NOLOCK) "
	sqlStr = sqlstr & "  INNER JOIN [db_event].[dbo].[tbl_realtime_event_obj] o WITH(NOLOCK) ON e.userid = o.option3 AND e.evt_code = o.evt_code "
	sqlStr = sqlstr & "  WHERE e.sub_opt1 = '1' AND e.evt_code='"&eCode&"' AND option3 <> '0' "
	sqlStr = sqlstr & "  ORDER BY e.sub_idx ASC "
	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	
	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("data") = jsArray()
		
		Do Until rsget.EOF            
			Set oJson("data")(null) = jsObject() 
			oJson("data")(null)("sub_idx") = rsget("sub_idx")
			oJson("data")(null)("evt_code") = rsget("evt_code")
			oJson("data")(null)("userid") = rsget("option3") '// tbl_realtime_event_obj에 당첨되면 들어가는 아이디값
			oJson("data")(null)("sub_opt1") = rsget("sub_opt1") '// 해당 필드가 1이어야 당첨임
			oJson("data")(null)("regdate") = rsget("regdate") '// 이벤트 응모일자
			oJson("data")(null)("open_date") = rsget("open_date") '// 당첨상품 오픈일자
			oJson("data")(null)("itemname") = rsget("option1") '// 상품명
            oJson("data")(null)("passwd") = rsget("option2") '// 비밀번호값
			oJson("data")(null)("imgcode") = rsget("option4") '// 당첨상품 이미지 파일명
			oJson("data")(null)("option5") = rsget("option5") '// 당첨상품 정렬순서
			rsget.MoveNext
		loop
	else
		oJson("data") = ""
	end if
	rsget.Close	
	oJson.flush
    Set oJson = Nothing
    dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->