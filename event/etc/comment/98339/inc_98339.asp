<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 너와 나의 2020년을 응원해
' History : 2019-10-30
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim evtStartDate, evtEndDate, currentDate, presentDate
dim debugMode
debugMode = request("debugMode")

dim eCode, couponIdx, couponType
'test
'currentDate = Cdate("2019-12-31")

IF application("Svr_Info") = "Dev" THEN
	eCode   =  90419
	couponIdx = "2903"
Else
	eCode   =  98339
	couponIdx = "1228"
End If
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[너와 나의 2020년을 응원해!]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_share_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[너와 나의 2020년을 응원해!]"
	Dim kakaodescription : kakaodescription = "지금 텐바이텐에서 이벤트 참여하면 나와 내 친구들 모두에게 다이어리를 드려요!"
	Dim kakaooldver : kakaooldver = "지금 텐바이텐에서 이벤트 참여하면 나와 내 친구들 모두에게 다이어리를 드려요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_share_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt98339 button {background-color:transparent;}

.mEvt98339 .girl-top {position:relative;}
.mEvt98339 .girl-top h2 {position:absolute; top:14.14%; left:0; width:100%;}
.mEvt98339 .girl-top h2 span {display:block; opacity:0; transform:translateY(2rem);}
.mEvt98339 .girl-top h2 .t2 {margin:1.71rem 0 1.28rem;}
.mEvt98339 .girl-top h2 .t4 {margin-top:1.9rem;}
.mEvt98339 .girl-top.on h2 span {opacity:1; transform:translateY(0); transition:.5s; transition-delay:.3s;}
.mEvt98339 .girl-top.on h2 .t2 {transition-delay:.5s;}
.mEvt98339 .girl-top.on h2 .t3 {transition-delay:.7s;}
.mEvt98339 .girl-top.on h2 .t4 {transition-delay:.9s;}

