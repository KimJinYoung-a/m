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
	dim evt_code, vMiracleGiftItemId, vToday, sqlStr
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21466
	Else
		evt_code   =  59261
	End If

	vToDay = left(Now(), 10) '// 오늘 날짜 값..
	'// 날짜값을 기준으로 메인정보를 가져온다.
	sqlstr = " Select idx, miracledate, miracleprice, miraclegiftitemid, regdate " &_
				 " From db_temp.dbo.tbl_MiracleOf10sec_Master " &_
				" Where convert(varchar(10), miracledate, 120) = '"&vToDay&"' "
	rsget.Open sqlStr,dbget,1
	If Not(rsget.bof Or rsget.eof) Then
		vMiracleGiftItemId = CLng(getNumeric(rsget("miraclegiftitemid")))
	Else
		vMiracleGiftItemId=""
	End If
	rsget.close


%>
<style type="text/css">
.tenSecondsBanner {position:relative;}
.tenSecondsBanner img {vertical-align:top;}
.tenSecondsBanner .goEvt {position:absolute; left:10%; bottom:16%; width:80%; height:12%;}
.tenSecondsBanner .goEvt a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript59261.asp",
		data: "mode=app_main&vMiracleGiftItemId=<%=vMiracleGiftItemId%>",
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
	<!-- 10초의 기적 전면 배너-->
	<div class="tenSecondsBanner">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59261/img_front_banner.jpg" alt="어벤져박스의 기적" /></h2>
		<p class="goEvt"><a href="" onclick="app_mainchk(); return false;">이벤트 참여하러 가기</a></p>
	</div>
	<!--// 10초의 기적 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->