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

	If vEventID = "89316" Then '// vol.1
		vStartNo = "0"
	ElseIf vEventID = "89423" Then '// vol.2
		vStartNo = "0"
	ElseIf vEventID = "89628" Then '// vol.3
		vStartNo = "1"
	ElseIf vEventID = "89817" Then '// vol.4
		vStartNo = "2"
	ElseIf vEventID = "89818" Then '// vol.5
		vStartNo = "3"
	ElseIf vEventID = "90070" Then '// vol.6
		vStartNo = "4"
	ElseIf vEventID = "90249" Then '// vol.7
		vStartNo = "5"
	ElseIf vEventID = "90582" Then '// vol.8
		vStartNo = "6"
	ElseIf vEventID = "90718" Then '// vol.9
		vStartNo = "7"
	ElseIf vEventID = "90879" Then '// vol.10
		vStartNo = "8"
	ElseIf vEventID = "90871" Then '// vol.11
		vStartNo = "9"
	ElseIf vEventID = "91292" Then '// vol.12
		vStartNo = "10"
	ElseIf vEventID = "91894" Then '// vol.13
		vStartNo = "11"
	ElseIf vEventID = "92235" Then '// vol.14
		vStartNo = "12"
	ElseIf vEventID = "93796" Then '// vol.15
		vStartNo = "13"
	ElseIf vEventID = "93883" Then '// vol.16
		vStartNo = "14"
	ElseIf vEventID = "93887" Then '// vol.17
		vStartNo = "15"
	ElseIf vEventID = "94995" Then '// vol.18
		vStartNo = "16"
	ElseIf vEventID = "95454" Then '// vol.19
		vStartNo = "17"
	ElseIf vEventID = "95779" Then '// vol.20
		vStartNo = "18"
	ElseIf vEventID = "95898" Then '// vol.21
		vStartNo = "19"
	ElseIf vEventID = "96769" Then '// vol.22
		vStartNo = "20"
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
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible;}
.monthTab {position:relative; width:100%; height:5.5rem; padding:0 7.5%; background:url(//webimage.10x10.co.kr/eventIMG/2017/77954/m/bg_line.png) repeat-x 0 0; background-size:1px auto;}
.monthTab:before,
.monthTab:after {content:''; display:inline-block; position:absolute; top:10%; z-index:10; width:0.8rem; height:75%; background-color:#fff;}
.monthTab:before {right:7%;}
.monthTab:after {left:7%;}
.monthTab li {height:5.5rem; text-align:center;}
.monthTab li p {position:relative; width:100%; height:5rem; padding-top:2rem; font-size:1.3rem; letter-spacing:1px; color:#999;}
.monthTab li p:after {content:''; display:inline-block; position:absolute; right:0; top:50%; z-index:10; width:0.1rem; height:2rem; margin-top:-0.9rem; background-color:#d1d1d1;}
.monthTab li:last-child p:after {display:none;}
.monthTab li p span {display:none; padding-top:0.2rem; font:normal 1.1rem/1 tahoma; letter-spacing:0;}
.monthTab li p span em {color:#e871ff;}
.monthTab li p a {display:none; position:absolute; left:0; top:0; width:100%; height:100%; text-indent:-999em;}
.monthTab li.current:before {content:''; display:inline-block; position:absolute; left:50%; bottom:-0.01rem; z-index:30; width:0; height:0; margin-left:-.3rem; border-style: solid; border-width:0.5rem 0.4rem 0 0.4rem;border-color:#252525 transparent transparent transparent;}
.monthTab li.current:after {content:''; display:inline-block; position:absolute; left:0; bottom:0.5rem; z-index:30; width:98%; height:0.2rem; background:#252525; }
.monthTab li.current p {padding-top:1.3rem; color:#252525; font-weight:bold;}
.monthTab li.current p span,
.monthTab li.current p a {display:block;}
.monthTab li.open p a {display:block; height:100%;}
.monthTab button {display:block; position:absolute; top:0.1rem; z-index:20; width:7.5%; height:4.85rem; background-color:transparent; text-indent:-999em; outline:0;}
.monthTab button:after {content:''; display:inline-block; position:absolute; top:50%; width:0; height:0; margin-top:-0.25rem; border-style: solid; border-width:0.5rem 0.6rem 0.5rem 0;border-color:transparent #252525 transparent transparent;}
.monthTab button.btnPrev {left:1rem;}
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
			<% if currentdate < "2018-09-18" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="89316"," current","")%>">
			<% End If %>
				<p>
					vol.1<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('89316'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-09-24" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="89423"," current","")%>">
			<% End If %>
 				<p>
					vol.2<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('89423'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-10-08" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="89628"," current","")%>">
			<% End If %>
				<p>
					vol.3<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('89628'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-10-15" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="89817"," current","")%>">
			<% End If %>
				<p>
					vol.4<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('89817'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-10-22" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="89818"," current","")%>">
			<% End If %>
				<p>
					vol.5<span>다꾸 <em>채널</em></span>
					<a href="" onclick="goEventLink('89818'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-10-29" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="90070"," current","")%>">
			<% End If %>
				<p>
					vol.6<span>다꾸 <em>채널</em></span>
					<a href="" onclick="goEventLink('90070'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-11-12" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="90249"," current","")%>">
			<% End If %>
				<p>
					vol.7<span>다꾸 <em>채널</em></span>
					<a href="" onclick="goEventLink('90249'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-11-19" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="90582"," current","")%>">
			<% End If %>
				<p>
					vol.8<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('90582'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-11-26" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="90718"," current","")%>">
			<% End If %>
				<p>
					vol.9<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('90718'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-12-03" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="90879"," current","")%>">
			<% End If %>
				<p>
					vol.10<span>다꾸 <em>채널</em></span>
					<a href="" onclick="goEventLink('90879'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-12-10" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="90871"," current","")%>">
			<% End If %>
				<p>
					vol.11<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('90871'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-12-17" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="91292"," current","")%>">
			<% End If %>
				<p>
					vol.12<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('91292'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-01-14" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="91894"," current","")%>">
			<% End If %>
				<p>
					vol.13<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('91894'); return false;">이벤트 바로가기</a>
				</p>
			</li> 

			<% if currentdate < "2019-01-28" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="92235"," current","")%>">
			<% End If %>
				<p>
					vol.14<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('92235'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-04-11" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="93796"," current","")%>">
			<% End If %>
				<p>
					vol.15<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('93796'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-04-18" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="93883"," current","")%>">
			<% End If %>
				<p>
					vol.16<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('93883'); return false;">이벤트 바로가기</a>
				</p>
			</li> 

			<% if currentdate < "2019-04-19" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="93887"," current","")%>">
			<% End If %>
				<p>
					vol.17<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('93887'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-06-03" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="94995"," current","")%>">
			<% End If %>
				<p>
					vol.18<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('94995'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-06-26" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="95454"," current","")%>">
			<% End If %>
				<p>
					vol.19<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('95454'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-07-10" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="95779"," current","")%>">
			<% End If %>
				<p>
					vol.20<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('95779'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-07-24" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="95898"," current","")%>">
			<% End If %>
				<p>
					vol.21<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('95898'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-08-21" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="96769"," current","")%>">
			<% End If %>
				<p>
					vol.22<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('96769'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-12-24" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="00000"," current","")%>">
			<% End If %>
				<p>
					vol.23<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('00000'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2019-12-24" then %>
			<li class="swiper-slide coming">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="00000"," current","")%>">
			<% End If %>
				<p>
					vol.24<span>다꾸 <em> 채널</em></span>
					<a href="" onclick="goEventLink('00000'); return false;">이벤트 바로가기</a>
				</p>
			</li>
		</ul>
	</div>
	<button class="btnPrev">이전</button>
	<button class="btnNext">다음</button>
</div>
</body>
</html>