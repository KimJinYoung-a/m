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

	If vEventID = "90691" Then '// 12월
		vStartNo = "0"
	ElseIf vEventID = "91631" Then '// 1월
		vStartNo = "0"
	ElseIf vEventID = "92378" Then '// 2월
		vStartNo = "1"
	ElseIf vEventID = "92873" Then '// 3월
		vStartNo = "2"
	ElseIf vEventID = "93618" Then '// 4월
		vStartNo = "3"
	ElseIf vEventID = "94259" Then '// 5월
		vStartNo = "4"
	ElseIf vEventID = "95103" Then '// 6월
		vStartNo = "5"
	ElseIf vEventID = "95698" Then '// 7월
		vStartNo = "6"
	ElseIf vEventID = "96535" Then '// 8월
		vStartNo = "7"
	ElseIf vEventID = "97185" Then '// 9월
		vStartNo = "8"
	ElseIf vEventID = "97793" Then '// 10월
		vStartNo = "9"
	ElseIf vEventID = "98410" Then '// 11월
		vStartNo = "10"
	ElseIf vEventID = "99103" Then '// 12월
		vStartNo = "11"
	ElseIf vEventID = "99708" Then '// 1월
		vStartNo = "12"
	ElseIf vEventID = "100282" Then '// 2월
		vStartNo = "13"
	ElseIf vEventID = "101008" Then '// 3월
		vStartNo = "14"
	ElseIf vEventID = "102453" Then '// 5월
		vStartNo = "15"
	ElseIf vEventID = "103133" Then '// 6월
		vStartNo = "16"	
	ElseIf vEventID = "104157" Then '// 7월
		vStartNo = "17"	
	ElseIf vEventID = "104770" Then '// 8월
		vStartNo = "18"
	ElseIf vEventID = "105425" Then '// 9월
		vStartNo = "19"
	ElseIf vEventID = "106341" Then '// 10월
		vStartNo = "20"
	ElseIf vEventID = "106998" Then '// 11월
		vStartNo = "21"
	ElseIf vEventID = "107947" Then '// 12월
		vStartNo = "22"
	ElseIf vEventID = "108695" Then '// 1월
		vStartNo = "23"
    ElseIf vEventID = "109266" Then '// 2월
        vStartNo = "24"
    ElseIf vEventID = "109739" Then '// 3월
        vStartNo = "25"
    ElseIf vEventID = "110259" Then '// 4월
        vStartNo = "26"
    ElseIf vEventID = "110996" Then '// 5월
        vStartNo = "27"
	ElseIf vEventID = "111387" Then '// 6월
        vStartNo = "28"
	ElseIf vEventID = "112278" Then '// 7월
        vStartNo = "29"
	ElseIf vEventID = "113022" Then '// 8월
        vStartNo = "30"
	ElseIf vEventID = "113686" Then '// 9월
        vStartNo = "31"
	ElseIf vEventID = "114091" Then '// 10월
        vStartNo = "32"
    ElseIf vEventID = "115003" Then '// 11월
        vStartNo = "33"
    ElseIf vEventID = "115416" Then '// 12월
        vStartNo = "34"
	ElseIf vEventID = "116218" Then '// 1월
        vStartNo = "35"
    ElseIf vEventID = "116610" Then '// 2월
        vStartNo = "36"
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
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; background-color:#fff;}
.monthTab {position:relative; width:100%;}
.monthTab .swiper-container {width:88%; padding-top:1.5rem;}
.monthTab .swiper-container:before {content:''; position:absolute; top:0; left:0; height:100%; width:0.2rem; background-color:#fff; z-index:97;}
.monthTab .swiper-container:after {content:''; position:absolute; top:0; right:0; height:100%; width:0.2rem; background-color:#fff; z-index:97;}
.monthTab ul {margin:0 auto; z-index:96;}
.monthTab li {float:left;}
.monthTab li a, .monthTab li span {display:block; position:relative; width:100%; height:2rem; line-height:2rem; text-align:center; font-size:1.4em; color:#999; font-weight:500;}
.monthTab li a:after, .monthTab li span:after {content:''; position:absolute; right:0; height:100%; width:0.1rem; background-color:#999;}
.monthTab li.current a {color:#000; font-weight:bold;}
.monthTab button {display:block; position:absolute; top:-0.3rem; z-index:20; width:7.5%; height:4.85rem; background-color:transparent; text-indent:-999em; outline:0;}
.monthTab button:after {content:''; display:inline-block; position:absolute; top:50%; width:0; height:0; margin-top:-0.25rem; border-style: solid; border-width:0.5rem 0.6rem 0.5rem 0;border-color:transparent #252525 transparent transparent;}
.monthTab button.btnPrev {left:1.5rem;}
.monthTab button.btnPrev:after {left:0rem;}
.monthTab button.btnNext {right:1.5rem;}
.monthTab button.btnNext:after {right:0rem; transform:rotate(180deg); -webkit-transform:rotate(180deg);}
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
			
			<% if currentdate < "2018-11-28" then %>
			<li class="swiper-slide coming">
				<span>12월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="90691"," current","")%>">
				<a href="" onclick="goEventLink('90691'); return false;">12월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-01-03" then %>
			<li class="swiper-slide coming">
				<span>1월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="91631"," current","")%>">
				<a href="" onclick="goEventLink('91631'); return false;">1월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-02-07" then %>
			<li class="swiper-slide coming">
				<span>2월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="92378"," current","")%>">
				<a href="" onclick="goEventLink('92378'); return false;">2월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-03-06" then %>
			<li class="swiper-slide coming">
				<span>3월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="92873"," current","")%>">
				<a href="" onclick="goEventLink('92873'); return false;">3월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-04-10" then %>
			<li class="swiper-slide coming">
				<span>4월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="93618"," current","")%>">
				<a href="" onclick="goEventLink('93618'); return false;">4월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-05-15" then %>
			<li class="swiper-slide coming">
				<span>5월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="94259"," current","")%>">
				<a href="" onclick="goEventLink('94259'); return false;">5월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-06-12" then %>
			<li class="swiper-slide coming">
				<span>6월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="95103"," current","")%>">
				<a href="" onclick="goEventLink('95103'); return false;">6월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-07-02" then %>
			<li class="swiper-slide coming">
				<span>7월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="95698"," current","")%>">
				<a href="" onclick="goEventLink('95698'); return false;">7월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-08-06" then %>
			<li class="swiper-slide coming">
				<span>8월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="96535"," current","")%>">
				<a href="" onclick="goEventLink('96535'); return false;">8월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-09-06" then %>
			<li class="swiper-slide coming">
				<span>9월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="97185"," current","")%>">
				<a href="" onclick="goEventLink('97185'); return false;">9월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-10-08" then %>
			<li class="swiper-slide coming">
				<span>10월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="97793"," current","")%>">
				<a href="" onclick="goEventLink('97793'); return false;">10월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-11-06" then %>
			<li class="swiper-slide coming">
				<span>11월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="98410"," current","")%>">
				<a href="" onclick="goEventLink('98410'); return false;">11월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2019-12-05" then %>
			<li class="swiper-slide coming">
				<span>12월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="99103"," current","")%>">
				<a href="" onclick="goEventLink('99103'); return false;">12월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-01-01" then %>
			<li class="swiper-slide coming">
				<span>1월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="99708"," current","")%>">
				<a href="" onclick="goEventLink('99708'); return false;">1월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-02-01" then %>
			<li class="swiper-slide coming">
				<span>2월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="100282"," current","")%>">
				<a href="" onclick="goEventLink('100282'); return false;">2월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-03-01" then %>
			<li class="swiper-slide coming">
				<span>3월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="101008"," current","")%>">
				<a href="" onclick="goEventLink('101008'); return false;">3월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-05-01" then %>
			<li class="swiper-slide coming">
				<span>5월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="102453"," current","")%>">
				<a href="" onclick="goEventLink('102453'); return false;">5월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-06-01" then %>
			<li class="swiper-slide coming">
				<span>6월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="103133"," current","")%>">
				<a href="" onclick="goEventLink('103133'); return false;">6월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-07-07" then %>
			<li class="swiper-slide coming">
				<span>7월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="104157"," current","")%>">
				<a href="" onclick="goEventLink('104157'); return false;">7월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-08-01" then %>
			<li class="swiper-slide coming">
				<span>8월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="104770"," current","")%>">
				<a href="" onclick="goEventLink('104770'); return false;">8월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-09-01" then %>
			<li class="swiper-slide coming">
				<span>9월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="105425"," current","")%>">
				<a href="" onclick="goEventLink('105425'); return false;">9월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-10-01" then %>
			<li class="swiper-slide coming">
				<span>10월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="106341"," current","")%>">
				<a href="" onclick="goEventLink('106341'); return false;">10월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-11-01" then %>
			<li class="swiper-slide coming">
				<span>11월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="106998"," current","")%>">
				<a href="" onclick="goEventLink('106998'); return false;">11월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2020-12-01" then %>
			<li class="swiper-slide coming">
				<span>12월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="107947"," current","")%>">
				<a href="" onclick="goEventLink('107947'); return false;">12월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-01-01" then %>
			<li class="swiper-slide coming">
				<span>1월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="108695"," current","")%>">
				<a href="" onclick="goEventLink('108695'); return false;">1월호</a>
			<% End If %>
			</li>

            <% if currentdate < "2021-02-01" then %>
			<li class="swiper-slide coming">
				<span>2월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="109266"," current","")%>">
				<a href="" onclick="goEventLink('109266'); return false;">2월호</a>
			<% End If %>
			</li>

            <% if currentdate < "2021-03-01" then %>
			<li class="swiper-slide coming">
				<span>3월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="109739"," current","")%>">
				<a href="" onclick="goEventLink('109739'); return false;">3월호</a>
			<% End If %>
			</li>

            <% if currentdate < "2021-04-01" then %>
			<li class="swiper-slide coming">
				<span>4월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="110259"," current","")%>">
				<a href="" onclick="goEventLink('110259'); return false;">4월호</a>
			<% End If %>
			</li>

            <% if currentdate < "2021-05-01" then %>
			<li class="swiper-slide coming">
				<span>5월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="110996"," current","")%>">
				<a href="" onclick="goEventLink('110996'); return false;">5월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-01" then %>
			<li class="swiper-slide coming">
				<span>6월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="111387"," current","")%>">
				<a href="" onclick="goEventLink('111387'); return false;">6월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-07-01" then %>
			<li class="swiper-slide coming">
				<span>7월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112278"," current","")%>">
				<a href="" onclick="goEventLink('112278'); return false;">7월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-08-01" then %>
			<li class="swiper-slide coming">
				<span>8월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="113022"," current","")%>">
				<a href="" onclick="goEventLink('113022'); return false;">8월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-09-01" then %>
			<li class="swiper-slide coming">
				<span>9월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="113686"," current","")%>">
				<a href="" onclick="goEventLink('113686'); return false;">9월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-10-01" then %>
			<li class="swiper-slide coming">
				<span>10월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="114091"," current","")%>">
				<a href="" onclick="goEventLink('114091'); return false;">10월호</a>
			<% End If %>
			</li>

            <% if currentdate < "2021-11-01" then %>
			<li class="swiper-slide coming">
				<span>11월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="115003"," current","")%>">
				<a href="" onclick="goEventLink('115003'); return false;">11월호</a>
			<% End If %>
			</li>

            <% if currentdate < "2021-12-01" then %>
			<li class="swiper-slide coming">
				<span>12월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="115416"," current","")%>">
				<a href="" onclick="goEventLink('115416'); return false;">12월호</a>
			<% End If %>
			</li>

			<% if currentdate < "2022-01-01" then %>
			<li class="swiper-slide coming">
				<span>1월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="116218"," current","")%>">
				<a href="" onclick="goEventLink('116218'); return false;">1월호</a>
			<% End If %>
			</li>

            <% if currentdate < "2022-02-01" then %>
			<li class="swiper-slide coming">
				<span>2월호</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="116610"," current","")%>">
				<a href="" onclick="goEventLink('116610'); return false;">2월호</a>
			<% End If %>
			</li>
		</ul>
	</div>
	<button class="btnPrev">이전</button>
	<button class="btnNext">다음</button>
</div>
</body>
</html>