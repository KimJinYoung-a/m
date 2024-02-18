<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()

'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)

	If vEventID = "78570" Then '// 1차
		vStartNo = "0"
	ElseIf vEventID = "78835" Then '// 2차
		vStartNo = "0"
	ElseIf vEventID = "79187" Then '// 3차
		vStartNo = "1"
	ElseIf vEventID = "00000" Then '// 4차
		vStartNo = "1"
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
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#333;}
.careSeries {position:relative; width:100%; height:100%;}
.careSeries .swiper-container,.careSeries .swiper-wrapper {height:100%;}
.careSeries li {position:relative; width:28.43%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/78835/m/txt_nav_default.png) no-repeat 0 0; background-size:auto 100%;}
.careSeries li:after {content:''; display:inline-block; position:absolute; right:0; top:30%; width:1px; height:40%; background-color:#4a4a4a;}
.careSeries li:last-child:after,.careSeries li.current:after {display:none;}
.careSeries li.open {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/78835/m/txt_nav.png);}
.careSeries li.current {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/78835/m/txt_nav_on.png);}
.careSeries li.season2 {background-position:33.3% 0;}
.careSeries li.season3 {background-position:66.6% 0;}
.careSeries li.season4 {background-position:100% 0;}
.careSeries li span {display:block; position:relative; height:100%; color:transparent;}
.careSeries li a {display:none; position:absolute; left:0; right:0; top:0; height:8rem; background:transparent;}
.careSeries li.open a {display:block;}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.careSeries .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:'auto'
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
<div class="careSeries">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<%' 오픈된 페이지 open, 현재 보고있는 페이지에 current 클래스 넣어주세요 %>
			<% if currentdate < "2017-06-19" then %>
			<li class="season1 swiper-slide">
			<% Else %>
			<li class="season1 swiper-slide open <%=CHKIIF(vEventID="78570"," current","")%>">
			<% End If %>
				<span><a href="" onclick="goEventLink('78570'); return false;">01.Cooling</a></span>
			</li>

			<% if currentdate < "2017-07-06" then %>
			<li class="season2 swiper-slide">
			<% Else %>
			<li class="season2 swiper-slide open <%=CHKIIF(vEventID="78835"," current","")%>">
			<% End If %>
				<span><a href="" onclick="goEventLink('78835'); return false;">02. Rainy season</a></span>
			</li>

			<% if currentdate < "2017-07-13" then %>
			<li class="season3 swiper-slide">
			<% Else %>
			<li class="season3 swiper-slide open <%=CHKIIF(vEventID="79187"," current","")%>">
			<% End If %>
				<span><a href="" onclick="goEventLink('79187'); return false;">03. Body</a></span>
			</li>

			<% if currentdate < "2018-06-19" then %>
			<li class="season4 swiper-slide">
			<% Else %>
			<li class="season4 swiper-slide open <%=CHKIIF(vEventID="99999"," current","")%>">
			<% End If %>
				<span><a href="" onclick="goEventLink('99999'); return false;">04.</a></span>
			</li>
		</ul>
	</div>
</div>
</body>
</html>