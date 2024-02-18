<%
	Dim cCa1Co, i1, vCa1page, vCa1pagesize, vCa1ComCnt
	vCa1page	= getNumeric(requestCheckVar(Request("page"),10))
	vIsMine	= requestCheckVar(Request("ismine"),1)
	If vCa1page = "" Then
		vCa1page = "1"
	End If
	vCa1pagesize = 8
	
	Set cCa1Co = New CPlay
	cCa1Co.FRectDIdx = vDIdx
	cCa1Co.FCurrPage = vCa1page
	cCa1Co.FPageSize = vCa1pagesize
	cCa1Co.FRectTop	= vCa1page*vCa1pagesize
	cCa1Co.FRectIsMine = vIsMine
	cCa1Co.sbPlayPlaylistComment
	
	vCa1ComCnt = cCa1Co.FTotalCount
%>
<div class="listComment" id="licmt1">
	<h3 class="hidden">코멘트 목록</h3>
	<div class="option">
		<div class="total"><span>TOTAL</span> <%=vCa1ComCnt%></div>
		<% If IsUserLoginOK() Then %>
			<% If vIsMine = "o" Then %>
				<a href="view.asp?didx=<%=vDIdx%>&iscomm=o">전체 코멘트 보기</a>
			<% Else %>
				<a href="view.asp?didx=<%=vDIdx%>&ismine=o&iscomm=o">내 코멘트 보기</a>
			<% End If %>
		<% End If %>
	</div>
	<%
	If (cCa1Co.FResultCount < 1) Then
		Response.Write "<ul><li class=""ct"">작성된 코멘트가 없습니다.</li></ul>"
	Else
	%>
	<ul>
		<% For i1 = 0 To cCa1Co.FResultCount-1 %>
		<li>
			<div class="writer">
				<span class="id"><%=printUserId(cCa1Co.FItemList(i1).FCa1ComUserID,2,"*")%></span>
				<% If cCa1Co.FItemList(i1).FCa1ComUserID = getEncLoginUserID() Then %>
				&nbsp;<button type="button" class="btnDel" onClick="jsCa1ComDel('<%=cCa1Co.FItemList(i1).FCa1Idx%>');">삭제</button>
				<% End If %>
				<span class="date"><%=FormatDate(cCa1Co.FItemList(i1).FCa1ComRegdate,"0000.00.00")%></span>
			</div>
			<p>
				<span class="grouping"><span style="color:#<%=vBGColor%>;">#<%=cCa1Co.FItemList(i1).Fcomment1%></span> <%=vCa1Coment1%></span>
				<span class="grouping"><span style="color:#<%=vBGColor%>">#<%=cCa1Co.FItemList(i1).Fcomment2%></span> <%=vCa1Coment2%></span>
				<% If cCa1Co.FItemList(i1).Fcomment3 <> "" Then %>
				<span class="grouping"><span style="color:#<%=vBGColor%>">#<%=cCa1Co.FItemList(i1).Fcomment3%></span> <%=vCa1Coment3%></span>
				<% End If %>
			</p>
		</li>
		<% Next %>
	</ul>
	<%	End If	%>
	<%= fnDisplayPaging_New(vCa1page,vCa1ComCnt,vCa1pagesize,4,"jsCa1Page") %>
</div>
<form name="frm1com" method="get" action="">
<input type="hidden" name="didx" value="<%=vDidx%>">
<input type="hidden" name="page" value="">
<input type="hidden" name="iscomm" value="o">
</form>
<form name="frm1comdel" method="post" action="playlist_proc.asp">
<input type="hidden" name="action" value="delete">
<input type="hidden" name="didx" value="<%=vDidx%>">
<input type="hidden" name="idx" value="">
<input type="hidden" name="ismine" value="<%=vIsMine%>">
</form>
<% Set cCa1Co = Nothing %>