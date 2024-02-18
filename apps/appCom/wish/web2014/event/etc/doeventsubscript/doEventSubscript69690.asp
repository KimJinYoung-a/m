<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 사대천왕 A
' History : 2016-03-17 유태욱 생성
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
Dim snsno , getitemno, rvalue

	mode = requestCheckvar(request("mode"),1)
	snsno = requestCheckvar(request("snsno"),2)
	getitemno = requestCheckvar(request("getitemno"),2)

	randomize
	renloop=int(Rnd*5000)+1 '100%

	prizecnt1 = 5 '5 '라인 공기청정기
	prizecnt2 = 18 '10 '아이리버 스피커
	prizecnt3 = 3500 '800 '에코백
	prizecnt4 = 3000 '1000 '토끼

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66073"
		icpn1 = "11125" '라인 공기청정기
		icpn2 = "11126" '아이리버
		icpn3 = "11127" '에코백
		icpn4 = "11128" '토끼
		icpn5 = "2767" '무료배송쿠폰(보너스 쿠폰)
	Else
		eCode = "69690"
		icpn1 = "11497" '라인 공기청정기
		icpn2 = "11498" '아이리버
		icpn3 = "11499" '에코백
		icpn4 = "11500" '토끼
		icpn5 = "823" '무료배송쿠폰(보너스 쿠폰)
	End If

	userid = getEncLoginUserID

	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		Response.Write "Err|잘못된 접근 입니다."
		dbget.close()	:	response.End

'		Response.Write "{ "
'		response.write """resultcode"":""88""" '// 잘못된 접속임
'		response.write "}"
'		dbget.close()
'		response.end
	end if

	If userid = "" Then
		Response.Write "Err|로그인후 이용하실 수 있습니다."
		dbget.close()	:	response.End

