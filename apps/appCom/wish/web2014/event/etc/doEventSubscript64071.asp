<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.06.25 유태욱 생성
'	Description : (초)능력자들
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
'	Dim remaincnt
	dim	DayName1, DayName2, DayName3, DayName4
	Dim cnt, evtimagenum, couponid
	Dim eCode, sqlstr
	Dim nowdate, refip, refer, renloop
	Dim LoginUserid
	Dim pdName1, pdName2, pdName3, pdName4
	Dim evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4
	Dim result1, result2, result3, mode, md5userid, evtUserCell
	Dim device
	
	If isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = now()
'	nowdate = "2015-07-06 10:10:00"

	LoginUserid = getLoginUserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63801
		couponid = 2723
	Else
		eCode   =  64071
		couponid = 746
	End If

	'//응모 확율
	randomize
	renloop=int(Rnd*10000)+1

'''''''''''''''''''''''''''''''''''''''''''''기본값'''''''''''''''''''''''''''''검색용단어
''구분1 : 1등				renloop > 10000 and renloop < 10002		0	%		japan			10000
''구분2 : 2등				renloop > 9500 and renloop < 9502		0.01%		pink			9501

''구분3 : 3등				renloop >= 5000 and renloop < 5001		0.01%		airframe
''구분4 : 4등 				renloop >= 1 and renloop < 200			2%			pocari

''꽝	: 무배쿠폰 																COUPON


''''''''''''''''''''''''''''''''''''''''''''운영	2015-07-06''''''''''''''''''검색용단어
''구분1 : 1등				renloop > 9950 and renloop < 10001		0  %		japan			10000
''구분2 : 2등				renloop > 9500 and renloop < 9502		0.01%		pink			9501

''구분3 : 3등				renloop >= 6000 and renloop < 7000		2%			airframe
''구분4 : 4등 				renloop >= 1 and renloop < 5000			25%			pocari

''꽝	: 무배쿠폰 																COUPON

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(LoginUserid&"10")

	''당첨레이어 구분
	If left(nowdate,10)=<"2015-06-29" or left(nowdate,10)="2015-07-06" Then
		DayName1 = "01"
		DayName2 = "02"
		DayName3 = "03"
		DayName4 = "04"
	elseif left(nowdate,10)="2015-06-30" or left(nowdate,10)="2015-07-07" Then
		DayName1 = "05"
		DayName2 = "06"
		DayName3 = "07"
		DayName4 = "08"
	elseif left(nowdate,10)="2015-07-01" or left(nowdate,10)="2015-07-08" Then
		DayName1 = "09"
		DayName2 = "10"
		DayName3 = "11"
		DayName4 = "12"
	elseif left(nowdate,10)="2015-07-02" or left(nowdate,10)="2015-07-09" Then
		DayName1 = "13"
		DayName2 = "14"
		DayName3 = "15"
		DayName4 = "16"
	elseif left(nowdate,10)="2015-07-03" or left(nowdate,10)>="2015-07-10" Then
		DayName1 = "17"
		DayName2 = "18"
		DayName3 = "19"
		DayName4 = "20"
	end if

	If left(nowdate,10)<"2015-06-30" or left(nowdate,10)="2015-07-04" or left(nowdate,10)="2015-07-05" or left(nowdate,10)="2015-07-06" Then
		evtimagenum	=	"01"

		pdName1 = "에어휠"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "드론캠"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "선풍기"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 299

		pdName4 = "17차"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2688

	elseif left(nowdate,10)="2015-06-30" Then
		evtimagenum	=	"02"

		pdName1 = "아이폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "배터리"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "피규어"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 700

		pdName4 = "핫식스"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2297

	elseif left(nowdate,10)="2015-07-07" Then
		evtimagenum	=	"02"

		pdName1 = "아이폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "배터리"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "피규어"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 300

		pdName4 = "핫식스"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2697

	elseif left(nowdate,10)="2015-07-01" or left(nowdate,10)="2015-07-08" Then
		evtimagenum	=	"03"

		pdName1 = "lgtv"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "시계"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "비밀의정원"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 100

		pdName4 = "태엽토이"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2898			''원래 2897 인데 1일꺼 1개 남은거 추가됨

	elseif left(nowdate,10)="2015-07-02" Then
		evtimagenum	=	"04"

		pdName1 = "아이패드"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "레이밴"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "월리퍼즐"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 700

		pdName4 = "하리보"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2297

	elseif left(nowdate,10)="2015-07-09" Then
		evtimagenum	=	"04"

		pdName1 = "아이패드"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "레이밴"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "월리퍼즐"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 300

		pdName4 = "하리보"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2788		''원래 2697개 인데 2일꺼 91개 남은거 추가됨

	elseif left(nowdate,10)="2015-07-03" or left(nowdate,10)>="2015-07-10" Then
		evtimagenum	=	"05"

		pdName1 = "여행100만"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "스마트빔"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "고잉캔들"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 350

		pdName4 = "설레임"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2647

	end if

	'// 나간 수량
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// 솔드아웃
	if left(nowdate,10)="2015-07-06" then
		If cnt > 2990 Then
			Response.Write "Err|오늘은 마감되었습니다.!"
			Response.End
		End If
	elseif left(nowdate,10)="2015-07-08" then
		If cnt > 3000 Then
			Response.Write "Err|오늘은 마감되었습니다.!"
			Response.End
		End If
	elseif left(nowdate,10)="2015-07-09" then
		If cnt > 3090 Then
			Response.Write "Err|오늘은 마감되었습니다.!"
			Response.End
		End If
	else
		If cnt > 2999 Then
			Response.Write "Err|오늘은 마감되었습니다.!"
			Response.End
		End If
	end if

	'// expiredate
	If not(left(nowdate,10)>="2015-06-29" and left(nowdate,10)<"2015-07-11") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	''// 주말 제외
	If left(nowdate,10)="2015-07-04" or left(nowdate,10)="2015-07-05" Then
		Response.Write "Err|주말엔 쉽니다."
		Response.End
	End If

	'// 해당일자 10시부터 응모 가능함, 그 이전에는 응모불가
	if left(nowdate,10)="2015-06-29" or left(nowdate,10)="2015-07-06" then
		If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then
			Response.Write "Err|월요일은 오전 10시부터 응모하실 수 있습니다."
			Response.End
		End If
	End if

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

	'// STAFF 여부 체크
