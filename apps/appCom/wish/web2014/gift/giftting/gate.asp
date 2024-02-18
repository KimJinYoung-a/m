<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->

<%
	Dim vCouponNO
	vCouponNO = requestCheckVar(request("pin_no"),15)
	If vCouponNO = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vCouponNO) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
%>
<form name="frm" action="index.asp" method="post">
<input type="hidden" name="pin_no" value="<%=vCouponNO%>">
<form>
<script language="javascript">
frm.submit();
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->