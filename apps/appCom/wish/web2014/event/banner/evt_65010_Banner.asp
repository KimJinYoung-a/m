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
	dim DayName, evtimagenum
	dim eCode, nowdate
	nowdate = now()
'	nowdate = "2015-07-06 10:00:00"
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  64837
	Else
		eCode   =  65010
	End If

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-08-03" Then
		DayName = "01"
	else
		DayName = "02"
	end if

	''5일치 구분(1주차5일,2주차5일)
	If left(nowdate,10)<"2015-07-28" or left(nowdate,10)="2015-08-03" Then
		evtimagenum	=	"01"
	elseif left(nowdate,10)="2015-07-28" or left(nowdate,10)="2015-08-04" Then
		evtimagenum	=	"02"
	elseif left(nowdate,10)="2015-07-29" or left(nowdate,10)="2015-08-05" Then
		evtimagenum	=	"03"
	elseif left(nowdate,10)="2015-07-30" or left(nowdate,10)="2015-08-06" Then
		evtimagenum	=	"04"
	elseif left(nowdate,10)="2015-07-31" or left(nowdate,10)>="2015-08-07" or left(nowdate,10)>="2015-08-01" or left(nowdate,10)>="2015-08-02" Then
		evtimagenum	=	"05"
	end if
%>
<style type="text/css">
.freezerBanner {position:relative;}
.freezerBanner img {vertical-align:top;}
.freezerBanner .goEvt {position:absolute; left:10%; bottom:4%; width:80%; height:11%;}
.freezerBanner .goEvt a {display:block; overflow:hidden; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk65010.asp",
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
<!-- 냉동실을 부탁해 전면 배너-->
<div class="freezerBanner">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65010/<%=DayName%>/img_front<%=evtimagenum%>.jpg" alt="냉동실을 부탁해" /></h2>
	<p class="goEvt"><a href="" onclick="app_mainchk(); return false;">이벤트 참여하러 가기</a></p>
</div>
<!--//냉동실을 부탁해 전면 배너 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->