<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2015오픈이벤트 덤&MOOMIN
' History : 2015.04.10 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
 Dim userid : userid = GetLoginUserID()
 	Dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode = "60746"
	Else
		eCode = "61490"
	End If
%>
<style type="text/css">
.aprilHoney img {vertical-align:top;}
.aprilHoney button {background-color:transparent;}
.app {display:none;}
.honeyGift .topic h1 {visibility:hidden; width:0; height:0;}
.giftarea .gift1, .giftarea .gift3 {background-color:#e2f5ff;}
.giftarea .gift2 {background-color:#c9eafb;}
.giftarea .link {display:block; position:relative; width:94%; margin:2% auto 0;}
.giftarea .link em {display:none; position:absolute; top:0; left:0; width:100%;}

.check {position:relative; background-color:#5cd3ff;}
.check p {width:320px; margin:0 auto;}
.check .btnwrap {position:absolute; top:0; left:50%; width:320px; height:141px; margin-left:-160px;}
.check .point {position:absolute; top:90px; left:87px; width:96px; height:25px; border-radius:15px; background-color:#91defb; font-size:13px; font-weight:bold; line-height:25px; color:#d50c0c; text-align:center;}
.check .btncheck {position:absolute; top:0; left:0;}
.check ul {padding:22px 20px; background-color:#2cc4fc;}
.check ul li {position:relative; padding-top:2px; padding-left:10px; color:#fff; font-size:11px; line-height:1.5em;}
.check ul li:after {content:' '; position:absolute; top:5px; left:0; width:2px; height:2px; border:2px solid #ffc101; border-radius:50%; background-color:transparent;}

.noti {padding:30px 10px;}
.noti h2 {color:#444; font-size:13px; line-height:1.25em;}
.noti h2 span {position:relative; padding:0 10px;}
.noti h2 span:after, .noti h2 span:before {content:' '; position:absolute; top:50%; width:2px; height:12px; margin-top:-6px; background-color:#33e4b9;}
.noti h2 span:after {left:0;}
.noti h2 span:before {right:0;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#555; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #ffc101; border-radius:50%; background-color:transparent;}

.bnr {overflow:hidden;}
.bnr a {float:left; width:50%;}

@media all and (min-width:480px){
	.check ul li {padding-top:4px; padding-left:15px; font-size:16px;}
	.check ul li:after {top:10px; width:3px; height:3px; border:3px solid #ffc101;}

	.noti {padding:45px 15px;}
	.noti h2 {font-size:20px;}
	.noti h2 span {padding:0 15px;}
	.noti h2 span:after, .noti h2 span:before {width:3px; height:18px; margin-top:-9px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:6px; width:3px; height:3px; border:3px solid #ffc101;}
}
</style>
<script type="text/javascript">
$(function(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$(".app").show();
			$(".mo").hide();
		}else{
			$(".mo").show();
			$(".app").hide();
		}
	});

function chkmypoint(){
	<% if Not(IsUserLoginOK) then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% else %>
		$.ajax({
			url: "/event/etc/mypoint_proc.asp",
			cache: false,
			success: function(message) {
				//팝업 호출
				$("#tempdiv").empty().append(message);
				$("#mypoint").empty()
				$("#mypoint").text($("strong#totmypoint").attr("value"));
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	<% end if %>
}
</script>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">

	<!-- iframe : 덤&무민 사은이벤트 이벤트 코드 61490 -->
	<div class="aprilHoney">
		<div class="honeyGift">
			<div class="topic">
				<h1>무민과 함께하는 아름다운 사은 이벤트 덤&amp;무민</h1>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift.png" alt="5만원 10만원 20만원 이상 구매 시 원하는 사은품을 선택할 수 있어요! 텐바이텐 배송상품 포함 주문시며, 기간은 4월 13일부터 소진시까지입니다." /></p>
			</div>

			<div class="giftarea">
				<div class="gift1">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/tit_gift_01.png" alt="5만원 이상 구매시" /></h2>
					<a href="/category/category_itemPrd.asp?itemid=1229782" target="_top" class="link mo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_01_01.png" alt="무민 피규어" />
						<!-- 솔드아웃시 style="display:block;" -->
						<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_soldout.png" alt="솔드아웃" /></em>
					</a>
					<a href="" onclick="parent.fnAPPpopupProduct(1229782);return false;" target="_top" class="link app">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_01_01.png" alt="무민 피규어" />
						<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_soldout.png" alt="솔드아웃" /></em>
					</a>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_01_02.png" alt="또는 2천 마일리지 선택" /></span>
				</div>
				<div class="gift2">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/tit_gift_02.png" alt="10만원 이상 구매시" /></h2>
					<a href="/category/category_itemPrd.asp?itemid=1239727" target="_top" class="link mo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_02_01.png" alt="무민 카드지갑" />
						<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_soldout.png" alt="솔드아웃" /></em>
					</a>
					<a href="" onclick="parent.fnAPPpopupProduct(1239727);return false;" target="_top" class="link app">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_02_01.png" alt="무민 카드지갑" />
						<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_soldout.png" alt="솔드아웃" /></em>
					</a>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_02_02.png" alt="또는 5천 마일리지 선택" /></span>
				</div>
				<div class="gift3">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/tit_gift_03.png" alt="20만원 이상 구매시" /></h2>
					<a href="/category/category_itemPrd.asp?itemid=1185800" target="_top" class="link mo">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_03_01.png" alt="무민 3단 도시락, 보존용기 세트" />
						<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_soldout.png" alt="솔드아웃" /></em>
					</a>
					<a href="" onclick="parent.fnAPPpopupProduct(1185800);return false;" target="_top" class="link app">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_03_01.png" alt="무민 3단 도시락, 보존용기 세트" />
						<em><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_soldout.png" alt="솔드아웃" /></em>
					</a>
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_gift_02_03.png" alt="또는 만 마일리지 선택" /></span>
				</div>
			</div>

			<div class="rolling">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/img_gift_01.jpg" alt="" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/img_gift_02.jpg" alt="" />
			</div>

			<!-- for dev msg : 예상 적립 마일리지 확인하기 -->
			<div class="check">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/txt_check.png" alt="예상 적립 마일리지 확인하기 4월 30일 지금 예정마일리지는" /></p>
				<div class="btnwrap">
					<!-- for dev msg : 확인 전 -->
					<div class="point" id="mypoint">456
						<button type="button" onclick="chkmypoint(); return false;"  class="btncheck"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/btn_check.png" alt="확인하기" /></button>
					</div>
				</div>
				<ul>
					<li>고객단순변심에 의한 환불, 교환 시 마일리지는 취소 됩니다.</li>
					<li>시스템 상 실시간 반영이 되지 않아 최종 마일리지 지급액과 차이가 있을 수 있습니다.</li>
				</ul>
			</div>

			<div class="noti">
				<h2><span>이벤트 유의사항</span></h2>
				<ul>
					<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
					<li>사은품은 한정수량이므로, 수량이 소진되었을 경우에는 마일리지만 선택이 가능합니다.</li>
					<li>텐바이텐 배송상품을 구매하지 않을 경우, 마일리지받기만 선택 가능합니다.</li>
					<li>마일리지는 4월30일 일괄 지급됩니다. 이벤트 페이지 내의 지급예정마일리지를 참고하세요.</li>
					<li>상품쿠폰, 보너스쿠폰, 할인카드 등의 사용 후 구매확정금액이 5만원/10만원/20만원 이상이어야 합니다.</li>
					<li>마일리지, 예치금, 기프트카드를 사용하신 경우는 구매확정 금액에 포함되어 사은품을 받으 실 수 있습니다.</li>
					<li>한 주문건의 구매금액 기준 이상일 때 증정, 다른 주문에 대한 누적적용이 되지 않습니다.</li>
					<li>선택하신 사은품의 경우 구매하신 텐바이텐 배송 상품과 함께 배송됩니다.</li>
					<li>텐바이텐 기프트카드를 구매하신 경우는 사은품과 사은쿠폰이 증정되지 않습니다.</li>
					<li>환불이나 교환 시 최종 구매 가격이 사은품 수령 가능금액 미만이 될 경우, 사은품과 함께 반품해야 하며, 마일리지 또한 취소됩니다.</li>
				</ul>
			</div>

			<div class="bnr mo">
				<a href="/event/eventmain.asp?eventid=61488" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/img_event_bnr_main.png" alt="사월의 꿀맛 메인으로 가기" /></a>
				<a href="/event/eventmain.asp?eventid=57669" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/img_event_bnr_tenten.png" alt="텐바이텐 배송 보기" /></a>
			</div>

			<div class="bnr app">
				<a href="" onclick="parent.fnAPPpopupEvent('61488'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/img_event_bnr_main.png" alt="사월의 꿀맛 메인으로 가기" /></a>
				<a href="" onclick="parent.fnAPPpopupEvent('57669'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60831/m/img_event_bnr_tenten.png" alt="텐바이텐 배송 보기" /></a>
			</div>
		</div>
	</div>
	<!-- //iframe -->
	<div id="tempdiv"></div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->