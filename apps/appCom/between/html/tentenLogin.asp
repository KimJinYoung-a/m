<!-- #include virtual="/apps/appCom/between/lib/inc/head.asp" -->
<script>
$(function() {
	$('.formWrap input').focusin(function() {
		$(this).parent().children('label').hide();
	});
});
</script>
</head>
<body>
<div class="wrapper" id="btwCtgy"><!-- for dev msg : 원뎁스별 해당 ID 추가(비트윈추천:btwRcmd/카테고리:btwCtgy/마이페이지:btwMypage) -->
	<div id="content">
		<!-- #include virtual="/apps/appCom/between/lib/inc/incHeader.asp" -->
		<div class="cont">
			<p>컨텐츠 영역</p>
		</div>
	</div>
	<!-- #include virtual="/apps/appCom/between/lib/inc/incFooter.asp" -->

	<!-- 텐바이텐 로그인 -->
	<div class="lyrPopWrap boxMdl midLyr">
		<div class="lyrPop tentenLogin">
			<div class="lyrPopCont">
				<h1>텐바이텐 로그인</h1>
				<div>
					<p>텐바이텐 회원으로 구매 시 마일리지 <br />적립, 쿠폰 등의 회원혜택을 받으실 수 있습니다.</p>
					<fieldset>
						<div class="formWrap">
							<p><label for="memId">아이디</label><input type="text" id="memId" /></p>
							<p><label for="memPw">비밀번호</label><input type="password" id="memPw" /></p>
						</div>
						<div class="btnWrap">
							<p class="btn02 btnOk"><a href="" class="tenRed">텐바이텐 로그인</a></p>
						</div>
						<p class="loginOpt">아이디 찾기 <span>l</span> 비밀번호 찾기 <span>l</span> 회원가입</p>
					</fieldset>
				</div>
			</div>
			<div class="lyrPopCont gry243 memBenefit">
				<dl>
					<dt>텐바이텐의 남다른 회원혜택</dt>
					<dd>
						<ul class="txtList02">
							<li><span class="txtBlk">마일리지적립</span> 상품구매시마일리지적립</li>
							<li><span class="txtBlk">다양한 상품 쿠폰</span> 회원가입과 동시에 쿠폰 발급</li>
							<li><span class="txtBlk">회원 등급별 혜택</span> 구매할 수록 할인혜택은 UP</li>
						</ul>
					</dd>
				</dl>
			</div>
			<span class="lyrClose">&times;</span>
		</div>
		<div class="dimmed"></div>
	</div>
	<!-- //텐바이텐 로그인 -->
</div>
</body>
</html>