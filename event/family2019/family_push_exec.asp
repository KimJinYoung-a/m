<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  가정의날 기획전
' History : 2019-04-10 최종원 생성
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
Dim oExhibition 
dim mastercode,  detailcode, bestItemList, detailGroupList, listType, tmpItemList
dim couponPrice, couponPer, tempPrice, salePer, saleStr, couponStr
dim tmpImgCode, disOption
dim i, j, tmpIdx
dim numOfItems

'gnb관련변수
	dim vGaParam, gaStr
	vGaParam = request("gaparam")

	if vGaParam <> "" then
		gaStr = "&gaparam=" & vGaParam
	end if
'gnb관련변수

numOfItems = 12
j = 0

listType = "A"

IF application("Svr_Info") = "Dev" THEN
	mastercode = 7
Else
	mastercode = 6	
End If

SET oExhibition = new ExhibitionCls

    bestItemList = oExhibition.getItemsListProc( listType, 100, mastercode, "", "1", "" )     '리스트타입, row개수, 마스터코드, 디테일코드, best아이템 구분, 카테고리 정렬 구분     
	detailGroupList = oExhibition.getDetailGroupList(mastercode)		    

function format(ByVal szString, ByVal Expression)
	if len(szString) < len(Expression) then
	format = left(expression, len(szString)) & szString
	else
	format = szString
	end if
