<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/inc_const.asp" -->
<%
	Dim targetDay	: targetDay = getNumeric(requestCheckVar(Request.form("tgd"),2))		'요청 일짜
	Dim targetItem	: targetItem = split("1250336,1250337,1250338,1250339,1250340,1250341,1250342,1250343,1250344,1250345,1250346,1250347",",")		'날짜별 상품ID

	'// 기준 날짜 설정
	if targetDay="" then targetDay = cStr(day(date))
	if cint(TargetDay)>day(date) then TargetDay = cStr(day(date))
	if cint(TargetDay)<13 then TargetDay = "13"
	if cint(TargetDay)>24 then TargetDay = "24"
%>
<div class="brandbox">
	<% if cint(TargetDay)=day(date) then %>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/tit_today_brand.png" alt="TODAY&apos;S BRAND" /></h2>
	<% else %>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/tit_on_sale_brand.png" alt="ON SALE" /></h2>
	<% end if %>
	<% Select Case targetDay %>
		<%	Case "13" %>
	<div class="item item1">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_01_01.jpg" alt="ROOM, ET" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=324873" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(324873);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_01_02.jpg" alt="상큼한 런던 스툴 21,000원" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1112585" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1112585);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_01_03.jpg" alt="엘바 좌식 테이블 37,000원" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1234356" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1234356);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_01_04.jpg" alt="메이 원목 벽시계 17,000원" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_01.png" alt="75,000원 &rarr; 31,900원 60%" /></p>
	</div>
		<%	Case "14" %>
	<div class="item item2">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_02_01.jpg" alt="iriver" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1091239" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1091239);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_02_02_v1.jpg" alt="블루투스 스피커" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1096372" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1096372);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_02_03_v1.jpg" alt="이어폰" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=596727" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(596727);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_02_04.jpg" alt="스마트펜 꿀맛 사은품" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=898771" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(898771);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_02_05.jpg" alt="보조 배터리 꿀맛 사은품" /></a></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_02_06.jpg" alt="칫솔 살균기 꿀맛 사은품" /></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_02.png" alt="51,200원 &rarr; 30,900원 40%" /></p>
	</div>
		<%	Case "15" %>
	<div class="item item3">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_03_01.jpg" alt="SNURK" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=920191" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(920191);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_03_02.jpg" alt="Astronaut Single" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1222026" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1222026);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_brand_03_03.jpg" alt="Twirre Printed Bag 깜작 선물! 100분 랜덤 선물!" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_03.png" alt="143,000원 &rarr; 49,900원 65%" /></p>
	</div>
		<%	Case "16" %>
	<div class="item item4" >
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_01.jpg" alt="COLEMAN" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1231836" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1231836);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_02.jpg" alt="펀 체어 싱글/페스웨이브" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1231838" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1231838);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_03.jpg" alt="암 체어 그린" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1239134" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1239134);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_04.jpg" alt="펀체어 더블폴리지 블루" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1239133" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1239133);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_05.jpg" alt="펀체어 더블폴리지 핑크" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1231941" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1231941);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_06.jpg" alt="팝업 박스" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1231950" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1231950);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_07.jpg" alt="행잉 체인" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1231291" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1231291);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_08.jpg" alt="런치 쿨러 5L" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1231987" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1231987);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_09.jpg" alt="쁘띠 레저 시트" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1237072" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1237072);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_10.jpg" alt="꿀맛 사은품 4가지 상품 중 랜덤 발송 마이 캠프 랜턴" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1243486" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1243486);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_11.jpg" alt="꿀맛 사은품 4가지 상품 중 랜덤 발송 LED 스트링 라이트" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1243489" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1243489);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_12.jpg" alt="꿀맛 사은품 4가지 상품 중 랜덤 발송 가랜드 스트링 라이트 핑" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1243490" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1243490);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_coleman_13.jpg" alt="꿀맛 사은품 4가지 상품 중 랜덤 발송 가랜드 스트링 라이트 블루" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_04.png" alt="56,170원 &rarr; 49,900원 11%" /></p>
	</div>
		<%	Case "17" %>
	<div class="item item5">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_bomann_01.jpg" alt="BOMANN" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1007309" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1007309);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_bomann_02.jpg" alt="스테인레스 무선주전자 커피포트" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1127320" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1127320);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_bomann_03.jpg" alt="토스터기" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_05_v1.png" alt="98,900원 &rarr; 29,900원 70%" /></p>
	</div>
		<%	Case "18" %>
	<div class="item item6">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_fashionbox_01.jpg" alt="FASHIONBOX" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1215158" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1215158);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_fashionbox_02.jpg" alt="u.t pigment eco bag" /></a></li>
			<li><a href="/street/street_brand.asp?makerid=moree01" <%=chkIIF(isApp,"onclick=""fnAPPpopupBrand('moree01');return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_fashionbox_03.jpg" alt="/street/street_brand.asp?makerid=moree01" /></a></li>
			<li><a href="/street/street_brand.asp?makerid=modernday&disp=116102" <%=chkIIF(isApp,"onclick=""fnAPPpopupBrand('modernday');return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_fashionbox_04.jpg" alt="라비에벨파우치 M" /></a></li>
			<li><a href="/street/street_brand.asp?makerid=modernday&disp=116102" <%=chkIIF(isApp,"onclick=""fnAPPpopupBrand('modernday');return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_fashionbox_05.jpg" alt="라비에벨파우치 S" /></a></li>
			<li class="last"><a href="/category/category_itemPrd.asp?itemid=1239583" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1239583);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_fashionbox_06.jpg" alt="20분 랜덤 증정 MARC BY MARC JACOBS MBM1316 베이커 (203866)" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_06.png" alt="82,300원 &rarr; 29,900원 64%" /></p>
	</div>
		<%	Case "19" %>
	<div class="item item7">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_01.jpg" alt="INSTAX" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1039511" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1039511);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_02.jpg" alt="와이파이 프린터" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1206145" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1206145);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_03.jpg" alt="미니 헬로키티 SET" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=822736" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(822736);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_04.jpg" alt="인스탁스 mini25 Cath kidston Pink" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=822728" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(822728);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_05.jpg" alt="인스탁스 mini25 Cath kidston Mint" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=610087" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(610087);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_06.jpg" alt="인스탁스 리락쿠마 패키지" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1206210" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1206210);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_07.jpg" alt="mini 8 윈터 패키지" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1118570" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1118570);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_08.jpg" alt="인스탁스 미니 8 키키라라" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1118571" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1118571);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_09.jpg" alt="인스탁스 미니 8 푸우" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=770217" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(770217);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_10.jpg" alt="인스탁스 미니 8 라즈베리" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=770217" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(770217);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_11.jpg" alt="인스탁스 미니 8 그레이프" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=742565" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(742565);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_12.jpg" alt="인스탁스 미니 25 핑크" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=742565" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(742565);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_instax_13.jpg" alt="인스탁스 미니 25 블루" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_07.png" alt="12가지 상품 중 랜덤으로 발송 148,600원 &rarr; 49,900원 66%" /></p>
	</div>
		<%	Case "20" %>
	<div class="item item8">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_01.jpg" alt="Playmobil" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1234865" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1234865);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_02.jpg" alt="송아지와 농장아가씨" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1234860" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1234860);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_03.jpg" alt="엄마와 아이들" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1234859" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1234859);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_04.jpg" alt="해적과 보물상자" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1234853" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1234853);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_05.jpg" alt="연주하는 피에로" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1234861" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1234861);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_06.jpg" alt="공주와 마네킨" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1234855" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1234855);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_07.jpg" alt="소녀와 염소" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1041892" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1041892);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_08.jpg" alt="천사와 악마" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=927334" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(927334);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_09.jpg" alt="건축가와 모형" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1041889" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1041889);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_playmobil_10.jpg" alt="늑대와 사냥꾼" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_08.png" alt="40가지 상품 중 7가지를 랜덤으로 발송 40,000원 &rarr; 19,900원 50%" /></p>
	</div>
		<%	Case "21" %>
	<div class="item item9">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_mybeans_01.jpg" alt="마이빈스" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=995520" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(995520);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_mybeans_02.jpg" alt="마이빈스 더치커피 500ml 와인병" /></li>
			<li><a href="/category/category_itemPrd.asp?itemid=995513" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(995513);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_mybeans_03.jpg" alt="마이빈스 더치커피 500ml 보르미올리병" /></li>
			<li class="last"><a href="/category/category_itemPrd.asp?itemid=1171539" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1171539);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_mybeans_04.jpg" alt="꿀맛 사은품 써모머그 엄브렐러 보틀" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_09_v1.png" alt="18,000원 &rarr; 9,900원 45%" /></p>
	</div>
		<%	Case "22" %>
	<div class="item item10">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_lamy_01.jpg" alt="LAMY" /></div>
		<ul>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_lamy_02.jpg" alt="Lamy Safari Special edition 2015 네온 라임 만년필" /></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_lamy_03.jpg" alt="꿀맛 사은품 Lamy 잉크카트리지" /></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_10.png" alt="54,000원 &rarr; 43,740원 19%" /></p>
	</div>
		<%	Case "23" %>
	<div class="item item11">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_method_01.jpg" alt="METHOD" /></div>
		<ul>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_method_02.jpg" alt="주방세제 안티박클리너" /></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1084108" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1084108);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_method_03.jpg" alt="욕실용 세정제" /></a></li>
			<li><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_method_04.jpg" alt="주방세제 파워디쉬폼 레몬민트" /></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1084728" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1084728);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_method_05.jpg" alt="꿀맛 사은품 핸드워시 후레쉬커런트" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_11.png" alt="27,700원 &rarr; 12,900원 53%" /></p>
	</div>
		<%	Case "24" %>
	<div class="item item12">
		<div class="brand"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_01.jpg" alt="ICONIC" /></div>
		<ul>
			<li><a href="/category/category_itemPrd.asp?itemid=1220259" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1220259);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_02.jpg" alt="투웨이 파스텔펜" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=897948" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(897948);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_03.jpg" alt="투웨이 데코펜" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=699617" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(699617);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_04.jpg" alt="컬러 트윈펜" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=521683" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(521683);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_05.jpg" alt="북마크세트" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=882296" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(882296);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_06.jpg" alt="에브리데이 행키" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=1053770" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(1053770);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_07.jpg" alt="에브리데이 행키 v.2" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=860504" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(860504);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_08.jpg" alt="스윙 카드포켓" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=860503" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(860503);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_09.jpg" alt="크로스 넥스트랩" /></a></li>
			<li><a href="/category/category_itemPrd.asp?itemid=484618" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(484618);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_10.jpg" alt="슬림 포켓 v.2" /></a></li>
			<li class="half"><a href="/category/category_itemPrd.asp?itemid=500681" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(500681);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_11.jpg" alt="레트로 뱃지" /></a></li>
			<li class="half"><a href="/category/category_itemPrd.asp?itemid=776819" <%=chkIIF(isApp,"onclick=""fnAPPpopupProduct(776819);return false;""","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/img_iconic_12.jpg" alt="클래식 빗거울" /></a></li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_price_12_v1.png" alt="11가지 상품 중 6가지를 랜덤으로 발송 40,000원 &rarr; 19,900원 50%" /></p>
	</div>
	<% End Select %>


	<% if isApp then%>
	<div class="app">
		<% if cInt(targetDay)>=day(date) and hour(now)<12 then %>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_buy_12pm.png" alt="정오 12시부터 구매하실 수 있습니다." /></p>
		<% else %>
		<div class="btnget"><a href="" onclick="fnGetChance(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/btn_get.png" alt="꿀맛찬스 구매하기" /></a></div>
		<% end if %>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_hurry_up.png" alt="한정수량이므로 조기에 소진될 수 있으니, 서둘러 주세요!" /></p>
	</div>
	<script type="text/javascript">
	function fnGetChance() {
		<% if date<"2015-04-13" or date>"2015-04-24" then %>
		alert("죄송합니다. 이벤트 기간이 아닙니다.");
		<% elseif cInt(targetDay)>=day(date) and hour(now)<12 then %>
		alert("꿀맛찬스는 정후 12시에 시작됩니다!");
		<% else %>
		fnAPPpopupProduct(<%=targetItem(targetDay-13)%>)
		<% end if %>
	}
	</script>
	<% else %>
	<div class="mo">
		<div class="btndown"><a href="" onclick="gotoDownload(); return false;" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/btn_down_app.png" alt="텐바이텐 앱 다운로드" /></a></div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60832/m/txt_get_only_app.png" alt="본 상품은 텐바이텐 APP에서만 구매하실 수 있습니다. 한정수량이므로 조기에 소진될 수 있으니, 서둘러 주세요!" /></p>
	</div>
	<% end if %>
</div>
