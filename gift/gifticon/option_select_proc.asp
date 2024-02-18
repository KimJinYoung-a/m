<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->

<%
	Dim vQuery, vIdx, vResult, vItemOption, vItemID, vOptionName, vRequireDetail
	vIdx 			= requestCheckVar(request("idx"),10)
	vItemID			= requestCheckVar(request("itemid"),10)
	vItemOption		= requestCheckVar(request("itemoption"),10)
	vRequireDetail	= Html2Db(Replace(LeftB(request("requiredetail"),512),"'",""))
	If vRequireDetail = "" Then
		vRequireDetail = "NULL"
	Else
		vRequireDetail = "'" & vRequireDetail & "'"
	End IF
	
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
	
	vQuery = "SELECT top 1 optionname From [db_item].[dbo].[tbl_item_option] Where itemid = '" & vItemID & "' and itemoption = '" & vItemOption & "'"
	rsget.Open vQuery,dbget
	IF Not rsget.EOF THEN
		vOptionName	= rsget("optionname")
	END IF
	rsget.close
	
	vQuery = "UPDATE [db_order].[dbo].[tbl_mobile_gift] SET itemoption = '" & vItemOption & "', optionname = '" & vOptionName & "', requiredetail = " & vRequireDetail & " Where idx = '" & vIdx & "'"
	dbget.Execute vQuery
%>

<form name="frm" action="<%=M_SSLUrl%>/gift/gifticon/userInfo.asp" method="post">
<input type="hidden" name="idx" value="<%=vIdx%>">
<input type="hidden" name="itemid" value="<%=vItemID%>">
<form>
<script language="javascript">
frm.submit();
</script>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->