<%
Dim cCa1list, vCa1Directer, vCa1Type, vCa1VideoURL, vCa1ComTitle, vCa1Coment1, vCa1Coment2, vCa1Coment3, vCa1PreComm1, vCa1PreComm2, vCa1PreComm3
Dim vCate1VideoOrigin, vCate1RewardCopy
SET cCa1list = New CPlay
cCa1list.FRectDIdx = vDIdx
cCa1list.sbPlayPlaylistDetail

vCa1Directer 	= cCa1list.FOneItem.Fdirecter
vCa1Type		= cCa1list.FOneItem.Ftype
vCa1VideoURL	= cCa1list.FOneItem.Fvideourl
vCa1ComTitle	= cCa1list.FOneItem.Fcomm_title
vCa1Coment1	= cCa1list.FOneItem.Fcomment1
vCa1Coment2	= cCa1list.FOneItem.Fcomment2
vCa1Coment3	= cCa1list.FOneItem.Fcomment3
vCa1PreComm1	= cCa1list.FOneItem.FCate1precomm1
vCa1PreComm2	= cCa1list.FOneItem.FCate1precomm2
vCa1PreComm3	= cCa1list.FOneItem.FCate1precomm3
vCate1VideoOrigin = cCa1list.FOneItem.FCate1VideoOrigin
vCate1RewardCopy = cCa1list.FOneItem.FCate1RewardCopy
SET cCa1list = Nothing
%>
<article class="playDetailV16 playlist">
	<div class="hgroup">
		<div>
			<a href="list.asp?cate=talk" class="corner">TALK</a>
			<h2><%=vTitle%></h2>
		</div>
	</div>
	<div class="cont">
		<div class="detail">
			<% If vCa1Type = "1" Then %>
				<div class="video">
					<iframe src="<%=vCa1VideoURL%>" frameborder="0" title="playlist video" allowfullscreen></iframe>
				</div>
			<% ElseIf vCa1Type = "2" Then %>
				<div class="poster">
					<img src="<%=fnPlayImageSelect(vImageList,vCate,"2","i")%>" alt="" />
				</div>
			<% End If %>
			<% If vCate1VideoOrigin <> "" Then %><p class="copyright"><%=vCate1VideoOrigin%></p><% End If %>
			<div class="textarea">
				<p><%=vSubCopy%></p>
				<div class="by"><%=vCa1Directer%></div>
			</div>
			<div class="form">
				<div class="skewedBg" style="background-color:#<%=vBGColor%>;"></div>
				<div class="desc">
					<h3><%=vCa1ComTitle%></h3>
					<% If vCate1RewardCopy <> "" Then %>
						<p><%=vCate1RewardCopy%></p>
						<p class="date">응모기간 : <%=Right(FormatDate(vTagSDate,"0000.00.00"),5)%> ~ <%=Right(FormatDate(vTagEDate,"0000.00.00"),5)%>  |  발표 : <%=Right(FormatDate(vTagAnnounce,"0000.00.00"),5)%></p>
					<% End If %>
				</div>
				<div class="field">
					<form name="frm1" method="post" action="playlist_proc.asp" onSubmit="return chkfrm1(this);">
					<input type="hidden" name="didx" value="<%=vDidx%>">
						<fieldset>
						<legend class="hidden">추천 노래 작성 폼</legend>
							<div class="texarea">
								<div class="grouping">
									<span><i>#</i><input type="text" name="comment1" value="" maxlength="15" title="입력1" placeholder="<%=vCa1PreComm1%>" <%=CHKIIF(IsUserLoginOK(),"","onclick='chkfrm1(this)'")%> /></span>
									<span><%=vCa1Coment1%></span>
								</div>
								<div class="grouping">
									<span><i>#</i><input type="text" name="comment2" value="" maxlength="15" title="입력2" placeholder="<%=vCa1PreComm2%>" <%=CHKIIF(IsUserLoginOK(),"","onclick='chkfrm1(this)'")%> /></span>
									<span><%=vCa1Coment2%></span>
								</div>
								<% If vCa1Coment3 <> "" Then %>
								<div class="grouping">
									<span><i>#</i><input type="text" name="comment3" value="" maxlength="15" title="입력3" placeholder="<%=vCa1PreComm3%>" <%=CHKIIF(IsUserLoginOK(),"","onclick='chkfrm1(this)'")%> /></span>
									<span><%=vCa1Coment3%></span>
								</div>
								<% End If %>
							</div>
							<input type="submit" value="추천하기" />
						</fieldset>
					</form>
				</div>
			</div>
			<!-- #include file="./playlist_comment.asp" -->
		</div>
		<% If fnPlayImageSelect(vImageList,vCate,"18","i") <> "" Then %>
		<div class="bnr">
			<a href="" onClick="jsPlayingOpenLinkPopup('<%=fnPlayImageSelect(vImageList,vCate,"18","l")%>'); return false;" alt="" /><img src="<%=fnPlayImageSelect(vImageList,vCate,"18","i")%>" alt="" /></a>
		</div>
		<% End If %>
		<!-- #include file="./inc_sns.asp" -->
		<div class="listMore">
			<div class="more">
				<h2>다른 TALK 보기</h2>
				<a href="list.asp?cate=talk">more</a>
			</div>
			<!-- #include file="./inc_listmore.asp" -->
		</div>
	</div>
</article>
<script>
function chkfrm1(f){
<% If IsUserLoginOK() Then %>
	if(f.comment1.value == ""){
		alert("'#<%=vCa1PreComm1%>' (을)를 입력해주세요!");
		f.comment1.focus();
		return false;
	}
	if(f.comment2.value == ""){
		alert("'#<%=vCa1PreComm2%>' (을)를 입력해주세요!");
		f.comment2.focus();
		return false;
	}
	<% If vCa1Coment3 <> "" Then %>
	if(f.comment3.value == ""){
		alert("'#<%=vCa1PreComm3%>' (을)를 입력해주세요!");
		f.comment3.focus();
		return false;
	}
	<% End If %>
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