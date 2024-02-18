<%
Dim cCa6howhow, vCa6Directer, vCate6Img(4), vCate6Copy(4), fc6, vCa6VideoURL, vCa6BanSub, vCa6BanTitle, vCa6BanBtnTitle, vCa6BanBtnLink
SET cCa6howhow = New CPlay
cCa6howhow.FRectDIdx = vDIdx
cCa6howhow.sbPlayHowhowDetail

vCa6VideoURL		= cCa6howhow.FOneItem.Fvideourl
vCa6BanSub			= cCa6howhow.FOneItem.Fbannsub
vCa6BanTitle		= cCa6howhow.FOneItem.Fbanntitle
vCa6BanBtnTitle	= cCa6howhow.FOneItem.Fbannbtntitle
vCa6BanBtnLink		= cCa6howhow.FOneItem.Fbannbtnlink
SET cCa6howhow = Nothing

For fc6=1 To 4
	vCate6Img(fc6)	= fnPlayImageSelectSortNo(vImageList,vCate,"17","i","0",fc6)
	vCate6Copy(fc6)	= fnPlayImageSelectSortNo(vImageList,vCate,"17","c","0",fc6)
Next
%>
<article class="playDetailV16 howhow">
	<div class="hgroup">
		<div>
			<a href="list.asp?cate=inspi" class="corner">!NSPIRATION</a>
			<h2><%=vTitle%></h2>
		</div>
	</div>
	<div class="cont">
		<div class="detail">
			<% If vCa6VideoURL <> "" Then %>
			<div class="video">
				<iframe src="<%=vCa6VideoURL%>" frameborder="0" title="howhow video" allowfullscreen></iframe>
			</div>
			<% End If %>
			<h3><span style="background-color:#<%=vBGColor%>;"></span><%=vSubCopy%></h3>
			<div class="textarea">
				<%
				For fc6=1 To 4
					If vCate6Img(fc6) <> "" OR vCate6Copy(fc6) <> "" Then
				%>
					<div class="desc">
						<% If vCate6Img(fc6) <> "" Then %><div class="figure"><img src="<%=vCate6Img(fc6)%>" alt="" /></div><% End If %>
						<% If vCate6Copy(fc6) <> "" Then %><p><%=vCate6Copy(fc6)%></p><% End If %>
					</div>
				<%
					End If
				Next
				%>
			</div>
			<div class="summary" style="background-color:#<%=vBGColor%>;">
				<div class="desc">
					<h3><%=vCa6BanSub%></h3>
					<p class="msg"><%=vCa6BanTitle%></p>
					<div class="btnLink">
						<a href="<%=vCa6BanBtnLink%>" target="_blank"><span><%=vCa6BanBtnTitle%></span></a>
					</div>
				</div>
			</div>
		</div>
		<!-- #include file="./inc_sns.asp" -->
		<div class="listMore">
			<div class="more">
				<h2>다른 !NSPIRATION 보기</h2>
				<a href="list.asp?cate=inspi">more</a>
			</div>
			<!-- #include file="./inc_listmore.asp" -->
		</div>
	</div>
</article>