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
	If vEventID = "81442" Then
		vStartNo = "0"
	ElseIf vEventID = "82284" Then '// 11월
		vStartNo = "0"
	ElseIf vEventID = "82895" Then '// 12월
		vStartNo = "1"
	ElseIf vEventID = "000" Then '// 01월
		vStartNo = "2"
	ElseIf vEventID = "000" Then '// 02월
		vStartNo = "3"
	End If

%>
<style type="text/css">

.navigator {background-color:#fff;}
.navigator .swiper-slide {position:relative; width:25.33%; padding-top:.5rem; text-align:center; color:#d3d3d3; font:600 1.2rem/4rem 'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}
.navigator .swiper-slide:after {content:' '; position:absolute; top:50%; left:0; width:1px; height:1.8rem; margin-top:-.9rem; background-color:#bababa;}
.navigator .swiper-slide:first-child:after {display:none;}
.navigator .swiper-slide a {display:block; height:100%;}
.navigator .swiper-slide a.current { color:#3a3a3a; border-bottom:0.3rem solid #3a3a3a;}
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
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81442" <%=CHKIIF(vEventID="81442"," class='current'","")%>>10月</a></li>

			<% if currentdate < "2017-11-23" then %>
			<li class="swiper-slide">11月</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82284" <%=CHKIIF(vEventID="82284"," class='current'","")%>>11月</a></li>
			<% End If %>

			<% if currentdate < "2017-12-14" then %>
			<li class="swiper-slide">12月</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82895" <%=CHKIIF(vEventID="82895"," class='current'","")%>>12月</a></li>
			<% End If %>

			<% if currentdate < "2018-01-00" then %>
			<li class="swiper-slide">1月</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>1月</a></li>
			<% End If %>

			<% if currentdate < "2018-02-00" then %>
			<li class="swiper-slide">2月</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>2月</a></li>
			<% End If %>

			<% if currentdate < "2018-03-00" then %>
			<li class="swiper-slide">3月</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=81322" <%=CHKIIF(vEventID="81322"," class='on'","")%>>3月</a></li>
			<% End If %>

		</ul>
	</div>
</div>