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
	If vEventID = "112289" Then '//7월
		vStartNo = "0"
	ElseIf vEventID = "112830" Then '// 8월
		vStartNo = "0"
	ElseIf vEventID = "113538" Then '// 9월
		vStartNo = "1"
	ElseIf vEventID = "114069" Then '// 10월
		vStartNo = "2"
	ElseIf vEventID = "114705" Then '// 11월
		vStartNo = "3"
	ElseIf vEventID = "115302" Then '// 10월
		vStartNo = "4"
	ElseIf vEventID = "116003" Then '// 10월
		vStartNo = "5"
	ElseIf vEventID = "116529" Then '// 10월
		vStartNo = "6"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#fff;}
.monthTab {position:relative; padding-bottom:1.47vw; background-color:#fff;}
.monthTab .swiper-container {padding:0 9.87%;}
.monthTab .swiper-slide {width:21.5%; height:15.2vw; text-align:center; color:#c3c3c3; font-size:4vw; line-height:16vw; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.monthTab .swiper-slide em {display:none;}
.monthTab .swiper-slide.current {width:57%; color:#393939;}
.monthTab .swiper-slide.current p {display:inline; border-bottom:.4vw solid #585858;}
.monthTab .swiper-slide.current em {display:inline-block; padding-left:2vw; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular';}
.monthTab .swiper-slide a {display:block; width:100%; height:100%;}
.monthTab button {position:absolute; top:0; z-index:100; width:9.87%; height:100%; background:#fff url(//webimage.10x10.co.kr/eventIMG/2020/102974/btn_nav_m.png) 50%/100% no-repeat; font-size:0;}
.monthTab .btn-prev {left:0;}
.monthTab .btn-next {right:0; transform:rotate(180deg);}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.monthTab .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:3,
		speed:300,
		prevButton:'.monthTab .btnPrev',
		nextButton:'.monthTab .btnNext'
	});
	$('.swiper-slide.coming').on('click', function(e){
		e.preventDefault();
		alert("오픈 예정 기획전 입니다.");
	});
});

function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
</head>
<body>
<div class="monthTab">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<% if currentdate < "2021-07-01" then %>
			<li class="swiper-slide"><span>7월호<em>프릳츠&라이언커피</em></span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="112289"," current","")%>"><a href="/event/eventmain.asp?eventid=112289" target="_top"><p>7월호<em>프릳츠&라이언커피</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-08-01" then %>
			<li class="swiper-slide"><span>8월호<em>탐앤탐스&일리</em></span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="112830"," current","")%>"><a href="/event/eventmain.asp?eventid=112830" target="_top"><p>8월호<em>탐앤탐스&일리</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-09-01" then %>
			<li class="swiper-slide"><span>9월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="113538"," current","")%>"><a href="/event/eventmain.asp?eventid=113538" target="_top"><p>9월호<em>제주 마이빈스</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-10-01" then %>
			<li class="swiper-slide"><span>10월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="114069"," current","")%>"><a href="/event/eventmain.asp?eventid=114069" target="_top"><p>10월호<em>인터내셔널 로스트</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-11-01" then %>
			<li class="swiper-slide"><span>11월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="114705"," current","")%>"><a href="/event/eventmain.asp?eventid=114705" target="_top"><p>11월호<em>헬리빈</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-12-01" then %>
			<li class="swiper-slide"><span>12월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="115302"," current","")%>"><a href="/event/eventmain.asp?eventid=115302" target="_top"><p>12월호<em>핸디엄</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2022-01-01" then %>
			<li class="swiper-slide"><span>1월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="116003"," current","")%>"><a href="/event/eventmain.asp?eventid=116003" target="_top"><p>1월호<em>더네이버스</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2022-02-10" then %>
			<li class="swiper-slide"><span>2월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="116529"," current","")%>"><a href="/event/eventmain.asp?eventid=116529" target="_top"><p>2월호<em>프릳츠</em></p></a>
			<% End If %>
			</li>

			<% if currentdate < "2022-03-01" then %>
			<li class="swiper-slide"><span>3월호</span>
			<% Else %>
			<li class="swiper-slide <%=CHKIIF(vEventID="000000"," current","")%>"><a href="/event/eventmain.asp?eventid=000000" target="_top"><p>3월호<em>Coming</em></p></a>
			<% End If %>
			</li>

		</ul>
		<button type="button" class="btn-prev">이전</button>
  		<button type="button" class="btn-next">다음</button>
	</div>
</div>
</body>
</html>