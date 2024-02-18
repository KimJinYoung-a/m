<%
	Dim cCa42Co, i42, vCa42page, vCa42pagesize, vCa42EntCnt
	vCa42page	= getNumeric(requestCheckVar(Request("page"),10))
	vIsMine	= requestCheckVar(Request("ismine"),1)
	If vCa42page = "" Then
		vCa42page = "1"
	End If
	vCa42pagesize = 5
	
	Set cCa42Co = New CPlay
	cCa42Co.FRectDIdx = vDIdx
	cCa42Co.FCurrPage = vCa42page
	cCa42Co.FPageSize = vCa42pagesize
	cCa42Co.FRectTop	= vCa42page*vCa42pagesize
	cCa42Co.FRectIsMine = vIsMine
	cCa42Co.sbPlayThingThingComment
	
	vCa42EntCnt = cCa42Co.FTotalCount
%>
<div class="listComment" id="licmt42">
	<h3 class="hidden">코멘트 목록</h3>
	<div class="option">
		<div class="total"><span>TOTAL</span> <%=vCa42EntCnt%></div>
		<% If IsUserLoginOK() Then %>
			<% If vIsMine = "o" Then %>
				<a href="view.asp?didx=<%=vDIdx%>&iscomm=o">전체 코멘트 보기</a>
			<% Else %>
				<a href="view.asp?didx=<%=vDIdx%>&ismine=o&iscomm=o">내 코멘트 보기</a>
			<% End If %>
		<% End If %>
	</div>
	<%
	If (cCa42Co.FResultCount < 1) Then
		Response.Write "<ul><li class=""ct"">작성된 코멘트가 없습니다.</li></ul>"
	Else
	%>
	<ul>
		<% For i42 = 0 To cCa42Co.FResultCount-1 %>
		<li>
			<span>내이름은 <em style="color:#<%=vBGColor%>;"><%=cCa42Co.FItemList(i42).FCa42EntVal%></em>
			<% If cCa42Co.FItemList(i42).FCa42EntUserID = getEncLoginUserID() Then %>
			&nbsp;<button type="button" class="btnDel" onClick="jsCa42EntDel('<%=cCa42Co.FItemList(i42).FCa42Idx%>');">삭제</button>
			<% End If %>
			</span>
			<span class="id">By. <%=printUserId(cCa42Co.FItemList(i42).FCa42EntUserID,2,"*")%></span>
		</li>
		<% Next %>
	</ul>
	<%= fnDisplayPaging_New(vCa42page,vCa42EntCnt,vCa42pagesize,4,"jsCa42Page") %>
	<%	End If	%>
</div>
<form name="frm42ent" method="get" action="">
<input type="hidden" name="didx" value="<%=vDidx%>">
<input type="hidden" name="page" value="">
<input type="hidden" name="iscomm" value="o">
</form>
<form name="frm42entdel" method="post" action="thingthing_proc.asp">
<input type="hidden" name="action" value="delete">
<input type="hidden" name="didx" value="<%=vDidx%>">
<input type="hidden" name="idx" value="">
<input type="hidden" name="ismine" value="<%=vIsMine%>">
</form>
<% Set cCa42Co = Nothing %>