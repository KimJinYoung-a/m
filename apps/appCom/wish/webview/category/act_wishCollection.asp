<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbAppWishopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls2nd.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
'#######################################################
'	Description : 상품의 wish Collection
'	History	:  2014.01.29 허진원 생성
'#######################################################
	dim oWishCol, tmpUid, tmpLp, itemid, i

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
		tmpLp = 0
%>
<h4>Related Wish Collection</h4>
<div class="related-wish-collection">
    <ul class="bxslider">
        <li>
            <div class="wish-collection">
                <h1><%=printUserId(oWishCol.FItemList(0).Fuserid,2,"*")%>님의<br>Wish Collection</h1>
                <!--span class="cnt"><%=oWishCol.FItemList(0).FfavCount%></span-->
                <ul class="collection-images">
		<%
			for i=0 to (oWishCol.FResultCount-1)
		%>

                    <li onclick="location.href='./category_itemPrd.asp?itemid=<%=oWishCol.FItemList(i).Fitemid%>';return false;"><img src="<%=oWishCol.FItemList(i).FimageUrl%>" alt="<%=replace(oWishCol.FItemList(i).Fitemname,"""","")%>" /></li>
		<%
				'그룹 구분
				tmpLp = tmpLp+1
				if i<(oWishCol.FResultCount-1) then
					if lcase(tmpUid)<>lcase(oWishCol.FItemList(i+1).Fuserid) then
						tmpUid=oWishCol.FItemList(i+1).Fuserid
						do until tmpLp>=oWishCol.FPageSize
							response.Write "<li><img src=""http://fiximage.10x10.co.kr/images/spacer.gif""></li>"
							tmpLp = tmpLp+1
						loop
						
						tmpLp = 0
		%>
                </ul>
                <div class="clear"></div>
            </div>
        </li>
        <li>
            <div class="wish-collection">
                <h1><%=printUserId(oWishCol.FItemList(i+1).Fuserid,2,"*")%>님의<br>Wish Collection</h1>
                <!--span class="cnt"><%=oWishCol.FItemList(i+1).FfavCount%></span-->
                <ul class="collection-images">
		<%
					end if
				end if
			next

			do until tmpLp>=oWishCol.FPageSize
				response.Write "<li><img src=""http://fiximage.10x10.co.kr/images/spacer.gif""></li>"
				tmpLp = tmpLp+1
			loop
		%>
                </ul>
                <div class="clear"></div>
            </div>
        </li>
    </ul>
</div>
<script type="text/javascript">
$(function(){
	$('.related-wish-collection .bxslider').bxSlider({
	    slideWidth: 1000,
	    minSlides: 1,
	    maxSlides: 1,
	    moveSlides: 1,
	    slideMargin: 10,
	    controls: false,
	    infiniteLoop: false
	});
});
</script>
<%
	end if

	set oWishCol = Nothing
%>
<!-- #include virtual="/lib/db/dbAppWishclose.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->