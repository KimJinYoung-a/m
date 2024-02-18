<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim currentdate
	currentdate = date()
	'currentdate = "2016-10-21"
	'response.write currentdate
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
Dim vEventID, vStartNo, appevturl
vEventID = requestCheckVar(Request("eventid"),9)
If vEventID = "73818" Then				
	vStartNo = "0"
ElseIf vEventID = "74302" Then			'2회차(11/21)
	vStartNo = "1"
ElseIf vEventID = "75030" Then			'3회차(12/19)
	vStartNo = "2"
ElseIf vEventID = "75628" Then			'4회차(17/01/16)
	vStartNo = "3"
ElseIf vEventID = "76388" Then			'5회차(17/02/27)
	vStartNo = "4"
ElseIf vEventID = "76773" Then			'6회차(17/03/20)
	vStartNo = "5"
ElseIf vEventID = "77399" Then			'7회차(17/04/17)
	vStartNo = "6"
ElseIf vEventID = "77959" Then			'8회차(17/05/23)
	vStartNo = "7"
ElseIf vEventID = "78717" Then			'9회차(17/06/26)
	vStartNo = "8"
ElseIf vEventID = "79340" Then			'10회차(17/07/25)
	vStartNo = "9"
ElseIf vEventID = "79876" Then			'11회차(17/08/25)
	vStartNo = "10"
ElseIf vEventID = "80676" Then			'12회차(17/09/26)
	vStartNo = "11"
ElseIf vEventID = "81299" Then			'13회차
	vStartNo = "12"
ElseIf vEventID = "82001" Then			'14회차
	vStartNo = "13"
ElseIf vEventID = "82946" Then			'15회차
	vStartNo = "14"
End If

If isapp = "1" Then
	appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
Else
	appevturl = "/event/eventmain.asp?"
