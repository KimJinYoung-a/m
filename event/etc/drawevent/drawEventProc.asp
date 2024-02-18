<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 100원 자판기
' History : 2019-06-17 최종원
' History : 2019-09-24 이종화 10월 주년 이벤트용 - 상품 변경
' History : 2019-09-26 이종화 10월 주년 이벤트용 - 테스트 케이스 설정
'			마케팅 ID , 시스템 ID 만 참여 가능 - 이벤트 시작일 부터 종료일 사이 & 확률 당첨 여부 가능
' History : 2020-01-07 이종화 텐텐 연간이용권
' History : 2020-01-07 이종화 백원 자판기
' History : 2020-04-07 원승현 백원 자판기
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/drawevent/DrawEventCls.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	Response.ContentType = "application/json"
	response.charset = "utf-8"
	dim currentDate, refer, eventStartDate, eventEndDate
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, couponidx
	dim drawEvt, winStartTimeLine, winEndTimeLine, startTimeOption, endTimeOption
	dim result, msg, itemId, oJson, md5userid, winItemid
	dim winPercent , winLimitedUser , winTimeLimitedUser
	dim mktTest : mktTest = false
	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
	
	Set oJson = jsObject()

	IF application("Svr_Info") <> "Dev" THEN
		If InStr(refer, "10x10.co.kr") < 1 Then
			oJson("response") = "err"
			oJson("faildesc") = "잘못된 접속입니다."
			oJson.flush
			Set oJson = Nothing
			dbget.close() : Response.End
		End If
	END IF

	IF application("Svr_Info") = "Dev" THEN
		eCode = "101600"
		'// 이번 100원 자판기는 쿠폰 발급 없음
		'couponidx = 2896
	Else
		eCode = "101991"
		'// 이번 100원 자판기는 쿠폰 발급 없음
		'couponidx = 1299
	End If

	eventStartDate  = Cdate("2020-04-09")		'이벤트 시작일 
	eventEndDate 	= Cdate("2020-04-17")		'이벤트 종료일
	currentDate 	= date()
	LoginUserid		= getencLoginUserid()	
	mode 			= request("mode")
	snsType			= request("snsnum")
	device = "A"
	winPercent = 300 	'당첨확률 : max = 1000
	winLimitedUser = 0  '당첨 인원
	winTimeLimitedUser = 0 '시간대별 당첨자수

	' 테스트용 Init
	IF LoginUserid="ley330" or LoginUserid="greenteenz" or LoginUserid="rnldusgpfla" or LoginUserid="cjw0515" or LoginUserid="thensi7" or LoginUserid = "motions" Then
		dim adminWinPercent : adminWinPercent = requestCheckVar(request("adminWinPercent"),4) '// 확률
		dim adminCurrentDate : adminCurrentDate = requestCheckVar(request("adminCurrentDate"),10) '// 당첨일 선정
		if date() < eventStartDate then mktTest = true '// 오픈전 테스트 flag

		winPercent = chkiif(adminWinPercent = "" , winPercent , adminWinPercent ) 	'당첨확률 : max = 1000
		winPercent = Cint(winPercent) '형변환 체크
		currentDate = chkiif(adminCurrentDate = "" , currentDate , adminCurrentDate ) '타임 라인 선택
		currentDate = Cdate(currentDate) '형변환 체크
		
		eventStartDate = date() '// flag 바꾼후 시작일 변경 
	END IF

if mode = "add" then
	' 타임라인
	call fnGetTimeLine(currentDate , "S" , mktTest , itemid , winLimitedUser , winTimeLimitedUser , winStartTimeLine , winEndTimeLine) '// 100원자판기 S , 텐텐 월간 이용권 M

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

	md5userid 	= md5(LoginUserid&"10") 			'md5 암호화
	set drawEvt = new DrawEventCls
	drawEvt.evtCode = eCode							'이벤트코드
	drawEvt.winPercent = winPercent					'당첨확률 : max = 1000
	drawEvt.userid = LoginUserid					'사용자id
	drawEvt.device = device							'기기
	drawEvt.winnerLimit = winLimitedUser			'당첨인원수
	drawEvt.timeLineWinnerLimit = winTimeLimitedUser'타임라인별 당첨인원수
	drawEvt.startWinTimeOption = winStartTimeLine	'타임라인 시작
	drawEvt.EndWinTimeOption = winEndTimeLine		'타임라인 종료	
	drawEvt.itemId = itemId							'타임라인 종료	
	drawEvt.mktTest = mktTest						'마케팅 테스트

	'drawEvt.testMode = true	
	drawEvt.execDraw100won()
	result = drawEvt.totalResult

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
			Case "B05"
				returntext = "타임라인 이외"
			Case "B06"
				returntext = "일반적인 꽝처리"
			Case "B07"
				returntext = "타임라인 당첨자 LIMIT도달"
			Case "C01"
				returntext = "당첨"
			Case Else
				returntext = "에러"
		End select
	
		if result = "C01" Then
			winItemid = itemid
		else
			winItemid = "00000"
		end if

		if drawEvt.isParticipationDayBase(2) and InStr(result, "B") > 0 then	
			'//쿠폰 발급(이번 100원 자판기는 쿠폰 발급 없음)
			'sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
			'sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
			'sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), DATEADD(D, 1,  GETDATE()), couponmeaipprice,validsitename" & vbcrlf
			'sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
			'sqlstr = sqlstr & " 	where idx in ("& couponidx &")"
			
			'dbget.execute sqlstr			
		end if
		
		oJson("response") = "ok"
		oJson("result") = result
		oJson("md5userid") = md5userid
		oJson("winItemid") = winItemid
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
elseif mode = "snschk" then
	if Not(IsUserLoginOK) Then			 	
		Response.write "ok|"& snsType
		response.end		
	end if
	set drawEvt = new DrawEventCls
	drawEvt.evtCode = eCode		'이벤트코드
	drawEvt.userid = LoginUserid'사용자id
	drawEvt.device = device		'기기
	drawEvt.snsType = snsType	'sns종류

	drawEvt.snsShare()
	Response.write "ok|" & snsType 
	response.end	
elseif mode = "winner" then
	Set oJson("data") = jsArray()	
	
	sqlStr = " SELECT userid, sub_opt2, regdate " 
	sqlStr = sqlstr & "  FROM [db_event].[dbo].[tbl_event_subscript] WITH(NOLOCK) "
	sqlStr = sqlstr & " WHERE EVT_CODE = '"& eCode &"' "
	sqlStr = sqlstr & "   AND SUB_OPT1 = '1' "
	sqlStr = sqlstr & "   AND SUB_OPT2 <> 0 "
	sqlStr = sqlstr & "   AND SUB_OPT3 = 'draw' "
	sqlStr = sqlstr & " order by regdate asc "

	rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
	
	if Not(rsget.EOF or rsget.BOF) then
		Set oJson("data") = jsArray()
		
		Do Until rsget.EOF            
			Set oJson("data")(null) = jsObject() 
			oJson("data")(null)("userid") = rsget("userid")
			oJson("data")(null)("sub_opt2") = rsget("sub_opt2")
			oJson("data")(null)("regdate") = rsget("regdate")
			rsget.MoveNext
		loop
	else
		oJson("data") = ""
	end if
	rsget.Close	
	oJson.flush
Set oJson = Nothing
end if
		
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->