<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script src="/apps/appCom/wish/web2014/lib/js/jquery.nouislider.min.js"></script>
<script>
$(function(){
	// 가격별 검색필터
	$("#priceRange").noUiSlider({
		start: [3000, 7000],
		connect: true,
		range: {'min': 1000, 'max': 10000},
		serialization: {
			lower: [$.Link({target:$(".minVal span"),format:{decimals: 0},method: "html"})],
			upper: [$.Link({target:$(".maxVal span"),format:{decimals: 0},method: "html"})]
		}
	});
	$('.minVal').appendTo('.noUi-handle-lower');
	$('.maxVal').appendTo('.noUi-handle-upper');

	// 컬러별 검색
	$('.colorType li').click(function(){
		$(this).find('em').toggle();
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>필터</h1>
			<p class="btnPopClose"><button class="pButton" onclick="#">닫기</button></p>
			<p class="btnPopRefresh"><button  class="pButton" onclick="#">새로고침</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="contentArea">
			<!-- 필터 리스트업 -->
			<div class="filterListup innerH25W10 bPad45">
				<!-- 가격별 -->
				<h2>가격별</h2>
				<section class="priceType box">
					<div class="rangeWrap">
						<div id="priceRange">
							<p class="minVal"><span></span>원</p>
							<p class="maxVal"><span></span>원</p>
						</div>
					</div>
				</section>
				<!--// 가격별 -->

				<!-- 컬러별 -->
				<h2>컬러별</h2>
				<section class="colorType">
					<ul>
						<li>
							<p class="wine"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="wine" /></p>
							<span>wine</span>
						</li>
						<li>
							<p class="red"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="red" /></p>
							<span>red</span>
						</li>
						<li>
							<p class="orange"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="orange" /></p>
							<span>orange</span>
						</li>
						<li>
							<p class="brown"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="brown" /></p>
							<span>brown</span>
						</li>
						<li>
							<p class="camel"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="camel" /></p>
							<span>camel</span>
						</li>

						<li>
							<p class="yellow"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="yellow" /></p>
							<span>yellow</span>
						</li>
						<li>
							<p class="beige"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="beige" /></p>
							<span>beige</span>
						</li>
						<li>
							<p class="ivory"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="ivory" /></p>
							<span>ivory</span>
						</li>
						<li>
							<p class="khaki"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="khaki" /></p>
							<span>khaki</span>
						</li>
						<li>
							<p class="green"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="green" /></p>
							<span>green</span>
						</li>
						<li>
							<p class="mint"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="mint" /></p>
							<span>mint</span>
						</li>
						<li>
							<p class="skyblue"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="skyblue" /></p>
							<span>skyblue</span>
						</li>
						<li>
							<p class="blue"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="blue" /></p>
							<span>blue</span>
						</li>
						<li>
							<p class="navy"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="navy" /></p>
							<span>navy</span>
						</li>
						<li>
							<p class="violet"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="violet" /></p>
							<span>violet</span>
						</li>

						<li>
							<p class="lilac"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="lilac" /></p>
							<span>lilac</span>
						</li>
						<li>
							<p class="pink"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="pink" /></p>
							<span>pink</span>
						</li>
						<li>
							<p class="babypink"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="babypink" /></p>
							<span>babypink</span>
						</li>
						<li>
							<p class="white"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="white" /></p>
							<span>white</span>
						</li>
						<li>
							<p class="grey"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="gray" /></p>
							<span>grey</span>
						</li>
						<li>
							<p class="charcoal"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="charcoal" /></p>
							<span>charcoal</span>
						</li>
						<li>
							<p class="black"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="black" /></p>
							<span>black</span>
						</li>
						<li>
							<p class="silver"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="silver" /></p>
							<span>silver</span>
						</li>
						<li>
							<p class="gold"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="gold" /></p>
							<span>gold</span>
						</li>
						<li>
							<p class="check"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="check" /></p>
							<span>check</span>
						</li>
						<li>
							<p class="stripe"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="stripe" /></p>
							<span>stripe</span>
						</li>
						<li>
							<p class="dot"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="dot" /></p>
							<span>dot</span>
						</li>
						<li>
							<p class="flower"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="flower" /></p>
							<span>flower</span>
						</li>
						<li>
							<p class="drawing"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="drawing" /></p>
							<span>drawing</span>
						</li>
						<li>
							<p class="animal"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="animal" /></p>
							<span>animal</span>
						</li>
						<li>
							<p class="geometric"><em></em><img src="http://fiximage.10x10.co.kr/m/2014/category/bg_pattern_blank.png" alt="geometric" /></p>
							<span>geometric</span>
						</li>
					</ul>
				</section>
				<!--// 컬러별 -->
				
				<!-- 배송별 -->
				<h2>배송별</h2>
				<section class="box deliverType">
					<ul>
						<li><input type="radio" id="deliver01" name="delivery" /> <label for="deliver01">무료배송</label></li>
						<li><input type="radio" id="deliver02" name="delivery" /> <label for="deliver02">텐바이텐 배송</label></li>
						<li><input type="radio" id="deliver03" name="delivery" /> <label for="deliver03">무료+텐바이텐 배송</label></li>
						<li><input type="radio" id="deliver04" name="delivery" /> <label for="deliver04">해외배송</label></li>
					</ul>
				</section>
				<!--// 배송별 -->
			</div>
			<div class="floatingBar">
				<div class="btnWrap">
					<div class="ftBtn"><span class="button btB1 btRed cWh1 w100p"><input type="submit" value="검색필터 적용하기" /></span></div>
				</div>
			</div>
			<!--// 필터 리스트업 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>