<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 에코백 시리즈 6월
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
	eCode   =  78366
End If

%>
<style type="text/css">
.ecoBag {background-color:#fffaea;}
.ecoBag .topic {position:relative; padding-top:3.5rem; background-color:#fff;}
.ecoBag iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.ecoBag .item a {display:block; position:relative;}
.ecoBag .item .price {position:absolute; bottom:14.48%; left:0; width:100%; text-align:center; font-size:1.5rem; color:#868686;}
.ecoBag .item .price .sale {padding-left:.5rem; font-weight:bold; color:#ff3131;}
.ecoBag .rolling .swiper {position:relative;}
.ecoBag .rolling .swiper .pagination{position:absolute; bottom:8.69%; z-index:20; left:0; width:100%;}
.ecoBag .rolling .swiper .swiper-pagination-switch {width:12px; height:12px; margin:0 0.7rem; border:2px solid #d5b34b; background-color:transparent;}
.ecoBag .rolling .swiper .swiper-active-switch {background-color:#d5b34b; border:#d5b34b solid 1px;}
.ecoBag .rolling .swiper button {position:absolute; top:35.97%; z-index:10; width:3.12%; background-color:transparent;}
.ecoBag .rolling .swiper .btnPrev {left:4.94%;}
.ecoBag .rolling .swiper .btnNext {right:4.94%;}
.swiper .swiper-container {position:relative;}
.swiper button {position:absolute; top:45.2%; width:4.3%; z-index:30; background-color:transparent;}
.swiper button.btnPrev {left:3.5%;}
.swiper button.btnNext {right:3.5%;}
.swiper .pagination {position:absolute; left:0; bottom:1rem; z-index:30; width:100%; height:auto; padding-top:0;}
.swiper .pagination span {display:inline-block; width:0.6rem; height:0.6rem; margin:0 0.5rem; border:0.1rem solid #fff; background-color:transparent;}
.swiper .pagination .swiper-active-switch {background-color:#fff;}
.swiper2 button {width:12.5%;}
.swiper2 button {top:44%;}
.swiper2 .pagination {bottom:3.8rem;}
.swiper2 .pagination span {border:0.1rem solid #000;}
.swiper2 .pagination .swiper-active-switch {background-color:#000;}

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
});
</script>
<div class="mEvt78366 ecoBag">
        <h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/tit_monthly_ecobag.png" alt="월간(月刊) 에코백" /></h2>
        <div class="topic">
                <iframe id="iframe_lucky" src="/event/etc/group/iframe_ecobag.asp?eventid=78366" frameborder="0" scrolling="no" title="월간 에코백 메뉴"></iframe>
                <div><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_may.jpg" alt="#6월호 Atticmermaid 매일 편하게 쓰는 천가방" /></div>
        </div>
        <p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_story.png" alt="이번 텐바이텐에서 소개하는 에코백은 아틱머메이드와 함께 했습니다. 항상 가방이 꽉 차는 준비가 철저한 당신. 필요한 것만 간편하게 챙기는 자유로운 당신. 짐이 많은 날, 간편하게 외출하는 날. 그날에 따라 때에 맞는 에코백을 들 수 있어요. 날마다 담는 물건과 메는 스타일이 다른 만큼, 다양하게 연출할 수 있도록 사용성의 폭을 넓힌 folding ecobag 을 소개합니다." /></p>
        <div class="item <%=chkIIF(isApp,"mApp","mWeb")%>">
				<%
				Dim itemid, oItem
				IF application("Svr_Info") = "Dev" THEN
					itemid = 786868
				Else
					itemid = 1725163
				End If
				set oItem = new CatePrdCls
					oItem.GetItemData itemid
				%>
        		<% if isapp then %>
        			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1725163&pEtr=78366" onclick="fnAPPpopupProduct('1725163&pEtr=78366');return false;">
        		<% else %>
                	<a href="/category/category_itemPrd.asp?itemid=1725163&pEtr=78366">
                <% end if %>
                        <img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_item_01_v2.jpg" alt="텐바이텐 단독 folding ecobag white" />
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
		        <% Set oItem = Nothing %>

				<%
				IF application("Svr_Info") = "Dev" THEN
					itemid = 786868
				Else
					itemid = 1725174
				End If
				set oItem = new CatePrdCls
					oItem.GetItemData itemid
				%>
        		<% if isapp then %>
        			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1725174&pEtr=78366" onclick="fnAPPpopupProduct('1725174&pEtr=78366');return false;">
        		<% else %>
                	<a href="/category/category_itemPrd.asp?itemid=1725174&pEtr=78366">
                <% end if %>
                        <img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_item_02_v2.jpg" alt="텐바이텐 단독 folding ecobag navy" />
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
		        <% Set oItem = Nothing %>

				<%
				IF application("Svr_Info") = "Dev" THEN
					itemid = 786868
				Else
					itemid = 1725175
				End If
				set oItem = new CatePrdCls
					oItem.GetItemData itemid
				%>
        		<% if isapp then %>
        			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1725175&pEtr=78366" onclick="fnAPPpopupProduct('1725175&pEtr=78366');return false;">
        		<% else %>
                	<a href="/category/category_itemPrd.asp?itemid=1725175&pEtr=78366">
                <% end if %>
                        <img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_item_03_v2.jpg" alt="텐바이텐 단독 folding ecobag greenish" />
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
				<% Set oItem = Nothing %>
        </div>

        <div><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_brand.jpg" alt="BRAND STORY 로맨틱한 상상이 꿈이 되고, 꿈이 현실이 될 때까지 우리는 저마다 로망을 가지고 있습니다. 어렸을 적 읽었던 동화에서부터 어른이 된 지금까지도요. 가끔 어떤 삶을 혹은 어떤 것을 보며 나도 저렇게 빛나기를 하고 바랄 때가 있어요. 그럴 때, 도움이 되는 작은 물건들이 있습니다. 힘들고 너무 뻔해 가끔은 지루하기도 한 일상을 그럴듯하게 만들어주는 물건들이요. 누군가에게는 허세처럼 보일 수 있지만, 누군가에게는로망일 수 있는 소소한 일상을, 스쳐 지나가는 삶의 순간들을 조금 더 스타일리쉬하게 만들어주는 작은 물건을 만드는 것이 저희가 꿈꾸는 일입니다." /></div>
        <div class="swiper swiper1">
                <div class="swiper-container">
                        <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_slide_01.jpg" alt="텐바이텐 단독 folding ecobag" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_slide_02.jpg" alt="텐바이텐 단독 folding ecobag" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_slide_03.jpg" alt="텐바이텐 단독 folding ecobag" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_slide_04.jpg" alt="텐바이텐 단독 folding ecobag" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/img_slide_05.jpg" alt="텐바이텐 단독 folding ecobag" /></div>
                        </div>
                        <div class="pagination"></div>
                        <button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/btn_prev.png" alt="" /></button>
                        <button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/btn_next.png" alt="" /></button>
                </div>
        </div>

        <div class="swiper swiper2">
                <p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_talk.png" alt="아틱머메이드와 이야기를 나누고 싶어요!" /></p>
                <div class="swiper-container">
                        <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_interview_01.png" alt="Q. 아틱머메이드에게 에코백이란 이제 에코백은 친환경이라는 기존의 의미에서 한걸음 더 나아가 하나의 아이템으로 자리 잡은 것 같아요. " /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_interview_02.png" alt="Q. 제품을 만들 때 중점적으로 생각하는 것 우리는 전부 소소한 로망을 가지고 있잖아요. 분위기나 색감, 기억 등등.... 일상에서 어떤 것들이 아름답다고 느끼는 순간들이요." /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_interview_03.png" alt="Q. 이번 신상품은 어떤 장점이 있는 상품인가요? 날마다 담는 물건과 메는 스타일이 다른 만큼 다양하게 연출할 수 있는 디자인입니다." /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_interview_04.png" alt="Q. 다음 신상은 어떤 상품을 준비하고 있을까 뜨거운 여름 시즌에 어울리는 가벼운 제품이 출시될 예정입니다." /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_interview_05.png" alt="Q. 마지막으로 아틱머메이드들 사랑하는 고객님들께 한마디 해주세요. 고객님들의 이루고 싶은 로망을 저희에게 들려주세요." /></div>
                        </div>
                        <div class="pagination"></div>
                        <button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/btn_prev.png" alt="" /></button>
                        <button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77954/m/btn_next.png" alt="" /></button>
                </div>
        </div>
        <div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/txt_comment.jpg" alt="COMMENT EVENT 아틱머메이드 X 텐바이텐 6월호 에코백을 보시고 어떤 생각이 드시나요? 정성스러운 댓글을 남겨주신 3분을 선정해 텐바이텐 상품권 1만원권을 드립니다! 이벤트 기간은 2017년 6월 14일 부터 6월 27일 입니다. 당첨자 발표는 2017년 6월 28일 입니다." /></a></div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->