<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'// 페이지 타이틀
strPageTitle = "10X10: 아이디/비밀번호 찾기"

Dim C_dumiKey
C_dumiKey = session.sessionid

'####### 실명인증 사용여부 ("N"으로하면 실명확인 없이 패스~) #######
Dim rnflag, sTab
rnflag	= "Y"
sTab = requestCheckVar(request("t"),2)

	'#######################################################################################
	'#####	개인인증키(대체인증키;아이핀) 서비스				한국신용정보(주)
	'#######################################################################################
	Dim NiceId, SIKey, ReturnURL, pingInfo, strOrderNo

	randomize(time())
	strOrderNo = Replace(date, "-", "")  & round(rnd*(999999999999-100000000000)+100000000000)
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script language="javascript" SRC="/lib/js/confirm.js"></script>
<script type="text/javascript">
	$(function() {
		//창 타이틀 변경
		fnAPPchangPopCaption("아이디/비밀번호 찾기");
	});

	function chgSelIdDiv(frm) {
		if(frm.value=="E") {
			$("#lyrIDEmail").show();
			$("#lyrIDPhone").hide();
		} else {
			$("#lyrIDEmail").hide();
			$("#lyrIDPhone").show();
		}
	}

	function chgSelPWDiv(frm) {
		if(frm.value=="E") {
			$("#lyrPWEmail").show();
			$("#lyrPWPhone").hide();
		} else {
			$("#lyrPWEmail").hide();
			$("#lyrPWPhone").show();
		}
	}

	function chgSelPWIPDiv(frm) {
		if(frm.value=="I") {
			$("#lyrPWiPin").show();
			$("#lyrPWMobi").hide();
		} else {
			$("#lyrPWiPin").hide();
			$("#lyrPWMobi").show();
		}
	}

	// 아이디 찾기 (이메일/휴대폰)
	function jsFindIDEP() {
		var sNm, sEm, sHp, para
		var frm = document.frmIDfind;

		if(frm.selIDDiv[0].checked) {
			sNm = frm.username.value;
			if(!sNm) {
				alert("이름을 입력해주세요.");
				frm.username.focus();
				return;
			}
			sHp = chkPhoneForm(frm)
			if(!sHp) return;
			para = "nm="+escape(sNm)+"&cell="+sHp
		} else {
			sNm = frm.username.value;
			if(!sNm) {
				alert("이름을 입력해주세요.");
				frm.username.focus();
				return;
			}
			sEm = chkEmailForm(frm)
			if(!sEm) return;
			para = "nm="+escape(sNm)+"&mail="+sEm
		}

		var rstStr = $.ajax({
			type: "POST",
			url: "/member/ajaxFindIDEmailHP.asp",
			data: para,
			dataType: "text",
			async: false
		}).responseText;

		$("#lyrIDResult").show();
		$("#lyrResultIdList").empty();
		$("#lyrResultIdList").html(rstStr);
	}

	// 패스워드 찾기 (이메일/휴대폰)
	function jsFindPWEP() {
		var sId, sNm, sEm, sHp, para
		var frm = document.frmPWfind;

		if(frm.selPWDiv[0].checked) {
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
			sHp = chkPhoneForm(frm)
			if(!sHp) return;
			para = "id="+sId+"&nm="+escape(sNm)+"&cell="+sHp
		} else {
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
			sEm = chkEmailForm(frm)
			if(!sEm) return;
			para = "id="+sId+"&nm="+escape(sNm)+"&mail="+sEm
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
		}else if (rstStr == "2"){
			alert("가입시 휴대폰으로 임시 비밀번호를 보내드렸습니다.\n문자를 확인해주세요.");
		}else if (rstStr == "3"){
			alert("핸드폰으로 본인증을 완료하신 고객입니다.\n휴대폰으로 비밀번호를 찾아주세요");
		}else if (rstStr == "4"){
			alert("이메일로 본인증을 완료하신 고객입니다.\n이메일로 비밀번호를 찾아주세요");
		}else if(rstStr == "5"){
			alert("입력하신 내용과 일치하는 정보가 없습니다.\n\n※실명인증 가입고객이라면 PC버전에서\n아이핀,본인인증으로 찾으실 수 있습니다.");
		}else if(rstStr == "6"){
			alert("SNS 계정으로 회원가입하신 고객입니다.\n\nSNS 계정으로 로그인을 통해 서비스를 이용해주세요.");
		}else{
			alert("발송 중 오류가 발생했습니다.\n\n"+rstStr);
		}
	}

	// 이메일 입력 확인
	function chkEmailForm(frm) {
		var email = frm.usermail.value;

		if (email == ''){
			alert("이메일을 입력해주세요.");
			frm.usermail.focus();
			return;
		}else if (!check_form_email(email)){
	        alert("이메일 주소가 유효하지 않습니다.");
			frm.usermail.focus();
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

	function jsIDPWdiv(d){
		if(d == "id"){
			$("#idli").addClass("current");
			$("#pwli").removeClass("current");
			$("#findId").show();
			$("#findPw").hide();
		}else{
			$("#idli").removeClass("current");
			$("#pwli").addClass("current");
			$("#findId").hide();
			$("#findPw").show();
		}
	}

	function jsPopMsg(msgcd) {
		switch(msgcd) {
			case "E11":
				alert("유효기간이 만료되었습니다.(E01)\n확인 후 다시 시도해주세요.");
				location.replace("/apps/appCom/wish/web2014/member/find_idpw.asp?t=id");
				break;
			case "E12":
				alert("잘못된 휴대폰 번호입니다.(E12)\n확인 후 다시 시도해주세요.");
				location.replace("/apps/appCom/wish/web2014/member/find_idpw.asp?t=id");
				break;
			case "E13":
				alert("잘못된 이메일 주소입니다.(E13)\n확인 후 다시 시도해주세요.");
				location.replace("/apps/appCom/wish/web2014/member/find_idpw.asp?t=id");
				break;
			case "E21":
				alert("처리중 오류가 발생했습니다.(E02)\n다시 시도해주세요.");
				break;
			case "E22":
				alert("처리중 오류가 발생했습니다.(E03)\n다시 시도해주세요.");
				break;
			case "E31":
				alert("검색 대상이 없습니다.\n확인 후 다시 시도해주세요.");
				location.replace("/apps/appCom/wish/web2014/member/find_idpw.asp?t=id");
				break;
			case "10":
				alert("회원정보에 등록된 휴대폰 번호로 아이디가 전송되었습니다.");
				location.replace("/apps/appCom/wish/web2014/member/find_idpw.asp?t=id");
				break;
			case "20":
				alert("회원정보에 등록된 이메일 주소로 아이디가 전송되었습니다.");
				break;
			default:
				alert("처리중 오류가 발생했습니다.(E99)");
		}
	}
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
	    <!--
		<div class="header">
			<h1>아이디 / 비밀번호 찾기</h1>
			<p class="btnPopPrev"><a href="" class="pButton" onclick="goBack('custom://gotoday.custom');return false;">이전으로</a></p>
		</div>
		-->
		<!-- content area -->
		<div class="content bgGry" id="contentArea">
			<!-- 아이디/비밀번호찾기 -->
			<div class="login inner5">
				<div class="tab01 tMar15">
					<ul class="tabNav tNum2">
						<li id="idli" <%=chkIIF(sTab="id","class=""current""","")%>><a href="" onClick="jsIDPWdiv('id'); return false;">아이디 찾기<span></span></a></li>
						<li id="pwli" <%=chkIIF(sTab="pw","class=""current""","")%>><a href="" onClick="jsIDPWdiv('pw'); return false;">비밀번호 찾기<span></span></a></li>
					</ul>
					<div class="tabContainer">
						<!-- 아이디 찾기 -->
						<div id="findId" <%=chkIIF(sTab="id","style=""display:block;""","style=""display:none;""")%>>
						<form name="frmIDfind" method="post" onsubmit="return false;">
						<input type="hidden" name="mode" value="id">
							<div class="box1">
								<div class="findType">
									<span><input type="radio" name="selIDDiv" id="fPhone" value="P" checked="checked" onclick="chgSelIdDiv(this)" /> <label for="fPhone">휴대폰</label></span>
									<span><input type="radio" name="selIDDiv" id="fMail" value="E" onclick="chgSelIdDiv(this)" /> <label for="fMail">이메일</label></span>
								</div>
								<div class="loginForm">
									<input type="text" name="username" maxlength="30" title="이름 입력" placeholder="이름" />
									<div id="lyrIDEmail" class="overHidden" style="display:none;">
									<input type="email" name="usermail" maxlength="100" title="이메일 입력" placeholder="이메일" />
									</div>
									<div id="lyrIDPhone" class="overHidden">
										<p class="ftLt w30p">
											<select name="txCell1" title="휴대전화 앞자리 선택">
												<option value="010">010</option>
												<option value="011">011</option>
												<option value="016">016</option>
												<option value="017">017</option>
												<option value="018">018</option>
												<option value="019">019</option>
											</select>
										</p>
										<p class="ftLt w35p lPad05"><input type="tel" name="txCell2" maxlength="4" class="" /></p>
										<p class="ftLt w35p lPad05"><input type="tel" name="txCell3" maxlength="4" class="" /></p>
									</div>
								</div>
								<div class="btnWrap">
									<p class="ftRt"><span class="button btB1 btRed cWh1"><input type="submit" value="확인" onclick="jsFindIDEP(); return false;" style="background-color:#ff3131;" /></span></p>
								</div>
							</div>
							<!-- 검색 확인 버튼 클릭후 출력 -->
							<div id="lyrIDResult" class="findResult" style="display:none;">
								<dl>
									<dt>
										<p class="result">아이디 조회 결과 입력하신 정보와 일치하는<br />아이디는 아래와 같습니다.</p>
										<p>가입정책 변경으로 신규고객과 인증절차가 이루어지지 않은<br />기존 고객 아이디가 함께 검색 될 수 있습니다.</p>
									</dt>
									<dd class="history">
										<ul id="lyrResultIdList"></ul>
									</dd>
								</dl>
								<div id="lyrResultIDBtn" style="display:none;">
									<span class="button btB1 btRed cWh1 w100p bMar05"><a href="#" onclick="fnAPPpopupBrowserURL('아이디 확인','<%=wwwUrl%>/apps/appCom/wish/web2014/member/pop_findFullID.asp');return false;">아이디 뒷자리 확인</a></span>
									<span class="button btB1 btRed cWh1 w100p"><a href="#" onclick="calllogin(); return false;">로그인</a></span>
								</div>
							</div>
							<!-- //검색 확인 버튼 클릭후 출력 -->
						</form>
						</div>
						<!--// 아이디 찾기 -->

						<!-- 비밀번호 찾기 -->
						<div id="findPw" <%=chkIIF(sTab="id","style=""display:none;""","style=""display:block;""")%>>
						<form name="frmPWfind" method="post" onsubmit="return false;">
							<div class="box1">
								<div class="findType">
									<span><input type="radio" name="selPWDiv" id="fPhone2" value="P" checked="checked" onclick="chgSelPWDiv(this)" /> <label for="fPhone2">휴대폰</label></span>
									<span><input type="radio" name="selPWDiv" id="fMail2" value="E" onclick="chgSelPWDiv(this)" /> <label for="fMail2">이메일</label></span>
								</div>
								<div class="loginForm">
									<input type="text" name="userid" maxlength="32" title="아이디 입력" class="w100p" placeholder="아이디" />
									<input type="text" name="username" maxlength="30" title="이름 입력" class="w100p" placeholder="이름" />
									<div id="lyrPWEmail" class="overHidden" style="display:none;">
									<input type="email" name="usermail" maxlength="100" title="이메일 입력" class="w100p" placeholder="이메일" />
									</div>
									<div id="lyrPWPhone" class="overHidden">
										<p class="ftLt w30p">
											<select name="txCell1" title="휴대전화 앞자리 선택">
												<option value="010">010</option>
												<option value="011">011</option>
												<option value="016">016</option>
												<option value="017">017</option>
												<option value="018">018</option>
												<option value="019">019</option>
											</select>
										</p>
										<p class="ftLt w35p lPad05"><input type="tel" name="txCell2" maxlength="4" class="" /></p>
										<p class="ftLt w35p lPad05"><input type="tel" name="txCell3" maxlength="4" class="" /></p>
									</div>
								</div>
								<div class="btnWrap">
									<p class="ftRt"><span class="button btB1 btRed cWh1"><input type="submit" value="확인" onclick="jsFindPWEP(); return false;" style="background-color:#ff3131;" /></span></p>
								</div>
							</div>
						</form>
						</div>
						<!--// 비밀번호 찾기 -->
					</div>
				</div>
			</div>
			<!--// 아이디/비밀번호찾기 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->