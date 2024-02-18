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
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21435
	Else
		evt_code   =  58539
	End If
%>
<style type="text/css">
.avengerBanner {position:relative;}
.avengerBanner img {vertical-align:top;}
.avengerBanner .goEvt {position:absolute; left:10%; bottom:14%; width:80%; height:13%;}
.avengerBanner .goEvt a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.avengerBanner .bnrFoot {position:relative; padding:13px 10px; text-align:left; font-size:14px; line-height:1; color:#616161; background:#f2f2f2;}
.avengerBanner .bnrFoot label {vertical-align:middle; padding-left:3px; font-weight:600;}
.avengerBanner .bnrFoot .close {display:block; position:absolute; right:14px; top:14px; width:17px;}
@media all and (min-width:480px){
	.avengerBanner .bnrFoot {padding:20px 15px; font-size:21px;}
	.avengerBanner .bnrFoot label {padding-left:5px;}
	.avengerBanner .bnrFoot .close {right:21px; top:21px; width:26px;}
}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript58539.asp",
		data: "mode=app_main",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=evt_code%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

</script>
</head>
<body>
	<!-- 어벤져박스의 기적 전면 배너-->
	<div class="avengerBanner">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58539/img_front_banner.gif" alt="어벤져박스의 기적" /></h2>
		<p class="goEvt"><a href="" onclick="app_mainchk(); return false;">이벤트 참여하러 가기</a></p>
	</div>
	<!--// 어벤져박스의 기적 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->