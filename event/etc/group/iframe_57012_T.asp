<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 57102 - 시리즈
' History : 2014-12-01 이종화 생성
'####################################################
dim evt_code1, evt_code2, evt_code3, evt_code4, evt_code5, evt_code6, evt_code7, evt_code8 , evt_code9 , evt_code10
dim evt_code11, evt_code12, evt_code13, evt_code14, evt_code15, evt_code16, evt_code17, evt_code18 , evt_code19 , evt_code20
Dim evt_code : evt_code = request("eventid")
	IF application("Svr_Info") = "Dev" THEN

	Else
		evt_code1 =  57102
		evt_code2 =  57185
		evt_code3 =  57211 
		evt_code4 =  57222 
		evt_code5 =  57213 
		evt_code6 =  57235 
		evt_code7 =  57224 
		evt_code8 =  57238 
		evt_code9 =  57219 
		evt_code10 = 57216 
		evt_code11 = 57236 
		evt_code12 = 57220 
		evt_code13 = 57212 
		evt_code14 = 57223 
		evt_code15 = 57215 
		evt_code16 = 57218 
		evt_code17 = 57204 
		evt_code18 = 57206 
		evt_code19 = 57208 
		evt_code20 = 58092 
	End If
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.onedayPrice {position:relative;}
.onedayPrice ul {height:100%;}
.onedayPrice ul li {position:absolute; left:5%; width:90%;}
.onedayPrice ul li a {display:none; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.onedayGift a {display:none}
</style>
<script>
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});
</script>
</head>
<body>
<% If date()="2014-12-29" And CStr(evt_code) = CStr(evt_code20) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:16%; top:13.5%;">
			<a href="/category/category_itemprd.asp?itemid=841828" class="mw" target="_top">rabbit led lamp</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('841828'); return false;" class="ma">rabbit led lamp</a>
		</li>
		<li style="height:16%; top:30%;">
			<a href="/category/category_itemprd.asp?itemid=856098" class="mw" target="_top">Baby Bunny</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('856098'); return false;" class="ma">Baby Bunny</a>
		</li>
		<li style="height:16%; top:46.5%;">
			<a href="/category/category_itemprd.asp?itemid=942372" class="mw" target="_top">Hungry Bunny</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('942372'); return false;" class="ma">Hungry Bunny</a>
		</li>
		<li style="height:16%; top:63%;">
			<a href="/category/category_itemprd.asp?itemid=942392" class="mw" target="_top">BABY SQUIRREL</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('942392'); return false;" class="ma">BABY SQUIRREL</a>
		</li>
		<li style="height:16%; top:79.5%;">
			<a href="/category/category_itemprd.asp?itemid=1096980" class="mw" target="_top">HEDGEHOG</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1096980'); return false;" class="ma">HEDGEHOG</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1229_img_oneday_price.png" alt="" /></p>
</div>
<% End If %>

<% If date()="2014-12-26" And CStr(evt_code) = CStr(evt_code19) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:16%; top:13.9%;">
			<a href="/category/category_itemprd.asp?itemid=768343" class="mw" target="_top">Wally Phenomenal Postcard Book 2</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('768343'); return false;" class="ma">Wally Phenomenal Postcard Book 2</a>
		</li>
		<li style="height:16%; top:30.7%;">
			<a href="/category/category_itemprd.asp?itemid=1143335" class="mw" target="_top">Where's Wally? The Search for the Lost Things</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1143335'); return false;" class="ma">Where's Wally? The Search for the Lost Things</a>
		</li>
		<li style="height:16%; top:47.6%;">
			<a href="/category/category_itemprd.asp?itemid=1152245" class="mw" target="_top">Where's Wally? The Totally Essential Travel Collection</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1152245'); return false;" class="ma">Where's Wally? The Totally Essential Travel Collection</a>
		</li>
		<li style="height:16%; top:64.4%;">
			<a href="/category/category_itemprd.asp?itemid=1143332" class="mw" target="_top">Where's Wally?</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1143332'); return false;" class="ma">Where's Wally?</a>
		</li>
		<li style="height:16%; top:81.2%;">
			<a href="/category/category_itemprd.asp?itemid=1143347" class="mw" target="_top">Before After</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1143347'); return false;" class="ma">Before After</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1226_img_oneday_price.png" alt="" /></p>
