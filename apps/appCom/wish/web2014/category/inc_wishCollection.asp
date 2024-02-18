<%
'#######################################################
'	Description : 상품의 wish Collection
'	History	: 2014.01.29 허진원 생성
'			: 2014.09.17 허진원 2014 하반기 리뉴얼
'#######################################################
	dim oWishCol, tmpUid

	set oWishCol = new CWish
	if IsUserLoginOK then oWishCol.FRectUserID = GetLoginUserID
	oWishCol.FPageSize=6
	oWishCol.FRectLimitCnt=5	'표시 제한 (최소 5개 이상 보유 회원만 표시)
	oWishCol.getWishCollectFromItem()

	if oWishCol.FResultCount>0 then
		'초기 아이디 확인
		tmpUid = oWishCol.FItemList(0).Fuserid
%>
<h2 class="tit02 tMar30"><span>관련 위시폴더</span></h2>
<div class="relationWishFolder">
	<div class="swiper-container swiper3">
		<div class="swiper-wrapper">
			<ul class="relationWish swiper-slide">
				<li class="folderTit">
					<a href="" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(oWishCol.FItemList(0).Fuserid))%>');return false;">
						<p><%=printUserId(oWishCol.FItemList(0).Fuserid,2,"*")%></p>
						<p class="tPad05 fs11">위시 <%=oWishCol.FItemList(0).FfavCount%></p>
					</a>
				</li>
			<%
				for i=0 to (oWishCol.FResultCount-1)
			%>
				<li><a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oWishCol.FItemList(i).Fitemid%>"><img src="<%=getThumbImgFromURL(oWishCol.FItemList(i).FimageOrg,110,110,"true","false")%>" alt="<%=replace(oWishCol.FItemList(i).Fitemname,"""","")%>" /></a></li>
			<%
					'그룹 구분
					if i<(oWishCol.FResultCount-1) then
						if lcase(tmpUid)<>lcase(oWishCol.FItemList(i+1).Fuserid) then
							tmpUid=oWishCol.FItemList(i+1).Fuserid
			%>
			</ul>
			<ul class="relationWish swiper-slide">
				<li class="folderTit">
					<a href="" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(oWishCol.FItemList(i+1).Fuserid))%>');return false;">
						<p><%=printUserId(oWishCol.FItemList(i+1).Fuserid,2,"*")%></p>
						<p class="tPad05 fs11">위시 <%=oWishCol.FItemList(i+1).FfavCount%></p>
					</a>
				</li>
			<%
						end if
					end if
				next
			%>
			</ul>
		</div>
	</div>
	<div class="pagination"></div>
</div>
<%
	end if

	set oWishCol = Nothing
%>