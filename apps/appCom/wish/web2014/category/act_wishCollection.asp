<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbAppWishopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls2nd.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'#######################################################
'	Description : 상품의 wish Collection
'	History	: 2014.01.29 허진원 생성
'			: 2014.09.17 허진원 2014 하반기 리뉴얼
'			: 2015.07.01 허진원 2015 하반기 리뉴얼
'#######################################################
	dim oWishCol, tmpUid, itemid, i

	itemid = getNumeric(requestCheckVar(request("itemid"),9))
	if itemid="" then Response.End

	set oWishCol = new CWish
	if IsUserLoginOK then oWishCol.FRectUserID = GetLoginUserID
	oWishCol.FPageSize=6
	oWishCol.FRectLimitCnt=5	'표시 제한 (최소 5개 이상 보유 회원만 표시)
	oWishCol.getWishCollectFromItem()

	if oWishCol.FResultCount>0 then
		'초기 아이디 확인
		tmpUid = oWishCol.FItemList(0).Fuserid
%>
<div class="box1 tMar20 wishCollectPdt">
	<div class="swiper-container swiper2">
		<div class="swiper-wrapper">

			<div class="swiper-slide">
				<div class="titWrap">
					<div class="pvtImg"><a href="#" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(oWishCol.FItemList(0).Fuserid))%>');return false;"><img src="http://fiximage.10x10.co.kr/web2015/common/img_profile_<%=Num2Str(getDefaultProfileImgNo(oWishCol.FItemList(0).Fuserid),2,"0","R")%>.png" alt="프로필 이미지" /></a></div>
					<h2>WISH COLLECTION</h2>
					<span><%=printUserId(oWishCol.FItemList(0).Fuserid,2,"*")%></span>
				</div>
				<ul>
				<%
					for i=0 to (oWishCol.FResultCount-1)
				%>
					<li>
						<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=oWishCol.FItemList(i).Fitemid%>">
							<p><img src="<%=getStonThumbImgURL(oWishCol.FItemList(i).FimageOrg,200,200,"true","false")%>" alt="<%=replace(oWishCol.FItemList(i).Fitemname,"""","")%>" /></p>
						</a>
					</li>
				<%
						'그룹 구분
						if i<(oWishCol.FResultCount-1) then
							if lcase(tmpUid)<>lcase(oWishCol.FItemList(i+1).Fuserid) then
								tmpUid=oWishCol.FItemList(i+1).Fuserid
				%>
				</ul>
			</div>
			<div class="swiper-slide">
				<div class="titWrap">
					<div class="pvtImg"><a href="#" onclick="fnAPPpopupBrowserURL('위시 프로필','<%=wwwUrl%>/apps/appcom/wish/web2014/my10x10/myWish/myWish.asp?ucid=<%=Server.UrlEncode(tenEnc(oWishCol.FItemList(i+1).Fuserid))%>');return false;"><img src="http://fiximage.10x10.co.kr/web2015/common/img_profile_<%=Num2Str(getDefaultProfileImgNo(oWishCol.FItemList(i+1).Fuserid),2,"0","R")%>.png" alt="프로필 이미지" /></a></div>
					<h2>WISH COLLECTION</h2>
					<span><%=printUserId(oWishCol.FItemList(i+1).Fuserid,2,"*")%></span>
				</div>
				<ul>
				<%
							end if
						end if
					next
				%>
				</ul>
			</div>
		</div>
	</div>
	<div class="pagination"></div>
</div>
<script type="text/javascript">
$(function(){
	if($('.wishCollectPdt .swiper-wrapper > div').length>1) {
		setTimeout(function(){
			mySwiper3 = new Swiper('.swiper2',{
				pagination:'.wishCollectPdt .pagination',
				paginationClickable:true,
				loop:true,
				resizeReInit:true,
				calculateHeight:true
			});
		}, 500);
	}
});
</script>
<%
	end if

	set oWishCol = Nothing
%>
<!-- #include virtual="/lib/db/dbAppWishclose.asp" -->
