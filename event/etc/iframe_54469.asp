<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 아침 드라마보다 더 극적인 기승전 쇼핑
' History : 2014.08.21 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event54469Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim eCode, blnitempriceyn, giftlimitcnt
dim ename, cEvent, emimg, smssubscriptcount, usercell, userid
	eCode=getevt_code
	userid = getloginuserid()

giftlimitcnt=0
smssubscriptcount=0
usercell=""

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	
set cEvent = nothing

smssubscriptcount = getevent_subscriptexistscount(eCode, userid, "SMS_W", "", "")
usercell = get10x10onlineusercell(userid)

'/상품 제한수량
giftlimitcnt=getgiftlimitcnt( limitgift() )
%>
<!-- #include virtual="/lib/inc/head.asp" -->

<title>생활감성채널, 텐바이텐 > 이벤트 > 기승전쇼핑_담고 싶은 것이 많은 당신을 위한 선물</title>
<style type="text/css">
.mEvt54470 {border-bottom:2px solid #9e2020;}
.mEvt54470 img {vertical-align:top; width:100%;}
.mEvt54470 p {max-width:100%;}
.wellorganized {background-color:#ffecec;}
.wellorganized .section, .wellorganized .section h3 {margin:0; padding:0;}
.wellorganized .sectionA {position:relative; padding-top:10%; }
.wellorganized .sectionA .ico {position:absolute; top:4%; left:0; z-index:5; width:100%;}
.wellorganized .sectionA h3 {position:relative; z-index:10;}
.wellorganized .sectionA .bag {margin-top:5%;}
.wellorganized .sectionA .figure {position:relative; margin-top:3%;}
.wellorganized .sectionA .figure .soldout {position:absolute; top:0; left:0; width:100%;}
.wellorganized .sectionA .btnApp {background-color:#ffd2d2; padding:7% 0; text-align:center;}
.wellorganized .sectionA .btnApp img {width:55%;}
.wellorganized .sectionB {text-align:left;}
.wellorganized .sectionB ul {padding:0 5.41666% 8%;}
.wellorganized .sectionB ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54470/blt_hypen.gif); background-repeat:no-repeat; background-position:0 10px; background-size:9px auto; color:#756354; font-size:16px; line-height:1.5em;}
.wellorganized .sectionB ul li em {color:#d50c0c; font-style:normal;}
@media all and (max-width:480px){
	.wellorganized .sectionB ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 6px; background-size:6px auto;}
}
.wellorganized .sectionC {overflow:hidden; padding:5% 15%; background-color:#ffdcdc;}
.wellorganized .sectionC a {display:block; float:left; width:33.33333%;}
.wellorganized .tab-area {position:relative; padding:15% 0 4%; border-bottom:1px solid #f05a5a; background-color:#d50c0c;}
.wellorganized .tab-area strong {display:block; position:absolute; top:8%; left:0; width:100%;}
.wellorganized .tab-area .tab-nav {overflow:hidden; padding:5% 1.5% 0;}
.wellorganized .tab-area .tab-nav li {float:left; width:25%; padding:0 0.625%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Flash animation */
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.3;}
}
@keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.3;}
}
.flash {-webkit-animation-name:flash; animation-name:flash; -webkit-animation-duration:3s; animation-duration:3s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-7px);}
	60% {-webkit-transform: translateY(-4px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-7px);}
	60% {transform: translateY(-4px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

Kakao.init('c967f6e67b0492478080bcf386390fdd');

function kakaosendcall(){
	kakaosend54469();
}

function kakaosend54469(){
	  Kakao.Link.sendTalkLink({
		  label: '[텐바이텐 EVENT]담고 싶은 것이 많은 당신을 위한 선물!\n한정수량으로 제작된 텐바이텐 x 덴스 쇼퍼백을 선물로 드립니다.',
		  image: {
			src: 'http://imgstatic.10x10.co.kr/offshop/temp/2014/201408/12613.jpg',
			width: '300',
			height: '200'
		  },
		 appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
			<% IF application("Svr_Info") = "Dev" THEN %>
				android: { url: encodeURIComponent('http://bit.ly/1oXcTcE')},
				iphone: { url: 'http://bit.ly/1oXcTcE'}
			<% Else %>
				android: { url: encodeURIComponent('http://bit.ly/1oXcTcE')},
				iphone: { url: 'http://bit.ly/1oXcTcE'}
			<% End If %>
			}
		  },
		  installTalk : Boolean
	  });
}

