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
	If vEventID = "69891" Then
		vStartNo = "0"
	ElseIf vEventID = "70636" Then
		vStartNo = "1"
	ElseIf vEventID = "71204" Then
		vStartNo = "2"
	ElseIf vEventID = "72704" Then
		vStartNo = "3"
	ElseIf vEventID = "73055" Then
		vStartNo = "4"
	ElseIf vEventID = "73817" Then
		vStartNo = "5"
	ElseIf vEventID = "74394" Then
		vStartNo = "6"
	ElseIf vEventID = "75084" Then
		vStartNo = "7"
	ElseIf vEventID = "75944" Then
		vStartNo = "8"
	ElseIf vEventID = "76882" Then
		vStartNo = "9"
	ElseIf vEventID = "77321" Then
		vStartNo = "10"
	ElseIf vEventID = "78015" Then
		vStartNo = "11"
	ElseIf vEventID = "78538" Then
		vStartNo = "12"
	ElseIf vEventID = "79201" Then
		vStartNo = "13"
	ElseIf vEventID = "79824" Then
		vStartNo = "14"
	ElseIf vEventID = "80681" Then
		vStartNo = "15"
	ElseIf vEventID = "81121" Then
		vStartNo = "16"
	ElseIf vEventID = "82050" Then
		vStartNo = "17"
	ElseIf vEventID = "82797" Then
		vStartNo = "18"
	ElseIf vEventID = "000" Then
		vStartNo = "19"
	ElseIf vEventID = "000" Then
		vStartNo = "20"
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
.swiper .swiper-slide span {display:block; width:42px; height:56px; padding-top:9px; color:#666; font-size:12px; line-height:1em;}
.swiper .swiper-slide span {color:#ccc;}
.swiper .swiper-slide a.on {width:105px; padding-top:20px; background:url(http://webimage.10x10.co.kr/eventIMG/2016/69891/m/bg_nav_on.png) no-repeat 0 0; background-size:100% auto; color:#fff; font-size:11px;}

@media all and (min-width:360px){
	.swiper .swiper-slide span {font-size:13px;}
	.swiper .swiper-slide a.on {font-size:12px;}
}

@media all and (min-width:480px){
	.swiper {height:84px;}
	.swiper .swiper-slide a,
	.swiper .swiper-slide span {width:64px; height:84px; font-size:18px;}
	.swiper .swiper-slide a.on {width:160px; padding-top:32px; font-size:16px;}
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
		<h1 class="hidden">잇키친 시리즈</h1>

		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">
					<li class="swiper-slide serise01">
						<a href="<%=appevturl%>eventid=69891" <%=CHKIIF(vEventID="69891"," class='on'","")%> target="_top">#01</a>
					</li>
					<li class="swiper-slide serise02">
						<a href="<%=appevturl%>eventid=70636" <%=CHKIIF(vEventID="70636"," class='on'","")%> target="_top">#02</a>
					</li>

					<% if currentdate < "2016-06-20" then %>
					<li class="swiper-slide serise03">
						<span>#03</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise03">
						<a href="<%=appevturl%>eventid=71204" <%=CHKIIF(vEventID="71204"," class='on'","")%> target="_top">#03</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-08-29" then %>
					<li class="swiper-slide serise04">
						<span>#04</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise04">
						<a href="<%=appevturl%>eventid=72704" <%=CHKIIF(vEventID="72704"," class='on'","")%> target="_top">#04</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-09-21" then %>
					<li class="swiper-slide serise05">
						<span>#05</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise05">
						<a href="<%=appevturl%>eventid=73055" <%=CHKIIF(vEventID="73055"," class='on'","")%> target="_top">#05</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-10-26" then %>
					<li class="swiper-slide serise06">
						<span>#06</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise06">
						<a href="<%=appevturl%>eventid=73817" <%=CHKIIF(vEventID="73817"," class='on'","")%> target="_top">#06</a>
					</li>
					<% End If %>

					<% if currentdate < "2016-11-23" then %>
					<li class="swiper-slide serise07">
						<span>#07</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise07">
						<a href="<%=appevturl%>eventid=74394" <%=CHKIIF(vEventID="74394"," class='on'","")%> target="_top" title="Classic TEAPOT makes Perfect TEA">#07</a>
					</li>
					<% End If %>


					<% if currentdate < "2016-12-21" then %>
					<li class="swiper-slide serise08">
						<span>#08</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise08">
						<a href="<%=appevturl%>eventid=75084" <%=CHKIIF(vEventID="75084"," class='on'","")%> target="_top" title="음식을 담는 가장 아름다운 방법">#08</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-02-06" then %>
					<li class="swiper-slide serise09">
						<span>#09</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise09">
						<a href="<%=appevturl%>eventid=75944" <%=CHKIIF(vEventID="75944"," class='on'","")%> target="_top" title="접시와 작품 그 사이">#09</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-03-22" then %>
					<li class="swiper-slide serise10">
						<span>#10</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise10">
						<a href="<%=appevturl%>eventid=76882" <%=CHKIIF(vEventID="76882"," class='on'","")%> target="_top" title="A Toast for life">#10</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-04-26" then %>
					<li class="swiper-slide serise11">
						<span>#11</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise11">
						<a href="<%=appevturl%>eventid=77321" <%=CHKIIF(vEventID="77321"," class='on'","")%> target="_top" title="DRESS UP YOUR TABLE">#11</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-05-23" then %>
					<li class="swiper-slide serise12">
						<span>#12</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise12">
						<a href="<%=appevturl%>eventid=78015" <%=CHKIIF(vEventID="78015"," class='on'","")%> target="_top" title="자연의 한 조각">#12</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-06-19" then %>
					<li class="swiper-slide serise13">
						<span>#13</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise13">
						<a href="<%=appevturl%>eventid=78538" <%=CHKIIF(vEventID="78538"," class='on'","")%> target="_top" title="Not just a JUG">#13</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-07-18" then %>
					<li class="swiper-slide serise14">
						<span>#14</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise14">
						<a href="<%=appevturl%>eventid=79201" <%=CHKIIF(vEventID="79201"," class='on'","")%> target="_top" title="This is THAT">#14</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-08-22" then %>
					<li class="swiper-slide serise15">
						<span>#15</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise15">
						<a href="<%=appevturl%>eventid=79824" <%=CHKIIF(vEventID="79824"," class='on'","")%> target="_top" title="This is THAT">#15</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-09-27" then %>
					<li class="swiper-slide serise16">
						<span>#16</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise16">
						<a href="<%=appevturl%>eventid=80681" <%=CHKIIF(vEventID="80681"," class='on'","")%> target="_top" title="This is THAT">#16</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-10-18" then %>
					<li class="swiper-slide serise17">
						<span>#17</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise17">
						<a href="<%=appevturl%>eventid=81121" <%=CHKIIF(vEventID="81121"," class='on'","")%> target="_top" title="This is THAT">#17</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-11-21" then %>
					<li class="swiper-slide serise18">
						<span>#18</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise18">
						<a href="<%=appevturl%>eventid=82050" <%=CHKIIF(vEventID="82050"," class='on'","")%> target="_top" title="LIM">#18</a>
					</li>
					<% End If %>

					<% if currentdate < "2017-12-19" then %>
					<li class="swiper-slide serise19">
						<span>#19</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise19">
						<a href="<%=appevturl%>eventid=82797" <%=CHKIIF(vEventID="82797"," class='on'","")%> target="_top" title="D.Meolleux">#19</a>
					</li>
					<% End If %>

					<% if currentdate < "2018-01-22" then %>
					<li class="swiper-slide serise20">
						<span>#20</span>
					</li>
					<% Else %>
					<li class="swiper-slide serise20">
						<a href="<%=appevturl%>eventid=79201" <%=CHKIIF(vEventID="79201"," class='on'","")%> target="_top" title="This is THAT">#20</a>
					</li>
					<% End If %>

					<li class="swiper-slide serise20">
						<span>#21</span>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>