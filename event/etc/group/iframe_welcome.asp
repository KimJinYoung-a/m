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

	If vEventID = "114127" Then '// 12월
		vStartNo = "0"
	ElseIf vEventID = "000000" Then '// 1월
		vStartNo = "0"
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
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#fff;}
.monthTab {position:relative; width:100%;}
.monthTab .swiper-container {width:88%; padding-top:1.5rem;}
.monthTab .swiper-container:before {content:''; position:absolute; top:0; left:0; height:100%; width:0.2rem; background-color:#fff; z-index:97;}
.monthTab .swiper-container:after {content:''; position:absolute; top:0; right:0; height:100%; width:0.2rem; background-color:#fff; z-index:97;}
.monthTab ul {margin:0 auto; z-index:96;}
.monthTab li {float:left;}
.monthTab li a, .monthTab li span {display:block; position:relative; width:100%; height:2rem; line-height:2rem; text-align:center; font-size:1.4em; color:#999; font-weight:500;}
.monthTab li.current a {color:#333; font-weight:bold;font-size:1.8rem;}
.monthTab button {display:block; position:absolute; top:-0.3rem; z-index:20; width:7.5%; height:4.85rem; background-color:transparent; text-indent:-999em; outline:0;}
.monthTab button:after {content:''; display:inline-block; position:absolute; top:50%; width:0; height:0; margin-top:-0.25rem; border-style: solid; border-width:0.5rem 0.6rem 0.5rem 0;border-color:transparent #252525 transparent transparent;}

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
			
			<% if currentdate < "2021-09-28" then %>
			<li class="swiper-slide coming">
				<span>스폰지밥</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="114127"," current","")%>">
				<a href="" onclick="goEventLink('114127'); return false;">스폰지밥</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-10-31" then %>
			<li class="swiper-slide coming">
				<span></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="000000"," current","")%>">
				<a href="" onclick="goEventLink('000000'); return false;"></a>
			<% End If %>
			</li>

			<% if currentdate < "2021-10-31" then %>
			<li class="swiper-slide coming">
				<span>what's next?</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="000000"," current","")%>">
				<a href="" onclick="goEventLink('000000'); return false;">what's next?</a>
			<% End If %>
			</li>

		</ul>
	</div>
</div>
</body>
</html>