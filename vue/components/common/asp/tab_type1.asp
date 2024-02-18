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
	<!-- 탭 type1 컴포넌트 (tab_type1)
		- 스크롤/탐색 시 정렬 옵션 상단 플로팅 (e.g. 카테고리 메인 - 뭐 없을까 싶을 때)
		- 정렬 옵션 선택 시 리스트 재정렬, [뭐 없을까 싶을 때] 상단으로 스크롤 이동
	-->
	<div class="tab_type1">
		<ul class="tab_list">
			<li class="tab_item"><a href=""><span>베스트셀러</span></a></li>
			<li class="tab_item"><a href="">클리어런스</a></li>
			<li class="tab_item"><a href="">할인상품</a></li>
			<li class="tab_item active"><a href="">스테디셀러</a></li>
			<li class="tab_item"><a href="">신상품</a></li>
			<li class="tab_item"><a href="">사봤는데요</a></li>
		</ul>
	</div>
	<script>
	$(function() {
		// for dev msg : 컴포넌트 내 active 액션 + 특정 페이지에서만 필요한 액션 (e.g. 카테고리 메인 - 뭐 없을까 싶을 때)
		$('.tab_type1 a').on('click', function(e) {
			e.preventDefault();
			$(e.currentTarget).parent('li').addClass('active').siblings().removeClass('active');
		});
	});
	</script>
</body>
</html>