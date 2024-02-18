<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ##What's your 미니언즈?
' History : 2015-07-13 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, eCouponID, RvchrNum, LoginUserid
Dim vQuery, strsql
Dim RvSelNum '// 상품 셀렉트 랜덤숫자
Dim RvConNum '// 당첨 랜덤숫자
Dim result1, result2
Dim vPstNum1, vPstNum2, vPstNum3, vPstNum4, vPstNum5, vPstNum6, vPstNum7 '// 일자별 한정갯수 셋팅
Dim vRvConNum1St, vRvConNum1Ed
Dim vRvConNum2St, vRvConNum2Ed
Dim vRvConNum3St, vRvConNum3Ed
Dim vRvConNum4St, vRvConNum4Ed
Dim vRvConNum5St, vRvConNum5Ed
Dim vRvConNum6St, vRvConNum6Ed
Dim vRvConNum7St, vRvConNum7Ed
Dim evtUserCell, refer, refip

	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	LoginUserid = GetLoginUserID

	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64826"
		eCouponID = 755
	Else
		eCode = "64805"
		eCouponID = 755
	End If


	'// 각 상품별 일자별 한정갯수 셋팅
	Select Case Trim(Left(Now(), 10))
		Case "2015-07-13" '// 이건 테스트 날짜용 셋팅임
			vPstNum1 = 1 '// 미니언즈 피규어
			vPstNum2 = 1 '// 미니언즈 스퀴시
			vPstNum3 = 1 '// 미니언즈 쇼퍼백
			vPstNum4 = 1 '// 미니언즈 비치볼
			vPstNum5 = 1 '// 미니언즈 우산
			vPstNum6 = 1 '// 미니언즈 스티커
			vPstNum7 = 1 '// 미니언즈 예매권

		Case "2015-07-14"
			vPstNum1 = 60 '// 미니언즈 피규어
			vPstNum2 = 20 '// 미니언즈 스퀴시
			vPstNum3 = 20 '// 미니언즈 쇼퍼백
			vPstNum4 = 10 '// 미니언즈 비치볼
			vPstNum5 = 10 '// 미니언즈 우산
			vPstNum6 = 25 '// 미니언즈 스티커
			vPstNum7 = 20 '// 미니언즈 예매권

		Case "2015-07-15"
			vPstNum1 = 60 '// 미니언즈 피규어
			vPstNum2 = 20 '// 미니언즈 스퀴시
			vPstNum3 = 20 '// 미니언즈 쇼퍼백
			vPstNum4 = 5 '// 미니언즈 비치볼
			vPstNum5 = 5 '// 미니언즈 우산
			vPstNum6 = 25 '// 미니언즈 스티커
			vPstNum7 = 20 '// 미니언즈 예매권

		Case "2015-07-16"
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 10 '// 미니언즈 스퀴시
			vPstNum3 = 10 '// 미니언즈 쇼퍼백
			vPstNum4 = 5 '// 미니언즈 비치볼
			vPstNum5 = 5 '// 미니언즈 우산
			vPstNum6 = 25 '// 미니언즈 스티커
			vPstNum7 = 10 '// 미니언즈 예매권

		Case "2015-07-17"
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 20 '// 미니언즈 스퀴시
			vPstNum3 = 20 '// 미니언즈 쇼퍼백
			vPstNum4 = 10 '// 미니언즈 비치볼
			vPstNum5 = 10 '// 미니언즈 우산
			vPstNum6 = 55 '// 미니언즈 스티커
			vPstNum7 = 25 '// 미니언즈 예매권

		Case "2015-07-18"
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 15 '// 미니언즈 스퀴시
			vPstNum3 = 15 '// 미니언즈 쇼퍼백
			vPstNum4 = 10 '// 미니언즈 비치볼
			vPstNum5 = 10 '// 미니언즈 우산
			vPstNum6 = 35 '// 미니언즈 스티커
			vPstNum7 = 10 '// 미니언즈 예매권

		Case "2015-07-19"
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 15 '// 미니언즈 스퀴시
			vPstNum3 = 15 '// 미니언즈 쇼퍼백
			vPstNum4 = 10 '// 미니언즈 비치볼
			vPstNum5 = 10 '// 미니언즈 우산
			vPstNum6 = 35 '// 미니언즈 스티커
			vPstNum7 = 15 '// 미니언즈 예매권

		Case "2015-07-20"
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 0 '// 미니언즈 스퀴시
			vPstNum3 = 0 '// 미니언즈 쇼퍼백
			vPstNum4 = 0 '// 미니언즈 비치볼
			vPstNum5 = 0 '// 미니언즈 우산
			vPstNum6 = 0 '// 미니언즈 스티커
			vPstNum7 = 0 '// 미니언즈 예매권

		Case "2015-07-21"
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 0 '// 미니언즈 스퀴시
			vPstNum3 = 0 '// 미니언즈 쇼퍼백
			vPstNum4 = 0 '// 미니언즈 비치볼
			vPstNum5 = 0 '// 미니언즈 우산
			vPstNum6 = 0 '// 미니언즈 스티커
			vPstNum7 = 0 '// 미니언즈 예매권

		Case "2015-07-22"
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 0 '// 미니언즈 스퀴시
			vPstNum3 = 0 '// 미니언즈 쇼퍼백
			vPstNum4 = 0 '// 미니언즈 비치볼
			vPstNum5 = 0 '// 미니언즈 우산
			vPstNum6 = 0 '// 미니언즈 스티커
			vPstNum7 = 0 '// 미니언즈 예매권

		Case Else
			vPstNum1 = 0 '// 미니언즈 피규어
			vPstNum2 = 0 '// 미니언즈 스퀴시
			vPstNum3 = 0 '// 미니언즈 쇼퍼백
			vPstNum4 = 0 '// 미니언즈 비치볼
			vPstNum5 = 0 '// 미니언즈 우산
			vPstNum6 = 0 '// 미니언즈 스티커
			vPstNum7 = 0 '// 미니언즈 예매권
	End Select

	'// 각 상품별 확률 셋팅(일단 각 당첨 확률은 1%로 조정)
	vRvConNum1St = 1 '// 미니언즈 피규어
	vRvConNum1Ed = 1 '// 미니언즈 피규어

	vRvConNum2St = 120 '// 미니언즈 스퀴시
	vRvConNum2Ed = 141 '// 미니언즈 스퀴시

	vRvConNum3St = 220 '// 미니언즈 쇼퍼백
	vRvConNum3Ed = 241 '// 미니언즈 쇼퍼백

	vRvConNum4St = 350 '// 미니언즈 비치볼
	vRvConNum4Ed = 361 '// 미니언즈 비치볼

	vRvConNum5St = 470 '// 미니언즈 우산
	vRvConNum5Ed = 481 '// 미니언즈 우산

	vRvConNum6St = 520 '// 미니언즈 스티커
	vRvConNum6Ed = 571 '// 미니언즈 스티커

	vRvConNum7St = 720 '// 미니언즈 예매권
	vRvConNum7Ed = 741 '// 미니언즈 예매권


