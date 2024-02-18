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
	If vEventID = "78570" Then '// 1차
		vStartNo = "0"
	ElseIf vEventID = "78835" Then '// 2차
		vStartNo = "0"
	ElseIf vEventID = "79187" Then '// 3차
		vStartNo = "1"
	ElseIf vEventID = "80104" Then '// 4차
		vStartNo = "3"
	ElseIf vEventID = "81514" Then '// 5차
		vStartNo = "4"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.navigator {background-color:#333; }
.navigator .swiper-slide {position:relative; width:29.33%; height:4.86rem;}
.navigator a,
.navigator span {display:block; position:relative; height:100%; padding-top:1.71rem; color:#fff; font-size:1.37rem; text-align:center;}
.navigator .on {background-color:#f2f2f4; color:#333; font-family:'AvenirNext-DemiBold'; font-weight:bold;}
.navigator .on:after {content:' '; position:absolute; top:50%; left:50%; width:2.82rem; height:0.26rem; margin:-0.2rem 0 0 -1.41rem; background-color:#4469d2;}
.navigator .swiper-slide:before {content:' '; position:absolute; z-index:10; top:50%; left:-1px; width:1px; height:2.39rem; margin-top:-1.19rem; background-color:#fff;}
.navigator .swiper-slide:first-child:before {display:none;}
.navigator span {color:#888;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="eventmain.asp?eventid=78570" <%=CHKIIF(vEventID="78570"," class='on'","")%>>01</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=78835" <%=CHKIIF(vEventID="78835"," class='on'","")%>>02</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=79187" <%=CHKIIF(vEventID="79187"," class='on'","")%>>03</a></li>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=80104" <%=CHKIIF(vEventID="80104"," class='on'","")%>>04</a></li>
			<% if currentdate < "2017-11-23" then %>
			<li class="swiper-slide"><span>05</span></li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81514" <%=CHKIIF(vEventID="81514"," class='on'","")%>>05</a></li>
			<% End If %>
		</ul>
	</div>
</div>