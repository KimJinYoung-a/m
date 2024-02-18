<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'#######################################################
'	History	: 2015.09.10 유태욱 생성
'	Description : 봉투맨
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
	Dim LoginUserid, renloop
	Dim eCode, sqlstr
	Dim nowdate, refip, refer
	Dim pdName1, pdName2, pdName3
	Dim renloop1, renloop2, renloop3
	Dim renloop1min, renloop2min, renloop3min
	Dim renloop1max, renloop2max, renloop3max
	Dim evtItemCnt1, evtItemCnt2, evtItemCnt3
	Dim evtItemCode1, evtItemCode2, evtItemCode3
	Dim cnt, evtimagenum, couponid, device
	Dim result1, result2, result3, mode, md5userid, evtUserCell

	If isapp then
		device = "A"
	else
		device = "M"
	end if

	nowdate = now()
''	nowdate = "2015-09-14 10:10:00"

	LoginUserid = GetEncLoginUserID()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64882
		couponid = 2740
	Else
		eCode   =  66085
		couponid = 778
	End If

	'//응모 확율
	randomize
	renloop=int(Rnd*10000)+1

If left(nowdate,10)="2015-09-22" Then		'''동적확율
	''확율조정
	''1등
	renloop1min = 9995		''0.05
	renloop1max = 10001
	
	''2등
	renloop2min = 5000		''0.5
	renloop2max = 5050

	''3등
	renloop3min = 1		''20
	renloop3max = 2000

else							'''
	''확율조정
	''1등
	renloop1min = 9995		''0.01
	renloop1max = 10001
	
	''2등
	renloop2min = 5000		''0.5
	renloop2max = 5050

	''3등
	renloop3min = 1		''10
	renloop3max = 2000

	''4등
	''renloop = 3000
