<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	: 2015.05.28 유태욱 생성
'	Description : ##티켓킹
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	dim	DayName1, DayName2, DayName3
	Dim cnt, remaincnt, evtimagenum, couponid
	Dim eCode, vDisp, sqlstr
	Dim nowdate, refip, refer, renloop
	Dim LoginUserid
	Dim pdName1, pdName2, pdName3, pdName4, pdName5
	Dim evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4, evtItemCode5
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4, evtItemCnt5
	Dim result1, result2, result3, mode, md5userid, evtUserCell
'	Dim vEuserInputCode, DayRightNumber

	nowdate = now()
'	nowdate = "2015-06-08 09:10:00"

	LoginUserid = getLoginUserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
'	vEuserInputCode = requestcheckvar(request("euserInputCode"),4) '// 사용자 입력값
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63772
		couponid = 2719
	Else
		eCode   =  62985
		couponid = 740
	End If

	'//응모 확율
	randomize
	renloop=int(Rnd*10000)+1

'''''''''''''''''''''''''''''''''''''''''''''기본값'''''''''''''''''''''''''''''검색용단어
''구분1 : 무배쿠폰			renloop > 9999 and renloop < 10001		0.01%		japan
''구분2 : 2등				renloop > 9500 and renloop < 9502		0.01%		pink			9501

''구분3 : 3등				renloop >= 9000 and renloop < 9100		1%			airframe
''구분4 : 4등 				renloop >= 6000 and renloop < 6200		2%			pocari

''구분5 : 기프트카드 		renloop >= 1 and renloop < 2			0.01%		giftcard		1
''꽝	: 무배쿠폰 																COUPON


''''''''''''''''''''''''''''''''''''''''''''운영	2015-06-12''''''''''''''''''검색용단어
''구분1 : 무배쿠폰			renloop > 9999 and renloop < 10001		0.01%		japan
''구분2 : 2등				renloop > 9500 and renloop < 9502		0.01%		pink			9501

''구분3 : 3등				renloop >= 2500 and renloop < 9500		0.5%		airframe
''구분4 : 4등 				renloop >= 2 and renloop < 2500			10%			pocari

