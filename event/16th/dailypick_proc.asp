<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 16주년 이벤트 골라보쑈
' History : 2017-09-28 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim RvConNum, couponidx, RvSelNum
dim bonuscouponexistscount,  currenttime, renloop , renloop2 , winlose
Dim eCode, LoginUserid, mode, sqlStr, result1, result2, result3, device, snsnum, snschk, evtUserCell, refip, refer, md5userid
dim ePrize1,ePrize2,ePrize3,ePrize4,ePrize5
	
IF application("Svr_Info") = "Dev" THEN
	eCode 		= "67438"
	couponidx	= "2858"
Else
	eCode 		= "80410"
	couponidx	= "1006"
End If

currenttime = date()

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

'// expiredate
'If not(currenttime >= "2017-09-27" and currenttime < "2017-10-26") Then
If not(currenttime >= "2017-10-10" and currenttime < "2017-10-26") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

'// 상품별 한정 수량
	ePrize1	= 1		
	ePrize2	= 50
	ePrize3	= 29
	ePrize4	= 120
	ePrize5	= 800
	
'//접근 device
	If isapp = "1" then
		device = "A"
	Else
		device = "M"
	End If 

'------------------------------------------------------------------------------------------------------------
'---기능
'------------------------------------------------------------------------------------------------------------
''상품명
Function itemprizename(v)
	Select Case CStr(v)
		Case "1"
			itemprizename = "다이슨 V8 앱솔루트 플러스"
		Case "2"
			itemprizename = "오각뿔캔들"
		Case "3"
			itemprizename = "[위글위글] Bluetooth Speaker"
		Case "4"
			itemprizename = "오버액션토끼 가방고리(3종)"
		Case "5"
			itemprizename = "Cablebite(케이블바이트)"
		Case Else
			itemprizename = "Cablebite(케이블바이트)"
	end Select
End Function

''처리 순서 0
''전화번호 중복당첨 꽝처리
Function duplnum(r)
	Dim dsqlStr
	If event_userCell_Selection_nodate(evtUserCell, eCode) > 0 Then '//전화번호 중복 당첨 꽝처리 - 날짜 없음
		If r = 1 Then 
			dsqlStr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
			dsqlStr = dsqlStr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
			dbget.execute dsqlStr
		Else
			dsqlStr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
			dsqlStr = dsqlStr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			dbget.execute dsqlStr
		End If 

		'// 해당 유저의 로그값 집어넣는다.
		dsqlStr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
		dsqlStr = dsqlStr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '전화번호중복비당첨처리', '"&device&"')"
		dbget.execute dsqlStr

		Response.write returnvalue2(r)
		dbget.close()	:	response.End
	End If
End Function 

''처리순서 1
''초기 당첨 여부 (0.1% 의 확률로 당첨 여부 결정)
Function floor1st()
	Dim winlose
	randomize
	renloop=int(Rnd*2000)+1

	if renloop < 11 then	''10%
		winlose = true
	else
		winlose = false '//테스트시 true로
	end If
	
	floor1st = winlose
End Function

''처리순서 2
''초기 당첨 이후 상품 선택
Function prizepick(r)
	Dim pResult ''1 , 2 , 3 , 4 , 5 :성공 // 0 : 실패
	randomize
	renloop2=int(Rnd*1000)+1

	If renloop2 = 1 Then '//다이슨
		pResult = prizeproc(1,r)
	ElseIf renloop2 > 1 And renloop2 <= 250 Then '//오각뿔캔들
		pResult = prizeproc(2,r)
	ElseIf renloop2 > 250 And renloop2 <= 990 Then '//블루투스 스피커
		pResult = prizeproc(3,r)
	ElseIf renloop2 > 990 And renloop2 <= 999 Then '//오버액션토끼
		pResult = prizeproc(4,r)
	ElseIf renloop2 > 999 And renloop2 <= 1000 Then '//케이블 바이트
		pResult = prizeproc(5,r)
	End If
	prizepick = pResult
End Function

