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
'	nowdate = "2015-05-21 10:00:00"
	
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  63772
	Else
		eCode   =  62985
	End If

	''1주차,2주차 구분
	'If left(nowdate,10)<"2015-06-06" Then
		DayName = "mon_01"
	'else
	'	DayName = "mon_02"
	'end if

	''5일치 구분(1주차5일,2주차5일)
	If left(nowdate,10)<"2015-06-02" or left(nowdate,10)="2015-06-06" or left(nowdate,10)="2015-06-07" or left(nowdate,10)="2015-06-08" Then
		evtimagenum	=	"01"
	elseif left(nowdate,10)="2015-06-02" or left(nowdate,10)="2015-06-09" Then
		evtimagenum	=	"02"
	elseif left(nowdate,10)="2015-06-03" or left(nowdate,10)="2015-06-10" Then
		evtimagenum	=	"03"
	elseif left(nowdate,10)="2015-06-04" or left(nowdate,10)="2015-06-11" Then
		evtimagenum	=	"04"
	elseif left(nowdate,10)="2015-06-05" or left(nowdate,10)>="2015-06-12" Then
		evtimagenum	=	"05"
	end if
%>


<style type="text/css">
img {vertical-align:top;}
.mEvt62985 .place {position:relative;}
.mEvt62985 .place .btnevent {position:absolute; bottom:5%; left:50%; width:83.4%; margin-left:-41.7%;}
</style>
<script>

function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/evtClickChk62985.asp",
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
<!-- [APP] 티켓 KING 전면배너 -->
<div class="mEvt62985">
	<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/tit_ticket_king_blue_front.png" alt="텐아비텐 여름 휴가 지원 프로젝트 티켓킹!" /></h1>
	<div class="place">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/img_place_<%= DayName %>_<%= evtimagenum %>_front.jpg" alt="오늘의 휴가지 니뽕! 일본 여행상품권 백만원 및 에다스 25형 수화물용 캐리어, 에어프레임 도쿄, 포카리스웨트 캔 250ml" /></p>
		<div class="btnevent"><a href="" onclick="app_mainchk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62985/btn_event.png" alt="이벤트 참여하기" /></a></div>
	</div>
</div>
<!-- //티켓 KING -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->