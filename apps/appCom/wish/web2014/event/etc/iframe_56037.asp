<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 정말 빼빼로가 좋아요
' History : 2014.10.30 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event56037Cls.asp" -->

<%
dim userid, eCode
	userid = getloginuserid()
	eCode=getevt_code

dim subscriptcount, totalsubscriptcountmacbook, totalsubscriptcountgiftcard, totalsubscriptcountbonuscoupon, totalbonuscouponcount
	subscriptcount=0
	totalsubscriptcountmacbook=0
	totalsubscriptcountgiftcard=0
	totalsubscriptcountbonuscoupon=0
	totalbonuscouponcount=0

'//당첨 플래그 winox 1:맥북 / 2:기프트카드 / 3:보너스쿠폰 / 5:꽝
totalsubscriptcountmacbook = getevent_subscripttotalcount(eCode, "", "1", "")
totalsubscriptcountgiftcard = getevent_subscripttotalcount(eCode, "", "2", "")
totalsubscriptcountbonuscoupon = getevent_subscripttotalcount(eCode, "", "3", "")
totalbonuscouponcount = getbonuscoupontotalcount(datecouponval, "", "", "")

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "", "")
end if

%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
.mEvt56037 {background-color:#fff;}
.mEvt56037 img {width:100%; vertical-align:top;}
.like-pepero .heading {position:relative; background-color:#fff5e8; padding-top:48%;}
.like-pepero .heading .like {position:absolute; top:12%; left:0; width:100%;}
.like-pepero .heading .deco {display:block; position:absolute; top:12%; left:5%; width:92%; margin:0 auto;}
.like-pepero .package {position:relative; background-color:#fff5e8;}
.like-pepero .package .macbook {position:absolute; top:4.5%; left:0; width:100%;}
.like-pepero .package .btn-challenge {position:absolute; bottom:7%; left:50%; width:80%; margin-left:-40%;}
.like-pepero .package .btn-challenge button {overflow:hidden; position:relative; width:100%; height:0; padding-bottom:18%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/56037/btn_challenge.gif) no-repeat 0 0; background-size:100% auto;}
.like-pepero .package .btn-challenge button span {position:absolute; top:0; left:0; width:100%; height:100%; color:#432400; text-indent:-999em;}
.like-pepero .giveaway {position:relative;}
.like-pepero .giveaway ul {overflow:hidden; position:absolute; top:20%; left:0; width:100%; padding:0 2%;}
.like-pepero .giveaway ul li {float:left; width:33.333%; padding-bottom:10px; text-align:center;}
.like-pepero .giveaway ul li span {display:block; position:relative; z-index:10; width:84%; margin:15px auto 0; background-color:#fff; box-shadow:0 0 3px 3px rgba(174,000,000,0.1);}
.like-pepero .giveaway ul li span:after {content:' '; position:absolute; top:-2px; left:50%; z-index:5; width:10px; height:10px; margin-left:-5px; background-color:#fff; box-shadow:0 0 3px 3px rgba(174,000,000,0.1); transform:matrix(0.5,1,0.45,-1,0,0); -moz-transform:matrix(0.5,1,0.45,-1,0,0); -webkit-transform:matrix(0.5,1,0.45,-1,0,0);}
.like-pepero .giveaway ul li strong {display:inline-block; position:relative; z-index:10; padding:10px 0 8px; background-color:#fff; color:#432400; font-size:10px; line-height:0.938em;}
.like-pepero .movie {padding-top:5%; background-color:#fff5e8;}
.like-pepero .movie .youtube {overflow:hidden; position:relative; height:0; margin:0 3% 10%; padding-bottom:56.25%; background:#000;}
.like-pepero .movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%;}
.like-pepero .noti {padding-bottom:7%;}
.like-pepero .noti ul {margin-top:4%; padding:0 4.5%;}
.like-pepero .noti ul li {margin-top:5px; padding-left:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/56037/blt_arrow.gif) no-repeat 0 3px; background-size:6px 7px; font-size:11px; line-height:1.375em;}
@media all and (min-width:480px){
	.like-pepero .giveaway ul li span {margin-top:20px;}
	.like-pepero .giveaway ul li strong {padding:15px 0 13px; font-size:15px;}
	.like-pepero .noti ul li {margin-top:10px; padding-left:16px; background-position:0 5px; background-size:9px 10px; font-size:15px;}
}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* FadeIn animation */
@-webkit-keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
.fadeIn {-webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-name:fadeIn; animation-name:fadeIn; -webkit-animation-iteration-count:5; animation-iteration-count:5;}
</style>
<script type="text/javascript">
$(function() {
	$("#bounce").hide();
	setInterval(function(){
		bounceShow();
	},1000);
	function bounceShow(){
		$("#bounce").delay("slow").fadeIn("slow");
	}
});

function jseventSubmit(frm){
	<% If not( IsUserLoginOK() ) Then %>
		//alert('로그인을 하셔야 참여가 가능 합니다');		
		parent.calllogin();
		return;
	<% Else %>
		<% If not(left(currenttime,10)>="2014-11-03" and left(currenttime,10)<"2014-11-10") Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 then %>
				alert("한 개의 아이디당 하루 한 번만 응모하실 수 있습니다.");
				return;
			<% else %>
				<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
					alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
					return;
				<% else %>
					frm.action="doEventSubscript56037.asp";
					frm.target="evtFrmProc";
					frm.mode.value='iteminsert';
					frm.submit();
				<% end if %>
			<% end if %>
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<div class="mEvt56037">
	<div class="like-pepero">
		<div class="heading">
			<p class="like"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/txt_like_pepero.png" alt="" /></p>
			<span class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/img_deco.png" alt="" /></span>
			<!--p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/txt_like_pepero.gif" alt="텐바이텐과 손을 맞잡고 말해보아요 정말 빼빼로가 좋아요? 진짜로?!" /></p-->
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/txt_event.gif" alt="빼빼로는 그저 거들 뿐! 그와 그녀가 원하는 건 따로 있다! 애플 맥북 에어 2대가 담긴 스페셜 패키지에 도전하세요! 이벤트 기간은 11월 3일부터 11월 9일까지며, 당첨자에게는 11월 10일까지 배송완료 보장해 드립니다." /></p>
		</div>

		<div class="package">
			<div id="bounce" class="macbook"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/img_macbook.png" alt="" /></div>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/txt_package.gif" alt="당신의 연인은 이런 걸 원한다 패키지는 13.3인치 애플 맥북 에어 2대와 빼빼로와 초콜릿으로 구성되어 있습니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/txt_event_guide.gif" alt="참여방법은 하루에 한번 오늘 당첨 도전하기후 바로 바로 즉석 경품을 확인하실 수 있습니다. 당첨 팁 매일 응모할 수록 당첨 확률도 함께 올라갑니다." /></p>

			<div class="btn-challenge">
				<button type="button" onclick="jseventSubmit(evtFrm1); return false;" class="animated fadeIn"><span>오늘의 당첨 도전</span></button>
			</div>
		</div>

		<div class="giveaway">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/tit_giveaway.gif" alt="당첨 경품" /></h3>
			<ul>
				<li>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/img_giveaway_01.png" alt="당신의 연인은 이런걸 원한다 패키지 한명" />
					<span><strong id="div1">당첨자수 : <%= totalsubscriptcountmacbook %>명</strong></span>
				</li>
				<li>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/img_giveaway_02.png" alt="텐바이텐 기프트카드 삼만원권 열명" />
					<span><strong id="div2">당첨자수 : <%= totalsubscriptcountgiftcard %>명</strong></span>
				</li>
				<li>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/img_giveaway_03.png" alt="텐바이텐 오천원 할인 쿠폰 천명" />
					<span><strong id="div3">당첨자수 : <%= totalsubscriptcountbonuscoupon %>명</strong></span>
				</li>
			</ul>
		</div>

		<div class="movie">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/tit_you_want.gif" alt="당신의 연인은 이런 걸 원한다 패키지는 이렇게 만들었어요" /></h3>
			<div class="youtube">
				<iframe src="//player.vimeo.com/video/110531911" frameborder="0" title="당신의 연인은 이런 걸 원한다 패키지 영상" allowfullscreen></iframe>
			</div>
			<div class="btn-event"><a href="/event/eventmain.asp?eventid=55737" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/btn_event_pepero.gif" alt="텐바이텐 빼빼로 데이 이벤트 구경가기" /></a></div>
		</div>

		<div class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/56037/tit_noti.gif" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>본 이벤트는 비트윈 고객을 위한 단독 이벤트이며, 비트윈 이벤트 상자를 통해서만 들어올 수 있습니다.</li>
				<li>텐바이텐 로그인 후, 이벤트 참여가 가능합니다.</li>
				<li>&lt;당신의 연인은 이런 걸 원한다&gt; 패키지는 13.3inch 애플 맥북 에어2대와 빼빼로가 담겨있습니다.</li>
				<li>맥북 모델명: 애플 맥북에어 13형 MacBook Air 13.3/1.3/4/256 MD761KH/A 입니다.</li>
				<li>&lt;당신의 연인은 이런 걸 원한다&gt; 패키지 당첨자의 제세공과금은 텐바이텐 부담이며, 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				<li>기프트 카드와 쿠폰 당첨 시, 해당 고객 ID로 발급됩니다.</li>
				<li>쿠폰 사용기간은 11월 16일까지이며, 4만원 이상 구매 시 사용 가능합니다.</li>
			</ul>
		</div>
	</div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->