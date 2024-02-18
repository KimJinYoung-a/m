<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY #32-1
' History : 2016-07-01 김진영 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66164
Else
	eCode   =  71707
End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("주얼리를 보는 색다른 시선! 반짝이는 상상!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/play/playGround.asp?idx=1403&contentsidx=130")
snpPre		= Server.URLEncode("텐바이텐")
snpTag		= Server.URLEncode("텐바이텐")
snpTag2		= Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐]반짝이는 상상\n\n주얼리를 보는 색다른 시선!\n\n평소 나의 모습을 반짝여주던 보석,노트 한켠에 무심코 그려뒀던 소소한 일러스트!\n\n이 둘이 만나면 어떤 모습일까요?\n\n보석과 일러스트가 만나 보여주는 색다른 모습을 함께 해주세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/playmo/ground/20160704/201607_ground_Jewlery1_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1403&contentsidx=130"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/play/playGround.asp?idx=1403&contentsidx=130"
end If

%>
<style type="text/css">
img {vertical-align:top;}
.mJewelry1 .section {position:relative; overflow:hidden; background:url(http://webimage.10x10.co.kr/playmo/ground/20160704/bg_jewelry.png) 50% 0 no-repeat; background-size:100%;}
.mJewelry1 a {overflow:hidden; display:block; position:absolute; text-indent:-999em; z-index:50; background-color:rgba(0,0,0,0);}
.mJewelry1 a.item01 {left:0; top:21%; width:100%; padding-bottom:76.25%;}
.mJewelry1 a.item02 {left:0; top:41%; width:35%; padding-bottom:60%;}
.mJewelry1 a.item03 {right:0; top:48%; width:40%; padding-bottom:55%;}
.mJewelry1 a.item04 {left:30%; top:61%; width:30%; padding-bottom:43%;}
.mJewelry1 a.item05 {left:29%; top:84%; width:28%; padding-bottom:33%;}
.mJewelry1 a.item06 {left:34%; top:3%; width:33%; padding-bottom:50%;}
.mJewelry1 a.item07 {left:28%; top:31%; width:33%; padding-bottom:50%;}
.mJewelry1 a.item08 {left:11%; top:16%; width:30%; padding-bottom:65%;}
.mJewelry1 a.item09 {right:1%; top:65%; width:46%; padding-bottom:40%;}
.mJewelry1 a.item10 {left:53%; top:9%; width:20%; padding-bottom:20%;}
.mJewelry1 a.item11 {left:13%; top:28%; width:23%; padding-bottom:23%;}
.mJewelry1 a.item12 {left:52%; top:45%; width:22%; padding-bottom:22%;}
.mJewelry1 a.item13 {left:0; top:58%; width:83%; padding-bottom:58%;}

.titSec {text-align:center;}
.titSec h2 {position:absolute; left:50%; top:17.2%; width:63.59375%; margin-left:-31.796875%;}
.titSec p {position:absolute; left:50%; top:50.5%; width:68.59375%; margin:3.6rem 0 0 -34.296875%;}
.titSec span {display:block; position:absolute; background-repeat:no-repeat; background-position:50% 0; background-size:100%;}
.titSec span.shooting1 {left:55%; top:0; width:11.71875%; height:17.25%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting1.png); animation:1.3s shooting 5 ease-in-out alternate;}
.titSec span.shooting2 {left:63.2%; top:-0.2rem; width:10.46875%; height:15.35%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting2.png); animation:1s shooting 5 ease-in-out alternate;}
.titSec span.shooting3 {left:69%; top:-0.6rem; width:11.875%; height:17.5%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting3.png); animation:0.5s shooting 5 ease-in-out alternate;}
.titSec span.shooting4 {left:81%; top:-1.1rem; width:12.34375%; height:19.9%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting4.png); animation:1.2s shooting 5 ease-in-out alternate;}
.titSec span.star1 {left:60%; top:0.8%; width:2.1875%; height:2.05%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star.png); animation:1.5s twinkle infinite ease-out; animation-fill-mode:both;}
.titSec span.star2 {left:73%; top:20%; width:2.1875%; height:2.05%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star.png); animation:2s twinkle infinite ease-out; animation-fill-mode:both;}
.titSec span.star3 {left:90%; top:9%; width:2.1875%; height:2.05%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star.png); animation:0.5s twinkle infinite ease-out; animation-fill-mode:both;}
@keyframes shooting {
	0% {height:0; opacity:0;}
	100% {height:19.9%; opacity:1;}
}
@keyframes twinkle {
	0% {opacity:0;}
	50% {opacity:1;}
	100% {opacity:0;}
}

