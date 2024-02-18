<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : 앵그리버드 행운을 날리새오!
' History : 2016-05-04 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode, LoginUserid, mode, sqlStr, result1, result2, result3, device, snsnum, snschk, RvSelNum, evtUserCell, refip, refer, md5userid, cnt
Dim RvConNum, vPstNum1, vPstNum2, vPstNum3, vPstNum4, vPstNum5 '// 일자별 한정갯수 셋팅
Dim vRvConNum1St, vRvConNum1Ed
Dim vRvConNum2St, vRvConNum2Ed
Dim vRvConNum3St, vRvConNum3Ed
Dim vRvConNum4St, vRvConNum4Ed
Dim vRvConNum5St, vRvConNum5Ed

IF application("Svr_Info") = "Dev" THEN
	eCode 		= "66119"
Else
	eCode 		= "70631"
End If

mode			= requestcheckvar(request("mode"),32)
snsnum 			= requestcheckvar(request("snsnum"),10)
LoginUserid		= getLoginUserid()
evtUserCell		= get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호
refip 			= Request.ServerVariables("REMOTE_ADDR")
refer 			= request.ServerVariables("HTTP_REFERER")
md5userid 		= md5(LoginUserid&"10")

If isapp = "1" Then device = "A" Else device = "M" End If 

'// 각 상품별 일자별 한정갯수 셋팅
Select Case Trim(Left(Now(), 10))
	Case "2016-05-10" '// 이건 테스트 날짜용 셋팅임
		vPstNum1 = 1 '// 영화예매권
		vPstNum2 = 1 '// 미니어처
		vPstNum3 = 1 '// 레고
		vPstNum4 = 1 '// 물총
		vPstNum5 = 1 '// 선글라스
	Case "2016-05-11"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 20 '// 미니어처
		vPstNum3 = 2 '// 레고
		vPstNum4 = 3 '// 물총
		vPstNum5 = 30 '// 선글라스
	Case "2016-05-12"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 20 '// 미니어처
		vPstNum3 = 2 '// 레고
		vPstNum4 = 3 '// 물총
		vPstNum5 = 30 '// 선글라스
	Case "2016-05-13"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 20 '// 미니어처
		vPstNum3 = 2 '// 레고
		vPstNum4 = 3 '// 물총
		vPstNum5 = 30 '// 선글라스
	Case "2016-05-14"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 10 '// 미니어처
		vPstNum3 = 1 '// 레고
		vPstNum4 = 2 '// 물총
		vPstNum5 = 15 '// 선글라스
	Case "2016-05-15"
		vPstNum1 = 20 '// 영화예매권
		vPstNum2 = 10 '// 미니어처
		vPstNum3 = 1 '// 레고
		vPstNum4 = 2 '// 물총
		vPstNum5 = 15 '// 선글라스
	Case "2016-05-16"
		vPstNum1 = 0 '// 영화예매권
		vPstNum2 = 0 '// 미니어처
		vPstNum3 = 0 '// 레고
		vPstNum4 = 0 '// 물총
		vPstNum5 = 0 '// 선글라스
	Case "2016-05-17"
		vPstNum1 = 0 '// 영화예매권
		vPstNum2 = 7 '// 미니어처
		vPstNum3 = 0 '// 레고
		vPstNum4 = 0 '// 물총
		vPstNum5 = 0 '// 선글라스
	Case "2016-05-18"
		vPstNum1 = 0 '// 영화예매권
		vPstNum2 = 0 '// 미니어처
		vPstNum3 = 0 '// 레고
		vPstNum4 = 0 '// 물총
		vPstNum5 = 0 '// 선글라스
	Case Else
		vPstNum1 = 0 '// 영화예매권
		vPstNum2 = 0 '// 미니어처
		vPstNum3 = 0 '// 레고
		vPstNum4 = 0 '// 물총
		vPstNum5 = 0 '// 선글라스
End Select

'// 각 상품별 확률 셋팅
'3%
vRvConNum1St = 100 '// 영화예매권
vRvConNum1Ed = 130 '// 영화예매권
'3%
vRvConNum2St = 200 '// 미니어처
vRvConNum2Ed = 230 '// 미니어처
'0.2%
vRvConNum3St = 300 '// 레고
vRvConNum3Ed = 302 '// 레고
'0.3%
vRvConNum4St = 400 '// 물총
vRvConNum4Ed = 403 '// 물총
'4%
vRvConNum5St = 500 '// 선글라스
vRvConNum5Ed = 540 '// 선글라스

