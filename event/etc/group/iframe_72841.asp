<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2015-03-09"
	
	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)


	If vEventID = "72841" Then
		vStartNo = "0"
	ElseIf vEventID = "72913" Then
		vStartNo = "0"
	ElseIf vEventID = "72914" Then
		vStartNo = "0"
	ElseIf vEventID = "72915" Then
		vStartNo = "1"
	ElseIf vEventID = "72916" Then
		vStartNo = "2"
	ElseIf vEventID = "72918" Then
		vStartNo = "4"
	ElseIf vEventID = "72919" Then
		vStartNo = "4"
	End If
	
	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.hidden {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}

.swiper {position:relative; height:65px; background-color:#fff;}
.swiper .swiper-slide {position:relative; padding:0 4px; text-align:center;}
.swiper .swiper-slide:after {content:' '; display:block; position:absolute; top:50%; right:0; width:1px; height:22px; margin-top:-11px; background-color:#dcdcdc;}
.rolling .swiper .nav7:after {display:none;}
.rolling .swiper .swiper-slide a,
.rolling .swiper .swiper-slide .coming {display:block; position:relative; width:88px; height:65px; line-height:65px;}
.rolling .swiper .swiper-slide a span, 
.rolling .swiper .swiper-slide .coming span {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/72841/m/img_navigator_01.png) no-repeat 50% 0; background-size:100% auto;}
.rolling .swiper .swiper-slide a span {background-position:50% -75px; cursor:pointer;}
.rolling .swiper .swiper-slide a.on span {background-position:50% 100%;}

.rolling .swiper .nav2 a span, 
.rolling .swiper .nav2 .coming span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72841/m/img_navigator_02.png);}
.rolling .swiper .nav3 a span, 
.rolling .swiper .nav3 .coming span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72841/m/img_navigator_03_v1.png);}
.rolling .swiper .nav4 a span, 
.rolling .swiper .nav4 .coming span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72841/m/img_navigator_04_v1.png);}
.rolling .swiper .nav5 a span, 
.rolling .swiper .nav5 .coming span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72841/m/img_navigator_05_v1.png);}
.rolling .swiper .nav6 a span, 
.rolling .swiper .nav6 .coming span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72841/m/img_navigator_06_v1.png);}
.rolling .swiper .nav7 a span, 
.rolling .swiper .nav7 .coming span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/72841/m/img_navigator_07_v1.png);}

@media all and (min-width:600px){
	.rolling .swiper .swiper-slide a,
	.rolling .swiper .swiper-slide .coming {display:block; position:relative; width:132px; height:97px;}
	.rolling .swiper .swiper-slide a span {background-position:50% -113px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('#navigator .swiper1',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto"
	});
});
</script>
</head>
<body>
	<div id="navigator" class="rolling">
		<h1 class="hidden">HOT BRAND WEEK</h1>

		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">
					<li class="swiper-slide nav1">
						<a href="<%=appevturl%>eventid=72841" <%=CHKIIF(vEventID="72841"," class='on'","")%> target="_top"><span></span>비욘드 클로젯</a>
					</li>

					<% if currentdate < "2016-09-06" then %>
					<li class="swiper-slide nav2">
						<span class="coming"><span></span>9월 6일 화요일 coming soon</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav2">
						<a href="<%=appevturl%>eventid=72913" <%=CHKIIF(vEventID="72913"," class='on'","")%> target="_top"><span></span>조셉앤스테이시<i></i></a>
					</li>
					<% End If %>

					<% if currentdate < "2016-09-07" then %>
					<li class="swiper-slide nav3">
						<span class="coming"><span></span>9월 7일 수요일 coming soon</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav3">
						<a href="<%=appevturl%>eventid=72914" <%=CHKIIF(vEventID="72914"," class='on'","")%> target="_top"><span></span>카렌화이트<i></i></a>
					</li>
					<% End If %>

					<% if currentdate < "2016-09-08" then %>
					<li class="swiper-slide nav4">
						<span class="coming"><span></span>9월 8일 목요일 coming soon</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav4">
						<a href="<%=appevturl%>eventid=72915" <%=CHKIIF(vEventID="72915"," class='on'","")%> target="_top"><span></span>지홍<i></i></a>
					</li>
					<% End If %>

					<% if currentdate < "2016-09-09" then %>
					<li class="swiper-slide nav5">
						<span class="coming"><span></span>9월 9일 금요일 coming soon</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav5">
						<a href="<%=appevturl%>eventid=72916" <%=CHKIIF(vEventID="72916"," class='on'","")%> target="_top"><span></span>에이들<i></i></a>
					</li>
					<% End If %>

					<% if currentdate < "2016-09-12" then %>
					<li class="swiper-slide nav6">
						<span class="coming"><span></span>9월 12일 월요일 coming soon</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav6">
						<a href="<%=appevturl%>eventid=72918" <%=CHKIIF(vEventID="72918"," class='on'","")%> target="_top"><span></span>화이트블랭크<i></i></a>
					</li>
					<% End If %>

					<% if currentdate < "2016-09-13" then %>
					<li class="swiper-slide nav7">
						<span class="coming"><span></span>9월 13일 화요일 coming soon</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav7">
						<a href="<%=appevturl%>eventid=72919" <%=CHKIIF(vEventID="72919"," class='on'","")%> target="_top"><span></span>쎄쎄쎄<i></i></a>
					</li>
					<% End If %>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>