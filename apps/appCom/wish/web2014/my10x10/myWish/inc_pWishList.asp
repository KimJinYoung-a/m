
<%

Set oDoc = new CAutoWish
	oDoc.FPageSize 			= PageSize
	oDoc.FCurrPage 			= CurrPage
	oDoc.FuserID				= vUserId
	oDoc.FFolderIdx			= vtFIdx
	oDoc.FFvUChk				= isViewingChk
	oDoc.GetWishProfilePrdList
	
TotalCnt = oDoc.FResultCount

%>
<!-- 나의 위시 리스트(상품) -->
<form name="FrmpWishList" id="FrmpWishList" method="post">
<div class="inner10">
	<ul class="myWishList wishCollectList">
		<li class="subTit">
			<h2>WISH<br />COLLECTION</h2>
			<p><a href="/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(vUserId))%>&vlg=flist">폴더 리스트 보기</a></p>
		</li>
		<% If oDoc.FResultCount>0 Then %>
			<% For i=0 To oDoc.FResultCount-1 %>
				<li value="<%=oDoc.FWishPrdList(i).FRectItemId%>">
					<a href="" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oDoc.FWishPrdList(i).FRectItemId%>&gaparam=<%=CHKIIF(isViewingChk,"wishlist","wishlist_a")%>');return false;">
						<% If Trim(oDoc.FWishPrdList(i).FFBasicImage) = "" Or IsNull(oDoc.FWishPrdList(i).FFBasicImage) Then %>
							<img src="http://fiximage.10x10.co.kr/web2008/category/blank.gif" alt="" />
						<% Else %>
							<img src="<%=oDoc.FWishPrdList(i).FFimageList %>" alt="" />
						<% End If %>
					</a>
				</li>
			<% Next %>
		<% End If %>
	</ul>
</div>
</form>
<div class="paging tMar25">
	<%=fnDisplayPaging_New(oDoc.FcurrPage,oDoc.FtotalCount,oDoc.FPageSize,4,"goPage")%>
</div>
<% If isViewingChk Then %>
	<div class="floatingBar">
		<div class="btnWrap myWishBtn">
			<div><span class="button btB1 btRed cWh1 wishEditBtn" style="display:block;" id="md"><a href="" >수정</a></span></div>
			<!-- 수정 버튼 클릭시 변경	-->

			<% If viewListGubun="wlist" And vtFIdx="" Then %>
				<div class="w50p ftLt"><span class="button btB1 btRed cWh1 wishEditBtn"  id="de" style="display:none;"><a href="">삭제</a></span></div>
				<div class="w50p ftLt lPad05"><span class="button btB1 btGryBdr cGy1 wishEditBtn"  id="cn" style="display:none;"><a href="">취소</a></span></div>
			<% Else %>
				<div class="w30p ftLt"><span class="button btB1 btRed cWh1 wishEditBtn"  id="de" style="display:none;"><a href="">삭제</a></span></div>
				<div class="w40p ftLt lPad05"><span class="button btB1 btRedBdr cRd1 wishEditBtn"  id="mo" style="display:none;"><a href="">폴더이동</a></span></div>
				<div class="w30p ftLt lPad05"><span class="button btB1 btGryBdr cGy1 wishEditBtn"  id="cn" style="display:none;"><a href="">취소</a></span></div>
			<% End If %>
		</div>
	</div>
<% End If %>
<!-- //나의 위시 컬렉션 -->
<%
	Set oDoc = Nothing
%>