<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2018-11-28"
	'response.write currentdate

	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)

	If vEventID = "93203" Then '// vol.1
		vStartNo = "0"
	ElseIf vEventID = "93528" Then '// vol.2
		vStartNo = "0"
	ElseIf vEventID = "93789" Then '// vol.3
		vStartNo = "1"
	ElseIf vEventID = "94554" Then '// vol.4
		vStartNo = "2"
	ElseIf vEventID = "95259" Then '// vol.5
		vStartNo = "3"
	ElseIf vEventID = "103012" Then '// vol.6
		vStartNo = "4"
	else
		vStartNo = "0"
	End IF

	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
.monthTab {position:relative; background:#fff;}
.monthTab .swiper-container {padding-left:1.5rem;}
.monthTab ul {margin:0 auto; z-index:96;}
.monthTab li {float:left; width: 36%; height:50.4vw;}
.monthTab li a, .monthTab li span {display:block; position:relative;}
.monthTab li.current a img {margin-top:-162%;}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.monthTab .swiper-container', {
		initialSlide:<%=vStartNo%>,
		slidesPerView:'auto',
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
		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
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
			<%' 오픈된 페이지 open, 현재 보고있는 페이지에 current 클래스 넣어주세요 %>
			
			<% if currentdate < "2019-03-12" then %>
			<li class="swiper-slide coming">
				<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/93528/m/btn_navi_01.jpg" alt=""></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="93203"," current","")%>">
				<a href="" onclick="goEventLink('93203'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93528/m/btn_navi_01.jpg" alt=""></a>
			<% End If %>
			</li>

			<% if currentdate < "2019-03-27" then %>
			<li class="swiper-slide coming">
				<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/93528/m/btn_navi_02.jpg" alt=""></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="93528"," current","")%>">
				<a href="" onclick="goEventLink('93528'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93528/m/btn_navi_02.jpg" alt=""></a>
			<% End If %>
			</li>

			<% if currentdate < "2019-04-10" then %>
			<li class="swiper-slide coming">
				<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/93789/m/btn_navi_03.jpg" alt=""></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="93789"," current","")%>">
				<a href="" onclick="goEventLink('93789'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93789/m/btn_navi_03.jpg" alt=""></a>
			<% End If %>
			</li>

			<% if currentdate < "2019-05-21" then %>
			<li class="swiper-slide coming">
				<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/93789/m/btn_navi_04.png" alt=""></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="94554"," current","")%>">
				<a href="" onclick="goEventLink('94554'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94554/m/btn_navi_04.jpg" alt=""></a>
			<% End If %>
			</li>

			<% if currentdate < "2019-06-19" then %>
			<li class="swiper-slide coming">
				<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94554/m/btn_navi_05.jpg" alt=""></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="95259"," current","")%>">
				<a href="" onclick="goEventLink('95259'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95259/m/btn_navi_05.jpg" alt=""></a>
			<% End If %>
			</li>

			<% if currentdate < "2020-05-26" then %>
			<li class="swiper-slide coming">
				<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/95259/m/btn_navi_06.jpg" alt=""></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="103012"," current","")%>">
				<a href="" onclick="goEventLink('103012'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103012/m/btn_navi_06.jpg" alt=""></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-05-28" then %>
			<li class="swiper-slide coming">
				<span><img src="//webimage.10x10.co.kr/fixevent/event/2020/103012/m/btn_navi_07.jpg" alt=""></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="000000"," current","")%>">
				<a href="" onclick="goEventLink('000000'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/000000/m/btn_navi_06.jpg" alt=""></a>
			<% End If %>
			</li>

		</ul>
	</div>
</div>
</body>
</html>