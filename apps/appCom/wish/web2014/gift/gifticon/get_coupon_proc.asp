<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/ordercls/giftiConCls.asp"-->

<%
	Dim vQuery, vQuery1, vUserID, vIdx, vResult, vItemOption, vItemID, vOptionName, vRequireDetail, vCouponNo, vSellCash, vNowDate, v60LaterDate, vMasterIdx, vCouponIDX
	vIdx 			= requestCheckVar(request("idx"),10)
	vUserID			= GetLoginUserID

	If vUserID = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	
	
	vQuery = "SELECT * From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND IsPAy = 'N'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vCouponNo 	= rsget("couponno")
		vItemID		= rsget("itemid")
		rsget.close
	Else
		rsget.close
		dbget.close()
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		Response.End
	End IF
	
	vQuery = "SELECT tot_sellcash From [db_order].[dbo].[tbl_mobile_gift_item] Where itemid = '" & vItemID & "' AND gubun = 'gifticon'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vSellCash = rsget("tot_sellcash")
	End IF
	rsget.close

	IF application("Svr_Info") = "Dev" THEN
		vMasterIdx = "219"
	Else
		vMasterIdx = "292"
	End If

	vNowDate		= Date()
	v60LaterDate	= DateAdd("d", 60, vNowDate) & " 23:59:59"
	
	vQuery = "INSERT INTO [db_user].[dbo].[tbl_user_coupon](masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, targetitemlist, startdate, expiredate, isusing, deleteyn, reguserid) "
	vQuery = vQuery & "VALUES('" & vMasterIdx & "', '" & vUserID & "', '2', '" & vSellCash & "', '기프티콘 교환쿠폰', '100', '', '" & vNowDate & "', '" & v60LaterDate & "', 'N', 'Y', 'system')"
	dbget.execute vQuery
	
	vQuery1 = " SELECT SCOPE_IDENTITY() "
	rsget.Open vQuery1,dbget
	IF Not rsget.EOF THEN
		vCouponIDX = rsget(0)
	END IF
	rsget.close
	'################################################################# [소켓 통신] #################################################################
		Dim oGicon, strData, vIsSuccess, vStatus
		vIsSuccess = "x"

		Set oGicon = New CGiftiCon
		strData = oGicon.reqCouponApproval(vCouponNO,"100100",10000) ''쿠폰번호, 추적번호, 상품 교환가
	    
		If (strData) Then
			vStatus = Trim(oGicon.FConResult.getResultCode)
		Else
			Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
			dbget.close()
			Response.End
		End If
		Set oGicon = Nothing
	
		If CStr(vStatus) = "0000" Then		'### 성공
			vIsSuccess = "o"
		Else
			vIsSuccess = "x"
		End If
	'################################################################# [소켓 통신] #################################################################
	
	If vIsSuccess = "o" Then
		vQuery = "UPDATE [db_user].[dbo].[tbl_user_coupon] SET deleteyn = 'N' WHERE idx = '" & vCouponIDX & "' " & vbCrLf
		vQuery = vQuery & "UPDATE [db_order].[dbo].[tbl_mobile_gift] SET IsPay = 'Y', couponidx = '" & vCouponIDX & "', userid = '" & vUserID & "', userlevel = '" & GetLoginUserLevel() & "' WHERE idx = '" & vIdx & "'"
		dbget.execute vQuery
	Else
		Response.write "<script language='javascript'>alert('기프티콘에 조회 중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
%>
<form name="frm" action="success_result.asp" method="post">
<input type="hidden" name="orderserial" value="0">
<input type="hidden" name="idx" value="<%=vIdx%>">
<input type="hidden" name="gubun" value="c">
<form>
<script language="javascript">
frm.submit();
</script>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->