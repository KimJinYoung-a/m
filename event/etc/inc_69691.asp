<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 사대천왕 M 랜딩페이지
' History : 2016.03.17 유태욱 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt69691 {position:relative;}
.mEvt69691 button {background:transparent;}
.item {overflow:hidden;}
.item li {float:left; width:50%;}
.btnArea {position:relative;}
.btnArea .btnApply {display:block; position:absolute; left:0; top:0; width:100%; background:transparent; vertical-align:top;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; left:7%; top:52%; width:86%; height:38%;}
.shareSns ul li {float:left; width:25%; height:100%; padding:0 2%;}
.shareSns ul li a {display:block; width:100%; height:100%; text-indent:-9999px;}
.evtNoti {color:#fff; padding:2rem 4% 2.5rem; background:#454545;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69690/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:1rem; font-size:1rem; line-height:1.4; letter-spacing:-0.003em;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.4rem; height:1px; background:#fff;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt69691").offset().top}, 0);
});

function gotoDownload(){
	parent.top.location.href='http://m.10x10.co.kr/apps/link/?9020160317';
	return false;
};
</script>

<div class="mEvt69691">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69691/tit_4000.png" alt="특별한 당신에게 보이는 사대천왕 - 앱에서 처음 로그인한 분에게 드리는 4천원의 행복 지금 응로하고 확인해보세요!" /></h2>
	<ul class="item">
		<li><img src="http://webimage.10x10.co.kr/eventIMG/2016/69691/img_item_01.jpg" alt="미밈 프로젝트 에코백" /></li>
		<li><a href="/category/category_itemprd.asp?itemid=841828&amp;pEtr=69691"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69691/img_item_02.jpg" alt="미니토끼 LED램프" /></a></li>
		<li><a href="/category/category_itemprd.asp?itemid=1440324&amp;pEtr=69691"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69691/img_item_03.jpg" alt="라인프렌즈 공기청정기" /></a></li>
		<li><a href="/category/category_itemprd.asp?itemid=1387323&amp;pEtr=69691"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69691/img_item_04.jpg" alt="아이리버 스피커" /></a></li>
	</ul>

	<a href="" onclick="gotoDownload(); return false;">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69691/btn_app.png" alt="APP에서 확인하기(사대천왕은 앱에서만 구매할 수 있습니다)" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69691/txt_app_benefit.png" alt="텐바이텐을 앱으로 만나면? 편리한쇼핑+다양한 이벤트+보너스 할인쿠폰" /></p>
	</a>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 이벤트는 앱에서 로그인 이력이 한번도 없는 고객님을 위한 이벤트입니다.</li>
			<li>ID당 1회만 구매가 가능합니다.</li>
			<li>이벤트는 상품 품절 시 조기 마감 될 수 있습니다.</li>
			<li>상품은 즉시결제로만 구매가 가능하며 배송 후 반품/교환/취소가 불가능합니다.</li>
			<li>구매하신 상품은 3월 28일 순차적으로 일괄 배송될 예정입니다.</li>
			<li>5만원 이상의 쿠폰할인을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
			<li>개인정보 확인이 되지 않을 시에는 당첨이 취소될 수 있습니다.</li>
		</ul>
	</div>
</div>
