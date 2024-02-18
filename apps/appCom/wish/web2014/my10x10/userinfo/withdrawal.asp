<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashcls.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
	dim ipoint, userid
	userid = getEncLoginUserID
	
	'// 보유 마일리지 조회
	dim oPoint,availtotalMile
	
	set oPoint = new TenPoint
	oPoint.FRectUserID = userid
	if (userid<>"") then
	    oPoint.getTotalMileage
	
	    availtotalMile = oPoint.FTotalMileage
	end if
	
	if availtotalMile<1 then availtotalMile=0
	
	set oPoint = Nothing
	
	'// 보유 예치금 조회
	dim availTenCash
	
	set oPoint = new CTenCash
	oPoint.FRectUserID = userid
	if (userid<>"") then
	    oPoint.getUserCurrentTenCash
	
	    availTenCash = oPoint.Fcurrentdeposit
	end if
	
	if availTenCash<1 then availTenCash=0
	
	set oPoint = Nothing
	
	'// 보유 텐바이텐 giftCard 조회
	dim availGiftCard
	
	set oPoint = new myGiftCard
	oPoint.FRectUserID = userid
	if (userid<>"") then
	    availGiftCard = oPoint.myGiftCardCurrentCash
	end if
	
	if availGiftCard<1 then availGiftCard=0
	
	set oPoint = Nothing

	''간편로그인수정;허진원 2018.04.24
	'SNS회원 여부
	dim isSNSMember: isSNSMember = false
	if GetLoginUserDiv="05" then
		isSNSMember = true
	end if
%>
<script language="javascript" SRC="/apps/appCom/wish/web2014/lib/js/confirm.js"></script>
<script type="text/javascript">
$(function(){
	$(".listInset textarea").hide();
	$(".listInset .itemRadio label").click(function(){
		$(".listInset .itemRadio label").removeClass("on");
		if ($(this).hasClass("on")) {
			$(this).removeClass("on");
		} else {
			$(this).addClass("on");
			$(".listInset textarea").hide();
		}
	});

	$(".listInset .itemRadio:nth-child(7) label").click(function(){
		$(".listInset textarea").show();
	});

	$(".certification .field .group").hide();
	$(".certification .field .group:first-child").show();

	$(".certification .way li:first").click(function(){
		$(".certification .field .group").hide();
		$(".certification .field .group:first-child").show();
	});
		$(".certification .way li:last").click(function(){
		$(".certification .field .group").hide();
		$(".certification .field .group:last").show();
	});
});

function TnByeBye(frm){
	var comdiv = document.getElementsByName('complaindiv')
	var comchecked= false;
	for (var i=0;i<comdiv.length;i++){
		if (comdiv[i].checked){
			comchecked= true;
		}
	}

	if (!comchecked){
		alert('사유를 선택해 주세요');
		return;
	}
	
	if(frm.complaindiv[6].checked){
			if(frm.complaintext.value == "" || frm.complaintext.value == "기타 불편사항 및 텐바이텐에 바라는 고객님의 충고를 부탁 드립니다."){
			frm.complaintext.value == "";
			frm.complaintext.focus();
			alert('기타 의견을 입력해주세요');
			return;
		}
	}

<%
	''간편로그인수정;허진원 2018.04.24
	if Not(isSNSMember) then
%>
	if (frm.txpass.value.length<1){
		alert('비밀 번호를 입력하세요');
		frm.txpass.focus();
		return;
	}
<%	end if %>

	if(frm.chkMethod[0].checked) {
		//휴대폰 선택
		var sHp = chkPhoneForm(frm)
		if(!sHp) return;
		frm.txPhone.value=sHp;
	} else if(frm.chkMethod[1].checked) {
		//이메일 선택
		var sEm = chkEmailForm(frm)
		if(!sEm) return;
		frm.txEmail.value=sEm;
	}

	if (confirm('탈퇴 하시겠습니까?')) {
		if(!($("#reason07").is(":checked"))){
			$("#wdEtc").val("");
		}
		frm.submit();
	}
}

// 이메일 입력 확인
function chkEmailForm(frm) {
	var email;
	email = frm.txEmail.value;
	if (frm.txEmail.value == ""){
		alert("이메일 주소를 입력해주세요");
		frm.txEmail.focus();
		return ;
	}

	if (email == ''){
		return;
	}else if (!check_form_email(email)){
        alert("이메일 주소가 유효하지 않습니다.");
		frm.txEmail.focus();
		return ;
	}
	return email;
}

