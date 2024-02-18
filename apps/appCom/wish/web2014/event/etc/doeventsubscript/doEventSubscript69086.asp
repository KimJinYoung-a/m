<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 사대천왕 for App
' History : 2016-02-11 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%	
dim eCode, userid, strSql , sqlstr , refer , totcnt , mode
Dim icpn1 , icpn2 , icpn3 , icpn4 , icpn5 '//상품쿠폰
Dim renloop , couponnum
Dim wincnt1 , wincnt2 , wincnt3 , wincnt4
Dim prizecnt1 , prizecnt2 , prizecnt3 , prizecnt4
Dim snsno , rvalue

	mode = requestCheckvar(request("mode"),1)
	snsno = requestCheckvar(request("snsno"),2)

	randomize
	renloop=int(Rnd*5000)+1 '100%

	prizecnt1 = 5 '5 '인스탁스
	prizecnt2 = 10 '10 '스티키몬스터
	prizecnt3 = 2264 '800 '토끼램프 '오후 4시 1차 물량 780개 추가
	prizecnt4 = 10000 '1000 '앨리스 '오후 4시 1차 물량 980개 추가

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66025"
		icpn1 = "11118" '인스탁스
		icpn2 = "11119" '스티키몬스터 베터리
		icpn3 = "11120" '당근토끼
		icpn4 = "11122" '앨리스 카드
		icpn5 = "2767" '무료배송쿠폰(보너스 쿠폰)
	Else
		eCode = "69086"
		icpn1 = "11479" '인스탁스
		icpn2 = "11478" '스티키몬스터 베터리
		icpn3 = "11477" '당근토끼
		icpn4 = "11476" '앨리스 카드
		icpn5 = "823" '무료배송쿠폰(보너스 쿠폰)
	End If

	userid = getEncLoginUserID

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "{ "
		response.write """resultcode"":""88""" '// 잘못된 접속임
		response.write "}"
		dbget.close()
		response.end
	end if

	If userid = "" Then
		Response.Write "{ "
		response.write """resultcode"":""44""" '// 아이디 없음
		response.write "}"
		dbget.close()
		response.end
	End If

	'// 이벤트 기간 확인
	If Not(Now() > #02/15/2016 10:00:00# and Now() < #02/29/2016 23:59:59#) Then
		Response.Write "{ "
		response.write """resultcode"":""33"""
		response.write "}"
		dbget.close()
		response.end
	End If 
'###########################################################################################################################################
	'//쿠폰 발급
	Sub fnGetCoupon(v)
		If v = 1 Then couponnum = icpn1
		If v = 2 Then couponnum = icpn2
		If v = 3 Then couponnum = icpn3
		If v = 4 Then couponnum = icpn4
		If v = 5 Then couponnum = icpn5

		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript](evt_code, userid, sub_opt1, sub_opt2, device)" + vbcrlf
		sqlstr = sqlstr & " VALUES("& eCode &", '" & userid & "', '"& couponnum &"', "& v &", 'A')" 
		dbget.execute sqlstr
		
		If v = 5 Then '꽝
			'//꽝이거나 소진됐을때
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'2016-02-10 00:00:00','2016-02-29 23:59:59',couponmeaipprice,validsitename" + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& couponnum &""
			dbget.execute sqlstr
		Else 
			'//당첨시
			rvalue = fnSetItemCouponDown(userid, couponnum)
			SELECT CASE  rvalue 
				CASE 0
					'Response.Write "데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오."
					Response.Write "{ "
					response.write """resultcode"":""E0"""
					response.write "}"
					dbget.close()
					response.End
				CASE 1
					Response.Write "{ "
					response.write """resultcode"":""11"""
					response.write ",""wincode"":"""&v&""""
					response.write "}"
					dbget.close()
					response.End
				CASE 2
					'Response.Write "기간이 종료되었거나 유효하지 않은 쿠폰입니다."
					Response.Write "{ "
					response.write """resultcode"":""E2"""
					response.write "}"
					dbget.close()
					response.End
				CASE 3
					'Response.Write "이미 쿠폰을 받으셨습니다."
					Response.Write "{ "
					response.write """resultcode"":""E3"""
					response.write "}"
					dbget.close()
					response.End
				case else
					'Response.Write "데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오."
					Response.Write "{ "
					response.write """resultcode"":""ER"""
					response.write "}"
					dbget.close()
					response.End
			END Select
		End If 
		
		Response.Write "{ "
		response.write """resultcode"":""11"""
		response.write ",""wincode"":"""&v&""""
		response.write "}"
		dbget.close()
		response.End
	End Sub
'###########################################################################################################################################
	'## 상품쿠폰 다운 함수
	Function fnSetItemCouponDown(ByVal userid, ByVal idx)
		dim sqlStr
		Dim objCmd
		Set objCmd = Server.CreateObject("ADODB.COMMAND")
		With objCmd
			.ActiveConnection = dbget
			.CommandType = adCmdText
			.CommandText = "{?= call [db_item].[dbo].sp_Ten_itemcoupon_down("&idx&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
			End With	
			fnSetItemCouponDown = objCmd(0).Value	
		Set objCmd = Nothing	
	END Function
'###########################################################################################################################################
	'//당첨 확인
	Sub fnGetWinner()
		strSql = "SELECT " + vbcrlf
		strSql = strSql & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as item1, " + vbcrlf
		strSql = strSql & " isnull(sum(case when sub_opt2 = '2' then 1 else 0 end),0) as item2, " + vbcrlf
		strSql = strSql & " isnull(sum(case when sub_opt2 = '3' then 1 else 0 end),0) as item3, " + vbcrlf
		strSql = strSql & " isnull(sum(case when sub_opt2 = '4' then 1 else 0 end),0) as item4 " + vbcrlf
		strSql = strSql & " from db_event.dbo.tbl_event_subscript where evt_code = '"&eCode&"' " 
		rsget.Open strSql,dbget,1
		IF Not rsget.Eof Then
			wincnt1 = rsget("item1")
			wincnt2 = rsget("item2")
			wincnt3 = rsget("item3")
			wincnt4 = rsget("item4")
		End If
		rsget.close()

		If renloop < 5 Then '1등 0.01%
			If wincnt1 < prizecnt1 Then '물량있음
				Call fnGetCoupon(1)
			Else
				Call fnGetCoupon(5)
			End If 
		ElseIf renloop > 5 And renloop < 16 Then '2등 0.1%
			If wincnt2 < prizecnt2 Then '물량있음
				Call fnGetCoupon(2)
			Else
				Call fnGetCoupon(5)
			End If 
		ElseIf renloop > 15 And renloop < 2200 Then '3등 40%
			If wincnt3 < prizecnt3 Then '물량있음
				Call fnGetCoupon(3)
			Else
				Call fnGetCoupon(5)
			End If 
		ElseIf renloop > 2201 And renloop < 5000 Then '4등 54%
			If wincnt4 < prizecnt4 Then '물량있음
				Call fnGetCoupon(4)
			Else
				Call fnGetCoupon(5)
			End If 
'		ElseIf renloop > 4900 And renloop < 5000 Then '5등 꽝 쿠폰
'			Call fnGetCoupon(5)
		End If 		
	End Sub
'###########################################################################################################################################
'###########################################################################################################################################
SELECT CASE mode
	CASE "I"	'이벤트 응모

		Dim lastusercnt '앱마지막 로그인 카운트
		Dim logusercnt '로그인내역 카운트
		Dim evt_pass : evt_pass = False '이벤트 응모 여부 chkflag

		strSql = "select min(convert(varchar(10),regdate,120)) from db_contents.dbo.tbl_app_regInfo where userid = '" & userid & "' "
		rsget.CursorLocation = adUseClient
		rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

		IF Not rsget.Eof Then
			lastusercnt = rsget(0) '// 날짜
		Else
			lastusercnt = ""
		End IF
		rsget.close

		If lastusercnt <> "" Then '//어쨌든 값은 있음
			If lastusercnt >= "2015-02-15" Then '// 기준 충족시
				evt_pass = true
			Else
				evt_pass = false
			End If 
		Else '//값 없음 ios라던가 값이 없을 수 있음
			strSql = "select min(convert(varchar(10),regdate,120)) from db_contents.[dbo].[tbl_app_NidInfo] WHERE lastuserid = '"& userid &"'"
			rsget.CursorLocation = adUseClient
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

			IF Not rsget.Eof Then
				logusercnt = rsget(0) '// 날짜
			Else
				logusercnt = ""
			End IF
			rsget.close

			If logusercnt <> "" Then '//여기엔 있다
				If logusercnt >= "2015-02-15" Then '// 기준 충족시
					evt_pass = true
				Else
					evt_pass = false
				End If
			Else
				evt_pass = false
			End if
		End If 

		If evt_pass Then '응모
			'//응모 카운트 체크
			strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
			rsget.CursorLocation = adUseClient
			rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

			IF Not rsget.Eof Then
				totcnt = rsget(0) '// 0 1
			End IF
			rsget.close

			If totcnt = 0 Then
				Call fnGetWinner()
			Else '이미 응모함
				Response.Write "{ "
				response.write """resultcode"":""99""" 
				response.write "}"
				dbget.close()
				response.End
			End If 
		Else '응모 권한이 없음
			Response.Write "{ "
			response.write """resultcode"":""00"""
			response.write "}"
			response.end
		End If 
	
	CASE "S"	'SNS 카운팅
		sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('"& eCode &"' " &_
			", '"& userid &"' " &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
			", '"& snsno &"' " &_
			", '' " &_
			", '' " &_
			", 'M') "
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
END Select
'###########################################################################################################################################
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->