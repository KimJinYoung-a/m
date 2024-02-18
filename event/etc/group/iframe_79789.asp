<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 핑크스타그램2
' History : 2017-08-09 유태욱 생성
'####################################################
%>
<%
Dim currentdate, vEventID
	currentdate = date()
'	currentdate = "2017-08-10"
	vEventID = requestCheckVar(Request("eventid"),9)
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
html, body {position:absolute; top:0; left:0; right:0; backface-visibility:visible; -webkit-backface-visibility:visible; font-size:11px;}
.pinkSeries button {background-color:transparent;}
.pinkSeries {position:relative; width:100%; margin:0 auto; height:4.2rem; padding:0 ; background-color:#e13874;}
.pinkSeries li.swiper-slide {display:table; height:4.2rem; text-align:center;}
.pinkSeries li.swiper-slide:after {display:inline-block; position:absolute; width:2px; height:1.8rem; left:-1px; top:1.2rem; content:' '; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79789/m/bg_line.jpg); background-size:100%;}
.pinkSeries li.swiper-slide:first-child {margin-left:-7%;}
.pinkSeries li.swiper-slide a {display:table-cell; position:relative; width:100%; height:1.8rem; padding-top:.3rem; vertical-align:middle; font-size:1.4rem;color:#ed9aba; font-weight:bold;}
.pinkSeries li.swiper-slide a span {display:none;}
.pinkSeries li.swiper-slide.on {width:50% !important;}
.pinkSeries li.swiper-slide.on a {color:#fff;}
.pinkSeries li.swiper-slide.on a span{display:inline-block; margin-left:.5rem; font-size:1.2rem; font-weight:normal;}
</style>
</head>
<body>
<script type="text/javascript">
function goEventLink(evt) {
	<% if isApp then %>
		parent.location.href='/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+evt;
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
	<div class="pinkSeries">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">
					<li class="swiper-slide pink-slide-1 <% if vEventID = "79660" then %> on<% end if %>">
						<a href="" onclick="goEventLink('79660'); return false;">01<br/><span>#멍이멍이쿨매트</span></a>
					</li>

					<li class="swiper-slide pink-slide-2 <% if vEventID = "79789" then %> on<% end if %>">
						<% If currentdate >= "2017-08-10" Then %>
							<a href="" onclick="goEventLink('79789'); return false;">02<br/><span>#FRITZ 콜드브루</span></a>
						<% else %> 
							<a href="" onclick="return false;">02<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-3 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-08-17" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">03<br/><span>#BIC핑크볼펜</span></a>
						<% else %>
							<a href="" onclick="return false;">03<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-4 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-08-24" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">04<span></span></a>
						<% else %>
							<a href="" onclick="return false;">04<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-5 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-08-31" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">05<span></span></a>
						<% else %>
							<a href="" onclick="return false;">05<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-6 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-09-07" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">06<span></span></a>
						<% else %>
							<a href="" onclick="return false;">06<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-7 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-09-14" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">07<span></span></a>
						<% else %>
							<a href="" onclick="return false;">07<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-8 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-09-21" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">08<span></span></a>
						<% else %>
							<a href="" onclick="return false;">08<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-9 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-09-28" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">09<span></span></a>
						<% else %>
							<a href="" onclick="return false;">09<br/><span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-10 <% if vEventID = "99999" then %> on<% end if %>">
						<% If currentdate >= "2017-10-05" Then %>
							<a href="" onclick="goEventLink('99999'); return false;">10<span></span></a>
						<% else %>
							<a href="" onclick="return false;">10<br/><span></span></a>
						<% end if %>
					</li>
				</ul>
			</div>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	pinkSwiper = new Swiper('.pinkSeries .swiper-container',{
		initialSlide:1,
		centeredSlides:true,
		slidesPerView:3,
		speed:300,
		prevButton:'.pinkSeries .btnPrev',
		nextButton:'.pinkSeries .btnNext'
	});

});
</script>
</body>
</html>