// 휴대폰 입력 확인
function chkPhoneForm(frm) {
	var phone;
	if (frm.txCell1.value.length<3){
	    alert("휴대전화 번호를 입력해주세요");
		frm.txCell1.focus();
		return ;
	}
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
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container bgGry">
		<div class="content" id="contentArea">
			<h2 class="hide">회원탈퇴</h2>
			<div class="countMileage">
				<p class="cBk1 ct"><strong>현재 사용가능한 마일리지는<br /> <span class="cRd1"><%= FormatNumber(availtotalMile,0) %></span> 포인트입니다.</strong></p>
				<% if availTenCash>0 then %>
				<p class="cBk1 ct"><strong>현재 예치금은 <span class="cRd1"><%= FormatNumber(availTenCash,0) %></span>원입니다.</strong></p>
				<% end if %>
				<% if availGiftCard>0 then %>
				<p class="cBk1 ct"><strong>현재 기프트 카드는 <span class="cRd1"><%= FormatNumber(availGiftCard,0) %></span>원입니다.</strong></p>
				<% end if %>
			</div>
			<div class="withdraw">
				<!-- 탈퇴사유 선택 -->
				<form name="byeFrm" method="post" action="/apps/appCom/wish/web2014/my10x10/userinfo/withdrawal_process.asp" onsubmit="return false;" >
				<input type="hidden" name="txPhone" value="" />
					<div class="listInset">
						<fieldset>
						<legend>텐바이텐 회원 탈퇴 사유</legend>
							<p class="cBk1 fs12 ct">어떤점이 고객님을 불편하게 만들었나요?</p>
							<ul>
								<li class="itemRadio"><input type="radio" name="complaindiv" value="01" id="reason01" /><label for="reason01"><span></span>상품품질 불만</label></li>
								<li class="itemRadio"><input type="radio" name="complaindiv" value="02" id="reason02" /><label for="reason02"><span></span>이용빈도 낮음</label></li>
								<li class="itemRadio"><input type="radio" name="complaindiv" value="04" id="reason03" /><label for="reason03"><span></span>개인정보유출 우려</label></li>
								<li class="itemRadio"><input type="radio" name="complaindiv" value="03" id="reason04" /><label for="reason04"><span></span>배송지연</label></li>
								<li class="itemRadio"><input type="radio" name="complaindiv" value="05" id="reason05" /><label for="reason05"><span></span>교환/환불/품질 불만</label></li>
								<li class="itemRadio"><input type="radio" name="complaindiv" value="07" id="reason06" /><label for="reason06"><span></span>A/S 불만</label></li>
								<li class="itemRadio"><input type="radio" name="complaindiv" value="06" id="reason07" /><label for="reason07"><span></span>기타</label></li>
							</ul>
							<textarea id="wdEtc" name="complaintext" cols="60" rows="5" title="기타 불편사항 및 텐바이텐에 바라는 고객님의 충고를 부탁 드립니다." placeholder="기타 불편사항 및 텐바이텐에 바라는 고객님의 충고를 부탁 드립니다."></textarea>
						</fieldset>
					</div>
					<!-- 본인확인 -->
					<div class="writeInfo certificationField">
						<fieldset>
						<legend>탈퇴관련 본인확인 선택</legend>
							<h3>본인확인</h3>
							<table class="writeTbl01">
								<colgroup>
									<col style="19%" />
									<col style="" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">아이디</th>
										<td><strong class="fs13"><%=userid%></strong></td>
									</tr>
								<%
									''간편로그인수정;허진원 2018.04.24
									if Not(isSNSMember) then
								%>
									<tr>
										<th scope="row"><label for="pw">비밀번호</label></th>
										<td><input type="password" name="txpass" id="pw" class="w100p" /></td>
									</tr>
								<%	end if %>
									<tr>
										<td colspan="2">
											<div class="certification">
												<ul class="way">
													<li><input type="radio" name="chkMethod" value="P" id="way01" checked /> <label for="way01">휴대전화</label></li>
													<li><input type="radio" name="chkMethod" value="E" id="way02" /> <label for="way02">이메일</label></li>
												</ul>
												<div class="field">
													<!-- 휴대전화 -->
													<div id="field01" class="group">
														<div>
															<span style="width:30%;"><input type="tel" name="txCell1" title="휴대전화 앞자리" value="" class="w100p ct" maxlength="3" /></span>
															<span class="ct" style="width:5%;">-</span>
															<span style="width:30%;"><input type="tel" name="txCell2" title="휴대전화 가운데자리" value="" class="w100p ct" maxlength="4" /></span>
															<span class="ct" style="width:5%;">-</span>
															<span style="width:30%;"><input type="tel" name="txCell3" title="휴대전화 뒷자리" value="" class="w100p ct" maxlength="4" /></span>
														</div>
														<p>※ 회원정보에 등록된 휴대전화번호 또는 이메일 중 하나를 선택하여 입력해주세요.</p>
													</div>
													<!-- 이메일 -->
													<div id="field02" class="group">
														<input type="email" value="" class="w100p" name="txEmail" maxlength="100" />
													</div>
												</div>
											</div>

										</td>
									</tr>
								</tbody>
							</table>
						</fieldset>
					</div>
					<div class="btngroup">
						<span class="button btB1 btRed cWh1 w100p"><button type="button" onclick="TnByeBye(document.byeFrm);"><i>텐바이텐과 이별하기</i></button></span>
					</div>
				</form>
			</div>
			<div class="listBox bgWht">
				<h3 class="cBk1"><span>회원탈퇴 안내</span></h3>
				<ul>
					<li><strong class="cRd1">회원탈퇴 시</strong> 고객님의 정보는 상품 반품 및 A/S를 위해 전자상거래 등에서 의 소비자 보호에 관한 법률에 의거한 10x10 고객정보 보호정책에 따라 관리됩니다.</li>
					<li><strong class="cRd1">회원탈퇴 시</strong> 고객님께서 보유하셨던 마일리지 및 현금성 포인트(예치금, Gift카드)는 모두 삭제되며, 환급 또한 불가능합니다.</li>
					<li>현금성 포인트(예치금, Gift카드)의 잔액을 환급 받으시려면 회원 탈퇴 전에 고객센터로 문의바랍니다. (<a href="tel:1644-6030">Tel. 1644-6030</a>)</li>
					<li>한 번 탈퇴한 아이디는 다시 사용할 수 없습니다.</li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->