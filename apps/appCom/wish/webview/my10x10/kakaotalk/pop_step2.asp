<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 카카오톡
'	History	:  2014.01.08 한용민 모바일페이지 이동/생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim sflow, usrHp1, usrHp2, usrHp3
	sflow	= requestCheckVar(Request.form("flow"),3)
	usrHp1	= requestCheckVar(Request.form("hpNo1"),4)
	usrHp2	= requestCheckVar(Request.form("hpNo2"),4)
	usrHp3	= requestCheckVar(Request.form("hpNo3"),4)
%>

<script type="text/javascript">

	function chkForm() {
		var frm = document.frm;
		var frmp = parent.document.frminfo;

		if(!frm.hpNo1.value) {
			alert("휴대폰국번을 입력해주세요.")
			frm.hpNo1.focus();
			return false;
		}
		if(!IsDigit(frm.hpNo1.value)) {
			alert("휴대폰국번을 숫자로 입력해주세요.")
			frm.hpNo1.focus();
			return false;
		}
		if(!frm.hpNo2.value) {
			alert("휴대폰 앞자리를 입력해주세요.")
			frm.hpNo2.focus();
			return false;
		}
		if(!IsDigit(frm.hpNo2.value)) {
			alert("휴대폰 앞자리를 숫자로 입력해주세요.")
			frm.hpNo2.focus();
			return false;
		}
		if(!frm.hpNo3.value) {
			alert("휴대폰 뒷자리를 입력해주세요.")
			frm.hpNo3.focus();
			return false;
		}
		if(!IsDigit(frm.hpNo3.value)) {
			alert("휴대폰 뒷자리를 숫자로 입력해주세요.")
			frm.hpNo3.focus();
			return false;
		}
		if(!frm.certifyNo.value) {
			alert("카카오톡으로 받으신 인증번호를 입력해주세요.")
			frm.certifyNo.focus();
			return false;
		}
		if(!IsDigit(frm.certifyNo.value)) {
			alert("인증번호는 숫자로 입력해주세요.")
			frm.certifyNo.focus();
			return false;
		}
		if(!frm.kakaoMsg.checked) {
			alert("서비스 이용에 동의하셔야 카카오톡 맞춤정보 서비스 신청이 가능합니다.");
			frm.kakaoMsg.focus();
			return false;
		}

		// 인증번호 받기 전송
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appCom/wish/webview/my10x10/kakaotalk/ajax_kakaoTalk_proc.asp",
			data: "mode=step2&flow=<%=sflow%>&certifyNo="+frm.certifyNo.value+"&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value,
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "2"){
			alert('잘못된 인증번호입니다.');
			return false;
		}else if (rstStr == "3"){
			alert('잘못된 휴대폰번호입니다.');
			return false;			
		}else if (rstStr == "3008"){
			alert('인증번호가 만료되었습니다.\n새로운 인증번호를 받아주세요.');
			jsOpenModal("/apps/kakaotalk/pop_step1.asp")
			return;
		}else if (rstStr == "1000"){
			var rstStr2 = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/webview/my10x10/kakaotalk/pop_step3.asp",
				data: "flow=<%=sflow%>",
				dataType: "text",
				async: false
			}).responseText;
			$("#modalCont").empty().html(rstStr2);
			$('#modalCont .modal .btn-close').one('click', function(){
				$("#modalCont").fadeOut(function(){
					$(this).empty();
				});
				$('body').css({'overflow':'auto'});
    			clearInterval(loop);
    			loop = null;
				return false;
			});

			//$("#modalCont").fadeIn();
			//$('body').css({'overflow':'hidden'});
			return false;
		}else{
			alert(rstStr);
			//alert('오류가 발생했습니다.');
			return false;
		}
		
		//$("#modalCont").fadeOut();
		//$('body').css({'overflow':'auto'});		
	}

	function sendSMS() {
		var frm = document.frm;
		var frmp = parent.document.frminfo;

		if(!frm.hpNo1.value) {
			alert("휴대폰국번을 입력해주세요.")
			frm.hpNo1.focus();
			return false;
		}
		if(!IsDigit(frm.hpNo1.value)) {
			alert("휴대폰국번을 숫자로 입력해주세요.")
			frm.hpNo1.focus();
			return false;
		}
		if(!frm.hpNo2.value) {
			alert("휴대폰 앞자리를 입력해주세요.")
			frm.hpNo2.focus();
			return false;
		}
		if(!IsDigit(frm.hpNo2.value)) {
			alert("휴대폰 앞자리를 숫자로 입력해주세요.")
			frm.hpNo2.focus();
			return false;
		}
		if(!frm.hpNo3.value) {
			alert("휴대폰 뒷자리를 입력해주세요.")
			frm.hpNo3.focus();
			return false;
		}
		if(!IsDigit(frm.hpNo3.value)) {
			alert("휴대폰 뒷자리를 숫자로 입력해주세요.")
			frm.hpNo3.focus();
			return false;
		}

		// 인증번호 받기 전송
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appCom/wish/webview/my10x10/kakaotalk/ajax_kakaoTalk_proc.asp",
			data: "mode=step1&flow=<%=sflow%>&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value,
			dataType: "text",
			async: false
		}).responseText;
	
		if (rstStr == "2"){
			alert('잘못된 휴대폰번호입니다.');
			return false;
		}else if (rstStr == "3009"){
			alert('이전에 받으신 인증번호가 아직 유효합니다.\n먼저 받으신 번호를 입력해주세요.');

			var rstStr2 = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/webview/my10x10/kakaotalk/pop_step2.asp",
				data: "flow=<%=sflow%>&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value,
				dataType: "text",
				async: false
			}).responseText;
			$("#modalCont").empty().html(rstStr2);
			$('#modalCont .modal .btn-close').one('click', function(){
				$("#modalCont").fadeOut(function(){
					$(this).empty();
				});
				$('body').css({'overflow':'auto'});
    			clearInterval(loop);
    			loop = null;
				return false;
			});
			//$("#modalCont").fadeIn();
			//$('body').css({'overflow':'hidden'});
			return false;
		}else if (rstStr == "2103"){
			alert('본 서비스는 스마트폰에 카카오톡이 설치되어 있어야 이용이 가능합니다.\n카카오톡이 설치 되어있지 않다면 설치 후 이용해주시기 바랍니다.');
			return false;
		}else if (rstStr == "1000"){
			var rstStr2 = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/webview/my10x10/kakaotalk/pop_step2.asp",
				data: "flow=<%=sflow%>&hpNo1="+frm.hpNo1.value+"&hpNo2="+frm.hpNo2.value+"&hpNo3="+frm.hpNo3.value,
				dataType: "text",
				async: false
			}).responseText;
			$("#modalCont").empty().html(rstStr2);

			$('#modalCont .modal .btn-close').one('click', function(){
				$("#modalCont").fadeOut(function(){
					$(this).empty();
				});
				$('body').css({'overflow':'auto'});
    			clearInterval(loop);
    			loop = null;
				return false;
			});

			//$("#modalCont").fadeIn();
			//$('body').css({'overflow':'hidden'});
			return false;
		}else{
			alert(rstStr);
			//alert('오류가 발생했습니다.');
			return false;
		}
	
		//$("#modalCont").fadeOut();
		//$('body').css({'overflow':'auto'});
	}
