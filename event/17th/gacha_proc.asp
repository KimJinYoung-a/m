<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Charset="UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'###########################################################
' Description : [텐바이텐] 17주년이벤트 - 100원으로 인생역전!
' History : 2018-09-19 이종화 
'###########################################################

dim sqlStr, LoginUserid
Dim eCode , mode , snsnum , evtUserCell , refip , refer , md5userid , renloop
Dim device
Dim actdate : actdate = Date()

'actdate = "2018-10-10"

if isapp then
	device = "A"
else
	device = "M"
end if

eCode 		= "89305" '// 이벤트 번호

mode		= requestcheckvar(request("mode"),32) '// add
snsnum 		= requestcheckvar(request("snsnum"),10)
LoginUserid	= getLoginUserid()
evtUserCell	= get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호
refip 		= Request.ServerVariables("REMOTE_ADDR") '// ip
refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
md5userid 	= md5(LoginUserid&"10") '//회원아이디 + 10 md5 암호화

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

'// 상품명
Function itemprize(v)
	Select Case CStr(v)
		Case "2018-10-10"
			itemprize = "애플 에어팟"
		Case "2018-10-11"
			itemprize = "아이패드 프로 256G"
		Case "2018-10-15"
			itemprize = "닌텐도 스위치"
		Case "2018-10-16"
			itemprize = "아이폰XS(5.8) 골드 256GB"
		Case "2018-10-18"
			itemprize = "LG전자 시네빔"
		Case "2018-10-22"
			itemprize = "애플와치 시리즈4"
		Case "2018-10-23"
			itemprize = "다이슨 V8 카본 파이버"
		Case "2018-10-25"
			itemprize = "치후 360 로봇 청소기"
		Case "2018-10-29"
			itemprize = "디지털카메라&포토프린터"
		Case "2018-10-31"
			itemprize = "다이슨 헤어드라이어"
		Case Else
			itemprize = ""
	end Select
End Function

'// 상품코드
Function itemprizecode(v)
	Select Case CStr(v)
		Case "2018-10-10"
			itemprizecode = "2095014" '애플 에어팟
		Case "2018-10-11"
			itemprizecode = "2095013" '아이패드 프로 256G
		Case "2018-10-15"
			itemprizecode = "2093362" '닌텐도 스위치
		Case "2018-10-16"
			itemprizecode = "2095012" '아이폰XS(5.8) 골드 256GB
		Case "2018-10-18"
			itemprizecode = "2093333" 'LG전자 시네빔
		Case "2018-10-22"
			itemprizecode = "2095011" '애플와치 시리즈4
		Case "2018-10-23"
			itemprizecode = "2093330" '다이슨 V8 카본 파이버
		Case "2018-10-25"
			itemprizecode = "2093505" '치후 360 로봇 청소기
		Case "2018-10-29"
			itemprizecode = "2093363" '디지털카메라&포토프린터
		Case "2018-10-31"
			itemprizecode = "2095001" '다이슨 헤어드라이어
		Case Else
			itemprizecode = ""
	end Select
End Function

'// 당첨 타임 테이블
Function winlosetimetable(v)
	Select Case CStr(v)
        Case "2018-10-10"
			winlosetimetable = chkiif(hour(now) >= 16,true,false)
		Case "2018-10-11"
			winlosetimetable = chkiif(hour(now) >= 19,true,false)
		Case "2018-10-15"
			winlosetimetable = chkiif(hour(now) >= 17,true,false)
		Case "2018-10-16"
			winlosetimetable = chkiif(hour(now) >= 18,true,false)
		Case "2018-10-18"
			winlosetimetable = chkiif(hour(now) >= 15,true,false)
		Case "2018-10-22"
			winlosetimetable = chkiif(hour(now) >= 19,true,false)
		Case "2018-10-23"
			winlosetimetable = chkiif(hour(now) >= 18,true,false)
		Case "2018-10-25"
			winlosetimetable = chkiif(hour(now) >= 16,true,false)
		Case "2018-10-29"
			winlosetimetable = chkiif(hour(now) >= 17,true,false)
		Case "2018-10-31"
			winlosetimetable = chkiif(hour(now) >= 16,true,false)
		Case Else
			winlosetimetable = false
	end Select
