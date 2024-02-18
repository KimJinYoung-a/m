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
.mEvt75048 {position:relative;}
.mEvt75048 .btnGo {display:block; position:absolute; bottom:4.5%; left:50%; width:81.25%; height:20%; margin-left:-40.625%;}

</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=75048",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=chkIIF(application("Svr_Info")="Dev","66252","75048")%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
	<% If Date()=> "2016-12-20" And Date() <= "2016-12-21" then %>
	<div class="appFrontBanner">
		<a href="" onclick="fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=75100');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/75100/m/bnr_front_a.jpg" alt="해피산타쿠폰 이벤트 참여하기" /></a>
	</div>
	<% Else %>
	<!-- [75048] 12월 30일 전면배너-->
	<div class="mEvt75048">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/75048/m/img_banner.jpg" alt="12월 30일 잊지 못할 하루를 텐바이텐이 드립니다. 지금 바로 응모하세요!" /></p>
		<a href="" onclick="app_mainchk(); return false;" class="btnGo" alt="이벤트 참여하기"></a>
	</div>
	<!--//75048 -->
	<% End If %>
	</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->