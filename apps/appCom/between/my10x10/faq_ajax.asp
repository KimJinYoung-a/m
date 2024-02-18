<%@ language=vbscript %>
<% option Explicit %>
<%
Response.CharSet = "euc-kr"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Expires","0"
response.Charset="UTF-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<!-- #include virtual="/apps/appCom/between/lib/class/noticefaqCls.asp" -->
<%
	Dim cNotiFaq, vPage, i
	vPage = requestCheckVar(request("page"),3)
	
	SET cNotiFaq = New CNoticeFaq
	cNotiFaq.FCurrPage = vPage
	cNotiFaq.FPageSize = 10
	cNotiFaq.FRectGubun = 2
	cNotiFaq.getNoticeFaqList
%>
<script type="text/javascript">
$(function() {
	
	<% If CStr(cNotiFaq.FTotalPage) = CStr(vPage) Then %>
	$(".listAddBtn").hide();
	<% End If %>
});
</script>

<%
	If cNotiFaq.FResultCount > 0 Then
		For i = 0 To cNotiFaq.FResultCount-1
%>
		<li>
			<p class="noticeHead" id="faqH<%=cNotiFaq.FItemList(i).Fidx%>" onClick="jsViewFaq('<%=cNotiFaq.FItemList(i).Fidx%>');"><%=db2html(cNotiFaq.FItemList(i).Fsubject)%></p>
			<div class="noticeView" id="faqV<%=cNotiFaq.FItemList(i).Fidx%>"><%=Replace(db2html(cNotiFaq.FItemList(i).Fcontents),"&lt;","<")%></div>
		</li>
<%
		Next
	End If
%>
<% SET cNotiFaq = Nothing %>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->