End Function

'// 구간 비교 s 랜덤결과 , v 기준값
function compareDice(s , v)
	compareDice = chkiif(s < v ,true,false)
end function 

'// 당첨 타임 구간
'// 11일 한정 당첨 확률 조정 3% , 5% , 7%
'// 2018-10-15 당첨 확률 조정 0.3% , 0.5% , 0.7%
function winLoseTimeSection(v,r)
	dim vDefaultPoint : vDefaultPoint = 0
	Select Case CStr(v)
        Case "2018-10-10" , "2018-10-25" , "2018-10-31"
			if hour(now) >= 16 and hour(now) < 18 then
				vDefaultPoint = 3
			elseif hour(now) >= 18 and hour(now) < 20 then 
				vDefaultPoint = 5
			elseif hour(now) >= 20 and hour(now) < 22 then 
				vDefaultPoint = 7
			elseif hour(now) >= 22 and hour(now) <= 23 then
				vDefaultPoint = 9
			end if 

			winLoseTimeSection = compareDice(r,vDefaultPoint)

		Case "2018-10-11"
			if hour(now) >= 19 and hour(now) < 21 then
				vDefaultPoint = 3
			elseif hour(now) >= 21 and hour(now) < 23 then 
				vDefaultPoint = 5
			elseif hour(now) = 23 then 
				vDefaultPoint = 7
			end if

			winLoseTimeSection = compareDice(r,vDefaultPoint)

		Case "2018-10-15" , "2018-10-29"
			if hour(now) >= 17 and hour(now) < 19 then
				vDefaultPoint = 3
			elseif hour(now) >= 19 and hour(now) < 21 then 
				vDefaultPoint = 5
			elseif hour(now) >= 21 and hour(now) < 23 then 
				vDefaultPoint = 7
			elseif hour(now) = 23 then
				vDefaultPoint = 9
			end if 

			winLoseTimeSection = compareDice(r,vDefaultPoint)

		Case "2018-10-16" , "2018-10-23"
			if hour(now) >= 18 and hour(now) < 20 then
				vDefaultPoint = 3
			elseif hour(now) >= 20 and hour(now) < 22 then 
				vDefaultPoint = 5
			elseif hour(now) >= 22 and hour(now) <= 23 then
				vDefaultPoint = 7
			end if		
			
			winLoseTimeSection = compareDice(r,vDefaultPoint)

		Case "2018-10-22"
			if hour(now) >= 19 and hour(now) < 21 then
				vDefaultPoint = 3
			elseif hour(now) >= 21 and hour(now) <= 23 then 
				vDefaultPoint = 5
			end if

			winLoseTimeSection = compareDice(r,vDefaultPoint)
			
		Case "2018-10-18"
			if hour(now) >= 15 and hour(now) < 17 then
				vDefaultPoint = 3
			elseif hour(now) >= 17 and hour(now) < 19 then 
				vDefaultPoint = 5
			elseif hour(now) >= 19 and hour(now) < 21 then 
				vDefaultPoint = 7
			elseif hour(now) >= 21 and hour(now) <= 23 then
				vDefaultPoint = 9
			end if 

			winLoseTimeSection = compareDice(r,vDefaultPoint)

		Case Else
			winLoseTimeSection = false
	end Select
end function

'#################################################################################################
'기본 체크 영역
'#################################################################################################
''처리 순서 0
''전화번호 중복당첨 꽝처리
Function duplnum(r)
	Dim dsqlStr
	If event_userCell_Selection_nodate(evtUserCell, eCode) > 0 Then '//전화번호 중복 당첨 꽝처리 - 날짜 없음
		If r = 1 Then 
			dsqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
			dsqlStr = dsqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
			dbget.execute dsqlStr
		Else
			dsqlStr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" & vbcrlf
			dsqlStr = dsqlStr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			dbget.execute dsqlStr
		End If 

		'// 해당 유저의 로그값 집어넣는다.
		dsqlStr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" & vbcrlf
		dsqlStr = dsqlStr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복비당첨처리', '"&device&"')"
		dbget.execute dsqlStr

		Response.write returnvalue2(r)
		dbget.close()	:	response.End
	End If
