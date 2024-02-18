<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2015-03-09"
	
	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)

	If vEventID = "73038" Then
		vStartNo = "0"
	ElseIf vEventID = "73039" Then
		vStartNo = "0"
	ElseIf vEventID = "73050" Then
		vStartNo = "0"
	ElseIf vEventID = "73137" Then
		vStartNo = "1"
	ElseIf vEventID = "73204" Then
		vStartNo = "2"
	ElseIf vEventID = "73205" Then
		vStartNo = "4"
	ElseIf vEventID = "73206" Then
		vStartNo = "4"
	ElseIf vEventID = "73207" Then
		vStartNo = "5"
	End IF
	
	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.earlyDiaryNav {position:relative; width:100%; height:4.9rem; z-index:10;}
.earlyDiaryNav .swiper-container {width:100%; height:4.9rem;}
.earlyDiaryNav li {position:relative; float:left; width:9rem; height:4.9rem; padding-top:1.35rem; background-color:#bacad8; margin-right:1px; color:#fff; text-align:center; border-radius:0.75rem 0.75rem 0 0; font-size:1rem; line-height:1.2;}
.earlyDiaryNav li span {font-size:1.1rem; font-weight:600;}
.earlyDiaryNav li a {display:none; width:9rem; height:4.9rem; margin-top:-1.35rem; padding-top:1.35rem;}
.earlyDiaryNav li.current {background-color:#006aca;}
.earlyDiaryNav li.open a {display:block; width:9rem; height:4.9rem;}
</style>
<script type="text/javascript">
$(function(){
	earlyDiarySwiper = new Swiper('.earlyDiaryNav .swiper-container',{
		initialSlide:<%=vStartNo%>,
		loop:false,
		autoplay:false,
		speed:500,
		slidesPerView:'auto',
		pagination:false
	});
});
</script>
</head>
<body>
<div class="earlyDiaryNav">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide nav1 open <%=CHKIIF(vEventID="73038"," current","")%>">
				<a href="<%=appevturl%>eventid=73038" target="_top">09.21<br /><span>아이코닉</span></a>
			</li>

			<% if currentdate < "2016-09-22" then %>
				<li class="swiper-slide nav2">09.22<br /><span>인디고</span></li>
			<% Else %>
				<li class="swiper-slide nav2 open <%=CHKIIF(vEventID="73039"," current","")%>">
					<a href="<%=appevturl%>eventid=73039" target="_top">09.22<br /><span>인디고</span></a>
				</li>
			<% End If %>

			<% if currentdate < "2016-09-23" then %>
				<li class="swiper-slide nav3">09.23<br /><span>안테나샵</span></li>
			<% Else %>
				<li class="swiper-slide nav3 open <%=CHKIIF(vEventID="73050"," current","")%>">
					<a href="<%=appevturl%>eventid=73050" target="_top">09.23<br /><span>안테나샵</span></a>
				</li>
			<% End If %>

			<% if currentdate < "2016-09-26" then %>
				<li class="swiper-slide nav4">09.26<br /><span>7321</span></li>
			<% Else %>
				<li class="swiper-slide nav4 open <%=CHKIIF(vEventID="73137"," current","")%>">
					<a href="<%=appevturl%>eventid=73137" target="_top">09.26<br /><span>7321</span></a>
				</li>
			<% End If %>

			<% if currentdate < "2016-09-27" then %>
				<li class="swiper-slide nav5">09.27<br /><span>라이브워크</span></li>
			<% Else %>
				<li class="swiper-slide nav5 open <%=CHKIIF(vEventID="73204"," current","")%>">
					<a href="<%=appevturl%>eventid=73204" target="_top">09.27<br /><span>라이브워크</span></a>
				</li>
			<% End If %>

			<% if currentdate < "2016-09-28" then %>
				<li class="swiper-slide nav6">09.28<br /><span>세컨드맨션</span></li>
			<% Else %>
				<li class="swiper-slide nav6 open <%=CHKIIF(vEventID="73205"," current","")%>">
					<a href="<%=appevturl%>eventid=73205" target="_top">09.28<br /><span>세컨드맨션</span></a>
				</li>
			<% End If %>

			<% if currentdate < "2016-09-29" then %>
				<li class="swiper-slide nav7">09.29<br /><span>바이.풀디자인</span></li>
			<% Else %>
				<li class="swiper-slide nav7 open <%=CHKIIF(vEventID="73206"," current","")%>">
					<a href="<%=appevturl%>eventid=73206" target="_top">09.29<br /><span>바이.풀디자인</span></a>
				</li>
			<% End If %>

			<% if currentdate < "2016-09-30" then %>
				<li class="swiper-slide nav8">09.30<br /><span>아르디움</span></li>
			<% Else %>
				<li class="swiper-slide nav8 open <%=CHKIIF(vEventID="73207"," current","")%>">
					<a href="<%=appevturl%>eventid=73207" target="_top">09.30<br /><span>아르디움</span></a>
				</li>
			<% End If %>
		</ul>
	</div>
</div>
</body>
</html>