''구분5 : 기프트카드 		renloop >= 1 and renloop < 2			0.5%		giftcard		1
''꽝	: 무배쿠폰 																COUPON

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(LoginUserid&"10")

	''당첨레이어 구분
	If left(nowdate,10)=<"2015-06-01" or left(nowdate,10)="2015-06-08" Then
		DayName1 = "01"
		DayName2 = "02"
		DayName3 = "03"
	elseif left(nowdate,10)="2015-06-02" or left(nowdate,10)="2015-06-09" Then
		DayName1 = "04"
		DayName2 = "05"
		DayName3 = "06"
	elseif left(nowdate,10)="2015-06-03" or left(nowdate,10)="2015-06-10" Then
		DayName1 = "07"
		DayName2 = "08"
		DayName3 = "09"
	elseif left(nowdate,10)="2015-06-04" or left(nowdate,10)="2015-06-11" Then
		DayName1 = "10"
		DayName2 = "11"
		DayName3 = "12"
	elseif left(nowdate,10)="2015-06-05" or left(nowdate,10)="2015-06-12" Then
		DayName1 = "13"
		DayName2 = "14"
		DayName3 = "15"
	end if

	If left(nowdate,10)<"2015-06-02" or left(nowdate,10)="2015-06-06" or left(nowdate,10)="2015-06-07" or left(nowdate,10)="2015-06-08" Then
		evtimagenum	=	"01"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "캐리어 핑크"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "에어프레임도쿄"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 495

		pdName4 = "포카리"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2503

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-02" or left(nowdate,10)="2015-06-09" Then
		evtimagenum	=	"02"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 2

		pdName2 = "시마헬기"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "마주로클립"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 700

		pdName4 = "제주보석건귤"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2297

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-03" or left(nowdate,10)="2015-06-10" Then
		evtimagenum	=	"03"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "아이리버블루투스오디오"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "오야스미양"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 745

		pdName4 = "짜파게티"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2253

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-04" or left(nowdate,10)="2015-06-11" Then
		evtimagenum	=	"04"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "커피메이커오븐"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "스크래치맵세계지도"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 295

		pdName4 = "베스킨라빈스싱글"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 2703

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	elseif left(nowdate,10)="2015-06-05" or left(nowdate,10)>="2015-06-12" Then
		evtimagenum	=	"05"

		pdName1 = "무배쿠폰"
		evtItemCode1 = "1111111"
		evtItemCnt1 = 1

		pdName2 = "인스탁스미니"
		evtItemCode2 = "2222222"
		evtItemCnt2 = 2

		pdName3 = "비킷BGP방수팩"
		evtItemCode3 = "3333333"
		evtItemCnt3 = 1000

		pdName4 = "도라에몽얼굴물총"
		evtItemCode4 = "4444444"
		evtItemCnt4 = 1998

		pdName5 = "기프트카드"
		evtItemCode5 = "5555555"
		evtItemCnt5 = 10
	end if
	
	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(nowdate,10)>="2015-06-01" and left(nowdate,10)<"2015-06-13") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	''// 주말 제외
	If left(nowdate,10)="2015-06-06" or left(nowdate,10)="2015-06-07" Then
		Response.Write "Err|주말엔 쉽니다."
		Response.End
	End If

	'// 해당일자 10시부터 응모 가능함, 그 이전에는 응모불가
	if left(nowdate,10)="2015-06-01" or left(nowdate,10)="2015-06-08" then
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
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2<>0 And sub_opt2<>'5555555' "
	rsget.Open sqlstr, dbget, 1
		remaincnt = rsget(0)
	rsget.close

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg
	
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode("텐바이텐 여름 휴가지원 프로젝트 ##티켓킹")
	snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=62986")
	snpPre = Server.URLEncode("10x10 이벤트")

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 " & Replace("티켓킹"," ",""))
	snpTag2 = Server.URLEncode("#10x10")





	If mode = "add" Then '//응모하기 버튼 클릭



if left(nowdate,10)="2015-06-12" then
If renloop > 9999 and renloop < 10001 Then ''무배쿠폰(꽝) 난수 당첨시(1%)	japan
	''//비당첨
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
		dbget.execute sqlstr

		Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
		dbget.close()	:	response.End
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
			sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
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
ElseIf renloop > 9500 and renloop < 9502 Then ''캐리어핑크 난수 당첨시	pink
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(캐리어핑크)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode2&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------전체 기간으로 변경해야함
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

		'// 기존에 등 당첨된 사람이면 무조건 비당첨 처리함.---------------evtItemCode1~5 --------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode2&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close

		If cnt < evtItemCnt2 then
			'// 최초응모자이고, 캐리어핑크 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '캐리어핑크당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName1&".png' alt='엄마! 나 핵 2등!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 캐리어핑크 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			'// 1번 응모를 하고 카카오 초대를 했다 치더라도 기존에 응모가 1등 당첨일 경우엔 더 이상 응모 안됨.
'					sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
'					rsget.Open sqlstr, dbget, 1
'					If rsget(0) > 0 Then
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'						dbget.execute sqlstr
'
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					End If

'					'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'					dbget.execute sqlstr
'
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End


			'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------전체 기간으로 변경해야함
			If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
				sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
				dbget.close()	:	response.End
			End If

			'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode2&-----------------------------------------------------------
