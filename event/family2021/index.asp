<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 가정의달 2021
' History : 2020-04-06 김형태 생성
'####################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)

	If gnbflag <> "" Then '//gnb 숨김 여부
		gnbflag = true
		strHeadTitleName = ""
	Else
		gnbflag = False
		strHeadTitleName = "가정의 달"
	End if
%>
<script>
	function scrollAction(st, hh) {
		var tit = $('.family2021 .tab-wrap h3');
		var tab = $('.family2021 .tab-nav').offset().top;
		var evt = $('.family2021 .evt-wrap').offset().top;
		var nav = $('.family2021 .tab-list');
		if (st + $(window).height() * .5 >= tit.offset().top) tit.addClass('on');
		if (st >= tab && st <= evt) {
			nav.css({'position': 'fixed', 'top': hh});
		} else {
			nav.css({'position': 'absolute', 'top': 0});
		}
	}
	$(function() {
		// 플로팅 탭
		var hh = $('.header_main').height();
		// scroll
		$(window).on('scroll', function(e) {
			var st = $(window).scrollTop() + hh;
			scrollAction(st, hh);
		});
		// click
		$(".family2021 .tab-nav a").on('click', function(e) {
			e.preventDefault();
			var target = $(this.hash).offset().top - $('.tab-nav').height() - hh;
			$('html,body').animate({'scrollTop': target + 1}, 0);
		});
	});
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<% server.Execute("/event/family2021/exec.asp") %>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>