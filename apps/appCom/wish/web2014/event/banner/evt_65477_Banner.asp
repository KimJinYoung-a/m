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
		eCode   =  64854
	Else
		eCode   =  65477
	End If
%>
<style type="text/css">
img {vertical-align:top;}

.mEvt65477 {position:relative;}
.mEvt65477 .btnEvent {position:absolute; bottom:3%; left:50%; width:65.46%; margin-left:-32.78%;}
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
<div class="mEvt65477">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/img_front_banner.jpg" alt="불이 켜진 비밀의 방으로 당신을 초대합니다. 초대장을 받으신 분들에게만 선물이 찾아갑니다!" /></p>
	<a href="" onclick="app_mainchk(); return false;" class="btnEvent"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65477/btn_event.gif" alt="비밀의 방 이벤트 참여하기" /></a>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->