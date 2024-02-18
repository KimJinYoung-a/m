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
	If vEventID = "78222" Then
		vStartNo = "0"
	ElseIf vEventID = "78929" Then
		vStartNo = "0"
	ElseIf vEventID = "79726" Then
		vStartNo = "1"
	ElseIf vEventID = "80231" Then
		vStartNo = "2"
	ElseIf vEventID = "81322" Then
		vStartNo = "3"
	ElseIf vEventID = "82106" Then
		vStartNo = "4"
	ElseIf vEventID = "83054" Then
		vStartNo = "5"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.navigator {background-color:#fff;}
.navigator .swiper-slide {position:relative; width:28.43%;}
.navigator .swiper-slide:after {content:' '; position:absolute; top:50%; left:0; width:1px; height:2rem; margin-top:-1rem; background-color:#bababa;}
.navigator .swiper-slide:first-child:after {display:none;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});

	$("#navigator .swiper-slide span").click(function(){
		alert("오픈 예정입니다.");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="eventmain.asp?eventid=78222" <%=CHKIIF(vEventID="78222"," class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_06_<%=CHKIIF(vEventID="78222","on","off")%>.gif" alt="6월" /></a></li>

			<% if currentdate < "2017-07-17" then %>
			<li class="swiper-slide"><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_07_off.gif" alt="7월" /></span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=78929" <%=CHKIIF(vEventID="78929"," class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_07_<%=CHKIIF(vEventID="78929","on","off")%>.gif" alt="7월" /></a></li>
			<% End If %>

			<% if currentdate < "2017-08-14" then %>
			<li class="swiper-slide"><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_08_off.gif" alt="8월" /></span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=79726" <%=CHKIIF(vEventID="79726"," class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_08_<%=CHKIIF(vEventID="79726","on","off")%>.gif" alt="8월" /></a></li>
			<% End If %>

			<% if currentdate < "2017-09-05" then %>
			<li class="swiper-slide"><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_09_off.gif" alt="9월" /></span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=80231" <%=CHKIIF(vEventID="80231"," class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_09_<%=CHKIIF(vEventID="80231","on","off")%>.gif" alt="9월" /></a></li>
			<% End If %>

			<% if currentdate < "2017-10-23" then %>
			<li class="swiper-slide"><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_10_off.gif" alt="10월" /></span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81322" <%=CHKIIF(vEventID="81322"," class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_10_<%=CHKIIF(vEventID="81322","on","off")%>.gif" alt="10월" /></a></li>
			<% End If %>

			<% if currentdate < "2017-11-20" then %>
			<li class="swiper-slide"><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_11_off.gif" alt="11월" /></span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82106" <%=CHKIIF(vEventID="82106"," class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_11_<%=CHKIIF(vEventID="82106","on","off")%>.gif" alt="11월" /></a></li>
			<% End If %>

			<% if currentdate < "2017-12-18" then %>
			<li class="swiper-slide"><span><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_12_off.gif" alt="12월" /></span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=83054" <%=CHKIIF(vEventID="83054"," class='on'","")%>><img src="http://webimage.10x10.co.kr/eventIMG/2017/78222/m/img_nav_month_12_<%=CHKIIF(vEventID="83054","on","off")%>.gif" alt="12월" /></a></li>
			<% End If %>

		</ul>
	</div>
</div>