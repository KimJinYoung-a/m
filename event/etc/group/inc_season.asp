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
	If vEventID = "114969" Then '// 7월
		vStartNo = "0"
	ElseIf vEventID = "115372" Then '// 8월
		vStartNo = "1"
	ElseIf vEventID = "115996" Then '// 9월
		vStartNo = "2"
	ElseIf vEventID = "116531" Then '// 10월
		vStartNo = "3"
	ElseIf vEventID = "" Then '// 11월
		vStartNo = "4"
	ElseIf vEventID = "" Then '// 12월
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
			<% if currentdate < "2021-11-15" then %>
			<li class="swiper-slide"><span>Vol.1</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="114969"," current","")%>"><a href="<%=eventUrl%>=114969">Vol.1</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-12-13" then %>
			<li class="swiper-slide"><span>Vol.2</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="115372"," current","")%>"><a href="<%=eventUrl%>=115372">Vol.2</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-01-04" then %>
			<li class="swiper-slide"><span>Vol.3</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="115996"," current","")%>"><a href="<%=eventUrl%>=115996">Vol.3</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-02-15" then %>
			<li class="swiper-slide"><span>Vol.4</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="116531"," current","")%>"><a href="<%=eventUrl%>=116531">Vol.4</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-09-05" then %>
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