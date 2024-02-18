<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10 CALENDAR APP</title>
<link rel="stylesheet" type="text/css" href="../lib/css/calAppStyle.css">
<script type="text/javascript" src="../lib/js/jquery-1.10.1.min.js"></script>
<script type="text/javascript" src="../lib/js/jquery-masonry.min.js"></script>
<!--[if lt IE 9]>
	<script src="../lib/js/respond.min.js"></script>
<![endif]-->
<script>
$(document).ready(function(){
	$('img').load(function(){
		$(".pdtList").masonry({
			itemSelector: '.item'
		});
	});
	$(".pdtList").masonry({
		itemSelector: '.item'
	});

	$('.item .markWish').click(function(){
		$(this).toggleClass('myWishPdt');
	});
});
</script>
</head>
<body>
<div class="wrapper">
	<div id="content">
		<div class="listWrap inner01 todayMList gry01">
			<ul class="pdtList boxMdl">
				<li class="item">
					<div class="listHeadBox">
						<div>
							<p class="headTit">오늘의 컬러상품 <br />할인중</p>
							<p class="headSale">10<span>%</span></p>
						</div>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish myWishPdt">관심상품(위시담기)</span><!--for dev msg : 나의 위시상품인 경우 myWishPdt 클래스명 추가-->
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt01.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish">관심상품(위시담기)</span>
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt02.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish">관심상품(위시담기)</span>
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt03.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish">관심상품(위시담기)</span>
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt01.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish myWishPdt">관심상품(위시담기)</span>
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt02.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish">관심상품(위시담기)</span>
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt03.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish">관심상품(위시담기)</span>
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt01.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div>
						<span class="markWish">관심상품(위시담기)</span>
						<a href=""><img src="http://fiximage.10x10.co.kr/m/webview/cal/temp/@temp_pdt02.png" alt="상품명" /></a>
					</div>
				</li>
				<li class="item">
					<div class="listMoreBox" style="background-color:#f55b8f"><!-- for dev msg : 해당 컬러값 백그라운드 컬러로 넣어주세요 -->
						<a href="">
							<div><p>더 많은 Pink 상품보기</p></div>
						</a>
					</div>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>