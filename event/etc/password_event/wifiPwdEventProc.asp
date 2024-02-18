<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 와이파이 비밀번호 이벤트
' History : 2019-08-05 최종원
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
		eCode = "90362"	
		couponidx = 2896
	Else
		eCode = "96413"
		couponidx = 1179
	End If

	eventStartDate  = cdate("2019-08-05")		'이벤트 시작일 
	eventEndDate 	= cdate("2019-08-18")		'이벤트 종료일
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

	if pwdEvent.isParticipationDayBase(2)  then	
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
	dim openDate, itemName, password, winner, itemcode, itemIdx

	set pwdEvent = new PasswordEventCls
	itemList = pwdEvent.getEventPrizeList(eCode)

	Set oJson("data") = jsArray()			

	if isArray(itemList) then
		for i = 0 to ubound(itemList,2)
			Set oJson("data")(null) = jsObject() 
			
			openDate = itemList(0, i)
			itemName = split(itemList(2, i), "|")(0)
			password = itemList(3, i)
			winner = itemList(4, i)
			itemcode = itemList(6, i)
			itemIdx = split(itemList(2, i), "|")(1)

		
			oJson("data")(null)("openDate") = openDate
			oJson("data")(null)("itemName") = itemName
			oJson("data")(null)("password") = password
			oJson("data")(null)("winner") = winner
			oJson("data")(null)("itemcode") = itemcode
			oJson("data")(null)("itemIdx") = itemIdx
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
elseif mode = "stat" then
	dim numOfParticipantsPerDay	
	sqlStr = ""

	sqlStr = sqlStr & "SELECT DISTINCT T1.날짜	 	"
	sqlStr = sqlStr & "	 , T2.수 AS 참여수	"
	sqlStr = sqlStr & "	 , T1.수 AS 가입자수	"
	sqlStr = sqlStr & "  FROM (	"
	sqlStr = sqlStr & "   select a.날짜	"
	sqlStr = sqlStr & "	    , count(a.수) as 수	"
	sqlStr = sqlStr & "	 from (	"
	sqlStr = sqlStr & "	   select CONVERT(CHAR(10), b.REGDATE, 23) AS 날짜 	"
	sqlStr = sqlStr & "			, count(b.userid) as 수	"
	sqlStr = sqlStr & "  		 FROM DB_EVENT.DBO.tbl_event_subscript a	"
	sqlStr = sqlStr & "		inner join db_user.dbo.tbl_user_n b with(nolock) on a.userid = b.userid	"
	sqlStr = sqlStr & "		and b.regdate >= '"& eventStartDate &"'"
	sqlStr = sqlStr & "		WHERE EVT_CODE = '"& CStr(eCode) &"'	"
	sqlStr = sqlStr & "			AND SUB_OPT3 = 'TRY' 	"
	sqlStr = sqlStr & "			and a.regdate >= '"& eventStartDate &"'"	
	sqlStr = sqlStr & "		group by b.USERID, CONVERT(CHAR(10), b.REGDATE, 23)	"
	sqlStr = sqlStr & "	) as a	"
	sqlStr = sqlStr & "	group by 날짜 		"
	sqlStr = sqlStr & "  )AS T1	"
	sqlStr = sqlStr & "  ,(	"
	sqlStr = sqlStr & "	SELECT A.날짜  	"
	sqlStr = sqlStr & "		, COUNT(A.수) AS 수 	"
	sqlStr = sqlStr & "	FROM ( 	"
	sqlStr = sqlStr & "	SELECT CONVERT(CHAR(10), REGDATE, 23) AS 날짜 	"
	sqlStr = sqlStr & "		 	, COUNT(USERID) 수 	"
	sqlStr = sqlStr & "		FROM DB_EVENT.DBO.tbl_event_subscript  	"
	sqlStr = sqlStr & "	WHERE EVT_CODE = '"& CStr(eCode) &"'	"
	sqlStr = sqlStr & "		AND SUB_OPT3 = 'TRY' 	"
	sqlStr = sqlStr & "		and regdate >= '"& eventStartDate &"'"		
	sqlStr = sqlStr & "	GROUP BY USERID, CONVERT(CHAR(10), REGDATE, 23) 	"
	sqlStr = sqlStr & "	)AS A 	"
	sqlStr = sqlStr & "	GROUP BY 날짜 	 	"
	sqlStr = sqlStr & "  )AS T2	"
	sqlStr = sqlStr & "  WHERE T1.날짜 = T2.날짜	"
	sqlStr = sqlStr & "  ORDER BY T1.날짜 ASC	"

	'response.write sqlStr &"<br>"
	'response.end

	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

	if not rsget.EOF then
		numOfParticipantsPerDay = rsget.getRows()
	end if
	rsget.close

	Set oJson("stat") = jsArray()				

	if isArray(numOfParticipantsPerDay) then	
		for i=0 to uBound(numOfParticipantsPerDay,2)
			Set oJson("stat")(null) = jsObject()
			
			oJson("stat")(null)("date") = numOfParticipantsPerDay(0,i)			
			oJson("stat")(null)("cnt") = numOfParticipantsPerDay(1,i)
			oJson("stat")(null)("new") = numOfParticipantsPerDay(2,i)
		next
	end if

	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
		
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->