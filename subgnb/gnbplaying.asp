<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
.life-vol003 .question {position:relative;}
.life-vol003 .question a {display:block; position:absolute; width:86.7%; height:29.2%; left:6.7%; font-size:0; text-indent:-999em;}
.life-vol003 .question .btn-scent1 {top:27.9%;}
.life-vol003 .question .btn-scent2 {top:60.5%;}
.life-vol003 .scent {padding-bottom:15%;}
#scent1, #scent1 .swiper-slide {background-color:#f4cad1;}
#scent2, #scent2 .swiper-slide {background-color:#7fa6c6;}
.scent .pagination {height:auto; padding-top:6.4%;}
.scent .swiper-pagination-switch {width:.56rem; height:.56rem; border-radius:0.28rem; -webkit-border-radius:0.28rem; margin:0 0.64rem;}
#scent1 .swiper-pagination-switch {background-color:#b0bdc8;}
#scent2 .swiper-pagination-switch {background-color:#eedade;}
.scent .swiper-active-switch {width:1.5rem;}
#scent1 .swiper-active-switch {background-color:#68bcc1;}
#scent2 .swiper-active-switch {background-color:#fccad2;}
.life-vol003 .slideNav {display:inline-block; position:absolute; height:50%; z-index:50; text-indent:-999em; background-color:transparent; background-repeat:no-repeat; background-position:50% 50%; background-size:100% auto;}
.life-vol003 .scent .slideNav {width:5.3%;}
#scent1 .slideNav {top:18%;}
#scent2 .slideNav {top:15%;}
.life-vol003 .scent .btnPrev {left:3.3%;}
.life-vol003 .scent .btnNext {right:3.3%;}
#scent1 .btnPrev {background-image:url(http://webimage.10x10.co.kr/play/life/vol003/m/btn_scent1_prev.png);}
#scent1 .btnNext {background-image:url(http://webimage.10x10.co.kr/play/life/vol003/m/btn_scent1_next.png);}
#scent2 .btnPrev {background-image:url(http://webimage.10x10.co.kr/play/life/vol003/m/btn_scent2_prev.png);}
#scent2 .btnNext {background-image:url(http://webimage.10x10.co.kr/play/life/vol003/m/btn_scent2_next.png);}
#rolling {padding-top:14.4%; background-color:#fff2e7;}
#rolling .swiper-slide {width:80%; margin-right:4.8%;}
#rolling .slideNav {width:6%; top:25%;}
#rolling .btnPrev {left:2.9%; background-image:url(http://webimage.10x10.co.kr/play/life/vol003/m/btn_rolling_prev.png);}
#rolling .btnNext {right:2.9%; background-image:url(http://webimage.10x10.co.kr/play/life/vol003/m/btn_rolling_next.png);}
#rolling .txt-area {position:relative;}
#rolling .btn-buy {display:block; position:absolute; left:50%; bottom:14.7%; width:57.8%; margin-left:-28.9%;}
.life-vol003 .culture {padding-top:1.33%; background-color:#fff;}
.life-vol003 .culture a {display:block;}
</style>
<script type="text/javascript">
$(function(){
	// 취향
	var que = $('.question a');
	que.click(function(e){
		e.preventDefault();
		$('html, body').animate({scrollTop:$(this.hash).offset().top}, 'fast');
	});
	// slide template
	slideTemplate = new Swiper('#scent1 .swiper-container',{
		loop:true,
		speed:800,
		pagination:"#scent1 .pagination",
		paginationClickable:true,
		prevButton:'#scent1 .btnPrev',
		nextButton:'#scent1 .btnNext',
		effect:'fade'
	});
	slideTemplate = new Swiper('#scent2 .swiper-container',{
		loop:true,
		speed:800,
		pagination:"#scent2 .pagination",
		paginationClickable:true,
		prevButton:'#scent2 .btnPrev',
		nextButton:'#scent2 .btnNext',
		effect:'fade'
	});
	slideTemplate = new Swiper('#rolling .swiper-container',{
		loop:true,
		speed:800,
		prevButton:'#rolling .btnPrev',
		nextButton:'#rolling .btnNext',
		slidesPerView:'auto'
	});
 });
</script>
</head>
<body class="default-font body-main playV18 detail-play">
	<!-- #include virtual="/lib/inc/incheader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="detail-cont">

			<!-- 컨텐츠 영역 -->
			<div class="life-vol003">
				<h2><img src="http://webimage.10x10.co.kr/play/life/vol003/m/tit_scent.jpg" alt="하루의 취향, 순간의 취향" /></h2>
				<div class="question">
					<img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_question.jpg" alt="당신의 취향은 무엇인가요?" />
					<a href="#scent1" class="btn-scent1">하루의 취향 보기</a>
					<a href="#scent2" class="btn-scent2">순간의 취향 보기</a>
				</div>
				<div id="scent1" class="scent">
					<div><img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_scent_1.jpg" alt="하루의 취향" /></div>
					<div class="swiper">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/txt_scent1_1.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/txt_scent1_2.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/txt_scent1_3.png" alt="" /></div>
							</div>
							<div class="pagination"></div>
							<button type="button" class="slideNav btnPrev">이전</button>
							<button type="button" class="slideNav btnNext">다음</button>
						</div>
					</div>
				</div><!-- //scent1 -->
				<div id="scent2" class="scent">
					<div><img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_scent_2.jpg" alt="순간의 취향" /></div>
					<div class="swiper">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/txt_scent2_1.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/txt_scent2_2.png" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/txt_scent2_3.png" alt="" /></div>
							</div>
							<div class="pagination"></div>
							<button type="button" class="slideNav btnPrev">이전</button>
							<button type="button" class="slideNav btnNext">다음</button>
						</div>
					</div>
				</div><!-- //scent2 -->
				<div id="rolling">
					<div class="swiper">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_rolling_01.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_rolling_02.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_rolling_03.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_rolling_04.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/img_rolling_05.jpg" alt="" /></div>
							</div>
							<button type="button" class="slideNav btnPrev">이전</button>
							<button type="button" class="slideNav btnNext">다음</button>
						</div>
					</div>
					<div class="txt-area">
						<img src="http://webimage.10x10.co.kr/play/life/vol003/m/txt_rolling.jpg" alt="당신에게는 어떤 취향이 와닿나요?" />
						<a href="/category/category_itemPrd.asp?itemid=2069638" class="btn-buy"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/btn_buy_scent.png" alt="취향 구매하러가기" /></a>
					</div>
				</div>
				<div class="culture">
					<a href="/culturestation/culturestation_event.asp?evt_code=4545"><img src="http://webimage.10x10.co.kr/play/life/vol003/m/bnr_culture.jpg" alt="컬쳐스테이션 이벤트 응모하러 가기" /></a>
				</div>
			</div>
			<!--// 컨텐츠 영역 -->
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incfooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->