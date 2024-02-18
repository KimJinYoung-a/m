<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 아이디 & 패스워드 찾기
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/util/commlib.asp" -->
<%
Dim C_dumiKey
	C_dumiKey = session.sessionid

'####### 실명인증 사용여부 ("N"으로하면 실명확인 없이 패스~) #######
Dim rnflag
	rnflag	= "Y"

'#######################################################################################
'#####	개인인증키(대체인증키;아이핀) 서비스				한국신용정보(주)
'#######################################################################################
Dim NiceId, SIKey, ReturnURL, pingInfo, strOrderNo

randomize(time())
strOrderNo = Replace(date, "-", "")  & round(rnd*(999999999999-100000000000)+100000000000)
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">

	$(document).ready(function(){
		$("#tabe").click(function() {
			frmPWfind.selPWDiv.value=$(this).attr("gubun");
			$("#tabe").addClass("active");
			$("#tabp").removeClass("active");
			$("#lyrIDEmail").show()
			$("#lyrIDPhone").hide()
		});
		$("#tabp").click(function() {
			frmPWfind.selPWDiv.value=$(this).attr("gubun");
			$("#tabe").removeClass("active");
			$("#tabp").addClass("active");
			$("#lyrIDEmail").hide()
			$("#lyrIDPhone").show()
		});		
	});

	// 이메일 입력 확인
	function chkEmailForm(frm) {
		var email;
		
		if (frm.txEmail1.value == ""){
			alert("이메일 앞부분을 입력해주세요");
			frm.txEmail1.focus();
			return ;
		}
		if (frm.txEmail1.value.indexOf('@')>-1){
		    alert("@를 제외한 앞부분만 입력해주세요...");
			frm.txEmail1.focus();
			return ;
		}
		if (frm.txEmail2.value == ""){
			alert("이메일 도메인을 선택해주시거나 직접 입력해주세요...");
			frm.txEmail2.focus();
			return ;
		}
		if ((frm.txEmail2.value == "etc")&&(frm.selfemail.value.length<1)){
		    alert("이메일 도메인을 선택해주시거나 직접 입력해주세요...");
			frm.selfemail.focus();
			return ;
		}
		if( frm.txEmail2.value == "etc"){
		    email = frm.txEmail1.value + '@' + frm.selfemail.value;
		}else{
		    email = frm.txEmail1.value + '@' + frm.txEmail2.value;
		}

		if (email == ''){
			return;
		}else if (!check_form_email(email)){
	        alert("이메일 주소가 유효하지 않습니다.");
			frm.txEmail1.focus();
			return ;
		}
		return email;
	}

	// 휴대폰 입력 확인
	function chkPhoneForm(frm) {
		var phone;
		if (frm.txCell2.value.length<3){
		    alert("휴대전화 번호를 입력해주세요");
			frm.txCell2.focus();
			return ;
		}
		if (frm.txCell3.value.length<4){
		    alert("휴대전화 번호를 입력해주세요");
			frm.txCell3.focus();
			return ;
		}
		phone = frm.txCell1.value+"-"+frm.txCell2.value+"-"+frm.txCell3.value
		return phone;
	}
	
	// 패스워드 찾기 (이메일/휴대폰)
	function jsFindPWEP(frm) {
		var sId, sNm, sEm, sHp, para

		sId = frm.userid.value;
		sNm = frm.username.value;

		if(!sId) {
			alert("아이디를 입력해주세요.");
			frm.userid.focus();
			return;
		}
		if(!sNm) {
			alert("성명을 입력해주세요.");
			frm.username.focus();
			return;
		}

		if(frmPWfind.selPWDiv.value=='E') {
			sEm = chkEmailForm(frm)
			if(!sEm) return;
			para = "id="+sId+"&nm="+escape(sNm)+"&mail="+sEm
		}else if(frmPWfind.selPWDiv.value=='p') {
			sHp = chkPhoneForm(frm)
			if(!sHp) return;
			para = "id="+sId+"&nm="+escape(sNm)+"&cell="+sHp
		}else{
			alert('구분자가 없습니다.');
		}

		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxFindPWEmailHP.asp",
			data: para,
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "1"){
			alert("가입시 메일로 임시 비밀번호를 보내드렸습니다.\n메일을 확인해주세요.");
			return;
		}else if (rstStr == "2"){
			alert("가입시 휴대폰으로 임시 비밀번호를 보내드렸습니다.\n문자를 확인해주세요.");
			return;
		}else if (rstStr == "3"){
			alert("핸드폰으로 본인증을 완료하신 고객입니다.\n휴대폰으로 비밀번호를 찾아주세요");
			return;
		}else if (rstStr == "4"){
			alert("이메일로 본인증을 완료하신 고객입니다.\n이메일로 비밀번호를 찾아주세요");
			return;
		}else if(rstStr == "5"){
			alert("입력하신 내용과 일치하는 정보가 없습니다.\n\n※실명인증 가입고객이라면 PC버전에서\n아이핀,본인인증으로 찾으실 수 있습니다.");
			return;
		}else{
			alert("발송 중 오류가 발생했습니다."+rstStr);
			return;
		}
	}
	
