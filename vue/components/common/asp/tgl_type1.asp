<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
<meta name="format-detection" content="telephone=no">
<title>2020 모바일</title>
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css" />
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
</head>
<body>
	<!-- 토글 컴포넌트 (tgl_type1) -->
	<div class="tgl_type1">
		<i class="bg"></i>
		<button type="button" data-label="rv" class="btn_tgl active"><span>후기사진</span></button>
		<button type="button" data-label="prd" class="btn_tgl">기본사진</button>
	</div>
	<script>
	$(function() {
		// 서로 다른 상품의 후기 리스트 - 이미지 스위치 (후기사진/기본사진)
		$('.tgl_type1 .btn_tgl').on('click', function(e) {
			e.preventDefault();
			var btn = $(e.currentTarget),
				item = btn.closest('.rv_item'),
				tgl = btn.parent('.tgl_type1'),
				btnAll = tgl.children('.btn_tgl'),
				bg = tgl.children('.bg');

			btnAll.removeClass('active');
			btn.addClass('active');

			if (btn.index() == 2) {
				bg.css('left', '50%')
			} else {
				bg.css('left', '0%')
			}

			if (btn.attr('data-label') == 'rv') {
				item.find('.prd_img').hide()
				item.find('.rv_img').show()
			} else {
				item.find('.rv_img').hide()
				item.find('.prd_img').show()
			}
		});
	});
	</script>
	<!-- //토글 컴포넌트 (tgl_type1) -->
</body>
</html>