end if

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(LoginUserid&"10")

	pdName1 = "1등 10만gift"
	evtItemCode1 = "1111111"
	evtItemCnt1 = 1

	pdName2 = "2등 1만gift"
	evtItemCode2 = "2222222"
	evtItemCnt2 = 35

	pdName3 = "3등 500마일"
	evtItemCode3 = "3333333"
	evtItemCnt3 = 1500

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

	'// 기프트,마일리지 수량 없으면 쿠폰처리
		If cnt > 1535 Then
			renloop = 3000
		'	Response.Write "Err|오늘은 마감되었습니다.!"
		'	Response.End
		End If

	'// expiredate
	If not(left(nowdate,10)>="2015-09-14" and left(nowdate,10)<"2015-09-23") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	''// 주말 제외
	If left(nowdate,10)="2015-09-19" or left(nowdate,10)="2015-09-20" Then
		Response.Write "Err|주말엔 쉽니다."
		Response.End
	End If

	'// 14일,21일 오전10시부터 응모 가능함, 그 이전에는 응모불가
	If left(nowdate,10)="2015-09-14" or left(nowdate,10)="2015-09-21" Then
		If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(09, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then
			Response.Write "Err|월요일은 오전 10시부터 응모하실 수 있습니다."
			Response.End
		End If
	end if

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If

If mode = "add" Then '//응모하기 버튼 클릭
	If renloop > renloop1min and renloop < renloop1max Then ''1등 난수 당첨
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
	
		'// 현재 재고 파악
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
				Call fnCautionEventLog(eCode,LoginUserid,renloop1,"log01","전화번호중복비당첨",device)

				'//쿠폰 발급
				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
				dbget.execute sqlstr
				
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,"coupon","log2","봉투맨쿠폰발급",device)
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win04_.png' alt='' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"Z</p></div></div>"

				dbget.close()	:	response.End
			End If
	
			If cnt < evtItemCnt1 then
				'// 최초응모자이고, 1등 잔량이있고, 입력한값이 1등난수당첨이면 당첨처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode1&"', '"&device&"')"
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log03",pdName1,device)
				
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win01.png' alt='100,000원 기프트 카드 당첨' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"A</p></div></div>"
				dbget.close()	:	response.End
			Else
				'// 1등 남은게 없으면 비당첨
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log04","비당첨",device)

				'//쿠폰 발급
				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
				dbget.execute sqlstr
				
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,"coupon","log05","봉투맨쿠폰발급",device)
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win04_.png' alt='' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"Z</p></div></div>"
				dbget.close()	:	response.End
			end if
		'// 응모를 1회 했을경우
		Else
			Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
			response.End
		End If

	elseIf renloop > renloop2min and renloop < renloop2max Then ''2등 난수 당첨
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
	
		'// 현재 재고 파악
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
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log06","전화번호중복비당첨",device)

				'//쿠폰 발급
				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
				dbget.execute sqlstr
				
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,"coupon","log07","봉투맨쿠폰발급",device)
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win04_.png' alt='' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"Z</p></div></div>"

				dbget.close()	:	response.End
			End If
	
			If cnt < evtItemCnt2 then
				'// 최초응모자이고, 2등 잔량이있고, 입력한값이 2등난수당첨이면 당첨처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', '"&device&"')"
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log08",pdName2,device)
				
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win02.png' alt='10,000원 기프트 카드 당첨' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"B</p></div></div>"
				dbget.close()	:	response.End
			Else
				'// 1등 남은게 없으면 비당첨
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log09","비당첨",device)

				'//쿠폰 발급
				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
				dbget.execute sqlstr
				
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,"coupon","log10","봉투맨쿠폰발급",device)
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win04_.png' alt='' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"Z</p></div></div>"
				dbget.close()	:	response.End
			end if
		'// 응모를 1회 했을경우
		Else
			Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
			response.End
		End If
	elseIf renloop > renloop3min and renloop < renloop3max Then ''3등 난수 당첨
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
	
		'// 현재 재고 파악
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2='"&evtItemCode3&"' "			
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
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log11","전화번호중복비당첨",device)

				'//쿠폰 발급
				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
				dbget.execute sqlstr
				
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,"coupon","log12","봉투맨쿠폰발급",device)
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win04_.png' alt='' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"Z</p></div></div>"

				dbget.close()	:	response.End
			End If
	
			If cnt < evtItemCnt3 then
				'// 최초응모자이고, 3등 잔량이있고, 입력한값이 3등난수당첨이면 당첨처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', '"&device&"')"
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log13",pdName3,device)
				
				''마일리지 로그 기록남김
				sqlstr = "insert into [db_user].[dbo].[tbl_mileagelog] (userid,mileage,jukyocd,jukyo,deleteyn)" + vbcrlf
				sqlstr = sqlstr & " VALUES('"& LoginUserid &"', '500', "& eCode &", '봉투맨 500마일리지 지급', 'N')"
				dbget.execute sqlstr

				'' 마일리지 정산(지급-업데이트(기존마일리지+지급마일리지)
				sqlstr = "update db_user.dbo.tbl_user_current_mileage set bonusmileage=bonusmileage+500" + vbcrlf
				sqlstr = sqlstr & " Where Userid='"& LoginUserid &"'"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log14","500마일리지지급",device)

				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win03_.png' alt='500 마일리지 당첨' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"C</p></div></div>"
				
				dbget.close()	:	response.End
			Else
				'// 1등 남은게 없으면 비당첨
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr
	
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,renloop,"log15","비당첨",device)

				'//쿠폰 발급
				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
				dbget.execute sqlstr
				
				'// 해당 유저의 로그값 집어넣는다.
				Call fnCautionEventLog(eCode,LoginUserid,"coupon","log16","봉투맨쿠폰발급",device)
				Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win04_.png' alt='' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"Z</p></div></div>"
				
				dbget.close()	:	response.End
			end if
		'// 응모를 1회 했을경우
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
			Call fnCautionEventLog(eCode,LoginUserid,renloop,"log17","비당첨",device)

			'//쿠폰 발급
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
			sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
			dbget.execute sqlstr
			
			'// 해당 유저의 로그값 집어넣는다.
			Call fnCautionEventLog(eCode,LoginUserid,"coupon","log18","봉투맨쿠폰발급",device)
			Response.write "OK|<div class='myBag'><button type='button' onclick=""fnClosemask();"" class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/btn_layer_close.png' alt='닫기' /></button><div class='win'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/66085/01/img_pop_win04_.png' alt='' /></p><button type='button' onclick=""fnClosemask();"" class='btnConfirm'>확인</button><p class='wincode'>"&md5userid&"Z</p></div></div>"
			
			dbget.close()	:	response.End
		Else
			Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
			response.End
		End If
	end if
'// 카카오톡 초대시
elseIf mode = "kakao" Then '//응모하기 버튼 클릭
	'// 로그 넣음
	Call fnCautionEventLog(eCode,LoginUserid,"kakao","log19","카카오 초대 클릭",device)
	Response.write "SUCCESS"
	dbget.close()	:	response.End
ElseIf mode="coupon" Then
	'//쿠폰 발급
	sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
	sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
	sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','2','1000','봉투맨<보너스 쿠폰>','10000','"& left(nowdate,10) &" 00:00:00','"& left(nowdate,10) &" 23:59:59','',0,'system')"
	dbget.execute sqlstr

	'// 해당 유저의 로그값 집어넣는다.
	Call fnCautionEventLog(eCode,LoginUserid,"coupon","log20","봉투맨쿠폰발급",device)

	Response.write "SUCCESS"
	dbget.close()	:	response.end

else
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->