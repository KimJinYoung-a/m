<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	' currentdate = "2020-03-26"
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
	If vEventID = "102724" Then '//5월
		vStartNo = "0"
	ElseIf vEventID = "103824" Then '// 7월
		vStartNo = "0"
	ElseIf vEventID = "104729" Then '// 8월
		vStartNo = "0"
	ElseIf vEventID = "106273" Then '// 9월
		vStartNo = "0"
	ElseIf vEventID = "106986" Then '// 10월
		vStartNo = "1"
	ElseIf vEventID = "" Then '// 11월
		vStartNo = "2"
	ElseIf vEventID = "" Then '// 12월
		vStartNo = "3"
	ElseIf vEventID = "" Then '// 1월
		vStartNo = "4"
	ElseIf vEventID = "" Then '// 2월
		vStartNo = "5"
	ElseIf vEventID = "" Then '// 3월
		vStartNo = "6"
	End If
%>
<style type="text/css">
.navigator {position:relative; background-color:#fff;}
.navigator .swiper-wrapper {display:flex;}
.navigator .swiper-slide {width:21.33%; height:5.54rem; color:#888888; font-size:1.28rem;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:flex; justify-content:center; align-items:center; width:100%; height:100%;}
.navigator .swiper-slide a {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.navigator .swiper-slide.current {border-bottom:solid .67vw #000; color:#000;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});
	$('.swiper-slide span').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">

			<% if currentdate < "2020-06-25" then %>
			<li class="swiper-slide"><span>7월</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="103824"," current","")%>"><a href="eventmain.asp?eventid=103824">7월</a>
			<% End If %>

			<% if currentdate < "2020-07-29" then %>
			<li class="swiper-slide"><span>8월</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="104729"," current","")%>"><a href="eventmain.asp?eventid=104729">8월</a>
			<% End If %>

			<% if currentdate < "2020-09-24" then %>
			<li class="swiper-slide"><span>9월</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="106273"," current","")%>"><a href="eventmain.asp?eventid=106273">9월</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-10-27" then %>
			<li class="swiper-slide"><span>10월</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="106986"," current","")%>"><a href="eventmain.asp?eventid=106986">10월</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-01-01" then %>
			<li class="swiper-slide"><span>11월</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="eventmain.asp?eventid=00000">11월</a>
			<% End If %>
			</li>
		</ul>
	</div>
</div>