End Function 

''처리순서 1
''초기 당첨 여부 (30% 의 확률 당첨 여부 + 타임테이블 내에 속해야함) 
Function floor1st()
	Dim winlose
	randomize
	renloop=int(Rnd*1000)+1

	If winlosetimetable(actdate) And winLoseTimeSection(actdate,renloop) Then  '//
		floor1st = true
	Else
		floor1st = false '// 아님 걍 꽝 // 테스트시엔 ture로 돌리고 테스트
	End If 

	If GetLoginUserLevel = 7 or GetLoginUserLevel = 0 Then '// staff , white 등급 제외
		floor1st = false '// 걍 꽝
	End If 
End Function

''처리순서 2
''상품 카운트 - 이전당첨 유무
Function prizeproc(v,r)
	Dim isqlStr , icnt
	sqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and sub_opt2 = "& v &" and datediff(day,regdate,getdate()) = 0 "			
	rsget.Open sqlstr, dbget, 1
		icnt = rsget("icnt")
	rsget.close

	If icnt >= 1 Then 
		'// 꽝처리 return => false
		prizeproc = lose_proc(r)
	Else
		'// 당첨 입력 처리 return => true
		prizeproc = win_proc(v,r)
	End If 
End Function

''처리순서 2-1-1
''당첨처리
Function win_proc(v,r)
	Dim wsqlStr
	If r = 1 Then '//최초응모
		'// 최초응모자 당첨처리
		wsqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
		wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"& v &"', '"&device&"')"
		dbget.execute wsqlstr
	Else '// 2번째 응모자
		'// SNS 공유자 당첨처리
		wsqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"& v &"'" & vbcrlf
		wsqlstr = wsqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		dbget.execute wsqlstr
	End If 

	'// 해당 유저의 로그값 집어넣는다.
	wsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" & vbcrlf
	wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '"& itemprize(actdate) &"', '"&device&"')"
	dbget.execute wsqlstr

	Response.write returnvalue(actdate) '//결과 html vResult 결과
End Function

''처리순서 2-1-2
''꽝처리
Function lose_proc(r)
	Dim lsqlStr
	If r = 1 Then '//최초응모
		'// 최초응모자 꽝처리
		lsqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
		lsqlstr = lsqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
		dbget.execute lsqlstr
	Else
		'// 두번째응모자 꽝처리
		lsqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" & vbcrlf
		lsqlstr = lsqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		dbget.execute lsqlstr
	End If 

	'// 해당 유저의 로그값 집어넣는다.
	lsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1 , value3, device)" & vbcrlf
	lsqlstr = lsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '꽝', '"&device&"')"
	dbget.execute lsqlstr

	Response.write returnvalue2(r) '//결과 html
End Function

''처리순서 3
''메시지 리턴 처리 'html
Function returnvalue(v)
	Select Case CStr(v)
		Case "2018-10-10"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1010.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-11"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1011.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-15"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1015.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-16"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1016.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-18"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1018.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-22"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1022.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-23"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1023.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-25"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1025.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-29"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1029.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case "2018-10-31"
			returnvalue = "OK|<div class='case1'><h3>축하합니다! 당첨되셨습니다 :)</h3><a href='' onclick=""goDirOrdItem("& itemprizecode(actdate) &");return false;""><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_prize_1031.png?v=1.1' alt='' /></a><p class='code'>"& md5userid &"</p></div>"
		Case Else
			returnvalue = "OK|<div class='case1'>응모일이아닙니다.</div>"
	end Select
End Function

'' 꽝메시지
Function returnvalue2(r)
	if r = 1 then 
		returnvalue2 = "OK|<div class='case2'><h3>아쉽게도 당첨되지 않았습니다 :(</h3><div><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_fail.png?v=1.01' alt='' /></div><a href='' onclick=""sharesns('ka');return false;"" class='btn-kakaotalk'>카카오톡</a><a href=''  onclick=""sharesns('fb');return false;"" class='btn-facebook'>페이스북</a></div>"
	else
		returnvalue2 = "OK|<div class='case2'><h3>아쉽게도 당첨되지 않았습니다 :(</h3><div><img src='http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_fail_2.png' alt='' /></div></div>"
	end if 
