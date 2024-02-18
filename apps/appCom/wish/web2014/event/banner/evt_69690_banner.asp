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
.appFrontBanner {position:relative;}
.appFrontBanner img {vertical-align:top;}
.appFrontBanner .goEvt {position:absolute; left:5%; bottom:2%; width:90%; height:14%;}
.appFrontBanner .goEvt a {display:block; overflow:hidden; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=69690",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=69690');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
	<div class="appFrontBanner">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69690/img_front_banner.jpg" alt="특별한 당신에게 보이는 사대천왕" /></h2>
		<p class="goEvt"><a href="#" onclick="app_mainchk(); return false;">이벤트 참여하기</a></p>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->