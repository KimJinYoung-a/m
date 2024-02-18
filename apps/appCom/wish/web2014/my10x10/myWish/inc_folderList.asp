<%
	Set oDoc = new CAutoWish
		oDoc.FuserID  = vUserid
		oDoc.FFvUChk = isViewingChk
		oDoc.GetWishFolderList
		
	TotalCnt = oDoc.FResultCount

%>
<div class="inner10">
	<!-- 나의 위시 리스트(폴더) -->
	<ul class="myWishList wishFolderList">
		<li class="subTit">
			<h2>WISH<br />COLLECTION</h2>
			<p><a href="/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(vUserId))%>&vlg=wlist">전체 위시보기</a></p>
		</li>
		<% IF oDoc.FResultCount >0 then %>
			<%
			For i=0 To TotalCnt-1

			IF (i <= TotalCnt-1) Then

			%>
				<li>
					<a href="/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?fIdx=<%=oDoc.FWishPrdList(i).FFolderIdx%>&ucid=<%=Server.UrlEncode(tenEnc(vUserId))%>&vlg=wlist">
						<p class="folderInfo">
							<span class="folderName"><%=oDoc.FWishPrdList(i).FFolderName%></span>
							<% IF Trim(oDoc.FWishPrdList(i).FFolderName) = "마이 웨딩 위시" AND Now() < #04/21/2015 00:00:00# then %><em class="crMint fs11" style="display:block; margin-bottom:5px;">| 이벤트 진행 중 |</em><% end if %>
							<span><%=oDoc.FWishPrdList(i).FFolderitemcnt%></span>
						</p>
						<% If Trim(oDoc.FWishPrdList(i).FFBasicImage) = "" Or IsNull(oDoc.FWishPrdList(i).FFBasicImage) Then %>
							<img src="http://fiximage.10x10.co.kr/web2008/category/blank.gif" alt="" />
						<% Else %>
							<img src="<%=oDoc.FWishPrdList(i).FFimageList %>" alt="" />
						<% End If %>
					</a>
				</li>
			<% End IF %>
			<% Next %>
		<% end if %>
	<!-- //폴더 리스트 -->
</div>
<% If isViewingChk Then %>
	<div class="floatingBar">
		<div class="btnWrap myWishBtn">
			<div><span class="button btB1 btRed cWh1 wishEditBtn"><a href="">수정</a></span></div>
		</div>
	</div>
<% End If %>
<%
	Set oDoc = Nothing
%>
