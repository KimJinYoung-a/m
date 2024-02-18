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
	dim eCode, nowdate
	nowdate = now()
'	nowdate = "2015-05-21 10:00:00"
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  62771
	Else
		eCode   =  62786
	End If
%>
<style type="text/css">
.foodFighterBanner {position:relative;}
.foodFighterBanner img {vertical-align:top;}
.foodFighterBanner .goEvt {position:absolute; left:7%; bottom:1.5%; width:85.5%; height:13%;}
.foodFighterBanner .goEvt a {display:block; overflow:hidden; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk62786.asp",
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
<!-- 푸드파이터 전면 배너-->
<div class="foodFighterBanner">
	<% If left(nowdate,10)>="2015-05-20" and left(nowdate,10)<"2015-05-24" Then %>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/img_front_banner_ver1_v2.png" alt="푸드파이터 1라운드" /></h2>
	<% end if %>
	<% If left(nowdate,10)>="2015-05-24" and left(nowdate,10)<"2015-05-27" Then %>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/img_front_banner_ver2.png" alt="푸드파이터 2라운드" /></h2>
	<% end if %>
	<% If left(nowdate,10)>="2015-05-27" Then %>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62786/img_front_banner_ver3.png" alt="푸드파이터 3라운드" /></h2>
	<% end if %>
	<p class="goEvt"><a href="" onclick="app_mainchk(); return false;">이벤트 참여하러 가기</a></p>
</div>
<!--//푸드파이터 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->