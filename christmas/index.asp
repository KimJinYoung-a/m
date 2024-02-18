<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : 2020 크리스마스 기획전
' History : 2020-11-16 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
	dim gnbflag , testmode
	gnbflag = RequestCheckVar(request("gnbflag"),1)
	testmode = RequestCheckVar(request("testmode"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
	Else 
		gnbflag = False
		strHeadTitleName = "크리스마스"
	End if

if GetLoginUserLevel<>"7" then
	if now() < #11/23/2020 00:00:00# then
		response.redirect "/christmas/2019/"
	end if
end if
ON ERROR RESUME NEXT

DIM totalPrice , salePercentString , couponPercentString , totalSalePercent, oExhibition, i
SET oExhibition = new ExhibitionCls
	oExhibition.FrectMasterCode = 17 '// 기획전 고유번호
	oExhibition.FrectListType = "A"
    oExhibition.Frectpick = 1
	oExhibition.getItemsPageListProc
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/xmas2020.css?v=1.01">
<script type="text/javascript">
var isApp = false;
$(function(){
	var itemSwiper = new Swiper(".prd_slider_type4 .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});

	// '카테고리 보기' 버튼 
	$(window).scroll(function(){
		var y = $(window).scrollTop(),
			pos = $('#xmas_item').offset().top;
		if (y > pos) $('.btn_cate').show();
		else $('.btn_cate').hide();
	});

	// 인터렉션
	$('.topic').addClass('on');
});
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content xmas2020">
		<!-- 상단 -->
		<div class="topic">
			<img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/img_top.jpg" alt="holly Homely Christmas">
			<h2>
				<span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/tit_xmas1.png" alt="holly"></span>
				<span class="t2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/tit_xmas2.png" alt="Homely Xmas"></span>
			</h2>
			<div class="deco">
				<i class="dc1"></i>
				<i class="dc2"></i>
				<i class="dc3"></i>
				<i class="dc4"></i>
			</div>
		</div>

		<%'<!-- MD PICK -->%>
		<% IF oExhibition.FTotalCount > 0 THEN %>
		<section class="mdpick">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/tit_md.png" alt="MD Pick"></h3>
			<div class="prd_slider_type4">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<% FOR i = 0 TO oExhibition.FResultCount-1 %>
						<% CALL oExhibition.FItemList(i).fnItemPriceInfos(totalPrice , salePercentString , couponPercentString , totalSalePercent) %>
						<article class="swiper-slide prd_item">
							<% if oExhibition.FItemList(i).Foptioncode="4" then %><div class="label_best">베스트</div><% end if %>
							<% if oExhibition.FItemList(i).Foptioncode="1" then %><div class="label_lowest">최저가</div><% end if %>
							<figure class="prd_img">
								<img src="<%=oExhibition.FItemList(i).FPrdImage%>" alt="<%=oExhibition.FItemList(i).Fitemname%>">
								<span class="prd_mask"></span>
							</figure>
							<div class="prd_info">
								<div class="prd_price">
									<span class="set_price"><dfn>판매가</dfn><%=totalPrice%></span>
									<% if salePercentString<>"0" and couponPercentString<>"0" then %>
									<span class="discount"><dfn>할인율</dfn><%=totalSalePercent%></span>
									<% else %>
									<% if salePercentString<>"0" then %><span class="discount"><dfn>할인율</dfn><%=salePercentString%></span><% end if %>
									<% if couponPercentString<>"0" then %><span class="discount"><dfn>할인율</dfn><%=couponPercentString%> </em>쿠폰</em></span><% end if %>
									<% end if %>
								</div>
								<div class="prd_name ellipsis2"><%=oExhibition.FItemList(i).Fitemname%></div>
								<div class="user_side">
									<% if fnEvalTotalPointAVG(oExhibition.FItemList(i).FtotalPoint,"search") >= 80 then %>
									<span class="user_eval"><dfn>평점</dfn><i style="width:<%=fnEvalTotalPointAVG(oExhibition.FItemList(i).FtotalPoint,"search")%>%"><%=fnEvalTotalPointAVG(oExhibition.FItemList(i).FtotalPoint,"search")%>점</i></span>
									<% if oExhibition.FItemList(i).FevalCnt >= 5 then %><span class="user_comment"><dfn>상품평</dfn><%=oExhibition.FItemList(i).FevalCnt%></span><% end if %>
									<% end if %>
								</div>
							</div>
							<a href="/category/category_itemPrd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>" class="prd_link"><span class="blind">상품 바로가기</span></a>
						</article>
						<% next %>
					</div>
				</div>
			</div>
		</section>
		<% end if %>

		<!-- 마케팅 -->
		<% if date() >= "2020-11-16" and date() <= "2020-11-29" then %>
		<a href="/event/eventmain.asp?eventid=107400" class="bnr_mkt"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/bnr_mkt.jpg" alt="마케팅 배너"></a>
		<% elseif date() >= "2020-11-30" and date() <= "2020-12-06"  then %>
		<a href="/event/eventmain.asp?eventid=107775" class="bnr_mkt"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/bnr_mkt_v2.jpg" alt="마케팅 배너"></a>
		<% elseif date() >= "2020-12-07" and date() <= "2020-12-13"  then %>
		<a href="/event/eventmain.asp?eventid=107790" class="bnr_mkt"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/bnr_mkt_v3.jpg" alt="마케팅 배너"></a>
		<% end if %>

		<!-- 이벤트(수작업) -->
		<section class="xmas_event">
			<a href="/event/eventmain.asp?eventid=107444"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/img_event.jpg" alt="event"></a>
			<a href="/event/eventmain.asp?eventid=107466"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/img_ch1.jpg?v=2" alt="chapter1"></a>
			<a href="/event/eventmain.asp?eventid=107467"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/img_ch2.jpg?v=2" alt="chapter2"></a>
			<a href="/event/eventmain.asp?eventid=107468"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/img_ch3.jpg?v=2" alt="chapter3"></a>
		</section>

		<%' 상품리스트 %>
		<div id="app" v-cloak></div>

		<a href="#xmas_item" class="btn_cate" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/btn_cate.png" alt="카테고리보기"></a><a href="#xmas_item" class="btn_cate" style="display:none;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/xmas/m/btn_cate.png" alt="카테고리보기"></a>
	</div>
    <!-- #include virtual="/lib/inc/incFooter.asp" -->
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<% IF application("Svr_Info") = "Dev" or testmode = "1" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<script src="/vue/exhibition/main/christmas2020/item-list.js"></script>
<script src="/vue/exhibition/main/christmas2020/searchfilter.js"></script>
<script src="/vue/exhibition/main/christmas2020/store.js"></script>
<script src="/vue/exhibition/main/christmas2020/index.js"></script>
</body>
</html>
<% SET oExhibition = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->