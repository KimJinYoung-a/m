<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [tvN X 텐바이텐] 응답하라1988 공식 굿즈 pre-open
' History : 2015-12-11 이종화
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode 

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65982
Else
	eCode   =  68039
End If
	
'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐xTvN] 응답하라 1988 공식 굿즈 사전 판매!")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[응답하라1988] 공식굿즈 선판매!\n\n텐바이텐과 <응답하라1988> 이 만났다!\n\n감동이 있는 명대사부터\n배우들의 명장면, 비하인드컷까지\n모두 디자인 문구 속에 담았습니다.\n\n예약판매 기념 10% 할인 중!\n오직 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/68039/m/img_bnr_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68039 .hidden {visibility:hidden; width:0; height:0;}
.mEvt68039 #app {display:none;}

.item {position:relative;}
.item ul {overflow:hidden; position:absolute; top:4%; left:50%; width:90%; margin-left:-45%;}
.item ul li {position:relative; float:left; width:50%; margin-bottom:4.2%; padding:0 1.8%;}
.item ul li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:152.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.item ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
.item ul li a.type1 {position:absolute; top:0; left:0; width:60%; padding-bottom:80.25%;}
.item ul li a.type1 span {background-color:red;}
.item ul li a.type2 {position:absolute; top:0; right:3%; width:40%; padding-bottom:90.25%;}

.sns {position:relative;}
.sns ul {overflow:hidden; position:absolute; bottom:12%; left:50%; width:86%; margin-left:-43%;}
.sns ul li {float:left; width:33.333%;}
.sns ul li a {overflow:hidden; display:block; position:relative; height:0; margin:0 4%; padding-bottom:80.25%; color:transparent; font-size:11px; line-height:11px; text-align:center;}
.sns ul li span {position:absolute; top:0; left:0; width:100%; height:100%; background-color:black; opacity:0; filter:alpha(opacity=0); cursor:pointer;}
</style>
<div class="mEvt68039">
	<article>
		<h2 class="hidden">응답하라1988 공식 굿즈 pre-open</h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68039/m/txt_1988.jpg" alt="오직 텐바이텐에서만 만날 수 있는 응답하라 공식 굿즈! 사전 판매 기념 10% 할인! 사전 판매 기간은  2015년 12월 14일 월요일 부터 12월 22일 화요일 까지며, 상품 배송 기간은 2015년 12월 23일 수요일부터 순차적으로 배송됩니다." /></p>

		<div class="item">
			<ul id="mo">
				<li><a href="/category/category_itemPrd.asp?itemid=1401873&amp;pEtr=68060"><span></span>2016 탁상 달력</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401874&amp;pEtr=68060"><span></span>2016 벽걸이 일력</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401875&amp;pEtr=68060"><span></span>딱지 스티커</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401877&amp;pEtr=68060"><span></span>청춘시대 노트</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401878&amp;pEtr=68060"><span></span>스마트폰 케이스</a></li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1401882&amp;pEtr=68060" class="type1"><span></span>티머니 버스카드 카드형</a>
					<a href="/category/category_itemPrd.asp?itemid=1401883&amp;pEtr=68060" class="type2"><span></span>티머니 버스카드 고리형</a>
				</li>
			</ul>
			<ul id="app">
				<li><a href="/category/category_itemPrd.asp?itemid=1401873&amp;pEtr=68060" onclick="fnAPPpopupProduct('1401873&amp;pEtr=68060');return false;"><span></span>2016 탁상 달력</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401874&amp;pEtr=68060" onclick="fnAPPpopupProduct('1401874&amp;pEtr=68060');return false;"><span></span>2016 벽걸이 일력</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401875&amp;pEtr=68060" onclick="fnAPPpopupProduct('1401875&amp;pEtr=68060');return false;"><span></span>딱지 스티커</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401877&amp;pEtr=68060" onclick="fnAPPpopupProduct('1401877&amp;pEtr=68060');return false;"><span></span>청춘시대 노트</a></li>
				<li><a href="/category/category_itemPrd.asp?itemid=1401878&amp;pEtr=68060" onclick="fnAPPpopupProduct('1401878&amp;pEtr=68060');return false;"><span></span>스마트폰 케이스</a></li>
				<li>
					<a href="/category/category_itemPrd.asp?itemid=1401882&amp;pEtr=68060" class="type1" onclick="fnAPPpopupProduct('1401882&amp;pEtr=68060');return false;"><span></span>티머니 버스카드 카드형</a>
					<a href="/category/category_itemPrd.asp?itemid=1401883&amp;pEtr=68060" class="type2" onclick="fnAPPpopupProduct('1401883&amp;pEtr=68060');return false;"><span></span>티머니 버스카드 고리형</a>
				</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68039/m/img_item_v3.jpg" alt="원가 및 유통 마진을 제외한 tvN 수익금은 사회공헌 분야에 기부됩니다." /></p>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/68039/m/img_photo_1988.jpg" alt="" />
		</div>

		<section class="sns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68039/m/tit_sns_v1.png" alt="응팔앓이 친구들에게도 얼른 이 소식을 알려주세요!" /></p>
			<ul>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><span></span>페이스북</a></li>
				<li><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');return false;"><span></span>라인</a></li>
				<li><a href="" onclick="parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');return false;"><span></span>카카오톡</a></li>
			</ul>
		</section>
	</article>
</div>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$("#app").show();
			$("#mo").hide();
	}else{
			$("#app").hide();
			$("#mo").show();
	}
});
</script>