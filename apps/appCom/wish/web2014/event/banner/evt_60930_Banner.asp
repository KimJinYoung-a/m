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
	dim evt_code, vMiracleGiftItemId, vToday, sqlStr, nowdate
	dim aJaxEvtUrl

	nowdate = date()

	IF application("Svr_Info") = "Dev" THEN
		If nowdate >= "2015-04-13" And nowdate < "2015-04-17" Then
			evt_code   =  60743
		ElseIf nowdate >= "2015-04-17" And nowdate < "2015-04-21" Then
			evt_code   =  60748
		Else
			evt_code   =  60749
		End If
	Else
		If nowdate >= "2015-04-13" And nowdate < "2015-04-17" Then
			evt_code   =  60930
		ElseIf nowdate >= "2015-04-17" And nowdate < "2015-04-21" Then
			evt_code   =  60931
		Else
			evt_code   =  60932
		End If
	End If

	aJaxEvtUrl = "/apps/appcom/wish/web2014/event/etc/doEventSubscript"&evt_code&".asp"
%>
<style type="text/css">
.threeSweetsBanner {position:relative;}
.threeSweetsBanner img {vertical-align:top;}
.threeSweetsBanner .goEvt {position:absolute; left:10%; bottom:9.5%; width:80%; height:10%;}
.threeSweetsBanner .goEvt a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "<%=aJaxEvtUrl%>",
		data: "mode=app_main",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appcom/wish/web2014/event/eventmain.asp?eventid=<%=evt_code%>');
		return false;
	}else if (str=="soldout"){
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
	<!-- 셋콤달콤 전면 배너-->
	<div class="threeSweetsBanner">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_front_banner.png" alt="듣고, 먹고, 즐기는 셋콤달콤" /></h2>
		<p class="goEvt"><a href="" onclick="app_mainchk(); return false;">이벤트 참여하러 가기</a></p>
	</div>
	<!--//셋콤달콤 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->