'					sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode2&"' And userid='"&LoginUserid&"' "			
'					rsget.Open sqlstr, dbget, 1
'					If rsget(0) > 0 Then
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'						dbget.execute sqlstr
'
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					End If

			If cnt < evtItemCnt2 then
			'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 캐리어핑크 난수걸리면 당첨 처리
				sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode2&"'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 캐리어핑크 당첨', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName1&".png' alt='엄마! 나 핵 2등!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
				dbget.close()	:	response.End
			else
				'// 캐리어핑크 남은게 없으면 걍 비당첨
				sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
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
ElseIf renloop >= 2500 and renloop < 9500 Then ''에어프레임 난수 당첨시	airframe
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(에어프레임도쿄)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode3&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함------전체 기간으로 변경해야함-----------------
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

'				'// 기존에 에 당첨된 사람이면 무조건 비당첨 처리함.---------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode3&--------------------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode3&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close
		
		If cnt < evtItemCnt3 then
			'// 최초응모자이고, 에어프레임도쿄 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '에어프레임도쿄', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName2&".png' alt='다들 미안! 3둥입니당!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 에어프레임도쿄 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			'// 카카오 초대를 했다 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
'					If Trim(result2)<>"0" Then
'						'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'						dbget.execute sqlstr
'		
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					Else
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------전체 기간으로 셋팅해야함------------------------------------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				End If

'						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode3&-----------------------------------------------------------
'						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode3&"' And userid='"&LoginUserid&"' "			
'						rsget.Open sqlstr, dbget, 1
'						If rsget(0) > 0 Then
'							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'							dbget.execute sqlstr
'	
'							'// 해당 유저의 로그값 집어넣는다.
'							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'							dbget.execute sqlstr
'	
'							Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'							dbget.close()	:	response.End
'						End If

				If cnt < evtItemCnt3 then
				'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 에어프레임도쿄 난수걸리면 당첨 처리
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode3&"'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 에어프레임도쿄 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName2&".png' alt='다들 미안! 3둥입니당!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				else
					'// 에어프레임도쿄 남은게 없으면 걍 비당첨
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				end if
'					End If
		Else
			Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
			response.End
		End If
	'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
	Else
		Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
		response.End
	End If
ElseIf renloop >= 2 and renloop < 2500 Then ''포카리 난수 당첨시	pocari
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(포카리)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode4&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------전체 기간으로 셋팅해야함-----------------
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

'				'// 기존에 에 당첨된 사람이면 무조건 비당첨 처리함.---------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode4&--------------------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode4&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close
		If cnt < evtItemCnt4 then
			'// 최초응모자이고, 포카리 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode4&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '포카리당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName3&".png' alt='너를 4등해!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 포카리 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
'					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
'					If Trim(result2)<>"0" Then
'						'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'						dbget.execute sqlstr
'		
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					Else
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------전체 기간으로 셋팅해야함------------------------------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				End If

'						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode4&-----------------------------------------------------------
'						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode4&"' And userid='"&LoginUserid&"' "
'						rsget.Open sqlstr, dbget, 1
'						If rsget(0) > 0 Then
'							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'							dbget.execute sqlstr
'	
'							'// 해당 유저의 로그값 집어넣는다.
'							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'							dbget.execute sqlstr
'	
'							Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'							dbget.close()	:	response.End
'						End If

				If cnt < evtItemCnt4 then
				'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 포카리 난수걸리면 당첨 처리
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode4&"'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 포카리 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName3&".png' alt='너를 4등해!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				else
					'// 포카리 남은게 없으면 걍 비당첨
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				end if
'					End If
		Else
			Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
			response.End
		End If
	'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
	Else
		Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
		response.End
	End If
ElseIf renloop >= 1 and renloop < 2 Then ''번외 기프트카드 하루 3000명중 10명	giftcard
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(기프트카드)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode5&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함-----------전체 기간으로 셋팅해야함-----------------
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

'				'// 기존에 에 당첨된 사람이면 무조건 비당첨 처리함.---------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode5&--------------------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode5&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close
		
		If cnt < evtItemCnt5 then
			'// 최초응모자이고, 기프트카드 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode5&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '기프트카드당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lygift inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_gift.png' alt='사장님도 모르는! 시크릿 티켓에 당첨되셨습니다!' /><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 기프트카드 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