</script>

<!-- modal#modalKakaoAuth -->
<div class="modal" id="modalKakaoAuth">
    <form name="frm" method="POST" style="margin:0px;" onsubmit="return false;">
	<input type="hidden" name="mode" value="step2">
	<input type="hidden" name="hpNo1" value="<%=usrHp1%>">
	<input type="hidden" name="hpNo2" value="<%=usrHp2%>">
	<input type="hidden" name="hpNo3" value="<%=usrHp3%>">
	<input type="hidden" name="flow" value="<%=sflow%>">
	<input type="hidden" name="cp" value="">    
    <div class="box">
        <header class="modal-header">
            <h1 class="modal-title">카카오톡 맞춤 정보 서비스 신청</h1>
            <a href="#modalKakaoAuth" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
			<div class="iscroll-area">
				<div class="red-box">
					<ul class="process kakao clear">
						<li><span class="label">10X10 회원인증</span></li>
						<li class="active"><span class="label">카카오톡 회원인증</span></li>
						<li><span class="label">신청완료</span></li>
					</ul>
				</div>
				<div class="kakao-friend">
					<i class="icon-lock"></i>사용자 인증
				</div>
				<div class="diff"></div>
				<div class="inner">
					<p>카카오톡으로 받으신 인증번호를 입력하신 후, 인증번호 확인을 눌러주세요. </p>
					<div class="diff-10"></div>
					<div class="input-block">
						<label for="authCode" class="input-label">인증번호 입력</label>
						<div class="input-controls">
							<input type="tel" name="certifyNo" maxlength="4" id="authCode" class="form full-size">
						</div>
					</div>
					<em class="em">* 인증을 완료하시면, 카카오톡 플러스 친구에 텐바이텐이 자동 추가됩니다. </em>
				</div>
				<div class="diff"></div>
				<div class="well type-b">
					<h3>
						<label for="agree">
							<input type="checkbox" name="kakaoMsg" id="agree" class="form" style="margin-right:10px;">
							맞춤정보 수신동의
						</label>
					</h3>
					<p class="x-small" style="margin-left:34px;">
						카카오톡으로 텐바이텐의 맞춤정보를 수신하겠습니다.<br>본 서비스를 신청하시면 텐바이텐 주문 및 배송관련 메시지와 다양한 혜택/이벤트 정보가 카카오톡으로 발송됩니다.
					</p>
				</div>
			</div>
        </div>
        <footer class="modal-footer">
            <div class="two-btns">
                <div class="col"><button onclick="chkForm();" class="btn type-b full-size">인증번호 확인</button></div>
                <div class="col"><button onclick="sendSMS();" class="btn type-a full-size">인증번호 재전송</button></div>
            </div>            
        </footer>
    </div>
    </form>
</div><!-- modal#modalKakaoAuth -->

<!-- #include virtual="/lib/db/dbclose.asp" -->