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
	If vEventID = "79155" Then '//vol1
		vStartNo = "0"
	ElseIf vEventID = "82317" Then '// vol2
		vStartNo = "0"
	ElseIf vEventID = "000" Then '// vol3
		vStartNo = "1"
	ElseIf vEventID = "000" Then '// vol4
		vStartNo = "2"
	ElseIf vEventID = "000" Then '// vol5
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol6
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol7
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol8
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol9
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol10
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol11
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol12
		vStartNo = "3"
	ElseIf vEventID = "000" Then '// vol13
		vStartNo = "3"
	End If

%>
<style type="text/css">
.navigator {background-color:#fff;}
.navigator .swiper-slide {position:relative; width:29.86%; padding-top:.5rem; text-align:center; color:#b8b7b7 ; font:600 1.6rem/4.6rem 'AvenirNext-Regular', 'AppleSDGothicNeo-Regular', 'RobotoRegular', 'Noto Sans', sans-serif;}
.navigator .swiper-slide:after {content:' '; position:absolute; top:50%; left:0; width:1px; height:1.96rem; margin-top:-.98rem; background-color:#bababa;}
.navigator .swiper-slide:first-child:after {display:none;}
.navigator .swiper-slide a {display:block; height:100%;}
.navigator .swiper-slide a.current {font-size:1.8rem; color:#3a3a3a; border-bottom:0.43rem solid #3a3a3a;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});
	$("#navigator .swiper-slide.coming").click(function(){
		alert("Coming soon");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide"><a href="eventmain.asp?eventid=79155" <%=CHKIIF(vEventID="79155"," class='current'","")%>>vol.1</a></li>

			<% if currentdate < "2017-12-22" then %>
			<li class="swiper-slide coming">vol.2</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=82317" <%=CHKIIF(vEventID="82317"," class='current'","")%>>vol.2</a></li>
			<% End If %>

			<% if currentdate < "2018-01-00" then %>
			<li class="swiper-slide coming">vol.3</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.3</a></li>
			<% End If %>

			<% if currentdate < "2018-02-00" then %>
			<li class="swiper-slide coming">vol.4</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.4</a></li>
			<% End If %>

			<% if currentdate < "2018-03-00" then %>
			<li class="swiper-slide coming">vol.5</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.5</a></li>
			<% End If %>

			<% if currentdate < "2018-04-00" then %>
			<li class="swiper-slide coming">vol.6</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.6</a></li>
			<% End If %>

			<% if currentdate < "2018-05-00" then %>
			<li class="swiper-slide coming">vol.7</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.7</a></li>
			<% End If %>

			<% if currentdate < "2018-06-00" then %>
			<li class="swiper-slide coming">vol.8</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.8</a></li>
			<% End If %>

			<% if currentdate < "2018-07-00" then %>
			<li class="swiper-slide coming">vol.9</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.9</a></li>
			<% End If %>

			<% if currentdate < "2018-08-00" then %>
			<li class="swiper-slide coming">vol.10</li>
			<% Else %>
			<li class="swiper-slide"><a href="eventmain.asp?eventid=000" <%=CHKIIF(vEventID="000"," class='current'","")%>>vol.10</a></li>
			<% End If %>

		</ul>
	</div>
</div>