.itemCircus h3 {position:absolute; left:50%; top:37.2%; width:64.84375%; margin-left:-32.421875%;}
.itemCircus h3.flip {animation-name:flip; animation-duration:1.2s; animation-iteration-count:2; backface-visibility:visible;}
.itemCircus span {display:block; position:absolute; left:0; top:1.7%; width:100%;}
.itemCircus span.balloon1 {animation-duration:2.5s;}
.itemCircus span.balloon2 {animation-duration:4s;}
.itemCircus span.balloon3 {animation-duration:2s;}
.itemCircus span.balloon {animation-name:balloon; animation-iteration-count:5; animation-timing-function:ease-out; animation-direction:alternate; animation-fill-mode:both;}
.itemCircus em {display:block; position:absolute; right:4%; top:66%; width:27.8125%;}
.itemCircus em.twinkle {animation:1s twinkle infinite ease-in-out; animation-fill-mode:both;}

@keyframes balloon {
	0% {margin-top:0;}
	50% {margin-top:-10px;}
	100% {margin-top:0;}
}
@keyframes flip {
	0% {transform:rotateY(180deg); animation-timing-function:ease-out;}
	100% {transform:rotateY(360deg); animation-timing-function:ease-in;}
}

.itemMusic span {overflow:hidden; display:block; position:absolute; right:0; top:14.1%; width:46.875%;}

.itemSea h3 {display:block; position:absolute; left:18.75%; top:46%; width:21.5625%;}
.itemSea h3.bounce {animation:2.5s bounce1 infinite ease-out alternate; animation-fill-mode:both;}
@keyframes bounce1 {
	0% {margin-top:0;}
	50% {margin-top:-10px;}
	100% {margin-top:0;}
}
.itemSea .lalala {display:block; position:absolute; left:29.6875%; top:1%; width:24.0625%; padding-bottom:65%; background:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_lalala.png) 50% 0 no-repeat; background-size:100%; text-align:right;}
.itemSea .lalala img {width:49.35%;}
.itemSea em {display:block; position:absolute;}
.itemSea em.drop1 {left:16%; top:41%; width:2.03125%;}
.itemSea em.drop2 {left:30%; top:39%; width:1.71875%;}
.itemSea em.drop3 {left:14%; top:43%; width:5%;}
.itemSea em.drop4 {left:29%; top:40%; width:5.46875%;}
.itemSea em.drop5 {left:12%; top:73%; width:12.03125%;}

.itemSpace span {display:block; position:absolute; background-repeat:no-repeat; background-position:50% 0; background-size:100%;}
.itemSpace span.shooting5 {left:31.5625%; top:11.3%; width:13.28125%; height:14.8%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting5.png); animation:1.3s shooting2 5 ease-in-out alternate;}
.itemSpace span.shooting6 {left:44.6875%; top:6.8%; width:11.71875%; height:13.6%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting6.png); animation:1s shooting2 5 ease-in-out alternate;}
.itemSpace span.shooting7 {left:49.2%; top:1.8%; width:17.5%; height:20.7%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting7.png); animation:0.5s shooting2 5 ease-in-out alternate;}
.itemSpace span.shooting8 {left:71.09375%; top:4.5%; width:12.96875%; height:17%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_shooting8.png); animation:0.7s shooting2 5 ease-in-out alternate;}
@keyframes shooting2 {
	0% {height:0; opacity:0;}
	100% {height:20.7%; opacity:1;}
}
.itemSpace em {display:block; position:absolute; background-repeat:no-repeat; background-position:50% 0; background-size:100%; animation-name:twinkle; animation-iteration-count:infinite; animation-timing-function:ease-out; animation-fill-mode:both;}
.itemSpace em.star4 {left:7.6%; top:16%; width:7.96875%; height:4.3%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star2.png); animation-duration:1s;}
.itemSpace em.star5 {left:26%; top:27%; width:3.6%; height:1.8%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star3.png); animation-duration:0.7s;}
.itemSpace em.star6 {left:5.9375%; top:38.7%; width:4.21875%; height:2%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star4.png); animation-duration:1.5s;}
.itemSpace em.star7 {left:56.25%; top:3.1%; width:2.1875%; height:1.6%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star.png); animation-duration:0.5s;}
.itemSpace em.star8 {left:50%; top:8.3%; width:2.1875%; height:1.6%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star.png); animation-duration:1s;}
.itemSpace em.star9 {left:62.1875%; top:23.9%; width:2.1875%; height:1.6%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star.png); animation-duration:1.1s;}
.itemSpace em.star10 {left:79.375%; top:14.8%; width:2.1875%; height:1.6%; background-image:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_star.png); animation-duration:0.4s;}

