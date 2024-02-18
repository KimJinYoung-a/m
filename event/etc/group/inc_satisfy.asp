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
	If vEventID = "97475" Then '//10월
		vStartNo = "0"
	ElseIf vEventID = "97927" Then '// 11월
		vStartNo = "0"
	ElseIf vEventID = "98890" Then '// 12월
		vStartNo = "0"
	ElseIf vEventID = "99782" Then '// 1월
		vStartNo = "1"
	ElseIf vEventID = "100368" Then '// 2월
		vStartNo = "2"
	ElseIf vEventID = "100920" Then '// 3월
		vStartNo = "3"
	ElseIf vEventID = "" Then '// 4월
		vStartNo = "4"
	ElseIf vEventID = "" Then '// 5월
		vStartNo = "5"
	ElseIf vEventID = "" Then '// 6월
		vStartNo = "6"
	ElseIf vEventID = "" Then '// 7월
		vStartNo = "7"
	ElseIf vEventID = "" Then '// 8월
		vStartNo = "8"
	ElseIf vEventID = "" Then '// 9월
		vStartNo = "9"
	End If
%>
<style type="text/css">
.navigator {background:#fff;}
.navigator .swiper-slide {height:4.69rem; position:relative; width:29%; text-align:center; color:#999; font-size:.94rem; line-height:normal;}
.navigator .swiper-slide a {display:flex; justify-content:center; align-items:center; width:100%; height:100%; flex-direction:column;}
.navigator .swiper-slide a strong {overflow:hidden; max-width:100%; white-space:nowrap; text-overflow:ellipsis;}
.navigator .current {color:#3a3a3a; border-bottom:0.17rem solid #000;}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});
	$('.swiper-slide a.coming').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다 :)");
	});
});
</script>
<div id="navigator" class="navigator">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<% if currentdate < "2019-10-01" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide<%=CHKIIF(vEventID="97475"," current","")%>">
			<% End If %>
				<a href="eventmain.asp?eventid=97475">#10월호<strong>다독多讀</strong></a>
			</li>

			<% if currentdate < "2019-11-01" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="97927"," current","")%>">
			<% End If %>
				<a href="eventmain.asp?eventid=97927">#11월호<strong>깊은 잠</strong></a>
			</li>

			<% if currentdate < "2019-12-02" then %>
			<li class="swiper-slide"><a href="" onclick="return false;" class="coming">#12월호</a></li>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="98890"," current","")%>">
				<a href="eventmain.asp?eventid=98890">#12월호<strong>Winter 'Home'liday</strong></a>
			</li>
			<% End If %>

			<% if currentdate < "2020-01-02" then %>
			<li class="swiper-slide"><a href="" onclick="return false;" class="coming">#1월호</a></li>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="99782"," current","")%>">
				<a href="eventmain.asp?eventid=99782">#1월호<strong>새해 목표</strong></a>
			</li>
			<% End If %>

			<% if currentdate < "2020-02-04" then %>
			<li class="swiper-slide"><a href="" onclick="return false;" class="coming">#2월호</a></li>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="100368"," current","")%>">
				<a href="eventmain.asp?eventid=100368">#2월호<strong>새해 새집 새방</strong></a>
			</li>
			<% End If %>

			<% if currentdate < "2020-03-03" then %>
			<li class="swiper-slide"><a href="" onclick="return false;" class="coming">#3월호</a></li>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="100920"," current","")%>">
				<a href="eventmain.asp?eventid=100920">#3월호<strong>집 밖은 위험해</strong></a>
			</li>
			<% End If %>

			<% if currentdate < "2020-12-31" then %>
			<li class="swiper-slide"><a href="" onclick="return false;" class="coming">#4월호</a></li>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>">
				<a href="eventmain.asp?eventid=000000">#4월호</a>
			</li>
			<% End If %>

		</ul>
	</div>
</div>