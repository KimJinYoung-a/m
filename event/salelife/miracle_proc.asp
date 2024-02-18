<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 4월정기세일 100원의 기적
' History : 2019-03-25 최종원
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
	dim currentDate, refer, eventStartDate, eventEndDate
	Dim eCode, LoginUserid, mode, sqlStr, device, snsType, returntext, couponidx
	dim drawEvt, winStartTimeLine, winEndTimeLine, startTimeOption, endTimeOption
	dim result, msg, itemId, oJson, md5userid, winItemid	
	refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

	// 바로 접속시엔 오류 표시
	If InStr(refer, "10x10.co.kr") < 1 Then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	End If

	IF application("Svr_Info") = "Dev" THEN
		eCode = "90247"	
		couponidx = 2896
	Else
		eCode = "93355"
		couponidx = 1138
	End If

	eventStartDate  = cdate("2019-03-28")		'이벤트 시작일
	eventEndDate 	= cdate("2019-04-22")		'이벤트 종료일	
	currentDate 	= date()
	LoginUserid		= getencLoginUserid()	
'테스트
'currentDate = Cdate("2019-04-01")

	mode 			= request("mode")
	snsType			= request("snsnum")	
	LoginUserid		= getencLoginUserid()	
	device = "A"

' 타임라인
	Select Case currentDate	
		Case "2019-03-29"
			if Cdate("09:10:00") < time() and Cdate("12:00:00") > time() then			
				itemId = 2292085
				winStartTimeLine = Cdate("09:10:00")
				winEndTimeLine = Cdate("12:00:00")				
			end if						
			if Cdate("12:01:00") < time() and Cdate("17:00:00") > time() then			
				itemId = 2292103
				winStartTimeLine = Cdate("12:01:00")
				winEndTimeLine = Cdate("17:00:00")				
			end if																			
		Case "2019-04-01"			
			if Cdate("14:45:00") < time() and Cdate("15:45:00") > time() then			
				itemId = 2292207
				winStartTimeLine = Cdate("14:45:00")
				winEndTimeLine = Cdate("15:45:00")		
			end if
		Case "2019-04-02"
			if Cdate("10:25:00") < time() and Cdate("11:00:00") > time() then			
				itemId = 2292048
				winStartTimeLine = Cdate("10:25:00")
				winEndTimeLine = Cdate("11:00:00")
			end if		
			if Cdate("16:30:00") < time() and Cdate("17:00:00") > time() then			
				itemId = 2292208
				winStartTimeLine = Cdate("16:30:00")
				winEndTimeLine = Cdate("17:00:00")
			end if					
		Case "2019-04-03"
			if Cdate("18:20:00") < time() and Cdate("19:20:00") > time() then			
				itemId = 2292200
				winStartTimeLine = Cdate("18:20:00")
				winEndTimeLine = Cdate("19:20:00")
			end if		
		Case "2019-04-05"
			if Cdate("13:30:00") < time() and Cdate("14:30:00") > time() then			
				itemId = 2292988
				winStartTimeLine = Cdate("13:30:00")
				winEndTimeLine = Cdate("14:30:00")
			end if				
		Case "2019-04-06"
			if Cdate("19:10:00") < time() and Cdate("20:10:00") > time() then			
				itemId = 2292103
				winStartTimeLine = Cdate("19:10:00")
				winEndTimeLine = Cdate("20:10:00")
			end if					
		Case "2019-04-08"
			if Cdate("17:00:00") < time() and Cdate("18:00:00") > time() then			
				itemId = 2292057
				winStartTimeLine = Cdate("17:00:00")
				winEndTimeLine = Cdate("18:00:00")
			end if							
		Case "2019-04-09"
			if Cdate("13:30:00") < time() and Cdate("14:30:00") > time() then			
				itemId = 2293045
				winStartTimeLine = Cdate("13:30:00")
				winEndTimeLine = Cdate("14:30:00")
			end if			
		Case "2019-04-11"
			if Cdate("19:10:00") < time() and Cdate("20:10:00") > time() then			
				itemId = 2292077
				winStartTimeLine = Cdate("19:10:00")
				winEndTimeLine = Cdate("20:10:00")
			end if				
		Case "2019-04-13"
			if Cdate("22:00:00") < time() and Cdate("23:00:00") > time() then			
				itemId = 2292085
				winStartTimeLine = Cdate("22:00:00")
				winEndTimeLine = Cdate("23:00:00")
			end if						
		Case "2019-04-16"
			if Cdate("10:25:00") < time() and Cdate("11:25:00") > time() then			
				itemId = 2293047
				winStartTimeLine = Cdate("10:25:00")
				winEndTimeLine = Cdate("11:25:00")
			end if	
			if Cdate("16:30:00") < time() and Cdate("17:30:00") > time() then			
				itemId = 2292160
				winStartTimeLine = Cdate("16:30:00")
				winEndTimeLine = Cdate("17:30:00")
			end if						
		Case "2019-04-17"
			if Cdate("13:30:00") < time() and Cdate("14:30:00") > time() then			
				itemId = 2293059
				winStartTimeLine = Cdate("13:30:00")
				winEndTimeLine = Cdate("14:30:00")
			end if					
		Case "2019-04-19"
			if Cdate("19:10:00") < time() and Cdate("20:10:00") > time() then			
				itemId = 2292964
				winStartTimeLine = Cdate("19:10:00")
				winEndTimeLine = Cdate("20:10:00")
			end if							
		Case "2019-04-20"
			if Cdate("14:45:00") < time() and Cdate("15:45:00") > time() then			
				itemId = 2293053
				winStartTimeLine = Cdate("14:45:00")
				winEndTimeLine = Cdate("15:45:00")
			end if			
		Case "2019-04-21"
			if Cdate("11:00:00") < time() and Cdate("12:00:00") > time() then			
				itemId = 2293060
				winStartTimeLine = Cdate("11:00:00")
				winEndTimeLine = Cdate("12:00:00")
			end if			
		Case "2019-04-22"
			if Cdate("19:10:00") < time() and Cdate("20:10:00") > time() then			
				itemId = 2290327
				winStartTimeLine = Cdate("19:10:00")
				winEndTimeLine = Cdate("20:10:00")
			end if					
	End select

if mode = "add" then
	if Not(IsUserLoginOK) Then			 	
		Response.write "err|로그인 후 참여하실 수 있습니다."
		response.end
	end if		
	if Not(currentDate >= eventStartDate And currentDate <= eventEndDate) then	'이벤트 참여기간		
		Response.write "err|이벤트 참여기간이 아닙니다."
		response.end
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
	drawEvt.itemId = itemId							'타임라인 종료	

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
		response.write "ok|" & result & "|" & md5userid & "|" & winItemid
		dbget.close()	:	response.End

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
	Set oJson = jsObject()
	Set oJson("data") = jsArray()	
	
	sqlStr = " SELECT userid, sub_opt2, regdate " 
	sqlStr = sqlstr & "  FROM [db_event].[dbo].[tbl_event_subscript] "
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