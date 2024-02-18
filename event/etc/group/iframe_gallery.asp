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

	If vEventID = "111853" Then '// 14일
		vStartNo = "0"
	ElseIf vEventID = "111883" Then '// 15일
		vStartNo = "1"
	ElseIf vEventID = "111884" Then '// 16일
		vStartNo = "2"
	ElseIf vEventID = "111922" Then '// 17일
		vStartNo = "3"
	ElseIf vEventID = "111995" Then '// 18일
		vStartNo = "4"
	ElseIf vEventID = "112009" Then '// 21일
		vStartNo = "5"
	ElseIf vEventID = "112010" Then '// 22일
		vStartNo = "6"
	ElseIf vEventID = "112011" Then '// 23일
		vStartNo = "7"
	ElseIf vEventID = "112012" Then '// 24일
		vStartNo = "8"
	ElseIf vEventID = "112013" Then '// 25일
		vStartNo = "9"
	ElseIf vEventID = "112014" Then '// 28일
		vStartNo = "10"
	ElseIf vEventID = "112016" Then '// 29일
		vStartNo = "11"
	ElseIf vEventID = "112017" Then '// 30일
		vStartNo = "12"
	ElseIf vEventID = "112178" Then '// 7/1일
		vStartNo = "13"
	ElseIf vEventID = "112231" Then '// 2일
		vStartNo = "14"
	ElseIf vEventID = "112245" Then '// 5일
		vStartNo = "15"
	ElseIf vEventID = "112246" Then '// 7일
		vStartNo = "16"
	ElseIf vEventID = "112247" Then '// 9일
		vStartNo = "17"
	ElseIf vEventID = "112248" Then '// 12일
		vStartNo = "18"
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
.monthTab {position:relative; width:100%;height:12rem;background:url(//webimage.10x10.co.kr/fixevent/event/2021/<%=vEventID%>/m/date_area.jpg)no-repeat 0 0;background-size:100%;}
.monthTab .swiper-container {width:40%; padding-top:4.5rem;float:right;margin-right:1.5rem;}
.monthTab .swiper-container:before {content:''; position:absolute; top:0; left:0; height:100%; width:0.2rem; z-index:97;}
.monthTab .swiper-container:after {content:''; position:absolute; top:0; right:0; height:100%; width:0.2rem; z-index:97;}
.monthTab ul {margin:0 auto; z-index:96;}
.monthTab li {float:left;}
.monthTab li a, .monthTab li span {display:block; position:relative; width:100%; height:2rem; line-height:2rem; text-align:center; font-size:1.6em; color:#fff; font-weight:500;}
.monthTab li.current a {color:#00FFD2; font-weight:bold;}
.monthTab li.current a.color_16{color:#e9ff6f;}
.monthTab li.current a.color_18{color:#e0ff34;}
.monthTab li.current a.color_21{color:#b0d7fc;}
.monthTab li.current a.color_22{color:#fff497;}
.monthTab li.current a.color_23{color:#adffa9;}
.monthTab li.current a.color_24{color:#faff68;}
.monthTab li.current a.color_29{color:#e3ff72;}
.monthTab li.current a.color_30{color:#f7ff72;}
.monthTab li.current a.color_1{color:#fff005;}
.monthTab li.current a.color_2{color:#c7eaff;}
.monthTab li.current a.color_5{color:#f7ff72;}
.monthTab li.current a.color_7{color:#e2ff8b;}
.monthTab li.current a.color_9{color:#f7ff72;}
.monthTab button {display:block; position:absolute; top:3rem; z-index:20; width:3.5%; height:4.85rem; background:transparent;}
.monthTab button.btnPrev {right:16.5rem;}
.monthTab button.btnPrev:after {left:0rem;}
.monthTab button.btnNext {right:.5rem;}
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
		alert("아직 오픈전입니다. 해당 이벤트는 내일 확인해주세요.");
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
			
			<% if currentdate < "2021-06-14" then %>
			<li class="swiper-slide coming">
				<span>14</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="111853"," current","")%>">
				<a href="" onclick="goEventLink('111853'); return false;">14</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-15" then %>
			<li class="swiper-slide coming">
				<span>15</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="111883"," current","")%>">
				<a href="" onclick="goEventLink('111883'); return false;">15</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-16" then %>
			<li class="swiper-slide coming">
				<span>16</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="111884"," current","")%>">
				<a href="" onclick="goEventLink('111884'); return false;" class="color_16">16</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-17" then %>
			<li class="swiper-slide coming">
				<span>17</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="111922"," current","")%>">
				<a href="" onclick="goEventLink('111922'); return false;" class="color_16">17</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-18" then %>
			<li class="swiper-slide coming">
				<span>18</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="111995"," current","")%>">
				<a href="" onclick="goEventLink('111995'); return false;" class="color_18">18</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-21" then %>
			<li class="swiper-slide coming">
				<span>21</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112009"," current","")%>">
				<a href="" onclick="goEventLink('112009'); return false;" class="color_21">21</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-22" then %>
			<li class="swiper-slide coming">
				<span>22</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112010"," current","")%>">
				<a href="" onclick="goEventLink('112010'); return false;" class="color_22">22</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-23" then %>
			<li class="swiper-slide coming">
				<span>23</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112011"," current","")%>">
				<a href="" onclick="goEventLink('112011'); return false;" class="color_23">23</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-24" then %>
			<li class="swiper-slide coming">
				<span>24</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112012"," current","")%>">
				<a href="" onclick="goEventLink('112012'); return false;" class="color_24">24</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-25" then %>
			<li class="swiper-slide coming">
				<span>25</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112013"," current","")%>">
				<a href="" onclick="goEventLink('112013'); return false;" class="color_24">25</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-28" then %>
			<li class="swiper-slide coming">
				<span>28</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112014"," current","")%>">
				<a href="" onclick="goEventLink('112014'); return false;" class="color_24">28</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-29" then %>
			<li class="swiper-slide coming">
				<span>29</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112016"," current","")%>">
				<a href="" onclick="goEventLink('112016'); return false;" class="color_29">29</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-06-30" then %>
			<li class="swiper-slide coming">
				<span>30</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112017"," current","")%>">
				<a href="" onclick="goEventLink('112017'); return false;" class="color_30">30</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-07-01" then %>
			<li class="swiper-slide coming">
				<span>1</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112178"," current","")%>">
				<a href="" onclick="goEventLink('112178'); return false;" class="color_1">1</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-07-02" then %>
			<li class="swiper-slide coming">
				<span>2</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112231"," current","")%>">
				<a href="" onclick="goEventLink('112231'); return false;" class="color_2">2</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-07-05" then %>
			<li class="swiper-slide coming">
				<span>5</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112245"," current","")%>">
				<a href="" onclick="goEventLink('112245'); return false;" class="color_5">5</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-07-07" then %>
			<li class="swiper-slide coming">
				<span>7</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112246"," current","")%>">
				<a href="" onclick="goEventLink('112246'); return false;" class="color_7">7</a>
			<% End If %>
			</li>

			<% if currentdate < "2021-07-09" then %>
			<li class="swiper-slide coming">
				<span>9</span>
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="112247"," current","")%>">
				<a href="" onclick="goEventLink('112247'); return false;" class="color_9">9</a>
			<% End If %>
			</li>
			
		</ul>
	</div>
	<button class="btnPrev"><img src="http://webimage.10x10.co.kr/fixevent/event/2021/111853/m/btn_prev.png" alt="이전"></button>
	<button class="btnNext"><img src="http://webimage.10x10.co.kr/fixevent/event/2021/111853/m/btn_next.png" alt="다음"></button>
</div>
</body>
</html>