'					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
'					If Trim(result2)<>"0" Then
'						'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'						dbget.execute sqlstr
'		
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					Else
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함-------------전체 기간으로 셋팅해야함------------------------------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				End If

'						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode5&-----------------------------------------------------------
'						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode5&"' And userid='"&LoginUserid&"' "
'						rsget.Open sqlstr, dbget, 1
'						If rsget(0) > 0 Then
'							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'							dbget.execute sqlstr
'	
'							'// 해당 유저의 로그값 집어넣는다.
'							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'							dbget.execute sqlstr
'	
'							Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'							dbget.close()	:	response.End
'						End If

				If cnt < evtItemCnt5 then
				'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 기프트카드 난수걸리면 당첨 처리
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode5&"'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 기프트카드 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lygift inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_gift.png' alt='사장님도 모르는! 시크릿 티켓에 당첨되셨습니다!' /><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				else
					'// 기프트카드 남은게 없으면 걍 비당첨
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				end if
'					End If
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
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
		dbget.execute sqlstr

		Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
		dbget.close()	:	response.End
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
			sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
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

If renloop > 9999 and renloop < 10001 Then ''무배쿠폰(꽝) 난수 당첨시(1%)	japan
	''//비당첨
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
		dbget.execute sqlstr

		Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
		dbget.close()	:	response.End
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
			sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
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
ElseIf renloop > 9500 and renloop < 9502 Then ''캐리어핑크 난수 당첨시	pink
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(캐리어핑크)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode2&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------전체 기간으로 변경해야함
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

		'// 기존에 등 당첨된 사람이면 무조건 비당첨 처리함.---------------evtItemCode1~5 --------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode2&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close

		If cnt < evtItemCnt2 then
			'// 최초응모자이고, 캐리어핑크 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '캐리어핑크당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName1&".png' alt='엄마! 나 핵 2등!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 캐리어핑크 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			'// 1번 응모를 하고 카카오 초대를 했다 치더라도 기존에 응모가 1등 당첨일 경우엔 더 이상 응모 안됨.
'					sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
'					rsget.Open sqlstr, dbget, 1
'					If rsget(0) > 0 Then
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'						dbget.execute sqlstr
'
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					End If

'					'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'					dbget.execute sqlstr
'
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End


			'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------전체 기간으로 변경해야함
			If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
				sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
				dbget.close()	:	response.End
			End If

			'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode2&-----------------------------------------------------------
'					sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode2&"' And userid='"&LoginUserid&"' "			
'					rsget.Open sqlstr, dbget, 1
'					If rsget(0) > 0 Then
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'						dbget.execute sqlstr
'
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					End If

			If cnt < evtItemCnt2 then
			'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 캐리어핑크 난수걸리면 당첨 처리
				sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode2&"'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 캐리어핑크 당첨', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName1&".png' alt='엄마! 나 핵 2등!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
				dbget.close()	:	response.End
			else
				'// 캐리어핑크 남은게 없으면 걍 비당첨
				sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
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
ElseIf renloop >= 9000 and renloop < 9100 Then ''에어프레임 난수 당첨시	airframe
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(에어프레임도쿄)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode3&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함------전체 기간으로 변경해야함-----------------
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

'				'// 기존에 에 당첨된 사람이면 무조건 비당첨 처리함.---------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode3&--------------------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode3&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close
		
		If cnt < evtItemCnt3 then
			'// 최초응모자이고, 에어프레임도쿄 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '에어프레임도쿄', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName2&".png' alt='다들 미안! 3둥입니당!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 에어프레임도쿄 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			'// 카카오 초대를 했다 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
'					If Trim(result2)<>"0" Then
'						'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'						dbget.execute sqlstr
'		
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					Else
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------전체 기간으로 셋팅해야함------------------------------------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				End If

