<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 아이커피 1차
' History : 2015.06.18 원승현 생성
'			2015.06.19 한용민 수정(전면배너 클릭카운트 추가)
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim DayName, evtimagenum, evtImgFName
dim eCode, nowdate
nowdate = now()
'nowdate = "2015-06-23 10:00:00"

IF application("Svr_Info") = "Dev" THEN
	eCode   =  63794
Else
	eCode   =  63739
End If

If nowdate >= "2015-06-18" And nowdate < "2015-06-23" Then
	evtImgFName = "coffee"
End If

If nowdate >= "2015-06-23" And nowdate < "2015-06-26" Then
	evtImgFName = "chicken"
End If

If nowdate >= "2015-06-26" Then
	evtImgFName = "tteokbokki"
End If

dim tmpval
if nowdate>="2015-06-23" then
	tmpval = "2"
elseif nowdate>="2015-06-26" then
	tmpval = "3"
else
	tmpval = "1"
end if
%>

<style type="text/css">
.mEvt63739 {position:relative;}
.mEvt63739 img {vertical-align:top;}
.mEvt63739 .btnevent {position:absolute; bottom:3%; left:50%; width:75%; margin-left:-37.5%;}
</style>
<script>
function app_mainchk(){
	var str = $.ajax({
		type: "GET",
		url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript63739_<%= tmpval %>.asp",
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
<%' [APP] 텐바이텐 심심타파 전면배너 %>
<div class="mEvt63739">
	<p>
		<img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/<%=evtImgFName%>/img_i_love_front.jpg" alt="" />
	</p>

	<a href="" onclick="app_mainchk(); return false;" class="btnevent"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63739/coffee/btn_event.png" alt="이벤트 참여하기" /></a>
</div>
<%'// [APP] 텐바이텐 심심타파 전면배너 %>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->