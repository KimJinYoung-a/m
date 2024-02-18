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
	If vEventID = "73902" Then				'1회차(11/02)
		vStartNo = "0"
	ElseIf vEventID = "74068" Then			'2회차(11/07)
		vStartNo = "0"
	ElseIf vEventID = "74158" Then			'3회차(11/14)
		vStartNo = "1"
	ElseIf vEventID = "74402" Then			'4회차(11/21)
		vStartNo = "2"
	ElseIf vEventID = "74472" Then			'5회차(11/28)
		vStartNo = "3"
	ElseIf vEventID = "74684" Then			'6회차(12/07)
		vStartNo = "4"
	ElseIf vEventID = "74841" Then			'7회차(12/12)
		vStartNo = "6"
	ElseIf vEventID = "75040" Then			'8회차(12/19)
		vStartNo = "6"
	ElseIf vEventID = "75230" Then			'9회차(12/27)
		vStartNo = "6"
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
.rolling {position:relative; width:31rem; margin:0 auto; height:3.5rem;}
.rolling .swiper {padding:0 2.5rem;}
.rolling .swiper .swiper-container {height:3.5rem;}
.rolling .swiper .swiper-slide {float:left; width:8.5rem; height:3.5rem; text-align:center;}
.rolling .swiper .swiper-slide a,
.rolling .swiper .swiper-slide span {display:block; width:100%; height:100%; padding-top:0.65rem; border-radius:0.5rem; background-color:#fff; font-size:1.1rem; line-height:1.1em;}
.rolling .swiper .swiper-slide span {color:#a6a6a6;}
.rolling .swiper .swiper-slide .on {background-color:#d94875; color:#fff;}
.rolling .swiper .nav2 .on {background-color:#a44122;}
.rolling .swiper .nav3 .on {background-color:#df3936;}
.rolling .swiper .nav4 .on {background-color:#f6634a;}
.rolling .swiper .nav4 .on {background-color:#f6634a;}
.rolling .swiper .nav5 .on {background-color:#ff9393;}
.rolling .swiper .nav6 .on {background-color:#ff6565;}
.rolling .swiper .nav7 .on {background-color:#e33837;}
.rolling .swiper .nav8 .on {background-color:#e84463;}
.rolling .swiper .nav9 .on {background-color:#000;}

.rolling .swiper .swiper-slide b {font-weight:bold;}

.rolling .swiper .btnNav {position:absolute; top:0; width:2.4rem; background-color:transparent;}
.rolling .swiper .btnPrev {left:0;}
.rolling .swiper .btnNext {right:0;}

@media all and (min-width:360px){
	.rolling {width:35rem;}
}
@media all and (min-width:375px){
	.rolling {width:36.5rem;}
}
@media all and (min-width:600px){
	.rolling {width:54rem;}
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
						<a href="<%=appevturl%>eventid=73902" <%=CHKIIF(vEventID="73902"," class='on'","")%> target="_top">11.02 (수)<br /> <b>Sonny Angel</b></a>
					</li>
					<% If currentdate < "2016-11-07" Then %>
					<li class="swiper-slide nav2">
						<span>11.07 (월)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav2">
						<a href="<%=appevturl%>eventid=74068" <%=CHKIIF(vEventID="74068"," class='on'","")%> target="_top">11.07 (월)<br /> <b>Superfiction</b></a>
					</li>
					<% End If %>

					<% If currentdate < "2016-11-14" Then %>
					<li class="swiper-slide nav3">
						<span>11.14 (월)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav3">
						<a href="<%=appevturl%>eventid=74158" <%=CHKIIF(vEventID="74158"," class='on'","")%> target="_top">11.14 (월)<br /> <b>Playmobil</b></a>
					</li>
					<% End If %>

					<% If currentdate < "2016-11-21" Then %>
					<li class="swiper-slide nav4">
						<span>11.21 (월)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav4">
						<a href="<%=appevturl%>eventid=74402" <%=CHKIIF(vEventID="74402"," class='on'","")%> target="_top">11.21 (월)<br /> <b>130BO</b></a>
					</li>
					<% End If %>

					<% If currentdate < "2016-11-28" Then %>
					<li class="swiper-slide nav5">
						<span>11.28 (월)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav5">
						<a href="<%=appevturl%>eventid=74472" <%=CHKIIF(vEventID="74472"," class='on'","")%> target="_top">11.28 (월)<br /> <b>Seulgie</b></a>
					</li>
					<% End If %>

					<% If currentdate < "2016-12-07" Then %>
					<li class="swiper-slide nav6">
						<span>12.07 (수)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav6">
						<a href="<%=appevturl%>eventid=74684" <%=CHKIIF(vEventID="74684"," class='on'","")%> target="_top">12.07 (수)<br /> <b>무한도전XSML</b></a>
					</li>
					<% End If %>

					<% If currentdate < "2016-12-12" Then %>
					<li class="swiper-slide nav7">
						<span>12.12 (월)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav7">
						<a href="<%=appevturl%>eventid=74841" <%=CHKIIF(vEventID="74841"," class='on'","")%> target="_top">12.12 (월)<br /> <b>DUCKOO</b></a>
					</li>
					<% End If %>					

					<% If currentdate < "2016-12-19" Then %>
					<li class="swiper-slide nav8">
						<span>12.19 (월)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav8">
						<a href="<%=appevturl%>eventid=75040" <%=CHKIIF(vEventID="75040"," class='on'","")%> target="_top">12.19 (월)<br /> <b>Goolygooly</b></a>
					</li>
					<% End If %>

					<% If currentdate < "2016-12-27" Then %>
					<li class="swiper-slide nav9">
						<span>12.27 (화)<br /> <b>Who&apos;s Next?</b></span>
					</li>
					<% Else %>
					<li class="swiper-slide nav9">
						<a href="<%=appevturl%>eventid=75230" <%=CHKIIF(vEventID="75230"," class='on'","")%> target="_top">12.27 (화)<br /> <b>COOLRAIN</b></a>
					</li>
					<% End If %>
				</ul>
			</div>
			<button type="button" class="btnNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73902/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73902/m/btn_next.png" alt="다음" /></button>
		</div>
	</div>
</body>
</html>