</div>
<p class="onedayGift"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/img_gift1226.gif" alt="오늘 워커북스 제품을 구매하시는 분들 중 10분을 추첨해 영국 프리미엄 독서용품 브랜드 IF의 독서대를 드립니다. 컬러은 랜덤입니다." /></p>
<% End If %>

<% If date()="2014-12-24" And CStr(evt_code) = CStr(evt_code18) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:16%; top:14%;">
			<a href="/category/category_itemprd.asp?itemid=1141225" class="mw" target="_top">Pink Floral Weekly Desk Pad</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1141225'); return false;" class="ma">Pink Floral Weekly Desk Pad</a>
		</li>
		<li style="height:16%; top:31%;">
			<a href="/category/category_itemprd.asp?itemid=1141224" class="mw" target="_top">Holiday Snow Scene Postcards</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1141224'); return false;" class="ma">Holiday Snow Scene Postcards</a>
		</li>
		<li style="height:16%; top:47.5%;">
			<a href="/category/category_itemprd.asp?itemid=1029198" class="mw" target="_top">2015 Les Fleurs Calendar</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1029198'); return false;" class="ma">2015 Les Fleurs Calendar</a>
		</li>
		<li style="height:16%; top:64.5%;">
			<a href="/category/category_itemprd.asp?itemid=1029191" class="mw" target="_top">Canine Coaster Set</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1029191'); return false;" class="ma">Canine Coaster Set</a>
		</li>
		<li style="height:16%; top:81%;">
			<a href="/category/category_itemprd.asp?itemid=920192" class="mw" target="_top">Over the Moon Card</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('920192'); return false;" class="ma">Over the Moon Card</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1224_img_oneday_price.png" alt="" /></p>
</div>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1224_txt_gift.jpg" alt="" /></p>
<% End If %>

<% If date()="2014-12-23" And CStr(evt_code) = CStr(evt_code17) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:16%; top:14%;">
			<a href="/category/category_itemprd.asp?itemid=1156190" class="mw" target="_top">Pink Floral Weekly Desk Pad</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1156190'); return false;" class="ma">Pink Floral Weekly Desk Pad</a>
		</li>
		<li style="height:16%; top:31%;">
			<a href="/category/category_itemprd.asp?itemid=934046" class="mw" target="_top">Holiday Snow Scene Postcards</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('934046'); return false;" class="ma">Holiday Snow Scene Postcards</a>
		</li>
		<li style="height:16%; top:47.5%;">
			<a href="/category/category_itemprd.asp?itemid=1113797" class="mw" target="_top">2015 Les Fleurs Calendar</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1113797'); return false;" class="ma">2015 Les Fleurs Calendar</a>
		</li>
		<li style="height:16%; top:64.5%;">
			<a href="/category/category_itemprd.asp?itemid=974340" class="mw" target="_top">Canine Coaster Set</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('974340'); return false;" class="ma">Canine Coaster Set</a>
		</li>
		<li style="height:16%; top:81%;">
			<a href="/category/category_itemprd.asp?itemid=934055" class="mw" target="_top">Over the Moon Card</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('934055'); return false;" class="ma">Over the Moon Card</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1223_img_oneday_price.png" alt="" /></p>
</div>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1223_txt_comment.jpg" alt="" /></p>
<% End If %>