end function
%>
<style>
.family2019 {position: relative;}
.topic {position: relative; background-color: #ffcecf;}
.topic h2 {position: absolute; top: 0; width: 100%;} 
.tab-area {position:relative; margin-top: -2rem;}
.tab-area ul {overflow:hidden; position: absolute; top:0; left:0; width:100%; height:100%;}
.tab-area ul li {float:left; height:100%; width: 50%;}
.tab-area ul li a {display:block; width:100%; height:100%; text-indent:-999em;}
.type-grid .section ul {padding: 0 .85rem; border: none;}
.type-grid .section li {padding: 0 .85rem; margin-bottom:  1.7rem; }
.type-grid .section li a {display: block; border-radius: 1.4rem}
.type-grid .section li a .thumbnail {width: 13.43rem; height: 13.43rem;}
.type-grid .section li a .desc {height: 7.04rem; padding:0.4rem 1rem 0; background-color: #f7f7f7;}
.type-grid .section li a .name {color: #666;}
.type-grid .section li a .price {display: block; overflow: hidden; width: 100%; margin-top: .5rem; white-space: nowrap; text-overflow: ellipsis;}
.type-grid .section li a .price b {margin-right: .2rem; font-family:'Verdana'; font-size: 1.19rem; font-weight: 600;}
.btn-more {background: transparent;}
.more-area {display: none;}
.slide1 {position: relative;}
.slide1 .pagination {position: absolute; bottom: 1.2rem; z-index: 999; width: 100%;}
.slide1 .pagination .swiper-pagination-switch {background-color: #fff; opacity: .5;}
.slide1 .pagination .swiper-pagination-switch.swiper-active-switch {opacity: 1;}
</style>
<script type="text/javascript">
$(function() {
	mySwiper = new Swiper(".slide1",{
		loop: true,
		pagination:'.slide1 .pagination',
		paginationClickable:true,
	});

// ======더보기
    $(".section").each(function(idx){
        if(idx == 0 || idx == 1){
            $("ul li:gt(5)" ,$(this)).css('display','none')
        }else{
            $("ul li:gt(3)" ,$(this)).css('display','none')
        }        
    });	
	$('.btn-more').click(function(e) { 
        var btnIdx = $(".btn-more").index($(this));        
        $(".section").each(function(idx){
            if(idx == btnIdx){
                $("ul li",$(this)).slideDown()                
            }      
        });
        $(this).hide();      
    });
// ======더보기    
	// skip to gift event
	$(".valen-head a").click(function(event){
	event.preventDefault();
	window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},800);
    });
});
</script>
    <!-- 가정의 달 -->
    <div id="content" class="content family2019">
        <!-- 상단 -->
        <div class="topic">
			<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_top.jpg" alt="종합선물세트">
            <div class="tab-area">
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_tab2.png?v=1.02" alt="">
                <ul>
                    <li><a href="./index.asp?link=1&gnbflag=1<%=gaStr%>">이달의 선물</a></li>
                    <li class="on"><a href="./index.asp?link=2&gnbflag=1<%=gaStr%>">추천선물</a></li>
                </ul>
            </div>
        </div>
		<!-- 상품목록및배너 -->
		<div class="items type-grid">			
            <% 
            if Ubound(bestItemList) > 0 then
                for i = 0 to 1 '2섹션
                    if i = 0 then
                        disOption = 0
                    else
                        disOption = 51
                    end if
                    tmpIdx = 0
            %>
			<div class="section">
				<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_0<%=i+1%>.jpg" alt="" /></h3>
				<ul>
					<%'<!-- 상품 6 노출 더보기 버튼 누르면 +4 총 10 노출 -->%>
                    <%
                    for j = 0 to Ubound(bestItemList) - 1
                        if tmpIdx = numOfItems then exit for '10개 상품만 노출                        
                        couponPer = oExhibition.GetCouponDiscountStr(bestItemList(j).Fitemcoupontype, bestItemList(j).Fitemcouponvalue)
                        couponPrice = oExhibition.GetCouponDiscountPrice(bestItemList(j).Fitemcoupontype, bestItemList(j).Fitemcouponvalue, bestItemList(j).Fsellcash)                    
                        salePer     = CLng((bestItemList(j).Forgprice-bestItemList(j).Fsellcash)/bestItemList(j).FOrgPrice*100)
                        if bestItemList(j).Fsailyn = "Y" and bestItemList(j).Fitemcouponyn = "Y" then '세일
                            tempPrice = bestItemList(j).Fsellcash - couponPrice
                            saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                            couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                        elseif bestItemList(j).Fitemcouponyn = "Y" then
                            tempPrice = bestItemList(j).Fsellcash - couponPrice
                            saleStr = ""
                            couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                        elseif bestItemList(j).Fsailyn = "Y" then
                            tempPrice = bestItemList(j).Fsellcash
                            saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                            couponStr = ""                                              
                        else
                            tempPrice = bestItemList(j).Fsellcash
                            saleStr = ""
                            couponStr = ""                                              
                        end if                    
                    %>
                    <%                            
                        if bestItemList(j).Fpicksorting >= disOption  then                                                                    
                    %>                    
					<li>
                        <% if isapp = 1 then %>    
                        <a href="javascript:void(0)" onclick="fnAPPpopupProduct('<%=bestItemList(j).Fitemid%>');" >	
                        <% else %>
                        <a href="/category/category_itemPrd.asp?itemid=<%=bestItemList(j).Fitemid%>" >
                        <% end if %>	
							<div class="thumbnail">
								<img src="<%=bestItemList(j).FImageList%>" alt="" />
                                <% if bestItemList(j).FsellYn = "N" then %>
                                <b class="soldout">일시 품절</b>
                                <% end if %>
							</div>
							<div class="desc">
								<p class="name"><%=bestItemList(j).Fitemname%></p>
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
                    <% 
                        tmpIdx = tmpIdx + 1 'index값 
                        else
                        end if
                    next 
                    %>
				</ul>                
				<button class="btn-more" style="display:<%=chkIIF(tmpIdx > 6, "","none")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_more.jpg" alt="더보기"></button>                
            </div>                
            <% 
                next
            end if
            %>    			
			<!-- 기획전 -->
			<div class="slide1">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=93729" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93729');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_01.jpg?v=1.01" alt="">
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=93725" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93725');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_02.jpg?v=1.01" alt="">
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=93721" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93721');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_03.jpg" alt="">
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=93724" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93724');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_04.jpg?v=1.02" alt="">
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=93723" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93723');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_05.jpg?v=1.02" alt="">
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=93727" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93727');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_06.jpg" alt="">
						</a>
					</div>
					<div class="swiper-slide">
						<a href="/event/eventmain.asp?eventid=93726" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=93726');return false;">
							<img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/img_slide_07.jpg?v=1.02" alt="">
						</a>
					</div>
				</div>
				<div class="pagination"></div>
			</div>
            <% 
            if Ubound(detailGroupList) > 0 then 
                for i = 0 to Ubound(detailGroupList) - 1 
                tmpItemList = oExhibition.getItemsListProc( listType, 12, mastercode, detailGroupList(i).Fdetailcode, "", "")'리스트타입, 아이템수, 마스터코드, 디테일코드, 픽아이템, 카테고리sort            
                tmpImgCode = format(detailGroupList(i).Fdetailcode / 10 + 2, "00")                    
            %>			
			<div class="section">
				<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/tit_<%=tmpImgCode%>.jpg" alt="<%=detailGroupList(i).Ftitle%>" /></h3>
                <% if Ubound(tmpItemList) > 0 then %>					
				<ul>
					<%'<!-- 상품 4 노출 더보기 버튼 누르면 +8 총 12 노출 -->%>
                    <%                      
                    for j = 0 to Ubound(tmpItemList) - 1                     
                    couponPer = oExhibition.GetCouponDiscountStr(tmpItemList(j).Fitemcoupontype, tmpItemList(j).Fitemcouponvalue)
                    couponPrice = oExhibition.GetCouponDiscountPrice(tmpItemList(j).Fitemcoupontype, tmpItemList(j).Fitemcouponvalue, tmpItemList(j).Fsellcash)                    
                    salePer     = CLng((tmpItemList(j).Forgprice-tmpItemList(j).Fsellcash)/tmpItemList(j).FOrgPrice*100)
                    if tmpItemList(j).Fsailyn = "Y" and tmpItemList(j).Fitemcouponyn = "Y" then '세일
                        tempPrice = tmpItemList(j).Fsellcash - couponPrice
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif tmpItemList(j).Fitemcouponyn = "Y" then
                        tempPrice = tmpItemList(j).Fsellcash - couponPrice
                        saleStr = ""
                        couponStr = "<b class=""discount color-green"">"&couponPer&"</b>"  
                    elseif tmpItemList(j).Fsailyn = "Y" then
                        tempPrice = tmpItemList(j).Fsellcash
                        saleStr = "<b class=""discount color-red"">"&salePer&"%</b>"
                        couponStr = ""                                              
                    else
                        tempPrice = tmpItemList(j).Fsellcash
                        saleStr = ""
                        couponStr = ""                                              
                    end if
                    %>                    
					<li>
                        <% if isapp = 1 then %>             
							<a href="javascript:fnAPPpopupProduct('<%=tmpItemList(j).Fitemid%>')" >							                                  	 	
                        <% else %>
                        	<a href="/category/category_itemPrd.asp?itemid=<%=tmpItemList(j).Fitemid%>">
                        <% end if %>
							<div class="thumbnail">
								<img src="<%=tmpItemList(j).FImageList%>" alt="" />
                                <% if tmpItemList(j).FsellYn = "N" then %>
                                <b class="soldout">일시 품절</b>
                                <% end if %>							
							</div>
							<div class="desc">
								<p class="name"><%=tmpItemList(j).Fitemname%></p>
								<div class="price">
                                    <b class="sum"><%=formatNumber(tempPrice, 0)%><span class="won">원</span></b>
                                    <% response.write saleStr%>
                                    <% response.write couponStr%>
								</div>
							</div>
						</a>
					</li>
                    <% next %>
				</ul>                      
				<button class="btn-more" style="display:<%=chkIIF(Ubound(tmpItemList) > 4, "","none")%>"><img src="//webimage.10x10.co.kr/fixevent/event/2019/family2019/m/btn_more.jpg" alt="더보기"></button>
                <% end if %>
			</div>
            <%
                next
            end if 
            %>
        </div>
    </div>
    <!-- // 가정의 달 -->