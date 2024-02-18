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
	If vEventID = "80653" Then
		vStartNo = "0"
	ElseIf vEventID = "80655" Then
		vStartNo = "0"
	ElseIf vEventID = "80656" Then
		vStartNo = "1"
	ElseIf vEventID = "80657" Then
		vStartNo = "2"
	ElseIf vEventID = "80720" Then
		vStartNo = "3"
	ElseIf vEventID = "80749" Then
		vStartNo = "4"
	ElseIf vEventID = "80771" Then
		vStartNo = "5"
	ElseIf vEventID = "80852" Then
		vStartNo = "6"
	ElseIf vEventID = "80854" Then
		vStartNo = "7"
	ElseIf vEventID = "80855" Then
		vStartNo = "8"
	ElseIf vEventID = "80856" Then
		vStartNo = "9"
	ElseIf vEventID = "80857" Then
		vStartNo = "10"
	ElseIf vEventID = "80858" Then
		vStartNo = "11"
	ElseIf vEventID = "80859" Then
		vStartNo = "12"
	ElseIf vEventID = "80860" Then
		vStartNo = "12"
	End If
	
	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.navigator {width:100%; height:4.6rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/early/m/bg_tab.png) repeat 0 0; background-size:100% auto;}
.navigator .swiper-slide {width:28%; height:4.6rem; margin-left:0.1rem; padding-top:1.3rem; color:#fff; font-size:1rem; line-height:1.2; text-align:center; border-radius:3rem 3rem 0 0; background-color:#d5cdca;}
.navigator .swiper-slide:first-child {margin-left:0;}
.navigator .swiper-slide strong {display:block; font-size:1.1rem;}
.navigator .swiper-slide.open {padding-top:0; background-color:#c9afa9;}
.navigator .swiper-slide.current {padding-top:0; background-color:#f29f8a;}
.navigator .swiper-slide a {display:block; height:100%; padding-top:1.3rem;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});
});
</script>
</head>
<body>
	<div id="navigator" class="navigator">
		<div class="swiper-container">
			<ul class="swiper-wrapper">

				<% if currentdate < "2017-09-18" then %>
				<li class="swiper-slide open">09.18<strong>루카랩</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80653"," current","")%>">
					<a href="<%=appevturl%>eventid=80653" target="_top">09.18<strong>루카랩</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-19" then %>
				<li class="swiper-slide">09.19<strong>인디고</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80655"," current","")%>">
					<a href="<%=appevturl%>eventid=80655" target="_top">09.19<strong>인디고</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-20" then %>
				<li class="swiper-slide">09.20<strong>라이브워크</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80656"," current","")%>">
					<a href="<%=appevturl%>eventid=80656" target="_top">09.20<strong>라이브워크</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-21" then %>
				<li class="swiper-slide">09.21<strong>아이코닉</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80657"," current","")%>">
					<a href="<%=appevturl%>eventid=80657" target="_top">09.21<strong>아이코닉</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-22" then %>
				<li class="swiper-slide">09.22<strong>데일리라이크</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80720"," current","")%>">
					<a href="<%=appevturl%>eventid=80720" target="_top">09.22<strong>데일리라이크</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-25" then %>
				<li class="swiper-slide">09.25<strong>아르디움</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80749"," current","")%>">
					<a href="<%=appevturl%>eventid=80749" target="_top">09.25<strong>아르디움</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-26" then %>
				<li class="swiper-slide">09.26<strong>리훈</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80771"," current","")%>">
					<a href="<%=appevturl%>eventid=80771" target="_top">09.26<strong>리훈</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-27" then %>
				<li class="swiper-slide">09.27<strong>아이코닉</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80852"," current","")%>">
					<a href="<%=appevturl%>eventid=80852" target="_top">09.27<strong>아이코닉</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-28" then %>
				<li class="swiper-slide">09.28<strong>세컨드맨션</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80854"," current","")%>">
					<a href="<%=appevturl%>eventid=80854" target="_top">09.28<strong>세컨드맨션</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-09-29" then %>
				<li class="swiper-slide">09.29<strong>페이퍼리안</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80855"," current","")%>">
					<a href="<%=appevturl%>eventid=80855" target="_top">09.29<strong>페이퍼리안 </strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-10-02" then %>
				<li class="swiper-slide">10.02<strong>플라잉웨일즈</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80856"," current","")%>">
					<a href="<%=appevturl%>eventid=80856" target="_top">10.02<strong>플라잉웨일즈</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-10-10" then %>
				<li class="swiper-slide">10.10<strong>세컨드맨션</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80857"," current","")%>">
					<a href="<%=appevturl%>eventid=80857" target="_top">10.10<strong>세컨드맨션</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-10-11" then %>
				<li class="swiper-slide">10.11<strong>인디고</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80858"," current","")%>">
					<a href="<%=appevturl%>eventid=80858" target="_top">10.11<strong>인디고</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-10-12" then %>
				<li class="swiper-slide">10.12<strong>비온뒤</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80859"," current","")%>">
					<a href="<%=appevturl%>eventid=80859" target="_top">10.12<strong>비온뒤</strong></a>
				</li>
				<% End If %>

				<% if currentdate < "2017-10-13" then %>
				<li class="swiper-slide">10.13<strong>잼스튜디오</strong></li>
				<% Else %>
				<li class="swiper-slide open <%=CHKIIF(vEventID="80860"," current","")%>">
					<a href="<%=appevturl%>eventid=80860" target="_top">10.13<strong>잼스튜디오</strong></a>
				</li>
				<% End If %>

			</ul>
		</div>
	</div>
</body>
</html>