<% If date()="2014-12-22" And CStr(evt_code) = CStr(evt_code16) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:13.5%; top:11.7%;">
			<a href="/category/category_itemprd.asp?itemid=1076575" class="mw" target="_top">스칸 홀스 암막커튼</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1076575'); return false;" class="ma">스칸 홀스 암막커튼</a>
		</li>
		<li style="height:13.5%; top:25.9%;">
			<a href="/category/category_itemprd.asp?itemid=1182882" class="mw" target="_top">스칸 베이지 리프믹스 암막커튼</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1182882'); return false;" class="ma">스칸 베이지 리프믹스 암막커튼</a>
		</li>
		<li style="height:13.5%; top:40%;">
			<a href="/category/category_itemprd.asp?itemid=1140708" class="mw" target="_top">따뜻한 마들렌 차렵 극세사 침구</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1140708'); return false;" class="ma">따뜻한 마들렌 차렵 극세사 침구</a>
		</li>
		<li style="height:13.5%; top:54.3%;">
			<a href="/category/category_itemprd.asp?itemid=1054843" class="mw" target="_top">북유럽 시크파이 주방러그매트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1054843'); return false;" class="ma">북유럽 시크파이 주방러그매트</a>
		</li>
		<li style="height:13.5%; top:68.5%;">
			<a href="/category/category_itemprd.asp?itemid=1052752" class="mw" target="_top">북유럽 시크파이 러그카페트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1052752'); return false;" class="ma">북유럽 시크파이 러그카페트</a>
		</li>
		<li style="height:13.5%; top:82.6%;">
			<a href="/category/category_itemprd.asp?itemid=1130579" class="mw" target="_top">사계절 솔리드 면극세사 패드</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1130579'); return false;" class="ma">사계절 솔리드 면극세사 패드</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1222_img_oneday_price.png" alt="" /></p>
</div>
<% End If %>

