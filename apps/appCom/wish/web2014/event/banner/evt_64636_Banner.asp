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
	dim eCode , imgcode
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64819
	Else
		eCode   =  64636
	End If

	If Date() = "2015-07-13" Then
		imgcode = "5"
	ElseIf Date() = "2015-07-14" Then
		imgcode = "4"
	ElseIf Date() = "2015-07-15" Then
		imgcode = "3"
	ElseIf Date() = "2015-07-16" Then
		imgcode = "2"
	ElseIf Date() = "2015-07-17" Then
		imgcode = "1"
	ElseIf Date() = "2015-07-20" Then
		imgcode = "6"
	ElseIf Date() = "2015-07-21" Then
		imgcode = "7"
	ElseIf Date() = "2015-07-22" Then
		imgcode = "8"
	End If 

%>
<style type="text/css">
img {vertical-align:top;}
.mEvt64636 {position:relative;}
.mEvt64636 .btnevent {position:absolute; bottom:4.5%; left:50%; width:83.4%; margin-left:-41.7%; padding-bottom:20%;}
.mEvt64636 .btnevent a {overflow:hidden; display:block; position:absolute; left:0; top:0; right:0; bottom:0; width:100%; height:100%; text-indent:-999em;}
</style>
<script>
function app_mainchk(){
	<% if date() >= "2015-07-18" and date() <= "2015-07-19" then%>
		alert('다음 시작은 20일 오전 10시 입니다.');
		return false;
	<% end if %>
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk64636.asp",
		data: "mode=app_main",
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
	<!-- [최저가왕 전면 배너]-->
	<div class="mEvt64636">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64636/img_front0<%=imgcode%>.png" alt="최저가왕" /></p>
		<div class="btnevent"><a href="" onclick="app_mainchk(); return false;">이벤트 참여하기</a></div>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->