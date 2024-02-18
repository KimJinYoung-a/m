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

'		initialSlide:vStartNo, // 23일~29일:7, 30일~2월5일:14, 2월6일~2월12일:21
	If vEventID = "75710" Then '// 2017-01-16
		vStartNo = "0"
	ElseIf vEventID = "75758" Then '// 2017-01-17
		vStartNo = "0"
	ElseIf vEventID = "75752" Then '// 2017-01-18
		vStartNo = "1"
	ElseIf vEventID = "75761" Then '// 2017-01-19
		vStartNo = "2"
	ElseIf vEventID = "75759" Then '// 2017-01-20
		vStartNo = "3"
	ElseIf vEventID = "75768" Then '// 2017-01-23
		vStartNo = "4"
	ElseIf vEventID = "75872" Then '// 2017-01-24
		vStartNo = "5"
	ElseIf vEventID = "75855" Then '// 2017-01-25
		vStartNo = "6"
	ElseIf vEventID = "75843" Then '// 2017-01-26
		vStartNo = "7"
	ElseIf vEventID = "75864" Then '// 2017-01-30
		vStartNo = "8"
	ElseIf vEventID = "75942" Then '// 2017-01-31
		vStartNo = "9"
	ElseIf vEventID = "75984" Then '// 2017-02-01
		vStartNo = "10"
	ElseIf vEventID = "76014" Then '// 2017-02-02
		vStartNo = "11"
	ElseIf vEventID = "75966" Then '// 2017-02-03
		vStartNo = "12"
	ElseIf vEventID = "75981" Then '// 2017-02-06
		vStartNo = "13"
	ElseIf vEventID = "75968" Then '// 2017-02-07
		vStartNo = "14"
	ElseIf vEventID = "75967" Then '// 2017-02-08
		vStartNo = "15"
	ElseIf vEventID = "75988" Then '// 2017-02-09
		vStartNo = "16"
	ElseIf vEventID = "75989" Then '// 2017-02-10
		vStartNo = "17"
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
<!-- iframe -->
<style>
.luckyDay {position:relative; width:32rem; height:7.5rem;}
.luckyDay .swiper-container {height:3.8rem;}
.luckyDay .swiper-slide {position:relative; float:left; width:8.5rem; height:3.8rem; margin-right:0.5rem; text-align:center; background-color:#fff; border-radius:0.4rem;}
.luckyDay .swiper-slide:first-child {margin-left:2.3rem;}
.luckyDay .swiper-slide:last-child {margin-right:2.3rem;}
.luckyDay .swiper-slide div {display:table-cell; width:8.5rem; height:3.8rem; padding-top:0.2rem; font-size:1.1rem; vertical-align:middle; text-align:center;}
.luckyDay .swiper-slide span {display:none; font-weight:bold; padding-top:0.2rem;}
.luckyDay .swiper-slide a {display:none; position:absolute; left:0; top:0; width:100%; height:100%; text-indent:-999em;}
.luckyDay .swiper-slide.current {background-color:#616161; color:#fff;}
.luckyDay .swiper-slide.open a {display:block;}
.luckyDay .swiper-slide.soldout {background-color:#456a7d; color:#fff;}
.luckyDay .swiper-slide.soldout span {display:block;}

@media all and (min-width:360px){
	.luckyDay {width:36rem;}
}
@media all and (min-width:375px){
	.luckyDay {width:37.5rem;}
}
@media all and (min-width:600px){
	.luckyDay {width:60rem;}
}
@media all and (min-width:667px){
	.luckyDay {width:66.7rem;}
}
</style>
<script type="text/javascript">
$(function(){
	// iframe
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
			<% if currentdate < "2017-01-16" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75710"," current","")%>">
			<% End If %>
				<div>01.16 (월) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75710'); return false;">이벤트 바로가기</a>
			</div>
			
			<% if currentdate < "2017-01-17" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75758"," current","")%>">
			<% End If %>
				<div>01.17 (화) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75758'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-18" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75752"," current","")%>">
			<% End If %>
					<div>01.18 (수) <span>SOLD OUT</span></div>
					<a href="" onclick="goEventLink('75752'); return false;">이벤트 바로가기</a>
				</li>
			</div>

			<% if currentdate < "2017-01-19" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75761"," current","")%>">
			<% End If %>
				<div>01.19 (목)<span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75761'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-20" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75759"," current","")%>">
			<% End If %>
				<div>01.20 (금) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75759'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-23" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75768"," current","")%>">
			<% End If %>
				<div>01.23 (월) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75768'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-24" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75872"," current","")%>">
			<% End If %>
				<div>01.24 (화) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75872'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-25" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75855"," current","")%>">
			<% End If %>
				<div>01.25 (수) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75855'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-26" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75843"," current","")%>">
			<% End If %>
				<div>01.26 (목)<span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75843'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-30" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75864"," current","")%>">
			<% End If %>
				<div>01.30 (월) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75864'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-01-31" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75942"," current","")%>">
			<% End If %>
				<div>01.31 (화) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75942'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-01" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75984"," current","")%>">
			<% End If %>
				<div>02.01 (수) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75984'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-02" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="76014"," current","")%>">
			<% End If %>
				<div>02.02 (목)<span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('76014'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-03" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75966"," current","")%>">
			<% End If %>
				<div>02.03 (금) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75966'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-06" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75981"," current","")%>">
			<% End If %>
				<div>02.06 (월) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75981'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-07" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75968"," current","")%>">
			<% End If %>
				<div>02.07 (화) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75968'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-08" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide soldout open <%=CHKIIF(vEventID="75967"," current","")%>">
			<% End If %>
				<div>02.08 (수) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75967'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-09" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75988"," current","")%>">
			<% End If %>
				<div>02.09 (목) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75988'); return false;">이벤트 바로가기</a>
			</div>

			<% if currentdate < "2017-02-10" then %>
				<div class="swiper-slide">
			<% Else %>
				<div class="swiper-slide open <%=CHKIIF(vEventID="75989"," current","")%>">
			<% End If %>
				<div>02.10 (금) <span>SOLD OUT</span></div>
				<a href="" onclick="goEventLink('75989'); return false;">이벤트 바로가기</a>
			</div>


		</div>
	</div>
</div>
</body>
</html>