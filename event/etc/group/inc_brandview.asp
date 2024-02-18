<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2019-10-01"
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
	If vEventID = "101636" Then '//4월
		vStartNo = "0"
	ElseIf vEventID = "102755" Then '// 5월
		vStartNo = "0"
	ElseIf vEventID = "103741" Then '// 6월
		vStartNo = "1"
	ElseIf vEventID = "00000" Then '// 7월
		vStartNo = "2"
	ElseIf vEventID = "00000" Then '// 8월
		vStartNo = "3"
	End If
%>
<style type="text/css">
.navigator {position:relative; background-color:#fff;}
.navigator .swiper-wrapper {display:flex;}
.navigator .swiper-slide {display:table; width:8.5rem; height:5.12em; color:#888; font-size:1.1rem; text-align:center;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:table-cell; width:100%; height:100%; padding-top:.2rem; line-height:1.3; vertical-align:middle;}
.navigator .swiper-slide.current a {color:#000; border-bottom:.17rem solid #000; font-family:'CoreSansCBold','NotoSansKRBold';}
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

			<% if currentdate < "2020-03-27" then %>
			<li class="swiper-slide"><span>2020.4</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="101636"," current","")%>"><a href="eventmain.asp?eventid=101636">2020.4<br>봄소리</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-05-18" then %>
			<li class="swiper-slide"><span>2020.5</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="102755"," current","")%>"><a href="eventmain.asp?eventid=102755">2020.5<br>여름준비</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-06-23" then %>
			<li class="swiper-slide"><span>2020.6</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="103741"," current","")%>"><a href="eventmain.asp?eventid=103741">2020.6<br>시원한 창</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-01-01" then %>
			<li class="swiper-slide"><span>2020.7</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="eventmain.asp?eventid=00000">2020.7</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-01-01" then %>
			<li class="swiper-slide"><span>2020.8</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="eventmain.asp?eventid=00000">2020.8</a>
			<% End If %>
			</li>
		</ul>
	</div>
</div>