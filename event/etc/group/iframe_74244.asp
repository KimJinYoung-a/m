<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2016-10-24"
	
	'response.write currentdate

'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때 뭐뭐뭐.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, vStartNo, appevturl
	vEventID = requestCheckVar(Request("eventid"),9)

	If vEventID = "74244" Then
		vStartNo = "0"
	ElseIf vEventID = "74244" Then
		vStartNo = "0"
	ElseIf vEventID = "74357" Then
		vStartNo = "0"
	ElseIf vEventID = "74358" Then
		vStartNo = "0"
	ElseIf vEventID = "74359" Then
		vStartNo = "2"
	ElseIf vEventID = "74428" Then
		vStartNo = "3"
	ElseIf vEventID = "74429" Then
		vStartNo = "4"
	ElseIf vEventID = "74530" Then
		vStartNo = "6"
	ElseIf vEventID = "74532" Then
		vStartNo = "7"
	ElseIf vEventID = "74573" Then
		vStartNo = "8"
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
.navWrap {width:27rem; height:6.5rem !important; margin:0 auto;}
.navWrap .swiper-container {height:6.5rem;}
.navWrap li {float:left; width:33.33333%; height:6.5rem;}
.navWrap li a {display:block; height:100%;}
.navWrap li span {display:block; width:8.3rem; height:100%; margin:0 auto; background-size:100% auto; background-repeat:no-repeat; background-position:0 0; text-indent:-999em;}
.navWrap li.date1114 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1114.png);}
.navWrap li.date1115 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1115.png);}
.navWrap li.date1116 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1116.png);}
.navWrap li.date1117 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1117.png);}
.navWrap li.date1118 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1118.png);}
.navWrap li.date1121 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1121.png);}
.navWrap li.date1122 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1122.png);}
.navWrap li.date1123 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1123.png);}
.navWrap li.date1124 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1124.png);}
.navWrap li.date1125 span {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/74244/m/tab_1125.png);}
.navWrap li.open span {background-position:0 -6.5rem;}
.navWrap li.today span {background-position:0 -13rem;}
@media all and (min-width:360px){
	.navWrap {width:30rem;}
}
@media all and (min-width:375px){
	.navWrap {width:32rem;}
}
@media all and (min-width:600px){
	.navWrap {width:54rem;}
}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.navWrap .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:3,
		//slidesPerGroup:3,
		speed:300
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
<div class="navWrap">
	<div class="swiper-container">
		<ul class="swiper-wrapper">
			<%' for dev msg : 오픈된 페이지 open, 오늘날짜 탭에는 today  클래스 붙여주세요 / 이벤트링크는 M/A 각각 부탁해염%>
				<li class="swiper-slide date1114 open">
					<span>11월 14일 INVITE.L</span>
				</li>

			<% if currentdate <> "2016-11-15" then %>
				<li class="swiper-slide date1115 <%=CHKIIF(currentdate < "2016-11-16",""," open")%>">
					<span>11월 15일 ICONIC</span>
				</li>
			<% else %>
				<li class="swiper-slide date1115 open <%=CHKIIF(vEventID="74357"," today","")%>">
					<a href="" onclick="goEventLink('74357'); return false;">
						<span>11월 15일 ICONIC</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-16" then %>
				<li class="swiper-slide date1116 <%=CHKIIF(currentdate < "2016-11-17",""," open")%>">
					<span>11월 16일 LIVEWORK</span>
				</li>
			<% else %>
				<li class="swiper-slide date1116 open <%=CHKIIF(vEventID="74358"," today","")%>">
					<a href="" onclick="goEventLink('74358'); return false;">
						<span>11월 16일 LIVEWORK</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-17" then %>
				<li class="swiper-slide date1117 <%=CHKIIF(currentdate < "2016-11-18",""," open")%>">
					<span>11월 17일 ARDIUM</span>
				</li>
			<% else %>
				<li class="swiper-slide date1117 open <%=CHKIIF(vEventID="74359"," today","")%>">
					<a href="" onclick="goEventLink('74359'); return false;">
						<span>11월 17일 ARDIUM</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-18" then %>
				<li class="swiper-slide date1118 <%=CHKIIF(currentdate < "2016-11-19",""," open")%>">
					<span>11월 18일 TIUM</span>
				</li>
			<% else %>
				<li class="swiper-slide date1118 open <%=CHKIIF(vEventID="74428"," today","")%>">
					<a href="" onclick="goEventLink('74428'); return false;">
						<span>11월 18일 TIUM</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-21" then %>
				<li class="swiper-slide date1121 <%=CHKIIF(currentdate < "2016-11-22",""," open")%>">
					<span>11월 21일 LAMY</span>
				</li>
			<% else %>
				<li class="swiper-slide date1121 open <%=CHKIIF(vEventID="74429"," today","")%>">
					<a href="" onclick="goEventLink('74429'); return false;">
						<span>11월 21일 LAMY</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-22" then %>
				<li class="swiper-slide date1122 <%=CHKIIF(currentdate < "2016-11-23",""," open")%>">
					<span>11월 22일 MMMG</span>
				</li>
			<% else %>
				<li class="swiper-slide date1122 open <%=CHKIIF(vEventID="74430"," today","")%>">
					<a href="" onclick="goEventLink('74430'); return false;">
						<span>11월 22일 MMMG</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-23" then %>
				<li class="swiper-slide date1123 <%=CHKIIF(currentdate < "2016-11-24",""," open")%>">
					<span>11월 23일</span>
				</li>
			<% else %>
				<li class="swiper-slide date1123 open <%=CHKIIF(vEventID="74530"," today","")%>">
					<a href="" onclick="goEventLink(''); return false;">
						<span>11월 23일</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-24" then %>
				<li class="swiper-slide date1124 <%=CHKIIF(currentdate < "2016-11-25",""," open")%>">
					<span>11월 24일</span>
				</li>
			<% else %>
				<li class="swiper-slide date1124 open <%=CHKIIF(vEventID="74532"," today","")%>">
					<a href="" onclick="goEventLink(''); return false;">
						<span>11월 24일</span>
					</a>
				</li>
			<% end if %>

			<% if currentdate <> "2016-11-25" then %>
				<li class="swiper-slide date1125 <%=CHKIIF(currentdate < "2016-11-26",""," open")%>">
					<span>11월 25일</span>
				</li>
			<% else %>
				<li class="swiper-slide date1125 open <%=CHKIIF(vEventID="74573"," today","")%>">
					<a href="" onclick="goEventLink(''); return false;">
						<span>11월 25일</span>
					</a>
				</li>
			<% end if %>
		</ul>
	</div>
</div>
<!--// iframe -->
</body>
</html>