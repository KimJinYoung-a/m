<%
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/email/maillib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/smscls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_orderCls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<%
    DIM vIdx : vIdx=SESSION("vIdx")

    IF (vIdx="") THEN
        Response.Write("FAIL")
        Response.End
    END IF

    dim uselevelGift
    Dim vQuery, vTemp, vResult, vIOrder, vIsSuccess, vRstMsg
	vQuery = "SELECT TOP 1 userlevel FROM [db_order].[dbo].[tbl_giftcard_order_temp] WHERE temp_idx = '" & vIdx & "'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof THEN
        uselevelGift = rsget("userlevel")
    ENd IF
    rsget.close()
    response.Cookies("uinfo").domain = "10x10.co.kr"
    response.cookies("uinfo")("muserlevel") = uselevelGift
    session("ssnuserlevel") = uselevelGift


	vTemp = OrderRealSaveProc(vIdx)
	
    session("ssnuserlevel") = ""
	response.Cookies("uinfo").domain = "10x10.co.kr"
	response.Cookies("uinfo") = ""

	vResult		= Split(vTemp,"|")(0)
	vIOrder		= Split(vTemp,"|")(1)
	vRstMsg		= Split(vTemp,"|")(2)
	vIsSuccess	= Split(vTemp,"|")(3)

	IF vResult = "ok" Then
		vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET IsPay = 'Y', PayResultCode = '" & vResult & "', giftOrderSerial = '" & vIOrder & "', IsSuccess = '" & vIsSuccess & "' WHERE temp_idx = '" & vIdx & "'"
		dbget.execute vQuery

		Response.Write("OK") '절대로 지우지 마세요
	Else
	    '' vResult="x3" 인 경우 업데이트 하면 안됨. 중복결제 될 수 있음 temp_idx=151252 //2013/10/01, SET IsPay = 'N'
	    IF (vResult<>"x3") then
		    ''vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET IsPay = 'N', PayResultCode = '" & vResult & "' WHERE temp_idx = '" & vIdx & "'"
		    vQuery = "UPDATE [db_order].[dbo].[tbl_giftcard_order_temp] SET PayResultCode = '" & vResult & "' WHERE temp_idx = '" & vIdx & "'"
		    dbget.execute vQuery
        ENd IF

		Response.Write("FAIL")
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->