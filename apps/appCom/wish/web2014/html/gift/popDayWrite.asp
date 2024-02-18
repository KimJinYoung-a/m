<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	// 글자수세기, input focus
	$('.writeFrm').each(function() {
		var defaultVal = this.value;
		$(this).focus(function() {
			if(this.value == defaultVal){
				this.value = '';
			}
		});
		$(this).blur(function(){
			if(this.value == ''){
				this.value = defaultVal;
			}
		});
	});
	function frmCount(val) {
		var len = val.value.length;
		if (len >= 201) {
			val.value = val.value.substring(0, 200);
		} else {
			$('.txtLimit span').text(len);
		}
	}
	$('.writeFrm').keyup(function() {
		frmCount(this);
	});

	$('.selectKwd li span').click(function(){
		$(this).toggleClass('on');
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>쓰기</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<ul class="giftTab">
				<li class="giftTalk"><a href=""><span class="tabIco"></span>GIFT TALK<em></em></a></li>
				<li class="giftDay on"><a href=""><span class="tabIco"></span>GIFT DAY<em></em></a></li>
			</ul>
			<div class="giftBrdHead">
				<p>선물에 관한 사연을 남겨주세요!<br /><a href="" class="viewGuide">GIFT DAY 이용방법<span>&gt;</span></a></p>
			</div>
			<p><img src="http://fiximage.10x10.co.kr/m/2013/gift/day_evt_bnr2.png" alt="5월의 주제 - 로즈데이, 선물을 찾아라!" style="vertical-align:top;" /><!-- dev for msg : 기프트데이 배너 / alt값 해당 이벤트 내용 넣어주세요 --></p>
			<div class="popGiftCont">
				<div class="giftDay">
					<div class="giftWrite">
						<!-- step01 -->
						<div class="step01">
							<p class="sTit"><strong>Step 1. 선택된 상품</strong></p>
							<div class="sCont">
								<p class="option">
									<span><input type="radio" id="giveGift" /> <label for="giveGift"><strong>주고싶은 선물</strong></label></span>
									<span><input type="radio" id="getGift" /> <label for="getGift"><strong>받고싶은 선물</strong></label></span>
								</p>
								<div class="innerW">
									<p class="pic">
										<a href=""><img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.png" alt="ascreem**님이 올린 쇼핑톡" style="width:100%;" /></a><!-- for dev msg : 상품명 alt 속성에 넣어주세요. -->
									</p>
								</div>
							</div>
						</div>
						<!--// step01 -->

						<!-- step02 -->
						<div class="step02 tMar25">
							<p class="sTit"><strong>Step 2. 주제에 맞는 내용을 적어주세요</strong></p>
							<div class="sCont">
								<textarea class="writeFrm" cols="20" rows="5">상품에 대한 내용을 200자 이내로 입력해주세요.</textarea>
								<p class="txtLimit"><span>0</span>/200자</p>
							</div>
						</div>
						<!--// step02 -->

						<!-- step03 -->
						<div class="step03 tMar15">
							<p class="sTit"><strong>Step 3. 키워드를 선택해주세요</strong> (3개까지 선택가능)</p>
							<div class="sCont">
								<div class="selectKwd">
									<ul>
										<li><span>MEN</span></li>
										<li><span>BABY</span></li>
										<li><span>HOME</span></li>
										<li><span>기념일</span></li>
										<li><span>축하&amp;감사</span></li>
										<li><span>입학&amp;졸업</span></li>
										<li><span>발렌타인데이</span></li>
										<li><span>어버이날</span></li>
										<li><span>스승의날</span></li>
										<li><span>빼빼로데이</span></li>
										<li><span>WOMAN</span></li>
										<li><span>FUN</span></li>
										<li><span>위시</span></li>
										<li><span>생일</span></li>
										<li><span>결혼&amp;집들이</span></li>
										<li><span>명절(설/추석)</span></li>
										<li><span>화이트데이</span></li>
										<li><span>어린이날</span></li>
										<li><span>할로윈</span></li>
										<li><span>크리스마스</span></li>
									</ul>
								</div>
							</div>
						</div>
						<!--// step03 -->
					</div>
				</div>
			</div>
		</div>
		<div class="floatingBar">
			<div class="btnWrap bNum2">
				<div class="ftBtn"><span class="button btB1 btGry2 cWh1 w100p"><a href="">취소</a></span></div>
				<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><a href="">등록</a></span></div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>