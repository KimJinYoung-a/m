<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  크리스마스 기획전
' History : 2018-11-12 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->

<%
dim vGaparam, gnbflag
dim strGaParam, strGnbStr
Dim oExhibition 
dim mastercode,  detailcode, bestItemList, eventList, detailGroupList, listType
dim i, y
'10 : 조명
'20 : 트리/리스
'30 : 오너먼트
'40 : 캔들/디퓨저
'50 : 선물
'60 : 카드
vGaparam = request("gaparam")
if vGaparam <> "" then strGaParam = "&gaparam=" & vGaparam
if gnbflag <> "" then strGnbStr = "&gnbflag=1"

gnbflag = RequestCheckVar(request("gnbflag"),1)

mastercode =  1
listType = "A"

SET oExhibition = new ExhibitionCls

    bestItemList = oExhibition.getItemsListProc( listType, 10, mastercode, "", "1", "" )     '리스트타입, row개수, 마스터코드, 디테일코드, best아이템 구분, 카테고리 정렬 구분 
	eventList = oExhibition.getEventListProc( listType, 10, mastercode, 0 )     '리스트타입, row개수, 마스터코드, 디테일코드
	detailGroupList = oExhibition.getDetailGroupList("1")		

function format(ByVal szString, ByVal Expression)
	if len(szString) < len(Expression) then
	format = left(expression, len(szString)) & szString
	else
	format = szString
	end if
