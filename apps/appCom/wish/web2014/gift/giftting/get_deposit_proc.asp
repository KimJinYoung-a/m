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

	'################################################################# [XML 통신] #################################################################
	Dim xmlHttp, postdata, strData, vntPostedData, vIsSuccess, vURL
	vIsSuccess = "x"
	IF application("Svr_Info") = "Dev" THEN
		vURL = "http://tcms.giftting.co.kr/outPinCheck.do"
	Else
		vURL = "http://admin.giftting.co.kr/outPinCheck.do"
	End If
	
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
	'####### couponidx = '1' 이 예치금교환(쿠폰교환이 없어져서 쿠폰idx 필드가 필요없게 되어 새로 만들자니 이것으로 대체 사용.
	If vIsSuccess = "o" Then
        vQuery = "INSERT INTO [db_user].[dbo].[tbl_depositlog] (userid, deposit, jukyocd, jukyo, deleteyn) "
        vQuery = vQuery & " VALUES('" & vUserID & "', " & CStr(vSellCash) & ", '210', '기프팅 예치금교환', 'N') " & vbCrLf
        vQuery = vQuery & "UPDATE [db_order].[dbo].[tbl_mobile_gift] SET IsPay = 'Y', couponidx = '1', userid = '" & vUserID & "', userlevel = '" & GetLoginUserLevel() & "' WHERE idx = '" & vIdx & "'"
        dbget.Execute vQuery

        Call updateUserDeposit(vUserID)
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
<%      
	function updateUserDeposit(byVal userid)
		dim sqlStr
		dim dataexist
	
		'==============================================================
		'예치금 재계산
		sqlStr = " update c " + vbCrlf
		sqlStr = sqlStr + " set " + vbCrlf
		sqlStr = sqlStr + " 	c.currentdeposit = T.gaindeposit - T.spenddeposit " + vbCrlf
		sqlStr = sqlStr + " 	, c.gaindeposit = T.gaindeposit " + vbCrlf
		sqlStr = sqlStr + " 	, c.spenddeposit = T.spenddeposit " + vbCrlf
		sqlStr = sqlStr + " from " + vbCrlf
		sqlStr = sqlStr + " 	db_user.dbo.tbl_user_current_deposit c " + vbCrlf
		sqlStr = sqlStr + " 	join ( " + vbCrlf
		sqlStr = sqlStr + " 		select " + vbCrlf
		sqlStr = sqlStr + " 			'" + userid + "' as userid " + vbCrlf
		sqlStr = sqlStr + " 			, IsNull(sum(case when deposit>0 then deposit else 0 end), 0) as gaindeposit " + vbCrlf
		sqlStr = sqlStr + " 			, IsNull(sum(case when deposit<0 then (deposit * -1) else 0 end), 0) as spenddeposit " + vbCrlf
		sqlStr = sqlStr + " 		from db_user.dbo.tbl_depositlog " + vbCrlf
		sqlStr = sqlStr + "     	where userid='" + userid + "'" + vbCrlf
		sqlStr = sqlStr + "     		and deleteyn='N' " + vbCrlf
		sqlStr = sqlStr + " 	) T " + vbCrlf
		sqlStr = sqlStr + " 	on " + vbCrlf
		sqlStr = sqlStr + " 		c.userid = T.userid " + vbCrlf
		'response.write sqlStr
	
		rsget.Open sqlStr,dbget
	
		sqlStr = " select @@rowcount as cnt "
		'response.write sqlStr
	
	    rsget.Open sqlStr,dbget,1
	        dataexist = (rsget("cnt") > 0)
	    rsget.Close
	
		'데이타가 없으면 생성한다.
		if (Not dataexist) then
	
			sqlStr = " if not exists (select * from db_user.dbo.tbl_user_current_deposit where userid = '" + userid + "') begin " + vbCrlf
			sqlStr = sqlStr + " 	insert into db_user.dbo.tbl_user_current_deposit(userid, currentdeposit, gaindeposit, spenddeposit) " + vbCrlf
			sqlStr = sqlStr + " 		select " + vbCrlf
			sqlStr = sqlStr + " 			'" + userid + "' " + vbCrlf
			sqlStr = sqlStr + " 			, IsNull(sum(deposit), 0) as currentdeposit " + vbCrlf
			sqlStr = sqlStr + " 			, IsNull(sum(case when deposit>0 then deposit else 0 end), 0) as gaindeposit " + vbCrlf
			sqlStr = sqlStr + " 			, IsNull(sum(case when deposit<0 then (deposit * -1) else 0 end), 0) as spenddeposit " + vbCrlf
			sqlStr = sqlStr + " 		from db_user.dbo.tbl_depositlog " + vbCrlf
			sqlStr = sqlStr + "     	where userid='" + userid + "'" + vbCrlf
			sqlStr = sqlStr + " end " + vbCrlf
	
			dbget.Execute sqlStr
		end if
	
	end function
%>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->