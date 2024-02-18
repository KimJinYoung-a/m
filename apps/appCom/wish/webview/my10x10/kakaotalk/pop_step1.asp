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
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, username, usrHp1, usrHp2, usrHp3, sflow
	userid = GetLoginUserID
	username = GetLoginUserName
	sflow	= requestCheckVar(Request.form("flow"),3)

dim myUserInfo
set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid
	
	if (userid<>"") then
	    myUserInfo.GetUserData
	    on Error Resume Next
	    usrHp1 = SplitValue(myUserInfo.FOneItem.Fusercell,"-",0)
	    usrHp2 = SplitValue(myUserInfo.FOneItem.Fusercell,"-",1)
	    usrHp3 = SplitValue(myUserInfo.FOneItem.Fusercell,"-",2)
	    On Error Goto 0
	end if
set myUserInfo = Nothing
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
		if(!frm.kakaoMsg.checked) {
			alert("서비스 이용에 동의하셔야 카카오톡 맞춤정보 서비스 신청이 가능합니다.")
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
	<form name="frm" method="post" style="margin:0px;" onsubmit="return false;">
	<input type="hidden" name="mode" value="step1">
	<input type="hidden" name="flow" value="<%=sflow%>">
    <div class="box">
        <header class="modal-header">
            <h1 class="modal-title">카카오톡 맞춤 정보 서비스 신청</h1>
            <a href="#modalKakaoAuth" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
        	<div class="iscroll-area">
				<div class="red-box">
					<ul class="process kakao clear">
						<li class="active"><span class="label">10X10 회원인증</span></li>
						<li><span class="label">카카오톡 회원인증</span></li>
						<li><span class="label">신청완료</span></li>
					</ul>
				</div>
				<div class="kakao-friend">
					<i class="icon-lock"></i>사용자 인증
				</div>
				<div class="diff"></div>
				<div class="inner">
					<div class="input-block">
						<label for="phone" class="input-label">휴대폰</label>
						<div class="input-controls phone">
							<div><input type="tel" name="hpNo1" value="<%=usrHp1%>" pattern="[0-9]*" id="phone1" class="form" maxlength="4"></div>
							<div><input type="tel" name="hpNo2" value="<%=usrHp2%>" pattern="[0-9]*" id="phone2" class="form" maxlength="4"></div>
							<div><input type="tel" name="hpNo3" value="<%=usrHp3%>" pattern="[0-9]*" id="phone3" class="form" maxlength="4"></div>
						</div>
					</div>
					<em class="em">* 휴대폰 번호를 수정하시면, 개인정보의 휴대폰 번호도 수정됩니다. </em>
				</div>
				<div class="diff"></div>
				<div class="well type-b">
					<h3>
						<label for="agree">
							<input type="checkbox" name="kakaoMsg" id="agree" class="form" style="margin-right:10px;">
							개인정보 취급 위탁동의
						</label>
					</h3>
					<ul class="txt-list" style="margin-left:34px;">
						<li>취급업체 : ㈜ 카카오</li>
						<li>위탁업무 내용 : 사용자 인증 </li>
						<li>공유정보 : 휴대전화번호</li>
						<li>개인정보의 보유 및 이용 기간 : 회원탈퇴 혹은 서비스 해제시까지 </li>
					</ul>
				</div>
			</div>
		</div>
        <footer class="modal-footer">
            <button onclick="chkForm();" class="btn type-a full-size">인증번호 받기</button>
        </footer>
    </div>
    </form>
</div><!-- modal#modalKakaoAuth -->

<!-- #include virtual="/lib/db/dbclose.asp" -->