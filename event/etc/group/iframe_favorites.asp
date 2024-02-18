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

	If vEventID = "109208" Then '// vol.1 오프투얼론
		vStartNo = "0"
	ElseIf vEventID = "108094" Then '// vol.2 서촌도감
		vStartNo = "0"
	ElseIf vEventID = "108730" Then '// vol.3 미술관옆작업실
		vStartNo = "1"
	ElseIf vEventID = "109897" Then '// vol.4 핀란드프로젝트
		vStartNo = "2"
	ElseIf vEventID = "110643" Then '// vol.5 커피한잔
		vStartNo = "3"
	ElseIf vEventID = "" Then '// vol.6 마지막 브랜드
		vStartNo = "4"
	else
		vStartNo = "0"
	End IF

	If isapp = "0" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#fff;}
.monthTab {position:relative; width:100%; height:100%;}
.monthTab .swiper-container {width:88%; height:100%;}
.monthTab .swiper-container:before {content:''; position:absolute; top:0; left:0; height:100%; width:0.2rem; background-color:#fff; z-index:97;}
.monthTab .swiper-container:after {content:''; position:absolute; top:0; right:0; height:100%; width:0.2rem; background-color:#fff; z-index:97;}
.monthTab ul {display:flex; align-items:center; height:100%; margin:0 auto; z-index:96;}
.monthTab li a, 
.monthTab li span {display:block; position:relative; width:100%; height:2rem; line-height:2rem; text-align:center; font-size:1.4rem; color:#999; font-weight:500;}
.monthTab li span.txt {width:4.56rem; height:2.30rem; margin: 0 auto; background:url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/txt_nav.png) no-repeat 0 0; background-size:100%;}
.monthTab .swiper-slide.current a {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; color:#191919;}
/* .monthTab li a:after, 
.monthTab li span:after {content:''; position:absolute; right:0; height:100%; width:0.1rem; background-color:#999;} */
/* .monthTab li.current a {color:#000; font-weight:bold;} */
.monthTab button {display:block; position:absolute; top:0; z-index:20; width:7.5%; height:100%; background-color:transparent; text-indent:-999em; outline:0;}
.monthTab button:after {content:''; display:inline-block; position:absolute; top:0; width:2rem; height:100%; margin-top:0;}
.monthTab button.btnPrev {left:1.5rem;}
.monthTab button.btnPrev:after {left:0rem; background: #fff url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_left.png) no-repeat 0 50%; background-size: 0.82rem 1.60rem;}
.monthTab button.btnNext {right:1.5rem;}
.monthTab button.btnNext:after {right:0rem; background: #fff url(//webimage.10x10.co.kr/fixevent/event/2020/108094/m/icon_right.png) no-repeat right 50%; background-size: 0.82rem 1.60rem;}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.monthTab .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:4,
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
			
			<% if currentdate < "2021-02-15" then %>
			<li class="swiper-slide coming">
				<span>Vol.1</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="109208"," current","")%>">
				<a href="" onclick="goEventLink('109208'); return false;">Vol.1</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-02-24" then %>
			<li class="swiper-slide coming">
				<span class="txt"></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="108094"," current","")%>">
				<a href="" onclick="goEventLink('108094'); return false;">Vol.2</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-03-05" then %>
			<li class="swiper-slide coming">
				<span class="txt"></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="108730"," current","")%>">
				<a href="" onclick="goEventLink('108730'); return false;">Vol.3</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-04-02" then %>
			<li class="swiper-slide coming">
				<span class="txt"></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="109897"," current","")%>">
				<a href="" onclick="goEventLink('109897'); return false;">Vol.4</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-04-23" then %>
			<li class="swiper-slide coming">
				<span class="txt"></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="110643"," current","")%>">
				<a href="" onclick="goEventLink('110643'); return false;">Vol.5</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-05-02" then %>
			<li class="swiper-slide coming">
				<span class="txt"></span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID=""," current","")%>">
				<a href="" onclick="goEventLink(''); return false;">Vol.6</a>
			<% End If %>
			</li>
		</ul>
	</div>
	<button class="btnPrev">이전</button>
	<button class="btnNext">다음</button>
</div>
</body>
</html>