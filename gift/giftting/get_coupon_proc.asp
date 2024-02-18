<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->

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
	
	vQuery = "SELECT tot_sellcash From [db_order].[dbo].[tbl_mobile_gift_item] Where itemid = '" & vItemID & "' AND gubun = 'giftting'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vSellCash = rsget("tot_sellcash")
	End IF
	rsget.close

	IF application("Svr_Info") = "Dev" THEN
		vMasterIdx = "218"
	Else
		vMasterIdx = "288"
	End If

	vNowDate		= Date()
	v60LaterDate	= DateAdd("d", 60, vNowDate) & " 23:59:59"
	
	vQuery = "INSERT INTO [db_user].[dbo].[tbl_user_coupon](masteridx, userid, coupontype, couponvalue, couponname, minbuyprice, targetitemlist, startdate, expiredate, isusing, deleteyn, reguserid) "
	vQuery = vQuery & "VALUES('" & vMasterIdx & "', '" & vUserID & "', '2', '" & vSellCash & "', '기프팅 교환쿠폰', '100', '', '" & vNowDate & "', '" & v60LaterDate & "', 'N', 'Y', 'system')"
	dbget.execute vQuery
	
	vQuery1 = " SELECT SCOPE_IDENTITY() "
	rsget.Open vQuery1,dbget
	IF Not rsget.EOF THEN
		vCouponIDX = rsget(0)
	END IF
	rsget.close
	'################################################################# [XML 통신] #################################################################
	Dim xmlHttp, postdata, strData, vntPostedData, vIsSuccess, vURL
	vIsSuccess = "x"
	vURL = "http://admin.giftting.co.kr/outPinCheck.do"
	'vURL = "http://tcms.giftting.co.kr/outPinCheck.do"
	
	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")

	postdata = "mdcode=10x10&pin_status=C&pin_no=" & vCouponNO & "&trd_dt=" & Replace(date(),"-","") & "&trd_tm=" & TwoNumber(hour(now))&TwoNumber(minute(now))&TwoNumber(second(now)) & "" '보낼 데이터 <!-- //-->

	xmlHttp.open "POST",vURL, False
    xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.Send postdata	'post data send

	IF Err.Number <> 0 then
		Response.write "<script language='javascript'>alert('기프팅에 조회 중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If

	vntPostedData = BinaryToText(xmlHttp.responseBody, "euc-kr")
	
	strData = vntPostedData

	Set xmlHttp = nothing
	
	If CStr(Right(Split(strData,"|")(0),2)) = "00" Then		'### Split(strData,"|")(0) 맨 앞에 빈값도 아닌 빈값이 같이 나와서 Right로 2자 자름.
		vIsSuccess = "o"
	Else
		vIsSuccess = "x"
	End If
	'################################################################# [XML 통신] #################################################################
	
	If vIsSuccess = "o" Then
		vQuery = "UPDATE [db_user].[dbo].[tbl_user_coupon] SET deleteyn = 'N' WHERE idx = '" & vCouponIDX & "' " & vbCrLf
		vQuery = vQuery & "UPDATE [db_order].[dbo].[tbl_mobile_gift] SET IsPay = 'Y', couponidx = '" & vCouponIDX & "', userid = '" & vUserID & "', userlevel = '" & GetLoginUserLevel() & "' WHERE idx = '" & vIdx & "'"
		dbget.execute vQuery
	Else
		Response.write "<script language='javascript'>alert('기프팅에 조회 중 오류가 발생하였습니다. 고객센터로 문의해 주세요.');document.location.href = '/';</script>"
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