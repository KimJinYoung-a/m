<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 2019 비밀번호 이벤트
' History : 2019-10-10 최종원
'###########################################################
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
		eCode = "90409"
		couponidx = 2896
	Else
		eCode = "97806"
		couponidx = 1217
	End If

	eventStartDate  = cdate("2019-10-10")		'이벤트 시작일
	eventEndDate 	= cdate("2019-10-31")		'이벤트 종료일
	currentDate 	= date()
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

	'pwdEvent.testMode = true
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

			oJson("data")(null)("openDate") = openDate
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("password") = password
			oJson("data")(null)("winner") = winner
			oJson("data")(null)("itemcode") = itemcode
			oJson("data")(null)("imgCode") = imgCode
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->