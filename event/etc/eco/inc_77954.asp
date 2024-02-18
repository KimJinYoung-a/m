<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 에코백 시리즈 5월
' History : 2017-07-19 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
dim currenttime
	currenttime =  now()
	'currenttime = #10/07/2015 09:00:00#

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66397
Else
	eCode   =  79256
End If

%>
<style type="text/css">
.ecoBag {background-color:#fffaea;}
.ecoBag .topic {position:relative; padding-top:3.5rem; background-color:#fff;}
.ecoBag .item {position:relative;}
.ecoBag .item .price {position:absolute; bottom:14.48%; left:0; width:100%; text-align:center; font-size:1.4rem; color:#868686; z-index:100;}
.ecoBag .item .price .sale {padding-left:.5rem; font-weight:bold; color:#ff3131;}
.ecoBag iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.ecoBag .rolling .swiper {position:relative;}
.ecoBag .rolling .swiper .pagination{position:absolute; bottom:8.69%; z-index:20; left:0; width:100%;}
.ecoBag .rolling .swiper .swiper-pagination-switch {width:12px; height:12px; margin:0 0.7rem; border:2px solid #d5b34b; background-color:transparent;}
.ecoBag .rolling .swiper .swiper-active-switch {background-color:#d5b34b; border:#d5b34b solid 1px;}
.ecoBag .rolling .swiper button {position:absolute; top:35.97%; z-index:10; width:3.12%; background-color:transparent;}
.ecoBag .rolling .swiper .btnPrev {left:4.94%;}
.ecoBag .rolling .swiper .btnNext {right:4.94%;}
.swiper .swiper-container {position:relative;}
.swiper button {position:absolute; top:42%; width:12.5%; z-index:30; background-color:transparent;}
.swiper button.btnPrev {left:0;}
.swiper button.btnNext {right:0;}
.swiper .pagination {position:absolute; left:0; bottom:1rem; z-index:30; width:100%; height:auto; padding-top:0;}
.swiper .pagination span {display:inline-block; width:0.6rem; height:0.6rem; margin:0 0.5rem; border:0.1rem solid #000; background-color:transparent;}
.swiper .pagination .swiper-active-switch {background-color:#000;}
.swiper2 button {top:43%;}
.swiper2 .pagination {bottom:3.8rem;}
</style>
<script type="text/javascript">
$(function(){
        mySwiper = new Swiper(".swiper1 .swiper-container",{
                loop:true,
                autoplay:2500,
                speed:800,
                pagination:".swiper1 .pagination",
                paginationClickable:true,
                prevButton:'.swiper1 .btnPrev',
                nextButton:'.swiper1 .btnNext',
                effect:'fade'
        });
        mySwiper = new Swiper(".swiper2 .swiper-container",{
                loop:true,
                autoplay:2500,
                speed:800,
                pagination:".swiper2 .pagination",
                paginationClickable:true,
                prevButton:'.swiper2 .btnPrev',
                nextButton:'.swiper2 .btnNext',
                effect:'fade'
        });
        mySwiper = new Swiper(".swiper3 .swiper-container",{
                loop:true,
                autoplay:2500,
                speed:800,
                pagination:".swiper3 .pagination",
                paginationClickable:true,
                prevButton:'.swiper3 .btnPrev',
                nextButton:'.swiper3 .btnNext',
                effect:'fade'
        });
});
</script>
<div class="mEvt77954 ecoBag">
        <h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/tit_monthly_ecobag.png" alt="월간(月刊) 에코백" /></h2>
        <div class="topic">
                <iframe id="iframe_lucky" src="/event/etc/group/iframe_ecobag.asp?eventid=77954" frameborder="0" scrolling="no" title="월간 에코백 메뉴"></iframe>
                <div><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_may.jpg" alt="#5월호 ithinkso 나도 그렇게 생각해" /></div>
        </div>
        <p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_story.png" alt="이번 텐바이텐에서 소개하는 에코백은 아이띵소와 함께 했습니다. 항상 가방속이 복잡한 그대를 위해 가볍고 편한 에코백에 수납력을 더했어요. 더운 여름에 더욱 상쾌하게 느껴지는 린넨 재질로 시원함을 주며 일상을 함께 하고싶은 에코백 입니다. 텐바이텐 X 아이띵소 콜라보 상품을 만나보세요! " /></p>

		<%
		Dim itemid, oItem
		IF application("Svr_Info") = "Dev" THEN
			itemid = 786868
		Else
			itemid = 1702337
		End If
		set oItem = new CatePrdCls
			oItem.GetItemData itemid
		%>
        <div class="item">
			<% if isapp then %>
            	<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1702337&pEtr=77954" onclick="fnAPPpopupProduct('1702337&pEtr=77954');return false;" class="mApp">
            <% else %>
            	<a href="/category/category_itemPrd.asp?itemid=1702337&pEtr=77954" class="mWeb">
            <% end if %>
                <img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_item_01_v2.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" />
                <div class="price">
					<% If oItem.FResultCount > 0 then %>
						<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
                            <s class="normal"><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
                            <span class="sale"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</span>
						<% else %>
							 <span class="sale"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
						<% end if %>
					<% end if %>
                </div>
            </a>
        </div>
        <% Set oItem = Nothing %>

		<%
		IF application("Svr_Info") = "Dev" THEN
			itemid = 786868
		Else
			itemid = 1701897
		End If
		set oItem = new CatePrdCls
			oItem.GetItemData itemid
		%>
        <div class="item">
            <div class="swiper swiper3">
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <a href="/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" class="mWeb">
                                    <img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_item02_1_v2.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" />
                            </a>
                            <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" onclick="fnAPPpopupProduct('1701897&pEtr=77954');return false;" class="mApp">
                                    <img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_item02_1_v2.jpg" alt="" />
                            </a>
                        </div>
                        <div class="swiper-slide">
                            <a href="/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" class="mWeb">
                                    <img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_item02_2_v2.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" />
                            </a>
                            <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" onclick="fnAPPpopupProduct('1701897&pEtr=77954');return false;" class="mApp">
                                    <img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_item02_2_v2.jpg" alt="" />
                            </a>
                        </div>
                        <div class="swiper-slide">
                            <a href="/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" class="mWeb">
                                    <img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_item02_3_v2.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" />
                            </a>
                            <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" onclick="fnAPPpopupProduct('1701897&pEtr=77954');return false;" class="mApp">
                                    <img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_item02_3_v2.jpg" alt="" />
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="price">
				<% If oItem.FResultCount > 0 then %>
					<% If (oItem.Prd.FSaleYn = "Y") and (oItem.Prd.FOrgPrice - oItem.Prd.FSellCash > 0) Then %>
                        <s class="normal"><%= FormatNumber(oItem.Prd.getOrgPrice,0) %></s>
                        <span class="sale"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %> [<%= Format00(2, CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100) ) %>%]</span>
					<% else %>
						 <span class="sale"><%= FormatNumber(oItem.Prd.FSellCash,0) & chkIIF(oItem.Prd.IsMileShopitem,"Point","won") %></span>
					<% end if %>
				<% end if %>
            </div>
        </div>
        <% Set oItem = Nothing %>

        <div class="swiper swiper1">
                <div class="swiper-container">
                        <div class="swiper-wrapper">
                                <div class="swiper-slide">
                                        <a href="/category/category_itemPrd.asp?itemid=1702337&pEtr=77954" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_01.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                        <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1702337&pEtr=77954" onclick="fnAPPpopupProduct('1702337&pEtr=77954');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_01.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                </div>
                                <div class="swiper-slide">
                                        <a href="/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_02.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                        <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" onclick="fnAPPpopupProduct('1701897&pEtr=77954');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_02.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                </div>
                                <div class="swiper-slide">
                                        <a href="/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_03.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                        <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" onclick="fnAPPpopupProduct('1701897&pEtr=77954');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_03.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                </div>
                                <div class="swiper-slide">
                                        <a href="/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_04.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                        <a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1701897&pEtr=77954" onclick="fnAPPpopupProduct('1701897&pEtr=77954');return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/img_slide_04.jpg" alt="텐바이텐 단독 TWIN BAG _ HAY" /></a>
                                </div>
                        </div>
                        <div class="pagination"></div>
                        <button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/btn_prev.png" alt="" /></button>
                        <button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/btn_next.png" alt="" /></button>
                </div>
        </div>
        <div><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_brand.jpg" alt="BRAND STORY 무심코 지나치는 사소한 순간들 그 순간들이 모여 하루의 대부분이 되고, 그 하루들이 모여 소중한 삶이 되는 것을 알고 있기에 우리는 늘 당신의 순간에 집중합니다. 언제나 곁을 지켜주는 오랜친구처럼 평범하지만 특별한 오늘과 내일을 함께하길 바랍니다." /></div>
        <div class="swiper swiper2">
                <p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_talk.png" alt="“아이띵소와 이야기를 나누고싶어요”" /></p>
                <div class="swiper-container">
                        <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_interview_01.png" alt="Q1.아이띵소에게 에코백이란? 누구나 장소와 용도에 상관없이 편안하게 사용을 할 수 있는 가방" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_interview_02.png" alt="Q2. 신제품 출시할 때 주로 어디에서 영감을 받으시나요?늘 주변을 살피고 사람들의 생활 패턴에 대해 고민" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_interview_03.png" alt="Q3 이번 신상 런칭하신 상품의 장점이 궁금해요그 시즌의 기분을 내면서도 과하지 않게 오래 쓸 수 있는 가방" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_interview_04.png" alt="Q4마지막으로 아이띵소를 사랑하는 고객님들께 한마디 해주세요 모든 분들이 사용하면 할수록 더 만족하게 되는 경험" /></div>
                        </div>
                        <div class="pagination"></div>
                        <button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/btn_prev.png" alt="" /></button>
                        <button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/btn_next.png" alt="" /></button>
                </div>
        </div>
        <div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/txt_comment.jpg" alt="COMMENT EVENT 아이띵소 X 텐바이텐 5월호 에코백런칭을 축하해주세요! 정성스러운 댓글을 남겨주신 3분을 선정해 텐바이텐 상품권 1만원권을 드립니다! 이벤트 기간은 2017년 5월 17일 부터 5월 30일 입니다. 당첨자 발표는 2017년 5월 31일 입니다." /></a></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->