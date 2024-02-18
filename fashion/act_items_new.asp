<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description :  신상품
' History : 2018-04-23 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'// disp 117 : 패션의류 , 116 : 패션잡화 , 125 : 주얼리/시계 , 118 : 뷰티
%>
<div id="new" class="tab-content current">
	<h2 class="hidden">신상품</h2>
	<div class="swiper-container">
		<div class="cate-list"></div>
		<div class="swiper-wrapper">
			<%
				Dim gaparam
				Dim i, ii , catename , cateurl , disp , minPrice
				For ii = 0 To 3
				
				Select Case ii
					Case 0 
						catename = "패션의류"
						cateurl  = "/shoppingtoday/shoppingchance_newitem.asp?srm=be&disp=117"
						disp = "117"
						gaparam  = "&gaparam=fashion_new_117_0"
						minPrice = "15000"
					Case 1 
						catename = "패션잡화"
						cateurl  = "/shoppingtoday/shoppingchance_newitem.asp?srm=be&disp=116"
						disp = "116"
						gaparam  = "&gaparam=fashion_new_116_0"
						minPrice = "10000"
					Case 2 
						catename = "주얼리/시계"
						cateurl  = "/shoppingtoday/shoppingchance_newitem.asp?srm=be&disp=125"
						disp = "125"
						gaparam  = "&gaparam=fashion_new_125_0"
						minPrice = "10000"
					Case 3 
						catename = "뷰티"
						cateurl  = "/shoppingtoday/shoppingchance_newitem.asp?srm=be&disp=118"
						disp = "118"
						gaparam  = "&gaparam=fashion_new_118_0"
						minPrice = "10000"
					Case Else
						catename = ""
						cateurl  = ""
				End Select 

			%>
			<div class="swiper-slide">
				<div class="items">
					<ul>
						<%
							dim oDoc,iLp, vWishArr
							set oDoc = new SearchItemCls
								oDoc.FListDiv 			= "newlist"
								oDoc.FRectSortMethod	= "be"
								oDoc.FRectSearchFlag 	= "newlist"
								oDoc.FPageSize 			= 6
								oDoc.FRectCateCode		= disp
								oDoc.FCurrPage 			= 1
								oDoc.FSellScope 		= "Y"
								oDoc.FScrollCount 		= 1
								oDoc.FminPrice			= minPrice
								oDoc.getSearchList

							IF oDoc.FResultCount >0 Then

							For i=0 To oDoc.FResultCount-1

						%>
						<li>
							<% If isapp = "1" Then %>
							<a href="" onclick="fnAPPpopupProduct('<%=oDoc.FItemList(i).FItemID%>');return false;">
							<% Else %>
							<a href="/category/category_itemPrd.asp?itemid=<%= oDoc.FItemList(i).FItemID %>&disp=<%= oDoc.FItemList(i).FCateCode %><%=gaparam & (i+1) %>">
							<% End If %>
								<div class="thumbnail"><img src="<%= getThumbImgFromURL(oDoc.FItemList(i).FImageBasic,200,200,"true","false") %>" alt="<% = oDoc.FItemList(i).FItemName %>"></div>
								<div class="desc">
									<div class="price">
										<%
											If oDoc.FItemList(i).IsSaleItem AND oDoc.FItemList(i).isCouponItem Then	'### 쿠폰 O 세일 O
												Response.Write "<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b> "
												If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
													If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
														Response.Write "<b class=""discount color-green""></b> "
													Else
														Response.Write "<b class=""discount color-green"">" & chkiif(InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") > 0, oDoc.FItemList(i).GetCouponDiscountStr ,"쿠폰") & "</b> "
													End If
												End If
												Response.Write "<span class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "원</span>"
											ElseIf oDoc.FItemList(i).IsSaleItem AND (Not oDoc.FItemList(i).isCouponItem) Then	'### 쿠폰 X 세일 O
												Response.Write "<b class=""discount color-red"">" & oDoc.FItemList(i).getSalePro & "</b> "
												Response.Write "<span class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & "원</span>"
											ElseIf oDoc.FItemList(i).isCouponItem AND (NOT oDoc.FItemList(i).IsSaleItem) Then	'### 쿠폰 O 세일 X
												If oDoc.FItemList(i).Fitemcoupontype <> "3" Then	'### 무료배송아닌것
													If InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") < 1 Then	'### 금액 쿠폰은 쿠폰으로 표시
														Response.Write "<b class=""discount color-green""></b> "
													Else
														Response.Write "<b class=""discount color-green"">" & chkiif(InStr(oDoc.FItemList(i).GetCouponDiscountStr,"%") > 0, oDoc.FItemList(i).GetCouponDiscountStr ,"쿠폰") & "</b> "
													End If
												End If
												Response.Write "<span class=""sum"">" & FormatNumber(oDoc.FItemList(i).GetCouponAssignPrice,0) & "원</span>"
											Else
												Response.Write "<span class=""sum"">" & FormatNumber(oDoc.FItemList(i).getRealPrice,0) & CHKIIF(oDoc.FItemList(i).IsMileShopitem," Point","원") & "</span>" &  vbCrLf
											End If
										%>
									</div>
								</div>
							</a>
						</li>
						<%
							Next 

							End If 
							Set oDoc =  nothing
						%>
						
					</ul>
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
	var ctgy = ['패션의류', '패션잡화', '주얼리/시계', '뷰티']
	var itemSwiper = new Swiper(".fashion-items #new .swiper-container", {
		loop:true,
		autoplay:3000,
		speed:300,
		effect:'fade',
		disableOnInteraction:false,
		pagination:'.fashion-items #new .cate-list',
		paginationClickable:true,
		paginationBulletRender: function (index, className) {
			return '<span class="' + className + '">' + (ctgy[index]) + '</span>';
		}
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->