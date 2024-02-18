<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 비밀의방 초대권
' History : 2015.08.14 원승현 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%	
dim eCode, userid, getbonuscoupon, currenttime, getlimitcnt, vmode, apgubun, vprocdate, strSql, sqlstr, totcnt, refer, vchasu, eCouponID, evtUserCell, renloop, refip
Dim vPrdCnt1, vPrdCnt2, vPrdCnt3, vPrdName1, vPrdName2, vPrdName3, vPrdCode1, vPrdCode2, vPrdCode3, vcouponbannerimg
Dim vPrd1St, vPrd1Ed, vPrd2St, vPrd2Ed, vPrd3St, vPrd3Ed, vdvalue, vtodaypw, result1, result2, result3, einviteCode
	IF application("Svr_Info") = "Dev" Then
		einviteCode = "64854"
		eCode = "64855"
		eCouponID = 764
	Else
		einviteCode = "65477"
		eCode = "65479"
		eCouponID = 764
	End If

	userid = getloginuserid()
	refer = request.ServerVariables("HTTP_REFERER")
	refip = Request.ServerVariables("REMOTE_ADDR")
	vmode = requestcheckvar(request("mode"),32)
	vprocdate = requestcheckvar(request("procdate"),32)
	vchasu = requestcheckvar(request("chasu"),32)
	vdvalue =  requestcheckvar(request("dvalue"),32)
	vtodaypw =  requestcheckvar(request("todaypw"),32)

	evtUserCell = get10x10onlineusercell(userid) '// 참여한 회원 핸드폰번호

	'// 쿠폰 레이어 뜰때 하단 팝업 이미지 파일명
	vcouponbannerimg = "img_banner_03"

	If userid = "" Then
		Response.Write "Err|로그인을 해야>?n이벤트에 참여할 수 있어요."
		dbget.close() : Response.End
	End If

	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end if

	If Left(now(), 10)="2015-08-15" Or Left(now(), 10)="2015-08-16" Or Left(now(), 10)="2015-08-22" Or Left(now(), 10)="2015-08-23" Then
		Response.Write "Err|주말에는 쉽니다."
		dbget.close() : Response.End
	End If


	If not( left(now(),10)>="2015-08-14" and left(now(),10)<"2015-08-29" ) Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		dbget.close() : Response.End
	End If


	'// 비밀의방 신청한 인원인지 확인한다.
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& userid &"' and evt_code = '"& einviteCode &"' And sub_opt1 = '"&Trim(vprocdate)&"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()

	If totcnt = 0 Then
		Response.Write "Err|초대장을 신청하신분만 응모 가능합니다."
		dbget.close() : Response.End
	End If


	'// 일자별 상품갯수 셋팅
	Select Case Trim(Left(now(), 10))

		Case "2015-08-17"
			vPrdCnt1 = 1
			vPrdName1 = "핏 비트 스마트 밴드"
			vPrdCode1 = "1265396"

			vPrdCnt2 = 200
			vPrdName2 = "스티키 몬스터 노트"
			vPrdCode2 = "1135303"

			vPrdCnt3 = 299
			vPrdName3 = "스플래쉬 펭귄 자동칫솔 걸이"
			vPrdCode3 = "1295437"

		Case "2015-08-18"
			vPrdCnt1 = 1
			vPrdName1 = "Pixie Bag"
			vPrdCode1 = "1068178"

			vPrdCnt2 = 250
			vPrdName2 = "무민 네일케어 세트"
			vPrdCode2 = "1330312"

			vPrdCnt3 = 250
			vPrdName3 = "딸기 타르트 비누"
			vPrdCode3 = "837392"

		Case "2015-08-19"
			vPrdCnt1 = 10
			vPrdName1 = "미니언 캐릭터 USB 메모리 (8G)"
			vPrdCode1 = "1292307"

			vPrdCnt2 = 250
			vPrdName2 = "러버덕"
			vPrdCode2 = "1102543"

			vPrdCnt3 = 240
			vPrdName3 = "애니멀 파우치 플랫"
			vPrdCode3 = "1328415"

		Case "2015-08-20"
			vPrdCnt1 = 1
			vPrdName1 = "Q5 보조배터리 7200mAh"
			vPrdCode1 = "1328232"

			vPrdCnt2 = 200
			vPrdName2 = "Canvas pouch"
			vPrdCode2 = "1320974"

			vPrdCnt3 = 299
			vPrdName3 = "1 PARAGRAPH DIARY"
			vPrdCode3 = "1235463"

		Case "2015-08-21"
			vPrdCnt1 = 1
			vPrdName1 = "스마트빔 큐브 미니빔 프로젝터"
			vPrdCode1 = "1151190"

			vPrdCnt2 = 10
			vPrdName2 = "샤오미 미스케일 스마트체중계"
			vPrdCode2 = "1284396"

			vPrdCnt3 = 489
			vPrdName3 = "미니자명종(화이트)"
			vPrdCode3 = "736701"

		Case "2015-08-24"
			vPrdCnt1 = 1
			vPrdName1 = "핏 비트 스마트 밴드"
			vPrdCode1 = "1265396"

			vPrdCnt2 = 100
			vPrdName2 = "스티키 몬스터 노트"
			vPrdCode2 = "1135303"

			vPrdCnt3 = 399
			vPrdName3 = "SMILES SWITCH LED LIGHT"
			vPrdCode3 = "1133679"

		Case "2015-08-25"
			vPrdCnt1 = 1
			vPrdName1 = "수화물용 캐리어(핑크)"
			vPrdCode1 = "939299"

			vPrdCnt2 = 50
			vPrdName2 = "무민 네일케어 세트"
			vPrdCode2 = "1330312"

			vPrdCnt3 = 449
			vPrdName3 = "딸기 타르트 비누"
			vPrdCode3 = "837392"

		Case "2015-08-26"
			vPrdCnt1 = 10
			vPrdName1 = "미니언 캐릭터 USB 메모리 (8G)"
			vPrdCode1 = "1292307"

			vPrdCnt2 = 50
			vPrdName2 = "러버덕"
			vPrdCode2 = "1102543"

			vPrdCnt3 = 440
			vPrdName3 = "애니멀 파우치 플랫"
			vPrdCode3 = "1328415"

		Case "2015-08-27"
			vPrdCnt1 = 1
			vPrdName1 = "레카코후 그늘막(light blue)"
			vPrdCode1 = "1308234"

			vPrdCnt2 = 50
			vPrdName2 = "Canvas pouch"
			vPrdCode2 = "1320974"

			vPrdCnt3 = 449
			vPrdName3 = "1 PARAGRAPH DIARY"
			vPrdCode3 = "1235463"

		Case "2015-08-28"
			vPrdCnt1 = 1
			vPrdName1 = "스마트빔 큐브 미니빔 프로젝터"
			vPrdCode1 = "1151190"

			vPrdCnt2 = 10
			vPrdName2 = "샤오미 미스케일 스마트체중계"
			vPrdCode2 = "1284396"

			vPrdCnt3 = 489
			vPrdName3 = "삭스신드롬 양말(랜덤)"
			vPrdCode3 = "1333740"

		Case Else
			vPrdCnt1 = 1
			vPrdName1 = "핏 비트 스마트 밴드"
			vPrdCode1 = "1265396"

			vPrdCnt2 = 200
			vPrdName2 = "스티키 몬스터 노트"
			vPrdCode2 = "1135303"

			vPrdCnt3 = 299
			vPrdName3 = "스플래쉬 펭귄 자동칫솔 걸이"
			vPrdCode3 = "1295437"
	End Select


	'// 응모확률 계산
	randomize
	renloop=int(Rnd*10000)+1


	Select Case Trim(Left(now(), 10))
		Case "2015-08-17"
			'// 1등 상품 당첨확률 0.1%
			vPrd1St = 1
			vPrd1Ed = 11

			'// 2등 상품 당첨확률 80%
			vPrd2St = 3000
			vPrd2Ed = 9999

			'// 3등 상품 당첨확률 10%
			vPrd3St = 2000
			vPrd3Ed = 3001
		Case "2015-08-18"
			'// 1등 상품 당첨확률 0.1%
			vPrd1St = 1
			vPrd1Ed = 11

			'// 2등 상품 당첨확률 1%
			vPrd2St = 1000
			vPrd2Ed = 1501

			'// 3등 상품 당첨확률 5%
			vPrd3St = 2000
			vPrd3Ed = 2501
		Case "2015-08-24"
			'// 1등 상품 당첨확률 0.1%
			vPrd1St = 1
			vPrd1Ed = 11

			'// 2등 상품 당첨확률 80%
			vPrd2St = 1000
			vPrd2Ed = 8001

			'// 3등 상품 당첨확률 5%
			vPrd3St = 2000
			vPrd3Ed = 2501

		Case "2015-08-27"
			'// 1등 상품 당첨확률 0.1%
			vPrd1St = 1
			vPrd1Ed = 11

			'// 2등 상품 당첨확률 80%
			vPrd2St = 1000
			vPrd2Ed = 8001

			'// 3등 상품 당첨확률 10%
			vPrd3St = 2000
			vPrd3Ed = 9999

		Case "2015-08-28"
			'// 1등 상품 당첨확률 0.1%
			vPrd1St = 1
			vPrd1Ed = 11

			'// 2등 상품 당첨확률 80%
			vPrd2St = 1000
			vPrd2Ed = 8001

			'// 3등 상품 당첨확률 10%
			vPrd3St = 2000
			vPrd3Ed = 9999

		Case Else
			'// 1등 상품 당첨확률 0.1%
			vPrd1St = 1
			vPrd1Ed = 11

			'// 2등 상품 당첨확률 0.5%
			vPrd2St = 1000
			vPrd2Ed = 1051

			'// 3등 상품 당첨확률 5%
			vPrd3St = 2000
			vPrd3Ed = 2501
	End Select



	'// 응모내역 검색
	sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10), regdate, 120) = '"&Left(now(), 10)&"' "
	rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
	If Not(rsget.bof Or rsget.Eof) Then
		'// 기존에 응모 했을때 값
		result1 = rsget(0) '//비밀의방 메인 일자
		result2 = rsget(1) '//상품코드
		result3 = rsget(2) '//상품명
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
		result3 = ""
	End IF
	rsget.close

	'// 일자별 응모한 내역이 있다면(쿠폰당첨 포함) 이미 응모하셨습니다. 출력
	If result1 <> "" Then
		Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
		response.End
	End If

	If result1 = "" Then '// 이미 응모했는지 다시한번 체크

		'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
		If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '0', '비밀의방 쿠폰', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
			dbget.execute sqlstr

			'// 쿠폰 넣어준다.
			sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
					 "values('"& eCouponID &"', '" & userid & "', '2','5000','비밀의방 쿠폰 5,000원-4만원이상','40000','"&Left(now(), 10)&" 00:00:00','"&Left(now(), 10)&" 23:59:59','',0,'system','app')"
			dbget.execute sqlstr

			Response.write "OK|<div class='winCoupon' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick=""fnAPPpopupEvent('65688');return false;"" class='bnr'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/"&vcouponbannerimg&".png' alt='현상금을 노려라' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기'/></button></div>"
			dbget.close()	:	response.End
		End If

		'// 1등 상품 당첨
		If renloop >= vPrd1St And renloop < vPrd1Ed Then
			'// 1등 상품 현재 재고파악
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&vPrdCode1&"' "			
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			'// 일자별로 정해진 수량 체크
			If rsget(0) >= vPrdCnt1 Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '0', '비밀의방 쿠폰', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '1등상품 재고초과 비당첨 처리', 'A')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
						 "values('"& eCouponID &"', '" & userid & "', '2','5000','비밀의방 쿠폰 5,000원-4만원이상','40000','"&Left(now(), 10)&" 00:00:00','"&Left(now(), 10)&" 23:59:59','',0,'system','app')"
				dbget.execute sqlstr

				'// for dev msg : 임시로 넣어두었습니다. 최종 이미지는 8/17~8/21까지는 img_banner_01.png / 8/24~8/28 img_banner_02.png 
				Response.write "OK|<div class='winCoupon' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick=""fnAPPpopupEvent('65688');return false;"" class='bnr'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/"&vcouponbannerimg&".png' alt='현상금을 노려라' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기'/></button></div>"
				dbget.close()	:	response.End
			Else
				'// 재고 있을경우
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '"&vPrdCode1&"', '"&vPrdName1&"', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '1등상품 당첨', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='winItem'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_01.png' alt='당첨을 축하합니다. 상품은 기본 배송지로 발송될 예정입니다' /></p><a href='' onclick=""fnAPPpopupBrowserURL('개인정보수정','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp');return false;"" class='btnAddress'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_address.png' alt='기본 배송지 확인하기' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기' /></button></div>"
				dbget.close()	:	response.End
			End If
	
		'// 2등 상품 당첨
		ElseIf renloop >= vPrd2St And renloop < vPrd2Ed Then
			'// 2등 상품 현재 재고파악
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&vPrdCode2&"' "			
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			'// 일자별로 정해진 수량 체크
			If rsget(0) >= vPrdCnt2 Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '0', '비밀의방 쿠폰', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '2등상품 재고초과 비당첨 처리', 'A')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
						 "values('"& eCouponID &"', '" & userid & "', '2','5000','비밀의방 쿠폰 5,000원-4만원이상','40000','"&Left(now(), 10)&" 00:00:00','"&Left(now(), 10)&" 23:59:59','',0,'system','app')"
				dbget.execute sqlstr

				Response.write "OK|<div class='winCoupon' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick=""fnAPPpopupEvent('65688');return false;"" class='bnr'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/"&vcouponbannerimg&".png' alt='현상금을 노려라' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기'/></button></div>"
				dbget.close()	:	response.End
			Else
				'// 재고 있을경우
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '"&vPrdCode2&"', '"&vPrdName2&"', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '2등상품 당첨', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='winItem'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_02.png' alt='당첨을 축하합니다. 상품은 기본 배송지로 발송될 예정입니다' /></p><a href='' onclick=""fnAPPpopupBrowserURL('개인정보수정','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp');return false;"" class='btnAddress'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_address.png' alt='기본 배송지 확인하기' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기' /></button></div>"
				dbget.close()	:	response.End
			End If

		'// 3등 상품 당첨
		ElseIf renloop >= vPrd3St And renloop < vPrd3Ed Then
			'// 3등 상품 현재 재고파악
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&vPrdCode3&"' "			
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			'// 일자별로 정해진 수량 체크
			If rsget(0) >= vPrdCnt3 Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '0', '비밀의방 쿠폰', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '3등상품 재고초과 비당첨 처리', 'A')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
						 "values('"& eCouponID &"', '" & userid & "', '2','5000','비밀의방 쿠폰 5,000원-4만원이상','40000','"&Left(now(), 10)&" 00:00:00','"&Left(now(), 10)&" 23:59:59','',0,'system','app')"
				dbget.execute sqlstr

				Response.write "OK|<div class='winCoupon' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick=""fnAPPpopupEvent('65688');return false;"" class='bnr'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/"&vcouponbannerimg&".png' alt='현상금을 노려라' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기'/></button></div>"
				dbget.close()	:	response.End
			Else
				'// 재고 있을경우
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '"&vPrdCode3&"', '"&vPrdName3&"', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '3등상품 당첨', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<div class='winItem'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_03.png' alt='당첨을 축하합니다. 상품은 기본 배송지로 발송될 예정입니다' /></p><a href='' onclick=""fnAPPpopupBrowserURL('개인정보수정','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp');return false;"" class='btnAddress'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_address.png' alt='기본 배송지 확인하기' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기' /></button></div>"
				dbget.close()	:	response.End
			End If

		'// 비당첨
		Else
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '"&vprocdate&"', '0', '비밀의방 쿠폰', getdate(), 'A')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '비당첨 쿠폰발급처리', 'A')"
			dbget.execute sqlstr

			'// 쿠폰 넣어준다.
			sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
					 "values('"& eCouponID &"', '" & userid & "', '2','5000','비밀의방 쿠폰 5,000원-4만원이상','40000','"&Left(now(), 10)&" 00:00:00','"&Left(now(), 10)&" 23:59:59','',0,'system','app')"
			dbget.execute sqlstr

			Response.write "OK|<div class='winCoupon' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/img_item_"&vdvalue&"_04.png' alt='비밀의 쿠폰 당첨을 축하합니다! 4만원이상 구매시 오천원 할인 쿠폰으로 앱에서만 사용 가능하며, 사용기한은 오늘 자정까지입니다' /></p><a href='' onclick=""fnAPPpopupEvent('65688');return false;"" class='bnr'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/"&vcouponbannerimg&".png' alt='현상금을 노려라' /></a><button type='button' class='btnclose' onclick='lyCloseW();return false'><img src='http://webimage.10x10.co.kr/eventIMG/2015/65479/btn_close.png' alt='당첨 레이어 팝업 닫기'/></button></div>"
			dbget.close()	:	response.End
		End If
	Else
		Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
		response.End

	End If

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->