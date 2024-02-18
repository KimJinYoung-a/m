<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 2019 추석 보너스 이벤트
' History : 2019-08-14 원승현
'####################################################
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
		eCode = "90368"	
		couponidx = 2896
	Else
		eCode = "96682"
		couponidx = 1188
	End If

	eventStartDate  = cdate("2019-08-19")		'이벤트 시작일 
	eventEndDate 	= cdate("2019-09-04")		'이벤트 종료일
	currentDate 	= date()
	LoginUserid		= getencLoginUserid()	
'테스트
'currentDate = cdate("2019-08-19")

	mode 			= request("mode")
	snsType			= request("snsnum")	
	LoginUserid		= getencLoginUserid()	
	device = "A"

' 타임라인
	Select Case currentDate	
		Case "2019-08-19"
		''테스트
			if Cdate("19:30:00") < time() and Cdate("20:30:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("19:30:00")
				winEndTimeLine = Cdate("20:30:00")				
			end if
		Case "2019-08-20"
            '// 당첨자 없는 일자

		Case "2019-08-21"
			if Cdate("10:15:00") < time() and Cdate("11:15:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("10:15:00")
				winEndTimeLine = Cdate("11:15:00")
			end if		
		Case "2019-08-22"
			if Cdate("18:30:00") < time() and Cdate("19:30:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("18:30:00")
				winEndTimeLine = Cdate("19:39:00")
			end if
		Case "2019-08-23"
            '// 당첨자 없는 일자

		Case "2019-08-24"
			if Cdate("15:45:00") < time() and Cdate("16:45:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("15:45:00")
				winEndTimeLine = Cdate("16:45:00")
			end if
        Case "2019-08-25"
            '// 당첨자 없는 일자
    				
		Case "2019-08-26"
			if Cdate("11:00:00") < time() and Cdate("12:00:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("11:00:00")
				winEndTimeLine = Cdate("12:00:00")
			end if
        Case "2019-08-27"
			if Cdate("16:30:00") < time() and Cdate("17:30:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("16:30:00")
				winEndTimeLine = Cdate("17:30:00")
			end if
        Case "2019-08-28"
			if Cdate("08:30:00") < time() and Cdate("09:30:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("08:30:00")
				winEndTimeLine = Cdate("09:30:00")
			end if
        Case "2019-08-29"
            '// 당첨자 없는 일자

        Case "2019-08-30"
			if Cdate("20:00:00") < time() and Cdate("21:00:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("20:00:00")
				winEndTimeLine = Cdate("21:00:00")
			end if
        Case "2019-08-31"
            '// 당첨자 없는 일자

        Case "2019-09-01"
			if Cdate("19:36:00") < time() and Cdate("20:36:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("19:36:00")
				winEndTimeLine = Cdate("20:36:00")
			end if
        Case "2019-09-02"
            '// 당첨자 없는 일자

		Case "2019-09-03"
			if Cdate("14:00:00") < time() and Cdate("15:00:00") > time() then			
				'itemId = 1000000
				winStartTimeLine = Cdate("14:00:00")
				winEndTimeLine = Cdate("15:00:00")
			end if
        Case "2019-09-04"
            '// 당첨자 없는 일자

	End select

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

	md5userid 	= md5(LoginUserid&"10") 			'md5 암호화
	set drawEvt = new DrawEventCls
	drawEvt.evtCode = eCode							'이벤트코드
	drawEvt.winPercent = 300 						'당첨확률 : max = 1000
	drawEvt.userid = LoginUserid					'사용자id
	drawEvt.device = device							'기기
	drawEvt.winnerLimit = 1							'당첨인원수
	drawEvt.startWinTimeOption = winStartTimeLine	'타임라인 시작
	drawEvt.EndWinTimeOption = winEndTimeLine		'타임라인 종료	
	'drawEvt.itemId = itemId							'상품코드(해당 이벤트는 itemid 없어서 넘기지 않음)

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

		if drawEvt.isParticipationDayBase(2) then	
			'//쿠폰 발급			
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, getdate(), dateadd(s, -1,dateadd(dd,datediff(dd,0,getdate()+1),0)),couponmeaipprice,validsitename" & vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
			sqlstr = sqlstr & " 	where idx in ("& couponidx &")"
			
			dbget.execute sqlstr			
		end if
		
		oJson("response") = "ok"
		oJson("result") = result
		oJson("md5userid") = md5userid
		'oJson("winItemid") = winItemid
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
	sqlStr = sqlstr & "  FROM [db_event].[dbo].[tbl_event_subscript] "
	sqlStr = sqlstr & " WHERE EVT_CODE = '"& eCode &"' "
	sqlStr = sqlstr & "   AND SUB_OPT1 = '1' "
	'sqlStr = sqlstr & "   AND SUB_OPT2 <> 0 "
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