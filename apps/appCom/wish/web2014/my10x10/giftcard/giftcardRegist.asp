<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
	dim userid: userid = getEncLoginUserID ''GetLoginUserID
%>
<script type="text/javascript">
$(function(){
	setTimeout("fnAPPchangPopCaption('기프트카드')",100);
});

function chkRegForm(frm) {
	if(!frm.agreement.checked) {
		alert("기프트카드 이용약관에 동의를 해주세요.");
		return false;
	}
	if(frm.masterCardCd1.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		frm.masterCardCd1.focus();
		return false;
	}
	if(frm.masterCardCd2.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		frm.masterCardCd2.focus();
		return false;
	}
	if(frm.masterCardCd3.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		frm.masterCardCd3.focus();
		return false;
	}
	if(frm.masterCardCd4.value.length<4) {
		alert("기프트카드 번호를 정확히 입력해주세요.");
		frm.masterCardCd4.focus();
		return false;
	}
	frm.masterCardCd.value = frm.masterCardCd1.value + frm.masterCardCd2.value + frm.masterCardCd3.value + frm.masterCardCd4.value;
}

function jsGoNextText(a){
	var t = $("#masterCardCd"+a+"");
	var b = parseInt(a) + 1;
	if(a < 4){
		if(t.val().length > 3){
			$("#masterCardCd"+b+"").focus();
		}
	}

	if(t.val().length > 4){
		t.val(t.val().substring(0,4));
	}
}

function jsPopTerms(){
	fnAPPpopupBrowserURL('기프트카드 약관','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/giftcard/giftcardTerms.asp?reurl=giftcardRegist');
	return false;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content myGiftcardV15a" id="contentArea">
			<div class="giftcardRegiV15a inner10">				
				<div class="giftcardRegiFormV15a">
					<form name="frmReg" method="POST" action="do_giftcardReg.asp" target="iframeProc" onsubmit="return chkRegForm(this)" style="margin:0px;">
					<input type="hidden" name="masterCardCd" value="" />
						<fieldset>
						<legend>기프트카드 등록</legend>
							<div class="box4">
								<p>인증번호를 등록해주세요.</p>
								<div class="field">
									<input type="number" name="masterCardCd1" id="masterCardCd1" autocomplete="off" title="기프트카드 인증번호 첫번째자리 네자리 입력" onKeyUp="jsGoNextText('1');" /> -
									<input type="number" name="masterCardCd2" id="masterCardCd2" autocomplete="off" title="기프트카드 인증번호 두번째자리 네자리 입력" onKeyUp="jsGoNextText('2');" /> -
									<input type="number" name="masterCardCd3" id="masterCardCd3" autocomplete="off" title="기프트카드 인증번호 세번째자리 네자리 입력" onKeyUp="jsGoNextText('3');" /> -
									<input type="number" name="masterCardCd4" id="masterCardCd4" autocomplete="off" title="기프트카드 인증번호 네번째자리 네자리 입력" onKeyUp="jsGoNextText('4');" />
								</div>
							</div>

							<div class="agree">
								<input type="checkbox" name="agreement" id="agreeYes" />
								<label for="agreeYes">기프트카드 약관 동의</label>
								<span class="button btS2 btGryBdr cGy1"><a href="" onClick="jsPopTerms(); return false;">약관보기</a></span>
							</div>

							<div class="button btB1 btRed cWh1 w100p"><button type="submit">등록하기</button></div>
						</fieldset>
					</form>
					<iframe src="about:blank" name="iframeProc" width="0" height="0" frameborder="0" ></iframe>
				</div>

				<div class="listBox">
					<ul>
						<li>기프트카드의 유효기간은 구매일로부터 5년입니다.</li>
						<li>인증번호 등록 후 기프트카드 금액을 현금처럼 사용할 수 있으며, 다른 결제 수단과 중복으로 사용 가능합니다.</li>
						<li>온라인 카드사용등록 전 기프트카드 메시지 또는 인증번호를 분실하신 경우 보내는 사람에게 재전송을 요청하실 수 있으며 재전송은 2회까지 가능합니다.</li>
					</ul>
				</div>
			</div>
			<a href="" onclick="fnAPPpopupBrowserURL('기프티콘 상품교환','<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifticon/'); return false;" class="btn-giftchange"><img src="//fiximage.10x10.co.kr/m/2019/my10x10/btn_giftchange.jpg" alt="기프티콘 상품 교환하기"></a>
		</div>
		<!-- //content area -->
		<footer class="giftcardFooter">
			<p>
				<span class="logo"><img src="http://fiximage.10x10.co.kr/m/2016/giftcard/img_logo.png" alt="10X10" /></span>
				<span class="cs"> | 고객행복센터 : <a href="tel:1644-6030">1644-6030</a></span>
			</p>
		</footer>			

	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->