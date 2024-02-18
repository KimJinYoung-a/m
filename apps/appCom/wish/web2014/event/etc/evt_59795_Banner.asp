<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 슈퍼백의 기적(박스이벤트)
' History : 2015.03.11 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event59795Cls.asp" -->

<%
dim eCode
eCode=getevt_code
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
.superBagsBanner {position:relative;}
.superBagsBanner img {vertical-align:top;}
.superBagsBanner .goEvt {position:absolute; left:10%; bottom:4%; width:80%; height:10.5%;}
.superBagsBanner .goEvt a {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script type="text/javascript">

function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "<%= appUrlPath %>/event/etc/doEventSubscript59795.asp",
		data: "mode=app_main",
		dataType: "text",
		async: false
	}).responseText;
	if (str == "OK"){
		fnAPPpopupEvent_URL('<%=wwwUrl%><%= appUrlPath %>/event/eventmain.asp?eventid=<%=eCode%>');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

</script>
</head>
<body>
<!-- 슈퍼백의 기적 전면 배너-->
<div class="superBagsBanner">
	<h2>
		<% '<!-- 날짜별로 이미지명 변경됩니다 0316~0320 --> %>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/59795/img_front_banner_<%= Format00(2,month(currenttime)) %><%= Format00(2,day(currenttime)) %>.jpg" alt="슈퍼백의 기적" />
	</h2>
	<p class="goEvt"><a href="#" onclick="app_mainchk(); return false;">이벤트 참여하러 가기</a></p>
</div>
<!--// 슈퍼백의 기적 전면 배너 -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->