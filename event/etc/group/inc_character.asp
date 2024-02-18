<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2017-09-05"
	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "86367" Then
		vStartNo = "0"
	ElseIf vEventID = "86645" Then
		vStartNo = "0"
	ElseIf vEventID = "86766" Then
		vStartNo = "1"
	ElseIf vEventID = "86951" Then
		vStartNo = "2"
	ElseIf vEventID = "87124" Then
		vStartNo = "3"
	ElseIf vEventID = "87274" Then
		vStartNo = "4"
	End If
%>
<style type="text/css">
.navigation {height:6.4rem; background:#f8f8f8;}
.navigation .swiper-slide {position:relative; width:11.2rem; height:6.4rem; color:#b7b7b7;  font-weight:600; text-align:center;}
.navigation .swiper-slide:before {content:''; position:absolute; left:0; top:50%; width:1px; height:3.9rem; margin-top:-1.95rem; background:#bababa;}
.navigation .swiper-slide:first-child:before {display:none;}
.navigation .swiper-slide p {display:table; width:100%; height:100%; font-size:1.1rem;}
.navigation .swiper-slide p span {display:table-cell; vertical-align:middle;}
.navigation .swiper-slide.open {background:#fff;}
.navigation .swiper-slide.open strong {display:block; padding-top:0.7rem; font-size:1.28rem;}
.navigation .swiper-slide.current {color:#222; font-weight:400; background:#fff;}
.navigation .swiper-slide.current:after {content:''; position:absolute; left:0; bottom:0; width:100%; height:.46rem; background:#222;}
</style>
<script type="text/javascript">
$(function(){
	navSwiper = new Swiper(".navigation .swiper-container",{
		initialSlide:<%=vStartNo%>,
		loop:false,
		slidesPerView:'auto',
		speed:600
	});
});
</script>
<div class="navigation">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<div class="swiper-slide open <%=CHKIIF(vEventID="86367"," current","")%>"><a href="eventmain.asp?eventid=86367" target="_top"><p><span>05.14<strong>히사시부리냥</strong></span></p></a></div>

			<% if currentdate < "2018-05-21" then %>
			<li class="swiper-slide"><p><span>05.21</span></p></li>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="86645"," current","")%>">
				<a href="eventmain.asp?eventid=86645" target="_top"><p><span>05.21<strong>핑팡퐁</strong></span></p></a>
			</li>
			<% End If %>

			<% if currentdate < "2018-05-28" then %>
			<li class="swiper-slide"><p><span>05.28</span></p></li>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="86766"," current","")%>">
				<a href="eventmain.asp?eventid=86766" target="_top"><p><span>05.28<strong>찌바</strong></span></p></a>
			</li>
			<% End If %>

			<% if currentdate < "2018-06-04" then %>
			<li class="swiper-slide"><p><span>06.04</span></p></li>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="86951"," current","")%>">
				<a href="eventmain.asp?eventid=86951" target="_top"><p><span>06.04<strong>고미</strong></span></p></a>
			</li>
			<% End If %>

			<% if currentdate < "2018-06-11" then %>
			<li class="swiper-slide"><p><span>06.11</span></p></li>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="87124"," current","")%>">
				<a href="eventmain.asp?eventid=87124" target="_top"><p><span>06.11<strong>도나쓰</strong></span></p></a>
			</li>
			<% End If %>

			<% if currentdate < "2018-06-18" then %>
			<li class="swiper-slide"><p><span>06.18</span></p></li>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="87274"," current","")%>">
				<a href="eventmain.asp?eventid=87274" target="_top"><p><span>06.18<strong>멜로비</strong></span></p></a>
			</li>
			<% End If %>

		</ul>
	</div>
</div>