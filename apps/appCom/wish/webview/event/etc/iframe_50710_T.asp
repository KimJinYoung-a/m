<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  오픈이벤트 몸도 마음도 봄봄봄!
' History : 2014.04.07 한용민 생성
'           2014.04.11 허진원 수정 : 슬라이드 고정 및 쿠폰이벤트 추가
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->
<!-- #include virtual="/event/2014openevent/cls2014openevent.asp" -->

<%
dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21136
	Else
		eCode   =  50710
	End If

dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL, DateViewYN
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt

IF egCode = "" THEN egCode = 0

	itemlimitcnt = 105	'상품최대갯수
	'이벤트 개요 가져오기
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode

		cEvent.fnGetEvent

		eCode		= cEvent.FECode
		ekind		= cEvent.FEKind
		emanager	= cEvent.FEManager
		escope		= cEvent.FEScope
		eName		= cEvent.FEName
		esdate		= cEvent.FESDate
		eedate		= cEvent.FEEDate
		estate		= cEvent.FEState
		eregdate	= cEvent.FERegdate
		epdate		= cEvent.FEPDate
		ecategory	= cEvent.FECategory
		ecateMid	= cEvent.FECateMid
		blnsale		= cEvent.FSale
		blngift		= cEvent.FGift
		blncoupon	= cEvent.FCoupon
		blncomment	= cEvent.FComment
		blnbbs		= cEvent.FBBS
		blnitemps	= cEvent.FItemeps
		blnapply	= cEvent.FApply
		etemplate	= cEvent.FTemplate
		emimg		= cEvent.FEMimg
		ehtml		= cEvent.FEHtml
		eitemsort	= cEvent.FItemsort
		ebrand		= cEvent.FBrand
		gimg		= cEvent.FGimg
		blnFull		= cEvent.FFullYN
		blnItemifno = cEvent.FIteminfoYN
		blnitempriceyn = cEvent.FItempriceYN
		LinkEvtCode = cEvent.FLinkEvtCode
		blnBlogURL	= cEvent.FblnBlogURL
		DateViewYN	= cEvent.FDateViewYN

	set cEvent = nothing

	'// 이벤트 링크 보정
	if Not(ehtml="" or isNull(ehtml)) then
		ehtml = replace(ehtml,"href=""/event/eventmain.asp","href=""/apps/appCom/wish/webview/event/eventmain.asp")
	end if