div.snsShare a {overflow:hidden; display:block; position:absolute; top:61%; width:18%; height:25%; text-indent:-999em;}
div.snsShare a.snsFb {left:9%;}
div.snsShare a.snsKt {left:28%;}
div.snsShare .line {display:block; position:absolute; left:9.6%; top:44.5%; width:61%; height:1.5%; background:url(http://webimage.10x10.co.kr/playmo/ground/20160704/deco_line.png) 0 0 no-repeat; background-size:100%;}
</style>
<script type="text/javascript">
$(function(){
	/* animation */
	$(window.parent).scroll(function(){
		var scrollTop = $(window.parent).scrollTop();
		if (scrollTop > 650) {
			$('.itemCircus span').addClass('balloon');
		}
		if (scrollTop > 700) {
			$(".itemCircus h3").addClass("flip");
		}
		if (scrollTop > 800) {
			$(".itemCircus em").addClass("twinkle");
		}
		if (scrollTop > 2350) {
			drop();
			$(".itemSea h3").addClass("bounce");
		}
	});

	$(".itemSea .drop1, .itemSea .drop2, .itemSea .drop3, .itemSea .drop4").css({"opacity":"0"});
	function drop() {
		$(".itemSea .drop1").delay(50).animate({"opacity":"1"},500);
		$(".itemSea .drop2").delay(300).animate({"opacity":"1"},700);
		$(".itemSea .drop3").delay(500).animate({"opacity":"1"},400);
		$(".itemSea .drop4").delay(700).animate({"opacity":"1"},350);
	}

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
	}else{
			$(".ma").hide();
			$(".mw").show();
	}
});
</script>
<div class="mJewelry1">
	<div class="section titSec">
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/tit_jewelry.png" alt="반짝이는 상상" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/txt_jewelry_head.png" alt="주얼리를 보는 색다른 시선" /></p>
		<span class="shooting1"></span>
		<span class="shooting2"></span>
		<span class="shooting3"></span>
		<span class="shooting4"></span>
		<span class="star1"></span>
		<span class="star2"></span>
		<span class="star3"></span>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160704/bg_jewelry_head.png" alt="" />
	</div>
	<div class="section itemCircus">
		<div class="itemLink mw">
			<a href="/category/category_itemPrd.asp?itemid=1090309" class="item01"></a>
			<a href="/category/category_itemPrd.asp?itemid=1500570" class="item02"></a>
			<a href="/category/category_itemPrd.asp?itemid=1411279" class="item03"></a>
			<a href="/category/category_itemPrd.asp?itemid=1454512" class="item04"></a>
			<a href="/category/category_itemPrd.asp?itemid=1481401" class="item05"></a>
		</div>
		<div class="itemLink ma">
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1090309" onclick="fnAPPpopupProduct('1090309'); return false;" class="item01"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1500570" onclick="fnAPPpopupProduct('1500570'); return false;" class="item02"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1411279" onclick="fnAPPpopupProduct('1411279'); return false;" class="item03"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1454512" onclick="fnAPPpopupProduct('1454512'); return false;" class="item04"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1481401" onclick="fnAPPpopupProduct('1481401'); return false;" class="item05"></a>
		</div>
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/txt_jewelry_circus.png" alt="CIRCUS" /></h3>
		<span class="balloon1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_balloon1.png" alt="" /></span>
		<span class="balloon2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_balloon2.png" alt="" /></span>
		<span class="balloon3"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_balloon3.png" alt="" /></span>
		<em class="confetti"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_confetti.png" alt="" /></em>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160704/img_jewelry_item1.jpg" alt="circus" />
	</div>
	<div class="section itemMusic">
		<div class="itemLink mw">
			<a href="/category/category_itemPrd.asp?itemid=1333854" class="item06"></a>
			<a href="/category/category_itemPrd.asp?itemid=1358613" class="item07"></a>
		</div>
		<div class="itemLink ma">
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1333854" onclick="fnAPPpopupProduct('1333854'); return false;" class="item06"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1358613" onclick="fnAPPpopupProduct('1358613'); return false;" class="item07"></a>
		</div>
		<span class="note"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/music.gif" alt="" /></span>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160704/img_jewelry_item2.jpg" alt="feel your soul" />
	</div>
	<div class="section itemSea">
		<div class="itemLink mw">
			<a href="/category/category_itemPrd.asp?itemid=1440980" class="item08"></a>
			<a href="/category/category_itemPrd.asp?itemid=1264322" class="item09"></a>
		</div>
		<div class="itemLink ma">
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1440980" onclick="fnAPPpopupProduct('1440980'); return false;" class="item08"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1264322" onclick="fnAPPpopupProduct('1264322'); return false;" class="item09"></a>
		</div>
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/txt_jewelry_catch.png" alt="catch your dream" /></h3>
		<span class="lalala"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/lalala.gif" alt="" /></span>
		<em class="drop1"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_drop1.png" alt="" /></em>
		<em class="drop2"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_drop2.png" alt="" /></em>
		<em class="drop3"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_drop3.png" alt="" /></em>
		<em class="drop4"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_drop4.png" alt="" /></em>
		<em class="drop5"><img src="http://webimage.10x10.co.kr/playmo/ground/20160704/deco_drop5.png" alt="" /></em>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160704/img_jewelry_item3.jpg" alt="" />
	</div>
	<div class="section itemSpace">
		<div class="itemLink mw">
			<a href="/category/category_itemPrd.asp?itemid=778282" class="item10"></a>
			<a href="/category/category_itemPrd.asp?itemid=778284" class="item11"></a>
			<a href="/category/category_itemPrd.asp?itemid=1408946" class="item12"></a>
			<a href="/category/category_itemPrd.asp?itemid=1502175" class="item13"></a>
		</div>
		<div class="itemLink ma">
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=778282" onclick="fnAPPpopupProduct('778282'); return false;" class="item10"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=778284" onclick="fnAPPpopupProduct('778284'); return false;" class="item11"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1408946" onclick="fnAPPpopupProduct('1408946'); return false;" class="item12"></a>
			<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1502175" onclick="fnAPPpopupProduct('1502175'); return false;" class="item13"></a>
		</div>
		<span class="shooting5"></span>
		<span class="shooting6"></span>
		<span class="shooting7"></span>
		<span class="shooting8"></span>
		<em class="star4"></em>
		<em class="star5"></em>
		<em class="star6"></em>
		<em class="star7"></em>
		<em class="star8"></em>
		<em class="star9"></em>
		<em class="star10"></em>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160704/img_jewelry_item4.jpg" alt="twinkle twinkle" />
	</div>
	<div class="section snsShare">
		<a href="#" class="snsFb" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/ico_facebook.png"  />페이스북 공유</a>
		<a href="#" class="snsKt" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20160620/ico_kakao.png" />카카오톡 공유</a>
		<span class="line"></span>
		<img src="http://webimage.10x10.co.kr/playmo/ground/20160704/img_sns.png" alt="보석의 색다른 변신 반짝이는 상상!" />
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->