</script>

</head>
<body>

<!-- 기승전쇼핑 -->
<div class="mEvt54470">
	<div class="wellorganized">
		<div class="section sectionA">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/txt_shopping_app.png" alt="앱에서 쇼핑하면 엄청난 일이 벌어진다" /></p>
			<span class="ico animated flash"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/ico_touch.png" alt="" /></span>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/tit_present_for_you.png" alt="담고 싶은 것이 많은 당신을 위한 선물" /></h3>
			<p class="gift"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/txt_gift.png" alt="텐바이텐 APP에서 3만원 이상 쇼핑하시면 한정수량으로 제작된 텐바이텐 X 덴스 쇼퍼백을 선물로 드립니다. 이벤트 기간은 8월 25일부터 9월 1일까지입니다." /></p>
			<p class="bag"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/txt_bag.png" alt="텐바이텐 X thence 쇼퍼백 선착순 2,000명! 한정수량이라 조기에 품절 될 수 있습니다. 서두르세요!" /></p>
			<div class="figure">
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/img_bag.png" alt="" />
				<% ' for dev msg : 품절시 style="display:block;로 바꿔주세요 %>
				<p class="soldout" style="display:<% if giftlimitcnt > 0 then response.write "none" %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/txt_sold_out.png" alt="종료되었습니다." /></p>
			</div>
			<div class="btnGo"><a href="/event/eventmain.asp?eventid=54511" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/btn_go_play.gif" alt="텐바이텐 X 덴스 쇼퍼백 PLAY 바로가기" /></a></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/txt_check_delivery.gif" alt="텐바이텐 배송 어떻게 확인하나요? 상품 정보 옆에 배송 구분란에 텐바이텐 배송 문구가 기재되어 있다면 이게 바로 텐텐배송이에요!" /></p>
			<div class="btnApp">
				<a href="http://m.10x10.co.kr/apps/link/?720140822" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/btn_go_app.png" alt="텐바이텐 앱 바로가기" /></a>
			</div>
		</div>

		<div class="section sectionB">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
				<li>사은품은 한정수량이므로, 수량이 모두 소진될 경우에는 이벤트가 자동 종료됩니다.</li>
				<li>상품 쿠폰, 보너스 쿠폰, 할인카드 등의 사용 후 <em>구매확정 금액이 3만원 이상</em> 이어야 합니다.</li>
				<li>구매 시, <em>텐바이텐 배송상품을 반드시 포함</em>해야 사은품을 받을 수 있습니다.</li>
				<li>마일리지, 예치금, GIFT 카드를 사용하신 경우는 구매확정금액에 포함되어 사은품을 받으실 수 있습니다.</li>
				<li>1회의 주문 건이 구매금액 기준 이상일 때 증정하며, 다른 주문에 대한 누적적용이 되지 않습니다.</li>
				<li>쇼퍼백은 구매하신 텐바이텐 배송 상품과 함께 배송됩니다.</li>
				<li>GIFT 카드를 구매하신 경우는 사은품과 사은 쿠폰이 증정되지 않습니다.</li>
				<li>환불이나 교환 시, 최종 구매 가격이 사은품 수령 가능 금액 미만이 될 경우, 사은품과 함께 반품해야 합니다.</li>
			</ul>
		</div>
		<%
		'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
		dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
		snpTitle = Server.URLEncode(ename)
		snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
		snpPre = Server.URLEncode("텐바이텐 이벤트")
		snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
		snpTag2 = Server.URLEncode("#10x10")
		snpImg = Server.URLEncode(emimg)
		%>
		<div class="section sectionC">
			<a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/ico_sns_twitter.png" alt="트위터" /></a>
			<a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/ico_sns_facebook.png" alt="페이스북" /></a>
			<a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/ico_sns_kakao.png" alt="카카오톡" /></a>
		</div>

		<div class="section sectionD tab-area">
			<strong class="animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54470/txt_wellorganized_shopping.png" alt="아침 드라마보다 더 극적인 기승전 쇼핑" /></strong>
			<ul class="tab-nav">
				<!-- #include virtual="/event/etc/iframe_54469_topmenu.asp" -->
			</ul>
		</div>
	</div>
</div>
<!-- //기승전쇼핑 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->