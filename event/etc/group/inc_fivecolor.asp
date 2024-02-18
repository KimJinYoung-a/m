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

	dim strRefer : strRefer = Request.ServerVariables("HTTP_REFERER") 
	dim eventUrl

	if instr(strRefer,"/subgnb/") > 1 then
		eventUrl = "/subgnb/gnbeventmain.asp?gnbflag=1&eventid"
	ELSEIF instr(strRefer,"/event/gnbeventmain.asp") > 1 then
		eventUrl = "gnbeventmain.asp?gnbflag=1&eventid"
	ELSE
		eventUrl = "eventmain.asp?eventid"
	END IF
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
	If vEventID = "113835" Then '// 7월
		vStartNo = "0"
	ElseIf vEventID = "114368" Then '// 8월
		vStartNo = "1"
	ElseIf vEventID = "114851" Then '// 9월
		vStartNo = "2"
	ElseIf vEventID = "115428" Then '// 10월
		vStartNo = "3"
	ElseIf vEventID = "115532" Then '// 11월
		vStartNo = "4"
	ElseIf vEventID = "116528" Then '// 12월
		vStartNo = "5"
	ElseIf vEventID = "" Then '// 1월
		vStartNo = "6"
	ElseIf vEventID = "" Then '// 2월
		vStartNo = "7"
	ElseIf vEventID = "" Then '// 3월
		vStartNo = "8"
	ElseIf vEventID = "" Then '// 4월
		vStartNo = "9"
	ElseIf vEventID = "" Then '// 5월
		vStartNo = "10"
	End If
%>
<style type="text/css">
.navigator {position:relative; background:#fff;}
.navigator .swiper-container {padding:0 8%;}
.navigator .swiper-slide {width:33.3%; height:4.78rem; color:#999; font-size:1.3rem;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:flex; justify-content:center; align-items:center; width:100%; height:100%;}
.navigator .swiper-slide a {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.navigator button {position:absolute; top:0; z-index:100; width:4.5rem; height:100%; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2020/101555/m/btn_prev.png) no-repeat center / 80%; font-size:0; color:transparent;}
.navigator .swiper-slide.current {color:#111;}
.navigator .btn-prev {left:0;}
.navigator .btn-next {right:0; transform:scaleX(-1);}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper("#navigator .swiper-container",{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		prevButton:"#navigator .btn-prev",
		nextButton:"#navigator .btn-next"
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
			<% if currentdate < "2021-09-27" then %>
			<li class="swiper-slide"><span>Sep</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="113835"," current","")%>"><a href="<%=eventUrl%>=113835">Sep</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-10-11" then %>
			<li class="swiper-slide"><span>Oct</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="114368"," current","")%>"><a href="<%=eventUrl%>=114368">Oct</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-11-15" then %>
			<li class="swiper-slide"><span>Nov</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="114851"," current","")%>"><a href="<%=eventUrl%>=114851">Nov</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-12-13" then %>
			<li class="swiper-slide"><span>Dev</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="115428"," current","")%>"><a href="<%=eventUrl%>=115428">Dev</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-01-03" then %>
			<li class="swiper-slide"><span>Jan</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="115532"," current","")%>"><a href="<%=eventUrl%>=115532">Jan</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-02-07" then %>
			<li class="swiper-slide"><span>Fab</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="116528"," current","")%>"><a href="<%=eventUrl%>=116528">Fab</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-10-05" then %>
			<li class="swiper-slide"><span>coming</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="<%=eventUrl%>=000000">coming</a>
			<% End If %>
			</li>

		</ul>
	</div>
	<button type="button" class="btn-prev">이전</button>
	<button type="button" class="btn-next">다음</button>
</div>