End If 
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.swiper {position:relative; height:56px;}
.swiper .swiper-slide {text-align:center;}
.swiper .swiper-slide a,
.swiper .swiper-slide span {display:block; width:42px; height:56px; padding-top:9px; color:#8d8d8d; font-size:12px; line-height:1.2em;}
.swiper .swiper-slide span {color:#ccc;}
.swiper .swiper-slide a.on {width:72px; padding-top:25px; background:url(http://webimage.10x10.co.kr/eventIMG/2016/73818/m/bg_nav_on.png) no-repeat 0 0; background-size:100% auto; color:#fff; font-size:11px;}

@media all and (min-width:360px){
	.swiper .swiper-slide span {font-size:13px;}
	.swiper .swiper-slide a.on {font-size:12px;}
}

@media all and (min-width:480px){
	.swiper {height:84px;}
	.swiper .swiper-slide a,
	.swiper .swiper-slide span {width:64px; height:84px; font-size:18px; line-height:1.5em;}
	.swiper .swiper-slide a.on {width:108px; padding-top:37px; font-size:16px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('#navigator .swiper1',{
		centeredSlides:true,
		initialSlide:<%=vStartNo%>,
		slidesPerView:"auto",
		spaceBetween:"1%"
	});

	$("#navigator .swiper .swiper-slide span").click(function(){
		alert("오픈 예정입니다.");
	});
});
</script>
</head>
<body>
	<div id="navigator" class="rolling">
		<h1 class="hidden">혹시.. 여신이세요? 메뉴</h1>

		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">
					<%' 오픈 %>
					<li class="swiper-slide nav01">
						<a href="<%=appevturl%>eventid=73818" <%=CHKIIF(vEventID="73818"," class='on'","")%> target="_top" title="데이트 편">#01</a>
					</li>
					<%' 오픈 전 %>

					<% If currentdate < "2016-11-21" Then %>
					<li class="swiper-slide nav02">
						<span>#02</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav02">
						<a href="<%=appevturl%>eventid=74302" <%=CHKIIF(vEventID="74302"," class='on'","")%> target="_top" title="지각 극복 편">#02</a>
					</li>
					<% End If %>

					<% If currentdate < "2016-12-19" Then %>
					<li class="swiper-slide nav03">
						<span>#03</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav03">
						<a href="<%=appevturl%>eventid=75030" <%=CHKIIF(vEventID="75030"," class='on'","")%> target="_top" title="힐링 크리스마스 편">#03</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-01-16" Then %>
					<li class="swiper-slide nav04">
						<span>#04</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav04">
						<a href="<%=appevturl%>eventid=75628" <%=CHKIIF(vEventID="75628"," class='on'","")%> target="_top" title="볼륨편">#04</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-02-27" Then %>
					<li class="swiper-slide nav05">
						<span>#05</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav05">
						<a href="<%=appevturl%>eventid=76388" <%=CHKIIF(vEventID="76388"," class='on'","")%> target="_top" title="독도지킴이 편">#05</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-03-20" Then %>
					<li class="swiper-slide nav06">
						<span>#06</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav06">
						<a href="<%=appevturl%>eventid=76773" <%=CHKIIF(vEventID="76773"," class='on'","")%> target="_top" title="달콤한 비누편">#06</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-04-17" Then %>
					<li class="swiper-slide nav07">
						<span>#07</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav07">
						<a href="<%=appevturl%>eventid=77399" <%=CHKIIF(vEventID="77399"," class='on'","")%> target="_top" title="담백한 선물편">#07</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-05-23" Then %>
					<li class="swiper-slide nav08">
						<span>#08</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav08">
						<a href="<%=appevturl%>eventid=77959" <%=CHKIIF(vEventID="77959"," class='on'","")%> target="_top" title="완벽한 다이어트편">#08</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-06-26" Then %>
					<li class="swiper-slide nav09">
						<span>#09</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav09">
						<a href="<%=appevturl%>eventid=78717" <%=CHKIIF(vEventID="78717"," class='on'","")%> target="_top" title="휴가 필수품편">#09</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-07-25" Then %>
					<li class="swiper-slide nav10">
						<span>#10</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav10">
						<a href="<%=appevturl%>eventid=79340" <%=CHKIIF(vEventID="79340"," class='on'","")%> target="_top" title="톡쏘는 클렌징편">#10</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-08-25" Then %>
					<li class="swiper-slide nav11">
						<span>#11</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav11">
						<a href="<%=appevturl%>eventid=79876" <%=CHKIIF(vEventID="79876"," class='on'","")%> target="_top" title="휴대용 마사지편">#11</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-09-26" Then %>
					<li class="swiper-slide nav12">
						<span>#12</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav12">
						<a href="<%=appevturl%>eventid=80676" <%=CHKIIF(vEventID="80676"," class='on'","")%> target="_top" title="헤어 마스크편">#12</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-10-25" Then %>
					<li class="swiper-slide nav13">
						<span>#13</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav13">
						<a href="<%=appevturl%>eventid=81299" <%=CHKIIF(vEventID="81299"," class='on'","")%> target="_top" title="브러쉬 클리너편">#13</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-11-23" Then %>
					<li class="swiper-slide nav14">
						<span>#14</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav14">
						<a href="<%=appevturl%>eventid=82001" <%=CHKIIF(vEventID="82001"," class='on'","")%> target="_top" title="다리 부종">#14</a>
					</li>
					<% End If %>

					<% If currentdate < "2017-12-21" Then %>
					<li class="swiper-slide nav15">
						<span>#15</span>
					</li>
					<% Else %>
					<li class="swiper-slide nav15">
						<a href="<%=appevturl%>eventid=82946" <%=CHKIIF(vEventID="82946"," class='on'","")%> target="_top"  title="DIY 배쓰밤편">#15</a>
					</li>
					<% End If %>

					<li class="swiper-slide nav17">
						<span>#17</span>
					</li>
					<li class="swiper-slide nav18">
						<span>#18</span>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>