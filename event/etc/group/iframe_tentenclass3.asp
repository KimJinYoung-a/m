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

	If vEventID = "95354" Then '// 7월
		vStartNo = "0"
	ElseIf vEventID = "96299" Then '// 8월
		vStartNo = "0"
	ElseIf vEventID = "96997" Then '// 9월
		vStartNo = "1"
	ElseIf vEventID = "97525" Then '// 10월
		vStartNo = "2"
	ElseIf vEventID = "98311" Then '// 11월
		vStartNo = "3"
	ElseIf vEventID = "99015" Then '// 12월
		vStartNo = "4"
	ElseIf vEventID = "99736" Then '// 1월
		vStartNo = "5"
	ElseIf vEventID = "100275" Then '// 2월
		vStartNo = "6"
	ElseIf vEventID = "100919" Then '// 3월
		vStartNo = "7"
	ElseIf vEventID = "101739" Then '// 4월
		vStartNo = "8"
	ElseIf vEventID = "102412" Then '// 5월
		vStartNo = "8"
	ElseIf vEventID = "103062" Then '// 6월
		vStartNo = "9"
	ElseIf vEventID = "103875" Then '// 7월
		vStartNo = "10"
	ElseIf vEventID = "104696" Then '// 8월
		vStartNo = "11"
	ElseIf vEventID = "105290" Then '// 9월
		vStartNo = "12"
	ElseIf vEventID = "106362" Then '// 10월
		vStartNo = "13"
	ElseIf vEventID = "106363" Then '// 11월
		vStartNo = "14"
	ElseIf vEventID = "106364" Then '// 12월	
		vStartNo = "15"
	End IF

	If isapp = "1" Then
		appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
	Else
		appevturl = "/event/eventmain.asp?"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style>
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#fff;}
.monthTab {position:relative; width:100%; height:100%;}
.monthTab .swiper-container {width:80%; height:100%;}
.monthTab li + li:before {content:' '; position:absolute; top:38%; width:1px; height:30%; background-color:#b2b2b2;}
.monthTab li a {position:relative; display:block; padding:2rem 0; font-family:'AvenirNext-Regular'; font-size:1.7rem; line-height:1.3; text-align:center; color:#b0b0b0;}
.monthTab li a b {display:block; font-family:'Malgun Gothic';}
.monthTab li.current a {color:#0a0a0a; font-family:'AvenirNext-Medium';}
.monthTab li.current a b {font-weight:bold;}
.monthTab li.current a:after {content:''; position:absolute; left:50%; top:85%; width:0; height:0; margin-left:-.5rem; border-width:.6rem .5rem 0 .5rem; border-style:solid; border-color:#202020 transparent transparent;}
.monthTab button {display:block; position:absolute; top:0; z-index:1; width:12%; height:100%; font-size:0; outline:0; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2019/95354/m/btn_date_nav.png) no-repeat 50% 50% / contain;}
.monthTab .btnPrev {left:0;}
.monthTab .btnNext {right:0; -webkit-transform:rotate(180deg); transform:rotate(180deg);}
</style>
<script type="text/javascript">
$(function(){
	dateSwiper = new Swiper('.monthTab .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:3,
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

			<% if currentdate < "2019-07-01" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="95354"," current","")%>">
			<% End If %>
				<a href="" onclick="goEventLink('95354'); return false;"><b>19.07</b>JUL</a>
			</li>

			<% if currentdate < "2019-08-01" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="96299"," current","")%>">
			<% End If %>
				<a href="" onclick="goEventLink('96299'); return false;"><b>19.08</b>AUG</a>
			</li>

			<% if currentdate < "2019-09-01" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="96997"," current","")%>">
			<% End If %>
				<a href="" onclick="goEventLink('96997'); return false;"><b>19.09</b>SEP</a>
			</li>

			<% if currentdate < "2019-10-01" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="97525"," current","")%>">
			<% End If %>
				<a href="" onclick="goEventLink('97525'); return false;"><b>19.10</b>OCT</a>
			</li>

			<% if currentdate < "2019-11-01" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="98311"," current","")%>">
			<% End If %>
				<a href="" onclick="goEventLink('98311'); return false;"><b>19.11</b>NOV</a>
			</li>

			<% if currentdate < "2019-12-01" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="99015"," current","")%>">
			<% End If %>
				<a href="" onclick="goEventLink('99015'); return false;"><b>19.12</b>DEC</a>
			</li>

			<% if currentdate < "2020-01-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.01</b>JAN</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="99736"," current","")%>">
				<a href="" onclick="goEventLink('99736'); return false;"><b>20.01</b>JAN</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-02-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.02</b>FEB</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="100275"," current","")%>">
				<a href="" onclick="goEventLink('100275'); return false;"><b>20.02</b>FEB</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-03-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.03</b>MAR</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="100919"," current","")%>">
				<a href="" onclick="goEventLink('100919'); return false;"><b>20.03</b>MAR</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-04-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.04</b>APR</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="101739"," current","")%>">
				<a href="" onclick="goEventLink('101739'); return false;"><b>20.04</b>APR</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-05-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.05</b>MAY</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="102412"," current","")%>">
				<a href="" onclick="goEventLink('102412'); return false;"><b>20.05</b>MAY</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-06-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.06</b>JUN</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="103062"," current","")%>">
				<a href="" onclick="goEventLink('103062'); return false;"><b>20.06</b>JUN</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-07-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.07</b>JULY</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="103875"," current","")%>">
				<a href="" onclick="goEventLink('103875'); return false;"><b>20.07</b>JULY</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-08-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.08</b>AUG</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="104696"," current","")%>">
				<a href="" onclick="goEventLink('104696'); return false;"><b>20.08</b>AUG</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-09-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.09</b>SEP</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="105290"," current","")%>">
				<a href="" onclick="goEventLink('105290'); return false;"><b>20.09</b>SEP</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-10-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.10</b>OCT</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="106362"," current","")%>">
				<a href="" onclick="goEventLink('106362'); return false;"><b>20.10</b>OCT</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-11-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.11</b>NOV</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="106363"," current","")%>">
				<a href="" onclick="goEventLink('106363'); return false;"><b>20.11</b>NOV</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-12-01" then %>
			<li class="swiper-slide coming">
				<a><b>20.12</b>DEC</a>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="106364"," current","")%>">
				<a href="" onclick="goEventLink('106364'); return false;"><b>20.12</b>DEC</a>
			<% End If %>
			</li>
		</ul>
	</div>
	<button class="btnPrev">이전</button>
	<button class="btnNext">다음</button>
</div>
</body>
</html>