<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  크리스마스 이벤트(IT’S SPECIAL 단독상품페이지)M
' History : 2014.11.27 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="lib/inc/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<style type="text/css">
.itsSpecial {background-color:#f5f5f5;}
.itsSpecial img {width:100%; vertical-align:top;}
.itsSpecial .hgroup {position:relative;}
.itsSpecial .deco {position:absolute; top:0; left:0; width:100%;}
.specialEdition {padding:0 3% 10%;}
.specialEdition ul li {padding:10% 0 5%; background:url(http://fiximage.10x10.co.kr/m/2014/common/double_line.png) repeat-x 0 100%;}
.animated {-webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* FadeIn animation */
@-webkit-keyframes fadeIn {
	0% {opacity:0;}
	50% {opacity:0.5;}
	100% {opacity:1;}
}
@keyframes fadeIn {
	0% {opacity:0;}
	50% {opacity:0.5;}
	100% {opacity:1;}
}
.fadeIn {-webkit-animation-name: fadeIn; animation-name: fadeIn; -webkit-animation-iteration-count:5; animation-iteration-count:5;}
</style>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">
	<!-- IT’S SPECIAL -->
	<div class="itsSpecial">
		<section>
			<div class="hgroup">
				<span class="deco animated fadeIn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_deco_special.png" alt="" /></span>
				<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/tit_unique_christmas.gif" alt="UNIQUE CHRISTMAS ITEMS 텐바이텐에서만 만날 수 있는 SPECIAL EDITION" /></h1>
			</div>
			
			<div class="specialEdition">
			<% if isApp=1 then %>
				<ul>
					<li><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=57170'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_01.jpg" alt="메리 우디 크리스마스 크리스마스 10% 분위기를 내기 위해 꼭 필요한 소품은?" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupProduct('1162950'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_02.jpg" alt="일편단심 크리스마스 조명 20% 서로 가까워질 수록 밝아지는 조명" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupProduct('1172445'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_03.jpg" alt="크리스마스 선물 세트 미니트리와 전구, 디퓨져로 구성된 블루밍앤미 선물 세트" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupProduct('1169177'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_04.jpg" alt="크리스마스 셀프파티 패키지 SOMETHING TO BE의 크리스마스 파티킷" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupBrand('5pening'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_05.jpg" alt="5PENING 오프닝의 핸드메이드 크리스마스 캔들" /></a></li>
					<li><a href="" onclick="parent.fnAPPpopupBrand('vayu'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_06.jpg" alt="VAYU 특별한 크리스마스 공간을 위해" /></a></li>
				</ul>
			<% else %>
				<ul>
					<li><a href="/event/eventmain.asp?eventid=57170"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_01.jpg" alt="메리 우디 크리스마스 크리스마스 10% 분위기를 내기 위해 꼭 필요한 소품은?" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1162950"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_02.jpg" alt="일편단심 크리스마스 조명 20% 서로 가까워질 수록 밝아지는 조명" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1172445"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_03.jpg" alt="크리스마스 선물 세트 미니트리와 전구, 디퓨져로 구성된 블루밍앤미 선물 세트" /></a></li>
					<li><a href="/category/category_itemPrd.asp?itemid=1169177"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_04.jpg" alt="크리스마스 셀프파티 패키지 SOMETHING TO BE의 크리스마스 파티킷" /></a></li>
					<li><a href="/street/street_brand.asp?makerid=5pening"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_05.jpg" alt="5PENING 오프닝의 핸드메이드 크리스마스 캔들" /></a></li>
					<li><a href="/street/street_brand.asp?makerid=vayu"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/img_special_edition_06.jpg" alt="VAYU 특별한 크리스마스 공간을 위해" /></a></li>
				</ul>
			<% end if %>
			</div>
		</section>

		<!-- for dev msg : 혜택 페이지로 링크 -->
		<% if isApp=1 then %>
			<div class="btn-go"><a href="" onclick="parent.fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56928" %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_go_benefit02.gif" alt="크리스마스 혜택 보고 이벤트 응모하러 가기" /></a></div>
		<% else %>
			<div class="btn-go"><a href="/event/eventmain.asp?eventid=<% IF application("Svr_Info") = "Dev" THEN response.write "21386" ELSE response.write "56928" %>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/x-mas/m/btn_go_benefit02.gif" alt="크리스마스 혜택 보고 이벤트 응모하러 가기" /></a></div>
		<% end if %>
	</div>
</div>
<!--// 이벤트 배너 등록 영역 -->
</body>
</html>