'	vRvConNum1St = 1 '// 미니언즈 피규어
'	vRvConNum1Ed = 1000 '// 미니언즈 피규어

'	vRvConNum2St = 1 '// 미니언즈 스퀴시
'	vRvConNum2Ed = 1000 '// 미니언즈 스퀴시

'	vRvConNum3St = 1 '// 미니언즈 쇼퍼백
'	vRvConNum3Ed = 1000 '// 미니언즈 쇼퍼백

'	vRvConNum4St = 1 '// 미니언즈 비치볼
'	vRvConNum4Ed = 1000 '// 미니언즈 비치볼

'	vRvConNum5St = 1 '// 미니언즈 우산
'	vRvConNum5Ed = 1000 '// 미니언즈 우산

'	vRvConNum6St = 1 '// 미니언즈 스티커
'	vRvConNum6Ed = 1000 '// 미니언즈 스티커

'	vRvConNum7St = 1 '// 미니언즈 예매권
'	vRvConNum7Ed = 1000 '// 미니언즈 예매권


	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(LoginUserid&"10")


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If


	'// expiredate
	If not(left(Now(),10)>="2015-07-13" and left(Now(),10)<"2015-07-23") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If


	'// 7월 14일만 10시부터 응모 가능함, 그 이후에는 0시 기준으로 응모가능
	If Left(Now(), 10) = "2015-07-14" Then
		If Not(TimeSerial(Hour(Now()), minute(Now()), second(Now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(Now()), minute(Now()), second(Now())) < TimeSerial(23, 59, 59)) Then
			Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
			Response.End
		End If
	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "Err|로그인 후 참여하실 수 있습니다."
		response.End
	End If


	'// 캐릭터 랜덤 셀렉트
	randomize
	RvchrNum=int(Rnd*5)+1

	'// 당첨 상품 랜덤 셀렉트
	randomize
	RvSelNum=int(Rnd*5)+1


	Select Case Trim(RvSelNum)

		Case "1" '// 미니언즈 피규어(총120개)
			
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
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
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 현재 재고 파악(미니언즈 피규어)
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&RvSelNum&"' "			
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 일자별로 정해진 수량 체크
				If rsget(0) >= vPstNum1 Then
					'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 피규어 재고초과 비당첨', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End

				Else '// 수량이 남아 있을경우

					'// 랜덤숫자 부여
					randomize
					RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If RvConNum >= vRvConNum1St And RvConNum < vRvConNum1Ed Then
						'// 당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '1', '미니언즈 피규어', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 피규어 당첨', 'A')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_pack.png' alt='미니언즈의 깜짝 선물! 미니언즈 미스테리팩' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					Else
						'// 비당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 피규어 비당첨', 'A')"
						dbget.execute sqlstr

						'// 쿠폰 넣어준다.
						sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
								 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					End If
				End If
				rsget.close
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "2" '// 미니언즈 스퀴시(총100개)

			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
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
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 현재 재고 파악(미니언즈 스퀴시)
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&RvSelNum&"' "			
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 일자별로 정해진 수량 체크
				If rsget(0) >= vPstNum2 Then
					'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 스퀴시 재고초과 비당첨', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End

				Else '// 수량이 남아 있을경우

					'// 랜덤숫자 부여
					randomize
					RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If RvConNum >= vRvConNum2St And RvConNum < vRvConNum2Ed Then
						'// 당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '2', '미니언즈 스퀴시', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 스퀴시 당첨', 'A')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_squish.png' alt='미니언즈의 깜짝 선물! 미니언즈 스퀴시' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					Else
						'// 비당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 스퀴시 비당첨', 'A')"
						dbget.execute sqlstr

						'// 쿠폰 넣어준다.
						sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
								 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					End If
				End If
				rsget.close
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "3" '// 미니언즈 쇼퍼백(총100개)

			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
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
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 현재 재고 파악(미니언즈 쇼퍼백)
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&RvSelNum&"' "			
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 일자별로 정해진 수량 체크
				If rsget(0) >= vPstNum3 Then
					'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 쇼퍼백 재고초과 비당첨', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End

				Else '// 수량이 남아 있을경우

					'// 랜덤숫자 부여
					randomize
					RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If RvConNum >= vRvConNum3St And RvConNum < vRvConNum3Ed Then
						'// 당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '3', '미니언즈 쇼퍼백', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 쇼퍼백 당첨', 'A')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_bag.png' alt='미니언즈의 깜짝 선물! 미니언즈 쇼퍼백' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					Else
						'// 비당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 쇼퍼백 비당첨', 'A')"
						dbget.execute sqlstr

						'// 쿠폰 넣어준다.
						sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
								 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					End If
				End If
				rsget.close
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "4" '// 미니언즈 비치볼(총50개)

			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
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
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 현재 재고 파악(미니언즈 비치볼)
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&RvSelNum&"' "			
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 일자별로 정해진 수량 체크
				If rsget(0) >= vPstNum4 Then
					'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 비치볼 재고초과 비당첨', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End

				Else '// 수량이 남아 있을경우

					'// 랜덤숫자 부여
					randomize
					RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If RvConNum >= vRvConNum4St And RvConNum < vRvConNum4Ed Then
						'// 당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '4', '미니언즈 비치볼', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 비치볼 당첨', 'A')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_ball.png' alt='미니언즈의 깜짝 선물! 미니언즈 비치볼' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					Else
						'// 비당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 비치볼 비당첨', 'A')"
						dbget.execute sqlstr

						'// 쿠폰 넣어준다.
						sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
								 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					End If
				End If
				rsget.close
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "5" '// 미니언즈 우산(총50개)
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
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
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 현재 재고 파악(미니언즈 우산)
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&RvSelNum&"' "			
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 일자별로 정해진 수량 체크
				If rsget(0) >= vPstNum5 Then
					'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 우산 재고초과 비당첨', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End

				Else '// 수량이 남아 있을경우

					'// 랜덤숫자 부여
					randomize
					RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If RvConNum >= vRvConNum5St And RvConNum < vRvConNum5Ed Then
						'// 당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '5', '미니언즈 우산', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 우산 당첨', 'A')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_umbrella.png' alt='미니언즈의 깜짝 선물! 미니언즈 우산' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					Else
						'// 비당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 우산 비당첨', 'A')"
						dbget.execute sqlstr

						'// 쿠폰 넣어준다.
						sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
								 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					End If
				End If
				rsget.close
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "6" '// 미니언즈 스티커(총200개)
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
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
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 현재 재고 파악(미니언즈 스티커)
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&RvSelNum&"' "			
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 일자별로 정해진 수량 체크
				If rsget(0) >= vPstNum6 Then
					'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 스티커 재고초과 비당첨', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End

				Else '// 수량이 남아 있을경우

					'// 랜덤숫자 부여
					randomize
					RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If RvConNum >= vRvConNum6St And RvConNum < vRvConNum6Ed Then
						'// 당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '6', '미니언즈 스티커', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 스티커 당첨', 'A')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_stiker.png' alt='미니언즈의 깜짝 선물! 미니언즈 스티커' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					Else
						'// 비당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 스티커 비당첨', 'A')"
						dbget.execute sqlstr

						'// 쿠폰 넣어준다.
						sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
								 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					End If
				End If
				rsget.close
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

		Case "7" '// 미니언즈 예매권(총100개)
			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
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
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 현재 재고 파악(미니언즈 예매권)
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&RvSelNum&"' "			
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 일자별로 정해진 수량 체크
				If rsget(0) >= vPstNum7 Then
					'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 예매권 재고초과 비당첨', 'A')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
							 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
					dbget.execute sqlstr

					Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End

				Else '// 수량이 남아 있을경우

					'// 랜덤숫자 부여
					randomize
					RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If RvConNum >= vRvConNum7St And RvConNum < vRvConNum7Ed Then
						'// 당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '7', '미니언즈 예매권', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 예매권 당첨', 'A')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_movie.png' alt='미니언즈의 깜짝 선물! 미니언즈 예매권' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					Else
						'// 비당첨
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
						dbget.execute sqlstr

						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니언즈 예매권 비당첨', 'A')"
						dbget.execute sqlstr

						'// 쿠폰 넣어준다.
						sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
								 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
						dbget.execute sqlstr

						Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
						dbget.close()	:	response.End
					End If
				End If
				rsget.close
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If


		Case Else '// 이도 저도 아니면 걍 쿠폰줌

			'// 응모내역 검색
			sqlstr = "select top 1 sub_opt1 , sub_opt2 "
			sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
			sqlstr = sqlstr & " where evt_code="& eCode &""
			sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If Not(rsget.bof Or rsget.Eof) Then
				'// 기존에 응모 했을때 값
				result1 = rsget(0) '//응모여부
				result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 나머지 1~7까진 상품당첨
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
			End IF
			rsget.close


			'// 일자별 응모한 내역이 있다면(쿠폰당첨 포함) 이미 응모하셨습니다. 출력
			If result1 <> "" Then
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

			If result1 = "" Then '// 이미 응모했는지 다시한번 체크
				'// 보통은 1~7에서 선택되어져서 이걸 타면 안되는데 혹 이상하게 들어옴 응모내역 없음 걍 쿠폰 줌
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '미니언즈 텐바이텐 쿠폰', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '요상하게 들어와서 비당첨 처리', 'A')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
						 "values('"& eCouponID &"', '" & LoginUserid & "', '2','3000','미니언즈 쿠폰 3,000원-3만원이상','30000','2015-07-14 00:00:00','2015-07-31 23:59:59','',0,'system','app')"
				dbget.execute sqlstr

				Response.write "OK|<div class='inner' style='display:block'><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_0"&RvchrNum&".png' alt='' /></div><div><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/img_minions_with_coupon.png' alt='미니언즈의 깜짝 선물! 텐바이텐 쿠폰' /></div><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/64805/btn_close.png' alt='닫기' /></button>	</div>"
				dbget.close()	:	response.End
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If

	End Select

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->