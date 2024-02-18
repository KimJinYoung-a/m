<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  위시베스트
' History : 2018-06-28 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls_B.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'// disp 121 : 가구/수납 , 122 : 데코/조명 , 112 : 키친 , 120 : 패브릭/생활
%>
<div id="best" class="tab-content current">
	<h2 class="hidden">위시베스트</h2>
	<div class="swiper-container">
		<div class="cate-list"></div>
		<div class="swiper-wrapper">
			<%
				Dim gaparam
				Dim i, ii , catename , cateurl , disp , oaward , minPrice
				For ii = 0 To 3
				
				Select Case ii
					Case 0 
						catename = "가구/수납"
						cateurl  = "/list/best/wish_detail2020.asp?disp=121"
						disp	 = "121"
						minPrice = "20000"
						gaparam  = "&gaparam=living_wish_121_0"
					Case 1 
						catename = "데코/조명"
						cateurl  = "/list/best/wish_detail2020.asp?disp=122"
						disp	 = "122"
						minPrice = "10000"
						gaparam  = "&gaparam=living_wish_122_0"
					Case 2 
						catename = "키친"
						cateurl  = "/list/best/wish_detail2020.asp?disp=112"
						disp	 = "112"
						minPrice = "8000"
						gaparam  = "&gaparam=living_wish_112_0"
					Case 3 
						catename = "패브릭/생활"
						cateurl  = "/list/best/wish_detail2020.asp?disp=120"
						disp	 = "120"
						minPrice = "10000"
						gaparam  = "&gaparam=living_wish_120_0"
					Case Else
						catename = ""
						cateurl  = ""
						disp	 = ""
						minPrice = ""
				End Select 
			%>
			<div class="swiper-slide">
				<div class="items">
					<ul>
						<%
							set oaward = new SearchItemCls
							oaward.FListDiv 		= "bestlist"
							oaward.FRectSortMethod	= "ws"
							oaward.FRectSearchFlag 	= "n"
							oaward.FPageSize 		= 6
							oaward.FRectCateCode	= disp
							oaward.FCurrPage 		= 1
							oaward.FSellScope 		= "Y"
							oaward.FScrollCount 	= 1
							oaward.FminPrice		= minPrice
							oaward.getSearchList

							If oaward.FResultCount Then

							For i=0 To oaward.FResultCount-1
						%>
						<li>
							<% If isapp = "1" Then %>
							<a href="" onclick="fnAPPpopupProduct('<%=oaward.FItemList(i).FItemID%>');return false;">
							<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%=oaward.FItemList(i).FItemID %><%=gaparam & (i+1) %>">
							<% End If %>
								<div class="thumbnail"><img src="<%=getThumbImgFromURL(oaward.FItemList(i).FImageBasic,"200","200","true","false") %>" alt="<%=oaward.FItemList(i).FItemName %>"></div>
								<div class="desc">
									<div class="price">
										<%
											If oaward.FItemList(i).IsSaleItem AND oaward.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
												Response.Write "<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b> "
												If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
													If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
														Response.Write "<b class=""discount color-green""></b> "
													Else
														Response.Write "<b class=""discount color-green"">" & chkiif(InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") > 0,oaward.FItemList(i).GetCouponDiscountStr,"쿠폰") & "</b> "
													End If
												End If
												Response.Write "<span class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "원</span>"
											ElseIf oaward.FItemList(i).IsSaleItem AND (Not oaward.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
												Response.Write "<b class=""discount color-red"">" & oaward.FItemList(i).getSalePro & "</b> "
												Response.Write "<span class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & "원</span>"
											ElseIf oaward.FItemList(i).isCouponItem AND (NOT oaward.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
												If oaward.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
													If InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
														Response.Write "<b class=""discount color-green""></b> "
													Else
														Response.Write "<b class=""discount color-green"">" & chkiif(InStr(oaward.FItemList(i).GetCouponDiscountStr,"%") > 0,oaward.FItemList(i).GetCouponDiscountStr,"쿠폰") & "</b> "
													End If
												End If
												Response.Write "<span class=""sum"">" & FormatNumber(oaward.FItemList(i).GetCouponAssignPrice,0) & "원</span>"
											Else
												Response.Write "<span class=""sum"">" & FormatNumber(oaward.FItemList(i).getRealPrice,0) & CHKIIF(oaward.FItemList(i).IsMileShopitem," Point","원") & "</span>" &  vbCrLf
											End If
										%>
									</div>
								</div>
							</a>
						</li>
						<%
							Next 

							End If 
							Set oaward =  nothing
						%>
					</ul>
				</div>
				<div class="btn-group">
					<% If isapp = "1" Then %>
					<a href="" onclick="fnAPPpopupBrowserRenewal('push', '베스트위시', '<%=wwwUrl%>/apps/appcom/wish/web2014<%=cateurl%><%=gaparam%>0', 'best');return false;" class="btn-plus">
					<% Else %>
					<a href="<%=cateurl%><%=gaparam%>0" class="btn-plus">
					<% End If %>
					<span class="icon icon-plus icon-plus-black"></span> <%=catename%> 더보기</a>
				</div>
			</div>
			<%
				Next 
			%>
		</div>
	</div>
</div>
<script>
$(function(){
	/* new, hot, best */
	var ctgy = ['가구/수납', '데코/조명', '키친', '패브릭/생활']
	var itemSwiper = new Swiper(".ctgy-items #best .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		disableOnInteraction:false,
		pagination:'.ctgy-items #best .cate-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (ctgy[index]) + '</span>';
		}
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->