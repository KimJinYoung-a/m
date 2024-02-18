<%
    
%>
<script>
$(function() {
	var didScroll;
	var lastScrollTop = 0;
	var delta = 5;
	var navbarHeight = $(".header-wrap").outerHeight();

	$(window).scroll(function(event){
		if ($("body").hasClass("body-main")){
			didScroll = true;
		}
	});

	setInterval(function() {
		if (didScroll) {
			hasScrolled();
			didScroll = false;
		}
	}, 250);

	function hasScrolled() {
		var st = $(this).scrollTop();

		// Make sure they scroll more than delta
		if(Math.abs(lastScrollTop - st) <= delta)
			return;

		// If they scrolled down and are past the navbar, add class .nav-up.
		// This is necessary so you never see what is "behind" the navbar.
		if (st > lastScrollTop && st > navbarHeight){
			// Scroll Down
			$("#header").removeClass("nav-down").addClass("nav-up");
			//$("#gotop").removeClass("nav-down").addClass("nav-up");
		} else {
			// Scroll Up
			if(st + $(window).height() < $(document).height()) {
				$("#header").removeClass("nav-up").addClass("nav-down");
				//$("#gotop").removeClass("nav-up").addClass("nav-down");
			}
		}
		lastScrollTop = st;
	}

	/* gnb */
	var gnbSwiper = new Swiper("#navGnb .swiper-container", {
		slidesPerView:"auto"
	});
});
</script>
<!-- 모바일 헤더 (header_wrap) -->
<div id="header" class="header_wrap">
	<header class="tenten_header header_main">
		<div class="header_inner">
			<button onclick="history.back();" type="button" class="header_back"><span class="blind">뒤로가기</span></button>
			<div class="util">
				<a href="/search/search_entry2020.asp" class="btn_search"><i class="i_magnify"></i><span class="blind">검색</span></a>
				<a href="/inipay/ShoppingBag.asp" class="btn-shoppingbag">
					<span class="blind">장바구니</span><i class="i_bag"></i>
					<% If GetCartCount > 0 Then %>
						<span class="badge"><%= GetCartCount %><%=chkiif(GetCartCount > 99,"+","")%></span>
					<% End If %>
				</a>
			</div>
		</div>
	</header>
</div>