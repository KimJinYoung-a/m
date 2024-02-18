<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->

<%
	Dim oshoppingbag, vQuery, vGubun, vIdx, vUserID, vGuestSeKey, vPacktype, vSpendmileage, vCouponmoney, vSpendtencash, vSpendgiftmoney, vSubtotalprice, vSailcoupon, vCheckitemcouponlist, vCountryCode, vTotCouponAssignPrice
	vUserID					= GetLoginUserID
	vGuestSeKey				= GetGuestSessionKey
	vGubun					= Request("gubun")
	vIdx					= Request("idx")
	vPacktype				= Request("packtype")
	vSpendmileage			= Request("spendmileage")
	vCouponmoney			= Request("couponmoney")
	vSpendtencash			= Request("spendtencash")
	vSpendgiftmoney			= Request("spendgiftmoney")
	vSubtotalprice			= Request("price")			'subtotalprice
	vSailcoupon				= Request("sailcoupon")
	vCheckitemcouponlist	= Request("checkitemcouponlist")
	If Right(vCheckitemcouponlist,1) = "," Then
		vCheckitemcouponlist = Left(vCheckitemcouponlist,Len(vCheckitemcouponlist)-1)
	End IF
	
	
	vCountryCode			= Request("countryCode")
	vTotCouponAssignPrice	= Request("totCouponAssignPrice")
	
	If vTotCouponAssignPrice = "" Then
	    set oshoppingbag = new CShoppingBag
	    oshoppingbag.FRectUserID = vUserID
	    oshoppingbag.FRectSessionID = vGuestSeKey
	    oShoppingBag.FRectSiteName  = "10x10"
	    oShoppingBag.FcountryCode = vCountryCode
	    
	    oshoppingbag.GetShoppingBagDataDB_Checked
	    
		vTotCouponAssignPrice = oshoppingbag.getTotalCouponAssignPrice(vPacktype)
		set oshoppingbag = Nothing
	End IF
	
	vQuery = "INSERT INTO [db_order].[dbo].[tbl_order_mobilecard_errReport]("
	vQuery = vQuery & " gubun, temp_idx, userid, guestSessionID, totCouponAssignPrice, spendmileage, couponmoney, spendtencash, spendgiftmoney, subtotalprice, sailcoupon, checkitemcouponlist) VALUES( "
	vQuery = vQuery & " '" & vGubun & "','" & vIdx & "','" & vUserID & "','" & vGuestSeKey & "','" & vTotCouponAssignPrice & "','" & vSpendmileage & "','" & vCouponmoney & "','" & vSpendtencash & "', "
	vQuery = vQuery & " '" & vSpendgiftmoney & "','" & vSubtotalprice & "','" & vSailcoupon & "','" & vCheckitemcouponlist & "') "
	dbget.execute vQuery
%>

</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->