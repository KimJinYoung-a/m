<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Charset="UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
IF Len(Request.ServerVariables("HTTP_REFERER")) = 0 Then
   response.write "<script>alert('access is incorrect');history.back();</script>"
   response.End
END IF
'###########################################################
' Description : 최 저 가 왕 for mobile & app (구 10원의 기적)
' History : 2015.07.06 이종화 
'###########################################################

dim sqlStr, loginid, evt_code, releaseDate, evt_option, evt_option2, strsql, Linkevt_code
Dim kit , coupon3 , coupon5 , arrList , i, mylist, vIdx, vUserprice, vProductname, samePriceCnt, userPriceCnt
dim usermail, couponkey , mode , vTotcnt
Dim result1 , result2
Dim rnum '//구분횟수
Dim vDevice 
If isapp = "1" Then 
	vDevice = "A"
Else
	vDevice = "M"
End If 
evt_code = requestCheckVar(Request("eventid"),32)		'이벤트 코드
Linkevt_code = requestCheckVar(Request("linkeventid"),32) '링크코드
loginid = GetLoginUserID()
vIdx = requestCheckVar(Request("idx"),32) '// db_temp.dbo.tbl_miracleOf10Won에 각 상품별 셋팅 idx
vUserprice = getNumeric(requestCheckVar(Request("userprice"),18)) '// 사용자가 입력한 상품가격
vProductname = request("productname") '//상품명
vUserprice = CLng(vUserprice)
mode = requestCheckVar(Request("mode"),6)

'#################################################################################################
'기본 체크 영역
'#################################################################################################
'// 로그인 여부 확인 //
if loginid="" or isNull(loginid) then
	Response.Write "{ "
	response.write """stcode"":""77"""
	response.write "}"
	response.End
end If

'// 이벤트 기간 확인 //
sqlStr = "Select evt_startdate, evt_enddate " &_
		" From db_event.dbo.tbl_event " &_
		" WHERE evt_code='" & evt_code & "'"

rsget.Open sqlStr,dbget,1
if rsget.EOF or rsget.BOF Then
	Response.Write "{ "
	response.write """stcode"":""99"""
	response.write "}"
	dbget.close()	:	response.End
elseif date<rsget("evt_startdate") or date>rsget("evt_enddate") Then
	Response.Write "{ "
	response.write """stcode"":""88"""
	response.write "}"
	dbget.close()	:	response.End
end if
rsget.Close

'//2라운드 모두 종료후 접근시
If hour(now()) >= 17 Then
	Response.Write "{ "
	response.write """stcode"":""888"""
	response.write "}"
	response.End
End If

'// 기타 잘못된 접근(이벤트코드없음, idx값 없음, mode값 없음)
If evt_code = "" Or IsNull(evt_code) Then
	Response.Write "{ "
	response.write """stcode"":""55"""
	response.write "}"
	response.End
End If
If vIdx = "" Or IsNull(vIdx) Then
	Response.Write "{ "
	response.write """stcode"":""55"""
	response.write "}"
	response.End
End If
If mode = "" Or IsNull(mode) Then
	Response.Write "{ "
	response.write """stcode"":""55"""
	response.write "}"
	response.End
End If

'#################################################################################################
'#####  kakao 
'#################################################################################################

If mode="kakao" then
	'//카카오초대 체크 여부 및 update
	If hour(now()) > 9 And hour(now()) < 13 Then
		rnum = "11"
	ElseIf hour(now()) > 13 And hour(now()) < 17 Then
		rnum = "21"
	Else
		Response.Write "{ "
		response.write """stcode"":""99""" '//아직 응모 시간 아니야~ 친구 초대 못보내~
		response.write "}"
		response.End
	End If
	
	'//카카오 로그 심기(클릭수 -_-;)
	sqlstr = "INSERT INTO [db_temp].[dbo].[tbl_event_click_log](eventid, chkid)" + vbcrlf
	sqlstr = sqlstr & " VALUES('"& evt_code &"', 'kakao')"
	dbget.execute(sqlstr)
	
	'// 응모내역 검색 , 이벤트코드 , 회차수 , 상품코드 , 일자 체크
	sqlstr = "select top 1 roundnum , kakaochk "
	sqlstr = sqlstr & " from db_temp.dbo.tbl_MiracleOf10Won_list "
	sqlstr = sqlstr & " where evt_code='"& evt_code &"'"
	sqlstr = sqlstr & " and userid='"& loginid &"' and datediff(day,regdate,getdate()) = 0 and roundnum = '"& rnum &"' and prizecode = '"&vIdx&"' "
	rsget.Open sqlstr, dbget, 1
	If Not rsget.Eof Then
		'//최초 응모
		result1 = rsget(0) '//응모1차 or 2차 응모여부
		result2 = rsget(1) '//카카오2차 응모 확인용 null , kakao
	Else
		'// 최초응모
		result1 = ""
		result2 = ""
	End IF
	rsget.close

	If result1 = "" and result2 = "" Then '//참여 이력이 없음 - 응모후 이용 하시오
		Response.Write "{ "
		response.write """stcode"":""11""" 
		response.write "}"
		dbget.close()	:	response.End
	ElseIf CStr(result1) = CStr(rnum) And (result2 = "" Or isnull(result2) Or result2 <> "kakao" or result2 = "NULL") Then	'//1회 참여시 
		sqlstr = " update db_temp.dbo.tbl_MiracleOf10Won_list set kakaochk = 'kakao'" + vbcrlf
		sqlstr = sqlstr & " where evt_code="& evt_code &" and userid='"& loginid &"' and datediff(day,regdate,getdate()) = 0 and roundnum = '"& rnum &"' and prizecode = '"&vIdx&"' " + vbcrlf
		dbget.execute sqlstr '// 응모 기회 한번 더줌
		Response.Write "{ "
		response.write """stcode"":""22"""
		response.write "}"
		dbget.close()	:	response.End
	ElseIf CStr(result1) = CStr(rnum) And result2 = "kakao" Then	'오늘의 초대는 모두 완료!\n내일 또 도전해 주세요!
		Response.Write "{ "
		response.write """stcode"":""33"""
		response.write "}"
		dbget.close()	:	response.End
	End If
