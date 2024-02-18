<%@codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.ContentType = "application/json"
'###########################################################
' Description : 여름에 뭐 입지?
' History : 2020-05-19 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<%
	dim currenttime, refer, amountLimit
	Dim eCode, LoginUserid, mode, sqlStr, device, cnt, cartTotalAmount
	dim oJson
	'object 초기화
	Set oJson = jsObject()

	IF application("Svr_Info") = "Dev" THEN
        eCode = "102182"
    Else
        eCode = "103450"
    End If

	mode = request("mode")

	currenttime 	= date()
	LoginUserid		= getencLoginUserid()
	refer 			= request.ServerVariables("HTTP_REFERER")
	cartTotalAmount = 0
	amountLimit = 200000
    if isapp then 
        device = "A"
    else
        device = "M"
    end if 

	''// 패션 카테고리 장바구니 금액
    Function getCartTotalAmountForFashionCategory(userid)
        If IsNull(userid) Or userid="" Then Exit Function
        On Error Resume Next
        dim sqlStr
        sqlStr = "exec [db_temp].[dbo].[usp_get_CartTotalPrice] @userid ='" & CStr(LoginUserid) & "'"

        rsget.CursorLocation = adUseClient
        rsget.CursorType=adOpenStatic
        rsget.Locktype=adLockReadOnly
        rsget.Open sqlStr, dbget
        
        If Not(rsget.bof Or rsget.eof) Then
            getCartTotalAmountForFashionCategory = rsget("totalprice")
        End If
        rsget.close
        
        On Error goto 0
    End Function
	
	if LoginUserid <> "" then cartTotalAmount = getCartTotalAmountForFashionCategory(LoginUserid)

if date() < Cdate("2020-06-24") then
	amountLimit = 200000
end if

if application("Svr_Info") <> "Dev" then 
    If InStr(refer, "10x10.co.kr") < 1 or eCode = "" Then
        oJson("response") = "err"
        oJson("message") = "잘못된 접속입니다."
        oJson.flush
        Set oJson = Nothing
        dbget.close() : Response.End
    End If
end if

if mode = "add" Then

	if Not(IsUserLoginOK) Then
		oJson("response") = "err"
		oJson("message") = "로그인을 해주세요."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	end if

	if cartTotalAmount < amountLimit Then
		oJson("response") = "err"
		oJson("message") = "장바구니에 패션 카테고리 상품 200,000원 이상 담은 후 이벤트 참여가 가능합니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End	
	end if

	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt1 = '1' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	If cnt < 1 Then
		sqlStr = ""
		sqlstr = "INSERT INTO [db_event].[dbo].[tbl_event_subscript] (evt_code , userid , device, sub_opt1)" & vbCrlf
		sqlstr = sqlstr & " VALUES ("& eCode &", '"& LoginUserid &"', '"&device&"', '1')"
		dbget.execute sqlstr

        '// 보너스 쿠폰 발급 1360
        sqlStr = ""
        sqlStr = sqlStr & "if not exists(select masteridx from [db_user].[dbo].tbl_user_coupon where userid='"& LoginUserid &"' and masteridx = 1360 and isusing = 'N')" & vbcrlf
        sqlStr = sqlStr & "begin" & vbcrlf
        sqlStr = sqlStr & " insert into [db_user].[dbo].tbl_user_coupon" & vbcrlf
        sqlStr = sqlStr & " (masteridx,userid,coupontype,couponvalue, couponname,minbuyprice,targetitemlist,startdate,expiredate,couponmeaipprice,validsitename)" & vbcrlf
        sqlStr = sqlStr & " 	SELECT idx, '"& LoginUserid &"',coupontype,couponvalue,couponname,minbuyprice,targetitemlist, startdate, expiredate,couponmeaipprice,validsitename"	 & vbcrlf
        sqlStr = sqlStr & " 	from [db_user].[dbo].tbl_user_coupon_master m" & vbcrlf
        sqlStr = sqlStr & " 	where idx = 1360 " & vbcrlf
        sqlStr = sqlStr & "end"
        dbget.execute sqlStr

		oJson("response") = "ok"
		oJson("message") = ""
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	Else				
		oJson("response") = "err"
		oJson("message") = "이미 신청하셨습니다."
		oJson.flush
		Set oJson = Nothing
		dbget.close() : Response.End
	End If

elseif mode = "cart" Then
	oJson("response") = "ok"
	oJson("message") = ""
	oJson("cartTotalAmount") = cartTotalAmount
	oJson.flush
	Set oJson = Nothing
	dbget.close() : Response.End
end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->