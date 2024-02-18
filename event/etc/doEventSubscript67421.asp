<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'###########################################################
' Description : 행운을 맞춰봐호우!
' History : 2015.11.19 원승현
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, eCouponID, RvchrNum, LoginUserid, deviceGubun, snsGubun
Dim vQuery, strsql
Dim RvSelNum '// 상품 셀렉트 랜덤숫자
Dim RvConNum '// 당첨 랜덤숫자
Dim result1, result2, result3
Dim evtUserCell, refer, refip
Dim vHiter, vGlassBottle, vTumblr1, vTumblr2
Dim vHiterSt, vHiterEd, vGlassBottleSt, vGlassBottleEd, vTumblr1St, vTumblr1Ed, vTumblr2St, vTumblr2Ed, vQueryCheck, imgLoop, imgLoopVal

	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	mode = requestcheckvar(request("mode"),32)
	snsGubun = requestcheckvar(request("snsGubun"),32)
	userid = GetEncLoginUserID


	'// 디바이스 구분
	If isApp = "1" Then
		deviceGubun = "A"
	Else
		deviceGubun = "M"
	End If

	evtUserCell = get10x10onlineusercell(userid) '// 참여한 회원 핸드폰번호

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65954"
	Else
		eCode = "67421"
	End If


	'// 꽝 이미지 랜덤
	randomize
	imgLoop=int(Rnd*8)+1
	Select Case Trim(imgLoop)
		Case "1"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose1.png"
		Case "2"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose2.png"
		Case "3"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose3.png"
		Case "4"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose4.png"
		Case "5"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose5.png"
		Case "6"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose6.png"
		Case "7"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose7.png"
		Case "8"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose8.png"
		Case Else
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_lose1.png"
	End Select

	'// 각 상품별 일자별 한정갯수 셋팅
	Select Case Trim(Left(Now(), 10))
		Case "2015-11-23" 
			vHiter = 1
			vGlassBottle = 20
			vTumblr1 = 30
			vTumblr2 = 30

		Case "2015-11-24"
			vHiter = 1
			vGlassBottle = 20
			vTumblr1 = 30
			vTumblr2 = 30

		Case "2015-11-25"
			vHiter = 1
			vGlassBottle = 20
			vTumblr1 = 30
			vTumblr2 = 30

		Case "2015-11-26"
			vHiter = 1
			vGlassBottle = 20
			vTumblr1 = 30
			vTumblr2 = 30

		Case "2015-11-27"
			vHiter = 1
			vGlassBottle = 23
			vTumblr1 = 30
			vTumblr2 = 30

		Case Else
			vHiter = 0
			vGlassBottle = 0
			vTumblr1 = 0
			vTumblr2 = 0
			'vHiter = 1
			'vGlassBottle = 1
			'vTumblr1 = 1
			'vTumblr2 = 1

	End Select

	'// 각 상품별 확률 셋팅
	vHiterSt = 1 '// 에코히터(0.1%)
	vHiterEd = 2 '// 에코히터(0.1%)

	vGlassBottleSt = 100 '// 기상예측 유리병(1%)
	vGlassBottleEd = 110 '// 기상예측 유리병(1%)

	vTumblr1St = 500 '// 호우호우텀블러1(5%)
	vTumblr1Ed = 550 '// 호우호우텀블러1(5%)

	vTumblr2St = 700 '// 호우호우텀블러2(5%)
	vTumblr2Ed = 750 '// 호우호우텀블러2(5%)

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(userid&"10")


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	Select Case Trim(mode)
		Case "add"

			'// expiredate
			If not(left(Now(),10)>="2015-11-23" and left(Now(),10)<"2015-11-28") Then
			'If not(left(Now(),10)>="2015-11-19" and left(Now(),10)<"2015-11-28") Then
				Response.Write "Err|이벤트 응모 기간이 아닙니다."
				Response.End
			End If


			'// 11월 23일만 10시부터 응모 가능함, 그 이후에는 0시 기준으로 응모가능
			If Left(Now(), 10) = "2015-11-23" Then
			'If Left(Now(), 10) = "2015-11-19" Then
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


			'// 당첨 상품 랜덤 셀렉트
			randomize
			RvSelNum=int(Rnd*4)+1
