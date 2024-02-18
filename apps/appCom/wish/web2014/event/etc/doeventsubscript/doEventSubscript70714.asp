<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2016.05.11 유태욱 생성
'	Description : 비밀의방 비번 응모 페이지
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	Dim eCode, sqlstr
	Dim nowdate, refip, refer, renloop, subscriptcount
	Dim cnt, couponid, device, LoginUserid
	Dim pdName1, pdName2, pdName3
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3
	Dim evtItemCode1, evtItemCode2, evtItemCode3
	Dim result1, result2, result3, mode, md5userid, evtUserCell
	
	If isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = now()
'													nowdate = "2016-05-18 10:10:00"

	LoginUserid = getencloginuserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66124
		couponid = 2787
	Else
		eCode   =  70714
		couponid = 859
	End If

	subscriptcount=0

	'//본인 참여 여부
	if LoginUserid<>"" then
		sqlstr = "select count(*) as cnt "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
''		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,21) = '" &left(nowdate,10)&"' "
		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		rsget.Open sqlstr, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			subscriptcount = rsget("cnt")
		End IF
		rsget.close
	end if

	'//응모 확율
	randomize
	renloop=int(Rnd*10000)+1

dim win1min, win1max, win2min, win2max, win3min, win3max
	'1등 당첨범위
	win1min	=	9900
	win1max	=	10000
	
	'2등 당첨범위
	win2min	=	5800
	win2max	=	6001
	
	'3등 당첨범위			'' 10 %
	win3min	=	4000
	win3max	=	5004

'''''''''''''''''''''''''''''''''''''''''''''기본값'''''''''''''''''''''''''''''검색용단어
'구분1 : 1등				renloop >= 9900 and renloop <= 10000		1	%		폴라로이드			10000
	
'구분2 : 2등				renloop >= 5800 and renloop <= 6001		2%		아이리버			9501

'구분3 : 3등				renloop >= 4500 and renloop <= 5004		5%		베스킨

'꽝	: 무배쿠폰 																COUPON

''''''''''''''''''''''''''''''''''''''''''''운영	2016-07-06''''''''''''''''''검색용단어
'구분1 : 1등				renloop >= 9900 and renloop <= 10000		1	%		폴라로이드			10000
	
'구분2 : 2등				renloop >= 5800 and renloop <= 6001		2%		아이리버			9501

'구분3 : 3등				renloop >= 4500 and renloop <= 5004		5%		베스킨

'꽝	: 무배쿠폰 																COUPON

	md5userid = md5(LoginUserid&"10")

	'상품정보
	pdName1 = "폴라로이드"
	pdName2 = "아이리버"
	pdName3 = "베스킨"
	evtItemCode1 = "1111111"
	evtItemCode2 = "2222222"
	evtItemCode3 = "3333333"

	if left(nowdate,10)="2016-05-17" then
		evtItemCnt1 = 1	'폴라로이드
		evtItemCnt2 = 2	'아이리버
		evtItemCnt3 = 200	'베스킨
	elseif left(nowdate,10)="2016-05-18" then
		evtItemCnt1 = 1	'폴라로이드
		evtItemCnt2 = 2	'아이리버
		evtItemCnt3 = 321	'베스킨
	elseif left(nowdate,10)="2016-05-19" then
		evtItemCnt1 = 0	'폴라로이드
		evtItemCnt2 = 1	'아이리버
		evtItemCnt3 = 232	'베스킨
	elseif left(nowdate,10)="2016-05-20" then
		evtItemCnt1 = 0	'폴라로이드
		evtItemCnt2 = 1	'아이리버
		evtItemCnt3 = 200	'베스킨
	elseif left(nowdate,10)="2016-05-23" then
		evtItemCnt1 = 0	'폴라로이드
		evtItemCnt2 = 1	'아이리버
		evtItemCnt3 = 200	'베스킨
	else
		evtItemCnt1 = 0	'폴라로이드
		evtItemCnt2 = 0	'아이리버
		evtItemCnt3 = 0	'베스킨
	end if

	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(nowdate,10)>="2016-05-17" and left(nowdate,10)<"2016-05-24") Then								''응모기간 수정
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	''// 주말 제외
	if mode <> "kakao" then
		If left(nowdate,10)="2016-05-21" or left(nowdate,10)="2016-05-22" Then
			Response.Write "Err|주말엔 문을 열 수 없습니다."
			Response.End
		End If


		'// 해당일자 10시부터 응모 가능함, 그 이전에는 응모불가
		if left(nowdate,10)="2016-05-17" then
			If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then
				Response.Write "Err|월요일은 오전 10시부터 응모하실 수 있습니다."
				Response.End
			End If
		End if
	end if

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

If mode = "add" Then '//응모하기 버튼 클릭
	if subscriptcount > 0 then
		Response.Write "Err|오늘은 이미 응모 하셨습니다."
		response.End
	else
		If renloop >= win1min and renloop <= win1max Then '1등 난수 당첨시-	폴라로이드
			'// 응모내역 검색
'			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
'			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
'			sqlstr = sqlstr & " where evt_code="& eCode &""
'			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
'			rsget.Open sqlstr, dbget, 1
'			If Not(rsget.bof Or rsget.Eof) Then
'				'// 기존에 응모 했을때 값
'				result1 = rsget(0) '//응모회수 1,2
'				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
'				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
'			Else
'				'// 최초응모
'				result1 = ""
'				result2 = ""
'				result3 = ""
'			End IF
'			rsget.close
		
			'// 현재 재고 파악(1등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode1&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
