<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : GS25 NFC태그 이벤트 (APP)
' History : 2014.07.23 허진원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%

%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<style type="text/css">
.bananaMilk {position:relative;}
.bananaMilk img {width:100%; vertical-align:top;}
.bananaMilk p {max-width:100%;}
.bananaMilk section {display:block; margin:0; padding:0;}
.bananaMilk .visual {position:relative;}
.bananaMilk .visual .ico {position:absolute; top:0; left:23.5%; width:26.5625%;}
.bananaMilk section:nth-child(2) {position:relative; padding-bottom:46%; background-color:#8bcfbc;}
.bananaMilk legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.bananaMilk fieldset {border:0;}
.bananaMilk .personalInfo {position:absolute; top:32%; left:0; width:100%;}
.bananaMilk .personalInfo div {padding:0 15%;}
.bananaMilk .personalInfo div:nth-child(2) {margin-top:3%;}
.bananaMilk .personalInfo label img, .personalInfo .label img {width:20%; margin-right:5px; vertical-align:middle;}
.bananaMilk .personalInfo input[type=text], .personalInfo input[type=tel] {height:36px; border:1px solid #72ac9c; padding:0 5px; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; -webkit-border-radius:0; -webkit-appearance:none; font-size:18px; font-weight:bold;}
.personalInfo select {height:36px; border:1px solid #72ac9c; margin:0; padding:0 5px; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; -webkit-border-radius:0; background-color:#fff; -webkit-appearance:none; background:white url(http://fiximage.10x10.co.kr/m/2013/common/element_select.png) no-repeat right 50%; background-size:17px 8px; font-size:18px; font-weight:bold;}
.bananaMilk .personalInfo input[type=text] {width:72%;}
.bananaMilk .personalInfo select {width:22%;}
.bananaMilk .personalInfo input[type=tel] {width:22%;}
.bananaMilk .personalInfo .agree {overflow:hidden; margin:5% 10% 6%;}
.bananaMilk .personalInfo .agree li {float:left; position:relative; width:50%;}
.bananaMilk .personalInfo .agree li label img {width:100%;}
.bananaMilk .personalInfo .agree li input[type=checkbox] {position:absolute; top:50%; left:4%; width:20px; height:20px; margin-top:-10px; border-radius:10px;}
.bananaMilk .personalInfo input[type=image] {width:100%;}
.bananaMilk section:nth-child(3) {padding-bottom:5%;}
.bananaMilk section:nth-child(3) ul {margin-top:4%; padding:0 7.1875%;}
.bananaMilk section:nth-child(3) ul li {margin-top:1px; color:#444; font-size:16px; line-height:1.5em;}
@media all and (max-width:480px){
	.bananaMilk .personalInfo input[type=text] {width:72%;}
	.bananaMilk .personalInfo input[type=tel] {width:20%;}
	.bananaMilk .personalInfo input[type=text], .personalInfo input[type=tel] {height:24px; font-size:12px;}
	.personalInfo select {height:24px; background-size:15px 7px; font-size:12px;}
	.bananaMilk .personalInfo .agree li input[type=checkbox] {width:12px; height:12px; margin-top:-6px;}
	.bananaMilk section:nth-child(3) ul li {margin-top:1px; color:#444; font-size:11px; line-height:1.5em;}
}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Shake animation */
@-webkit-keyframes shake {
	0%, 100% {-webkit-transform: translateX(0);}
	10%, 30%, 50%, 70%, 90% {-webkit-transform: translateX(-10px);}
	20%, 40%, 60%, 80% {-webkit-transform: translateX(10px);}
}
@keyframes shake {
	0%, 100% {transform: translateX(0);}
	10%, 30%, 50%, 70%, 90% {transform: translateX(-10px);}
	20%, 40%, 60%, 80% {transform: translateX(10px);}
}
.shake {-webkit-animation-name: shake; animation-name: shake;}
</style>
<script type="text/javascript">
var vUUID;

$(function(){
	<% if flgDevice="A" or flgDevice="I" then %>
	window.location="custom://uuid.custom?callback=jsCallbackUUID";
	<% else %>
	alert("안드로이드 또는 아이폰만 참여가 가능합니다.");
	<% end if %>
});

function fnChkSubmit() {
	<% if date>="2014-09-01" then %>
		alert("죄송합니다. 종료된 이벤트 입니다.");
		return;
	<% end if %>

	var frm = document.frmInput;
	if(!frm.vname.value) {
		alert("응모하시는 분의 본명을 남겨주세요");
		frm.vname.focus();
		return;
	}
	if(!(frm.vhp1.value=="010"||frm.vhp1.value=="011"||frm.vhp1.value=="016"||frm.vhp1.value=="017"||frm.vhp1.value=="018"||frm.vhp1.value=="019")) {
		alert("경품이 발송될 정확한 연락처를 남겨주세요.");
		frm.vhp1.focus();
		return;
	}
	if(frm.vhp2.value.length<3) {
		alert("경품이 발송될 정확한 연락처를 남겨주세요.");
		frm.vhp2.focus();
		return;
	}
	if(frm.vhp3.value.length<4) {
		alert("경품이 발송될 정확한 연락처를 남겨주세요.");
		frm.vhp3.focus();
		return;
	}
	if(!frm.agreeyes.checked) {
		alert("개인정보 수집 정책에 동의하셔야 응모가 가능합니다.");
		return;
	}

	if(!vUUID||vUUID=="undefined") {
		alert("처리중 오류가 발생했습니다.\n앱을 재설치해주세요.\n같은 오류가 반복될 경우 텐바이텐 고객센터(1644-6030)으로 연락주세요.");
		return;
	}
	frm.uuid.value=vUUID;
	frm.submit();
}

function jsCallbackUUID(retval){
    vUUID = retval;
}
</script>
</head>
<body>
<body class="event">
	<!-- wrapper -->
	<div class="wrapper">
		<!-- #content -->
		<div id="content">
			<!-- 텐바이텐 앱 다운받고 바나나맛 우유 받으세요! -->
				<div class="bananaMilk">
					<section>
						<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/tit_first_meet.gif" alt="텐바이텐 앱과의 첫만남, 반갑습니다!" /></h1>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_everyone_gift.gif" alt="아래 이벤트에 참여하시는 모든 분께 선물을 드립니다" /></p>
						<div class="visual">
							<span class="ico animated shake"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_two.png" alt="둘중 하나 100퍼센트 당첨" /></span>
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/img_visual_gift.jpg" alt="" />
						</div>
					</section>

					<section>
						<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/tit_event_takepart.gif" alt="이벤트 참여하기" /></h2>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_personal_info.gif" alt="이벤트 경품 지급을 위해 개인정보를 입력해 주세요." /></p>
						<!-- for dev msg : 개인정보 입력 -->
						<form name="frmInput" method="POST" action="doEventSubscript.asp" target="evtFrmProc">
						<input type="hidden" name="uuid" value="">
							<fieldset>
							<legend>개인정보 입력</legend>
								<div class="personalInfo">
									<div>
										<label for="username"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_label_name.gif" alt="이름" /></label>
										<input type="text" name="vname" id="username" maxlength="16" value="" />
									</div>
									<div>
										<span class="label"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_label_mobile.gif" alt="연락처" /></span>
										<select name="vhp1" title="휴대폰 번호 앞자리 입력">
											<option value="010">010</option>
											<option value="011">011</option>
											<option value="016">016</option>
											<option value="017">017</option>
											<option value="018">018</option>
											<option value="019">019</option>
										</select> -
										<input type="tel" name="vhp2" title="휴대폰 번호 가운데자리 입력" maxlength="4" value="" /> -
										<input type="tel" name="vhp3" title="휴대폰 번호 뒷자리 입력" maxlength="4" value="" />
									</div>
									<ul class="agree">
										<li>
											<input type="checkbox" id="agreeyes" name="agreeyes" />
											<label for="agreeyes"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_label_agree.gif" alt="개인정보 수집 정책에 동의" /></label>
										</li>
										<li><a href="" onclick="jsOpenModal('ajax_privateterms.asp'); return false;" class="btn-show-modal"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/btn_go_personal_info.gif" alt="개인정보수집정책 보기" /></a></li>
									</ul>
									<div class="btnSubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/53715/btn_submit.png" alt="응모확인" onclick="fnChkSubmit(); return false;" /></div>
								</div>
							</fieldset>
						</form>
						<!-- //for dev msg : 개인정보 입력 -->
					</section>

					<section>
						<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/tit_noti.gif" alt="유의사항" /></h2>
						<ul>
							<li>바나나맛 우유는 매일 9시부터 선착순으로 지급됩니다.</li>
							<li>오전 0시 ~오전 9시까지는 텐바이텐 쿠폰이 지급됩니다.</li>
							<li>바나나맛 우유 소진 후에는 텐바이텐 쿠폰이 지급됩니다.</li>
							<li>바나나맛 우유는 하루 150개 한정 수량입니다.</li>
							<li>한개의 디바이스에서 1회만 참여하실 수 있습니다.</li>
							<li>한 개의 휴대폰 번호 당 1회만 참여하실 수 있습니다.</li>
							<li>잘못된 휴대폰 번호는 당첨이 자동 취소됩니다.</li>
							<li>응모 내역이 있는 다른 번호로의 양도 및 재발송은 불가합니다.</li>
							<li>응모자가 많아 문자 수신이 지연될 수 있습니다.</li>
							<li>모바일 쿠폰을 문자로 받지 못하신 고객님은 텐바이텐 고객센터 <a href="tel:1644-6030" style="color:#444; text-decoration:none;">1644-6030</a>으로 문의주시기 바랍니다.</li>
						</ul>
					</section>
					<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
				</div>
				<!-- //텐바이텐 앱 다운받고 바나나맛 우유 받으세요! -->
		</div><!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			
		</footer><!-- #footer -->

	</div><!-- wrapper -->
	<div id="modalCont" style="display:none;"></div>    
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->