<script>
$(function(){
    $(".cont1 ul li:gt(3)").css('display','none');
    $(".cont2 ul li:gt(3)").css('display','none');
    $(".cont3 ul li:gt(3)").css('display','none');
    $(".cont4 ul li:gt(1)").css('display','none');
	// 더보기
	$('.btn-item-more').click(function(e) {
        var btnIdx = $(".btn-item-more").index($(this)) + 1;
        $(".cont"+ btnIdx +" ul li").slideDown()
		e.preventDefault();
	});
	//더 많은 상품보기- 버튼
	$('.btn-down').click(function(e){
		$(this).css({'display':'none'})
		return false;
	})	
})
</script>
<%
    dim bestList, soldList, cartList, popularEvtList
    dim couponPer, couponPrice, itemSalePer, tempPrice, saleStr, couponStr

    bestList = oExhibition.getItemsListProc( "B", 12, mastercode, "", "1", "1" )
    soldList = oExhibition.getItemsListProc( "C", 12, mastercode, "", "", "" )
    cartList = oExhibition.getItemsListProc( "B", 12, mastercode, "", "", "4" )
%>
		<section class="diary-rcmd" id="diaryNav1">
			<div class="diary-nav">
				<ul>
					<li class="on"><a href="#diaryNav1">추천 문구템</a></li>
					<li><a href="#diaryNav2">기획전</a></li>
					<li><a href="#diaryNav3">다이어리 찾기</a></li>
				</ul>
			</div>
			<!-- 추천다이어리 -->
			<div class="diary-list best">
				<!-- 추천다이어리 > 베스트셀러 -->
				<% if isArray(bestList) then %>
				<p>베스트셀러</p>
				<div class="items type-list cont1">
					<ul>
						<%
							for i = 0 to Ubound(bestList) - 1
								couponPer = oExhibition.GetCouponDiscountStr(bestList(i).Fitemcoupontype, bestList(i).Fitemcouponvalue)
								couponPrice = oExhibition.GetCouponDiscountPrice(bestList(i).Fitemcoupontype, bestList(i).Fitemcouponvalue, bestList(i).Fsellcash)
								itemSalePer     = CLng((bestList(i).Forgprice-bestList(i).Fsellcash)/bestList(i).FOrgPrice*100)
								if bestList(i).Fsailyn = "Y" and bestList(i).Fitemcouponyn = "Y" then '세일
									tempPrice = bestList(i).Fsellcash - couponPrice
									saleStr = "<b class=""discount sale"">"&itemSalePer&"%</b>"
									couponStr = "<b class=""discount coupon"">"&couponPer&"</b>"
								elseif bestList(i).Fitemcouponyn = "Y" then
									tempPrice = bestList(i).Fsellcash - couponPrice
									saleStr = ""
									couponStr = "<b class=""discount coupon"">"&couponPer&"</b>"
								elseif bestList(i).Fsailyn = "Y" then
									tempPrice = bestList(i).Fsellcash
									saleStr = "<b class=""discount sale"">"&itemSalePer&"%</b>"
									couponStr = ""
								else
									tempPrice = bestList(i).Fsellcash
									saleStr = ""
									couponStr = ""
								end if
						%>
						<li>		
						<%if isapp = 1 then%>
							<a href="javascript:TnGotoProduct('<%=bestList(i).Fitemid%>');">							
						<%else%>
							<a href="/category/category_itemPrd.asp?itemid=<%=bestList(i).Fitemid%>">
						<%end if%>				
								<div class="thumbnail">
									<img src="<%=bestList(i).FImageList%>" alt="" />
									<!-- dev for msg: 랭킹의 1~3위까지만 num-rolling 클래스가 더 붙습니다 4위부터는 num-rolling 빼주세요-->
									<div class="badge badge-count1 <%=chkIIF(i < 3, "num-rolling", "")%>">
										<em><%=i + 1%></em>
									</div>
								</div>
								<div class="desc">
									<div class="price-area">
										<span class="price"><%=formatNumber(tempPrice, 0)%></span>
										<% response.write saleStr%>
										<% response.write couponStr%>   
									</div>
									<p class="name"><%=bestList(i).Fitemname%></p>
									<span class="brand"><%=bestList(i).FbrandName%></span>
								</div>
							</a>
						</li>
						<% next %>
					</ul>
					<!-- for dev msg : 처음에는 상품4개 노출 되고 더보기 버튼 누른면 더보기버튼 없어지면서 총 12개 노출 -->
					<a href="" class="btn-down btn-item-more" style="display:<%=chkIIF(i > 4, "","none")%>">더 많은 상품보기</a>
				</div>
				<% end if %>
				<!-- 추천다이어리 > 방금 판매된 -->
				<% if isArray(soldList) then %>
				<p>방금 판매된</p>
				<div class="items type-list cont2">
					<ul>
						<% 
							for i = 0 to Ubound(soldList) - 1 
								couponPer = oExhibition.GetCouponDiscountStr(soldList(i).Fitemcoupontype, soldList(i).Fitemcouponvalue)
								couponPrice = oExhibition.GetCouponDiscountPrice(soldList(i).Fitemcoupontype, soldList(i).Fitemcouponvalue, soldList(i).Fsellcash)                    
								itemSalePer     = CLng((soldList(i).Forgprice-soldList(i).Fsellcash)/soldList(i).FOrgPrice*100)
								if soldList(i).Fsailyn = "Y" and soldList(i).Fitemcouponyn = "Y" then '세일
									tempPrice = soldList(i).Fsellcash - couponPrice
									saleStr = "<b class=""discount sale"">"&itemSalePer&"%</b>"
									couponStr = "<b class=""discount coupon"">"&couponPer&"</b>"  
								elseif soldList(i).Fitemcouponyn = "Y" then
									tempPrice = soldList(i).Fsellcash - couponPrice
									saleStr = ""
									couponStr = "<b class=""discount coupon"">"&couponPer&"</b>"  
								elseif soldList(i).Fsailyn = "Y" then
									tempPrice = soldList(i).Fsellcash
									saleStr = "<b class=""discount sale"">"&itemSalePer&"%</b>"
									couponStr = ""                                              
								else
									tempPrice = soldList(i).Fsellcash
									saleStr = ""
									couponStr = ""                                              
								end if                                        
						%>      					
						<li>
						<%if isapp = 1 then%>
							<a href="javascript:TnGotoProduct('<%=soldList(i).Fitemid%>');">							
						<%else%>
							<a href="/category/category_itemPrd.asp?itemid=<%=soldList(i).Fitemid%>">
						<%end if%>		
								<div class="thumbnail">
									<img src="<%=soldList(i).FImageList%>" alt="" />
									<div class="badge badge-count2">
										<em><%=soldList(i).FSellDate%></em>
									</div>
								</div>
								<div class="desc">
									<div class="price-area">
										<span class="price"><%=formatNumber(tempPrice, 0)%></span>
										<% response.write saleStr%>
										<% response.write couponStr%>   
									</div>
									<p class="name"><%=soldList(i).Fitemname%></p>
									<span class="brand"><%=soldList(i).FbrandName%></span>
								</div>
							</a>
						</li>
						<% next %>
					</ul>
					<!-- for dev msg : 처음에는 상품4개 노출 되고 더보기 버튼 누른면 더보기버튼 없어지면서 총 12개 노출 -->
					<a href="" class="btn-down btn-item-more" style="display:<%=chkIIF(i > 4, "","none")%>">더 많은 상품보기</a>
				</div>
				<% end if %>
				<!-- 추천다이어리 > 장바구니에 많이 담긴 -->
				<% if isArray(cartList) then %>
				<p>위시에 많이 담긴</p>
				<div class="items type-list cont3">
					<ul>
					<% 
						for i = 0 to Ubound(cartList) - 1 
							couponPer = oExhibition.GetCouponDiscountStr(cartList(i).Fitemcoupontype, cartList(i).Fitemcouponvalue)
							couponPrice = oExhibition.GetCouponDiscountPrice(cartList(i).Fitemcoupontype, cartList(i).Fitemcouponvalue, cartList(i).Fsellcash)                    
							itemSalePer     = CLng((cartList(i).Forgprice-cartList(i).Fsellcash)/cartList(i).FOrgPrice*100)
							if cartList(i).Fsailyn = "Y" and cartList(i).Fitemcouponyn = "Y" then '세일
								tempPrice = cartList(i).Fsellcash - couponPrice
								saleStr = "<b class=""discount sale"">"&itemSalePer&"%</b>"
								couponStr = "<b class=""discount coupon"">"&couponPer&"</b>"  
							elseif cartList(i).Fitemcouponyn = "Y" then
								tempPrice = cartList(i).Fsellcash - couponPrice
								saleStr = ""
								couponStr = "<b class=""discount coupon"">"&couponPer&"</b>"  
							elseif cartList(i).Fsailyn = "Y" then
								tempPrice = cartList(i).Fsellcash
								saleStr = "<b class=""discount sale"">"&itemSalePer&"%</b>"
								couponStr = ""                                              
							else
								tempPrice = cartList(i).Fsellcash
								saleStr = ""
								couponStr = ""                                              
							end if                                        
					%>					
						<li>				
						<%if isapp = 1 then%>
							<a href="javascript:TnGotoProduct('<%=cartList(i).Fitemid%>');">							
						<%else%>
							<a href="/category/category_itemPrd.asp?itemid=<%=cartList(i).Fitemid%>">
						<%end if%>		
								<div class="thumbnail">
									<img src="<%=cartList(i).FImageList%>" alt="" />
									<div class="badge badge-count2">
										<em><%=formatNumber(cartList(i).FfavCnt, 0)%>명</em>
									</div>
								</div>
								<div class="desc">
									<div class="price-area">
										<span class="price"><%=formatNumber(tempPrice, 0)%></span>
										<% response.write saleStr%>
										<% response.write couponStr%>   
									</div>
									<p class="name"><%=cartList(i).Fitemname%></p>
									<span class="brand"><%=cartList(i).FbrandName%></span>
								</div>
							</a>
						</li>
						<% next %>	
					</ul>
					<!-- for dev msg : 처음에는 상품4개 노출 되고 더보기 버튼 누른면 더보기버튼 없어지면서 총 12개 노출 -->
					<a href="" class="btn-down btn-item-more" style="display:<%=chkIIF(i > 4, "","none")%>">더 많은 상품보기</a>
				</div>
				<% end if %>
			</div>
		</section>