End If

'#################################################################################################
'#####  insert
'#################################################################################################

If mode="insert" Then
	'// 10원 단위로 입력했는지 확인
	If Right(Trim(vUserprice), 1) <> "0" Then
		Response.Write "{ "
		response.write """stcode"":""11"""
		response.write "}"
		response.End	
	End If


	'// 유저 가격이 기적의 범위 가격 내인지 확인
	sqlstr = " Select idx, sdate, edate, sviewdate, eviewdate, productCode, productName, productBigImg, productSmallImg, productPrice, auctionMinPrice, auctionMaxPrice, " &_
				" winnerPrice, winneruserid, regdate From db_temp.dbo.tbl_MiracleOf10Won " &_
				" Where auctionMinPrice <= '"&Trim(vUserprice)&"' And auctionMaxPrice >= '"&Trim(vUserprice)&"' And idx='"&vIdx&"' "
	rsget.Open sqlStr,dbget,1
	if rsget.BOF or rsget.EOF Then
		Response.Write "{ "
		response.write """stcode"":""66"""
		response.write "}"
		dbget.close()
		response.End	
	End If
	rsget.Close


	'// 상품 현재 가격 입력 가능시간인지 확인
	sqlstr = " Select idx, sdate, edate, sviewdate, eviewdate, productCode, productName, productBigImg, productSmallImg, productPrice, auctionMinPrice, auctionMaxPrice, " &_
				" winnerPrice, winneruserid, regdate From db_temp.dbo.tbl_MiracleOf10Won " &_
				" Where getdate() >= sdate And  getdate() <= edate And idx='"&vIdx&"' "
	rsget.Open sqlStr,dbget,1
	if rsget.BOF or rsget.EOF Then
		Response.Write "{ "
		response.write """stcode"":""44"""
		response.write "}"
		dbget.close()
		response.End	
	End If
	rsget.Close


	'// 해당 상품에 대하여 동일가격을 입력했는지 확인
	sqlstr = " Select lprice " &_
				" From db_temp.dbo.tbl_MiracleOf10Won_list " &_
				" Where evt_code='"&evt_code&"' And prizecode='"&vIdx&"' And userid='"&loginid&"' "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.BOF or rsget.EOF) Then
		Do Until rsget.eof
			If Trim(CStr(rsget(0))) = Trim(vUserprice) Then
				Response.Write "{ "
				response.write """stcode"":""33"""
				response.write "}"
				dbget.close()
				response.End	
			End If
		rsget.movenext
		Loop
	End If
	rsget.Close

	'// 해당 상품 가격을 2회 초과 입력했는지 확인
	sqlstr = " Select count(*) " &_
				" From db_temp.dbo.tbl_MiracleOf10Won_list " &_
				" Where evt_code='"&evt_code&"' And prizecode='"&vIdx&"' And userid='"&loginid&"' "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.BOF or rsget.EOF) Then
		vTotcnt = rsget(0)

		If rsget(0) >= 2 Then
			Response.Write "{ "
			response.write """stcode"":""22"""
			response.write "}"
			dbget.close()
			response.End	
		End If
	End If
	rsget.Close

	Sub fnGetInsert(v) '//
		'// 값을 입력한다.
		sqlStr = " Insert into db_temp.dbo.tbl_MiracleOf10Won_list (evt_code , userid , usercell , userlevel , roundnum , lprice , prizecode , prizename , device) " &_
				" select top 1 '"& evt_code &"',n.userid,n.usercell,l.userlevel,'"& v &"', '"& vUserprice &"' , '"& vIdx &"' , '"& vProductname &"' ,'"& vDevice &"' from db_user.dbo.tbl_user_n as n " &_
				" inner join db_user.dbo.tbl_logindata as l " &_
				" on n.userid = l.userid and n.userid = '"&loginid&"' " 
		dbget.execute(sqlStr)

		'// 유저가 입력한 금액 동일값 카운트
		sqlstr = " Select count(*) as cnt " &_
					" From db_temp.dbo.tbl_MiracleOf10Won_list " &_
					" Where evt_code='"&evt_code&"' And prizecode='"&vIdx&"' And lprice='"&vUserprice&"' "
		rsget.Open sqlStr,dbget,1
		If Not(rsget.bof Or rsget.eof) Then
			samePriceCnt = rsget(0)
		Else
			samePriceCnt = 0
		End If
		rsget.Close

		'// 현재 유저가 입력한 금액갯수
		sqlstr = " Select count(*) " &_
					" From db_temp.dbo.tbl_MiracleOf10Won_list " &_
					" Where evt_code='"&evt_code&"' And prizecode='"&vIdx&"' And userid='"&loginid&"' "
		rsget.Open sqlStr,dbget,1
		If Not(rsget.bof Or rsget.eof) Then
			userPriceCnt = rsget(0)
		Else
			userPriceCnt = 0
		End If
		rsget.Close

		'// 결과 값 리턴
			Response.Write "{ "
			response.write """stcode"":""00"""
			response.write ", ""productcode"":"""&vIdx&""""
			response.write ", ""samepricecnt"":"""&samePriceCnt&""""
			response.write ", ""userpriceCnt"":"""&userPriceCnt&""""
			response.write ", ""userprice"":"""&vUserprice&""""
			response.write "}"
			response.End
	End Sub


	'// 입력 프로세스
	If hour(now()) > 9 And hour(now()) < 13 Then
		If vTotcnt = 0 then
			Call fnGetInsert(11)
		ElseIf vTotcnt = 1 Then
			'// 응모내역 검색 , 이벤트코드 , 회차수 , 상품코드 , 일자 체크
			sqlstr = "select top 1 kakaochk "
			sqlstr = sqlstr & " from db_temp.dbo.tbl_MiracleOf10Won_list "
			sqlstr = sqlstr & " where evt_code='"& evt_code &"'"
			sqlstr = sqlstr & " and userid='"& loginid &"' and datediff(day,regdate,getdate()) = 0 and roundnum = '11' and prizecode = '"&vIdx&"' "
			rsget.Open sqlstr, dbget, 1
			If Not rsget.Eof Then
				If rsget(0) = "" Or isnull(rsget(0)) Or rsget(0) <> "kakao" or rsget(0) = "NULL" Then
					Response.Write "{ "
					response.write """stcode"":""999""" '//카카오 없다 다단계 하고 와라
					response.write "}"
					dbget.close()
					response.End
				Else
					rsget.close
					Call fnGetInsert(12) '2번째 응모 프로세스
				End If 
			End IF
			rsget.close
		End If 
	ElseIf hour(now()) > 13 And hour(now()) < 17 Then
		If vTotcnt = 0 then
			Call fnGetInsert(21)
		ElseIf vTotcnt = 1 Then
			'// 응모내역 검색 , 이벤트코드 , 회차수 , 상품코드 , 일자 체크
			sqlstr = "select top 1 kakaochk "
			sqlstr = sqlstr & " from db_temp.dbo.tbl_MiracleOf10Won_list "
			sqlstr = sqlstr & " where evt_code='"& evt_code &"'"
			sqlstr = sqlstr & " and userid='"& loginid &"' and datediff(day,regdate,getdate()) = 0 and roundnum = '21' and prizecode = '"&vIdx&"' "
			rsget.Open sqlstr, dbget, 1
		
			If Not rsget.Eof Then
				If rsget(0) = "" Or isnull(rsget(0)) Or rsget(0) <> "kakao" or rsget(0) = "NULL" Then
					Response.Write "{ "
					response.write """stcode"":""999""" '//카카오 없다 다단계 하고 와라
					response.write "}"
					dbget.close()
					response.End
				Else 
					rsget.close
					Call fnGetInsert(22) '2번째 응모 프로세스
				End If 
			End IF
			rsget.close
		End If 
	Else
		Response.Write "{ "
		response.write """stcode"":""99""" '//아직 응모 시간 아니야~
		response.write "}"
		response.End
	End if
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->