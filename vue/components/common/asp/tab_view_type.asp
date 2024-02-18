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
	<!-- 뷰 타입 탭 컴포넌트 (tab_view_type) -->
	<div class="tab_view_type">
		<button type="button" class="btn_view_type active"><i class="i_list_detail"></i>자세히</button>
		<button type="button" class="btn_view_type"><i class="i_list_photo"></i>사진만</button>
	</div>
	<script>
	$(function() {
		// 상품/상품후기 리스트 뷰 타입 전환 (자세히/사진만)
		$('.btn_view_type').on('click', function(e) {
			e.preventDefault();
			var btn = $(e.currentTarget),
				tab = btn.parent('.tab_view_type'),
				btnAll = tab.children('.btn_view_type');
			btnAll.removeClass('active');
			btn.addClass('active');
			// for dev msg : 뷰 타입에 따라 유닛 렌더링
		});
	});
	</script>
	<!-- //뷰 타입 탭 컴포넌트 (tab_view_type) -->
</body>
</html>