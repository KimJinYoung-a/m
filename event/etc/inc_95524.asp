<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 6월의 사은품
' History : 2019-06-21 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "90320"
Else
	eCode = "95524"
End If
%>
<%
'// SNS 공유용
    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

    snpTitle    = Server.URLEncode("[6월의 사은품]")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_kakao.jpg")
    appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = "[6월의 사은품]"
    Dim kakaodescription : kakaodescription = "선착순 700명에게만 드리는 레터링 유리컵 받아가세요!"
    Dim kakaooldver : kakaooldver = "선착순 700명에게만 드리는 레터링 유리컵 받아가세요!"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_kakao.jpg"
    Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.topic {position:relative;}
.topic .limited {display:inline-block; position:absolute; top:34.29%; right:24%; width:17.87%;}
.topic .limited:before {display:inline-block; position:absolute; top:-.55rem; right:-.43rem; z-index:5; width:4.57rem; height:4.57rem; background-color:#fb9885; border-radius:50%; content:''; animation:bounce 300 1s .25s;}
.limited img {position:relative; z-index:10; animation:bounce 300 1s;}
@keyframes bounce {
    from, to{margin-top:0; animation-timing-function:ease-in;}
    50% {margin-top:1rem; animation-timing-function:ease-out;}
}
.swiper2 {position:relative;}
.swiper2 .vod-area {position:absolute; top:0; left:6.5%; width:86.9%; height:100%;}
.swiper2 .vod-area iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.swiper2 .pagination {position:absolute; left:0; bottom:29.17%; width:100%; height:.77rem; padding-top:0; font-size:0; z-index:50; text-align:center;}
.swiper2 .pagination .swiper-pagination-switch {display:inline-block; width:.77rem; height:.77rem; margin:0 0.3rem; background-color:#dedede; transition:all .3s;}
.swiper2 .pagination .swiper-active-switch {background:#8292f7;}

.brand {position:relative;}
.brand ul {overflow:hidden; position:absolute; top:49%; left:0; width:100%; height:30%; padding:0 8%;}
.brand ul li {float:left; width:33.333%; height:100%;}
.brand ul li a {display:inline-block; width:100%; height:100%;}
.brand .btn-go-evt {display:inline-block; position:absolute; bottom:10%; left:0; width:100%; height:10%;}

.sns-share {position:relative;}
.sns-share ul {position:absolute; top:0; right:7.1%; height:100%; width:37.33%;}
.sns-share ul li {float:left; width:50%; height:100%;}
.sns-share ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}

.noti {padding-bottom:3.2rem; background-color:#ffca63;}
.noti ul {padding:0 8.6%;}
.noti ul li {padding:.5rem 0 .5rem 1rem; color:#281d15; font-size:1rem; line-height:1.56; font-weight:bold; text-indent:-.8rem; word-break:keep-all;}
.noti ul li a {display:inline-block; padding:0 .43rem; background-color:#ff4b4b; color:#fff; line-height:1.71rem; font-weight:normal; text-indent:0;}
</style>
<script type="text/javascript">
$(function(){
	topSwiper = new Swiper(".swiper1", {
		effect:'fade',
		autoplay:1300,
        speed:1800,
		loop:true,
	});
	swiper2 = new Swiper(".swiper2", {
		effect:'fade',
		autoplay:false,
		pagination:'.swiper2 .pagination',
		paginationClickable:true,
		loop:true
	});
});
</script>
<script>
//공유용 스크립트
	function snschk(snsnum) {		
		if(snsnum=="fb"){
			<% if isapp then %>
			fnAPPShareSNS('fb','<%=appfblink%>');
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			<% end if %>
		}else{
			<% if isapp then %>		
				fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
				return false;
			<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
			<% end if %>
		}		
	}
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		//카카오 SNS 공유
		Kakao.init('c967f6e67b0492478080bcf386390fdd');

		Kakao.Link.sendTalkLink({
			label: label,
			image: {
			src: imageurl,
			width: width,
			height: height
			},
			webButton: {
				text: '10x10 바로가기',
				url: linkurl
			}
		});
	}

	//카카오 SNS 공유 v2.0
	function event_sendkakao(label , description , imageurl , linkurl){	
		Kakao.Link.sendDefault({
			objectType: 'feed',
			content: {
				title: label,
				description : description,
				imageUrl: imageurl,
				link: {
				mobileWebUrl: linkurl
				}
			},
			buttons: [
				{
				title: '웹으로 보기',
				link: {
					mobileWebUrl: linkurl
				}
				}
			]
		});
	}
</script>
</head>
<body>            		
			<!-- 95524 6월사은품 -->
			<div class="mEvt95524">
                <div class="topic">
                    <div class="swiper swiper1">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_top_1.jpg" alt="6월의 사은품 #유리컵"></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_top_2.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_top_3.jpg" alt=""></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_top_4.jpg" alt=""></div>
                        </div>
                    </div>
                    <span class="limited"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/txt_limited.png" alt="선착순 700명"></span>
                </div>
                <div class="intro"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/txt_intro.png" alt="시원한 커피 한잔이 당기는 계절, 예쁜 유리컵 하나면 홈카페를 즐길 수 있어요. 유리컵을 받게 되면 이렇게 세팅해보세요!"></div>
                <div class="swiper swiper2">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_tag_1.jpg" alt="">
                            <div class="vod-area"><iframe src="https://player.vimeo.com/video/343617553" width="640" height="564" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div>
                        </div>
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_tag_1.jpg" alt=""></div>
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_tag_2.jpg?v=1.01" alt=""></div>
                    </div>
                    <div class="pagination"></div>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/txt_tag.png" alt="#예쁘니까 더맛있는느낌! #어렵게 준비했어요 레터링 유리컵"></div>
                </div>
                <div class="brand">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_brand.jpg" alt="레터링 유리컵을 만든 곳은 August8th(8월8일)이에요.'나를 위한 특별한 생일선물'이라는 컨셉으로 유니크한 상품들을 소개하는 라이프 스타일샵입니다. 홈카페를 좋아한다면 꼭 둘러보세요!">
                    <ul>
                        <li><a href="/category/category_itemPrd.asp?itemid=2145133&pEtr=95524" onclick="TnGotoProduct('2145133');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2394175&pEtr=95524" onclick="TnGotoProduct('2394175');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2369483&pEtr=95524" onclick="TnGotoProduct('2369483');return false;"></a></li>
                    </ul>
                    <a href="/event/eventmain.asp?eventid=95488" onclick="jsEventlinkURL(95488);return false;" class="btn-go-evt"></a>
                </div>
                <a href="/event/eventmain.asp?eventid=89269" onclick="jsEventlinkURL(89269);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/bnr_tenten_delievery.jpg" alt="텐바이텐 배송 상품 보러 가기"></a>
                <!-- sns 공유하기 -->
                <div class="sns-share">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/img_sns_share.jpg" alt="친구들에게도 6월 사은품을 알려주세요!">
                    <ul>
                        <li><a href="javascript:snschk('fb')">페이스북공유</a></li>
                        <li><a href="javascript:snschk('ka')">카카오톡공유</a></li>
                    </ul>
                </div>
                <div class="noti">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/95524/m/tit_noti.png" alt="유의사항"></h3>
                    <ul>
                        <li>- 본 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
                        <li>- 사은품은 텐바이텐 배송상품을 포함한 구매확정 금액이 6만원 이상이어야 선택이 가능합니다.  <a href="/event/eventmain.asp?eventid=89269" onclick="jsEventlinkURL(89269);return false;">텐바이텐 배송상품 보러가기 &gt;</a></li>
                        <li>- 구매확정 금액은 쿠폰, 할인카드 등을 적용한 최종 금액입니다. (마일리지/기프트카드/예치금 적용항목에서 제외입니다.)</li>
                        <li>- 사은품은 텐바이텐 배송 상품과 함께 배송됩니다.</li>
                        <li>- 환불이나 교환으로 인해 최종 구매 가격이 6만원 미만이 될 경우, 사은품도 함께 반품되어야 합니다.</li>
                        <li>- 텐바이텐 기프트카드 상품을 구매하는 경우에는 사은품 증정 대상이 아닙니다.</li>
                        <li>- 사은품이 모두 소진될 경우 이벤트는 조기 마감될 수 있습니다.</li>
                        <li>- 유리컵 레터링의 색상은 랜덤으로 증정됩니다.</li></li>
                    </ul>
                </div>
			</div>
			<!-- 95524 6월사은품 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->