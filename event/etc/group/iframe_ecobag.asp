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

	If vEventID = "77954" Then '// 5월
		vStartNo = "0"
	ElseIf vEventID = "78366" Then '// 6월
		vStartNo = "0"
	ElseIf vEventID = "79244" Then '// 7월
		vStartNo = "1"
	ElseIf vEventID = "79952" Then '// 8월
		vStartNo = "2"
	ElseIf vEventID = "80552" Then '// 9월
		vStartNo = "3"
	ElseIf vEventID = "81098" Then '// 10월
		vStartNo = "4"
	ElseIf vEventID = "81543" Then '// 11월
		vStartNo = "5"
	ElseIf vEventID = "82985" Then '// 12월
		vStartNo = "6"
	ElseIf vEventID = "86441" Then '// 2018년 5월
		vStartNo = "7"
	ElseIf vEventID = "87368" Then '// 2018년 6월
		vStartNo = "8"
	ElseIf vEventID = "88116" Then '// 2018년 7월
		vStartNo = "9"
	ElseIf vEventID = "88904" Then '// 2018년 9월
		vStartNo = "10"
	ElseIf vEventID = "90218" Then '// 2018년 10월
		vStartNo = "10"
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
.monthTab {position:relative; width:100%; height:5.5rem; padding:0 7.5%; background:url(http://webimage.10x10.co.kr/eventIMG/2017/77954/m/bg_line.png) repeat-x 0 0; background-size:1px auto;}
.monthTab:before,
.monthTab:after {content:''; display:inline-block; position:absolute; top:10%; z-index:10; width:0.8rem; height:75%; background-color:#fff;}
.monthTab:before {right:7%;}
.monthTab:after {left:7%;}
.monthTab li {display:table; height:5.5rem; text-align:center;}
.monthTab li p {position:relative; display:table-cell; height:5rem; padding-top:0.3rem; font-size:1.3rem; letter-spacing:1px; vertical-align:middle; color:#999;}
.monthTab li p:after {content:''; display:inline-block; position:absolute; right:0; top:50%; z-index:10; width:0.1rem; height:2rem; margin-top:-0.9rem; background-color:#d1d1d1;}
.monthTab li:last-child p:after {display:none;}
.monthTab li p span {display:none; padding-top:0.2rem; font:normal 1.2rem/1 tahoma; letter-spacing:0;}
.monthTab li p a {display:none; position:absolute; left:0; top:0; width:100%; height:100%; text-indent:-999em;}
.monthTab li.current:before {content:''; display:inline-block; position:absolute; left:50%; bottom:-0.01rem; z-index:30; width:0; height:0; border-style: solid; border-width:0.5rem 0.4rem 0 0.4rem;border-color:#252525 transparent transparent transparent;}
.monthTab li.current:after {content:''; display:inline-block; position:absolute; left:0; bottom:0.5rem; z-index:30; width:98%; height:0.2rem; background:#252525; }
.monthTab li.current p {color:#252525; font-weight:bold;}
.monthTab li.current p span,
.monthTab li.current p a {display:block;}
.monthTab li.open p span,
.monthTab li.open p a {display:block;}
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
			<% if currentdate < "2017-05-17" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="77954"," current","")%>">
			<% End If %>
				<p>
					#5월호<span>ITHINKSO</span>
					<a href="" onclick="goEventLink('77954'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2017-06-14" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="78366"," current","")%>">
			<% End If %>
				<p>
					#6월호<span>ATTICMERMAID</span>
					<a href="" onclick="goEventLink('78366'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2017-07-19" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="79244"," current","")%>">
			<% End If %>
				<p>
					#7월호<span>W/W</span>
					<a href="" onclick="goEventLink('79244'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2017-08-23" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="79952"," current","")%>">
			<% End If %>
				<p>
					#8월호<span>BRENDA BRENDEN</span>
					<a href="" onclick="goEventLink('79952'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2017-09-19" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="80552"," current","")%>">
			<% End If %>
				<p>
					#9월호<span>HEVITZ</span>
					<a href="" onclick="goEventLink('80552'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2017-10-11" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="81098"," current","")%>">
			<% End If %>
				<p>
					#10월호<span>ithinkso</span>
					<a href="" onclick="goEventLink('81098'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2017-10-31" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide open <%=CHKIIF(vEventID="81543"," current","")%>">
			<% End If %>
				<p>
					#11월호<span>LVEB</span>
					<a href="" onclick="goEventLink('81543'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2017-12-14" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide soldout open <%=CHKIIF(vEventID="82985"," current","")%>">
			<% End If %>
				<p>
					#12월호<span>uncommon things</span>
					<a href="" onclick="goEventLink('82985'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-05-14" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide soldout open <%=CHKIIF(vEventID="86441"," current","")%>">
			<% End If %>
				<p>
					#5월호<span>ITHINKSO</span>
					<a href="" onclick="goEventLink('86441'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-06-25" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide soldout open <%=CHKIIF(vEventID="87368"," current","")%>">
			<% End If %>
				<p>
					#6월호<span>YURT</span>
					<a href="" onclick="goEventLink('87368'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-07-26" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide soldout open <%=CHKIIF(vEventID="88116"," current","")%>">
			<% End If %>
				<p>
					#7월호<span>LAZY LOUNGE</span>
					<a href="" onclick="goEventLink('88116'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-08-28" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide soldout open <%=CHKIIF(vEventID="88904"," current","")%>">
			<% End If %>
				<p>
					#9월호<span>MARYMOND</span>
					<a href="" onclick="goEventLink('88904'); return false;">이벤트 바로가기</a>
				</p>
			</li>

			<% if currentdate < "2018-11-05" then %>
			<li class="swiper-slide">
			<% Else %>
			<li class="swiper-slide soldout open <%=CHKIIF(vEventID="90218"," current","")%>">
			<% End If %>
				<p>
					#11월호<span>RAWROW</span>
					<a href="" onclick="goEventLink('90218'); return false;">이벤트 바로가기</a>
				</p>
			</li>

		</ul>
	</div>
	<button class="btnPrev">이전</button>
	<button class="btnNext">다음</button>
</div>
</body>
</html>