''처리순서 2-1
''상품 카운트
Function prizeproc(v,r)
	Dim isqlStr , icnt , cResult
	sqlstr = "select count(*) as icnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and sub_opt2 = "& v &""			
	rsget.Open sqlstr, dbget, 1
		icnt = rsget("icnt")
	rsget.close

	If v = 1 Then
		If icnt >= ePrize1 Then '// 1이상
			'//꽝처리 return => false
			cResult = lose_proc(r)
		Else
			'//1등 입력 처리 return => true
			cResult = win_proc(v,r)
		End If 
	ElseIf v = 2 Then
		If icnt >= ePrize2 Then '// 50이상
			'//꽝처리 return => false
			cResult = lose_proc(r)
		Else
			'//2등 입력 처리 return => true
			cResult = win_proc(v,r)
		End If
	ElseIf v = 3 Then
		If icnt >= ePrize3 Then '// 29이상
			'//꽝처리 return => false
			cResult = lose_proc(r)
		Else
			'//3등 입력 처리 return => true
			cResult = win_proc(v,r)
		End If
	ElseIf v = 4 Then
		If icnt >= ePrize4 Then '// 120이상
			'//꽝처리 return => false
			cResult = lose_proc(r)
		Else
			'//4등 입력 처리 return => true
			cResult = win_proc(v,r)
		End If
	ElseIf v = 5 Then
		If icnt >= ePrize5 Then '// 800이상
			'//꽝처리 return => false
			cResult = lose_proc(r)
		Else
			'//5등 입력 처리 return => true
			cResult = win_proc(v,r)
		End If
	End If 
	prizeproc = cResult
End Function

''처리순서 2-1-1
''당첨처리
Function win_proc(v,r)
	Dim wsqlStr
	If r = 1 Then '//최초응모
		'// 최초응모자 당첨처리
		wsqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
		wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"& v &"', '"&device&"')"
		dbget.execute wsqlstr
	Else '// 2번째 응모자
		'// SNS 공유자 당첨처리
		wsqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"& v &"'" + vbcrlf
		wsqlstr = wsqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		dbget.execute wsqlstr
	End If 

	'// 해당 유저의 로그값 집어넣는다.
	wsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1,  value3, device)" + vbcrlf
	wsqlstr = wsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '"& itemprizename(v) &"', '"&device&"')"
	dbget.execute wsqlstr

	win_proc = v
End Function

''처리순서 2-1-2
''꽝처리
Function lose_proc(r)
	Dim lsqlStr
	If r = 1 Then '//최초응모
		'// 최초응모자 꽝처리
		lsqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
		lsqlstr = lsqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
		dbget.execute lsqlstr
	Else
		'// 두번째응모자 꽝처리
		lsqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
		lsqlstr = lsqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		dbget.execute lsqlstr
	End If 

	'// 해당 유저의 로그값 집어넣는다.
	lsqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value1 ,  value3, device)" + vbcrlf
	lsqlstr = lsqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"','"&renloop&"', '무료배송쿠폰', '"&device&"')"
	dbget.execute lsqlstr

	lose_proc = 0
End Function

''처리순서 3
''메시지 리턴 처리 'html
Function returnvalue(v)
	Select Case CStr(v)
		Case "1"
			returnvalue = "OK|<div class='win'><div class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_win_1.png' alt='다이슨 V8 앱솔루트 플러스 당첨' /></div><p class='code'>"& md5userid &"</p><a href='/my10x10/userinfo/confirmuser.asp' class='btn-mypage'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/btn_mypage.png' alt='개인정보 확인하러가기' /></a></div>"
		Case "2"
			returnvalue = "OK|<div class='win'><div class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_win_2.png' alt='오각뿔캔들 당첨' /></div><p class='code'>"& md5userid &"</p><a href='/my10x10/userinfo/confirmuser.asp' class='btn-mypage'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/btn_mypage.png' alt='개인정보 확인하러가기' /></a></div>"
		Case "3"
			returnvalue = "OK|<div class='win'><div class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_win_3.png' alt='위글위글 블루투스 스피커 당첨' /></div><p class='code'>"& md5userid &"</p><a href='/my10x10/userinfo/confirmuser.asp' class='btn-mypage'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/btn_mypage.png' alt='개인정보 확인하러가기' /></a></div>"
		Case "4"
			returnvalue = "OK|<div class='win'><div class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_win_4.png' alt='오버액션토끼 가방고리 당첨' />"& md5userid &"</p><a href='/my10x10/userinfo/confirmuser.asp' class='btn-mypage'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/btn_mypage.png' alt='개인정보 확인하러가기' /></a></div>"
		Case "5"
			returnvalue = "OK|<div class='win'><div class='item'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/img_win_5.png' alt='케이블바이트 당첨' /></div><p class='code'>"& md5userid &"</p><a href='/my10x10/userinfo/confirmuser.asp' class='btn-mypage'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/btn_mypage.png' alt='개인정보 확인하러가기' /></a></div>"
		Case Else
			returnvalue = "OK|<div><a href='' onclick='get_coupon(); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/layer_gollabo_fail.png' alt='앗 당첨되지 않았어요.' /></a></div>"
	end Select
