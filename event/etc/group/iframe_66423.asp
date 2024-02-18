<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description :  이벤트코드 66423(m/a) 오빠 럭키박스 뽑았다, 널 데리러가!
' History : 2015.09.24 
'####################################################
Dim oEventid : oEventid = Trim(request("eventid"))
Dim vFront, vBack
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
body {background-color:#ffefc7;}
.navigator {padding:6px 0 15px 5px; background-color:#ffefc7;}
.navigator ul {overflow:hidden; width:303px; margin:0 auto;}
.navigator ul li {float:left; width:101px; height:39px;}
.navigator ul li a, .navigator ul li span {display:block; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/66423/bg_nav_v2.png) no-repeat 0 0; background-size:606px auto; font-size:12px; text-indent:-999em;}
.navigator ul li.nav0924 a.on {background-position:0 -39px;}
.navigator ul li.nav0924 a {background-position:0 100%;}
.navigator ul li.nav0925 span {background-position:-101px 0;}
.navigator ul li.nav0925 a.on {background-position:-101px -39px;}
.navigator ul li.nav0925 a {background-position:-101px 100%;}

.navigator ul li.nav0926 span {background-position:-202px 0;}
.navigator ul li.nav0926 a.on {background-position:-202px -39px;}
.navigator ul li.nav0926 a {background-position:-202px 100%;}

.navigator ul li.nav0927 span {background-position:-303px 0;}
.navigator ul li.nav0927 a.on {background-position:-303px -39px;}
.navigator ul li.nav0927 a {background-position:-303px 100%;}

.navigator ul li.nav0928 span {background-position:-404px 0;}
.navigator ul li.nav0928 a.on {background-position:-404px -39px;}
.navigator ul li.nav0928 a {background-position:-404px 100%;}

.navigator ul li.nav0929 span {background-position:100% 0;}
.navigator ul li.nav0929 a.on {background-position:100% -39px;}
.navigator ul li.nav0929 a {background-position:100% 100%;}

@media all and (min-width:480px){
	.navigator {padding:10px 0 22px 7px;}
	.navigator ul {width:453px;}
	.navigator ul li {float:left; width:151px; height:58px;}
	.navigator ul li a, .navigator ul li span {background-size:906px auto;}
	.navigator ul li.nav0924 a.on {background-position:0 -58px;}
	.navigator ul li.nav0924 a {background-position:0 100%;}
	.navigator ul li.nav0925 span {background-position:-151px 0;}
	.navigator ul li.nav0925 a.on {background-position:-151px -58px;}
	.navigator ul li.nav0925 a {background-position:-151px 100%;}

	.navigator ul li.nav0926 span {background-position:-302px 0;}
	.navigator ul li.nav0926 a.on {background-position:-302px -58px;}
	.navigator ul li.nav0926 a {background-position:-302px 100%;}

	.navigator ul li.nav0927 span {background-position:-453px 0;}
	.navigator ul li.nav0927 a.on {background-position:-453px -58px;}
	.navigator ul li.nav0927 a {background-position:-453px 100%;}

	.navigator ul li.nav0928 span {background-position:-604px 0;}
	.navigator ul li.nav0928 a.on {background-position:-604px -58px;}
	.navigator ul li.nav0928 a {background-position:-604px 100%;}

	.navigator ul li.nav0929 span {background-position:100% 0;}
	.navigator ul li.nav0929 a.on {background-position:100% -58px;}
	.navigator ul li.nav0929 a {background-position:100% 100%;}
}
</style>
</head>
<body>
	<div class="navigator">
		<ul>
			<li class="nav0924"><a href="<%=CHKIIF(isApp=1,"/apps/appCom/wish/web2014","")%>/event/eventmain.asp?eventid=66423" <%=CHKIIF(oEventid="66423","class=""on""","")%> target="_top">9월 24일</a></li>
			<% Call sbIsTodayLater("2015-09-25",oEventid,"66474") %>
			<li class="nav0925"><%=vFront%>9월 25일 금<%=vBack%></li>
			<% Call sbIsTodayLater("2015-09-26",oEventid,"66475") %>
			<li class="nav0926"><%=vFront%>9월 26일 토<%=vBack%></li>
			<% Call sbIsTodayLater("2015-09-27",oEventid,"66476") %>
			<li class="nav0927"><%=vFront%>9월 27일 일<%=vBack%></li>
			<% Call sbIsTodayLater("2015-09-28",oEventid,"66477") %>
			<li class="nav0928"><%=vFront%>9월 28일 월<%=vBack%></li>
			<% Call sbIsTodayLater("2015-09-29",oEventid,"66478") %>
			<li class="nav0929"><%=vFront%>9월 29일 화<%=vBack%></li>
		</ul>
	</div>
</body>
</html>
<%
Sub sbIsTodayLater(d,re,e)
	Dim vToday
	vToday = Date()
	'vToday = DateAdd("d",Date(),3)
	If CDate(d) <= vToday Then
		vFront = "<a href=""" & CHKIIF(isApp=1,"/apps/appCom/wish/web2014","") & "/event/eventmain.asp?eventid=" & e & """ " & CHKIIF(CStr(re)=CStr(e),"class=""on""","") & " target=""_top"">"
		vBack = "</a>"
	Else
		vFront = "<span>"
		vBack = "</span>"
	End If
End Sub
%>