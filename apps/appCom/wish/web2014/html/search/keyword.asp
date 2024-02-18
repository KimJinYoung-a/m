<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/head.asp" -->
<script type="text/javascript">
$(function(){
	/* iphone, ipad, ipod */
	var userAgent = navigator.userAgent.toLowerCase();
	function iSearch(){
		if(userAgent.match("ipad") || userAgent.match("iphone") || userAgent.match("ipod")) {
			$(".search input").focus(function() {
				$(".search").css("position", "absolute");
				$(".keyword .tab").css("position", "absolute");
			});
		}
	}
	iSearch();

	/* tab menu */
	$(".tabCont").hide();
	$(".tab").find("li:first a").addClass("on");
	$(".tabContainer").find(".tabCont:first").show();

	$(".tab li").click(function() {
		$(this).siblings("li").find("a").removeClass("on");
		$(this).find("a").addClass("on");
		$(this).closest(".tab").nextAll(".tabContainer:first").find(".tabCont").hide();
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});
});
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<h1 class="hide">검색</h1>
			<!-- search  -->
			<div class="search">
				<!-- for dev msg : action에 임시로 넣어두었습니다. -->
				<form action="http://m.10x10.co.kr/search/search_item.asp">
					<fieldset>
						<input type="search" title="검색어 입력" required placeholder="레인슈즈" />
						<input type="submit" value="검색" class="btnSch" />
						<button type="button" class="btnCancel">취소</button>
					</fieldset>
				</form>
			</div>
			<!-- //search -->

			<!-- keyword -->
			<div class="keyword">
				<ul class="tab">
					<li><a href="#interest">인기 검색어</a></li>
					<li><a href="#recent">최근 검색어</a></li>
				</ul>
				<div class="tabContainer">
					<div id="interest" class="tabCont interest">
						<h2 class="hide">인기 검색어</h2>
						<ul>
							<li><a href="">1. 아이패드 거치대</a></li>
							<li><a href="">2. 드라이기</a></li>
							<li><a href="">3. MY Bottle</a></li>
							<li><a href="">4. 장우산</a></li>
							<li><a href="">5. 스냅백</a></li>
							<li><a href="">6. 에코백</a></li>
							<li><a href="">7. 개코백</a></li>
							<li><a href="">8. 개코원숭이</a></li>
							<li><a href="">9. 비타민</a></li>
							<li><a href="">10. 다이어트</a></li>
						</ul>
					</div>

					<div id="recent" class="tabCont recent">
						<h2 class="hide">최근 검색어</h2>
						<ul>
							<li><a href="">아이폰 <span>08.04</span></a></li>
							<li><a href="">틴트 <span>08.04</span></a></li>
							<li><a href="">스냅백 <span>08.04</span></a></li>
							<li><a href="">sleepy <span>08.04</span></a></li>
							<li><a href="">레인코트 <span>08.04</span></a></li>
							<li><a href="">선글라스 <span>08.04</span></a></li>
						</ul>
						<button type="button" class="btnDel">검색기록 삭제</button>
						<!-- for dev msg : 최근 검색기록이 없을 경우 -->
						<p class="noData">최근 검색기록이 없습니다.</p>
					</div>
				</div>
			</div>
			<!-- //keyword -->

		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/html/lib/inc/incFooter.asp" -->
</div>
</body>
</html>