End Function

Function returnvalue2(v)
	Select Case CStr(v)
		Case "1"
			returnvalue2 = "OK|<div class='onemore'><p><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/layer_gollabo_fail_sns.png' alt='앗 당첨되지 않았어요' /></p><a href='' onclick='get_coupon(); return false;' class='btn-download'>쿠폰 다운받기</a><ul><li><a href='' onclick='sharesns(""fb"");return false;'>페이스북으로 공유</a></li><li><a href='' onclick='sharesns(""ka"");return false;'>카카오톡으로 공유</a></li><li><a href='' onclick='sharesns(""pt"");return false;'>핀터레스트로 공유</a></li></ul></div>"
		Case "2"
			returnvalue2 = "OK|<div><a href='' onclick='get_coupon(); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/layer_gollabo_fail.png' alt='앗 당첨되지 않았어요.' /></a></div>"
		Case Else
			returnvalue2 = "OK|<div><a href='' onclick='get_coupon(); return false;'><img src='http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/layer_gollabo_fail.png' alt='앗 당첨되지 않았어요.' /></a></div>"
	end Select
End Function

Function returnlink(v)
	Select Case CStr(v)
		Case "1"
			If isapp = "1" Then 
				returnlink = "<a href='' onclick=""fnAPPpopupProduct('1750502');return false;"" class='color-red'>축! 당첨<i>▶</i></a>"
			Else
				returnlink = "<a href='/category/category_itemPrd.asp?itemid=1750502' class='color-red'>축! 당첨<i>▶</i></a>"
			End If 
		Case "2"
			If isapp = "1" Then
				returnlink = "<a href='' onclick=""fnAPPpopupProduct('1474359');return false;"" class='color-red'>축! 당첨<i>▶</i></a>"
			Else
				returnlink = "<a href='/category/category_itemPrd.asp?itemid=1474359' class='color-red'>축! 당첨<i>▶</i></a>"
			End If 
		Case "3"
			If isapp = "1" Then 
				returnlink = "<a href='' onclick=""fnAPPpopupProduct('1758010');return false;"" class='color-red'>축! 당첨<i>▶</i></a>"
			Else 
				returnlink = "<a href='/category/category_itemPrd.asp?itemid=1758010' class='color-red'>축! 당첨<i>▶</i></a>"
			End If 
		Case "4"
			If isapp = "1" Then 
				returnlink = "<a href='' onclick=""fnAPPpopupProduct('1768120');return false;"" class='color-red'>축! 당첨<i>▶</i></a>"
			Else
				returnlink = "<a href='/category/category_itemPrd.asp?itemid=1768120' class='color-red'>축! 당첨<i>▶</i></a>"
			End If 
		Case "5"
			If isapp = "1" Then 
				returnlink = "<a href='' onclick=""fnAPPpopupProduct('1759439');return false;"" class='color-red'>축! 당첨<i>▶</i></a>"
			Else
				returnlink = "<a href='/category/category_itemPrd.asp?itemid=1759439' class='color-red'>축! 당첨<i>▶</i></a>"
			End If 
		Case Else
			returnlink = "꽝"
	End Select
