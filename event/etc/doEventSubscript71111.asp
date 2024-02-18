<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description :  tab2 : [참여이벤트] 도리를 찾아서
' History : 2016.06.10 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode, eCouponID, LoginUserid, sqlStr, result1, result2, result3, device, RvSelNum, evtUserCell, refip, refer, md5userid, cnt, vCnt
Dim RvConNum, vPstNum1, vPstNum2, vPstNum3 '// 일자별 한정갯수 셋팅
Dim vRvConNum1St, vRvConNum1Ed
Dim vRvConNum2St, vRvConNum2Ed
Dim vRvConNum3St, vRvConNum3Ed

IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66148"
	eCouponID	= "2795"
Else
	eCode 		= "71111"
	eCouponID	= "873"
End If

LoginUserid		= getLoginUserid()
evtUserCell		= get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호
refip 			= Request.ServerVariables("REMOTE_ADDR")
refer 			= request.ServerVariables("HTTP_REFERER")
md5userid 		= md5(LoginUserid&"10")
If isapp = "1" Then device = "A" Else device = "M" End If 


'// 각 상품별 일자별 한정갯수 셋팅
Select Case Trim(Left(Now(), 10))
	Case "2016-06-09" '// 이건 테스트 날짜용 셋팅임
		vPstNum1 = 1 '// 영화예매권
		vPstNum2 = 1 '// 트럼프 카드
		vPstNum3 = 1 '// 아이폰6 케이스
	Case "2016-06-10"
		vPstNum1 = 1 '// 영화예매권
		vPstNum2 = 1 '// 트럼프 카드
		vPstNum3 = 1 '// 아이폰6 케이스
	Case "2016-06-11"
		vPstNum1 = 1 '// 영화예매권
		vPstNum2 = 1 '// 트럼프 카드
		vPstNum3 = 1 '// 아이폰6 케이스
	Case "2016-06-12"
		vPstNum1 = 1 '// 영화예매권
		vPstNum2 = 1 '// 트럼프 카드
		vPstNum3 = 1 '// 아이폰6 케이스
	Case "2016-06-13"
		vPstNum1 = 40 '// 영화예매권
		vPstNum2 = 30 '// 트럼프 카드
		vPstNum3 = 5 '// 아이폰6 케이스
	Case "2016-06-14"
		vPstNum1 = 71 '// 영화예매권
		vPstNum2 = 51 '// 트럼프 카드
		vPstNum3 = 10 '// 아이폰6 케이스
	Case "2016-06-15"
		vPstNum1 = 30 '// 영화예매권
		vPstNum2 = 30 '// 트럼프 카드
		vPstNum3 = 0 '// 아이폰6 케이스
	Case "2016-06-16"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 30 '// 트럼프 카드
		vPstNum3 = 0 '// 아이폰6 케이스
	Case "2016-06-17"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 10 '// 트럼프 카드
		vPstNum3 = 0 '// 아이폰6 케이스
	Case "2016-06-18"
		vPstNum1 = 0 '// 영화예매권
		vPstNum2 = 0 '// 트럼프 카드
		vPstNum3 = 0 '// 아이폰6 케이스
	Case "2016-06-19"
		vPstNum1 = 0 '// 영화예매권
		vPstNum2 = 0 '// 트럼프 카드
		vPstNum3 = 0 '// 아이폰6 케이스
	Case "2016-06-20"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 10 '// 트럼프 카드
		vPstNum3 = 0 '// 아이폰6 케이스
	Case "2016-06-21"
		vPstNum1 = 10 '// 영화예매권
		vPstNum2 = 13 '// 트럼프 카드		'13
		vPstNum3 = 0 '// 아이폰6 케이스
	Case "2016-06-22"
		vPstNum1 = 0 '// 영화예매권
		vPstNum2 = 0 '// 트럼프 카드
		vPstNum3 = 0 '// 아이폰6 케이스
End Select