'						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode3&-----------------------------------------------------------
'						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode3&"' And userid='"&LoginUserid&"' "			
'						rsget.Open sqlstr, dbget, 1
'						If rsget(0) > 0 Then
'							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'							dbget.execute sqlstr
'	
'							'// 해당 유저의 로그값 집어넣는다.
'							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'							dbget.execute sqlstr
'	
'							Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'							dbget.close()	:	response.End
'						End If

				If cnt < evtItemCnt3 then
				'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 에어프레임도쿄 난수걸리면 당첨 처리
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode3&"'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 에어프레임도쿄 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName2&".png' alt='다들 미안! 3둥입니당!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				else
					'// 에어프레임도쿄 남은게 없으면 걍 비당첨
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				end if
'					End If
		Else
			Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
			response.End
		End If
	'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
	Else
		Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
		response.End
	End If
ElseIf renloop >= 6000 and renloop < 6200 Then ''포카리 난수 당첨시	pocari
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(포카리)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode4&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------전체 기간으로 셋팅해야함-----------------
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

'				'// 기존에 에 당첨된 사람이면 무조건 비당첨 처리함.---------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode4&--------------------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode4&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close
		If cnt < evtItemCnt4 then
			'// 최초응모자이고, 포카리 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode4&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '포카리당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName3&".png' alt='너를 4등해!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 포카리 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
'					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
'					If Trim(result2)<>"0" Then
'						'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'						dbget.execute sqlstr
'		
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					Else
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함--------------전체 기간으로 셋팅해야함------------------------------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				End If

'						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode4&-----------------------------------------------------------
'						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode4&"' And userid='"&LoginUserid&"' "
'						rsget.Open sqlstr, dbget, 1
'						If rsget(0) > 0 Then
'							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'							dbget.execute sqlstr
'	
'							'// 해당 유저의 로그값 집어넣는다.
'							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'							dbget.execute sqlstr
'	
'							Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'							dbget.close()	:	response.End
'						End If

				If cnt < evtItemCnt4 then
				'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 포카리 난수걸리면 당첨 처리
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode4&"'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 포카리 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lywin inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_"&DayName3&".png' alt='너를 4등해!' /><strong class='no'>no."&Cint(remaincnt)+1&"</strong><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				else
					'// 포카리 남은게 없으면 걍 비당첨
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				end if
'					End If
		Else
			Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
			response.End
		End If
	'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
	Else
		Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
		response.End
	End If
ElseIf renloop >= 1 and renloop < 2 Then ''번외 기프트카드 하루 3000명중 10명	giftcard
	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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

	'// 현재 재고 파악(기프트카드)
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode5&"' "			
	rsget.Open sqlstr, dbget, 1
		cnt = rsget(0)
	rsget.close

	'// 최초 응모자면
	If result1="" And result2="" And result3="" Then
		'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함-----------전체 기간으로 셋팅해야함-----------------
		If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		End If

'				'// 기존에 에 당첨된 사람이면 무조건 비당첨 처리함.---------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode5&--------------------------------
'				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode5&"' And userid='"&LoginUserid&"' "			
'				rsget.Open sqlstr, dbget, 1
'				If rsget(0) > 0 Then
'					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
'					dbget.execute sqlstr
'	
'					'// 해당 유저의 로그값 집어넣는다.
'					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.', 'A')"
'					dbget.execute sqlstr
'	
'					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'					dbget.close()	:	response.End
'				End If
'				rsget.close
		
		If cnt < evtItemCnt5 then
			'// 최초응모자이고, 기프트카드 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode5&"', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '기프트카드당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lygift inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_gift.png' alt='사장님도 모르는! 시크릿 티켓에 당첨되셨습니다!' /><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		Else
			'// 기프트카드 남은게 없으면 걍 비당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
			dbget.close()	:	response.End
		end if
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
'					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
'					If Trim(result2)<>"0" Then
'						'// 이전에 뭐든 당첨이력이 있으면 걍 비당첨
'						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'						dbget.execute sqlstr
'
'						'// 해당 유저의 로그값 집어넣는다.
'						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
'						dbget.execute sqlstr
'		
'						Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'						dbget.close()	:	response.End
'					Else
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함-------------전체 기간으로 셋팅해야함------------------------------------
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				End If

