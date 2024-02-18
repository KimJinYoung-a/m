<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script>
$(function(){
	$('.selectAB .item .pic:nth-child(1)').prepend('<span class="label">A</span>');
	$('.selectAB .item .pic:nth-child(2)').prepend('<span class="label">B</span>');

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
	$('.addPdt .item .blank').append('<img src="http://fiximage.10x10.co.kr/m/2013/gift/img_more.png" alt="" style="width:100%;" />');
	$('.selectKwd li span').click(function(){
		$(this).toggleClass('on');
	});

	// sample question
	$('.qSample').click(function(){
		$('.viewSample').slideToggle();
	});
	$('.viewSample .lyrClose').click(function(){
		$('.viewSample').hide();
	});
	$('.viewSample li').click(function(){
		var exText = $(this).text();
		$('.viewSample').hide();
		$('.step02 .sCont textarea').empty().val(exText);
		frmCount($('.writeFrm').get(0));
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
				<li class="giftTalk on"><a href=""><span class="tabIco"></span>GIFT TALK<em></em></a></li>
				<li class="giftDay"><a href=""><span class="tabIco"></span>GIFT DAY<em></em></a></li>
			</ul>
			<div class="giftBrdHead">
				<p>선물이 고민 된다면 톡을 작성하세요!<br /><a href="" class="viewGuide">GIFT TALK 이용방법<span>&gt;</span></a></p>
			</div>
			<div class="popGiftCont">
				<div class="giftTalk">
					<div class="giftWrite">
						<!-- step01 -->
						<div class="step01">
							<p class="sTit"><strong>Step 1. 선택된 상품</strong></p>
							<div class="sCont">
								<div class="addPdt">
									<div class="item">
										<img src="http://fiximage.10x10.co.kr/m/2013/@temp/thumb_600x600.jpg" alt="처칠머그컵" style="width:100%;" />
									</div>
									<div class="item">
										<p><a href="" class="blank"><span>상품 추가 등록 시<br />비교가능 (옵션)</span></a></p>
									</div>
								</div>
							</div>
						</div>
						<!--// step01 -->

						<!-- step02 -->
						<div class="step02 tMar25">
							<p class="sTit"><strong>Step 2. 고민되는 내용</strong></p>
							<div class="sCont">
								<!-- 샘플질문 -->
								<div class="questionGuide">
									<span class="qSample"><em>?</em>샘플 질문</span>
									<div class="viewSample">
										<p class="cC40">아래 샘플 질문 클릭 시 바로 입력됩니다.</p>
										<ul>
											<li>OOO 선물로 괜찮을까요?</li>
											<li>어떤게 괜찮나요?</li>
											<li>직장동료 집들이 선물로 괜찮을까요?</li>
											<li>빵! 터지게 웃긴 선물로 괜찮을까요?</li>
											<li>단체 선물로 괜찮을까요?</li>
										</ul>
									</div>
								</div>
								<!--// 샘플질문 -->
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