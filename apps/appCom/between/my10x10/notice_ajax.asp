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
	cNotiFaq.FRectGubun = 1
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
			<p class="noticeHead" id="noticeH<%=cNotiFaq.FItemList(i).Fidx%>" onClick="jsViewNotice('<%=cNotiFaq.FItemList(i).Fidx%>');">
				<em><%=db2html(cNotiFaq.FItemList(i).Fsubject)%></em> <span class="date"><%=TwoNumber(DatePart("m",cNotiFaq.FItemList(i).Fregdate))%>/<%=TwoNumber(DatePart("d",cNotiFaq.FItemList(i).Fregdate))%></span>
				<%=Chkiif(DateDiff("d", Now, cNotiFaq.FItemList(i).Fregdate) >= 0 AND DateDiff("d", Now, cNotiFaq.FItemList(i).Fregdate) < 7,"<span class='newIco saleRed'>N<span>","") %>
			</p>
			<div class="noticeView" id="noticeV<%=cNotiFaq.FItemList(i).Fidx%>"><%=Replace(db2html(cNotiFaq.FItemList(i).Fcontents),"&lt;","<")%></div>
		</li>
<%
		Next
	End If
%>
<% SET cNotiFaq = Nothing %>
<!-- #include virtual="/lib/db/dbCTclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->