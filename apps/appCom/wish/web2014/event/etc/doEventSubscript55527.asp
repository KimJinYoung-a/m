<% option Explicit %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
	IF Len(Request.ServerVariables("HTTP_REFERER")) = 0 Then
	   response.write "<script>alert('access is incorrect');history.back();</script>"
	   response.End
	END IF
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%

	'###########################################################
	' Description : 10원의 기적!
	' History : 2014.07.21 원승현
	'###########################################################

	dim sqlStr, loginid, evt_code, releaseDate, evt_option, evt_option2, strsql, Linkevt_code
	Dim kit , coupon3 , coupon5 , arrList , i, mylist, vIdx, vProductCode, vUserprice, vProductname, samePriceCnt, userPriceCnt
	dim usermail, couponkey
	evt_code = requestCheckVar(Request("eventid"),32)		'이벤트 코드
	Linkevt_code = requestCheckVar(Request("linkeventid"),32) '링크코드
	loginid = GetLoginUserID()
	vIdx = requestCheckVar(Request("idx"),32) '// db_temp.dbo.tbl_miracleOf10Won에 각 상품별 셋팅 idx
	vProductCode = requestCheckVar(Request("productcode"),42) '// 상품코드
	vUserprice = getNumeric(requestCheckVar(Request("userprice"),18)) '// 사용자가 입력한 상품가격
	vProductname = request("productname")

	vUserprice = CLng(vUserprice)


	dim referer
	referer = request.ServerVariables("HTTP_REFERER")


	'// 로그인 여부 확인 //
	if loginid="" or isNull(loginid) then
		Response.Write "{ "
		response.write """stcode"":""77"""
'		response.write ", ""productcode"":"""&vProductCode&""""
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


	'// 기타 잘못된 접근(이벤트코드없음, idx값 없음, 상품코드값없음)
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
	If vProductCode = "" Or IsNull(vProductCode) Then
		Response.Write "{ "
		response.write """stcode"":""55"""
		response.write "}"
		response.End
	End If


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
	sqlstr = " Select sub_opt2 " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" Where evt_code='"&evt_code&"' And sub_opt1='"&vIdx&"' And userid='"&loginid&"' "
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

	'// 해당 상품 가격을 3회 초과 입력했는지 확인
	sqlstr = " Select count(*) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" Where evt_code='"&evt_code&"' And sub_opt1='"&vIdx&"' And userid='"&loginid&"' "
	rsget.Open sqlStr,dbget,1
	if Not(rsget.BOF or rsget.EOF) Then
		
		If rsget(0) >= 3 Then
			Response.Write "{ "
			response.write """stcode"":""22"""
			response.write "}"
			dbget.close()
			response.End	
		End If
	End If
	rsget.Close


	'// 값을 입력한다.
	sqlStr = "Insert into db_event.dbo.tbl_event_subscript " &_
			" (evt_code, userid, sub_opt1, sub_opt2, sub_opt3, device) values " &_
			" (" & evt_code &_
			",'" & loginid & "'" &_
			",'" & vIdx & "'" &_
			",'" & vUserprice & "'" &_
			",'" & vProductname & "'" &_
			",'A')"
			'response.write sqlstr
	dbget.execute(sqlStr)


	'// 유저가 입력한 금액 동일값 카운트
	sqlstr = " Select count(*) as cnt " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" Where evt_code='"&evt_code&"' And sub_opt1='"&vIdx&"' And sub_opt2='"&vUserprice&"' "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		samePriceCnt = rsget(0)
	Else
		samePriceCnt = 0
	End If
	rsget.Close

	'// 현재 유저가 입력한 금액갯수
	sqlstr = " Select count(*) " &_
				" From db_event.dbo.tbl_event_subscript " &_
				" Where evt_code='"&evt_code&"' And sub_opt1='"&vIdx&"' And userid='"&loginid&"' "
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
		response.write ", ""productcode"":"""&vProductCode&""""
		response.write ", ""samepricecnt"":"""&samePriceCnt&""""
		response.write ", ""userpriceCnt"":"""&userPriceCnt&""""
		response.write ", ""userprice"":"""&vUserprice&""""
		response.write "}"
		response.End

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->