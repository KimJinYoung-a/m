<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2020-03-26"
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
	If vEventID = "102526" Then '// vol1
		vStartNo = "0"
	ElseIf vEventID = "103179" Then '// vol2
		vStartNo = "1"
	ElseIf vEventID = "00000" Then '// vol3
		vStartNo = "2"
	ElseIf vEventID = "00000" Then '// vol4
		vStartNo = "3"
	End If
%>
<style type="text/css">
.navigator {position:relative;}
.navigator .swiper-container {position:absolute; left:0; top:33%; width:100%; padding:0 5.7%;}
.navigator .swiper-wrapper {display:flex;}
.navigator .swiper-slide {width:49%; padding:0 1.7%;}
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
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tit_daccu.png" alt="다꾸생활백서 모음"></p>
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<li class="swiper-slide <%=CHKIIF(vEventID="102526"," current","")%>"><a href="eventmain.asp?eventid=102526"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tab_vol1.png" alt="vol1.메모지"></a>
			</li>

			<% if currentdate < "2020-06-10" then %>
			<li class="swiper-slide"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tab_coming_vol2.png" alt="vol2"></span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="103179"," current","")%>"><a href="eventmain.asp?eventid=103179"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tab_vol2.png" alt="vol2"></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-04-29" then %>
			<li class="swiper-slide"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tab_coming_vol3.png" alt="vol3"></span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="eventmain.asp?eventid=102167"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tab_vol3.png" alt="vol3"></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-01-01" then %>
			<li class="swiper-slide"><span><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tab_coming_vol4.png" alt="vol4"></span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="eventmain.asp?eventid=00000"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102526/m/tab_vol4.png" alt="vol4"></a>
			<% End If %>
			</li>

		</ul>
	</div>
</div>