'			If result1="" And result2="" And result3="" Then
			if subscriptcount < 1 then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		 
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log01","전화번호중복비당첨",device)
	
					Response.write "OK|<div class='winCoupon'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick='get_coupon(); return false;' class='btnCoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_coupon.png' alt='쿠폰 다운받기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
		
				If cnt < evtItemCnt1 then
					'// 최초응모자이고, 1등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode1&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log02",pdName1,device)
		
					Response.write "OK|<div class='winItem'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_01.png' alt='디지털 즉석 카메라 당첨을 축하합니다. 상품은 기본 배송지로 발송될 예정입니다' /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnAddress'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_address.png' alt='기본 배송지 확인하기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 1등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log03","비당첨",device)
		
					Response.write "OK|<div class='winCoupon'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick='get_coupon(); return false;' class='btnCoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_coupon.png' alt='쿠폰 다운받기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			Else
				Response.Write "Err|오늘은 이미 응모 하셨습니다."
				response.End
			End If
		ElseIf renloop >= win2min and renloop <= win2max Then '2등 난수 당첨시	-아이리버
			'// 응모내역 검색
'			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
'			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
'			sqlstr = sqlstr & " where evt_code="& eCode &""
'			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
'			rsget.Open sqlstr, dbget, 1
'			If Not(rsget.bof Or rsget.Eof) Then
'				'// 기존에 응모 했을때 값
'				result1 = rsget(0) '//응모회수 1,2
'				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
'				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
'			Else
'				'// 최초응모
'				result1 = ""
'				result2 = ""
'				result3 = ""
'			End IF
'			rsget.close
		
			'// 현재 재고 파악(2등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode2&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
'			If result1="" And result2="" And result3="" Then
			if subscriptcount < 1 then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log07","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='winCoupon'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick='get_coupon(); return false;' class='btnCoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_coupon.png' alt='쿠폰 다운받기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt2 then
					'// 최초응모자이고, 2등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log08",pdName2,device)
		
					Response.write "OK|<div class='winItem'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_02.png' alt='아이리버 불루투스 스피커 당첨을 축하합니다. 상품은 기본 배송지로 발송될 예정입니다' /></p><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnAddress'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_address.png' alt='기본 배송지 확인하기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 2등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log09","비당첨",device)
		
					Response.write "OK|<div class='winCoupon'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick='get_coupon(); return false;' class='btnCoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_coupon.png' alt='쿠폰 다운받기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			Else
				Response.Write "Err|오늘은 이미 응모 하셨습니다."
				response.End
			End If
		ElseIf renloop >= win3min and renloop <= win3max Then '3등 난수 당첨시	베스킨
			'// 응모내역 검색
'			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
'			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
'			sqlstr = sqlstr & " where evt_code="& eCode &""
'			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
'			rsget.Open sqlstr, dbget, 1
'			If Not(rsget.bof Or rsget.Eof) Then
'				'// 기존에 응모 했을때 값
'				result1 = rsget(0) '//응모회수 1,2
'				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
'				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
'			Else
'				'// 최초응모
'				result1 = ""
'				result2 = ""
'				result3 = ""
'			End IF
'			rsget.close
		
			'// 현재 재고 파악(3등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode3&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
'			If result1="" And result2="" And result3="" Then
			if subscriptcount < 1 then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함------전체 기간으로 변경해야함-----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log13","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='winCoupon'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick='get_coupon(); return false;' class='btnCoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_coupon.png' alt='쿠폰 다운받기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt3 then
					'// 최초응모자이고, 3등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log14",pdName3,device)
		
					Response.write "OK|<div class='winItem'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_03.png' alt='베스킨라빈스 싱글레귤러 당첨을 축하합니다. 상품은 기본 배송지로 발송될 예정입니다' /></p><div class='phone'><div><span>"&evtUserCell&"</span><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnmodify'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_modify.png' alt='수정' /></a></div></div><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 3등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid, renloop,"log15","비당첨",device)
		
					Response.write "OK|<div class='winCoupon'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick='get_coupon(); return false;' class='btnCoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_coupon.png' alt='쿠폰 다운받기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='레이어 팝업 닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			Else
				Response.Write "Err|오늘은 이미 응모 하셨습니다."
				response.End
			End If
		else
			'//비당첨
			'// 응모내역 검색
'			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
'			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
'			sqlstr = sqlstr & " where evt_code="& eCode &""
'			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
'			rsget.Open sqlstr, dbget, 1
'			If Not(rsget.bof Or rsget.Eof) Then
'				'// 기존에 응모 했을때 값
'				result1 = rsget(0) '//응모회수 1,2
'				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
'				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
'			Else
'				'// 최초응모
'				result1 = ""
'				result2 = ""
'				result3 = ""
'			End IF
'			rsget.close
		
			'// 최초 응모자면
'			If result1="" And result2="" And result3="" Then
			if subscriptcount < 1 then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
		 
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid, renloop,"log25","비당첨",device)
		
				Response.write "OK|<div class='winCoupon'><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/img_item_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick='get_coupon(); return false;' class='btnCoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2016/70714/btn_coupon.png' alt='쿠폰 다운받기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='레이어 팝업 닫기' /></button></div>"
				dbget.close()	:	response.End
			Else
				Response.Write "Err|오늘은 이미 응모 하셨습니다."
				response.End
			End If
		end if
	end if
ElseIf mode="coupon" Then
	'//쿠폰 발급
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
	sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','3','2000','쉿! 무료배송쿠폰','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	Call fnCautionEventLog(eCode,LoginUserid, renloop,"log28","무배쿠폰발급",device)

	Response.write "SUCCESS"
	dbget.close()	:	response.end
Else
	Response.Write "Err|잘못된 접속 입니다. 잠시 후 다시 시도해 주세요."
	response.End
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->