'			RvSelNum = 1

			Select Case Trim(RvSelNum)
				Case "1" '// 리플렉트 에코히터(총5개)
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 비당첨, 1-에코히터, 2-기상예측유리병, 3-호우호우텀블러1, 4-호우호우텀블러2
						result3 = rsget(2) '// 일단 안씀
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close
					If Trim(result1)="" Then
						'// 응모내역이 없을시
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
						If userBlackListCheck(userid) Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 현재 재고 파악(리플렉트에코히터)
						'// 일자별로 정해진 수량 체크
						If chkProductCntToday(eCode, "1") >= vHiter Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "에코히터재고초과비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						Else
							'// 수량이 남아 있을경우
							'// 랜덤숫자 부여
							randomize
							RvConNum=int(Rnd*1000)+1 '100%
							'// 당첨확률 0.1%
							If RvConNum >= vHiterSt And RvConNum < vHiterEd Then
								'// 당첨
								Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "리플렉트 에코히터 당첨", imgLoopVal, "1")
								dbget.close()	:	response.End
							Else
								'// 비당첨
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "리플렉트 에코히터 비당첨", imgLoopVal, "0")
								dbget.close()	:	response.End
							End If
						End If
					Else
						'// 응모를 1회 했을시
						If Left(now(), 10) >= "2015-11-27" Then
							Response.Write "Err|하루 1회만 응모 가능합니다."
						Else
							Response.Write "Err|하루 1회만 응모 가능합니다.>?n내일 다시 응모해주세요. :)"
						End If
						response.End
					End If

				Case "2" '// 기상예측 유리병(총 100개)
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 비당첨, 1-에코히터, 2-기상예측유리병, 3-호우호우텀블러1, 4-호우호우텀블러2
						result3 = rsget(2) '// 일단 안씀
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close
					If Trim(result1)="" Then
						'// 응모내역이 없을시
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
						If userBlackListCheck(userid) Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 현재 재고 파악(기상예측 유리병)
						'// 일자별로 정해진 수량 체크
						If chkProductCntToday(eCode, "2") >= vGlassBottle Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "기상예측유리병재고초과비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						Else
							'// 수량이 남아 있을경우
							'// 랜덤숫자 부여
							randomize
							RvConNum=int(Rnd*1000)+1 '100%
							'// 당첨확률 0.3%
							If RvConNum >= vGlassBottleSt And RvConNum < vGlassBottleEd Then
								'// 당첨
								Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "기상예측 유리병 당첨", imgLoopVal, "2")
								dbget.close()	:	response.End
							Else
								'// 비당첨
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "기상예측 유리병 비당첨", imgLoopVal, "0")
								dbget.close()	:	response.End
							End If
						End If
					Else
						'// 응모를 1회 했을시
						If Left(now(), 10) >= "2015-11-27" Then
							Response.Write "Err|하루 1회만 응모 가능합니다."
						Else
							Response.Write "Err|하루 1회만 응모 가능합니다.>?n내일 다시 응모해주세요. :)"
						End If
						response.End
					End If


				Case "3" '// 호우호우 텀블러1(총 150개)
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 비당첨, 1-에코히터, 2-기상예측유리병, 3-호우호우텀블러1, 4-호우호우텀블러2
						result3 = rsget(2) '// 일단 안씀
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close
					If Trim(result1)="" Then
						'// 응모내역이 없을시
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
						If userBlackListCheck(userid) Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 현재 재고 파악(호우호우 텀블러1)
						'// 일자별로 정해진 수량 체크
						If chkProductCntToday(eCode, "3") >= vTumblr1 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "호우호우텀블러1재고초과비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						Else
							'// 수량이 남아 있을경우
							'// 랜덤숫자 부여
							randomize
							RvConNum=int(Rnd*1000)+1 '100%
							'// 당첨확률 0.5%
							If RvConNum >= vTumblr1St And RvConNum < vTumblr1Ed Then
								'// 당첨
								Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "호우호우 텀블러1 당첨", imgLoopVal, "3")
								dbget.close()	:	response.End
							Else
								'// 비당첨
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "호우호우 텀블러1 비당첨", imgLoopVal, "0")
								dbget.close()	:	response.End
							End If
						End If
					Else
						'// 응모를 1회 했을시
						If Left(now(), 10) >= "2015-11-27" Then
							Response.Write "Err|하루 1회만 응모 가능합니다."
						Else
							Response.Write "Err|하루 1회만 응모 가능합니다.>?n내일 다시 응모해주세요. :)"
						End If
						response.End
					End If

				Case "4" '// 호우호우 텀블러2(총 150개)
					'// 응모내역 검색
					sqlstr = "select top 1 sub_opt1 , sub_opt2, sub_opt3 "
					sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
					sqlstr = sqlstr & " where evt_code="& eCode &""
					sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' "
					rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
					If Not(rsget.bof Or rsget.Eof) Then
						'// 기존에 응모 했을때 값
						result1 = rsget(0) '// 응모횟수
						result2 = rsget(1) '// 당첨여부 0일 경우엔 비당첨, 1-에코히터, 2-기상예측유리병, 3-호우호우텀블러1, 4-호우호우텀블러2
						result3 = rsget(2) '// 일단 안씀
					Else
						'// 최초응모
						result1 = ""
						result2 = ""
						result3 = ""
					End IF
					rsget.close
					If Trim(result1)="" Then
						'// 응모내역이 없을시
						'// 같은 전화번호로 해당일자 기준 당첨된 상품이 하나라도 있으면 무조건 비당첨 처리함
						If event_userCell_Selection(evtUserCell, Left(Now(), 10), eCode) > 0 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "전화번호중복비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 블랙 리스트에 등재되어 있는 회원일시 무조건 비당첨 처리
						If userBlackListCheck(userid) Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "블랙리스트아이디비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						End If

						'// 현재 재고 파악(호우호우 텀블러1)
						'// 일자별로 정해진 수량 체크
						If chkProductCntToday(eCode, "4") >= vTumblr2 Then
							Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "호우호우텀블러2재고초과비당첨처리", imgLoopVal, "0")
							dbget.close()	:	response.End
						Else
							'// 수량이 남아 있을경우
							'// 랜덤숫자 부여
							randomize
							RvConNum=int(Rnd*1000)+1 '100%
							'// 당첨확률 0.5%
							If RvConNum >= vTumblr2St And RvConNum < vTumblr2Ed Then
								'// 당첨
								Response.write confirmChkValue("Y", userid, eCode, deviceGubun, refip, "호우호우 텀블러2 당첨", imgLoopVal, "4")
								dbget.close()	:	response.End
							Else
								'// 비당첨
								Response.write confirmChkValue("N", userid, eCode, deviceGubun, refip, "호우호우 텀블러2 비당첨", imgLoopVal, "0")
								dbget.close()	:	response.End
							End If
						End If
					Else
						'// 응모를 1회 했을시
						If Left(now(), 10) >= "2015-11-27" Then
							Response.Write "Err|하루 1회만 응모 가능합니다."
						Else
							Response.Write "Err|하루 1회만 응모 가능합니다.>?n내일 다시 응모해주세요. :)"
						End If
						response.End
					End If

				Case Else
					Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
					Response.End
			End Select

		Case "houhouApp"
			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '호우호우앱다운로드클릭', '"&deviceGubun&"')"
			dbget.execute sqlstr

			Response.write "OK|1"
			Response.End

		Case Else
			Response.Write "Err|정상적인 경로로 응모해주시기 바랍니다."
			Response.End
	End Select



	Function confirmChkValue(gubun, userid, eCode, deviceGubun, refip, logValue, imgLoopVal, rightValue)

		Dim sqlstr

		'// gubun - 당첨 비당첨 구분
		'// userid - 유저아이디
		'// deviceGubun - 디바이스 구분
		'// refip - 유저 아이피
		'// logValue - 로그에 들어갈 문구
		'// imgLoopVal - 꽝 이미지 랜덤
		'// rightValue - 당첨상품번호(1-리플렉트 에코히터, 2-기상예측 유리병, 3-호우호우 텀블러1, 4-호우호우 텀블러2)

		If gubun="Y" Then
			'// 당첨
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '"&rightValue&"', '', getdate(), '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&logValue&"', '"&deviceGubun&"')"
			dbget.execute sqlstr

			If Trim(rightValue) = "1" Then
				Response.write "OK|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_win1.png>|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_win1.png>"
			ElseIf Trim(rightValue) = "2" Then
				Response.write "OK|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_win2.png>|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_win2.png>"
			ElseIf Trim(rightValue) = "3" Then
				Response.write "OK|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_win3.png>|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_win3.png>"
			ElseIf Trim(rightValue) = "4" Then
				Response.write "OK|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_win4.png>|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_win3.png>"
			Else
				Response.write "OK|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/howoo_win4.png>|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_win3.png>"
			End If
		Else
			'// 비당첨시
			sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, regdate, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '"&rightValue&"', getdate(), '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 해당 유저의 로그값 집어넣는다.
			sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
			sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '"&logValue&"', '"&deviceGubun&"')"
			dbget.execute sqlstr

			'// 마지막날은 다른 이미지 보여준다.
			If Left(now(), 10) >= "2015-11-27" Then
				confirmChkValue = "OK|<img src="&imgLoopVal&">|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_lose_last.png>"
			Else 
				confirmChkValue = "OK|<img src="&imgLoopVal&">|<img src=http://webimage.10x10.co.kr/eventIMG/2015/67421/m/result_lose.png>"
			End If 

		End If

	End Function


	Function chkrightCntToday(eCode, userid)

		Dim sqlstr

		'// 해당 아이디로 금일 당첨된 상품이 있다면 무조건 비당첨 처리한다.
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2 in ('1','2','3','4') And userid='"&userid&"' "	
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If rsget(0) > 0 Then
			chkrightCntToday = True
		Else
			chkrightCntToday = False
		End If
		rsget.close
	End Function 

	Function chkProductCntToday(eCode, rightvalue)

		Dim sqlstr

		'// 현재 재고 파악
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(Now(), 10) &"' And sub_opt2='"&rightvalue&"' "			
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		chkProductCntToday = rsget(0)
		rsget.close

	End Function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->