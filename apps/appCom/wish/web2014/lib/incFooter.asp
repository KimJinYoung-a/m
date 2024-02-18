<!-- incLogScript 2015.07.22 원승현 추가(앱용 로그관련 스크립트는 전부 이쪽으로..) -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
$(function(){
	
	if ($("body").hasClass("body-main")){
		checkOS();
	}

	var didScroll;
	var lastScrollTop = 0;
	var delta = 5;

	
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

		if(Math.abs(lastScrollTop - st) <= delta)
			return;

		if (st > lastScrollTop && st){
			// Scroll Down
			$("#header").removeClass("nav-down").addClass("nav-up");
			$("#gotop").removeClass("nav-down").addClass("nav-up");
		} else {
			// Scroll Up
			if(st + $(window).height() < $(document).height()) {
				$("#header").removeClass("nav-up").addClass("nav-down");
				$("#gotop").removeClass("nav-up").addClass("nav-down");
			}
		}
		lastScrollTop = st;
	}

	/* footer contents show hide */
	$(".tenten-footer .tenten a").on("click", function(e){
		$(this).toggleClass("on");
		$(".tenten-footer address .desc").toggle();
		return false;
	});
});

/* android and ios check for body-main padding */
function checkOS(){
	if(userAgent.match("ipad") || userAgent.match("iphone") || userAgent.match("ipod")) {
		$(".body-main").addClass("ios");
	} else {
		$(".body-main").addClass("android");
	}
}
</script>
<footer class="tenten-footer">
	<div class="footer-content">
		<div class="footer-nav">
			<a href="" onclick="fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appcom/wish/web2014/common/news/index.asp?','right','','sc');return false;">공지사항</a>			
			<a href="" onclick="fnAPPpopupBrowserURL('고객행복센터','<%=wwwUrl%>/apps/appCom/wish/web2014/cscenter/','right','','sc'); return false;">고객행복센터</a>
			<a href="" onclick="fnAPPpopupBrowserURL('매장안내','<%=wwwUrl%>/apps/appcom/wish/web2014/offshop/','right','','sc');return false;">매장안내</a>
			<a href="" onclick="openbrowser('http://company.10x10.co.kr/'); return false;">회사소개</a>
		</div>

		<address>
			<div class="tenten"><a href="#moretenten" title="더보기">(주) 텐바이텐 사업자정보</a></div>
			<div id="moretenten" class="desc">
				<p class="info">대표이사 : 최은희<br /> <a href="" onclick="openbrowser('http://www.ftc.go.kr/bizCommPop.do?wrkr_no=2118700620'); return false;" title="공정거래위원회 사업자등록현황 통신판매사업자 정보 페이지로 이동">사업자등록번호 : <u>211-87-00620</u> <br />통신판매업 신고번호 : <u>제 01-1968호</u></a></p>
				<%'// 대표님 지시로 인한 cs 전화번호 임시 비노출 2020-10-16 %>
				<% If left(now(),10)>="2022-01-01" Then %>				
					<p class="cs"><!-- <a href="tel:1644-6030">고객센터 1644-6030</a> --> <a href="mailto:customer@10x10.co.kr">이메일보내기</a></p>
				<% Else %>
					<p class="cs"><a href="mailto:customer@10x10.co.kr">이메일보내기</a></p>
				<% End If %>
			</div>
		</address>

		<div class="footer-link">
			<a href="" onclick="fnAPPpopupBrowserURL('이용약관','<%=wwwUrl%>/apps/appcom/wish/web2014/member/pop_viewUsageTerms.asp','right','','sc');return false;">이용약관</a>
			<a href="" onclick="fnAPPpopupBrowserURL('개인정보처리방침','<%=wwwUrl%>/apps/appcom/wish/web2014//member/pop_viewPrivateTerms.asp','right','','sc');return false;" style="font-weight:bold;">개인정보처리방침</a>
			<a href="" onclick="fnAPPpopupBrowserURL('청소년보호정책','<%=wwwUrl%>/apps/appcom/wish/web2014//member/youth.asp','right','','sc');return false;">청소년보호정책</a>
		</div>

		<ul class="tenten-sns">
			<li><a href="" onclick="openbrowser('http://facebook.com/your10x10'); return false;" class="facebook">텐바이텐 페이스북으로 이동</a></li>
			<li><a href="" onclick="openbrowser('http://instagram.com/your10x10'); return false;" class="instagram">텐바이텐 공식 인스타그램계정으로 이동</a></li>
			<!-- li><a href="http://www.10x10shop.com/Mobile" onclick="openbrowser('http://www.10x10shop.com/Mobile'); return false;" target="_blank" class="china">텐바이텐 차이나 쇼핑몰로 이동</a></li -->
		</ul>
		<p class="copyright">&copy; Tenbyten inc.</p>
	</div>
</footer>
<div id="gotop" class="btn-top" onclick="fnAPPpopupScrollToTOP();"><button type="button">맨위로</button></div>
<div id="modalLayer" style="display:none;"></div>
<div id="modalLayer2" style="display:none;"><div id="modalLayer2Contents"></div><div id="dimed"></div></div>