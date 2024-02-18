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
		eCode   =  63801
	Else
		eCode   =  64071
	End If

	''1주차,2주차 구분
	If left(nowdate,10)<"2015-07-06" Then
		DayName = "01"
	else
		DayName = "02"
	end if

	''5일치 구분(1주차5일,2주차5일)
	If left(nowdate,10)<"2015-06-30" or left(nowdate,10)="2015-07-06" Then
		evtimagenum	=	"01"
	elseif left(nowdate,10)="2015-06-30" or left(nowdate,10)="2015-07-07" Then
		evtimagenum	=	"02"
	elseif left(nowdate,10)="2015-07-01" or left(nowdate,10)="2015-07-08" Then
		evtimagenum	=	"03"
	elseif left(nowdate,10)="2015-07-02" or left(nowdate,10)="2015-07-09" Then
		evtimagenum	=	"04"
	elseif left(nowdate,10)="2015-07-03"  or left(nowdate,10)="2015-07-04" or left(nowdate,10)="2015-07-05" or left(nowdate,10)>="2015-07-10" Then
		evtimagenum	=	"05"
	end if
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt64071 {position:relative;}
.mEvt64071 .btnevent {position:absolute; bottom:7%; left:50%; width:83.4%; margin-left:-41.7%;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk64071.asp",
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
	<!-- [APP전용] 초능력자들 전면배너-->
	<div class="mEvt64071">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/<%=DayName%>/img_front_<%=evtimagenum%>.jpg" alt="오늘의 초능력 공중부양" /></p>
		<div class="btnevent"><a href="" onclick="app_mainchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64071/01/btn_event.png" alt="능력자들 이벤트 응모하러 가기" /></a></div>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->