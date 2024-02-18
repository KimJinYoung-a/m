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
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "81998" Then
		vStartNo = "0"
	ElseIf vEventID = "82060" Then
		vStartNo = "0"
	ElseIf vEventID = "81950" Then
		vStartNo = "1"
	ElseIf vEventID = "81951" Then
		vStartNo = "2"
	ElseIf vEventID = "82182" Then
		vStartNo = "3"
	ElseIf vEventID = "81971" Then
		vStartNo = "4"
	ElseIf vEventID = "82201" Then
		vStartNo = "5"
	ElseIf vEventID = "81990" Then
		vStartNo = "6"
	ElseIf vEventID = "82199" Then
		vStartNo = "7"
	ElseIf vEventID = "81989" Then
		vStartNo = "8"
	ElseIf vEventID = "82484" Then
		vStartNo = "9"
	ElseIf vEventID = "82501" Then
		vStartNo = "10"
	ElseIf vEventID = "82630" Then
		vStartNo = "11"
	ElseIf vEventID = "82292" Then
		vStartNo = "11"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.navigator .swiper-container {padding:0 2.09rem 0 2.35rem;}
.navigator a, .navigator span {display:-webkit-flex; display:flex; justify-content:center; flex-direction:column; width:8.62rem; height:3.8rem; margin-right:0.26rem; border-radius:0.34rem; color:#fff; font-size:1.19rem; line-height:1.37rem; text-align:center; vertical-align:middle;}
.navigator a {background-color:#73514e;}
.navigator span {background-color:#a6817f;}
.navigator .on {background-color:#fb3e32;}
</style>
<script type="text/javascript">
$(function(){
	navigatorSwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});

	$("#navigator .swiper-slide span").click(function(){
		alert("coming soon");
	});
});
</script>
<nav id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81998" <%=CHKIIF(vEventID="81998"," class='on'","")%>>11.13 (월)</a></li>
			<% if currentdate < "2017-11-14" then %>
			<li class="swiper-slide"><span>11.14 (화)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82060" <%=CHKIIF(vEventID="82060"," class='on'","")%>>11.14 (화)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-15" then %>
			<li class="swiper-slide"><span>11.15 (수)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81950" <%=CHKIIF(vEventID="81950"," class='on'","")%>>11.15 (수)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-16" then %>
			<li class="swiper-slide"><span>11.16 (목)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81951" <%=CHKIIF(vEventID="81951"," class='on'","")%>>11.16 (목)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-17" then %>
			<li class="swiper-slide"><span>11.17 (금)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82182" <%=CHKIIF(vEventID="82182"," class='on'","")%>>11.17 (금)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-20" then %>
			<li class="swiper-slide"><span>11.20 (월)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81971" <%=CHKIIF(vEventID="81971"," class='on'","")%>>11.20 (월)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-21" then %>
			<li class="swiper-slide"><span>11.21 (화)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82201" <%=CHKIIF(vEventID="82201"," class='on'","")%>>11.21 (화)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-22" then %>
			<li class="swiper-slide"><span>11.22 (수)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81990" <%=CHKIIF(vEventID="81990"," class='on'","")%>>11.22 (수)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-23" then %>
			<li class="swiper-slide"><span>11.23 (목)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82199" <%=CHKIIF(vEventID="82199"," class='on'","")%>>11.23 (목)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-24" then %>
			<li class="swiper-slide"><span>11.24 (금)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81989" <%=CHKIIF(vEventID="81989"," class='on'","")%>>11.24 (금)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-28" then %>
			<li class="swiper-slide"><span>11.28 (화)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82484" <%=CHKIIF(vEventID="82484"," class='on'","")%>>11.28 (화)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-29" then %>
			<li class="swiper-slide"><span>11.29 (수)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82501" <%=CHKIIF(vEventID="82501"," class='on'","")%>>11.29 (수)</a></li>
			<% End If %>

			<% if currentdate < "2017-11-30" then %>
			<li class="swiper-slide"><span>11.30 (목)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82630" <%=CHKIIF(vEventID="82630"," class='on'","")%>>11.30 (목)</a></li>
			<% End If %>

			<% if currentdate < "2017-12-04" then %>
			<li class="swiper-slide"><span>12.04 (월)</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82292" <%=CHKIIF(vEventID="82292"," class='on'","")%>>12.04 (월)</a></li>
			<% End If %>

			<!--li class="swiper-slide"><a href="">SOLD OUT<br /> 11.15 (수)</a></li-->
		</ul>
	</div>
</nav>