.mEvt98339 .girl-slide {position:relative; padding-bottom:5rem; background-color:#fff;}
.mEvt98339 .girl-slide .vod-slide iframe {width:100%; height:100%;}
.mEvt98339 .girl-slide .pagination {position:absolute; bottom:6.3%; left:0; z-index:10; width:100%; height:1rem; padding-top:0; }
.mEvt98339 .girl-slide .pagination span {width:.8rem; height:.8rem; margin:0 .34rem; border:solid .17rem #000; background-color:transparent;}
.mEvt98339 .girl-slide .pagination .swiper-active-switch {background-color:#000;}

.mEvt98339 .gift {position:relative; background-color:#fff0f0;}
.mEvt98339 .gift .gift-item {margin-top:9.6rem;}

.mEvt98339 .picked {padding-bottom:4.91rem; background-color:#fff;}
.mEvt98339 .picked-slide .swiper-slide {width:48% !important; margin:0 .55rem;}
.mEvt98339 .picked-slide .swiper-slide:first-child {margin-left:1.62rem;}
.mEvt98339 .picked-slide .swiper-slide:last-child {margin-right:1.62rem;}

.mEvt98339 .sns {position:relative;}
.mEvt98339 .sns ul {display:flex; width:26.6%; height:100%; justify-content:space-between; position:absolute; top:0; right:7.6%;}
.mEvt98339 .sns ul li {flex-basis:50%; height:100%;}
.mEvt98339 .sns ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}

.cmt-area {background-color:#fff;}
.cmt-area .cmt-write .btn-submit {width:100%;}
.cmt-area .cmt-write .input-box {overflow:hidden; display:flex; align-items:center; width:26.45rem; height:3.63rem; margin:1.07rem auto 0; padding-left:1.28rem; background-color:#fff; border-radius:.43rem; border:solid .085rem #3e47b2;}
.cmt-area .cmt-write .input-box input {width:14.52rem; height:100%; padding:0 1.62rem; border:0; border-radius:0; color:#222; font-size:1.49rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.cmt-area .input-box input::-webkit-input-placeholder,.cmt-area .input-box textarea::-webkit-input-placeholder {color:#999;}
.cmt-area .input-box input::-moz-placeholder,.cmt-area .input-box textarea::-moz-placeholder {color:#999;}
.cmt-area .input-box input:-ms-input-placeholder,.cmt-area .input-box textarea:-ms-input-placeholder {color:#999;}
.cmt-area .input-box input:-moz-placeholderm,.cmt-area .input-box textarea:-moz-placeholder {color:#999;}
.cmt-area .cmt-write .input-box button {margin-left:auto;}
.cmt-area .cmt-write .input-box span {display:inline-block; width:3.88rem;}
.cmt-area .cmt-write .input-grp {margin-top:0;}
.cmt-area .cmt-write .input-num {color:#000; font-size:1.49rem; font-weight:bold;}
.cmt-area .cmt-write .input-num input {width:5rem; padding-right:.85rem; text-align:right;}
.cmt-area .cmt-write .input-reason {position:relative; align-items:flex-start; height:auto; padding:1.07rem;}
.cmt-area .cmt-write .input-reason span {width:2.56rem; margin-top:.4rem;}
.cmt-area .cmt-write .input-reason textarea {width:100%; padding:0; padding-left:2.82rem; border:0; border-radius:0; font-size:1.49rem;}
.cmt-area .cmt-write .input-reason .txt-num {position:absolute; bottom:.85rem; right:1.92rem; color:#888; font-size:1.11rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.cmt-area .cmt-write .btn-chck {width:6.87rem;}

.cmt-area .search-section {position:relative; margin:0 1.71rem; background-color:#f8d4d8;}
.cmt-area .search-section .input-box {display:flex; justify-content:center; position:absolute; top:36.55%; left:50%; width:26.45rem; height:4.05rem; margin-left:-13.23rem;}
.cmt-area .search-section .input-box input {width:16.47rem; height:100%; padding:0 1.28rem; border:0; border-radius:.38rem 0 0 .38rem; font-size:1.28rem;}
.cmt-area .search-section .btn-search {width:5.55rem; height:100%;}

.cmt-area .cmt-list ul {width:32rem; padding:2.99rem 1.49rem 3.41rem; margin:0 auto;}
.cmt-area .cmt-list ul li {position:relative; height:31.36rem; padding:1.92rem; margin-top:1.71rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/bg_cmt1.png); background-repeat:no-repeat; background-size:100% 100%;}
.cmt-area .cmt-list ul li:first-child {margin-top:0;}
.cmt-area .cmt-list ul li:nth-child(4n-2) {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/bg_cmt2.png);}
.cmt-area .cmt-list ul li:nth-child(4n-1) {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/bg_cmt3.png);}
.cmt-area .cmt-list ul li:nth-child(4n) {background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/bg_cmt4.png);}
.cmt-area .cmt-list li > div span {color:#3740af;}
.cmt-area .cmt-list li .cmt-grp {margin-left:.51rem; margin-top:1.49rem; font-size:1.53rem; line-height:1.5; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; letter-spacing:-.04rem;}
.cmt-area .cmt-list li .cmt-grp .name {color:#eb0074;}
.cmt-area .cmt-list li .cmt-reason {overflow:hidden; height:11.95rem; margin-top:3.41rem; padding:1.6rem 1.19rem; background-color:#fff; font-size:1.19rem; line-height:1.57; font-family:'AvenirNext-Medium', 'AppleSDGothicNeo-Medium';}
.cmt-area .cmt-list li .share {margin-top:1.75rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; line-height:1.66rem; text-align:right;}
.cmt-area .cmt-list li .share .btn-share {display:inline-block; position:relative; width:6.14rem; height:1.66rem; margin-left:.43rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_share.png); background-repeat:no-repeat; background-size:100%; text-indent:-999em;}
.cmt-area .cmt-list li .smile-wrap {position:absolute; top:1.71rem; right:1.93rem; font-size:1.28rem; text-align:center; color:#e61587; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.cmt-area .cmt-list li .smile-wrap .count {display:none; position:absolute; top:0; left:0; width:100%; font-size:1.28rem; text-align:center; animation:countUp2 0.2s both;}
.cmt-area .cmt-list li .smile-wrap.is-touched .count {animation:countUp1 0.8s;}
.cmt-area .cmt-list li .smile-wrap .click {position:absolute; top:0; left:0; width:100%; font-size:1.28rem; text-align:center; animation:swing 1s infinite linear; transform-origin:50% 250%;}
.cmt-area .cmt-list li .smile-wrap .btn-smile i {display:block; width:4.35rem; height:4.35rem; margin-top:1.91rem; margin-bottom:.6rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/ico_smile.png); background-repeat:no-repeat; background-size:100%; text-indent:-999em;}
.cmt-area .cmt-list li .smile-wrap .btn-smile span {color:#000; font-size:1.37rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold;}
.cmt-area .cmt-list li .btn-delete {position:absolute; top:1.28rem; right:1.25rem; width:1.41rem; height:1.41rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_delete.png); background-repeat:no-repeat; background-size:100%; text-indent:-999em;}
.cmt-area .pagingV15a {margin-top:0; padding-bottom:4.48rem;}
.cmt-area .pagingV15a a {position:relative; padding-top:0; color:#ff8c69; font-size:1.58rem;}
.cmt-area .pagingV15a .current a {color:#3740af;}
.cmt-area .pagingV15a .arrow a:after {left:50%; top:50%; width:.68rem; height:1.15rem; margin:-.58rem 0 0 -.34rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_next.png) 0 0 no-repeat; background-size:100% 100%;}
.cmt-area .btn-more {width:100%; padding-bottom:5rem; text-align:center;}
.cmt-area .btn-more img {width:29.01rem; }

.lyr-share, .lyr-smile, .lyr-kit  {position:fixed; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,.8);}
.lyr-share .inner {position:relative; width:29.01rem; margin:5.12rem auto 0;}
.lyr-share .inner ul {display:flex; justify-content:space-between; position:absolute; top:64.37%; left:50%; width:71.47%; height:21.71%; margin-left:-35.74%;}
.lyr-share .inner ul li {width:33.33%;}
.lyr-share .inner ul li a{display:inline-block; width:100%; height:100%; text-indent:-999em;}
.lyr-share .btn-close {position:absolute; top:1.28rem; right:1.25rem; width:1.41rem; height:1.41rem; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/btn_close.png); background-repeat:no-repeat; background-size:100%; text-indent:-999em;}
.lyr-share .btn-cp {position:relative; top:-1rem;}

.lyr-smile .inner {width:15.23rem; margin:0 auto;}
.lyr-smile .inner .smile {display:inline-block; position:relative; margin-top:16.89rem;}
.lyr-smile .inner .smile > img {animation:wink 1s infinite linear; opacity:0;}
.lyr-smile .inner .smile i {position:absolute; top:0; left:0; opacity:0; animation:wink 1s infinite; animation-direction:reverse;}
.lyr-smile .inner .smile .dc {display:inline-block; position:absolute; top:-2.3rem; left:50%; width:.64rem; height:1.58rem; margin-left:2.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_spark.png)no-repeat 50% 50%/100%; animation:blink 1s infinite;}
.lyr-smile .inner .smile .dc2 {top:-2.13rem; margin-left:5.01rem; transform:rotate(30deg); animation-delay:.3s;}
.lyr-smile .inner .smile .dc3 {top:-.3rem; margin-left:6.27rem; transform:rotate(60deg); animation-delay:.5s;}
@keyframes swing {
    0% {transform:rotate(0deg);}
    25% {transform:rotate(-20deg);}
    50% {transform:rotate(0deg);}
    75% {transform:rotate(20deg);}
    100% {transform:rotate(0);}
}
@keyframes wink {
    from {opacity:0;}
    49.999% {opacity:0;}
    50%{opacity:1;}
    99.999% {opacity:1;}
    to  {opacity:0;}
}
@keyframes blink {
    from {opacity:1;}
    50%  {opacity:0;}
    to {opacity:1;}
}
@keyframes countUp1 {
	0% {
		-webkit-transform:scaleX(0.9) translateY(1rem);
		transform:scaleX(0.9) translateY(1rem);
		opacity:0;
	}
	10%,100% {
		-webkit-transform:scaleX(1) translateY(0);
		transform:scaleX(1) translateY(0);
		opacity:1;
	}
}
@keyframes countUp2 {
	0% {
		-webkit-transform:translateY(0);
		transform:translateY(0);
		opacity:1;
	}
	100% {
		-webkit-transform:translateY(-2rem);
		transform:translateY(-2rem);
		opacity:0;
	}
}
</style>
<script src="https://cdn.jsdelivr.net/npm/clipboard@2/dist/clipboard.min.js"></script>
<script type="text/javascript">
var isapp = '<%=isapp%>'
var eventCode = '<%=eCode%>'
var couponIdx = '<%=couponIdx%>'
$(function() {
    $('.mEvt98339 .girl-top').addClass('on');
	$(".mEvt98339 .btn-share").click(function(){
		$(".mEvt98339 .lyr-share").show();
	});
    $(".mEvt98339 .btn-close").click(function(){
		$(this).parent().parent().hide();
	});
    slideTemplate = new Swiper('.girl-slide',{
        loop:true,
        //autoplay:3000,
        autoplayDisableOnInteraction:false,
        speed:800,
        pagination:".girl-slide .pagination",
        paginationClickable:true
    });
    slideTemplate = new Swiper('.picked-slide',{
        autoplay:3000,
        speed:800,
        slidesPerView:'auto'
    });
});
function sharesns(snsnum) {
		if(snsnum=="fb"){
			<% if isapp then %>
			fnAPPShareSNS('fb','<%=appfblink%>');
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			<% end if %>
		}else if(snsnum=="tw"){
			popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=kakaodescription%>');return false;
		}else{
			<% if isapp then %>
				fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
				return false;
			<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );
			<% end if %>
		}
}
</script>
<!-- 98339 다이어리 -->
<div class="mEvt98339">
	<div class="girl-top">
		<h2>
			<span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_my_girl1_v2.png" alt="텐바이텐 다이어리 배달 프로젝트"></span>
			<span class="t2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_my_girl2_v2.png" alt="너와 나의"></span>
			<span class="t3"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_my_girl3_v2.png" alt="2020년을 응원해"></span>
			<span class="t4"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_my_girl4_v2.png" alt="다가오는 2020년은 더  반짝이기를! 텐바이텐 X 오마이걸 한정판 다이어리 키트1000개를  선물합니다!"></span>
		</h2>
		<img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/bg_top.jpg?v=1.01" alt="발표 : 19. 12. 20">
	</div>
	<div class="brand-story">
		<div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/txt_prj.png" alt="10X10 DIARY PROJECT"></div>
		<div class="behind-cut">
			<h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_behind.png" alt="텐바이텐 X 오마이걸 Behind Cut"></h3>
			<div class="girl-slide swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide vod-slide"><iframe src="https://www.youtube.com/embed/PpD3X1_txxA" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl9.jpg" alt=""></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl1_v2.jpg" alt=""></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl2_v2.jpg" alt=""></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl3_v2.jpg" alt=""></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl4_v2.jpg" alt=""></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl5_v2.jpg" alt=""></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl6_v2.jpg" alt=""></div>
					<div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_girl7_v2.jpg" alt=""></div>
				</div>
				<div class="pagination"></div>
			</div>
		</div>
	</div>
	<div class="picked">
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_pick_v2.png" alt="오마이걸이 Pick한 다이어리를 만나보세요!"></p>
		<div class="picked-slide swiper-container">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2510594&pEtr=98339" onclick="TnGotoProduct('2510594');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_pick1_v2.jpg" alt="효정’s Pick"></a></div>
				<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2488134&pEtr=98339" onclick="TnGotoProduct('2488134');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_pick2_v2.jpg" alt="미미’s Pick"></a></div>
				<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2110036&pEtr=98339" onclick="TnGotoProduct('2110036');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_pick3_v2.jpg" alt="유아’s Pick"></a></div>
				<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2512749&pEtr=98339" onclick="TnGotoProduct('2512749');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_pick4_v2.jpg" alt="승희’s Pick"></a></div>
				<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2209032&pEtr=98339" onclick="TnGotoProduct('2209032');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_pick5_v2.jpg" alt="지호’s Pick"></a></div>
				<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2542576&pEtr=98339" onclick="TnGotoProduct('2542576');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_pick6_v2.jpg" alt="비니’s Pick"></a></div>
				<div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2523735&pEtr=98339" onclick="TnGotoProduct('2523735');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_slide_pick7_v2.jpg" alt="아린’s Pick"></a></div>
			</div>
		</div>
	</div>
	<div class="sns">
		<img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_sns.png" alt="텐바이텐 SNS에서 오마이걸의 다꾸 + 비하인드컷을 만나보세요">
		<ul class="mWeb">
			<li><a href="https://tenten.app.link/e/ItiIOmdzz1" target="_blank">텐바이텐 페이스북으로 이동</a></li>
			<li><a href="https://tenten.app.link/bKLCGT1Cz1" target="_blank">텐바이텐 인스타그램으로 이동</a></li>
		</ul>
		<ul class="mApp">
			<li><a href="" onclick="fnAPPpopupExternalBrowser('https://tenten.app.link/e/ItiIOmdzz1');return false;">텐바이텐 페이스북으로 이동</a></li>
			<li><a href="" onclick="fnAPPpopupExternalBrowser('https://tenten.app.link/bKLCGT1Cz1');return false;">텐바이텐 인스타그램으로 이동</a></li>
		</ul>
	</div>
	<div class="gift">
		<h4><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/tit_gif_v2.png" alt="이벤트 선물"></h4>
		<div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_gift_v2.jpg" alt="선물1 나와 친구 모두에게 2020 다이어리 KIT (1,000명) 선물2 오마이걸 사인 다이어리 (7명) 선물3 3천원 할인 쿠폰 (모두)"></div>
	</div>
    <div class="cmt-area">
        <div id="app"></div>
    </div>
	<% If isapp = "1" Then %>									
	<div class="related-bnr">
		<ul>			
			<li class="mApp"><a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_eventtop_banner','eventcode|etc','<%=ecode%>|1', function(bool){if(bool) {fnAPPpopupBrowserURL('2020 다이어리','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2020/');return false;}});"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_bnr1.jpg" alt="다이어리 스토리"></a></li>
			<li><a href="javascript:fnAmplitudeEventMultiPropertiesAction('click_eventtop_banner','eventcode|etc','<%=ecode%>|2', function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97607'); return false;}});" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_bnr2.jpg" alt="텐바이텐은 처음이지? 기획전"></a></li>
		</ul>
	</div>			
	<% Else %>
	<div class="related-bnr">
		<ul>
			<li class="mWeb"><a href="http://m.10x10.co.kr/diarystory2020/" onclick="fnAmplitudeEventMultiPropertiesAction('click_eventtop_banner','eventcode|etc','<%=ecode%>|1')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_bnr1_v2.jpg" alt="다이어리 스토리"></a></li>
			<li><a href="/event/eventmain.asp?eventid=99222" onclick="fnAmplitudeEventMultiPropertiesAction('click_eventtop_banner','eventcode|etc','<%=ecode%>|2')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98339/m/img_bnr2_v2.jpg" alt="텐바이텐은 처음이지? 기획전"></a></li>
		</ul>
	</div>
	<% End If %>



</div>
<!--// 98339 다이어리 -->


<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<% IF application("Svr_Info") = "Dev" or debugMode = 1 THEN %>
<script src="https://unpkg.com/vue"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/common/util-components/like-icon.js?v=1.02"></script>
<script src="/event/etc/comment/98339/list-98339.js?v=1.01"></script>
<script src="/vue/event/comment/list/comment-container.js?v=1.0"></script>
<script src="/event/etc/comment/98339/index-98339.js?v=1.01"></script>