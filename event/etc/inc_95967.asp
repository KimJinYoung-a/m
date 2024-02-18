<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 7월의 사은품
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
	eCode = "95967"
End If
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[7월의 사은품]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[7월의 사은품]"
	Dim kakaodescription : kakaodescription = "선착순 2,500명에게만 드리는 PVC 파우치 받아가세요!"
	Dim kakaooldver : kakaooldver = "선착순 2,500명에게만 드리는 PVC 파우치 받아가세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.topic {position:relative;}
.topic .limited {position:absolute; top:31.63%; right:15.33%; width:17.87%;}
.topic .limited:before {position:absolute; top:-9%; right:-9%; z-index:5; width:80%; height:80%; background-color:#8fffc9; border-radius:50%; content:''; animation:bounce 300 1s .25s;}
.limited img {position:relative; z-index:10; animation:bounce 300 1s;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(1rem); animation-timing-function:ease-out;}
}
.instagram {position:relative;}
.swiper2 {position:relative;}
.swiper2 .pagination {position:absolute; left:0; bottom:-8.3%; z-index:10; width:100%; height:auto; padding-top:0;}
.swiper2 .pagination .swiper-pagination-switch {width:9px; height:9px; background-color:#dedede;}
.swiper2 .pagination .swiper-active-switch {background-color:#8292f7;}
.disney {position:relative;}
.disney ul {position:absolute; top:40%; left:0; width:100%; height:33%; padding:0 8%;}
.disney ul li {float:left; width:33.3%; height:100%;}
.disney ul li a {display:block; width:100%; height:100%; font-size:0; color:transparent;}
.disney .btn-go-evt {position:absolute; bottom:8%; left:0; width:100%; height:15%; font-size:0; color:transparent;}
.sns-share {position:relative;}
.sns-share ul {position:absolute; top:0; right:7.1%; height:100%; width:37.33%;}
.sns-share ul li {float:left; width:50%; height:100%;}
.sns-share ul li a {display:block; width:100%; height:100%; text-indent:-999em;}
.noti {padding-bottom:3.2rem; background-color:#3a78fa;}
.noti ul {padding:0 8.6%;}
.noti ul li {position:relative; padding:.5rem 0 .5rem 1rem; color:#fff; font-size:1.07rem; line-height:1.56; word-break:keep-all;}
.noti ul li:before {content:'-'; position:absolute; left:.2rem; top:.4rem;}
.noti ul li a {display:inline-block; padding:0 .43rem; background-color:#ff4ba0; color:#fff; line-height:1.71rem;}
</style>
<script type="text/javascript">
$(function(){
	topSwiper = new Swiper(".swiper1", {
		effect:'fade',
		autoplay:2000,
		speed:1,
		loop:true,
	});
	swiper2 = new Swiper(".swiper2", {
		autoplay:2000,
		speed:500,
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
			<!-- 95967 7월의 사은품 -->
			<div class="mEvt95967">
				<div class="topic">
					<div class="swiper swiper1">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_top_1.jpg" alt="7월의 사은품 #파우치"></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_top_2.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_top_3.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_top_4.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_top_5.jpg" alt=""></div>
						</div>
					</div>
					<span class="limited"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/txt_limited.png" alt="선착순 2,500명"></span>
				</div>
				<div class="instagram">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/txt_intro.jpg" alt="파우치 하나 바꿨을 뿐인데"></p>
					<div class="swiper swiper2">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_slide_1.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_slide_2.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_slide_3.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_slide_4.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_slide_5.jpg" alt=""></div>
							<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_slide_6.jpg" alt=""></div>
						</div>
						<div class="pagination"></div>
					</div>
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/txt_tag.jpg" alt="#투명파우치 #PVC파우치 #디즈니"></p>
				</div>
				<div class="disney">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_brand.jpg" alt="디즈니 X 텐바이텐">
					<ul>
						<li><a href="/category/category_itemPrd.asp?itemid=2367258&pEtr=95967" onclick="TnGotoProduct('2367258');return false;">디즈니 PVC 투명파우치 M</a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=2367260&pEtr=95967" onclick="TnGotoProduct('2367260');return false;">디즈니 PVC 투명파우치 L</a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=2367260&pEtr=95967" onclick="TnGotoProduct('2367260');return false;">디즈니 PVC 투명파우치 L</a></li>
					</ul>
					<a href="/event/eventmain.asp?eventid=95995" onclick="jsEventlinkURL(95995);return false;" class="btn-go-evt">디즈니 상품 더 보러가기</a>
				</div>
				<a href="/event/eventmain.asp?eventid=89269" onclick="jsEventlinkURL(89269);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/bnr_tenten_delievery.jpg" alt="텐바이텐 배송 상품 보러가기"></a>
				<!-- SNS 공유 -->
				<div class="sns-share">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/img_share.jpg" alt="친구들에게도 7월 사은품 알려주기">
					<ul>
						<li><a href="javascript:snschk('fb')">페이스북 공유</a></li>
						<li><a href="javascript:snschk('ka')">카카오톡 공유</a></li>
					</ul>
				</div>
				<div class="noti">
					<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/95967/m/tit_noti.jpg" alt="유의사항"></h3>
					<ul>
						<li>본 이벤트는 텐바이텐 회원님을 위한 혜택입니다. <br>(비회원 구매 증정 불가)</li>
						<li>사은품은 텐바이텐 배송상품을 포함한 구매확정 금액이 4만원 이상이어야 선택이 가능합니다. <a href="/event/eventmain.asp?eventid=89269" onclick="jsEventlinkURL(89269);return false;">텐바이텐 배송상품 보러가기 &gt;</a></li>
						<li>구매확정 금액은 쿠폰, 할인카드 등을 적용한 최종 금액입니다. (마일리지/기프트카드/예치금 적용항목에서 제외입니다.)</li>
						<li>사은품은 텐바이텐 배송 상품과 함께 배송됩니다.</li>
						<li>환불이나 교환으로 인해 최종 구매 가격이 4만원 미만이 될 경우, 사은품도 함께 반품되어야 합니다.</li>
						<li>텐바이텐 기프트카드 상품을 구매하는 경우에는 사은품 증정 대상이 아닙니다.</li>
						<li>사은품이 모두 소진될 경우 이벤트는 조기 마감될 수 있습니다.</li>
						<li>PVC 파우치의 색상 및 캐릭터는 랜덤으로 증정됩니다.</li>
					</ul>
				</div>
			</div>
			<!-- 95967 7월의 사은품 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->