end function
%>
<script type="text/javascript">
$(function() {
	/* event banner */
	var mainSwiper = new Swiper("#xmas-swiper .swiper-container", {
		pagination:"#xmas-swiper .pagination-dot",
		paginationClickable:true,
		//autoplay:3000,
		loop:true,
		speed:600
	});

	$(".elmore").css("display","none");

    $('.btn-block').click(function(e){
		var idx = e.target.value;
		$(".detailElm"+idx).css("display", "");
		$(this).hide();        
    });	
});
</script>
	<div id="content" class="content xmas2018 xmas-pick">
		<h2><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/tit_xmas.gif" alt="Christmas Record - 찰칵, 당신의 크리스마스를 담아요" /></h2>
		<div class="xmas-tab">
			<img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/tab_xmas_02.jpg" alt="추천 상품 " />
			<span class="txt-pick"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt-pick.png" alt="PICK" /></span>
			<ul>
				<li><a href="./index.asp?link=1&gnbflag=1<%=strGaParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_tab','tabname','한컷크리스마스');">한 컷 크리스마스</a></li>
				<li class="on"><a href="./index.asp?link=2&gnbflag=1<%=strGaParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_tab','tabname','추천상품');">추천 상품</a></li>
			</ul>
		</div>
		<!-- 기획전 롤링 -->
		<% if isArray(eventList) then %>
		<div id="xmas-swiper" class="xmas-swiper list-card type-align-left">
			<div class="swiper-container">
				<div class="swiper-wrapper">
				<%'기획전 롤링%>
				<% if Ubound(eventList) > 0 then %>
				<% 
					for i = 0 to Ubound(eventList) - 1 
					if eventList(i).Fsquareimage = "" then
					else						
				%>
					<div class="swiper-slide">
					<% if isapp = 1 then %>						
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2018christmas_event','idx|eventcode','<%=i+1%>|<%=eventList(i).Fevt_code%>'
						, function(bool){if(bool) {fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=eventList(i).Fevt_code%>');return false;}});" >						
					<% else %>
						<a href="/event/eventmain.asp?eventid=<%=eventList(i).Fevt_code%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_event','idx|eventcode','<%=i+1%>|<%=eventList(i).Fevt_code%>')">						
					<% end if %>					
							<div class="thumbnail"><img src="<%=eventList(i).Fsquareimage%>" alt=""></div>
							<p class="desc">
								<b class="headline">
									<span class="ellipsis"><%=cStr(Split(eventList(i).Fevt_name,"|")(0))%></span>									
									<%=chkIIF(eventList(i).Fsaleper <> "", "<b class=""discount"">~"&eventList(i).Fsaleper&"%</b>","") %>									
								</b>
								<span class="subcopy">									
									<!--<%=chkIIF(eventList(i).Fsalecper <> "", "<span class=""label-color"">쿠폰 ~"&eventList(i).Fsalecper&"%</span>","") %>-->
									<%=eventList(i).Fevt_subcopy%>
								</span>
							</p>
						</a>
					</div>							
					<% 
					end if		
					next 							
					%>	
				<% end if %>
				<%'기획전 롤링%>	
				</div>
				<div class="pagination-dot block-dot"></div>
			</div>
		</div>
		<% end if %>

		<!-- 크리스마스 베스트 -->
		<section class="xmas-best">
			<h3><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/tit_best_10.png" alt="Best10 크리스마스 베스트셀러" /></h3>
			<div class="items type-grid">
				<ul>				
                <% if Ubound(bestItemList) > 0 then %>
                <%  
                    dim tempNumber, couponPrice, couponPer, tempPrice, salePer
                    dim saleStr, couponStr
                    
                    for i = 0 to Ubound(bestItemList) - 1 
                    tempNumber = format(i+1, "00")    
                    couponPer = oExhibition.GetCouponDiscountStr(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue)
                    couponPrice = oExhibition.GetCouponDiscountPrice(bestItemList(i).Fitemcoupontype, bestItemList(i).Fitemcouponvalue, bestItemList(i).Fsellcash)                    
                    salePer     = CLng((bestItemList(i).Forgprice-bestItemList(i).Fsellcash)/bestItemList(i).FOrgPrice*100)
                    if bestItemList(i).Fsailyn = "Y" and bestItemList(i).Fitemcouponyn = "Y" then '세일
                        tempPrice = bestItemList(i).Fsellcash - couponPrice
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif bestItemList(i).Fitemcouponyn = "Y" then
                        tempPrice = bestItemList(i).Fsellcash - couponPrice
                        saleStr = ""
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif bestItemList(i).Fsailyn = "Y" then
                        tempPrice = bestItemList(i).Fsellcash
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = ""                                              
                    else
                        tempPrice = bestItemList(i).Fsellcash
                        saleStr = ""
                        couponStr = ""                                              
                    end if
                %>
					<li>
                        <% if isapp = 1 then %>    
						<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2018christmas_best_item','index|itemid','<%=i+1%>|<%=bestItemList(i).Fitemid%>'
						, function(bool){if(bool) {fnAPPpopupProduct('<%=bestItemList(i).Fitemid%>');return false;}});" >	
                        <% else %>
                        <a href="/category/category_itemPrd.asp?itemid=<%=bestItemList(i).Fitemid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_best_item','index|itemid','<%=i+1%>|<%=bestItemList(i).Fitemid%>')">
                        <% end if %>						
							<div class="thumbnail">
								<img src="<%=bestItemList(i).FImageList%>" alt="" />
                                <% if bestItemList(i).FsellYn = "N" then %>
                                <b class="soldout">일시 품절</b>
                                <% end if %>								
								<em><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/txt_best_<%=tempNumber%>.png" alt="<%=i+1%>" /></em>
							</div>                               
                            <!--가격-->
							<div class="desc">
								<p class="name"><%=bestItemList(i).Fitemname%></p>
								<div class="price">
									<div class="unit">
                                        <b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b>
                                        <% response.write saleStr%>
                                        <% response.write couponStr%>
                                    </div>
								</div>
							</div>
                            <!--가격-->                            
						</a>
					</li>
                <% next %>                    
                <% end if %>
				</ul>
			</div>
		</section>

		<%'<!-- 크리스마스 카테고리 상품-->		%>		
		<% if Ubound(detailGroupList) > 0 then %>		
			<% 
			dim tmpItemList
			for i = 0 to Ubound(detailGroupList) - 1 
			tmpItemList = oExhibition.getItemsListProc( listType, 12, mastercode, detailGroupList(i).Fdetailcode, "", "")'리스트타입, 아이템수, 마스터코드, 디테일코드, 픽아이템, 카테고리sort
			%>
		<section class="category-item">
			<h3><b><%=detailGroupList(i).Ftitle%></b></h3>
			<div class="items type-grid">
			<%'카테고리 상품%>
				<ul>
					<% if Ubound(tmpItemList) > 0 then %>					
                <%                      
                    for y = 0 to Ubound(tmpItemList) - 1                     
                    couponPer = oExhibition.GetCouponDiscountStr(tmpItemList(y).Fitemcoupontype, tmpItemList(y).Fitemcouponvalue)
                    couponPrice = oExhibition.GetCouponDiscountPrice(tmpItemList(y).Fitemcoupontype, tmpItemList(y).Fitemcouponvalue, tmpItemList(y).Fsellcash)                    
                    salePer     = CLng((tmpItemList(y).Forgprice-tmpItemList(y).Fsellcash)/tmpItemList(y).FOrgPrice*100)
                    if tmpItemList(y).Fsailyn = "Y" and tmpItemList(y).Fitemcouponyn = "Y" then '세일
                        tempPrice = tmpItemList(y).Fsellcash - couponPrice
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif tmpItemList(y).Fitemcouponyn = "Y" then
                        tempPrice = tmpItemList(y).Fsellcash - couponPrice
                        saleStr = ""
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif tmpItemList(y).Fsailyn = "Y" then
                        tempPrice = tmpItemList(y).Fsellcash
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = ""                                              
                    else
                        tempPrice = tmpItemList(y).Fsellcash
                        saleStr = ""
                        couponStr = ""                                              
                    end if
                %>
					<li <%=chkIIF(y > 5, "class='elmore detailElm"&detailGroupList(i).Fdetailcode&"'", "")%>>
                        <% if isapp = 1 then %>             
							<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2018christmas_item','itemid|category_name','<%=tmpItemList(y).Fitemid%>|<%=detailGroupList(i).Ftitle%>'
							, function(bool){if(bool) {fnAPPpopupProduct('<%=tmpItemList(y).Fitemid%>');return false;}});" >							                                  	 	
                        <% else %>
                        	<a href="/category/category_itemPrd.asp?itemid=<%=tmpItemList(y).Fitemid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_item','itemid|category_name','<%=tmpItemList(y).Fitemid%>|<%=detailGroupList(i).Ftitle%>')">
                        <% end if %>
							<div class="thumbnail">
								<img src="<%=tmpItemList(y).FImageList%>" alt="" />
                                <% if tmpItemList(y).FsellYn = "N" then %>
                                <b class="soldout">일시 품절</b>
                                <% end if %>																
							</div>   
							<div class="desc">
								<p class="name"><%=tmpItemList(y).Fitemname%></p>
								<div class="price">
									<div class="unit">
                                        <b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b>
                                        <% response.write saleStr%>
                                        <% response.write couponStr%>
                                    </div>
								</div>
							</div>
						</a>
					</li>			
					<% next %>		
					<% end if %>
				</ul>
				<% if Ubound(tmpItemList) > 5 then %>
				<button class="btn btn-large btn-block btn-more" value="<%=detailGroupList(i).Fdetailcode%>">더보기<span class="btn-icon"></span></button>
				<% end if %>				
			</div>
		</section>
			<% next %>
		<% end if %>
		<!-- 하단 배너 -->
		<a href="/category/category_list.asp?disp=122113" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_bottom_category','','');" class="mWeb"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_xmas.jpg" alt="크리스마스 아이템 모두 보기" /></a>
		<a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_2018christmas_bottom_category','',''
		 ,function(bool){if(bool) {fnAPPpopupCategory('122113'); return false;}});" class="mApp">
			<img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_xmas.jpg" alt="크리스마스 아이템 모두 보기" />
		</a>		
		<a href="./index.asp?link=1&gnbflag=1<%=strGaParam%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_2018christmas_bottom_tab','tabname','한컷크리스마스');"><img src="http://fiximage.10x10.co.kr/web2018/xmas2018/m/bnr_insta.jpg" alt="한 컷 크리스마스" /></a>
	</div>
	<!-- //contents -->