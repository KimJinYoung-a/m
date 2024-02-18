<%
Dim cCa5comma, vCa5Directer, vCate5Img(5), vCate5Copy(5), fc5
SET cCa5comma = New CPlay
cCa5comma.FRectDIdx = vDIdx
cCa5comma.sbPlayCommaDetail
vCa5Directer = cCa5comma.FOneItem.Fdirecter
SET cCa5comma = Nothing

For fc5=1 To 5
	vCate5Img(fc5)	= fnPlayImageSelectSortNo(vImageList,vCate,"14","i","0",fc5)
	vCate5Copy(fc5)	= fnPlayImageSelectSortNo(vImageList,vCate,"14","c","0",fc5)
Next
%>
<article class="playDetailV16 comma">
	<div id="cover" class="hgroup cover" style="background-image:url(<%=fnPlayImageSelect(vImageList,vCate,"13","i")%>);">
		<div>
			<a href="list.asp?cate=inspi" class="corner">!NSPIRATION</a>
			<h2><%=vTitleStyle%></h2>
		</div>
	</div>
	<div class="cont">
		<div class="detail">
			<h3><%=vSubCopy%></h3>
			<div class="textarea">
				<%
				For fc5=1 To 5
					If vCate5Img(fc5) <> "" Then
				%>
					<div class="desc">
						<div class="figure"><img src="<%=vCate5Img(fc5)%>" alt="" /></div>
						<p><%=vCate5Copy(fc5)%></p>
					</div>
				<%
					End If
				Next
				%>
			</div>
			<!--<p class="author"><%=vCa5Directer%></p>//-->
		</div>
		<% If fnPlayImageSelect(vImageList,vCate,"16","i") <> "" Then %>
		<div class="bnr">
			<a href="" onClick="jsPlayingOpenLinkPopup('<%=fnPlayImageSelect(vImageList,vCate,"16","l")%>'); return false;" alt="" /><img src="<%=fnPlayImageSelect(vImageList,vCate,"16","i")%>" alt="" /></a>
		</div>
		<% End If %>
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