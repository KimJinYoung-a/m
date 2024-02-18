<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet = "UTF-8"
'####################################################
' Description : ##10원의 마술상(app)
' History : 2016-03-24 원승현 생성
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
dim eCode, userid, sqlstr, mode, vLinkECode , vTotalCount, md5userid, RvchrNum, LoginUserid
Dim evtUserCell, refer, refip, device, vQuery, strsql, toDayDate, eventitemid, couponidx, snsno, vPstNum, vRvConNumSt, vRvConNumEd, result1, result2, RvConNum
	
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	userid = getEncLoginUserID
	mode = requestcheckvar(request("mode"),32)
	snsno = requestcheckvar(request("snsno"),32)
	evtUserCell = get10x10onlineusercell(userid) '// 참여한 회원 핸드폰번호

	'// 해당일자
	toDayDate = Left(now(), 10)

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66090"
		couponidx = "841"
	Else
		eCode = "69883"
		couponidx = "841"
	End If

	if isapp="1" then
		device = "A"
	else
		device = "M"
	end If
	
	'// 일자별 적용 값
	Select Case Trim(toDayDate)
		Case "2016-03-28"
			eventitemid = 1458315
			vPstNum = 500

		Case "2016-03-29"
			eventitemid = 1458316
			vPstNum = 862

		Case "2016-03-30"
			eventitemid = 1458317
			vPstNum = 851

		Case "2016-03-31"
			eventitemid = 1458318
			vPstNum = 264

		Case "2016-04-01"
			eventitemid = 1458319
			vPstNum = 122

		Case Else
			eventitemid = 1458315
			vPstNum = 0
	End Select 

	'// 확률 셋팅(일단 각 당첨 확률은 5%로 조정)
	vRvConNumSt = 1 '// 10원의 마술상
	vRvConNumEd = 2 '// 10원의 마술상

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(userid&"10")


	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If


	'// expiredate
	If not(toDayDate>="2016-03-28" and toDayDate<"2016-04-02") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
		Response.End
	End If

	'// 3월 28일만 10시부터 응모 가능함, 그 이후에는 0시 기준으로 응모가능
	If Left(Now(), 10) = "2016-03-28" Then
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

	If mode="add" Then

		'// 응모내역 검색
		sqlstr = "select top 1 sub_opt1 , sub_opt2 "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& userid &"' and convert(varchar(10),regdate,120) = '"& toDayDate &"' "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If Not(rsget.bof Or rsget.Eof) Then
			'// 기존에 응모 했을때 값
			result1 = rsget(0) '//응모여부
			result2 = rsget(1) '//당첨여부 0일 경우엔 쿠폰당첨, 1일 경우엔 상품당첨
		Else
			'// 최초응모
			result1 = ""
			result2 = ""
		End IF
		rsget.close

		'// 일자별 응모한 내역이 있다면(쿠폰당첨 포함) 이미 응모하셨습니다. 출력
		If result1 <> "" Then
			If toDayDate = "2016-04-01" Then
				Response.Write "Err|이미 응모하셨습니다."
				response.End
			Else
				Response.Write "Err|이미 응모하셨습니다.>?n내일 다시 응모해 주세요."
				response.End
			End If
		End If

		If result1 = "" Then '// 이미 응모했는지 다시한번 체크

			'// 해당 이벤트 기간에 한번이라도 당첨된 내역이 있으면 비당첨 처리
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt2='1' And userid='"&userid&"' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
			If rsget(0) > 0 Then

				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', '10원의 마술상 - 무료배송쿠폰', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value1, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '99', '이벤트 기간중 1회이상 중복당첨 안됨', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_on_my_god.png' alt='헉 이런! 마술상에 당첨되지 않았어요! 대신, 무료배송 쿠폰을 드릴게요!' /></p><button type='button' class='btnDown' onclick='getcoupon();return false;'>쿠폰 다운받기</button><button type='button' class='btnClose' onclick='fnClosemask();return false;'>닫기</button>"
				dbget.close()	:	response.End

			End If 
			rsget.close

			'// 블랙리스트 아이디는 무조건 비당첨 처리한다.
			If userBlackListCheck(userid) Then

				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', '10원의 마술상 - 무료배송쿠폰', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value1, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '99', '블랙리스트 비당첨처리', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_on_my_god.png' alt='헉 이런! 마술상에 당첨되지 않았어요! 대신, 무료배송 쿠폰을 드릴게요!' /></p><button type='button' class='btnDown' onclick='getcoupon();return false;'>쿠폰 다운받기</button><button type='button' class='btnClose' onclick='fnClosemask();return false;'>닫기</button>"
				dbget.close()	:	response.End
			End If

			'// 현재 재고 파악
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& toDayDate &"' And sub_opt2='1' "
			rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly

			'// 일자별로 정해진 수량 체크
			If rsget(0) >= vPstNum Then
				'// 정해진 수량이 넘었을 경운 무조건 쿠폰당첨 처리
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', '10원의 마술상 - 무료배송쿠폰', getdate(), 'A')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip, value1, value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '99', '당첨한도갯수 초과 비당첨 처리', 'A')"
				dbget.execute sqlstr

				Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_on_my_god.png' alt='헉 이런! 마술상에 당첨되지 않았어요! 대신, 무료배송 쿠폰을 드릴게요!' /></p><button type='button' class='btnDown' onclick='getcoupon();return false;'>쿠폰 다운받기</button><button type='button' class='btnClose' onclick='fnClosemask();return false;'>닫기</button>"
				dbget.close()	:	response.End

			Else '// 수량이 남아 있을경우

				'// 랜덤숫자 부여
				randomize
				RvConNum=int(Rnd*1000)+1 '100%

				'// 당첨여부 판단
				If RvConNum >= vRvConNumSt And RvConNum < vRvConNumEd Then
					'// 당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '1', '"&eventitemid&"', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip ,  value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '88', '10원의 마술상 당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_oh_yes.png' alt='축하합니다. 10원의 마술상 당첨! 배송비는 별도입니다.' /></p><div class='serialNo'><strong>"&md5userid&"</strong></div><a href='' class='btnGet' onclick='goShoppingBag();return false;'>구매하러 가기</a><button type='button' class='btnClose' onclick='fnClosemask();return false;'>닫기</button>"
					dbget.close()	:	response.End
				Else
					'// 비당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt2, sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"', '1', '0', '10원의 마술상 - 무료배송쿠폰', getdate(), 'A')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '99', '10원의 마술상 비당첨', 'A')"
					dbget.execute sqlstr

					Response.write "OK|<p><img src='http://webimage.10x10.co.kr/eventIMG/2016/69883/txt_on_my_god.png' alt='헉 이런! 마술상에 당첨되지 않았어요! 대신, 무료배송 쿠폰을 드릴게요!' /></p><button type='button' class='btnDown' onclick='getcoupon();return false;'>쿠폰 다운받기</button><button type='button' class='btnClose' onclick='fnClosemask();return false;'>닫기</button>"
					dbget.close()	:	response.End
				End If
			End If
			rsget.close
		Else
			If toDayDate = "2016-04-01" Then
				Response.Write "Err|이미 응모하셨습니다."
				response.End
			Else
				Response.Write "Err|이미 응모하셨습니다.>?n내일 다시 응모해 주세요."
				response.End
			End If
		End If

	ElseIf mode="S" Then
		sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('"& eCode &"' " &_
			", '"& userid &"' " &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
			", '4' " &_
			", '"& snsno &"' " &_
			", '' " &_
			", 'A') "
		dbget.Execute sqlstr
		if snsno = "tw" then
			Response.write "tw"
		elseif snsno = "fb" then
			Response.write "fb"
		elseif snsno = "ka" then
			Response.write "ka"
		elseif snsno = "ln" then
			Response.write "ln"
		else
			Response.write "99"
		end if
		Response.End

	ElseIf mode="coupon" then

		'// 오늘자로 이벤트에 참여한 회원인지 확인한다.
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& toDayDate &"' And sub_opt2='0' And userid='"&userid&"' "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If rsget(0) < 1 Then
			Response.Write "정상적인 경로가 아닙니다."
			response.End
		End If 
		rsget.close

		'// 오늘자로 쿠폰을 발급받았는지 확인한다.
		sqlstr = " Select count(*) From [db_user].dbo.tbl_user_coupon Where masteridx='"&couponidx&"' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&toDayDate&"' "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If rsget(0) > 0 Then
			Response.Write "이미 쿠폰을 발급받으셨습니다."
			response.End
		End If
		rsget.close

		'// 쿠폰 넣어준다.
		sqlstr = "insert into [db_user].dbo.tbl_user_coupon(masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid,validsitename) " & _
				 "values('"& couponidx &"', '" & userid & "', '3','2000','10원의 마술상 - 무료배송쿠폰','10000','2016-03-28 00:00:00','2016-04-01 23:59:59','',0,'system','app')"
		dbget.execute sqlstr

		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '99', '무료배송쿠폰받음', 'A')"
		dbget.execute sqlstr

		Response.Write "무료배송 쿠폰이 발급되었습니다."
		Response.End

	ElseIf mode="shoppingbag" then

		'// 오늘자로 이벤트에 당첨된 회원인지 확인한다.
		sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& toDayDate &"' And sub_opt2='1' And userid='"&userid&"' "
		rsget.Open sqlstr, dbget, adOpenForwardOnly, adLockReadOnly
		If rsget(0) < 1 Then
			Response.Write "정상적인 경로가 아닙니다."
			response.End
		End If 
		rsget.close


		'// 해당 유저의 로그값 집어넣는다.
		sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value1, value3, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '"& userid &"' ,'"&refip&"', '2', '바로구매하기 클릭', 'A')"
		dbget.execute sqlstr

		Response.Write "OK"
		Response.End

	Else
		Response.Write "<script type='text/javascript'>alert('정상적인 경로가 아닙니다.'); parent.top.location.href='/event/eventmain.asp?eventid="&eCode&"'</script>"
		dbget.close() : Response.End
	End If

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->