strPageTitle = "생활감성채널, 텐바이텐 > 이벤트 > " & eName
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 구매 금액별 사은이벤트</title>
<style type="text/css">
.mEvt50710 {background:#f5f5f5 url(http://webimage.10x10.co.kr/eventIMG/2014/50694/bg_grey.gif) left top repeat-y; background-size:100% auto;}
.mEvt50710 p {max-width:100%;}
.mEvt50710 img {vertical-align:top; width:100%;}
.slideWrap {padding:0 12px 10%;}
.slide {overflow:visible !important; position:relative; width:435px; height:270px; margin:0 auto; padding:5px; box-shadow:1px 1px 1px 1px #eaeaea; background-color:#fff; }
.slidesjs-container {}
.slidesjs-slide img {width:435px; height:270px;}
.slide .slidesjs-navigation {display:block; position:absolute; top:50%; z-index:200; width:36px; height:36px; margin-top:-18px; text-indent:-999em;}
.slide .slidesjs-previous {left:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_prev_over.png) left top no-repeat; background-size:36px 36px;}
.slide .slidesjs-previous:hover {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_prev_over.png) left top no-repeat; background-size:36px 36px;}
.slide .slidesjs-next {right:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_next_over.png) right top no-repeat; background-size:36px 36px;}
.slide .slidesjs-next:hover {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_next_over.png) right top no-repeat; background-size:36px 36px;}
@media all and (max-width:480px){
	.slide {width:290px; height:180px;}
	.slidesjs-slide img {width:290px; height:180px;}
	.slide .slidesjs-navigation {width:24px; height:24px; margin-top:-12px; }
	.slide .slidesjs-previous {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_prev_over.png) left top no-repeat; background-size:24px 24px;}
	.slide .slidesjs-previous:hover {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_prev_over.png) left top no-repeat; background-size:24px 24px;}
	.slide .slidesjs-next {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_next_over.png) right top no-repeat; background-size:24px 24px;}
	.slide .slidesjs-next:hover {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_navigation_next_over.png) right top no-repeat; background-size:24px 24px;}
}
.slide .slidesjs-pagination {position:absolute; left:50%; bottom:-20px; z-index:50; width:154px; margin-left:-77px;}
.slide .slidesjs-pagination li {float:left; padding:0 6px;}
.slide .slidesjs-pagination li a {display:block; width:10px; height:9px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_pagination.png) left top no-repeat; background-size:10px 9px; text-indent:-999em;}
.slide .slidesjs-pagination li .active {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/btn_pagination_atv.png) left top no-repeat; background-size:10px 9px;}
.discoveryTenbyten .buySum {padding:5% 0 10%;}
.discoveryTenbyten .buySum h3 {padding-top:10%;}
.discoveryTenbyten .buySum h3:first-child {padding-top:0;}
.discoveryTenbyten .buySum ul {overflow:hidden; width:101%; padding-top:5%;}
.discoveryTenbyten .buySum ul li {float:left; position:relative; width:33.3333%;}
.discoveryTenbyten .buySum ul li .soldOut {display:none; position:absolute; left:0; top:0;}
.discoveryTenbyten .note {padding:6%; background:#def6ff url(http://webimage.10x10.co.kr/eventIMG/2014/50694/bg_sky.gif) left top repeat-y; background-size:100% auto;}
.discoveryTenbyten .note h3 img {width:37.29166%;}
.discoveryTenbyten .note ul {padding-top:3%;}
.discoveryTenbyten .note ul li {padding-left:15px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/blt_arrow.png) left 6px no-repeat; background-size:7px 7px; color:#000; font-size:15px; line-height:1.5em;}
.discoveryTenbyten .note ul li strong, .discoveryTenbyten .note ul li em {color:#d60c0b;font-style:normal;}
@media all and (max-width:480px){
	.discoveryTenbyten  .note ul li {padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50732/blt_arrow.png) left 5px no-repeat; background-size:4px 5px; font-size:11px;}
}
.btmBnr {border-top:2px solid #38a9c2; border-bottom:2px solid #38a9c2;}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min.js"></script>
<script type="text/javascript">
	$(function(){
		$('.slide').slidesjs({
			width:290,
			height:180,
			navigation: {effect: "fade"},
			pagination: {effect: "fade"},
			play: {interval:3000, effect: "fade", auto: true, swap: false},
			effect: {fade: {speed:1500,crossfade: true}}
		});
	});

</script>
</head>
<body>

<!-- 구매 금액별 사은이벤트 -->
<div class="mEvt50710">
	<div class="discoveryTenbyten">
		<p><a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=51155" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50734/bnr_coupon_app.png" alt="리뉴얼 기념 할인 무폰을 다운받으세요! 할인혜택 받고 구매금액별 사은품까지! - 할인쿠폰 다운로드 받기" /></a></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/50710/tit_spring.png" alt="사은품의 재발견! 리뉴얼 기념 이벤트 봄도 마음도 봄! 봄! 봄!" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/txt_spring.png" alt="푸릇푸릇! 텐텐섬에서 건강한 봄을 만나세요! 구매금액별 사은품으로 여러분의 몸도 마음도 하루하루 건강하세요! 기간 : 04.10-04.21" /></p>
		<div class="slideWrap">
			<div class="slide">
				<div><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/eventIMG/2014/50694/img_slide_01.png",580,360,"true","false")%>" alt="7만원 이상 구매시, 아이스크림 휴대용 스피커" /></div>
				<div><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/eventIMG/2014/50694/img_slide_02.png",580,360,"true","false")%>" alt="7만원 이상 구매시, 쫀득한 군고구마" /></div>
				<div><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/eventIMG/2014/50694/img_slide_03.png",580,360,"true","false")%>" alt="15만원 이상 구매시, 별밤좋은 캔들랜턴" /></div>
				<div><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/eventIMG/2014/50694/img_slide_04.png",580,360,"true","false")%>" alt="15만원 이상 구매시, 수제조청 + 스푼 SET" /></div>
				<div><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/eventIMG/2014/50694/img_slide_05.png",580,360,"true","false")%>" alt="25만원 이상 구매시, 쉐프의 허브상자 + 미니 삽 SET" /></div>
				<div><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/eventIMG/2014/50694/img_slide_06.png",580,360,"true","false")%>" alt="25만원 이상 구매시, E25gram(15개입) + 파우치 SET" /></div>
				<div><img src="<%=getThumbImgFromURL("http://webimage.10x10.co.kr/eventIMG/2014/50694/img_slide_07.png",580,360,"true","false")%>" alt="구매금액 사은품과 함께 드리는 혜택의 뭉게구름! 텐바이텐 배송 상품을 구매하신 모든 고객에게, 산돌 365종 폰트 모두 담은 산돌구름을 드립니다! 산돌 구름 플러스 3개월 이용권 (9만원 상당)" /></div>
			</div>
		</div>

		<div class="buySum">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/tit_sum_01.png" alt="7만원 이상 구매시 사은품" /></h3>
			<ul>
				<li>
					<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=888302"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_01_01.png" alt="아이스크림 휴대용 스피커 (컬러랜덤)" /></a>
					<span class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_sold_out_01.png" alt="Sold Out" /></span>
				</li>
				<li>
					<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1023480"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_01_02.png" alt="쫀득한 군고구마" /></a>
					<span class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_sold_out_01.png" alt="Sold Out" /></span>
				</li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_01_03.png" alt="텐바이텐 6천원 할인 쿠폰 : 4만원 이상 구매시 사용가능" /></li>
			</ul>

			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/tit_sum_02.png" alt="15만원 이상 구매시 사은품" /></h3>
			<ul>
				<li>
					<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=735112"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_02_01.png" alt="별밤 좋은 캔들랜턴(M)" /></a>
					<span class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_sold_out_02.png" alt="Sold Out" /></span>
				</li>
				<li>
					<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=976199"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_02_02.png" alt="수제조청 (쌀눈/고구마/모과맛 중 택1) + 스푼 SET" /></a>
					<span class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_sold_out_02.png" alt="Sold Out" /></span>
				</li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_02_03.png" alt="텐바이텐 11천원 할인 쿠폰 : 7만원 이상 구매시 사용가능" /></li>
			</ul>

			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/tit_sum_03.png" alt="25만원 이상 구매시 사은품" /></h3>
			<ul>
				<li>
					<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=1029642"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_03_01.png" alt="쉐프의 허브상자(컬러선택) + 미니 삽 SET" /></a>
					<span class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_sold_out_03.png" alt="Sold Out" /></span>
				</li>
				<li>
					<a href="http://m.10x10.co.kr/apps/appCom/wish/webview/category/category_itemPrd.asp?itemid=553501"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_03_02.png" alt="E25gram(15개입) + 파우치 SET" /></a>
					<span class="soldOut"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_sold_out_03.png" alt="Sold Out" /></span>
				</li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/img_gift_03_03.png" alt="텐바이텐 15천원 할인 쿠폰 : 9만원 이상 구매시 사용가능" /></li>
			</ul>
		</div>

		<div class="sandolFont">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/txt_sandol_font.png" alt="텐텐 배송 상품을 구매하면 무.조.건 간다! 텐텐섬의 전설 속 고대문자를 만나보세요 산돌폰트 3개월 무료 이용권 구매 금액 상관없이! 텐바이텐 배송 상품을 1개 이상 구매한 모든 고객에게 드립니다!" /></p>
			<div><a href="/apps/appcom/wish/webview/event/eventmain.asp?eventid=51082"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/btn_sandol_font.png" alt="산돌 폰트 자세히 보러 가기" /></a></div>
		</div>

		<div class="note">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/50694/txt_note.png" alt="사은품 선택 시 유의사항" /></h3>
			<ul>
				<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
				<li>텐바이텐 사은품은 한정수량이므로, 수량이 소진되었을 경우에는 원하는 사은품 선택이 어려울 수 있습니다.</li>
				<li>텐바이텐 배송상품을 구매하지 않을 경우, 할인쿠폰만 선택 가능합니다.</li>
				<li>상품 쿠폰, 보너스 쿠폰, 할인카드 등의 사용 후 <strong>구매확정 금액</strong><em>이 7만원/15만원/25만원 이상</em> 이어야 합니다.</li>
				<li>마일리지, 예치금, GIFT 카드를 사용하신 경우는 <em>구매확정금액</em>에 포함되어 사은품을 받으실 수 있습니다.</li>
				<li>한 주문 건이 구매금액 기준 이상일 때 증정하며 다른 주문에 대한 누적적용이 되지 않습니다.</li>
				<li>사은품의 경우 구매하신 텐바이텐 배송 상품과 함께 배송되며, <em>할인쿠폰은 4월 28일 일괄발급</em>됩니다. </li>
				<li>사은품 할인 쿠폰 사용은 최소구매금액 기준과 사용유효기간이 있습니다.</li>
				<li>GIFT 카드를 구매하신 경우는 사은품과 사은 쿠폰이 증정되지 않습니다.</li>
				<li>환불이나 교환 시, 최종 구매 가격이 사은품 수령 가능 금액 미만이 될 경우, 사은품과 함께 반품해야 하며, 사은쿠폰은 취소 처리됩니다. </li>
				<li>산돌 폰트 3개월 무료 이용권은 텐바이텐 배송 상품을 구매한 모든 고객님들께 텐바이텐 배송 상자에 넣어 발송됩니다.</li>
			</ul>
		</div>
	</div>
</div>
<!-- //구매 금액별 사은이벤트 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->