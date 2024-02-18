<!-- #include virtual="/html/lib/inc/head.asp" -->
</head>
<body>
	<!-- 페이지네이션 컴포넌트 (pagination) -->
	<div class="pagination">
		<a href="" class="prev"><span class="blind">이전페이지</span></a>
		<div class="current">
			<span class="num">3</span>
			<input type="number" value="3">
		</div>
		<i class="bar">/</i>
		<span class="total">1,214</span>
		<a href="" class="next"><span class="blind">다음페이지</span></a>
	</div>
	<script>
	$(function() {
		// 페이지네이션 input
		$('.pagination input').on('keydown', function(e) {
			var $input = $(e.target);
			var initVal = this.defaultValue;
			setTimeout(function() {
				var newVal = $input.val();
				if (!newVal) {
					alert('숫자만 입력해 주세요');
					$input.val(initVal);
					$input.siblings('.num').text(initVal);
					$input.blur();
				} else {
					$input.siblings('.num').text(newVal);
				}
			},10);
		});
	});
	</script>
</body>
</html>