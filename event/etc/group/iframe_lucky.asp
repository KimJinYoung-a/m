<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2016-11-18"
	
	'response.write currentdate

'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)

	If vEventID = "78064" Then '// 2017-05-22
		vStartNo = "0"
	ElseIf vEventID = "78073" Then '// 2017-05-23
		vStartNo = "0"
	ElseIf vEventID = "78128" Then '// 2017-05-24
		vStartNo = "1"
	ElseIf vEventID = "78070" Then '// 2017-05-25
		vStartNo = "2"
	ElseIf vEventID = "78069" Then '// 2017-05-26
		vStartNo = "3"
	ElseIf vEventID = "78072" Then '// 2017-05-27,28
		vStartNo = "4"
	ElseIf vEventID = "78074" Then '// 2017-05-29
		vStartNo = "5"
	ElseIf vEventID = "78265" Then '// 2017-05-30
		vStartNo = "6"
	ElseIf vEventID = "78129" Then '// 2017-05-31
		vStartNo = "7"
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
.luckyDay {position:relative; width:32rem; height:7rem;}
.luckyDay .swiper-container {height:4rem;}
.luckyDay .swiper-slide {position:relative; float:left; width:9.5rem; height:4rem; margin-left:0.7rem; text-align:center; color:#949393; background-color:#fff; border-radius:0.4rem;}
.luckyDay .swiper-slide:first-child {margin-left:8.4%;}
.luckyDay .swiper-slide:last-child {margin-right:2.7rem;}
.luckyDay .swiper-slide div {display:table-cell; width:9.5rem; height:4rem; padding-top:0.2rem; font-size:1.1rem; letter-spacing:-0.025em; font-weight:600; vertical-align:middle; text-align:center;}
.luckyDay .swiper-slide span {display:none; font-size:1.3rem; font-weight:bold; font-family:arial;}
.luckyDay .swiper-slide a {display:none; position:absolute; left:0; top:0; width:100%; height:100%; text-indent:-999em;}
.luckyDay .swiper-slide.current {background-color:#66b963; color:#fff;}
.luckyDay .swiper-slide.open a {display:block;}
.luckyDay .swiper-slide.soldout {background-color:#a0a0a0; color:#fff;}
.luckyDay .swiper-slide.soldout span {display:block;}
@media all and (min-width:360px){
	.luckyDay {width:36rem;}
}
@media all and (min-width:375px){
	.luckyDay {width:37.5rem;}
}
@media all and (min-width:600px){
	.luckyDay {width:60rem; height:9rem;}
}
@media all and (min-width:667px){
	.luckyDay {width:66.7rem;}
}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.luckyDay .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:'auto',
		speed:300,
		nextButton:'.luckyDay .btnNext',
		prevButton:'.luckyDay .btnPrev'
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
<div class="luckyDay">
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<%' 오픈된 페이지 open, 현재 보고있는 페이지에 current 클래스 넣어주세요 %>
			<% if currentdate < "2017-05-22" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78064"," current","")%>">
			<% End If %>
				<div>05.22 (월) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78064'); return false;">이벤트 바로가기</a>
			</div>
			
			<% if currentdate < "2017-05-23" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78073"," current","")%>">
			<% End If %>
				<div>05.23 (화) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78073'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-05-24" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78128"," current","")%>">
			<% End If %>
					<div>05.24 (수) <span>SOLD OUT</span></div>
					<a href="" onclick="goEventLink('78128'); return false;">이벤트 바로가기</a>
				</li>
			</div>

			<% if currentdate < "2017-05-25" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78070"," current","")%>">
			<% End If %>
				<div>05.25 (목)<span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78070'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-05-26" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78069"," current","")%>">
			<% End If %>
				<div>05.26 (금) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78069'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-05-27" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78072"," current","")%>">
			<% End If %>
				<div>05.27~28 (토/일) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78072'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-05-29" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78074"," current","")%>">
			<% End If %>
				<div>05.29 (월) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78074'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-05-30" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78265"," current","")%>">
			<% End If %>
				<div>05.30 (화) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78265'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-05-31" then %>
			<div class="swiper-slide">
			<% Else %>
			<div class="swiper-slide open <%=CHKIIF(vEventID="78129"," current","")%>">
			<% End If %>
				<div>05.31 (수)<span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('78129'); return false;">이벤트 바로가기</a>
			</div>
		</div>
	</div>
</div>
</body>
</html>