End function
'------------------------------------------------------------------------------------------------------------
'---처리
'------------------------------------------------------------------------------------------------------------
If mode = "add" Then 		'//응모버튼 클릭
	Dim vResult : vResult = 0  '//최종결과 default 0 

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
			Response.write returnvalue2(1) '//결과 html
			dbget.close()	:	response.End
		End If 

		duplnum(1) '//전화번호 걸러내기 통과후 아래로

		If floor1st() Then '//1차 당첨 or 비당첨
			vResult = prizepick(1) '//당첨후 상품 처리 '// vResult = 1 , 2 , 3 , 4 , 5 성공 , vResult = 0 꽝
			Response.write returnvalue(vResult) '//결과 html
			dbget.close()	:	response.End
		Else
			vResult = lose_proc(1) '//꽝처리
			Response.write returnvalue2(1) '//결과 html
			dbget.close()	:	response.End
		End If
	ElseIf result1 = 1 Then '//2차 응모
		If result3 <> "" Then '//sns 공유 체크

			'//어뷰징 아웃!
			if userBlackListCheck(LoginUserid) Then
				'Response.write "이색히야 넌 영원히 꽝이야"
				lose_proc(2) '//꽝처리
				Response.write returnvalue2(2) '//결과 html
				dbget.close()	:	response.End
			End If 

			duplnum(2) '//전화번호 걸러내기 통과후 아래로

			If result2 > 0 Then '//1차 당첨이력이 있을경우
				vResult = lose_proc(2) '//꽝처리
				Response.write returnvalue2(2) '//결과 html 2차 꽝 결과
				dbget.close()	:	response.End
			else
				If floor1st() Then '//2차 당첨 or 비당첨
					vResult = prizepick(2) '//당첨후 상품 처리 '// vResult = 1 , 2 , 3 , 4 , 5 성공 , vResult = 0 꽝
					Response.write returnvalue(vResult) '//결과 html vResult 결과
					dbget.close()	:	response.End
				Else
					vResult = lose_proc(2) '//꽝처리
					Response.write returnvalue2(2) '//결과 html 2차 꽝 결과
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
ElseIf mode="coupon" Then

	'If not(currenttime >= "2017-09-27" and currenttime < "2017-10-26") Then
	If not(currenttime >= "2017-10-10" and currenttime < "2017-10-26") Then
		Response.Write "DATENOT"
		dbget.close() : Response.End
	End If

	if LoginUserid="" then
		Response.Write "USERNOT"
		dbget.close() : Response.End
	End If

	bonuscouponexistscount=getbonuscouponexistscount(LoginUserid, couponidx, "", "", left(currenttime,10))
	if bonuscouponexistscount>2 then
		Response.write "MAXCOUPON"
		dbget.close() : Response.End
	end if

	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , isnull(sub_opt3,'') as sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "

	'response.write sqlstr & "<br>"
	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0,1 
		result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
	End IF
	rsget.close

	If result1 = "" Or isnull(result1) Then
		Response.write "NOT1" '//참여 이력이 없음 - 응모후 이용 하시오
		dbget.close()	:	response.End
	else
		'//쿠폰 발급
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
		sqlstr = sqlstr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'"& Left(Date(),10) &" 00:00:00','"& Left(Date(),10) &" 23:59:59',couponmeaipprice,validsitename" + vbcrlf
		sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
		sqlstr = sqlstr & " 	where idx in ("& couponidx &")"
		'response.write sqlstr & "<br>"
		dbget.execute sqlstr

		''로그저장
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log](evt_code, userid, refip, value1, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "', 'coupon', '"& device &"')"
	
		'response.write sqlstr & "<br>"
		dbget.execute sqlstr

		Response.write "SUCCESS"
		dbget.close()	:	response.end
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
		ElseIf snsnum = "pt" Then
			Response.write "OK|pt|pt"
		Else
			Response.write "error"
		End If
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb" or snschk = "pt") Then	'오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!
		Response.Write "Err|end|"
		dbget.close()	:	response.End
	Else
		Response.write "error"
	End If
ElseIf mode = "mypick" Then '//응모 이력
	Dim returnhtml

	sqlstr = ""
	sqlstr = sqlstr & " SELECT regdate , sub_opt1 , sub_opt2 "
	sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " WHERE evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' "
	sqlstr = sqlstr & " order by regdate asc "
	rsget.Open sqlstr, dbget, 1
	If Not(rsget.bof Or rsget.Eof) Then
		Do Until rsget.eof
			returnhtml = returnhtml & "<tr><td>"& formatdate(rsget("regdate"),"00.00") & "("& Left(weekDayName(weekDay(rsget("regdate"))),1)&")"  &"</td><td>"& chkiif(rsget("sub_opt1")<>"","응모완료","")& "("& formatdate(rsget("regdate"),"00:00") &")" &"</td><td>"& returnlink(rsget("sub_opt2")) &"</td></tr>"
		rsget.movenext
		Loop
	End IF
	rsget.close

	Response.write "OK|	<p class='user'><strong>"& LoginUserid &"</strong> 님의 응모 현황</p><div class='list'><table><colgroup><col width='133px' /><col width='181px' /><col width='130px' /></colgroup>"& returnhtml &"</table></div>"
	dbget.close()	:	response.End
Else
	Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
	dbget.close() : Response.End
End If	
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->