'	if request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW
'		Response.write "Err|스태프는 참여하실 수 없습니다."
'		dbget.close() : Response.End
'	end If

	'// 티켓 발행넘버용	no.1~3000
'	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0 And sub_opt2<>'5555555' "
'	rsget.Open sqlstr, dbget, 1
'		remaincnt = rsget(0)
'	rsget.close

If mode = "add" Then '//응모하기 버튼 클릭
	if left(nowdate,10)="2015-07-10" then
	
		If renloop > 9950 and renloop < 10001 Then ''1등 난수 당첨시(0.01%)	japan
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(1등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode1&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log01","전화번호중복비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
		
				If cnt < evtItemCnt1 then
					'// 최초응모자이고, 1등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode1&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log02",pdName1,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName1&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 1등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log03","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log04","전화번호중복비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
		
					If cnt < evtItemCnt1 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 1등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode1&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log05","2번째도전1등당첨",device)
		
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName1&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 1등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log06","비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		ElseIf renloop > 9500 and renloop < 9502 Then ''2등 난수 당첨시	pink
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(2등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode2&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log07","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt2 then
					'// 최초응모자이고, 2등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log08",pdName2,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName2&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 2등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log09","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log10","전화번호중복비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt < evtItemCnt2 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 2등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode2&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log11","2번째도전2등당첨",device)
		
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName2&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 2등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log12","비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		ElseIf renloop >= 6000 and renloop < 7000 Then ''3등 난수 당첨시	airframe
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(3등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode3&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함------전체 기간으로 변경해야함-----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log13","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt3 then
					'// 최초응모자이고, 3등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log14",pdName3,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName3&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 3등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log15","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log16","전화번호중복비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt < evtItemCnt3 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 3등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode3&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log17","2번째도전3등당첨",device)
	
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName3&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 3등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log18","비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		ElseIf renloop >= 1 and renloop < 5000 Then ''4등 난수 당첨시	pocari
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(4등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode4&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log19","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt4 then
					'// 최초응모자이고, 4등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode4&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log20",pdName4,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName4&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 4등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
	
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log21","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log22","전화번호중복비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt < evtItemCnt4 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 4등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode4&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log23","2번째도전4등당첨",device)
	
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName4&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 4등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log24","비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		else
			''//비당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			''// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
		 
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log25","비당첨",device)
		
				Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
				dbget.close()	:	response.End
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log26","비당첨(2번째도전)",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		end if
	else
		If renloop > 10000 and renloop < 10002 Then ''1등 난수 당첨시(0.01%)	japan
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(1등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode1&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log01","전화번호중복비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
		
				If cnt < evtItemCnt1 then
					'// 최초응모자이고, 1등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode1&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log02",pdName1,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName1&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 1등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log03","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log04","전화번호중복비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
		
					If cnt < evtItemCnt1 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 1등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode1&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log05","2번째도전1등당첨",device)
		
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName1&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 1등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log06","비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		ElseIf renloop > 9500 and renloop < 9502 Then ''2등 난수 당첨시	pink
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(2등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode2&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log07","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt2 then
					'// 최초응모자이고, 2등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log08",pdName2,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName2&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 2등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log09","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log10","전화번호중복비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt < evtItemCnt2 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 2등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode2&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log11","2번째도전2등당첨",device)
		
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName2&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 2등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
		
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log12","비당첨(2번째 도전)",device)
		
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		ElseIf renloop >= 5000 and renloop < 5001 Then ''3등 난수 당첨시	airframe
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(3등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode3&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함------전체 기간으로 변경해야함-----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log13","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt3 then
					'// 최초응모자이고, 3등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log14",pdName3,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName3&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 3등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log15","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log16","전화번호중복비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt < evtItemCnt3 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 3등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode3&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log17","2번째도전3등당첨",device)
	
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName3&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 3등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log18","비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		ElseIf renloop >= 1 and renloop < 200 Then ''4등 난수 당첨시	pocari
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			'// 현재 재고 파악(4등)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode4&"' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget(0)
			rsget.close
		
			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log19","전화번호중복비당첨처리",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				End If
	
				If cnt < evtItemCnt4 then
					'// 최초응모자이고, 4등 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode4&"', '"&device&"')"
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log20",pdName4,device)
		
					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName4&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 4등 남은게 없으면 걍 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
	
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log21","비당첨",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				end if
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------
					If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log22","전화번호중복비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					End If
	
					If cnt < evtItemCnt4 then
					'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 4등 난수걸리면 당첨 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode4&"'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log23","2번째도전4등당첨",device)
	
						Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_win_item_"&DayName4&".png' alt='' /><a href='' onclick='fnAPPpopupBrowserURL(""마이텐바이텐"",""http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/userinfo/confirmuser.asp""); return false;' class='btnMy10x10'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_my10x10.png' alt='회원정보 확인하러 가기' /></a><div class='serialnumber'><strong>"&md5userid&"</strong></div><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					else
						'// 4등 남은게 없으면 걍 비당첨
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
	
						'// 해당 유저의 로그값 집어넣는다.
						Call fnCautionEventLog(eCode,LoginUserid,renloop,"log24","비당첨(2번째 도전)",device)
	
						Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
						dbget.close()	:	response.End
					end if
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		else
			''//비당첨
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모회수 1,2
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close
		
			''// 최초 응모자면
			If result1="" And result2="" And result3="" Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
		 
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log25","비당첨",device)
		
				Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
				dbget.close()	:	response.End
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
					dbget.execute sqlstr
		
					'// 해당 유저의 로그값 집어넣는다.
					Call fnCautionEventLog(eCode,LoginUserid,renloop,"log26","비당첨(2번째도전)",device)
		
					Response.write "OK|<div class='lylose inner' style='display:block;'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/02/img_lose_item_coupon.png' alt='나 꽝대또 당첨앙대또 슬퍼하지 마세요! 텐바이텐이 무료배송 초능력을 선물할게요! 텐바이텐 배송 상품으로 만원 이상 구매시 사용 가능합니다.' /><a href='' onclick='get_coupon(); return false;' class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_coupon.png' alt='쿠폰 다운 받기' /></a><a href='' onclick='fnAPPpopupEvent(64101); return false;' title='참여하러 가기'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/img_bnr.png' alt='실망하지 마세요! 꽝 없는 이벤트가 당신을 기다립니다.' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_close.png' alt='닫기' /></button></div>"
					dbget.close()	:	response.End
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If
		end if
	end if
'// 카카오톡 초대시
elseIf mode = "kakao" Then '//응모하기 버튼 클릭
	'// 로그 넣음
	Call fnCautionEventLog(eCode,LoginUserid,renloop,"log27","카카오 초대 클릭",device)

	'//카카오초대 클릭 카운트 
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0"
	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1 = rsget(0) '//응모회수 1,2
		result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
		result3 = rsget(2) '//카카오2차 응모 확인용 null , kakao
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	If result1 = "" Or isnull(result1) Then
		Response.write "NOT1" '//참여 이력이 없음 - 응모후 이용 하시오
		Response.End
	ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") Then '//1회 참여시 
		sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
		sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0" + vbcrlf
		dbget.execute sqlstr '// 응모 기회 한번 더줌

		Response.write "SUCCESS"
		dbget.close()	:	response.End
	ElseIf result1 = "1" And result3 = "kakao" Then		'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
		Response.write "NOT2"
		Response.end
	ElseIf (result1 = "1" And result3 = "kakao") Or result1 = "2" Then		'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
		Response.write "END" '//오늘 참여 끝
		Response.End
	End If
ElseIf mode="coupon" Then
	'//쿠폰 발급
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
	sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','3','2000','(초)능력자들 <무료배송권>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	Call fnCautionEventLog(eCode,LoginUserid,renloop,"log28","무배쿠폰발급",device)

	Response.write "SUCCESS"
	dbget.close()	:	response.end
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->