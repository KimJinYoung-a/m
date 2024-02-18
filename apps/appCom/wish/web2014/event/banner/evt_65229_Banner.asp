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
<%
	dim eCode
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64843
	Else
		eCode   =  65229
	End If
%>
<style type="text/css">
.rewardBanner {position:relative;}
.rewardBanner img {vertical-align:top;}
.rewardBanner .goEvt {position:absolute; left:15%; bottom:8.5%; width:70%; height:13%;}
.rewardBanner .goEvt a {display:block; overflow:hidden; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=<%=eCode%>",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
<div class="rewardBanner">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65229/img_front_banner.jpg" alt="현상금을 노려라" /></h2>
	<p class="goEvt"><a href="" onclick="app_mainchk(); return false;">이벤트 참여하러 가기</a></p>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->