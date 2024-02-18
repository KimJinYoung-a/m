<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2017-11-17"
	
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
	If vEventID = "82559" Then
		vStartNo = "0"
	ElseIf vEventID = "82825" Then
		vStartNo = "0"
	ElseIf vEventID = "83060" Then
		vStartNo = "0"
	ElseIf vEventID = "83514" Then
		vStartNo = "1"
	ElseIf vEventID = "00000" Then
		vStartNo = "0"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.navigator .swiper-container {padding:0 2.56rem;}
.navigator .swiper-slide:after,
.navigator .on:after,
.navigator .btn-nav:after {content:' '; position:absolute;}
.navigator .swiper-slide {width:33.333%; text-align:center;}
.navigator .swiper-slide:after {top:50%; left:0; width:1px; height:2.65rem; margin-top:-1.325rem; background-color:#ccc;}
.navigator .swiper-slide:first-child:after {display:none;}
.navigator a, .navigator .coming {display:block; width:100%; height:5rem; color:#ccc; font-size:1.37rem; line-height:1.62rem; font-weight:bold; vertical-align:middle;}
.navigator a {position:relative; padding-top:1.13rem;}
.navigator a span {font-weight:normal;}
.navigator .coming {padding-top:1.9rem;}
.navigator .on {color:#000;}
.navigator .on:after {bottom:0; left:0; width:100%; height:2px; background-color:currentColor;}
.navigator .btn-nav {position:absolute; top:0; z-index:10; width:2.56rem; height:5rem; background-color:#fff; color:transparent;}
.navigator .btn-prev {left:0;}
.navigator .btn-nav:after {top:50%; left:50%; width:0; height:0; border-style:solid; border-width:0.43rem 0.43rem 0.43rem 0; margin:-0.43rem 0 0 -0.21rem; border-color:transparent #000 transparent transparent;}
.navigator .btn-next {right:0;}
.navigator .btn-next:after {-webkit-transform:rotate(-180deg); transform:rotate(-180deg);}
</style>
<script type="text/javascript">
$(function(){
	if ($("#navigator .swiper-container .swiper-slide").length > 3) {
		navigatorSwiper = new Swiper("#navigator .swiper-container",{
			initialSlide:<%=vStartNo%>,
			slidesPerView:"auto",
			nextButton:"#navigator .btn-next",
			prevButton:"#navigator .btn-prev",
		});
	} else {
		$("#navigator .btn-nav").hide();
	}

	$("#navigator .swiper-slide .coming").click(function(){
		alert("coming soon");
	});
});
</script>
<nav id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82559" <%=CHKIIF(vEventID="82559"," class='on'","")%>>1st<br /> <span>from 529</span></a></li>

			<% if currentdate < "2017-12-08" then %>
			<li class="swiper-slide"><span class="coming">2nd</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82825" <%=CHKIIF(vEventID="82825"," class='on'","")%>>2nd<br /> <span>초은</span></a></li>
			<% End If %>

			<% if currentdate < "2017-12-08" then %>
			<li class="swiper-slide"><span class="coming">3rd</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=83060" <%=CHKIIF(vEventID="83060"," class='on'","")%>>3rd<br /> <span>밀키웨이</span></a></li>
			<% End If %>

			<% if currentdate < "2018-01-10" then %>
			<li class="swiper-slide"><span class="coming">4rd</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=83514" <%=CHKIIF(vEventID="83514"," class='on'","")%>>4rd<br /> <span style="font-size:1.2rem;">heeeunlee</span></a></li>
			<% End If %>

			<li class="swiper-slide"><span class="coming">5th</span></li>
			<li class="swiper-slide"><span class="coming">6th</span></li>
		</ul>
	</div>
	<button type="button" class="btn-nav btn-prev">이전</button>
	<button type="button" class="btn-nav btn-next">다음</button>
</nav>