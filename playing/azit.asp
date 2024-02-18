<%
Dim cCa3azit, vCate3EntryCont, vCate3EntrySDate, vCate3EntryEDate, vCate3AnnounDate, vCate3Notice, vPlayAzitList, vCate3EntryMethod
Dim vCate3Ptitle(4), vCate3Pjuso(4), vCate3Plink(4), vCate3PImg(20), vCate3PCopy(20), fc3, p3, l3, tmp3
SET cCa3azit = New CPlay
cCa3azit.FRectDIdx = vDIdx
cCa3azit.sbPlayAzitDetail

tmp3 = 0
vCate3EntryCont		= cCa3azit.FOneItem.FCate3EntryCont
If cCa3azit.FOneItem.FCate3EntrySDate <> "" Then
	vCate3EntrySDate		= Right(FormatDate(cCa3azit.FOneItem.FCate3EntrySDate,"0000.00.00"),5)
End If
If cCa3azit.FOneItem.FCate3EntryEDate <> "" Then
	vCate3EntryEDate		= Right(FormatDate(cCa3azit.FOneItem.FCate3EntryEDate,"0000.00.00"),5)
End If
If cCa3azit.FOneItem.FCate3AnnounDate <> "" Then
	vCate3AnnounDate		= Right(FormatDate(cCa3azit.FOneItem.FCate3AnnounDate,"0000.00.00"),5)
End If
vCate3Notice			= cCa3azit.FOneItem.FCate3Notice
vCate3EntryMethod		= cCa3azit.FOneItem.FCate3EntryMethod
vPlayAzitList			= cCa3azit.FPlayAzipList

For p3=1 To 4
	vCate3Ptitle(p3)	= fnPlayAzitSelect(vPlayAzitList,p3,"1")
	vCate3Pjuso(p3)	= fnPlayAzitSelect(vPlayAzitList,p3,"2")
	vCate3Plink(p3)	= fnPlayAzitSelect(vPlayAzitList,p3,"3")
	
	For l3=1 To 5
		tmp3 = tmp3 + 1
		vCate3PImg(tmp3)		= fnPlayImageSelectSortNo(vImageList,vCate,"7","i",p3,l3)
		vCate3PCopy(tmp3)	= fnPlayImageSelectSortNo(vImageList,vCate,"7","c",p3,l3)
	Next
Next
SET cCa3azit = Nothing
%>
<article class="playDetailV16 azit">
	<div id="cover" class="hgroup cover" style="background-image:url(<%=fnPlayImageSelect(vImageList,vCate,"6","i")%>);">
		<div>
			<a href="list.asp?cate=talk" class="corner">TALK</a>
			<h2><%=vTitleStyle%></h2>
			<p><%=vSubCopy%></p>
		</div>
	</div>
	<div class="cont">
		<div class="detail">
			<%
			tmp3 = 0
			For p3=1 To 4
				If vCate3Ptitle(p3) <> "" Then
			%>
				<div id="placeRolling<%=p3%>" class="swiperCarousel">
					<h3><span>0<%=p3%></span><%=vCate3Ptitle(p3)%></h3>
					<div class="swiper-container">
						<div class="swiper-wrapper">
						<%
						For l3=1 To 5
							tmp3 = tmp3 + 1
						%>
							<% If l3 < 5 Then %>
							<div class="swiper-slide">
								<div class="figure"><img src="<%=vCate3PImg(tmp3)%>" alt="" /></div>
								<p class="textarea"><%=vCate3PCopy(tmp3)%></p>
							</div>
							<% End If %>
							<% If l3 = 5 Then %>
							<div class="swiper-slide">
								<div class="figure"><img src="<%=vCate3PImg(tmp3)%>" alt="" /></div>
								<p class="textarea">
									<% if isApp=1 then %>
									<a href="" title="새창" class="address" onClick="fnAPPpopupBrowserURL('AZIT&','<%=vCate3Plink(p3)%>'); return false;"><span><%=vCate3Pjuso(p3)%></span></a>
									<% Else %>
									<a href="<%=vCate3Plink(p3)%>" target="_blank" title="새창" class="address"><span><%=vCate3Pjuso(p3)%></span></a>
									<% End If %>
								</p>
							</div>
							<% End If %>
						<% Next %>
						</div>
						<div class="paginationDot"></div>
					</div>
				</div>
			<%
				End If
			Next
			%>
			
			<% If vCate3EntryMethod = "c" Then %>
				<!-- #include file="./azit_comment.asp" -->
			<% Else %>
			<div class="summary" style="background-color:#cac7bb;">
				<div class="desc">
					<p class="msg"><%=vCate3EntryCont%></p>
					<p class="date">응모기간 : <%=vCate3EntrySDate%> ~ <%=vCate3EntryEDate%> <span>|</span> 발표 : <%=vCate3AnnounDate%></p>
					<div class="btnLink">
						<a href="https://www.instagram.com/explore/tags/%ED%85%90%EB%B0%94%EC%9D%B4%ED%85%90%EC%95%84%EC%A7%80%ED%8A%B8%EC%97%94/" target="_blank"><span>AZIT&amp; 올리러 가기</span></a>
					</div>
				</div>
				<div id="noti" class="noti">
					<h3><a href="#noticontents"><span>유의사항</span></a></h3>
					<div id="noticontents" class="noticontents">
						<ul>
							<%=Replace(vCate3Notice,vbCrLf,"<br />")%>
						</ul>
						<button type="button" class="btnFold"><span>유의사항 접기</span></button>
					</div>
				</div>
			</div>
			<% End If %>
		</div>
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