</script>
</head>
<body class="util">
    <!-- wrapper -->
    <div class="wrapper">
        <!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="pop_find_id.asp">아이디 찾기</a>
                <a href="pop_find_pw.asp" class="active">비밀번호 찾기</a>
            </div>
        </header><!-- #header -->
        <div class="well type-b">
            <ul class="txt-list">
                <li>이메일 또는 휴대폰으로 임시비밀번호를 보내드립니다.<br>임시비밀번호로 로그인 후, <a href="#" class="red">My 10X10 &gt; 개인정보수정</a>에서 비밀번호를 반드시 수정해 주세요.</li>
            </ul>
        </div>
        <!-- #content -->
        <div id="content">
            <form name="frmPWfind" method="post" onsubmit="return false;">
			<input type="hidden" name="selPWDiv" value="E">            
            <div class="inner">
                <div class="tabs type-c">
                    <a href="#" id="tabe" gubun="E" class="active">이메일</a>
                    <a href="#" id="tabp" gubun="p">휴대폰번호</a>
                </div>
                <div class="input-block">
                    <label for="userid" class="input-label">아이디</label>
                    <div class="input-controls">
                        <input type="text" name="userid" maxlength="32" id="userid" class="form full-size">
                    </div>
                </div>
                <div class="input-block">
                    <label for="name" class="input-label">이름</label>
                    <div class="input-controls">
                        <input type="text" name="username" maxlength="32" id="name" class="form full-size">
                    </div>
                </div>
                <div id="lyrIDEmail" class="input-block email-block">
                    <label for="email" class="input-label">이메일</label>
                    <div class="input-controls email-type-b">
						<input type="text" id="email1" name="txEmail1" value="" maxlength="32" class="form">
                        @
                        <% call DrawEamilBoxHTML_App("document.frmPWfind","selfemail","txEmail2","","form","form bordered",""," onchange=""jsShowMailBox('document.frmPWfind','txEmail2','selfemail'); """) %>
					</div>
                </div>
                <div id="lyrIDPhone" style="display:none;" class="input-block">
                    <label for="phone" class="input-label">휴대폰</label>
                    <div class="input-controls">
                        <select name="txCell1" style="width:30%;" id="phone1" class="form">
							<option value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
                        </select>
                        <input type="tel" name="txCell2" pattern="[0-9]*" style="width:30%; ime-mode:active;" id="phone2" class="form" maxlength="4">
                        <input type="tel" name="txCell3" pattern="[0-9]*" style="width:30%; ime-mode:active;" id="phone3" class="form" maxlength="4">
                    </div>
                </div>	                         
                <div class="diff-10"></div>
                <div class="form-actions highlight">
                    <button onclick="jsFindPWEP(document.frmPWfind);" class="btn type-a full-size">확인</button>
                </div>
            </div>
             </form>
        </div><!-- #content -->
        <!-- #footer -->
        <footer id="footer">
        </footer><!-- #footer -->
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->