End Function

'------------------------------------------------------------------------------------------------------------
'---처리
'------------------------------------------------------------------------------------------------------------
Dim result1 , result2 , result3 , snschk
If mode = "add" Then 		'//응모버튼 클릭
	'// 응모내역 검색
	sqlstr = ""
	sqlstr = sqlstr & " SELECT TOP 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " WHERE evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 경품코드가 들어가 있을경우엔 당첨
		result3 = rsget(2) '//SNS 2차 응모 확인용
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	If result1 = "" Then '//1차 응모
		'//어뷰징 아웃!
		if userBlackListCheck(LoginUserid) Then
			'Response.write "이색히야 넌 영원히 꽝이야"
			lose_proc(1) '//꽝처리
			dbget.close()	:	response.End
		End If 	

		duplnum(1) '//전화번호 걸러내기 통과후 아래로

		If floor1st() Then '//1차 당첨 or 비당첨
			Call prizeproc(1,1) '//당첨후 상품 처리 
			dbget.close()	:	response.End
		Else
			lose_proc(1) '//꽝처리
			dbget.close()	:	response.End
		End If
	ElseIf result1 = 1 Then '//2차 응모
		If result3 <> "" Then '//sns 공유 체크
			'//어뷰징 아웃!
			if userBlackListCheck(LoginUserid) Then
				'Response.write "이색히야 넌 영원히 꽝이야"
				lose_proc(2) '//꽝처리
				dbget.close()	:	response.End
			End If 	
			
			duplnum(2) '//전화번호 걸러내기 통과후 아래로

			If result2 > 0 Then '//1차 당첨이력이 있을경우
				lose_proc(2) '//꽝처리
				dbget.close()	:	response.End
			else
				If floor1st() Then '//2차 당첨 or 비당첨
					Call prizeproc(1,2) '//당첨후 상품 처리 
					dbget.close()	:	response.End
				Else
					lose_proc(2) '//꽝처리
					dbget.close()	:	response.End
				End If 
			End If 
		Else
			Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
			response.End
		End If 
	Else '//금일 모두 응모
		Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
		response.End
	End If 
ElseIf mode = "snschk" Then '//SNS 클릭
	'//응모내역
	sqlStr = ""
	sqlStr = sqlStr & " SELECT TOP 1 sub_opt1, isnull(sub_opt3, '') as sub_opt3 "
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript "
	sqlStr = sqlStr & " WHERE evt_code='"& eCode &"'"
	sqlStr = sqlStr & " and userid='"& LoginUserid &"' and datediff(day, regdate, getdate()) = 0 "
	rsget.Open sqlStr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1	= rsget(0) '//응모1차 or 2차 응모여부
		snschk	= rsget(1) '//2차 응모 확인용 null , ka , fb , tw
	Else
		'//최초응모
		result1 = ""
		snschk = ""
	End IF
	rsget.close

	If result1 = "" and snschk = "" Then 																	'참여 이력이 없음 - 응모후 이용 하시오
		Response.Write "Err|none"
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "") Then														'1회 참여시 
		sqlStr = ""
		sqlStr = sqlStr & " UPDATE db_event.dbo.tbl_event_subscript SET " & vbcrlf
		sqlStr = sqlStr & " sub_opt3 = '"& snsnum &"'" & vbcrlf
		sqlStr = sqlStr & " WHERE evt_code = "& eCode &" and userid = '"& LoginUserid &"' and datediff(day, regdate, getdate()) = 0 " & vbcrlf
		dbget.execute sqlStr 
		If snsnum = "tw" Then
			Response.write "OK|tw|tw"
		ElseIf snsnum = "fb" Then
			Response.write "OK|fb|fb"
		ElseIf snsnum = "ka" Then
			Response.write "OK|ka|ka"
		Else
			Response.write "error"
		End If
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb") Then	'오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!
		Response.Write "Err|end|"
		dbget.close()	:	response.End
	Else
		Response.write "error"
	End If
Else
	Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->