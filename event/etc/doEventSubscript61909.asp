<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  BML에서 진행하는 모바일 QR 이벤트
' History : 2015.04.28 원승현 생성
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
	Dim LoginUserid, couponid
	Dim result1, result2, md5userid, evtUserCell

	nowdate = now()
'	nowdate = "2015-05-02 10:00:00"

	LoginUserid = getLoginUserid()
	refip = Request.ServerVariables("REMOTE_ADDR")
	refer = request.ServerVariables("HTTP_REFERER")
	evtUserCell = get10x10onlineusercell(LoginUserid) '// 참여한 회원 핸드폰번호
	couponid = "733" '// 쿠폰 아이디


	IF application("Svr_Info") = "Dev" THEN
		eCode   =  61768
	Else
		eCode   =  61909
	End If

	'// 당첨시 확실히 판단하기 위해 userid에 "10"스트링으로 더해 md5값 만들어 보여줌
	md5userid = md5(LoginUserid&"10")

	'// 바로 접속시엔 오류 표시
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접속입니다."
		Response.End
	end If

	'// expiredate
	If not(left(nowdate,10)>="2015-05-02" and left(nowdate,10)<"2015-05-04") Then
		Response.Write "Err|이벤트 응모 기간이 아닙니다."
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


		'// 응모확률 랜덤
		randomize
		renloop=int(Rnd*1000)+1 '100%

		'// 응모내역 검색
		sqlstr = "select top 1 sub_opt1 , sub_opt3 "
		sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
		sqlstr = sqlstr & " where evt_code="& eCode &""
		sqlstr = sqlstr & " and userid='"& LoginUserid &"' and convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' "
		rsget.Open sqlstr, dbget, 1
		If Not(rsget.bof Or rsget.Eof) Then
			'// 기존에 응모 했을때 값
			result1 = rsget(0) '//응모여부(1-응모)
			result2 = rsget(1) '//당첨여부(lg스마트빔 미니 프로젝터(projector), 아이리버 블루투스 스피커(speaker), 장미 리본 꽃팔찌(band), 텐바이텐 할인쿠폰(coupon))
		Else
			'// 최초응모
			result1 = ""
			result2 = ""
		End IF
		rsget.close


		'// 응모 했는지 확인
		If result1="" And result2="" Then

			'// 기존에 당첨된 사람이면 무조건 쿠폰발행 처리함.
			sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And sub_opt3 in ('projector','speaker','band') And userid='"&LoginUserid&"' "
			rsget.Open sqlstr, dbget, 1
			If rsget(0) >= 1 Then
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'coupon', getdate(), 'M')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '기존상품당첨자라 쿠폰발급 처리함.', 'M')"
				dbget.execute sqlstr

				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','1','15','BML 2015에서 만난 친구를 위한 쿠폰','30000','"& Left(nowdate, 10) &"','2015-05-31 23:59:59','',0,'system')"
				dbget.execute sqlstr
				Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win04.png' alt ='텐바이텐 15% 할인쿠폰 당첨' /></p></div>"
				dbget.close()	:	response.end
			End If
			rsget.close

			'// lg스마트빔 확률 0.5%
			If renloop>=1 And renloop < 6 Then

				'// lg스마트빔 재고파악
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt3='projector' "
				rsget.Open sqlstr, dbget, 1
				If rsget(0) >= 1 Then
					'// 프로젝터가 나갔다면 쿠폰발행
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'coupon', getdate(), 'M')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '프로젝터가 다 나가서 쿠폰발급 처리함.', 'M')"
					dbget.execute sqlstr

					sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
					sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
					sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','1','15','BML BML 2015에서 만난 친구를 위한 쿠폰','30000','"& Left(nowdate, 10) &"','2015-05-31 23:59:59','',0,'system')"
					dbget.execute sqlstr

					Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win04.png' alt ='텐바이텐 15% 할인쿠폰 당첨' /></p></div>"
					dbget.close()	:	response.end
				Else
					'// 프로젝터 당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'projector', getdate(), 'M')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '프로젝터 당첨', 'M')"
					dbget.execute sqlstr

					Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win01.png' alt ='LG 스마트빔 미니 프로젝터 당첨' /></p></div>"
					dbget.close()	:	response.end
				End If
				rsget.close

			'// 아이리버 스피커 1%
			ElseIf renloop>=10 And renloop < 21 Then

				'// 아이리버 스피커 재고파악
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt3='speaker' "
				rsget.Open sqlstr, dbget, 1
				If rsget(0) >= 2 Then
					'// 스피커가 다 나갔다면 쿠폰발행
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'coupon', getdate(), 'M')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '스피커가 다 나가서 쿠폰발급 처리함.', 'M')"
					dbget.execute sqlstr

					sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
					sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
					sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','1','15','BML 2015에서 만난 친구를 위한 쿠폰','30000','"& Left(nowdate, 10) &"','2015-05-31 23:59:59','',0,'system')"
					dbget.execute sqlstr
					Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win04.png' alt ='텐바이텐 15% 할인쿠폰 당첨' /></p></div>"
					dbget.close()	:	response.end
				Else
					'// 스피커 당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'speaker', getdate(), 'M')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '스피커 당첨', 'M')"
					dbget.execute sqlstr

					Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win02.png' alt ='아이리버 휴대용 블루투스 스피커 당첨' /></p></div>"
					dbget.close()	:	response.end
				End If
				rsget.close

			'// 장미 리본 꽃팔찌 50%
			ElseIf renloop>=400 And renloop < 901 Then

				'// 꽃팔찌 재고파악
				sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] Where evt_code="& eCode &" And convert(varchar(10),regdate,120) = '"& Left(nowdate, 10) &"' And sub_opt3='band' "
				rsget.Open sqlstr, dbget, 1
				If rsget(0) >= 195 Then
					'// 꽃팔찌가 다 나갔다면 쿠폰발행
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'coupon', getdate(), 'M')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '꽃팔찌가 다 나가서 쿠폰발급 처리함.', 'M')"
					dbget.execute sqlstr

					sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
					sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
					sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','1','15','BML 2015에서 만난 친구를 위한 쿠폰','30000','"& Left(nowdate, 10) &"','2015-05-31 23:59:59','',0,'system')"
					dbget.execute sqlstr
					Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win04.png' alt ='텐바이텐 15% 할인쿠폰 당첨' /></p></div>"
					dbget.close()	:	response.end
				Else
					'// 꽃팔찌 당첨
					sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'band', getdate(), 'M')"
					dbget.execute sqlstr

					'// 해당 유저의 로그값 집어넣는다.
					sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
					sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '장미 리본 꽃팔찌 당첨', 'M')"
					dbget.execute sqlstr

					Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win03.png' alt ='장미 리본 꽃 팔찌 당첨' /></p></div>"
					dbget.close()	:	response.end
				End If
				rsget.close

			'// 기타 나머지 사람들은 전부 쿠폰 발행
			Else
				sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , sub_opt1 , sub_opt3, regdate, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"', '1', 'coupon', getdate(), 'M')"
				dbget.execute sqlstr

				'// 해당 유저의 로그값 집어넣는다.
				sqlstr = "INSERT INTO db_log.[dbo].[tbl_caution_event_log] (evt_code , userid , refip , value3, device)" + vbcrlf
				sqlstr = sqlstr & " VALUES("& eCode &", '"& LoginUserid &"' ,'"&refip&"', '쿠폰당첨', 'M')"
				dbget.execute sqlstr

				sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
				sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue,couponname,minbuyprice,startdate,expiredate,targetitemlist,couponmeaipprice,reguserid)" + vbcrlf
				sqlstr = sqlstr & " values('" &couponid &"','"& LoginUserid &"','1','15','BML 2015에서 만난 친구를 위한 쿠폰','30000','"& Left(nowdate, 10) &"','2015-05-31 23:59:59','',0,'system')"
				dbget.execute sqlstr
				Response.write "OK|<div class='applyResult' style='display:block;'><p><img src='http://webimage.10x10.co.kr/eventIMG/2015/61909/img_win04.png' alt ='텐바이텐 15% 할인쿠폰 당첨' /></p></div>"
				dbget.close()	:	response.end

			End If
		Else
			Response.Write "Err|오늘은 모두 참여하셨습니다."
			response.End
		End If

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->