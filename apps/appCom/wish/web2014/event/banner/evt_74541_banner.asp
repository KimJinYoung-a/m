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
.greenChrisbox {position:relative;}
.greenChrisbox img {vertical-align:top;}
.greenChrisbox .btnGo {position:absolute; bottom:4.5%; left:50%; width:81.25%; margin-left:-40.625%;}

</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk.asp",
		data: "mode=app_main&ecode=74541",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=chkIIF(application("Svr_Info")="Dev","66243","74541")%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}
</script>
</head>
<body>
<!-- [74541] 이니스프리 프로모션 - 그린 크리스박스 전면배너-->
<div class="mEvt74541 greenChrisbox">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/img_bnr_front.jpg" alt="텐바이텐과 이니스프리가 함께하는 그린 크리스박스 배송비 2,000원만 결제하면 그린 크리스박스가 갑니다!" /></p>
	<a href="" onclick="app_mainchk(); return false;" class="btnGo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/74541/m/btn_go.png" alt="이벤트 참여하기" /></a>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->