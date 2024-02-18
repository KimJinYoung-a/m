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
%><%
dim currentdate
	currentdate = date()
	'currentdate = "2017-09-05"

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
	If vEventID = "79660" Then
		vStartNo = "0"
	ElseIf vEventID = "79789" Then
		vStartNo = "0"
	ElseIf vEventID = "79931" Then
		vStartNo = "1"
	ElseIf vEventID = "79988" Then
		vStartNo = "2"
	ElseIf vEventID = "80212" Then
		vStartNo = "3"
	ElseIf vEventID = "81371" Then
		vStartNo = "4"
	ElseIf vEventID = "82474" Then
		vStartNo = "5"
	ElseIf vEventID = "83112" Then
		vStartNo = "6"
	ElseIf vEventID = "83997" Then
		vStartNo = "7"
	ElseIf vEventID = "84271" Then
		vStartNo = "8"
	End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.pinkSeries {position:relative; margin:0 auto; text-align:center; background-color:#e13874;}
.pinkSeries li.swiper-slide {display:table; width:19%; height:4.2rem; color:#ed9aba; font-family:verdana;}
.pinkSeries li.swiper-slide:after,
.pinkSeries li.swiper-slide:last-child:before {content:'';  display:inline-block; position:absolute; top:50%; width:1.5px; height:1.8rem; margin-top:-0.9rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/79789/m/bg_line.jpg) 0 50% no-repeat; background-size:100%;}
.pinkSeries li.swiper-slide:after { left:0; }
.pinkSeries li.swiper-slide:last-child:before {right:0;}
.pinkSeries li.swiper-slide a {display:table-cell; width:100%; height:100%; font-size:1.3rem; font-weight:bold; vertical-align:middle;}
.pinkSeries li.swiper-slide a span {display:none;}
.pinkSeries li.swiper-slide.on {width:60%; color:#fff;}
.pinkSeries li.swiper-slide.on a span {display:block; font-size:1.2rem; font-weight:normal;}
.pinksta-feed {position:absolute; bottom:0; left:0; z-index:100;}
.feedWrap {position:relative;}
.feedWrap ul {position:absolute; left:0; top:0; right:0; bottom:0; width:100%; height:100%;}
.feedWrap ul li {float:left; width:33.33%; height:33.33%;}
.feedWrap ul.more li {float:left; width:33.33%; height:25%;}
.feedWrap ul li a {overflow:hidden; display:block; width:100%; height:100%; text-indent:-999em;}
</style>
</head>
<body>
<script type="text/javascript">
$(function(){
	pinkSwiper = new Swiper('.pinkSeries .swiper-container',{
		initialSlide:<%=vStartNo%>,
		slidesPerView:'auto',
		speed:300
	});
	$(".pinkSeries .swiper-slide .coming").click(function(){
		alert("Coming soon");
	});
});
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
	<!-- nav -->
	<div class="pinkSeries">
		<div class="swiper">
			<div class="swiper-container swiper1">
				<ul class="swiper-wrapper">
					<li class="swiper-slide pink-slide-1 <% if vEventID = "79660" then %> on<% end if %>">
						<a href="" onclick="goEventLink('79660'); return false;">01<span>#멍이멍이쿨매트</span></a>
					</li>

					<li class="swiper-slide pink-slide-2 <% if vEventID = "79789" then %> on<% end if %>">
						<% If currentdate >= "2017-08-10" Then %>
							<a href="" onclick="goEventLink('79789'); return false;">02<span>#FRITZ 콜드브루</span></a>
						<% else %>
							<a href="" onclick="return false;">02<span>#FRITZ 콜드브루</span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-3 <% if vEventID = "79931" then %> on<% end if %>">
						<% If currentdate >= "2017-08-17" Then %>
							<a href="" onclick="goEventLink('79931'); return false;">03<span>#BIC핑크볼펜</span></a>
						<% else %>
							<a href="" onclick="return false;">03<span>#BIC핑크볼펜</span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-4 <% if vEventID = "79988" then %> on<% end if %>">
						<% If currentdate >= "2017-08-24" Then %>
							<a href="" onclick="goEventLink('79988'); return false;">04<span>#미미츠보씰</span></a>
						<% else %>
							<a href="" onclick="return false;">04<span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-5 <% if vEventID = "80212" then %> on<% end if %>">
						<% If currentdate >= "2017-08-31" Then %>
							<a href="" onclick="goEventLink('80212'); return false;">05<span>#미드나잇인서울 컵시리얼</span></a>
						<% else %>
							<a href="" onclick="return false;">05<span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-6 <% if vEventID = "81371" then %> on<% end if %>">
						<% If currentdate >= "2017-10-25" Then %>
							<a href="" onclick="goEventLink('81371'); return false;">06<span>#백설공주 애플블랙티</span></a>
						<% else %>
							<a href="" onclick="return false;">06<span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-7 <% if vEventID = "82474" then %> on<% end if %>">
						<% If currentdate >= "2017-11-29" Then %>
							<a href="" onclick="goEventLink('82474'); return false;">07<span>#문라잇펀치로맨스 핫팩</span></a>
						<% else %>
							<a href="" onclick="return false;">07<span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-8 <% if vEventID = "83112" then %> on<% end if %>">
						<% If currentdate >= "2017-12-21" Then %>
							<a href="" onclick="goEventLink('83112'); return false;">08<span>#인테이크 핑크 칼로리컷</span></a>
						<% else %>
							<a href="" onclick="return false;">08<span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-9 <% if vEventID = "83997" then %> on<% end if %>">
						<% If currentdate >= "2018-01-30" Then %>
							<a href="" onclick="goEventLink('83997'); return false;">09<span>#어반약과 핑크에디션</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">09<span></span></a>
						<% end if %>
					</li>
					<li class="swiper-slide pink-slide-10 <% if vEventID = "84271" then %> on<% end if %>">
						<% If currentdate >= "2018-02-05" Then %>
							<a href="" onclick="goEventLink('84271'); return false;">10 <span>#위니비니 핑크에디션</span></a>
						<% else %>
							<a href="" onclick="return false;" class="coming">10<span></span></a>
						<% end if %>
					</li>

					<li class="swiper-slide pink-slide-11 <% if vEventID = "000" then %> on<% end if %>">
						<a href="" onclick="return false;" class="coming">11<span></span></a>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<!-- feed -->
	<div  class="pinksta-feed">
		<div class="feedWrap">
			<% if currentdate >= "2017-10-19" and currentdate < "2017-10-19" then %>
			<ul>
				<li><a href="eventmain.asp?eventid=79660">01 #멍멍이쿨매트</a></li>
				<li><a href="eventmain.asp?eventid=79789">02 #FRITZ 콜드브루</a></li>
				<li><a href="eventmain.asp?eventid=79931">03 #BIC핑크볼펜</a></li>
				<li><a href="eventmain.asp?eventid=79988">04 #미미츠보씰</a></li>
				<li><a href="eventmain.asp?eventid=80212">THE NEXT PINK IS..</a></li>
				<li><a href="eventmain.asp?eventid=81371">THE NEXT PINK IS..</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/79988/m/img_feed.jpg" alt="Pinkstagram Feed" /></p>

			<% elseif currentdate >= "2017-10-19" and currentdate < "2017-10-26"  then %>
			<% '#5 (~10/25)' %>
			<ul>
				<li><a href="eventmain.asp?eventid=79660">01 #멍멍이쿨매트</a></li>
				<li><a href="eventmain.asp?eventid=79789">02 #FRITZ 콜드브루</a></li>
				<li><a href="eventmain.asp?eventid=79931">03 #BIC핑크볼펜</a></li>
				<li><a href="eventmain.asp?eventid=79988">04 #미미츠보씰</a></li>
				<li><a href="eventmain.asp?eventid=80212">05 #미드나잇인서울</a></li>
				<li><a href="eventmain.asp?eventid=81371">THE NEXT PINK IS..</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/80212/m/img_feed.jpg" alt="Pinkstagram Feed" /></p>

			<% elseif currentdate >= "2017-10-26" and currentdate < "2017-11-29" then %>
			<% '#6 (10/26-11/01)' %>
			<ul>
				<li><a href="eventmain.asp?eventid=79660">01 #멍멍이쿨매트</a></li>
				<li><a href="eventmain.asp?eventid=79789">02 #FRITZ 콜드브루</a></li>
				<li><a href="eventmain.asp?eventid=79931">03 #BIC핑크볼펜</a></li>
				<li><a href="eventmain.asp?eventid=79988">04 #미미츠보씰</a></li>
				<li><a href="eventmain.asp?eventid=80212">05 #미드나잇인서울</a></li>
				<li><a href="eventmain.asp?eventid=81371">06 #백설공주 애플블랙티</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/81371/m/img_feed_v2.jpg" alt="Pinkstagram Feed" /></p>

			<% elseif currentdate >= "2017-11-29" and currentdate < "2017-12-21" then %>
			<% '#7 (11/02-11/07)' %>
			<ul>
				<li><a href="eventmain.asp?eventid=79660">01 #멍멍이쿨매트</a></li>
				<li><a href="eventmain.asp?eventid=79789">02 #FRITZ 콜드브루</a></li>
				<li><a href="eventmain.asp?eventid=79931">03 #BIC핑크볼펜</a></li>
				<li><a href="eventmain.asp?eventid=79988">04 #미미츠보씰</a></li>
				<li><a href="eventmain.asp?eventid=80212">05 #미드나잇인서울</a></li>
				<li><a href="eventmain.asp?eventid=81371">06 #백설공주 애플블랙티</a></li>
				<li><a href="eventmain.asp?eventid=82474">07 #문라잇펀치로맨스 핫팩</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/82474/m/img_feed.jpg" alt="Pinkstagram Feed" /></p>

			<% elseif currentdate >= "2017-12-21" and currentdate < "2018-01-30" then %>
			<% '#8 (11/02-11/07)' %>
			<ul>
				<li><a href="eventmain.asp?eventid=79660">01 #멍멍이쿨매트</a></li>
				<li><a href="eventmain.asp?eventid=79789">02 #FRITZ 콜드브루</a></li>
				<li><a href="eventmain.asp?eventid=79931">03 #BIC핑크볼펜</a></li>
				<li><a href="eventmain.asp?eventid=79988">04 #미미츠보씰</a></li>
				<li><a href="eventmain.asp?eventid=80212">05 #미드나잇인서울</a></li>
				<li><a href="eventmain.asp?eventid=81371">06 #백설공주 애플블랙티</a></li>
				<li><a href="eventmain.asp?eventid=82474">07 #문라잇펀치로맨스 핫팩</a></li>
				<li><a href="eventmain.asp?eventid=83112">08 #인테이크 핑크 칼로리컷</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/83112/m/img_feed.jpg" alt="Pinkstagram Feed" /></p>

			<% elseif currentdate >= "2018-01-30" and currentdate < "2018-02-04" then %>
			<% '#9 (01/30-02/14)' %>
			<ul>
				<li><a href="eventmain.asp?eventid=79660">01 #멍멍이쿨매트</a></li>
				<li><a href="eventmain.asp?eventid=79789">02 #FRITZ 콜드브루</a></li>
				<li><a href="eventmain.asp?eventid=79931">03 #BIC핑크볼펜</a></li>
				<li><a href="eventmain.asp?eventid=79988">04 #미미츠보씰</a></li>
				<li><a href="eventmain.asp?eventid=80212">05 #미드나잇인서울</a></li>
				<li><a href="eventmain.asp?eventid=81371">06 #백설공주 애플블랙티</a></li>
				<li><a href="eventmain.asp?eventid=82474">07 #문라잇펀치로맨스 핫팩</a></li>
				<li><a href="eventmain.asp?eventid=83112">08 #어반약과 핑크에디션</a></li>
				<li><a href="eventmain.asp?eventid=83997">09 #인테이크 핑크 칼로리컷</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/83997/m/img_feed.jpg" alt="Pinkstagram Feed" /></p>

			<% elseif currentdate >= "2018-02-05" and currentdate < "2018-12-31" then %>
			<% '#10 (02/06-)' %>
			<ul class="more">
				<li><a href="eventmain.asp?eventid=79660">01 #멍멍이쿨매트</a></li>
				<li><a href="eventmain.asp?eventid=79789">02 #FRITZ 콜드브루</a></li>
				<li><a href="eventmain.asp?eventid=79931">03 #BIC핑크볼펜</a></li>
				<li><a href="eventmain.asp?eventid=79988">04 #미미츠보씰</a></li>
				<li><a href="eventmain.asp?eventid=80212">05 #미드나잇인서울</a></li>
				<li><a>pink</a></li>
				<li><a href="eventmain.asp?eventid=81371">06 #백설공주 애플블랙티</a></li>
				<li><a href="eventmain.asp?eventid=82474">07 #문라잇펀치로맨스 핫팩</a></li>
				<li><a href="eventmain.asp?eventid=83112">08 #인테이크 핑크 칼로리컷</a></li>
				<li><a>stagram</a></li>
				<li><a href="eventmain.asp?eventid=83997">09 #어반약과 핑크에디션</a></li>
				<li><a href="eventmain.asp?eventid=84271">10 #위니비니 핑크에디션</a></li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/84271/m/img_feed.jpg" alt="Pinkstagram Feed" /></p>
			<% end if %>
		</div>
	</div>
</body>
</html>