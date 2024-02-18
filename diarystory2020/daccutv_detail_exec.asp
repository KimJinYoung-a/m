<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 다꾸티비 상세 페이지
' History : 2019-08-22 이종화 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim vAdrVer
dim debugMode

debugMode = request("debugMode")
vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<script type="text/javascript">
function fnSearchEventText(stext){
	<% If flgDevice="A" Then %>
		fnAPPpopupSearch(stext);
	<% Else %>
		<% If vAdrVer>="2.24" Then %>
			fnAPPpopupSearchOnNormal(stext,"product");
		<% Else %>
			fnAPPpopupSearch(stext);
		<% End If %>
	<% End If %>
}

var isapp = '<%=isapp%>'
var debugMode = '<%=debugMode%>'

$(function() {
	// 상세페이지 탑버튼 숨김
	$("#gotop").remove();

	var prevent = false;
	$(window).scroll(function() {
		// header
		var hh = $(".tenten-header").outerHeight();
		var conT = $(".vod-info").offset().top - hh;
		var y = $(window).scrollTop();
		var fnFloating = function() {
			if ( conT < y ) {
				$(".info-floating").show();
			}
			else {
				$(".info-floating").hide();
			}
		}
		fnFloating();
	});

	// video
	$('.player .thm').click(function(){
		$(".tenten-header").removeClass("header-transparent");
		prevent = true;
		$(this).fadeOut(400);
		$(this).next('.vod').find('iframe')[0].contentWindow.postMessage('{"event":"command","func":"' + 'playVideo' + '","args":""}', '*');
		<% if isapp > 0 then%>
		fnSetAlwaysFixHeader();
		<% end if %>
	});

	// tags
	var tagSwiper = new Swiper('.info-tags .swiper-container', {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});

		// gift popup
	$(".reply-evt .thumbnail > a").click(function(e){
		$(".ly-gift").show();
		e.preventDefault();
	});
	$(".ly-gift .btn-close, .ly-gift .mask").click(function(e){
		$(".ly-gift").hide();
		e.preventDefault();
	});
});
</script>
	<!-- contents -->
	<div id="content" class="content diary-sub">
		<!-- platform -->
		<div id="app"></div>
	</div>	
	<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
	<% IF application("Svr_Info") = "Dev" or debugMode = 1 THEN %>
	<script src="/vue/vue_dev.js"></script>
	<% Else %>
	<script src="/vue/vue.min.js"></script>
	<% End If %>
	<script src="/vue/vue.lazyimg.min.js"></script>
	<!-- 컴포넌트 -->
	<script src="/vue/media/daccutv/common/clap/clap-icon.js?v=1.00"></script>
	<script src="/vue/media/daccutv/detail/owner.js"></script>
	<script src="/vue/media/daccutv/detail/banner-list.js"></script>
	<script src="/vue/media/daccutv/detail/player.js"></script>
	<script src="/vue/media/daccutv/detail/vod-info.js"></script>
	<script src="/vue/media/daccutv/detail/related-product.js"></script>
	<script src="/vue/media/daccutv/detail/relatedContents.js"></script>
	<script src="/vue/media/daccutv/detail/comment-list.js?v=1.0"></script>
	<script src="/vue/event/comment/event-comment.js"></script>
	<!-- 뷰인스턴스 -->
	<script src="/vue/media/daccutv/detail/index.js"></script>
	<!-- //contents -->