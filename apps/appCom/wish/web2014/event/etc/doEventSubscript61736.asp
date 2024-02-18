<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
'### 주인을 찾습니다.
'### 2015-04-23 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	Dim eCode, vDisp, sqlstr
	Dim nowdate, refip, refer, renloop
	Dim LoginUserid, DayName, pdName1, pdName2, pdName3, pdName4, evtItemCode1, evtItemCode2, evtItemCode3, evtItemCode4, evtItemCnt1, evtItemCnt2, evtItemCnt3, evtItemCnt4
	Dim DayRightNumber, vEuserInputCode, result1, result2, result3, mode, md5userid, evtUserCell

	nowdate = now()
'	nowdate = "2015-04-27 10:00:00"

	LoginUserid = getLoginUserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	vEuserInputCode = requestcheckvar(request("euserInputCode"),4) '// 사용자 입력값
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  61762
	Else
		eCode   =  61736
	End If

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(LoginUserid&"10")

	Select Case Left(nowdate, 10)
		Case "2015-04-27"
			DayName = "mon"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"
			DayRightNumber = "1235"

			pdName2 = "단보 보조배터리(랜덤)"
			evtItemCode2 = "1190691"
			evtItemCnt2 = 50

			pdName3 = "울랄라 CANVAS POUCH(랜덤)"
			evtItemCode3 = "1060478"
			evtItemCnt3 = 100

			pdName4 = "스누피시리즈(랜덤)"
			evtItemCode4 = "1137825"
			evtItemCnt4 = 300

		Case "2015-04-28"
			DayName = "tue"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"
			DayRightNumber = "8687"

			pdName2 = "샤오미 5,000mAh"
			evtItemCode2 = "1234675"
			evtItemCnt2 = 138

			pdName3 = "무민 카드지갑"
			evtItemCode3 = "1239727"
			evtItemCnt3 = 396

			pdName4 = "아이스바 비누(컬러랜덤)"
			evtItemCode4 = "914161"
			evtItemCnt4 = 197

		Case "2015-04-29"
			DayName = "wed"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"
			DayRightNumber = "8282"

			pdName2 = "엄브렐러 보틀"
			evtItemCode2 = "1171539"
			evtItemCnt2 = 85

			pdName3 = "아이리버 이어마이크(컬러 랜덤)"
			evtItemCode3 = "1234645"
			evtItemCnt3 = 120

			pdName4 = "무민 마스코트 피규어(랜덤)"
			evtItemCode4 = "1229782"
			evtItemCnt4 = 250

		Case "2015-04-30"
			DayName = "thu"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"
			DayRightNumber = "5882"

			pdName2 = "비밀의 정원"
			evtItemCode2 = "1234646"
			evtItemCnt2 = 29

			pdName3 = "Card case(랜덤)"
			evtItemCode3 = "1146210"
			evtItemCnt3 = 66

			pdName4 = "Monotask 한달 플래너(랜덤)"
			evtItemCode4 = "1193295"
			evtItemCnt4 = 336

		Case "2015-05-01"
			DayName = "fri"

			pdName1 = "애플 아이패드 미니3 16GB"
			evtItemCode1 = "1182605"
			evtItemCnt1 = "1"
			DayRightNumber = "1551"

			pdName2 = "무민 원형접시(2size)"
			evtItemCode2 = "1181799"
			evtItemCnt2 = 49

			pdName3 = "캡슐 태엽 토이(랜덤)"
			evtItemCode3 = "1202920"
			evtItemCnt3 = 90

			pdName4 = "야광 달빛스티커 GRAY (small)"
			evtItemCode4 = "1234674"
			evtItemCnt4 = 193

	End Select


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If


	'// expiredate
	If not(left(nowdate,10)>="2015-04-27" and left(nowdate,10)<"2015-05-02") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If


	'// 해당일자 10시부터 응모 가능함, 그 이전에는 응모불가
	If Not(TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(nowdate), minute(nowdate), second(nowdate)) < TimeSerial(23, 59, 59)) Then
		Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
		Response.End
	End If

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
	


	Select Case Trim(mode)

		'// 아이패드
		Case "CaseFir"

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

			'// 현재 재고 파악(아이패드)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode1&"' "			
			rsget.Open sqlstr, dbget, 1
			If rsget(0) > 0 Then
				Response.Write "Err|이미 SOLDOUT된 상품 입니다."
				response.End
			End If
			rsget.close

			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then

				'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 기존에 아이패드에 당첨된 사람이면 무조건 비당첨 처리함.
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
				rsget.Open sqlstr, dbget, 1
				If rsget(0) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"', '기존아이패드당첨자라비당첨처리함.', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
				rsget.close
				
				'// 사용자가 입력한 값과 아이패드 정답값과 비교한다.
				If Trim(vEuserInputCode) = Trim(DayRightNumber) Then
					'// 최초응모자이고 입력한값이 아이패드 정답값과 같음 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode1&"', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"', '아이패드당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_01.jpg' alt='"&pdName1&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button><div style='position:absolute; bottom:3%; left:0; width:100%; text-align:center;'><strong style='font-size:11px; color:#000; font-weight:normal;'>"&md5userid&"</strong></div></div>"
					dbget.close()	:	response.End
				Else
					'// 같지않을경우 비당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"','비당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
					If Trim(result2)<>"0" Then
						Response.Write "alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"
						response.End
					Else
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If

						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아이패드에 당첨되면	 비당첨 처리함.
						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
						rsget.Open sqlstr, dbget, 1
						If rsget(0) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"', '기존아이패드당첨자라비당첨처리함.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If

						'// kakao에 값이 있고 해당일 기존 당첨자도 아니고, 기존에 아이패드도 당첨 안됐는데 입력값과 답이 같으면 아이패드 당첨 처리
						If Trim(vEuserInputCode) = Trim(DayRightNumber) Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode1&"'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"', '2번째 도전 아이패드 당첨', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_01.jpg' alt='"&pdName1&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button><div style='position:absolute; bottom:3%; left:0; width:100%; text-align:center;'><strong style='font-size:11px; color:#000; font-weight:normal;'>"&md5userid&"</strong></div></div>"
							dbget.close()	:	response.End

						Else
							'// 값이 틀릴경우 비당첨 처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value2, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '"&DayRightNumber&"','비당첨(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If



		'// 일자별 두번째 상품
		Case "CaseSec"

			'// 응모확률 랜덤
			randomize
			renloop=int(Rnd*1000)+1 '100%

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

			'// 현재 재고 파악(두번째 상품)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode2&"' "			
			rsget.Open sqlstr, dbget, 1
			If rsget(0) >= evtItemCnt2 Then
				Response.Write "Err|이미 SOLDOUT된 상품 입니다."
				response.End
			End If
			rsget.close


			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then

				'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If


				'// 기존에 아이패드에 당첨된 사람이면 무조건 비당첨 처리함.
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
				rsget.Open sqlstr, dbget, 1
				If rsget(0) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '기존아이패드당첨자라비당첨처리함.', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
				rsget.close


				'// 1% 확률로 정답자를 가린다.
				If renloop >= 500 And renloop < 511 Then

					'// 최초응모자이고 확률에 해당되면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode2&"', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&vEuserInputCode&"', '"&pdName2&" 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_02.jpg' alt='"&pdName2&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button></div>"
					dbget.close()	:	response.End
				Else
	
					'// 확률에 속하지 않을경우 비당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&vEuserInputCode&"', '비당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
					If Trim(result2)<>"0" Then
						Response.Write "alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"
						response.End
					Else

						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If

						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아이패드에 당첨되면	 비당첨 처리함.
						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
						rsget.Open sqlstr, dbget, 1
						If rsget(0) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '기존아이패드당첨자라비당첨처리함.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If

						'// 1% 확률로 정답자를 가린다.
						If renloop >= 500 And renloop < 511 Then
							'// 확률에 속하면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode2&"'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '2번째 도전 "&pdName2&" 당첨', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_02.jpg' alt='"&pdName2&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button></div>"
							dbget.close()	:	response.End

						Else
							'// 값이 틀릴경우 비당첨 처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '비당첨(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If



		'// 일자별 세번째 상품
		Case "CaseThr"

			'// 응모확률 랜덤
			randomize
			renloop=int(Rnd*1000)+1 '100%

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

			'// 현재 재고 파악(세번째 상품)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode3&"' "			
			rsget.Open sqlstr, dbget, 1
			If rsget(0) >= evtItemCnt3 Then
				Response.Write "Err|이미 SOLDOUT된 상품 입니다."
				response.End
			End If
			rsget.close

			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then

				'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 기존에 아이패드에 당첨된 사람이면 무조건 비당첨 처리함.
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
				rsget.Open sqlstr, dbget, 1
				If rsget(0) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '기존아이패드당첨자라비당첨처리함.', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
				rsget.close
				
				'// 2% 확률로 정답자를 가린다.
				If renloop >= 300 And renloop < 321 Then
					'// 최초응모자이고 확률에 해당되면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode3&"', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&vEuserInputCode&"', '"&pdName3&" 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_03.jpg' alt='"&pdName3&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 확률에 속하지 않을경우 비당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&vEuserInputCode&"', '비당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
					If Trim(result2)<>"0" Then
						Response.Write "alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"
						response.End
					Else

						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If

						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아이패드에 당첨되면	 비당첨 처리함.
						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
						rsget.Open sqlstr, dbget, 1
						If rsget(0) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '기존아이패드당첨자라비당첨처리함.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If

						'// 2% 확률로 정답자를 가린다.
						If renloop >= 300 And renloop < 321 Then
							'// 확률에 속하면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode3&"'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '2번째 도전 "&pdName3&" 당첨', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_03.jpg' alt='"&pdName3&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button></div>"
							dbget.close()	:	response.End

						Else
							'// 값이 틀릴경우 비당첨 처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '비당첨(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If



		'// 일자별 네번째 상품
		Case "Casefou"

			'// 응모확률 랜덤
			randomize
			renloop=int(Rnd*1000)+1 '100%

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

			'// 현재 재고 파악(네번째 상품)
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt2='"&evtItemCode4&"' "			
			rsget.Open sqlstr, dbget, 1
			If rsget(0) >= evtItemCnt4 Then
				Response.Write "Err|이미 SOLDOUT된 상품 입니다."
				response.End
			End If
			rsget.close

			'// 최초 응모자면
			If result1="" And result2="" And result3="" Then

				'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
				If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '전화번호중복비당첨처리', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If

				'// 기존에 아이패드에 당첨된 사람이면 무조건 비당첨 처리함.
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
				rsget.Open sqlstr, dbget, 1
				If rsget(0) > 0 Then
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '기존아이패드당첨자라비당첨처리함.', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
				rsget.close
				
				'// 3% 확률로 정답자를 가린다.
				If renloop >= 1 And renloop < 31 Then
					'// 최초응모자이고 확률에 해당되면 당첨처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', '"&evtItemCode4&"', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '"&vEuserInputCode&"', '"&pdName4&" 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_04.jpg' alt='"&pdName4&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button></div>"
					dbget.close()	:	response.End
				Else
					'// 확률에 속하지 않을경우 비당첨 처리
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '1', '0', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"','"&refip&"', '"&vEuserInputCode&"', '비당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
					dbget.close()	:	response.End
				End If
			'// 응모를 1회 했을경우
			ElseIf Trim(result1) = "1" Then
				'// 2회 이상 응모를 할경우엔 무조건 result3에 카카오 친구초대값에 kakao 값이 있어야함
				If Trim(result3)="kakao" Then
					'// 카카오 초대를 했다손 치더라도 기존에 응모가 당첨일 경우엔 더 이상 응모 안됨.
					If Trim(result2)<>"0" Then
						Response.Write "alert('이미 도전 성공하셨네요!\n내일 다시 도전해 주세요!');return false;"
						response.End
					Else

						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(nowdate, 10), eCode) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '전화번호중복비당첨처리.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If


						'// kakao에 값이 있고 2번째 도전자 이지만 이벤트 기간동안 한번이라도 아이패드에 당첨되면	 비당첨 처리함.
						sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='"&evtItemCode1&"' And userid='"&LoginUserid&"' "			
						rsget.Open sqlstr, dbget, 1
						If rsget(0) > 0 Then
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '기존아이패드당첨자라비당첨처리함.(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If

						'// 3% 확률로 정답자를 가린다.
						If renloop >= 1 And renloop < 31 Then
							'// 확률에 속하면 당첨처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '"&evtItemCode4&"'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '2번째 도전 "&pdName4&" 당첨', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyWin' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_win_"&DayName&"2_04.jpg' alt='"&pdName4&" 축하합니다. 마이텐바이텐에서 주소를 확인해 주세요!' /></p><button type='button' class='btnconfirm' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_confirm.png' alt='확인' /></button></div>"
							dbget.close()	:	response.End

						Else
							'// 값이 틀릴경우 비당첨 처리
							sqlstr = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt1 = '2' , sub_opt2 = '0'" + vbcrlf
							sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
							dbget.execute sqlstr

							'// 해당 유저의 로그값 집어넣는다.
							sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
							sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '"&vEuserInputCode&"', '비당첨(2번째 도전)', 'A')"
							dbget.execute sqlstr

							Response.write "OK|<div class='lyLose' style='display:block'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/txt_lose.png' alt='저런 꽝이예요! 다음 기회를 이용해주세요!' /></p><button type='button' class='btnclose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2015/61736/btn_colse_01.png' alt='닫기' /></button>	</div>"
							dbget.close()	:	response.End
						End If
					End If
				Else
					Response.Write "Err|카카오톡으로 친구에게 이벤트 알려주면,>?n도전기회가 한 번 더 생깁니다!"
					response.End
				End If
			
			'// 2번째 응모까지 다 했을경우(그이외의 경우에도 여기에 걸림)
			Else
				Response.Write "Err|오늘의 도전을 모두 했어요!>?n내일 다시 도전해 주세요!"
				response.End
			End If


		'// 카카오톡 초대시
		Case "kakao"
			'// 로그 넣음
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '"&refip&"', '카카오 초대 클릭', 'A')"
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
			ElseIf result1 = "1" And (result3 = "" Or isnull(result3) Or result3 <> "kakao" or result3 = "NULL") And result2="0" Then '//1회 참여시
				sqlstr = " update [db_event].[dbo].[tbl_event_subscript] set sub_opt3 = 'kakao'" + vbcrlf
				sqlstr = sqlstr & " where evt_code="& eCode &" and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"'" + vbcrlf
				dbget.execute sqlstr '// 응모 기회 한번 더줌

				Response.write "SUCCESS"
				dbget.close()	:	response.End
			ElseIf result1 = "1" And result3 = "kakao" Then
				Response.write "NOT2"
				Response.end
			ElseIf (result1 = "1" And result3 = "kakao") Or result1 = "2" Then 
				Response.write "END" '//오늘 참여 끝
				Response.End
			ElseIf Trim(result2) > 0 Then
				Response.write "complete" '//이미 당첨된 인원은 안됨.
				Response.End
			End If 
	End Select

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->