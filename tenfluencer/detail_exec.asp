<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 미디어 플랫폼 상세 실행페이지
' History : 2019-05-21 최종원 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim vAdrVer
dim debugMode

debugMode = request("debugMode")
vAdrVer = 1.0
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/platform.css?v=2.00">
<script type="text/javascript" src="/lib/js/jquery.transit.min.js"></script>
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
		var fnHeader = function() {
			if ( conT < y && prevent === false ) {
				$(".tenten-header").removeClass("header-transparent");
			}
			else if ( conT > y && prevent === false ) {
				$(".tenten-header").addClass("header-transparent");
			}
		}
		var fnFloating = function() {
			if ( conT < y ) {
				$(".info-floating").show();
			}
			else {
				$(".info-floating").hide();
			}
		}
		fnHeader();
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

	// wish
	// $('.btn-wish').click(function(){
	// 	$(this).toggleClass('on');
	// 	$(this).children("i").transition({ scale: 1.1 }, 100).transition({ scale: 1 }, 100);
	// });

	// reply
/*
	$(".reply-evt .write textarea").on({
		focus: function() {
			$(this).attr( 'placeholder', '300자 이내로 작성해주세요' ),
			$(this).closest(".write").addClass("focus");
		},
		keypress: function() {
			$(this).closest(".write").addClass("writing");
		},
		blur: function() {
			if( $(this).closest(".write").hasClass("writing") ) {
				return false;
			} else {
				$(this).attr( 'placeholder', '댓글을 입력해주세요' ),
				$(this).closest(".write").removeClass("focus");
			}
		}
	});
 */
	// gift popup
	$(".reply-evt .thumbnail > a").click(function(e){
		$(".ly-gift").show();
		e.preventDefault();
	});
	$(".ly-gift .btn-close, .ly-gift .mask").click(function(e){
		$(".ly-gift").hide();
		e.preventDefault();
	});

	// clap
/*
 	var popState = false;
	$(".btn-clap").click(function(){
		$this = $(this);
		$parent = $(this).parent(".clap-wrap");
		$parent.addClass("is-touched");
		$this.siblings(".count").show();

		var point = "<div class='point'><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span><span class='point-item'></span></div>";
		$this.siblings(".point").remove();
		$parent.append(point);

		// for dev msg : 박수 30번 축하 팝업 - popClap() 주석 해제
		var popClap = function() {
			$(".ly-clap").delay(300).show(0).delay(2100).hide(0);
		}
		if( popState === false ){
			// popClap();
			popState = true;
		}
		setTimeout(function(){
			popState = false;
		}, 3000);
	});
 */
});
</script>
	<!-- contents -->
	<div id="content" class="content">
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
	<script src="/vue/media/tenfluencer/common/clap/clap-icon.js?v=1.00"></script>
	<script src="/vue/media/tenfluencer/detail/owner.js"></script>
	<script src="/vue/media/tenfluencer/detail/banner-list.js"></script>
	<script src="/vue/media/tenfluencer/detail/player.js"></script>
	<script src="/vue/media/tenfluencer/detail/vod-info.js"></script>
	<script src="/vue/media/tenfluencer/detail/related-product.js"></script>
	<script src="/vue/media/tenfluencer/detail/relatedContents.js"></script>
	<script src="/vue/media/tenfluencer/detail/comment-list.js?v=1.0"></script>
	<script src="/vue/event/comment/event-comment.js"></script>
	<!-- 뷰인스턴스 -->
	<script src="/vue/media/tenfluencer/detail/index.js"></script>
	<!-- //contents -->