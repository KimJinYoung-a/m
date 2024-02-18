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
	If vEventID = "100700" Then '// Vol.1
		vStartNo = "0"
	ElseIf vEventID = "101555" Then '// Vol.2
		vStartNo = "0"
	ElseIf vEventID = "102167" Then '// Vol.3
		vStartNo = "0"
	ElseIf vEventID = "102819" Then '// Vol.4
		vStartNo = "0"
	ElseIf vEventID = "103595" Then '// Vol.5
		vStartNo = "0"
	ElseIf vEventID = "104545" Then '// Vol.6
		vStartNo = "1"
	ElseIf vEventID = "105287" Then '// Vol.7
		vStartNo = "2"
	ElseIf vEventID = "106064" Then '// Vol.8
		vStartNo = "3"
	ElseIf vEventID = "106907" Then '// Vol.9
		vStartNo = "4"
	ElseIf vEventID = "107793" Then '// Vol.10
		vStartNo = "5"
	ElseIf vEventID = "" Then '// Vol.11
		vStartNo = "6"
	End If
%>
<style type="text/css">
.navigator {position:relative; background-color:#fff;}
.navigator .swiper-container {padding:0 5rem;}
.navigator .swiper-slide {width:20%; height:4.78rem; color:#909090; font-size:1.36rem;}
.navigator .swiper-slide span,
.navigator .swiper-slide a {display:flex; justify-content:center; align-items:center; width:100%; height:100%;}
.navigator .swiper-slide a { font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.navigator button {position:absolute; top:0; z-index:100; width:5rem; height:100%; background-color:transparent; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/101555/m/btn_prev.png); background-size:100% 100%; background-repeat:no-repeat; font-size:0;}
.navigator .swiper-slide.current {color:#484848;}
.navigator .btn-prev {left:0;}
.navigator .btn-next {right:0; transform:rotate(180deg);}
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
			<% if currentdate < "2020-02-19" then %>
			<li class="swiper-slide"><span>Vol.1</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="100700"," current","")%>"><a href="<%=eventUrl%>=100700">Vol.1</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-03-26" then %>
			<li class="swiper-slide"><span>Vol.2</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="101555"," current","")%>"><a href="<%=eventUrl%>=101555">Vol.2</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-04-29" then %>
			<li class="swiper-slide"><span>Vol.3</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="102167"," current","")%>"><a href="<%=eventUrl%>=102167">Vol.3</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-05-26" then %>
			<li class="swiper-slide"><span>Vol.4</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="102819"," current","")%>"><a href="<%=eventUrl%>=102819">Vol.4</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-07-01" then %>
			<li class="swiper-slide"><span>Vol.5</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="103595"," current","")%>"><a href="<%=eventUrl%>=103595">Vol.5</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-08-03" then %>
			<li class="swiper-slide"><span>Vol.6</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="104545"," current","")%>"><a href="<%=eventUrl%>=104545">Vol.6</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-09-02" then %>
			<li class="swiper-slide"><span>Vol.7</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="105287"," current","")%>"><a href="<%=eventUrl%>=105287">Vol.7</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-10-05" then %>
			<li class="swiper-slide"><span>Vol.8</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="106064"," current","")%>"><a href="<%=eventUrl%>=106064">Vol.8</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-11-03" then %>
			<li class="swiper-slide"><span>Vol.9</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="106907"," current","")%>"><a href="<%=eventUrl%>=106907">Vol.9</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-12-01" then %>
			<li class="swiper-slide"><span>Vol.10</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="107793"," current","")%>"><a href="<%=eventUrl%>=107793">Vol.10</a>
			<% End If %>
			</li>
		</ul>
	</div>
	<button type="button" class="btn-prev">이전</button>
	<button type="button" class="btn-next">다음</button>
</div>