<% If date()="2014-12-19" And CStr(evt_code) = CStr(evt_code15) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:23%; top:19.5%;">
			<a href="/category/category_itemprd.asp?itemid=938719" class="mw" target="_top">카메라클러치백(미러리스파우치)</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('938719'); return false;" class="ma">카메라클러치백(미러리스파우치)</a>
		</li>
		<li style="height:23%; top:43.5%;">
			<a href="/category/category_itemprd.asp?itemid=1064558" class="mw" target="_top">소니 A5000 케이스(플라워</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1064558'); return false;" class="ma">소니 A5000 케이스(플라워</a>
		</li>
		<li style="height:23%; top:67.5%;">
			<a href="/category/category_itemprd.asp?itemid=1065232" class="mw" target="_top">소니 A5000케이스(핑크플라워)</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1065232'); return false;" class="ma">소니 A5000케이스(핑크플라워)</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1219_img_oneday_price.png" alt="" /></p>
</div>
<% End If %>

<% If date()="2014-12-18" And CStr(evt_code) = CStr(evt_code14) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:16%; top:13.8%;">
			<a href="/category/category_itemprd.asp?itemid=1118593" class="mw" target="_top">데미테르 NEW 15ml 향수 10종 중 택1 12,900원 41% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1118593'); return false;" class="ma">데미테르 NEW 15ml 향수 10종 중 택1 12,900원 41% 할인</a>
		</li>
		<li style="height:16%; top:30.7%;">
			<a href="/category/category_itemprd.asp?itemid=616794" class="mw" target="_top">핸드크림 50ML 6종 택3 12,000원 73% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('616794'); return false;" class="ma">핸드크림 50ML 6종 택3 12,000원 73% 할인</a>
		</li>
		<li style="height:16%; top:47.6%;">
			<a href="/category/category_itemprd.asp?itemid=1143775" class="mw" target="_top">샴푸와 트리트먼트 6종 택1 29,000원 52% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1143775'); return false;" class="ma">샴푸와 트리트먼트 6종 택1 29,000원 52% 할인</a>
		</li>
		<li style="height:16%; top:64.4%;">
			<a href="/category/category_itemprd.asp?itemid=971829" class="mw" target="_top">퍼퓸드 바디클렌저와 로션 6종 택1 29,000원 50% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('971829'); return false;" class="ma">퍼퓸드 바디클렌저와 로션 6종 택1 29,000원 50% 할인</a>
		</li>
		<li style="height:16%; top:81.2%;">
			<a href="/category/category_itemprd.asp?itemid=675616" class="mw" target="_top">그녀들의 향기테라피 롤온 21종 택1 8,900원 53% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('675616'); return false;" class="ma">그녀들의 향기테라피 롤온 21종 택1 8,900원 53% 할인</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1218_img_oneday_price.png" alt="" /></p>
</div>
<p class="onedayGift"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/img_gift1218.gif" alt="코멘트 이벤트 당신의 스토리를 담은 향에 대한 이야기를 들려주세요. 추첨을 통해 5분께 데메테르 30ml 향수를 선물로 드립니다. 향은 랜덤으로 발송됩니다. 당첨자 발표는 2015년 1월 5일이며, 코멘트 작성기간은 2014년 12월 18일부터 12월 31일까지 입니다." /></p>
<% End If %>

<% If date()="2014-12-17" And CStr(evt_code) = CStr(evt_code13) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:24%; top:21%;">
			<a href="/category/category_itemprd.asp?itemid=1039511" class="mw" target="_top">INSTAX SHARE SP-1 184,000원 20% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1039511'); return false;" class="ma">INSTAX SHARE SP-1 184,000원 20% 할인</a>
		</li>
		<li style="height:24%; top:46.4%;">
			<a href="/category/category_itemprd.asp?itemid=957974" class="mw" target="_top">미니 90 네오 클래식 193,600원 20% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('957974'); return false;" class="ma">미니 90 네오 클래식 193,600원 20% 할인</a>
		</li>
		<li style="height:24%; top:71.8%;">
			<a href="/category/category_itemprd.asp?itemid=569187" class="mw" target="_top">인스탁스미니 필름셋트 총 80장 59,000원 21% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('569187'); return false;" class="ma">인스탁스미니 필름셋트 총 80장 59,000원 21% 할인</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1217_img_oneday_price.png" alt="" /></p>
</div>
<% End If %>

<% If date()="2014-12-16" And CStr(evt_code) = CStr(evt_code12) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:15.6%; top:13.7%;">
			<a href="/category/category_itemprd.asp?itemid=1056583" class="mw" target="_top">MOON 3P세트 Metal프레임 44,850원 25% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1056583'); return false;" class="ma">MOON 3P세트 Metal프레임 44,850원 25% 할인</a>
		</li>
		<li style="height:15.6%; top:30.2%;">
			<a href="/category/category_itemprd.asp?itemid=922484" class="mw" target="_top">구스넥 스탠드 10colors 26,100원 25% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('922484'); return false;" class="ma">구스넥 스탠드 10colors 26,100원 25% 할인</a>
		</li>
		<li style="height:15.6%; top:46.7%;">
			<a href="/category/category_itemprd.asp?itemid=756866" class="mw" target="_top">에이콘 장스탠드 52,350원 25% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('756866'); return false;" class="ma">에이콘 장스탠드 52,350원 25% 할인</a>
		</li>
		<li style="height:15.6%; top:63.2%;">
			<a href="/category/category_itemprd.asp?itemid=609238" class="mw" target="_top">NYC 서브웨이 사인 Metal프레임 13,230원 25% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('609238'); return false;" class="ma">NYC 서브웨이 사인 Metal프레임 13,230원 25% 할인</a>
		</li>
		<li style="height:15.6%; top:79.7%;">
			<a href="/category/category_itemprd.asp?itemid=575933" class="mw" target="_top">Metal 미러월 거울 3P세트 52,350원 25% 할인</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('575933'); return false;" class="ma">Metal 미러월 거울 3P세트 52,350원 25% 할인</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1216_img_oneday_price.png" alt="" /></p>
</div>
<% End If %>

<% If date()="2014-12-15" And CStr(evt_code) = CStr(evt_code11) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:16%; top:14%;">
			<a href="/category/category_itemprd.asp?itemid=887142" class="mw" target="_top">3 Ring Binder</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('887142'); return false;" class="ma">3 Ring Binder</a>
		</li>
		<li style="height:16%; top:30.5%;">
			<a href="/category/category_itemprd.asp?itemid=978933" class="mw" target="_top">Harris Tweed</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('978933'); return false;" class="ma">Harris Tweed</a>
		</li>
		<li style="height:16%; top:47.5%;">
			<a href="/category/category_itemprd.asp?itemid=870544" class="mw" target="_top">Travel Partition Pouch set</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('870544'); return false;" class="ma">Travel Partition Pouch set</a>
		</li>
		<li style="height:16%; top:64.5%;">
			<a href="/category/category_itemprd.asp?itemid=335165" class="mw" target="_top">Bag in bag</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('335165'); return false;" class="ma">Bag in bag</a>
		</li>
		<li style="height:16%; top:81.5%;">
			<a href="/category/category_itemprd.asp?itemid=692535" class="mw" target="_top">Cooler Bag</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('692535'); return false;" class="ma">Cooler Bag</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1215_img_oneday_price.png" alt="" /></p>
</div>
<p class="onedayGift"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1215_txt_gift.jpg" alt="" /></p>
<% End If %>

<% If date()="2014-12-12" And CStr(evt_code) = CStr(evt_code10) Then %>
<div class="onedayPrice">
							<ul>
		<li style="height:19%; top:16.5%;">
			<a href="/category/category_itemprd.asp?itemid=521884" class="mw" target="_top">케이블전선 정리박스</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('521884'); return false;" class="ma">케이블전선 정리박스</a>
		</li>
		<li style="height:19%; top:36.5%;">
			<a href="/category/category_itemprd.asp?itemid=1168325" class="mw" target="_top">팬톤컬러 커트러리3P</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1168325'); return false;" class="ma">팬톤컬러 커트러리3P</a>
		</li>
		<li style="height:19%; top:56.5%;">
			<a href="/category/category_itemprd.asp?itemid=499707" class="mw" target="_top">맥주맛도 모르면서 캔홀더</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('499707'); return false;" class="ma">맥주맛도 모르면서 캔홀더</a>
		</li>
		<li style="height:19%; top:76.5%;">
			<a href="/category/category_itemprd.asp?itemid=626938" class="mw" target="_top">Jaga-tama 야채스토커</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('626938'); return false;" class="ma">Jaga-tama 야채스토커</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1212_img_oneday_price.png" alt="" /></p>
</div>
<p class="onedayGift">
	<a href="/category/category_itemprd.asp?itemid=1168327" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1212_txt_gift.jpg" alt="" /></a>
	<a href="#" onclick="parent.fnAPPpopupProduct('1168327'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1212_txt_gift.jpg" alt="" /></a>
</p>
<% End If %>

<% If date()="2014-12-11" And CStr(evt_code) = CStr(evt_code9) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:13%; top:12%;">
			<a href="/category/category_itemprd.asp?itemid=1166313" class="mw" target="_top">북유럽 레드장식 트리</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1166313'); return false;" class="ma">북유럽 레드장식 트리</a>
		</li>
		<li style="height:13%; top:26%;">
			<a href="/category/category_itemprd.asp?itemid=1170163" class="mw" target="_top">포인세티아 패턴 토분 세트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1170163'); return false;" class="ma">포인세티아 패턴 토분 세트</a>
		</li>
		<li style="height:13%; top:40.5%;">
			<a href="/category/category_itemprd.asp?itemid=1167420" class="mw" target="_top">열매 미니 리스</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1167420'); return false;" class="ma">열매 미니 리스</a>
		</li>
		<li style="height:13%; top:54.5%;">
			<a href="/category/category_itemprd.asp?itemid=811703" class="mw" target="_top">피치수국,로즈 화병세트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('811703'); return false;" class="ma">피치수국,로즈 화병세트</a>
		</li>
		<li style="height:13%; top:69%;">
			<a href="/category/category_itemprd.asp?itemid=951709" class="mw" target="_top">클레르 스노우볼 화병 세트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('951709'); return false;" class="ma">클레르 스노우볼 화병 세트</a>
		</li>
		<li style="height:13%; top:83%;">
			<a href="/category/category_itemprd.asp?itemid=1135431" class="mw" target="_top">프렌치 수국 화병세트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1135431'); return false;" class="ma">프렌치 수국 화병세트</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1211_img_oneday_price02.png" alt="" /></p>
</div>
<% End If %>

<% If date()="2014-12-10" And CStr(evt_code) = CStr(evt_code8) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:24%; top:21%;">
			<a href="/category/category_itemprd.asp?itemid=1147261" class="mw" target="_top">WORDPROCESS</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1147261'); return false;" class="ma">WORDPROCESS</a>
		</li>
		<li style="height:24%; top:46.5%;">
			<a href="/category/category_itemprd.asp?itemid=1143863" class="mw" target="_top">RECIPE BAG</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1143863'); return false;" class="ma">RECIPE BAG</a>
		</li>
		<li style="height:24%; top:72%;">
			<a href="/category/category_itemprd.asp?itemid=1137919" class="mw" target="_top">POT BAG _ acoustic</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1137919'); return false;" class="ma">POT BAG _ acoustic</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1210_img_oneday_price.png" alt="" /></p>
</div>
<p class="onedayGift">
	<a href="/category/category_itemprd.asp?itemid=576816" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1210_txt_gift.jpg" alt="" /></a>
	<a href="#" onclick="parent.fnAPPpopupProduct('576816'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1210_txt_gift.jpg" alt="" /></a>
</p>
<% End If %>

<% If date()="2014-12-09" And CStr(evt_code) = CStr(evt_code7) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:12%; top:10.5%;">
			<a href="/category/category_itemprd.asp?itemid=1179381" class="mw" target="_top">해적선</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1179381'); return false;" class="ma">해적선</a>
		</li>
		<li style="height:12%; top:23%;">
			<a href="/category/category_itemprd.asp?itemid=579669" class="mw" target="_top">크리스마스 장터</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('579669'); return false;" class="ma">크리스마스 장터</a>
		</li>
		<li style="height:12%; top:36%;">
			<a href="/category/category_itemprd.asp?itemid=579667" class="mw" target="_top">크리스마스 거실</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('579667'); return false;" class="ma">크리스마스 거실</a>
		</li>
		<li style="height:12%; top:48.5%;">
			<a href="/category/category_itemprd.asp?itemid=1040054" class="mw" target="_top">조랑말 목장과 마차</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1040054'); return false;" class="ma">조랑말 목장과 마차</a>
		</li>
		<li style="height:12%; top:61.5%;">
			<a href="/category/category_itemprd.asp?itemid=1040053" class="mw" target="_top">공주의 섬과보트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1040053'); return false;" class="ma">공주의 섬과보트</a>
		</li>
		<li style="height:12%; top:74%;">
			<a href="/category/category_itemprd.asp?itemid=1040052" class="mw" target="_top">소방서와 쿼드 바이크</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1040052'); return false;" class="ma">소방서와 쿼드 바이크</a>
		</li>
		<li style="height:12%; top:86.5%;">
			<a href="/category/category_itemprd.asp?itemid=1040051" class="mw" target="_top">기사 시합장과 대포</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1040051'); return false;" class="ma">기사 시합장과 대포</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1209_img_oneday_price.png" alt="" /></p>
</div>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1209_txt_gift.jpg" alt="" /></p>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1209_txt_comment.jpg" alt="" /></p>
<% End If %>

<% If date()="2014-12-08" And CStr(evt_code) = CStr(evt_code6) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:16%; top:14%;">
			<a href="/category/category_itemprd.asp?itemid=1035580" class="mw" target="_top">UNDERWEAR POUCH VER.2 여행용 속옷 파우치</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1035580'); return false;" class="ma">UNDERWEAR POUCH VER.2 여행용 속옷 파우치</a>
		</li>
		<li style="height:16%; top:31%;">
			<a href="/category/category_itemprd.asp?itemid=1064257" class="mw" target="_top">PHOTOGRAPH</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1064257'); return false;" class="ma">PHOTOGRAPH</a>
		</li>
		<li style="height:16%; top:47.5%;">
			<a href="/category/category_itemprd.asp?itemid=653547" class="mw" target="_top">OFFICE LEATHER BACKPACK</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('653547'); return false;" class="ma">OFFICE LEATHER BACKPACK</a>
		</li>
		<li style="height:16%; top:64.5%;">
			<a href="/category/category_itemprd.asp?itemid=897657" class="mw" target="_top">MINI JOURNEY NO SKIMMING passport ver.3</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('897657'); return false;" class="ma">MINI JOURNEY NO SKIMMING passport ver.3</a>
		</li>
		<li style="height:16%; top:81%;">
			<a href="/category/category_itemprd.asp?itemid=1077899" class="mw" target="_top">PATTERN GRAND VOYAGING BAG VER.2</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1077899'); return false;" class="ma">PATTERN GRAND VOYAGING BAG VER.2</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1208_img_oneday_price.png" alt="" /></p>
</div>
<p class="onedayGift">
	<a href="/category/category_itemprd.asp?itemid=1047277" class="mw" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1208_txt_gift.jpg" alt="" /></a>
	<a href="#" onclick="parent.fnAPPpopupProduct('1047277'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1208_txt_gift.jpg" alt="" /></a>
</p>
<% End If %>

<% If date()="2014-12-05" And CStr(evt_code) = CStr(evt_code5) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:23.5%; top:20%;">
			<a href="/category/category_itemprd.asp?itemid=740083" class="mw" target="_top">솔리드 러그</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('740083'); return false;" class="ma">솔리드 러그</a>
		</li>
		<li style="height:23.5%; top:44.5%;">
			<a href="/category/category_itemprd.asp?itemid=824258" class="mw" target="_top">허니비 카페트</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('824258'); return false;" class="ma">허니비 카페트</a>
		</li>
		<li style="height:23.5%; top:68.5%;">
			<a href="/category/category_itemprd.asp?itemid=1017266" class="mw" target="_top">별 러그</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1017266'); return false;" class="ma">별 러그</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1205_img_oneday_price.png" alt="" /></p>
</div>
<% End If %>

<% If date()="2014-12-04" And CStr(evt_code) = CStr(evt_code4) Then %>
<div class="onedayPrice">
	<ul>
		<li style="height:13.5%; top:12%;">
			<a href="/category/category_itemprd.asp?itemid=816988" class="mw" target="_top">Laetitia</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('816988'); return false;" class="ma">Laetitia</a>
		</li>
		<li style="height:13.5%; top:26.5%;">
			<a href="/category/category_itemprd.asp?itemid=732720" class="mw" target="_top">brenna.gather</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('732720'); return false;" class="ma">brenna.gather</a>
		</li>
		<li style="height:13.5%; top:41%;">
			<a href="/category/category_itemprd.asp?itemid=721020" class="mw" target="_top">trilly</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('721020'); return false;" class="ma">trilly</a>
		</li>
		<li style="height:13.5%; top:55%;">
			<a href="/category/category_itemprd.asp?itemid=617463" class="mw" target="_top">daniela</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('617463'); return false;" class="ma">daniela</a>
		</li>
		<li style="height:13.5%; top:69.5%;">
			<a href="/category/category_itemprd.asp?itemid=388656" class="mw" target="_top">lauren</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('388656'); return false;" class="ma">lauren</a>
		</li>
		<li style="height:13.5%; top:84%;">
			<a href="/category/category_itemprd.asp?itemid=1169649" class="mw" target="_top">mistic topaz.641 e</a>
			<a href="#" onclick="parent.fnAPPpopupProduct('1169649'); return false;" class="ma">mistic topaz.641 e</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1204_img_oneday_price.png" alt="" /></p>
</div>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1204_txt_comment.png" alt="" /></p>
<% End If %>

<% If date()="2014-12-03" And CStr(evt_code) = CStr(evt_code3) Then %>
<div class="onedayPrice">
	<ul>
		<li class="p01">
				<a href="/category/category_itemprd.asp?itemid=762178" class="mw">퍼스트클래스/레볼루션/센세이션 하드케이스 39종</a>
				<a href="#" onclick="fnAPPpopupProduct('762178'); return false;" class="ma">퍼스트클래스/레볼루션/센세이션 하드케이스 39종</a>
		</li>
		<li class="p02">
				<a href="/category/category_itemprd.asp?itemid=1137159" class="mw">아이폰6 & 아이폰6플러스 하드케이스</a>
				<a href="#" onclick="fnAPPpopupProduct('1137159'); return false;" class="ma">아이폰6 & 아이폰6플러스 하드케이스</a>
		</li>
		<li class="p03">
				<a href="/category/category_itemprd.asp?itemid=1131036" class="mw">트윙클 투명케이스 9종</a>
				<a href="#" onclick="fnAPPpopupProduct('1131036'); return false;" class="ma">트윙클 투명케이스 9종</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1203_img_oneday_price.png" alt="" /></p>
</div>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1203_txt_gift.jpg" alt="" /></p>
<% End If %>

<% If date()="2014-12-02" And CStr(evt_code) = CStr(evt_code2) Then %>
<div class="onedayPrice">
	<ul>
		<li class="p01">
			<a href="/category/category_itemprd.asp?itemid=1068178" class="mw">Pillarbox Red Leather Pixie Bag</a>
			<a href="#" onclick="fnAPPpopupProduct('1068178'); return false;" class="ma">Pillarbox Red Leather Pixie Bag</a>
		</li>
		<li class="p02">
			<a href="/category/category_itemprd.asp?itemid=666681" class="mw">12.5inch Autumn Tan</a>
			<a href="#" onclick="fnAPPpopupProduct('666681'); return false;" class="ma">12.5inch Autumn Tan</a>
		</li>
		<li class="p03">
			<a href="/category/category_itemprd.asp?itemid=740215" class="mw">12.5inch Double Yellow and Charcoal Black</a>
			<a href="#" onclick="fnAPPpopupProduct('740215'); return false;" class="ma">12.5inch Double Yellow and Charcoal Black</a>
		</li>
		<li class="p04">
			<a href="/category/category_itemprd.asp?itemid=730973" class="mw">14inch Patent Fuchsia Petal</a>
			<a href="#" onclick="fnAPPpopupProduct('730973'); return false;" class="ma">14inch Patent Fuchsia Petal</a>
		</li>
		<li class="p05">
			<a href="/category/category_itemprd.asp?itemid=731111" class="mw">15inch Patent Deep Purple</a>
			<a href="#" onclick="fnAPPpopupProduct('731111'); return false;" class="ma">15inch Patent Deep Purple</a>
		</li>
	</ul>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1202_img_oneday_price.png" alt="" /></p>
</div>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/1202_txt_comment.jpg" alt="" /></p>
<% End If %>

<% If date()="2014-12-01" And CStr(evt_code) = CStr(evt_code1) Then %>
<div class="onedayPrice">
<ul>
<li class="p01">
		<a href="/category/category_itemprd.asp?itemid=1038318" class="mw">아이코닉 큐브백 v.2</a>
		<a href="#" onclick="fnAPPpopupProduct('1038318'); return false;" class="ma">아이코닉 큐브백 v.2</a>
</li>
<li class="p02">
		<a href="/category/category_itemprd.asp?itemid=968889" class="mw">아이코닉 세이브업 캐쉬북 V.5</a>
		<a href="#" onclick="fnAPPpopupProduct('968889'); return false;" class="ma">아이코닉 세이브업 캐쉬북 V.5</a>
</li>
<li class="p03">
		<a href="/category/category_itemprd.asp?itemid=1080754" class="mw">아이코닉 레이어 백</a>
		<a href="#" onclick="fnAPPpopupProduct('1080754'); return false;" class="ma">아이코닉 레이어 백</a>
</li>
<li class="p04">
		<a href="/category/category_itemprd.asp?itemid=1076024" class="mw">아이코닉 트래블 워시백</a>
		<a href="#" onclick="fnAPPpopupProduct('1076024'); return false;" class="ma">아이코닉 트래블 워시백</a>
</li>
<li class="p05">
		<a href="/category/category_itemprd.asp?itemid=998650" class="mw">아이코닉 짚업 월렛L V.2</a>
		<a href="#" onclick="fnAPPpopupProduct('998650'); return false;" class="ma">아이코닉 짚업 월렛L V.2</a>
</li>
</ul>
<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/img_oneday_price1201.png" alt="" /></p>
</div>
<p class="ondayGift">
	<a href="/category/category_itemprd.asp?itemid=1073018" class="mw"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/img_gift1201_n2.jpg" alt="" /></a>
	<a href="#" onclick="fnAPPpopupProduct('1073018'); return false;" class="ma"><img src="http://webimage.10x10.co.kr/eventIMG/2014/brand-award/m/img_gift1201_n2.jpg" alt="" /></a>
</p>
<% End If %>
</body>
</html>