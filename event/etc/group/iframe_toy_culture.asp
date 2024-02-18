<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim currentdate
	currentdate = date()
	'currentdate = "2016-11-21"
	'response.write currentdate
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'연미님 코맨트
'1. 24Line부터 시작하는 vEventID를 각 날짜에 맞게 넣어주세요. ex) 11/14일에 이벤트코드가 정해지면 26Line에 74068이 아닌 그 이벤트코드로 수정
'2. swiper-slide에 이벤트코드 수정해주세요. ex) 11/14일에 이벤트코드가 정해지면 106Line에 74068이 아닌 그 이벤트코드 수정과 내용 수정
'#######################################################################
Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)
	If vEventID = "77029" Then				'1회차
		vStartNo = "0"
	ElseIf vEventID = "77270" Then			'2회차
		vStartNo = "0"
	ElseIf vEventID = "77294" Then			'3회차
		vStartNo = "1"
	ElseIf vEventID = "77295" Then			'4회차
		vStartNo = "1"
	End If

If isapp = "1" Then
	appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
Else
	appevturl = "/event/eventmain.asp?"
End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>아트토이</title>
<style type="text/css">
.rolling {position:relative; margin:0 auto; width:320px; height:67px;}
.rolling .swiper {position:relative; padding:0 6.25%;}
.rolling .swiper .swiper-slide {position:relative; float:left; width:33.333%; height:67px; text-align:center;}
.rolling .swiper .swiper-slide span, .rolling .swiper .swiper-slide a {display:block; position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/77029/m/tab_0.png) 0 100% no-repeat; background-size:100% auto; text-indent:-999em;}
.rolling .swiper .swiper-slide a span {background-position:50% 50%;}
.rolling .swiper .swiper-slide a.on span {background-position:50% 0;}

.rolling .swiper .swiper-slide.nav2 span, .rolling .swiper .swiper-slide.nav2 a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77270/m/tab_1.png);}
.rolling .swiper .swiper-slide.nav3 span, .rolling .swiper .swiper-slide.nav3 a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77294/m/tab_2.png);}
.rolling .swiper .swiper-slide.nav4 span, .rolling .swiper .swiper-slide.nav4 a {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77295/m/tab_3.png);}

.rolling .swiper .btnNav {position:absolute; top:50%; width:3.1%; margin-top:-1.8%; background-color:transparent;}
.rolling .swiper .btnPrev {left:1.5%;}
.rolling .swiper .btnNext {right:1.5%;}

@media all and (min-width:360px){
	.rolling {width:360px;}
	.rolling .swiper .swiper-slide {height:75px;}
}
@media all and (min-width:375px){
	.rolling {width:375px;}
	.rolling .swiper .swiper-slide {height:79.1px;}
}
@media all and (min-width:600px){
	.rolling {width:600px; }
	.rolling .swiper .swiper-slide {height:125.62px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('#navigator .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:3,
		spaceBetween:"0.8%",
		nextButton:"#navigator .btnNext",
		prevButton:"#navigator .btnPrev"
	});
});
</script>
</head>
<body>
	<div id="navigator" class="rolling">
		<div class="swiper">
			<div class="swiper-container">
				<ul class="swiper-wrapper">
					<li class="swiper-slide nav1">
						<a href="<%=appevturl%>eventid=77029" <%=CHKIIF(vEventID="77029"," class='on'","")%> target="_top"><span>4월3일</span></a>
					</li>

					<% If currentdate < "2017-04-10" Then %>
					<li class="swiper-slide nav2">
						<span></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav2">
						<a href="<%=appevturl%>eventid=77270" <%=CHKIIF(vEventID="77270"," class='on'","")%> target="_top"><span>4월10일</span></a>
					</li>
					<% End If %>

					<% If currentdate < "2017-04-17" Then %>
					<li class="swiper-slide nav3">
						<span></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav3">
						<a href="<%=appevturl%>eventid=77294" <%=CHKIIF(vEventID="77294"," class='on'","")%> target="_top"><span>4월17일</span></a>
					</li>
					<% End If %>

					<% If currentdate < "2017-04-24" Then %>
					<li class="swiper-slide nav4">
						<span></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav4">
						<a href="<%=appevturl%>eventid=77295" <%=CHKIIF(vEventID="77295"," class='on'","")%> target="_top"><span>4월24일</span></a>
					</li>
					<% End If %>
				</ul>
			</div>
			<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77029/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77029/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>
</body>
</html>