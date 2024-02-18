<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 에코백 시리즈 7월 MA
' History : 2017-07-28 유태욱 생성
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
	eCode   =  66398
Else
	eCode   =  79244
End If

%>
<style type="text/css">
.ecoBag {background-color:#f7f7f7;}
.ecoBag .topic {position:relative; padding-top:3.5rem; background-color:#fff;}
.ecoBag iframe {position:absolute; top:0; left:0; right:0; width:100%; height:5.5rem;}
.ecoBag .item a {display:block; position:relative;}
.ecoBag .item .price {position:absolute; bottom:18.48%; left:0; width:100%; text-align:center; font-size:1.4rem; color:#868686;}
.ecoBag .item .date {position:absolute; bottom:10.85%; left:50%; margin-left:-6.4rem; padding:.7rem .8rem; font-size:1.1rem; line-height:1.1rem; background-color:#d50c0c; color:#fff; font-weight:bold;}
.ecoBag .item .date.only {margin-left:-7.45rem;}
.ecoBag .item a:nth-child(1) .price {bottom:14.48%;}
.ecoBag .item a:nth-child(1) .date {bottom:6.85%;}
.ecoBag .swiper {position:relative;}
.ecoBag .swiper .pagination{position:absolute; bottom:1.2rem; z-index:20; left:0; width:100%; height:0.5rem; padding-top:0;}
.ecoBag .item .price .sale {padding-left:.5rem; font-weight:bold; color:#ff3131;}
.ecoBag .swiper .swiper-pagination-switch {width:0.5rem; height:0.5rem; margin:0 0.5rem; border:0.1rem solid #252525; background-color:transparent;}
.ecoBag .swiper .swiper-active-switch {background-color:#252525; border:0;}
.ecoBag .swiper button {position:absolute; top:42%; z-index:10; width:12.5%; background-color:transparent;}
.ecoBag .swiper .btnPrev {left:0;}
.ecoBag .swiper .btnNext {right:0;}
.ecoBag .swiper2 .pagination {bottom:3.7rem;}
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
	<!-- 월간(月刊) 에코백 -->
	<div class="mEvt79244 ecoBag">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78366/m/tit_monthly_ecobag.png" alt="월간(月刊) 에코백" /></h2>
		<div class="topic">
			<iframe id="iframe_lucky" src="/event/etc/group/iframe_ecobag.asp?eventid=79244" frameborder="0" scrolling="no" title="월간 에코백 메뉴"></iframe>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_ww.jpg" alt="#7월호 WW 일상을 더욱 싱그럽게!" /></div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_story.png" alt="이번 텐바이텐 에서 소개하는 에코백은 W/W와 함께 했습니다. 매일 똑같은 색상의 에코백을 들었다면 내일은 활력을 주는 그린 색상의 에코백은 어떨까요? 작지만 알차게, 밋밋한 일상에 상쾌하고 싱그러운 느낌을 주는 에코백입니다. 싱그러운 하루를 보낼 그대의 일상을 함께 하고 싶습니다." /></p>



		<div class="item <%=chkIIF(isApp,"mApp","mWeb")%>">
			<%
			Dim itemid, oItem
			dim saletextonly, saletext
				if date() >= "2017-07-19" and date() <= "2017-08-01" then
					saletextonly = "<div class='date only'>7.19 - 8.01 단 2주간 단독특가</div>"
					saletext = "<div class='date'>7.19 - 8.01 단 2주간 특가</div>"
				else
					saletextonly = ""
					saletext = ""
				end if

			IF application("Svr_Info") = "Dev" THEN
				itemid = 786868
			Else
				itemid = 1750035
			End If
			set oItem = new CatePrdCls
				oItem.GetItemData itemid
			%>
    		<% if isapp then %>
    			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1750035&pEtr=79244" onclick="fnAPPpopupProduct('1750035&pEtr=79244');return false;">
    		<% else %>
            	<a href="/category/category_itemPrd.asp?itemid=1750035&pEtr=79244">
            <% end if %>

				<img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_prd_1.jpg" alt="LINEN MINI ECOBAG_GREEN" />
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
				<%= saletextonly %>
			</a>
			<% Set oItem = Nothing %>

			<%
			IF application("Svr_Info") = "Dev" THEN
				itemid = 786868
			Else
				itemid = 1721433
			End If
			set oItem = new CatePrdCls
				oItem.GetItemData itemid
			%>
    		<% if isapp then %>
    			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1721433&pEtr=79244" onclick="fnAPPpopupProduct('1721433&pEtr=79244');return false;">
    		<% else %>
            	<a href="/category/category_itemPrd.asp?itemid=1721433&pEtr=79244">
            <% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_prd_2.jpg" alt="LINEN MINI ECOBAG_BEIGE" />
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
				<%= saletext %>
			</a>
			<% Set oItem = Nothing %>

			<%
			IF application("Svr_Info") = "Dev" THEN
				itemid = 786868
			Else
				itemid = 1721438
			End If
			set oItem = new CatePrdCls
				oItem.GetItemData itemid
			%>
    		<% if isapp then %>
    			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1721438&pEtr=79244" onclick="fnAPPpopupProduct('1721438&pEtr=79244');return false;">
    		<% else %>
            	<a href="/category/category_itemPrd.asp?itemid=1721438&pEtr=79244">
            <% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_prd_3.jpg" alt="LINEN MINI ECOBAG_RED" />
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
				<%= saletext %>
			</a>
			<% Set oItem = Nothing %>

			<%
			IF application("Svr_Info") = "Dev" THEN
				itemid = 786868
			Else
				itemid = 1721432
			End If
			set oItem = new CatePrdCls
				oItem.GetItemData itemid
			%>
    		<% if isapp then %>
    			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1721432&pEtr=79244" onclick="fnAPPpopupProduct('1721432&pEtr=79244');return false;">
    		<% else %>
            	<a href="/category/category_itemPrd.asp?itemid=1721432&pEtr=79244">
            <% end if %>
			<a href="/category/category_itemPrd.asp?itemid=1721432&pEtr=79244">
				<img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_prd_4.jpg" alt="LINEN MINI ECOBAG_BLUE" />
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
				<%= saletext %>
			</a>
			<% Set oItem = Nothing %>

		</div>

		<div class="swiper swiper1">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_slide_1.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_slide_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_slide_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/img_slide_4.jpg" alt="" /></div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="" /></button>
			</div>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_brand.jpg" alt="BRAND STORY 로맨틱한 상상이 꿈이 되고, 꿈이 현실이 될 때까지 우리는 저마다 로망을 가지고 있습니다. 어렸을 적 읽었던 동화에서부터 어른이 된 지금까지도요. 가끔 어떤 삶을 혹은 어떤 것을 보며 나도 저렇게 빛나기를 하고 바랄 때가 있어요. 그럴 때, 도움이 되는 작은 물건들이 있습니다. 힘들고 너무 뻔해 가끔은 지루하기도 한 일상을 그럴듯하게 만들어주는 물건들이요. 누군가에게는 허세처럼 보일 수 있지만, 누군가에게는로망일 수 있는 소소한 일상을, 스쳐 지나가는 삶의 순간들을 조금 더 스타일리쉬하게 만들어주는 작은 물건을 만드는 것이 저희가 꿈꾸는 일입니다." /></div>
		<div class="swiper swiper2">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_talk.png" alt="더블유더블유와 이야기를 나누고 싶어요!" /></p>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_interview_1.png" alt=" " /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_interview_2.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_interview_3.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_interview_4.png" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_interview_5.png" alt="" /></div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_prev.png" alt="" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/btn_next.png" alt="" /></button>
			</div>
		</div>
		<div><a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79244/m/txt_comment.jpg" alt="COMMENT EVENT 더블유더블유 X 텐바이텐의 상큼한 그린 에코백을 언제 들고 싶은지 남겨주세요! 정성스러운 댓글을 남겨주신 20분을 선정해 라운드랩 섬유향수를 보내드립니다!" /></a></div>
	</div>
	<!--// 월간(月刊) 에코백 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->