<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  [15주년] 워킹맨
' History : 2016.10.06 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
	dim mode, referer,refip, apgubun, nowDate, nowpos, act, sqlstr, md5userid, eCouponID, vQuery, vValidsitename
	referer = request.ServerVariables("HTTP_REFERER")
	refip = request.ServerVariables("REMOTE_ADDR")

	'// 모드값(ins)
	mode = requestcheckvar(request("mode"),32)
	
	'// 현재 위치값
	nowpos = requestcheckvar(request("nowpos"),32) 
	
	'// 액션값
	'/////////////////액션구분///////////////////////
	'// mileage1-100마일리지첫번째지급
	'// gift1-경품응모
	'// cgv-영화예매권
	'// mileage2-100마일리지두번째지급
	'// gift2-두번째경품응모
	'// mileage3-500마일리지지급(마지막)
	'// nomal1-01출첵
	'// nomal2-02출첵
	'// nomal4-04출첵
	'// nomal6-06출첵
	'// nomal7-07출첵
	'// nomal9-09출첵
	'// nomal10-10출첵
	'// nomal12-12출첵
	'// nomal14-14출첵
	'///////////////////////////////////////////////
	act = requestcheckvar(request("act"),32)

	Dim eCode, userid
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66215
		eCouponID = 916
	Else
		eCode   =  73063
		eCouponID = 916
	End If

	'// 아이디
	userid = getEncLoginUserid()
	'// 오늘날짜
	nowDate = Left(Now(), 10)

	'// 모바일웹&앱전용
	If isApp="1" Then
		apgubun = "A"
		vValidsitename = "app"
	Else
		apgubun = "M"
		vValidsitename = "mobile"
	End If

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(userid&"10")

	if InStr(referer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	end If

	If not(nowDate >= "2016-10-10" and nowDate < "2016-10-25") Then
		Response.Write "Err|이벤트 응모기간이 아닙니다."
		dbget.close() : Response.End
	End IF

	'// 로그인시에만 응모가능
	If not(IsUserLoginOK()) Then
		Response.Write "Err|로그인 후 응모해주세요."
		dbget.close() : Response.End
	End If

	'// 혹시 오전 10시부터 응모여부 할 수도 있으니 남겨둠
	'If Left(now(), 10) = "2016-10-10" Then
	'	If Not(TimeSerial(Hour(now()), minute(now()), second(now())) >= TimeSerial(10, 00, 00) And TimeSerial(Hour(now()), minute(now()), second(now())) < TimeSerial(23, 59, 59)) Then
	'		Response.Write "Err|오전 10시부터 응모하실 수 있습니다."
	'		dbget.close() : Response.End
	'	End If
	'End If


	'// 출석등록
	if mode="ins" Then

		'// 등록전 오늘 출첵을 했는지 확인한다.
		If UserAppearChk(nowDate) > 0 Then
			Response.Write "Err|이미 출석하셨습니다."
			dbget.close() : Response.End
		End If


		'// act를 기준으로 각 액션마다 출석수를 확인한다.
		Select Case Trim(act)
			Case "mileage1"
				'// 최초 100마일리지 신청은 총 출석수가 2회였을때 신청가능
				If Not(nowAppearCnt()=2) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else

					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "100", nowDate)

					Response.Write "OK|03|"&getLayerHtml(mode, nowpos, act, md5userid)
					dbget.close() : Response.End
				End If
			Case "gift1"
				'// 최초 경품응모는 총 출석수가 4회였을때 신청가능
				If Not(nowAppearCnt()=4) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|05|"&getLayerHtml(mode, nowpos, act, md5userid)
					dbget.close() : Response.End
				End If
			Case "cgv"
				'// 최초 cgv예매권은 총 출석수가 7회였을때 신청가능
				If Not(nowAppearCnt()=7) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|08|"&getLayerHtml(mode, nowpos, act, md5userid)
					dbget.close() : Response.End
				End If
			Case "mileage2"
				'// 두번째 100마일리지 신청은 총 출석수가 10회였을때 신청가능
				If Not(nowAppearCnt()=10) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "100", nowDate)

					Response.Write "OK|11|"&getLayerHtml(mode, nowpos, act, md5userid)
					dbget.close() : Response.End
				End If
			Case "gift2"
				'// 두번째 경품응모는 총 출석수가 12회였을때 신청가능
				If Not(nowAppearCnt()=12) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|13|"&getLayerHtml(mode, nowpos, act, md5userid)
					dbget.close() : Response.End
				End If
			Case "mileage3"
				'// 세번째 500마일리지 신청은 총 출석수가 14회였을때 신청가능
				If Not(nowAppearCnt()=14) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "500", nowDate)

					Response.Write "OK|15|"&getLayerHtml(mode, nowpos, act, md5userid)
					dbget.close() : Response.End
				End If
			Case "nomal1"
				'// 01영역 일반응모
				If Not(nowAppearCnt()=0) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|01|"
					dbget.close() : Response.End
				End If
			Case "nomal2"
				'// 02영역 일반응모
				If Not(nowAppearCnt()=1) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|02|"
					dbget.close() : Response.End
				End If
			Case "nomal4"
				'// 04영역 일반응모
				If Not(nowAppearCnt()=3) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|04|"
					dbget.close() : Response.End
				End If
			Case "nomal6"
				'// 06영역 일반응모
				If Not(nowAppearCnt()=5) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|06|"
					dbget.close() : Response.End
				End If
			Case "nomal7"
				'// 07영역 일반응모
				If Not(nowAppearCnt()=6) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|07|"
					dbget.close() : Response.End
				End If
			Case "nomal9"
				'// 09영역 일반응모
				If Not(nowAppearCnt()=8) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|09|"
					dbget.close() : Response.End
				End If
			Case "nomal10"
				'// 10영역 일반응모
				If Not(nowAppearCnt()=9) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|10|"
					dbget.close() : Response.End
				End If
			Case "nomal12"
				'// 12영역 일반응모
				If Not(nowAppearCnt()=11) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|12|"
					dbget.close() : Response.End
				End If
			Case "nomal14"
				'// 14영역 일반응모
				If Not(nowAppearCnt()=13) Then
					Response.Write "Err|정상적인 경로로 응모해주세요."
					dbget.close() : Response.End
				Else
					'// 출첵 데이터를 넣어준다.
					Call InsAppearData(eCode, userid, apgubun, Trim(act), "", nowDate)

					Response.Write "OK|14|"
					dbget.close() : Response.End
				End If
			Case Else
				Response.Write "Err|정상적인 경로로 응모해주세요."
				dbget.close() : Response.End
		End Select

	ElseIf mode="gift1" Then
	'// 경품응모 첫번째
		Dim vGift1PstNum, vGift1RvConNumSt, vGift1RvConNumEd, Gift1result1, Gift1result2, Gift1RvConNum
		'// 한정갯수 셋팅
		vGift1PstNum = 700

		'// 확률셋팅
		vGift1RvConNumSt = 1
		vGift1RvConNumEd = 801


		'// 응모내역을 가져온다.
		sqlstr = " Select top 1 sub_opt1, sub_opt3 From db_event.dbo.tbl_event_subscript "
		sqlstr = sqlstr & " Where evt_code='"&eCode&"' "
		sqlstr = sqlstr & " And userid='"&userid&"' "
		sqlstr = sqlstr & " And sub_opt1='"&Trim(mode)&"' "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.bof Or rsget.eof) Then
			Gift1result1 = rsget(0) '// 출첵데이터
			Gift1result2 = rsget(1) '// 경품참여여부
		Else
			Gift1result1 = ""
			Gift1result2 = ""
		End If
		rsget.close

		'// 출첵 데이터는 있어야 되며
		If Trim(Gift1result1)<>"" Then
			'// 경품참여여부는 없어야 된다.
			If (IsNull(Gift1result2) Or Gift1result2="") Then
				'// 현재 당첨된 갯수를 가져옴
				sqlstr = " Select count(*) From db_event.dbo.tbl_event_subscript "
				sqlstr = sqlstr & " Where evt_code='"&eCode&"' "
				sqlstr = sqlstr & " And sub_opt1='"&Trim(mode)&"' "
				sqlstr = sqlstr & " And sub_opt3='true' "
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 정해진 수량이 넘었을경우는 무조건 쿠폰당첨 처리
				If rsget(0)>=vGift1PstNum Then
					Call UpAppearData(eCode, userid, Trim(mode), "false")

					'// 해당 유저의 로그값 집어넣는다.
					Call InsLogData(eCode, userid, refip, apgubun, "첫번째 경품응모 재고초과 비당첨 처리")

					'// 무료배송쿠폰 넣어준다.
					Call InsCouponData(eCouponID, userid, nowDate, vValidsitename)

					Response.Write "OK|"&getLayerHtml(mode, nowpos, "coupon", md5userid)
					dbget.close() : Response.End
				Else
					'// 랜덤숫자 부여
					randomize
					Gift1RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If Gift1RvConNum >= vGift1RvConNumSt And Gift1RvConNum < vGift1RvConNumEd Then
						'// 당첨
						Call UpAppearData(eCode, userid, Trim(mode), "true")

						'// 해당 유저의 로그값 집어넣는다.
						Call InsLogData(eCode, userid, refip, apgubun, "첫번째 경품응모 당첨")

						Response.Write "OK|"&getLayerHtml(mode, nowpos, "giftwin", md5userid)
					Else
						'// 비당첨
						Call UpAppearData(eCode, userid, Trim(mode), "false")

						'// 해당 유저의 로그값 집어넣는다.
						Call InsLogData(eCode, userid, refip, apgubun, "첫번째 경품응모 비당첨 처리")

						'// 무료배송쿠폰 넣어준다.
						Call InsCouponData(eCouponID, userid, nowDate, vValidsitename)

						Response.Write "OK|"&getLayerHtml(mode, nowpos, "coupon", md5userid)
						dbget.close() : Response.End
					End If
				End If
			Else
				Response.Write "Err|이미 경품응모를 하셨습니다."
				dbget.close() : Response.End
			End If
		Else
			Response.Write "Err|출석체크 후 응모하실 수 있습니다."
			dbget.close() : Response.End
		End If


	ElseIf mode="cgv" Then
	'// cgv 영화예매권 응모
		Dim vCgvPstNum, vCgvRvConNumSt, vCgvRvConNumEd, Cgvresult1, Cgvresult2, Cgv1RvConNum
		'// 한정갯수 셋팅
		vCgvPstNum = 50

		'// 확률셋팅
		vCgvRvConNumSt = 1
		vCgvRvConNumEd = 11

		'// 응모내역을 가져온다.
		sqlstr = " Select top 1 sub_opt1, sub_opt3 From db_event.dbo.tbl_event_subscript "
		sqlstr = sqlstr & " Where evt_code='"&eCode&"' "
		sqlstr = sqlstr & " And userid='"&userid&"' "
		sqlstr = sqlstr & " And sub_opt1='"&Trim(mode)&"' "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.bof Or rsget.eof) Then
			Cgvresult1 = rsget(0) '// 출첵데이터
			Cgvresult2 = rsget(1) '// cgv응모참여여부
		Else
			Cgvresult1 = ""
			Cgvresult2 = ""
		End If
		rsget.close

		'// 출첵 데이터는 있어야 되며
		If Trim(Cgvresult1)<>"" Then
			'// cgv 주말 이용권 응모여부는 없어야 된다.
			If (IsNull(Gift1result2) Or Gift1result2="") Then
				'// 현재 당첨된 갯수를 가져옴
				sqlstr = " Select count(*) From db_event.dbo.tbl_event_subscript "
				sqlstr = sqlstr & " Where evt_code='"&eCode&"' "
				sqlstr = sqlstr & " And sub_opt1='"&Trim(mode)&"' "
				sqlstr = sqlstr & " And sub_opt3='true' "
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 정해진 수량이 넘었을경우는 무조건 쿠폰당첨 처리
				If rsget(0)>=vCgvPstNum Then
					Call UpAppearData(eCode, userid, Trim(mode), "false")

					'// 해당 유저의 로그값 집어넣는다.
					Call InsLogData(eCode, userid, refip, apgubun, "CGV주말이용권 재고초과 비당첨 처리")


					'// 무료배송쿠폰 넣어준다.
					Call InsCouponData(eCouponID, userid, nowDate, vValidsitename)

					Response.Write "OK|"&getLayerHtml(mode, nowpos, "coupon", md5userid)
					dbget.close() : Response.End
				Else
					'// 랜덤숫자 부여
					randomize
					Cgv1RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If Cgv1RvConNum >= vCgvRvConNumSt And Cgv1RvConNum < vCgvRvConNumEd Then
						'// 당첨
						Call UpAppearData(eCode, userid, Trim(mode), "true")

						'// 해당 유저의 로그값 집어넣는다.
						Call InsLogData(eCode, userid, refip, apgubun, "CGV주말이용권 당첨")

						Response.Write "OK|"&getLayerHtml(mode, nowpos, "cgvwin", md5userid)
						dbget.close() : Response.End
					Else
						'// 비당첨
						Call UpAppearData(eCode, userid, Trim(mode), "false")

						'// 해당 유저의 로그값 집어넣는다.
						Call InsLogData(eCode, userid, refip, apgubun, "CGV주말이용권응모 비당첨 처리")

						'// 무료배송쿠폰 넣어준다.
						Call InsCouponData(eCouponID, userid, nowDate, vValidsitename)

						Response.Write "OK|"&getLayerHtml(mode, nowpos, "coupon", md5userid)
						dbget.close() : Response.End
					End If
				End If
			Else
				Response.Write "Err|이미 CGV주말이용권 응모를 하셨습니다."
				dbget.close() : Response.End
			End If
		Else
			Response.Write "Err|출석체크 후 응모하실 수 있습니다."
			dbget.close() : Response.End
		End If

	ElseIf mode="gift2" Then
	'// 경품응모 첫번째
		Dim vGift2PstNum, vGift2RvConNumSt, vGift2RvConNumEd, Gift2result1, Gift2result2, Gift2RvConNum
		'// 한정갯수 셋팅
		vGift2PstNum = 1590

		'// 확률셋팅
		vGift2RvConNumSt = 1
		vGift2RvConNumEd = 801


		'// 응모내역을 가져온다.
		sqlstr = " Select top 1 sub_opt1, sub_opt3 From db_event.dbo.tbl_event_subscript "
		sqlstr = sqlstr & " Where evt_code='"&eCode&"' "
		sqlstr = sqlstr & " And userid='"&userid&"' "
		sqlstr = sqlstr & " And sub_opt1='"&Trim(mode)&"' "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.bof Or rsget.eof) Then
			Gift2result1 = rsget(0) '// 출첵데이터
			Gift2result2 = rsget(1) '// 경품참여여부
		Else
			Gift2result1 = ""
			Gift2result2 = ""
		End If
		rsget.close

		'// 출첵 데이터는 있어야 되며
		If Trim(Gift2result1)<>"" Then
			'// 경품참여여부는 없어야 된다.
			If (IsNull(Gift2result2) Or Gift2result2="") Then
				'// 현재 당첨된 갯수를 가져옴
				sqlstr = " Select count(*) From db_event.dbo.tbl_event_subscript "
				sqlstr = sqlstr & " Where evt_code='"&eCode&"' "
				sqlstr = sqlstr & " And sub_opt1='"&Trim(mode)&"' "
				sqlstr = sqlstr & " And sub_opt3='true' "
				rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
				'// 정해진 수량이 넘었을경우는 무조건 쿠폰당첨 처리
				If rsget(0)>=vGift2PstNum Then
					Call UpAppearData(eCode, userid, Trim(mode), "false")

					'// 해당 유저의 로그값 집어넣는다.
					Call InsLogData(eCode, userid, refip, apgubun, "두번째 경품응모 재고초과 비당첨 처리")

					'// 무료배송쿠폰 넣어준다.
					Call InsCouponData(eCouponID, userid, nowDate, vValidsitename)

					Response.Write "OK|"&getLayerHtml(mode, nowpos, "coupon", md5userid)
					dbget.close() : Response.End
				Else
					'// 랜덤숫자 부여
					randomize
					Gift2RvConNum=int(Rnd*1000)+1 '100%

					'// 1% 확률
					If Gift2RvConNum >= vGift2RvConNumSt And Gift2RvConNum < vGift2RvConNumEd Then
						'// 당첨
						Call UpAppearData(eCode, userid, Trim(mode), "true")

						'// 해당 유저의 로그값 집어넣는다.
						Call InsLogData(eCode, userid, refip, apgubun, "두번째 경품응모 당첨")

						Response.Write "OK|"&getLayerHtml(mode, nowpos, "giftwin", md5userid)
						dbget.close() : Response.End
					Else
						'// 비당첨
						Call UpAppearData(eCode, userid, Trim(mode), "false")

						'// 해당 유저의 로그값 집어넣는다.
						Call InsLogData(eCode, userid, refip, apgubun, "두번째 경품응모 비당첨 처리")

						'// 무료배송쿠폰 넣어준다.
						Call InsCouponData(eCouponID, userid, nowDate, vValidsitename)

						Response.Write "OK|"&getLayerHtml(mode, nowpos, "coupon", md5userid)
						dbget.close() : Response.End
					End If
				End If
			Else
				Response.Write "Err|이미 경품응모를 하셨습니다."
				dbget.close() : Response.End
			End If
		Else
			Response.Write "Err|출석체크 후 응모하실 수 있습니다."
			dbget.close() : Response.End
		End If
	Else
		Response.Write "Err|잘못된 접속입니다."
		dbget.close() : Response.End
	End If

	'// 현재까지 해당유저가 출첵을 한 횟수데이터
	Function nowAppearCnt()
		Dim vQuery

		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			nowAppearCnt = rsget(0)
		End IF
		rsget.close
	End Function

	'// 해당일자 출첵했는지 확인
	Function UserAppearChk(Dt)
		Dim vQuery
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And convert(varchar(10), regdate, 120)='"&Dt&"' "
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
		IF Not rsget.Eof Then
			UserAppearChk = rsget(0)
		End IF
		rsget.close
	End Function

	'// 레이어 내용 가져오기
	Function getLayerHtml(mode, nowpos, act, md5uid)
		Select Case Trim(act)
			Case "mileage1"
				getLayerHtml = "<div id='lyr01m'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_milgbnk.png' alt='마일리지 은행' /><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "

			Case "gift1"
				getLayerHtml = "<div id='lyr05h'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_gift_ohye.png' alt='선물의 집' /><a href='' onclick=""getAppearGift('gift1', '"&nowpos&"', '"&Trim(act)&"');return false;"" class='btnGoLink'>응모하기</a><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "

			Case "cgv"
				getLayerHtml = "<div id='lyr04c'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_cinema_tckt.png' alt='영화관 - CGV 주말 이용권 1인' /><a href='' onclick=""getAppearGift('cgv', '"&nowpos&"', '"&Trim(act)&"');return false;"" class='btnGoLink'>응모하기</a><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "

			Case "mileage2"
				getLayerHtml = "<div id='lyr01m'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_milgbnk.png' alt='마일리지 은행' /><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "

			Case "gift2"
				getLayerHtml = "<div id='lyr05h'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_gift_ohye.png' alt='선물의 집' /><a href='' onclick=""getAppearGift('gift2', '"&nowpos&"', '"&Trim(act)&"');return false;"" class='btnGoLink'>응모하기</a><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "

			Case "mileage3"
				getLayerHtml = "<div id='lyr00e'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_wlkng_fnsh.png' alt='완주를 축하합니다' /><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "

			Case "coupon"
				getLayerHtml = "<div id='lyr03f'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_fail_uu.png' alt='앗, 이런 당첨되지 않았어요' /><a href='' onclick=""alert('무료배송 쿠폰이 발급되었습니다.');parent.location.reload();"" class='btnGoLink'>무료배송 쿠폰 다운받기</a><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "

			Case "giftwin"
				If isApp="1" Then
					getLayerHtml = "<div id='lyr02g' ><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_win_gift.png' alt='당첨을 축하합니다 - 당첨 사은품 리스트 중 1가지 상품이 기본 배송지로 10월 26일에 배송될 예정입니다.' /><a href='' onclick=""fnAPPpopupBrowserURL('개인정보수정','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp'); return false;"" class='btnGoLink'>기본 배송지 확인하러 가기</a><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "
				Else
					getLayerHtml = "<div id='lyr02g' ><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_win_gift.png' alt='당첨을 축하합니다 - 당첨 사은품 리스트 중 1가지 상품이 기본 배송지로 10월 26일에 배송될 예정입니다.' /><a href='/my10x10/userinfo/confirmuser.asp' target='_blank' class='btnGoLink'>기본 배송지 확인하러 가기</a><p class='code'>"&md5uid&"</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "
				End If

			Case "cgvwin"
				If isApp="1" Then
					getLayerHtml = " <div id='lyr06t'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_win_cinema_tckt.png' alt='당첨을 축하합니다 - 당첨된 상품은 기프티콘으로 등록된 휴대폰번호로 10월 26일에 발송될 예정입니다.' /><a href='' onclick=""fnAPPpopupBrowserURL('개인정보수정','"&wwwUrl&"/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp'); return false;"" class='btnGoLink'>휴대폰번호 확인하러 가기</a><p class='code'>여기</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "
				Else
					getLayerHtml = " <div id='lyr06t'><div><img src='http://webimage.10x10.co.kr/eventIMG/2016/15th/73063/m/img_lyr_win_cinema_tckt.png' alt='당첨을 축하합니다 - 당첨된 상품은 기프티콘으로 등록된 휴대폰번호로 10월 26일에 발송될 예정입니다.' /><a href='/my10x10/userinfo/confirmuser.asp' target='_blank' class='btnGoLink'>휴대폰번호 확인하러 가기</a><p class='code'>여기</p><button type='button' onclick=""giftLayerClose();return false;"" class='lyrClose'>닫기</button></div></div> "
				End If

			Case Else
				getLayerHtml = "<div class='giftLyr window' id='lyr00e'><div>오류가 발생하였습니다. 고객센터로 문의해주세요.<p class='code'>"&md5uid&"</p><button type='button'  onclick=""giftLayerClose();return false;""  class='lyrClose'>닫기</button></div></div>"
		End Select
	End Function


	'// 출첵 데이터 ins
	Function InsAppearData(evt_code, uid, device, sub_opt1, sub_opt3, regdate)
		Dim vQuery
		If sub_opt3 <> "" Then
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, sub_opt3, regdate)" & vbCrlf
			vQuery = vQuery & " VALUES ("& eCode &", '"& userid &"', '"&apgubun&"','"&act&"','"&sub_opt3&"','"&regdate&" "&Hour(now())&":"&minute(now())&":"&second(now())&"')"
		Else
			vQuery = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid, device, sub_opt1, regdate)" & vbCrlf
			vQuery = vQuery & " VALUES ("& eCode &", '"& userid &"', '"&apgubun&"','"&act&"','"&regdate&" "&Hour(now())&":"&minute(now())&":"&second(now())&"')"
		End If
		dbget.execute vQuery
	End Function

	'// 쿠폰 데이터 ins
	Function InsCouponData(ecid, uid, nDt, vValSName)
		Dim vQuery

		vQuery = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
				 "values('"& ecid &"', '" & uid & "', '3','2000','워킹맨 이벤트 무료배송쿠폰','10000','"&nDt&" 00:00:00','"&nDt&" 23:59:59','',0,'system','"&vValSName&"')"
		dbget.execute vQuery
	End Function

	'// 로그 데이터 ins
	Function InsLogData(evt_code, uid, rip, ag, dsc)
		Dim vQuery

		vQuery = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value3, device)" + vbcrlf
		vQuery = vQuery & " VALUES("& evt_code &", '"& uid &"' ,'"&rip&"', '"&dsc&"', '"&ag&"')"
		dbget.execute vQuery
	End Function

	'// 당첨 비당첨 여부 update
	Function UpAppearData(evt_code, uid, mode, winlose)
		Dim vQuery

		vQuery = "update [db_event].[dbo].[tbl_event_subscript] set sub_opt3='"&winlose&"' Where evt_code='"&evt_code&"' And userid='"&uid&"' And sub_opt1='"&Trim(mode)&"' "
		dbget.execute vQuery

	End Function


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->


