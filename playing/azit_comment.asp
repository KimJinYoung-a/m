<%
	Dim cCa3Co, i3, vCa3page, vCa3pagesize, vCa3ComCnt
	vCa3page	= getNumeric(requestCheckVar(Request("page"),10))
	vIsMine	= requestCheckVar(Request("ismine"),1)
	If vCa3page = "" Then
		vCa3page = "1"
	End If
	vCa3pagesize = 8
	
	Set cCa3Co = New CPlay
	cCa3Co.FRectDIdx = vDIdx
	cCa3Co.FCurrPage = vCa3page
	cCa3Co.FPageSize = vCa3pagesize
	cCa3Co.FRectTop	= vCa3page*vCa3pagesize
	cCa3Co.FRectIsMine = vIsMine
	cCa3Co.sbPlayAzitComment
	
	vCa3ComCnt = cCa3Co.FTotalCount
%>
<script>
function chkfrm3(f){
<% If IsUserLoginOK() Then %>
	if(f.comment1.value == ""){
		alert("추천 아지트를 입력해주세요!(20자 이내)");
		f.comment1.focus();
		return false;
	}
	if(f.comment2.value == ""){
		alert("추천 이유를 입력해주세요!(200자 이내)");
		f.comment2.focus();
		return false;
	}
	return true;
<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/playing/view.asp?didx="&vDIdx&"")%>');
		return false;
	<% end if %>
<% End If %>
}
</script>
<div class="summary">
	<div class="desc">
		<p class="msg">공유하고 싶은 아지트를 추천해주세요!<br / ><%=vCate3EntryCont%></p>
		<p class="date">응모기간 : <%=vCate3EntrySDate%> ~ <%=vCate3EntryEDate%> <span>|</span> 발표 : <%=vCate3AnnounDate%></p>
	</div>
	<div class="form">
		<div class="field">
			<form name="frm3" method="post" action="azit_proc.asp" onSubmit="return chkfrm3(this);">
			<input type="hidden" name="didx" value="<%=vDidx%>">
				<fieldset>
				<legend class="hidden">추천 아지트 작성 폼</legend>
					<div class="texarea">
						<input type="text" title="추천 아지트 입력" name="comment1" value="" maxlength="20" placeholder="추천 아지트 (20자 이내)" <%=CHKIIF(IsUserLoginOK(),"","onclick='chkfrm3(this)'")%> />
						<textarea cols="60" rows="5" title="추천 이유 입력" name="comment2" value="" maxlength="200" placeholder="추천 이유 (200자 이내)" <%=CHKIIF(IsUserLoginOK(),"","onclick='chkfrm3(this)'")%>></textarea>
						<input type="submit" value="추천하기" />
					</div>
				</fieldset>
			</form>
		</div>
	</div>
	<div id="noti" class="noti">
		<h3><a href="#noticontents"><span>유의사항</span></a></h3>
		<div id="noticontents" class="noticontents">
			<ul>
				<li>입력하신 블로그 주소는 개인정보 유출로 인한 피해를 막고자 비공개로 텐바이텐에 접수됩니다.</li>
				<li>통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</li>
			</ul>
			<button type="button" class="btnFold"><span>유의사항 접기</span></button>
		</div>
	</div>
</div>

<!-- comment list -->
<div class="listComment" id="licmt3">
	<h3 class="hidden">코멘트 목록</h3>
	<div class="option">
		<div class="total"><span>TOTAL</span> <%=vCa3ComCnt%></div>
		<% If IsUserLoginOK() Then %>
			<% If vIsMine = "o" Then %>
				<a href="view.asp?didx=<%=vDIdx%>&iscomm=o">전체 코멘트 보기</a>
			<% Else %>
				<a href="view.asp?didx=<%=vDIdx%>&ismine=o&iscomm=o">내 코멘트 보기</a>
			<% End If %>
		<% End If %>
	</div>
	<%
	If (cCa3Co.FResultCount < 1) Then
		Response.Write "<p class=""noData"">작성된 코멘트가 없습니다.</p>"
	Else
	%>
	<ul>
		<% For i3 = 0 To cCa3Co.FResultCount-1 %>
		<li>
			<div class="writer">
				<span class="id"><%=printUserId(cCa3Co.FItemList(i3).FCa3ComUserID,2,"*")%></span>
				<% If cCa3Co.FItemList(i3).FCa3ComUserID = getEncLoginUserID() Then %>
				&nbsp;<button type="button" class="btnDel" onClick="jsCa3ComDel('<%=cCa3Co.FItemList(i3).FCa3Idx%>');">삭제</button>
				<% End If %>
				<span class="date"><%=FormatDate(cCa3Co.FItemList(i3).FCa3ComRegdate,"0000.00.00")%></span>
			</div>
			<div class="textarea">
				<div><b><%=cCa3Co.FItemList(i3).Fcomment1%></b></div>
				<p><%=cCa3Co.FItemList(i3).Fcomment2%></p>
			</div>
		</li>
		<% Next %>
	</ul>
	<%	End If	%>
	<%= fnDisplayPaging_New(vCa3page,vCa3ComCnt,vCa3pagesize,4,"jsCa3Page") %>
</div>
<form name="frm3com" method="get" action="">
<input type="hidden" name="didx" value="<%=vDidx%>">
<input type="hidden" name="page" value="">
<input type="hidden" name="iscomm" value="o">
</form>
<form name="frm3comdel" method="post" action="azit_proc.asp">
<input type="hidden" name="action" value="delete">
<input type="hidden" name="didx" value="<%=vDidx%>">
<input type="hidden" name="idx" value="">
<input type="hidden" name="ismine" value="<%=vIsMine%>">
</form>