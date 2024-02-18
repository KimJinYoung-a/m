<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10 CALENDAR APP</title>
<link rel="stylesheet" type="text/css" href="../lib/css/calAppStyle.css">
<script type="text/javascript" src="../lib/js/jquery-1.10.1.min.js"></script>
<!--[if lt IE 9]>
	<script src="../lib/js/respond.min.js"></script>
<![endif]-->
<script>
function imgWChk(){
	var imgW = $('.item img').width();
	$('.item img').css('height',imgW);
}

$(document).ready(function(){
	imgWChk();
	$('.item .markWish').click(function(){
		$(this).toggleClass('myWishPdt');
	});

	$('.viewOpt').click(function(){
		$(this).toggleClass('bigView');
		$('.pdtList').toggleClass('bigView');
		imgWChk();
	});
});
</script>
</head>
<body>
<div class="wrapper">
	<div id="content">
		<div class="listWrap inner01 itemList gry01">
			<div class="sortWrap">
				<span class="viewOpt">보기옵션</span>
				<p>
					<span>
						<select title="">
							<option>NEW</option>
							<option>NEW</option>
							<option>NEW</option>
						</select>
					</span>
					<span>
						<select title="">
							<option>BEST</option>
							<option>BEST</option>
							<option>BEST</option>
						</select>
					</span>
				</p>
			</div>
			<ul class="pdtList boxMdl">
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
			</ul>

		</div>
	</div>
</div>
</body>
</html>