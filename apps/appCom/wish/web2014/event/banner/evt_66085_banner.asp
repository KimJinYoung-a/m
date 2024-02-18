<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<style type="text/css">
.bagManBanner {position:relative;}
.bagManBanner img {vertical-align:top;}
.bagManBanner .goEvt {position:absolute; left:10%; bottom:3.5%; width:80%; height:13%;}
.bagManBanner .goEvt a {display:block; overflow:hidden; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=66085",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=66085');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
<!-- 봉투맨 전면 배너-->
<div class="bagManBanner">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66085/img_front_banner01.gif" alt="당신의 선택이 보너스를 결정한다 - 봉투맨" /></h2>
	<p class="goEvt"><a href="#" onclick="app_mainchk(); return false;">이벤트 참여하기</a></p>
</div>
<!--//봉투맨 전면 배너 -->
</body>
</html>