'// 바로 접속시엔 오류 표시
If InStr(refer, "10x10.co.kr") < 1 Then
	Response.Write "Err|잘못된 접속입니다."
	Response.End
End If

'// expiredate
If not(Left(Now(),10) >= "2016-05-09" and Left(Now(),10) < "2016-05-19") Then
	Response.Write "Err|이벤트 응모 기간이 아닙니다."
	Response.End
End If

'// 로그인 여부 체크
If Not(IsUserLoginOK) Then
	Response.Write "Err|로그인 후 참여하실 수 있습니다."
	response.End
End If

If mode = "add" Then 		'//응모버튼 클릭
	'// 당첨 상품 랜덤 셀렉트
	Randomize
	RvSelNum = Int(Rnd * 5) + 1
'	RvSelNum = 1

	Select Case Trim(RvSelNum)
		Case "1" '// 영화 예매권(총125개)
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
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

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum1 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				Else
					'// 랜덤숫자 부여
					Randomize
					RvConNum=int(Rnd*1000)+1 '100%
					If RvConNum >= vRvConNum1St And RvConNum < vRvConNum1Ed Then
						'// 최초응모자이고, 영화예매권 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '11111', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_01.png' alt='영화 예매권 당첨' /></p>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum1 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					Else
						'// 랜덤숫자 부여
						Randomize
						RvConNum=int(Rnd*1000)+1 '100%
						If RvConNum >= vRvConNum1St And RvConNum < vRvConNum1Ed Then
							'// SNS 공유자이고, 영화예매권 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '11111'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_01.png' alt='영화 예매권 당첨' /></p>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '영화예매권 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "2" '// 미니어쳐(총100개)
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(2번..미니어쳐)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = '22222' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum2 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니어처인형 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				Else
					'// 랜덤숫자 부여
					Randomize
					RvConNum=int(Rnd*1000)+1 '100%
					If RvConNum >= vRvConNum2St And RvConNum < vRvConNum2Ed Then
						'// 최초응모자이고, 미니어쳐 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '22222', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니어처인형 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_02.png' alt='미니어쳐 당첨' /></p>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니어처인형 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum2 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니어처인형 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					Else
						'// 랜덤숫자 부여
						Randomize
						RvConNum=int(Rnd*1000)+1 '100%
						If RvConNum >= vRvConNum2St And RvConNum < vRvConNum2Ed Then
							'// SNS 공유자이고, 미니어쳐 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '22222'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니어처인형 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_02.png' alt='미니어쳐 당첨' /></p>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '미니어처인형 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "3" '// 레고(총10개)
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(3번..레고)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = '33333' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum3 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '레고 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				Else
					'// 랜덤숫자 부여
					Randomize
					RvConNum=int(Rnd*1000)+1 '100%
					If RvConNum >= vRvConNum3St And RvConNum < vRvConNum3Ed Then
						'// 최초응모자이고, 레고 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '33333', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '레고 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_03.png' alt='레고 당첨' /></p>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '레고 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum3 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '레고 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					Else
						'// 랜덤숫자 부여
						Randomize
						RvConNum=int(Rnd*1000)+1 '100%
						If RvConNum >= vRvConNum3St And RvConNum < vRvConNum3Ed Then
							'// SNS 공유자이고, 레고 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '33333'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '레고 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_03.png' alt='레고 당첨' /></p>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '레고 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "4" '// 물총(총15개)
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(4번..물총)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = '44444' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum4 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '물총 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				Else
					'// 랜덤숫자 부여
					Randomize
					RvConNum=int(Rnd*1000)+1 '100%
					If RvConNum >= vRvConNum4St And RvConNum < vRvConNum4Ed Then
						'// 최초응모자이고, 물총 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '44444', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '물총 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_04.png' alt='물총 당첨' /></p>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '물총 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum4 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '물총 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					Else
						'// 랜덤숫자 부여
						Randomize
						RvConNum=int(Rnd*1000)+1 '100%
						If RvConNum >= vRvConNum4St And RvConNum < vRvConNum4Ed Then
							'// SNS 공유자이고, 물총 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '44444'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '물총 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_04.png' alt='물총 당첨' /></p>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '물총 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case "5" '// 선글라스(총150개)
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
				result2 = rsget(1) '//당첨여부 0일 경우엔 비당첨, 상품코드가 들어가 있을경우엔 당첨
				result3 = rsget(2) '//SNS 2차 응모 확인용
			Else
				'// 최초응모
				result1 = ""
				result2 = ""
				result3 = ""
			End IF
			rsget.close

			'// 현재 재고 파악(5번..선글라스)
			sqlstr = "select count(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2 = '55555' "			
			rsget.Open sqlstr, dbget, 1
				cnt = rsget("cnt")
			rsget.close

			'// 최초 응모자면
			If result1 = "" Then
				'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
				If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr
					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨처리', '"&device&"')"
					dbget.execute sqlstr
					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				End If

				If cnt >= vPstNum5 Then
					'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '선글라스 비당첨', '"&device&"')"
					dbget.execute sqlstr

					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
					dbget.close()	:	response.End
				Else
					'// 랜덤숫자 부여
					Randomize
					RvConNum=int(Rnd*1000)+1 '100%
					If RvConNum >= vRvConNum5St And RvConNum < vRvConNum5Ed Then
						'// 최초응모자이고, 선글라스 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '55555', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '선글라스 당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_05.png' alt='선글라스 당첨' /></p>"
						dbget.close()	:	response.End
					Else
						sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', '"&device&"')"
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '선글라스 비당첨', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
				End If
			ElseIf Trim(result1) = "1" Then
				If (Trim(result3)="ka") OR (Trim(result3)="tw") OR (Trim(result3)="fb") Then
					'// 같은 전화번호로 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함----------------
					If event_userCell_Selection(evtUserCell, Left(now(), 10), eCode) > 0 Then
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '전화번호중복 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					End If
	
					If cnt >= vPstNum5 Then
						'// 정해진 수량이 넘었을 경운 무조건 꽝 처리
						sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
						sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
						dbget.execute sqlstr
						'// 해당 유저의 로그값 집어넣는다.
						sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
						sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '선글라스 비당첨(2번째 도전)', '"&device&"')"
						dbget.execute sqlstr
						Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
						dbget.close()	:	response.End
					Else
						'// 랜덤숫자 부여
						Randomize
						RvConNum=int(Rnd*1000)+1 '100%
						If RvConNum >= vRvConNum5St And RvConNum < vRvConNum5Ed Then
							'// SNS 공유자이고, 선글라스 잔량이 있고, 입력한값이 난수당첨이면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '55555'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '선글라스 당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_05.png' alt='선글라스 당첨' /></p>"
							dbget.close()	:	response.End
						Else
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and datediff(day,regdate,getdate()) = 0 "
							dbget.execute sqlstr
							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '선글라스 비당첨(2번째도전)', '"&device&"')"
							dbget.execute sqlstr
							Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|친구 초대시>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			Else
				Response.Write "Err|이미 참여하셨습니다.>?n내일 다시 참여해 주세요."
				response.End
			End If
		Case Else
			Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_win_06.png' alt='꽝' /></p>"
			Response.End
	End Select
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
			Response.write "OK|tw|<div><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_roulette.gif' alt='룰렛이미지' /></div><button type='button' class='btnFly' onclick='checkform();return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/btn_fly.png' alt='날리기 GO!' /></button><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/bg_blank.png' alt='' /></div>"
		ElseIf snsnum = "fb" Then
			Response.write "OK|fb|<div><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_roulette.gif' alt='룰렛이미지' /></div><button type='button' class='btnFly' onclick='checkform();return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/btn_fly.png' alt='날리기 GO!' /></button><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/bg_blank.png' alt='' /></div>"
		ElseIf snsnum = "ka" Then
			Response.write "OK|ka|<div><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_roulette.gif' alt='룰렛이미지' /></div><button type='button' class='btnFly' onclick='checkform();return false;' ><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/btn_fly.png' alt='날리기 GO!' /></button><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/70631/m/bg_blank.png' alt='' /></div>"
		Else
			Response.write "error"
		End If
		dbget.close()	:	response.End
	ElseIf CStr(result1) <> "" And (snschk = "ka" or snschk = "tw" or snschk = "fb") Then	'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
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