'						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아무거나 당첨되면 비당첨 처리함.-----------------한상품만 할건지,전체 상품으로 할건지 설정&evtItemCode5&-----------------------------------------------------------
'						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode5&"' And userid='"&LoginUserid&"' "
'						rsget.Open sqlstr, dbget, 1
'						If rsget(0) > 0 Then
'							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
'							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
'							dbget.execute sqlstr
'	
'							'// 해당 유저의 로그값 집어넣는다.
'							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
'							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '기존당첨자라비당첨처리함.(2번째 도전)', 'A')"
'							dbget.execute sqlstr
'	
'							Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
'							dbget.close()	:	response.End
'						End If

				If cnt < evtItemCnt5 then
				'// kakao에 값이 있고 기존 당첨자도 아니고, 기존에 당첨 안됐는데 기프트카드 난수걸리면 당첨 처리
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode5&"'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"', '2번째 도전 기프트카드 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lygift inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_gift.png' alt='사장님도 모르는! 시크릿 티켓에 당첨되셨습니다!' /><a href='' onclick=""popSNSPost('fb','"&snpTitle&"','"&snpLink&"','',''); return false;"" class='btnfacebook'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_facebook.png' alt='페이스북 공유하기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				else
					'// 기프트카드 남은게 없으면 걍 비당첨
					sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
					sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				end if
'					End If
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
	sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
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
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&renloop&"','비당첨', 'A')"
		dbget.execute sqlstr

		Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
		dbget.close()	:	response.End
	'// 응모를 1회 했을경우
	ElseIf Trim(result1) = "1" Then
		'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
		If Trim(result3)="kakao" Then
			sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
			sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','비당첨(2번째 도전)', 'A')"
			dbget.execute sqlstr

			Response.write "OK|<div class='lylose inner' style='display:block'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/img_win_item_coupon.png' alt='' /><a href='' onclick=""get_coupon(); return false;"" class='btncoupon'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_coupon.png' alt='쿠폰 다운 받기' /></a><button type='button' onclick=""fnClosemask();"" class='btnclose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_close.png' alt='닫기' /></button><div class='serialnumber'><strong>"&md5userid&"</strong></div></div>"
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
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value2, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&renloop&"', '카카오 초대 클릭', 'A')"
		dbget.execute sqlstr

		'//카카오초대 클릭 카운트 
		'// 응모내역 검색
		sqlstr = "select top 1 sub_opt1 , sub_opt2 , sub_opt3 "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'"
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
		ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") Then '//1회 참여시 ( And result2="0" 뺏음)
			sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
			sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'" + vbcrlf
			dbget.execute sqlstr '// 응모 기회 한번 더줌

			Response.write "SUCCESS"
			dbget.close()	:	response.End
		ElseIf result1 = "1" And result3 = "kakao" Then		'오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!
			Response.write "NOT2"
			Response.end
		ElseIf (result1 = "1" And result3 = "kakao") Or result1 = "2" Then		'오늘의 응모는 모두 완료!\n내일 또 도전해 주세요!
			Response.write "END" '//오늘 참여 끝
			Response.End
		End If
	ElseIf mode="coupon" Then
		'//쿠폰 발급
		sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
		sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
		sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','3','2000','티켓킹 <무료배송권>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value2, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&renloop&"','무배쿠폰발급', 'A')"
		dbget.execute sqlstr

		Response.write "SUCCESS"
		dbget.close()	:	response.end
	End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->