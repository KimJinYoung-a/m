<!-- #include virtual="/html/lib/inc/head.asp" -->
</head>
<body>
	<!-- 카테고리 필터 슬라이더 컴포넌트 (ctgr_nav_type2) -->
    <nav class="ctgr_nav_type2">
        <div class="swiper-container">
            <ul class="swiper-wrapper">
                <li class="swiper-slide"><a href="">전체</a></li>
                <li class="swiper-slide"><a href="" class="active">디자인문구</a></li>
                <li class="swiper-slide"><a href="">디지털&sol;핸드폰</a></li>
                <li class="swiper-slide"><a href="">디자인가전</a></li>
                <li class="swiper-slide"><a href="">가구&sol;수납</a></li>
                <li class="swiper-slide"><a href="">데코&sol;조명</a></li>
                <li class="swiper-slide"><a href="">패브릭&sol;생활</a></li>
                <li class="swiper-slide"><a href="">키친</a></li>
                <li class="swiper-slide"><a href="">푸드</a></li>
                <li class="swiper-slide"><a href="">패션의류</a></li>
                <li class="swiper-slide"><a href="">패션잡화</a></li>
                <li class="swiper-slide"><a href="">주얼리&sol;시계</a></li>
                <li class="swiper-slide"><a href="">뷰티</a></li>
                <li class="swiper-slide"><a href="">토이&sol;취미</a></li>
                <li class="swiper-slide"><a href="">베이비&sol;키즈</a></li>
                <li class="swiper-slide"><a href="">캣엔독</a></li>
            </ul>
        </div>
    </nav>
	<script>
	$(function() {
		// 카테고리 필터 슬라이더
        var ctgrSwiper = new Swiper('.ctgr_nav_type2 .swiper-container', {
            slidesPerView:'auto',
        });
        $('.ctgr_nav_type2').on('click', function(e) {
            if ($(e.target).is('a')) {
                e.preventDefault();
                $(this).find('a').removeClass('active');
                $(e.target).addClass('active');
            }
        });
	});
	</script>
	<!-- //카테고리 필터 슬라이더 컴포넌트 (ctgr_nav_type2) -->
</body>
</html>