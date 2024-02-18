<%
Dim cCa31comma, vCa31Directer, vCate31Img(5), vCate31Copy(5), fc31
SET cCa31comma = New CPlay
cCa31comma.FRectDIdx = vDIdx
cCa31comma.sbPlayCommaDetail
vCa31Directer = cCa31comma.FOneItem.Fdirecter
SET cCa31comma = Nothing

For fc31=1 To 5
	vCate31Img(fc31)	= fnPlayImageSelectSortNo(vImageList,vCate,"25","i","0",fc31)
	vCate31Copy(fc31)	= fnPlayImageSelectSortNo(vImageList,vCate,"25","c","0",fc31)
Next
%>
<article class="playDetailV16 comma">
	<div id="cover" class="hgroup cover" style="background-image:url(<%=fnPlayImageSelect(vImageList,vCate,"23","i")%>);">
		<div>
			<a href="list.asp?cate=talk" class="corner">TALK</a>
			<h2><%=vTitleStyle%></h2>
		</div>
	</div>
	<div class="cont">
		<div class="detail">
			<h3><%=vSubCopy%></h3>
			<div class="textarea">
				<%
				For fc31=1 To 5
					If vCate31Img(fc31) <> "" Then
				%>
					<div class="desc">
						<div class="figure"><img src="<%=vCate31Img(fc31)%>" alt="" /></div>
						<p><%=vCate31Copy(fc31)%></p>
					</div>
				<%
					End If
				Next
				%>
			</div>
			<!--<p class="author"><%=vCa31Directer%></p>//-->
		</div>
		<% If fnPlayImageSelect(vImageList,vCate,"26","i") <> "" Then %>
		<div class="bnr">
			<a href="<%=fnPlayImageSelect(vImageList,vCate,"26","l")%>" alt="" /><img src="<%=fnPlayImageSelect(vImageList,vCate,"26","i")%>" alt="" /></a>
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