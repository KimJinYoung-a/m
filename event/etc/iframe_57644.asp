<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  오빠나믿지? socar
' History : 2014.12.11 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event57644Cls.asp" -->

<%
dim eCode, userid, i, addr_si
	eCode=getevt_code
	userid = getloginuserid()
	addr_si = getaddr_si()

dim subscriptcount, firstsubscriptcount, couponexistscount
	subscriptcount=0
	firstsubscriptcount=0
	couponexistscount=0

'//본인 참여 여부
if userid<>"" then
	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate(), "", "")
	'//본인처음참여수
	firstsubscriptcount = getevent_subscriptexistscount(eCode, userid, "", "1", "")
	'//본인쿠폰다운로드수
	couponexistscount = getbonuscouponexistscount(userid, couponval57644(), "", "", "")
end if

%>

<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt57645 img {vertical-align:top;}
.socar {}
.topic {position:relative;}
.topic .heart {position:absolute; top:8%; left:60%; width:4.5%;}
.take {padding:10% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57645/bg_sky.gif) repeat-y 0 0; background-size:100% auto;}
.take legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.take .col {margin:7% 3.4% 0; padding:5%; background-color:#fff;}
.take .col .select-wrap {overflow:hidden; padding:4% 2%; background-color:#ebf7fb;}
.take .col .select-wrap .styled-selectbox {float:left; width:50%; padding:0 2%;}
.take .col .select-wrap .styled-selectbox select {width:100%; border:1px solid #939393; border-radius:0; background:url(http://fiximage.10x10.co.kr/m/2014/common/element_select2.png) no-repeat 98% 50% #fff;}
.take .col3 {padding-bottom:0;}
.take .col3 .itext {padding:4%%; background-color:#ebf7fb;}
.take .col3 input {width:100%; border:1px solid #939393; border-radius:0; text-align:center;}
.take .col3 .example {margin-top:2%; color:#6d6d6d; font-size:12px; line-height:1.313em; text-align:center;}
.btn-join {width:60%; margin:5% auto 0;}
.take ul {margin:0 3.4%; padding:5%; background-color:#fff;}
.take ul li {margin-top:5px; padding-left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57645/blt_arrow_blue.png); background-repeat:no-repeat; background-position:0 5px; background-size:6px 6px; color:#535353; font-size:12px; line-height:1.25em;}
.btn-submit {width:66.25%; margin:35px auto 0; text-align:center;}
.btn-submit input {width:100%;}

.about {padding:10% 0; background-color:#effefc;}
.btn-down {width:66%; margin:3% auto 0;}

.noti {padding-bottom:10%; background-color:#fff;}
.noti ul {padding:0 6%;}
.noti ul li {margin-top:6px; padding-left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57645/blt_arrow_red.png); background-repeat:no-repeat; background-position:0 5px; background-size:6px 6px; color:#535353; font-size:12px; line-height:1.25em;}

/* layer popup */
.lypop {position:absolute; top:31.5%; left:50%; z-index:50; width:90%; margin-left:-45%; background-color:#fff;}
.lypop-inner {margin:5px; border:3px solid #eee;}
.btn-close {overflow:hidden; display:block; position:relative; width:142px; height:40px; margin:7% auto 10%; background-color:#d50c0c; color:#fff;}
.btn-close span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57645/btn_close.gif) no-repeat 50% 0; background-size:142px 40px;}
.mask {position:absolute; top:0; left:0; z-index:20; width:100%; height:100%; background-color:rgba(000,000,000,.5);}

@media all and (min-width:480px){
	.take .col3 .example {font-size:18px;}
	.take ul li {padding-left:15px; background-size:9px 9px; font-size:17px;}
	.noti ul li {padding-left:15px; background-size:9px 9px; font-size:17px;}
	.btn-close {width:214px; height:66px;}
	.btn-close span {background-size:214px 66px;}
}

.animated {-webkit-animation-duration:1s; animation-duration:1s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* FadeIn animation */
@-webkit-keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes fadeIn {
	0% {opacity:0;}
	100% {opacity:1;}
}
.fadeIn {-webkit-animation-name: fadeIn; animation-name: fadeIn; -webkit-animation-iteration-count:5; animation-iteration-count:5;}
</style>
<script type="text/javascript">
$(function(){
/* layer popup */
	$("#lypop .btn-close").click(function(){
		$("#lypop").fadeOut();
		$(".mask").fadeOut();
	});

	$(".mask").click(function(){
		$("#lypop").fadeOut();
		$(".mask").fadeOut();
	});
});

function jscouponSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If getnowdate>="2014-12-15" and getnowdate<"2014-12-22" Then %>
			<% if subscriptcount <> 0 then %>
				alert("하루에 한번만 참여 가능 합니다.");
				return;
			<% else %>
				<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
					alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
					return;
				<% else %>
					if ($("#si").val()==""){
						alert("쏘카를 수령하실 도/시 를 선택해 주세요.");
						return;
					}
					if ($("#gu").val()==""){
						alert("쏘카를 수령하실 시/군/구 를 선택해 주세요.");
						return;
					}
					if ($("#mm").val()==""){
						alert("쏘카를 수령하실 월을 선택해 주세요.");
						return;
					}
					if ($("#dd").val()==""){
						alert("쏘카를 수령하실 일을 선택해 주세요.");
						return;
					}
					if ($("#email").val()==""){
						alert("쏘카에 가입된 이메일 ID를 입력해 주세요.");
						return;
					}
					if ($("#email").val()=="쏘카에 가입된 이메일 ID를 입력해주세요. (예: example@10x10.co.kr)"){
						alert("쏘카에 가입된 이메일 ID를 입력해 주세요.");
						return;
					}					

					$("#socarid").val($("#email").val())
					frm.action="/event/etc/doEventSubscript57644.asp";
					frm.target="evtFrmProc";
					frm.mode.value='couponinsert';
					frm.submit();
				<% end if %>
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function mmchange(v){
	<% If IsUserLoginOK() Then %>
		<% If getnowdate>="2014-12-15" and getnowdate<"2014-12-22" Then %>
			if (v==""){
				return;
			}
		
			var str = $.ajax({
				type: "GET",
				url: "/event/etc/doEventSubscript57644.asp",
				data: "mode=mmchange&si="+v,
				dataType: "text",
				async: false
			}).responseText;
			//alert( str );
			if (str==''){
				//alert('정상적인 경로가 아닙니다');
				return;
			}else if (str.substring(0,2)=='02'){
				alert('이벤트 응모 기간이 아닙니다.');
				return;
			}else if (str.substring(0,2)=='03'){
				alert('도/시 를 선택해 주세요.');
				return;
			}else if (str.substring(0,2)=='01'){
				$("#gu").html(str.substring(5,3000))
			}
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<div class="mEvt57645">
	<div class="socar">
		<div class="topic">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_socar.gif" alt ="텐바이텐과 쏘카 오빠 나 믿지?" /></p>
			<span class="heart animated fadeIn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57644/img_heart.png" alt ="" /></span>
			<p class="desc"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_desc.gif" alt ="송년회로 얇아진 여러분의 오빠들을 위해 만든 우렁각시 이벤트! 담당자는 솔로지만, 여러분은 커플이니까요! 오직 단 한 커플을 위한 특별한 선물의 주인공이 되어보세요. 이벤트 기간은 2014년 12월 15일부터 12월 21까지 입니다." /></p>
			<p class="gift"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_gift.gif" alt ="단 한 커플에세 써모그 커플보틀, 타이맥스 커플 시계, 48시간 쏘카 무료 이용권, 커플 울 머플러를 드립니다. 당신이 원하는 날, 선물을 싣고 텐바이텐과 쏘카가 직접 찾아갑니다. 하루에 한번 응모 가능하며, 응모 횟수가 많을 수록 당첨 확률이 높아집니다. 첫 응모 하시는 모든 분께는 텐바이텐 삼천원 쿠폰과 쏘카 만원 금액권을 드립니다." /></p>
		</div>

		<!-- 응모하기 -->
		<div class="take">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/tit_event.png" alt ="이벤트 응모" /></h3>
				<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
				<input type="hidden" name="mode">
				<fieldset>
				<legend>응모하기</legend>
					<div class="col col1">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_select_site.gif" alt ="1. 쏘카 수령 지역 선택하기 당첨 시, 쏘카를 수령/반납할 장소를 선택해주세요." /></p>
						<div class="select-wrap">
							<div class="styled-selectbox">
								<select id='si' name='si' onchange='mmchange(this.value);' class="select" title="도/시 선택하기">
									<option value=''>도/시 선택하기</option>

										<% if isarray(addr_si) then %>
										<% for i = 0 to ubound(addr_si,2) %>
										<option value="<%= addr_si(0,i) %>"><%= addr_si(0,i) %></option>
										<% next %>
									<% end if %>
								</select>
							</div>

							<div class="styled-selectbox">
								<select id='gu' name='gu' class="select" title="시/군/구 선택하기">
									<option value=''>시/군/구 선택하기</option>
								</select>
							</div>
						</div>
					</div>

					<div class="col col2">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_select_date.gif" alt ="2. 쏘카 수령 날짜 선택하기 당첨 시, 쏘카를 수령할 날짜를 선택해주세요." /></p>
						<div class="select-wrap">
							<div class="styled-selectbox">
								<select id="mm" name="mm" class="select" title="월 선택하기">
									<option value=''>월 선택하기</option>
									<option value="01">2015년 01월</option>
									<option value="12">2014년 12월</option>
								</select>
							</div>

							<div class="styled-selectbox">
								<select id="dd" name="dd" class="select" title="일 선택하기">
									<option value=''>일 선택하기</option>

									<% for i = 1 to 31 %>
										<option value="<%= Format00(2,i) %>"><%= Format00(2,i) %>일</option>
									<% next %>
								</select>
							</div>
						</div>
					</div>

					<div class="col col3">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_select_member.gif" alt ="3. 쏘카 회원 인증하기 쏘카 이용권을 받을 ID를 입력해주세요." /></p>
						<div class="itext">
							<input type="text" name="email" id="email" title="쏘카에 가입된 이메일 ID를 입력" placeholder="쏘카에 가입된 이메일 ID를 입력해주세요." />
							<p class="example">( 예 : example@10x10.co.kr )</p>
						</div>
						<div class="btn-join">
							<% if isApp=1 then %>
								<a href="" onclick="parent.fnAPPpopupExternalBrowser('http://goo.gl/esPvPv'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/btn_join_socar.gif" alt ="쏘카 가입하러 바로가기" /></a>
							<% else %>
								<a href="http://goo.gl/esPvPv" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/btn_join_socar.gif" alt ="쏘카 가입하러 바로가기" /></a>
							<% end if %>
						</div>
					</div>

					<ul>
						<li>쏘카에 신규가입 시, 프로모션 코드에 <strong class="cRd1">텐바이텐</strong>을 입력해주세요.</li>
						<li>입력하신 내역은 당첨 후, 변경이 불가합니다.<br /> 잘못 기재된 부분이 없는지 꼭 다시 확인해주세요.</li>
						<li>입력한 쏘카 ID로 쏘카 금액권이 지급됩니다.<br /> 정확한 쏘카 ID를 입력해주세요.</li>
					</ul>
					<div class="btn-submit"><a href="" onclick="jscouponSubmit(evtFrm1); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/57645/btn_submit.gif" alt ="응모하기" /></a></div>
				</fieldset>
				</form>
		</div>

		<div class="about">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/tit_about_socar.gif" alt ="텐바이텐의 친구 쏘카를 소개합니다." /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_about_socar.gif" alt ="언제 어디서나 내 차처럼 스마트폰 앱으로 예약하는 10분 단위 차량 대여서비스! 원하는 시간만큼 원하는 장소에서 원하는 차량을 빌리세요!" /></p>
			<div class="btn-down">
				<% if isApp=1 then %>
					<a href="" onclick="parent.fnAPPpopupExternalBrowser('http://m.socar.kr/dn'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/btn_down.gif" alt ="쏘카 앱 다운로드 받기" /></a>
				<% else %>
					<a href="http://m.socar.kr/dn" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/btn_down.gif" alt ="쏘카 앱 다운로드 받기" /></a>
				<% end if %>
			</div>
		</div>

		<div class="noti">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/tit_noti.gif" alt ="이벤트 유의사항" /></h2>
			<ul>
				<li>텐바이텐과 쏘카 회원을 대상으로 한 이벤트 입니다.</li>
				<li>텐바이텐 쿠폰과 쏘카 쿠폰은 ID 당 한 번, 첫 응모시에 지급됩니다.</li>
				<li>텐바이텐 쿠폰은 응모와 동시에 즉시 지됩니다.</li>
				<li>응모 시에 선택한 날짜와 장소는 당첨 후, 변경이 불가합니다.</li>
				<li>본 이벤트를 통해 쏘카에 가입하시는 분은 자동으로 쏘카 쿠폰이 지급됩니다.</li>
				<li>기존 쏘카 회원에게는 쏘카 쿠폰을 12월 24일 (수)에 일괄 지급합니다.</li>
				<li>응모횟수가 많은 수록 &apos;단 한 커플을 위한 선물&apos;에 당첨될 확률이 높아집니다.</li>
				<li>&apos;단 한 커플을 위한 선물&apos;을 수령 시에는 개인정보를 요청할 수 있습니다.</li>
			</ul>
		</div>

		<!-- 레이어 팝업 -->
		<!-- for dev msg : 처음 응모시만 보여주세요 style="display:block;" -->
		<div id="lypop" class="lypop" style="display:none;">
			<div class="lypop-inner">
				<p class="thanks"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_thank_you.gif" alt ="첫 응모, 감사합니다! 첫 데이트처럼 짜릿한 선물을 드릴게요!" /></p>
				<p class="gift"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_first_gift.gif" alt ="3만원 이상 구매시 사용가능한 텐바이텐 3천원 할인 쿠폰과 2만원 이상 이용시 사용 가능한 쏘카 1만원 금액권을 드립니다." /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_coupon.gif" alt ="텐바이텐 할인쿠폰은 응모하신 ID로 자동 발급되었습니다. 쏘카 1만원 금액권은 입력하신 쏘카 ID로 12월 24일에 일괄 지급 됩니다. 신규회원은 프로모션코드에 텐바이텐을 입력하시면 바로 받으실 수 있습니다! " /></p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57645/txt_entry.gif" alt ="다섯 쌍에게 드리는 타이맥스 커플시계 + 커플 울 머플러 + 써모머그 커플보틀 + 48시간 쏘카 무료 이용권 선물에도 자동 응모되셨습니다. 응모 횟수가 많을 수록 당첨 확률이 높아지니 내일도 잊지 말고 또 응모해주세요!" /></p>
				<button type="button" class="btn-close"><span></span>닫기</button>
			</div>
		</div>
		<!-- for dev msg : 처음 응모시만 보여주세요 style="display:block;" -->
		<div class="mask" style="display:none;"></div>
	</div>
	
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->