'		Response.Write "{ "
'		response.write """resultcode"":""44""" '// 아이디 없음
'		response.write "}"
'		dbget.close()
'		response.end
	End If

	if mode <> "S" then
		'// 이벤트 기간 확인
		If Not(Now() > #03/21/2016 10:00:00# and Now() < #03/27/2016 23:59:59#) Then
			Response.Write "Err|이벤트 응모 기간이 아닙니다."
			dbget.close()	:	response.End

'			Response.Write "{ "
'			response.write """resultcode"":""33"""
'			response.write "}"
'			dbget.close()
'			response.end
		End If
	end if
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
			'//꽝이거나 소진됐을때 무료배송 쿠폰
			sqlstr = "insert into [db_user].[dbo].tbl_user_coupon" + vbcrlf
			sqlstr = sqlstr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" + vbcrlf
			sqlstr = sqlstr & " 	SELECT idx, '"& userid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist,'2016-03-21 00:00:00','2016-03-31 23:59:59',couponmeaipprice,validsitename" + vbcrlf
			sqlstr = sqlstr & " 	from [db_user].[dbo].tbl_user_coupon_master m" + vbcrlf
			sqlstr = sqlstr & " 	where idx="& couponnum &""
			dbget.execute sqlstr
		Else 
			'//당첨시
			rvalue = fnSetItemCouponDown(userid, couponnum)
			SELECT CASE  rvalue 
				CASE 0
					Response.Write "Err|데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오."
					dbget.close()	:	response.End
					
					'Response.Write "데이터 처리에 문제가 발생하였습니다. 관리자에게 문의해주십시오."
'					Response.Write "{ "
'					response.write """resultcode"":""E0"""
'					response.write "}"
'					dbget.close()
'					response.End
				CASE 1
					if v = 1 then
						Response.write "OK|<button class='btnClose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_layer_close.png' alt='닫기' /></button><div class='win' ><p onclick=""addshoppingBag('1');""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/realimg/layer_win_01.png' alt='' /></p><a href=''  class='goBuy'>지금 구매하러 가기</a></div>"
						dbget.close()	:	response.End
					elseif v = 2 then
						Response.write "OK|<button class='btnClose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_layer_close.png' alt='닫기' /></button><div class='win' ><p onclick=""addshoppingBag('2');""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/realimg/layer_win_02.png' alt='' /></p><a href=''  class='goBuy'>지금 구매하러 가기</a></div>"
						dbget.close()	:	response.End
					elseif v = 3 then
						Response.write "OK|<button class='btnClose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_layer_close.png' alt='닫기' /></button><div class='win' ><p onclick=""addshoppingBag('3');""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/realimg/layer_win_03.png' alt='' /></p><a href=''  class='goBuy'>지금 구매하러 가기</a></div>"
						dbget.close()	:	response.End
					elseif v = 4 then
						Response.write "OK|<button class='btnClose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_layer_close.png' alt='닫기' /></button><div class='win' ><p onclick=""addshoppingBag('4');""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/realimg/layer_win_04.png' alt='' /></p><a href=''  class='goBuy'>지금 구매하러 가기</a></div>"
						dbget.close()	:	response.End
					else
						Response.write "OK|<button class='btnClose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_layer_close.png' alt='닫기' /></button><div class='win' ><p onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/realimg/layer_win_05.png' alt='' /></p><a href=''  class='goBuy'>무료배송 쿠폰</a></div>"
						dbget.close()	:	response.End
					end if
						
'					Response.write "OK|<button class='btnClose'><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_layer_close.png' alt='닫기' /></button><div class='win' ><p><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/realimg/layer_win_0"&v&".png' alt='' /></p><a href='' onclick='addshoppingBag('"&v&"');return false;' class='goBuy'>지금 구매하러 가기</a></div>"
'					dbget.close()	:	response.End
'					Response.Write "{ "
'					response.write """resultcode"":""11"""
'					response.write ",""wincode"":"""&v&""""
'					response.write "}"
'					dbget.close()
'					response.End
				CASE 2
					Response.Write "Err|기간이 종료되었거나 유효하지 않은 쿠폰입니다."
					dbget.close()	:	response.End

					'Response.Write "기간이 종료되었거나 유효하지 않은 쿠폰입니다."
'					Response.Write "{ "
'					response.write """resultcode"":""E2"""
'					response.write "}"
'					dbget.close()
'					response.End
				CASE 3
					Response.Write "Err|이미 쿠폰을 받으셨습니다."
					dbget.close()	:	response.End

					'Response.Write "이미 쿠폰을 받으셨습니다."
'					Response.Write "{ "
'					response.write """resultcode"":""E3"""
'					response.write "}"
'					dbget.close()
'					response.End
				case else
					Response.Write "Err|데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오."
					dbget.close()	:	response.End

					'Response.Write "데이터 처리에 예외 상황이 발생하였습니다. 관리자에게 문의해주십시오."
'					Response.Write "{ "
'					response.write """resultcode"":""ER"""
'					response.write "}"
'					dbget.close()
'					response.End
			END Select
		End If 
		
		Response.write "OK|<button class='btnClose' onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/btn_layer_close.png' alt='닫기' /></button><div class='win' ><p onclick=""fnClosemask();""><img src='http://webimage.10x10.co.kr/eventIMG/2016/69690/realimg/layer_win_05.png' alt='' /></p><a href=''  class='goBuy'>무료배송 쿠폰</a></div>"
		dbget.close()	:	response.End

'		Response.Write "{ "
'		response.write """resultcode"":""11"""
'		response.write ",""wincode"":"""&v&""""
'		response.write "}"
'		dbget.close()
'		response.End
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

		If renloop < 1 Then '1등 0%								라인 프렌드 공기청정기		0
			If wincnt1 < prizecnt1 Then '물량있음
				Call fnGetCoupon(1)
			Else
				Call fnGetCoupon(5)
			End If 
		ElseIf renloop > 0 And renloop < 251 Then '2등 0%		아이리버 스피커			1~250
			If wincnt2 < prizecnt2 Then '물량있음
				Call fnGetCoupon(2)
			Else
				Call fnGetCoupon(5)
			End If 
		ElseIf renloop > 250 And renloop < 3751 Then '3등 70%		에코백					251~3750
			If wincnt3 < prizecnt3 Then '물량있음
				Call fnGetCoupon(3)
			Else
				Call fnGetCoupon(5)
			End If
		ElseIf renloop > 3750 And renloop < 5001 Then '4등 15%	토끼램프					4251~5000
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
			If lastusercnt >= "2016-03-21" Then '// 기준 충족시
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
				If logusercnt >= "2016-03-21" Then '// 기준 충족시
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
				Response.Write "Err|이미 응모 하셨습니다."
				dbget.close()	:	response.End

'				Response.Write "{ "
'				response.write """resultcode"":""99""" 
'				response.write "}"
'				dbget.close()
'				response.End
			End If 
		Else '응모 권한이 없음
			Response.Write "Err|본 이벤트는 APP에서 로그인 이력이 한번도 없는 고객님을 위한 이벤트입니다."
			dbget.close()	:	response.End

'			Response.Write "{ "
'			response.write """resultcode"":""00"""
'			response.write "}"
'			response.end
		End If 
	
	CASE "S"	'SNS 카운팅
		sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('"& eCode &"' " &_
			", '"& userid &"' " &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
			", '"& snsno &"' " &_
			", '' " &_
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
	CASE "G"	'구매하러가기 버튼 카운팅
		sqlstr = "insert into db_log.[dbo].[tbl_caution_event_log] (evt_code, userid, refip, value1 , value2, value3, device ) values " &_
			" ('"& eCode &"' " &_
			", '"& userid &"' " &_
			", '"& Left(request.ServerVariables("REMOTE_ADDR"),32) & "' " &_
			", '"& getitemno &"' " &_
			", 'getitemno' " &_
			", '' " &_
			", 'A') "
		dbget.Execute sqlstr

		Response.write "OK"
		Response.End
END Select
'###########################################################################################################################################
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->