'// 각 상품별 확률 셋팅
'10%
vRvConNum1St = 300 '// 영화예매권
vRvConNum1Ed = 400 '// 영화예매권
'5%
vRvConNum2St = 600 '// 트럼프 카드
vRvConNum2Ed = 650 '// 트럼프 카드
'3%
vRvConNum3St = 900 '// 아이폰6 케이스
vRvConNum3Ed = 930 '// 아이폰6 케이스

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// expiredate
If not(Left(Now(),10) >= "2016-06-09" and Left(Now(),10) < "2016-06-23") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

'// 당첨 상품 랜덤 셀렉트
Randomize
RvSelNum = Int(Rnd * 3) + 1
'RvSelNum = 2

Select Case Trim(RvSelNum)
	Case "1" '// 영화 예매권(총 180개)
		'// 응모내역 검색
		sqlstr = ""
		sqlstr = sqlstr & " SELECT TOP 1 sub_opt1 , sub_opt2 , sub_opt3 "
		sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " WHERE evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		rsget.Open sqlstr, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			'// 기존에 응모 했을때 값
			result1 = rsget(0) '//응모회수
			result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
			result3 = rsget(2) '미사용
		Else
			'// 최초응모
			result1 = ""
			result2 = ""
			result3 = ""
		End IF
		rsget.close

		'// 현재 재고 파악(1번..영화 예매권)
		sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = '11111' "			
		rsget.Open sqlstr, dbget, 1
			cnt = rsget("cnt")
		rsget.close

		'// 당일 최초 응모자면
		If result1 = "" Then
			'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
			If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End
			End If

			sqlstr = ""
			sqlstr = sqlStr & " SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid = '"&LoginUserid&"' and sub_opt2 in ('11111', '22222', '33333') "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				vCnt = rsget("cnt")
			End IF
			rsget.close
			
			If vCnt > 0 Then		'1회라도 상품 당첨 이력이 있다면 비당첨 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '상품당첨완료로비당첨', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End
			End If

			If cnt >= vPstNum1 Then
				'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 비당첨', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End

			Else
				'// 랜덤숫자 부여
				Randomize
				RvConNum=int(Rnd*1000)+1 '100%
				If RvConNum >= vRvConNum1St And RvConNum < vRvConNum1Ed Then
					'// 최초응모자이고, 영화예매권 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '11111', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 당첨', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_movie.png' alt='축하드려요! 도리를 찾아서 영화 초대권 1인 1매 당첨! 당첨자 안내는 2016년 6월 27일 오후 텐바이텐 공지사항를 확인해 주세요!' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
					dbget.close()	:	response.End
				Else
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 비당첨', '"&device&"')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
					sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
					dbget.close()	:	response.End
				End If
			End If
		Else
			Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
			response.End
		End If
	Case "2" '// 트럼프카드(총 150개)
		'// 응모내역 검색
		sqlstr = ""
		sqlstr = sqlstr & " SELECT TOP 1 sub_opt1 , sub_opt2 , sub_opt3 "
		sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " WHERE evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		rsget.Open sqlstr, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			'// 기존에 응모 했을때 값
			result1 = rsget(0) '//응모회수
			result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
			result3 = rsget(2) '미사용
		Else
			'// 최초응모
			result1 = ""
			result2 = ""
			result3 = ""
		End IF
		rsget.close

		'// 현재 재고 파악(2번..트럼프카드)
		sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = '22222' "			
		rsget.Open sqlstr, dbget, 1
			cnt = rsget("cnt")
		rsget.close

		'// 당일 최초 응모자면
		If result1 = "" Then
			'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
			If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End
			End If

			sqlstr = ""
			sqlstr = sqlStr & " SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid = '"&LoginUserid&"' and sub_opt2 in ('11111', '22222', '33333') "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				vCnt = rsget("cnt")
			End IF
			rsget.close
			
			If vCnt > 0 Then		'1회라도 상품 당첨 이력이 있다면 비당첨 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '상품당첨완료로비당첨', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End
			End If

			If cnt >= vPstNum2 Then
				'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '트럼프카드 비당첨', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End

			Else
				'// 랜덤숫자 부여
				Randomize
				RvConNum=int(Rnd*1000)+1 '100%
				If RvConNum >= vRvConNum2St And RvConNum < vRvConNum2Ed Then
					'// 최초응모자이고, 트럼프카드 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '22222', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '트럼프카드', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_card.png' alt='축하드려요! 도리를 찾아서 트럼프 카드 1개 당첨! 당첨자 안내는 2016년 6월 27일 오후 텐바이텐 공지사항를 확인해 주세요!' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
					dbget.close()	:	response.End
				Else
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '트럼프카드 비당첨', '"&device&"')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
					sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
					dbget.close()	:	response.End
				End If
			End If
		Else
			Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
			response.End
		End If
	Case "3" '// 아이폰6 케이스(총 10개)
		'// 응모내역 검색
		sqlstr = ""
		sqlstr = sqlstr & " SELECT TOP 1 sub_opt1 , sub_opt2 , sub_opt3 "
		sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " WHERE evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
		rsget.Open sqlstr, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			'// 기존에 응모 했을때 값
			result1 = rsget(0) '//응모회수
			result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
			result3 = rsget(2) '미사용
		Else
			'// 최초응모
			result1 = ""
			result2 = ""
			result3 = ""
		End IF
		rsget.close

		'// 현재 재고 파악(3번..아이폰6 케이스)
		sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = '33333' "			
		rsget.Open sqlstr, dbget, 1
			cnt = rsget("cnt")
		rsget.close

		'// 당일 최초 응모자면
		If result1 = "" Then
			'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
			If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End
			End If

			sqlstr = ""
			sqlstr = sqlStr & " SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and userid = '"&LoginUserid&"' and sub_opt2 in ('11111', '22222', '33333') "
			rsget.Open sqlstr, dbget, 1
			If Not(rsget.bof Or rsget.Eof) Then
				vCnt = rsget("cnt")
			End IF
			rsget.close
			
			If vCnt > 0 Then		'1회라도 상품 당첨 이력이 있다면 비당첨 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" & vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '상품당첨완료로비당첨', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End
			End If

			If cnt >= vPstNum3 Then
				'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
				sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '아이폰6 케이스 비당첨', '"&device&"')"
				dbget.execute sqlstr

				'// 쿠폰 넣어준다.
				sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
				sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
				dbget.execute sqlstr
				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
				dbget.close()	:	response.End

			Else
				'// 랜덤숫자 부여
				Randomize
				RvConNum=int(Rnd*1000)+1 '100%
				If RvConNum >= vRvConNum3St And RvConNum < vRvConNum3Ed Then
					'// 최초응모자이고, 아이폰6 케이스 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '33333', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '아이폰6 케이스', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_iphone_case.png' alt='축하드려요! 도리를 찾아서 아이폰케이스 1개 당첨! 랜덤으로 발송되며, 당첨자 안내는 2016년 6월 27일 오후 텐바이텐 공지사항를 확인해 주세요!' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
					dbget.close()	:	response.End
				Else
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)"& vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '아이폰6 케이스 비당첨', '"&device&"')"
					dbget.execute sqlstr

					'// 쿠폰 넣어준다.
					sqlstr = "INSERT INTO [db_user].dbo.tbl_user_coupon(masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, startdate, expiredate, targetitemlist, couponmeaipprice, reguserid) " & vbcrlf
					sqlstr = sqlstr & " VALUES('"& eCouponID &"', '" & LoginUserid & "', '3', '2000', '텐바이텐 무료배송 쿠폰', '10000', '2016-06-13 00:00:00', '2016-06-30 23:59:59', '', 0, 'system')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/txt_win_coupon.png' alt='찾았다 도리! 무료배송쿠폰 지급완료 텐바이텐 배송 상품 구매시 사용 가능합니다.  ' /></p><button type='button' onclick='btnClose();' class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/71111/m/btn_close.png' alt='레이어팝업 닫기' /></button>"
					dbget.close()	:	response.End
				End If
			End If
		Else
			Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
			response.End
		End If
End Select
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->