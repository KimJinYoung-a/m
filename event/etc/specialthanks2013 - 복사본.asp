<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 고마워서 보내는 선물</title>
<style type="text/css">
.mEvt45797 {}
.mEvt45797 img {vertical-align:top;}
.mEvt45797 .ct {text-align:center !important;}
.mEvt45797 .tMar15 {margin-top:15px;}
.mEvt45797 .myCandleWrap {position:relative; overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_bg_addr.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .myCandle { width:89%; border-top:5px solid #cc0d0d; margin:8% 5%;}
.mEvt45797 .myCandle .myAddr {position:relative;  padding:5%; border:1px solid #bebebe; border-top:0; box-shadow:3px 3px 3px #ebebeb;}
.mEvt45797 .myCandle .myAddr dl {overflow:hidden; width:100%; display:table; font-size:12px; margin-bottom:15px;}
.mEvt45797 .myCandle .myAddr dt {display:table-cell; vertical-align:top; width:30%; padding-top:9px; font-weight:bold; color:#555;}
.mEvt45797 .myCandle .myAddr dd {display:table-cell; width:70%; text-align:left; vertical-align:top;}
.mEvt45797 .myCandle .myAddr dd .bar {padding-top:7px; display:inline-block;}
.mEvt45797 .myCandle .myAddr dd .txtInp {height:18px; padding:5px 10px; font-size:12px; border:1px solid #bbb; color:#666; vertical-align:top; font-family:verdana, tahoma, dotum, dotumche, '돋움', '돋움체', sans-serif;}
.mEvt45797 .myAddr .btn01 {font-size:11px; line-height:12px; padding:8px; color:#fff; background:#aaa; border:1px solid #aaa; vertical-align:top; }
.mEvt45797 .myAddr .btn01:hover {background:#8a8a8a; border:1px solid #8a8a8a;}
.mEvt45797 .myAddr .btn02 {color:#fff; background:#d50c0c; border:1px solid #d50c0c; font-size:12px; line-height:13px; padding:12px 25px; vertical-align:top; }
.mEvt45797 .myAddr .btn02:hover {background:#b20202; border:1px solid #b20202;}
.mEvt45797 .specialGift {position:relative;}
.mEvt45797 .slide {position:relative; overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .slidesjs-slide {background-size:100% 100%; background-position:left top; background-repeat:no-repeat;}
.mEvt45797 .slidesjs-container {width:95% !important; margin:0 auto;}
.mEvt45797 .slidesjs-pagination {position:absolute; right:20px; bottom:10px; z-index:100; overflow:hidden;}
.mEvt45797 .slidesjs-pagination li {float:left; width:10px; margin-left:4px;}
.mEvt45797 .slidesjs-pagination li a {display:block; width:10px; height:10px; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_pagination_off.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .slidesjs-pagination li a.active {background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_pagination_on.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .goldGrade .slide .photo01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle01.png);}
.mEvt45797 .goldGrade .slide .photo02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle02.png);}
.mEvt45797 .goldGrade .slide .photo03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle03.png);}
.mEvt45797 .goldGrade .slide .photo04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle04.png);}
.mEvt45797 .goldGrade .slide .photo05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle05.png);}
.mEvt45797 .silverGrade .slide .photo01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle01.png);}
.mEvt45797 .silverGrade .slide .photo02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle02.png);}
.mEvt45797 .silverGrade .slide .photo03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle03.png);}
.mEvt45797 .silverGrade .slide .photo04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle04.png);}
.mEvt45797 .silverGrade .slide .photo05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle05.png);}
.mEvt45797 .candleImage {background-size:100% 100%; background-repeat:no-repeat; background-position:left top;}
.mEvt45797 .goldGrade .candleImage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_img_gold_candle.png);}
.mEvt45797 .silverGrade .candleImage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_img_silver_candle.png);}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min_3.0.4.js"></script>
<script type="text/javascript">
$(function(){
	$(function(){
	$('.slide').slidesjs({
		//width:"850",
		//height:"564",
		navigation: false,
		pagination: {
			effect: "fade"
		},
		play: {
			interval:3000,
			effect: "fade",
			auto: true,
			swap: false
		},
		effect: {
			fade: {
				speed:1500,
				crossfade: true
			}
		}
	});
});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt45797">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_head.png" alt="고마워서 보내는 선물" style="width:100%;" /></div>
					<!-- for dev msg : 골드 회원일경우 클래스 goldGrade / 실버회원일경우 클래스 silverGrade 추가해주세요 -->
					<div class="specialGift goldGrade">
						<div class="slide">
							<div class="photo01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo05"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
						</div>
						<div class="myCandleWrap">
							<div class="myCandle">
								<div class="myAddr">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_txt01.png" alt="주소확인" style="width:100%;" /></p>
									<dl>
										<dt>회원아이디</dt>
										<dd><input type="text" class="txtInp" style="width:60%;" /></dd>
									</dl>
									<dl>
										<dt>주소</dt>
										<dd>
											<p>
												<input type="tel" class="txtInp" style="width:9%;" />
												<span class="bar">-</span>
												<input type="tel" class="txtInp" style="width:9%;" />
												<a href="" class="btn btn01">우편번호 찾기</a>
											</p>
											<p class="tMar15"><input type="text" class="txtInp" style="width:81%;" /></p>
											<p class="tMar15"><input type="text" class="txtInp" style="width:81%;" /></p>
										</dd>
									</dl>
									<dl>
										<dt>전화번호</dt>
										<dd>
											<input type="tel" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" class="txtInp" style="width:15%;" />
										</dd>
									</dl>
									<dl>
										<dt>휴대전화</dt>
										<dd>
											<input type="tel" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" class="txtInp" style="width:15%;" />
										</dd>
									</dl>
									<p class="ct" style="margin-top:25px;"><a href="#" class="btn btn02">주소 확인하기</a></p>
									<p class="ct" style="margin-top:10px;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_txt02.png" alt="이곳에서 확인하신 주소는 기본 회원 정보로 업데이트됩니다." style="width:100%;" /></p>
								</div>
							</div>
						</div>
						<div class="candleImage"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank02.png" alt="" style="width:100%;" /></div>
					</div>

					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_tenten_gift.png" alt="10월10일 12주년을 맞이하는 텐바이텐에서 만나요!" style="width:100%;" /></div>
				</div>
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	<!-- #include virtual="/lib/inc/incCategory.asp" -->
</div>
</body>
</html>