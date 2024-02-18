<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : Wallpaper 페이지
' History : 2018-08-06 최종원
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->

<%
strHeadTitleName = "월페이퍼"

dim eCode, vUserID, sqlstr
dim viewcnt1, viewcnt2, viewcnt3, viewcnt4, viewcnt5, viewcnt6, viewcnt7, viewcnt8, viewcnt9, viewcnt10, viewcnt11, viewcnt12, viewcnt13, viewcnt14, viewcnt15, viewcnt16, viewcnt17, viewcnt18, viewcnt19, viewcnt20, viewcnt21, viewcnt22, viewcnt23, viewcnt24, viewcnt25, viewcnt26, viewcnt27, viewcnt28, viewcnt29, viewcnt30
dim week24, week25, week26, week27, week28, week29, week30

week24 = #01/21/2019 00:00:00# '92131
week25 = #01/28/2019 00:00:00# '
week26 = #02/05/2019 00:00:00# '
week27 = #02/12/2019 00:00:00# '
week28 = #02/19/2019 00:00:00# '
week29 = #02/26/2019 00:00:00# '
week30 = #03/05/2019 00:00:00# '

IF application("Svr_Info") = "Dev" THEN
	eCode = "66415"
Else
	eCode = "88366"
End If

'조회수 카운터
sqlstr = "SELECT " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '1' then 1 else 0 end),0) as view1, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '2' then 1 else 0 end),0) as view2, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '3' then 1 else 0 end),0) as view3, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '4' then 1 else 0 end),0) as view4, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '5' then 1 else 0 end),0) as view5, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '6' then 1 else 0 end),0) as view6, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '7' then 1 else 0 end),0) as view7, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '8' then 1 else 0 end),0) as view8, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '9' then 1 else 0 end),0) as view9, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '10' then 1 else 0 end),0) as view10, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '11' then 1 else 0 end),0) as view11, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '12' then 1 else 0 end),0) as view12, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '13' then 1 else 0 end),0) as view13, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '14' then 1 else 0 end),0) as view14, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '15' then 1 else 0 end),0) as view15, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '16' then 1 else 0 end),0) as view16, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '17' then 1 else 0 end),0) as view17, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '18' then 1 else 0 end),0) as view18, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '19' then 1 else 0 end),0) as view19, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '20' then 1 else 0 end),0) as view20, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '21' then 1 else 0 end),0) as view21, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '22' then 1 else 0 end),0) as view22, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '23' then 1 else 0 end),0) as view23, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '24' then 1 else 0 end),0) as view24, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '25' then 1 else 0 end),0) as view25, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '26' then 1 else 0 end),0) as view26, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '27' then 1 else 0 end),0) as view27, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '28' then 1 else 0 end),0) as view28, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '29' then 1 else 0 end),0) as view29, " + vbcrlf
sqlstr = sqlstr & " isnull(sum(case when sub_opt2 = '30' then 1 else 0 end),0) as view30 " + vbcrlf
sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript where evt_code = '"& eCode &"' "
rsget.Open sqlstr,dbget,1
IF Not rsget.Eof Then
	viewcnt1 = rsget("view1")
	viewcnt2 = rsget("view2")
	viewcnt3 = rsget("view3")
	viewcnt4 = rsget("view4")
	viewcnt5 = rsget("view5")
	viewcnt6 = rsget("view6")
	viewcnt7 = rsget("view7")
	viewcnt8 = rsget("view8")
	viewcnt9 = rsget("view9")
	viewcnt10 = rsget("view10")
	viewcnt11 = rsget("view11")
	viewcnt12 = rsget("view12")
	viewcnt13 = rsget("view13")
	viewcnt14 = rsget("view14")
	viewcnt15 = rsget("view15")
	viewcnt16 = rsget("view16")
	viewcnt17 = rsget("view17")
	viewcnt18 = rsget("view18")
	viewcnt19 = rsget("view19")
	viewcnt20 = rsget("view20")
	viewcnt21 = rsget("view21")
	viewcnt22 = rsget("view22")
	viewcnt23 = rsget("view23")
	viewcnt24 = rsget("view24")
	viewcnt25 = rsget("view25")
	viewcnt26 = rsget("view26")
	viewcnt27 = rsget("view27")
	viewcnt28 = rsget("view28")
	viewcnt29 = rsget("view29")
	viewcnt30 = rsget("view30")
End If
rsget.close()
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
$(function(){
	var itemSwiper = new Swiper(".last-wallpaper .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});
});
function fnAddViewCount(viewval, eventCode){
	fnAmplitudeEventAction('click_wallpaper_more','eventcode',eventCode);

	// alert();
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/doeventsubscript/doEventSubscript_wallpaper.asp",
		data: "viewval="+viewval,
		dataType: "text",
		async: false
	}).responseText;	
} 
function fnAPPRCVpopSNS(){
	//fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	$("#lySns").show();
	$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	return false;
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
			src: imageurl,
			width: width,
			height: height
			},
		appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
				android: { url: linkurl},
				iphone: { url: linkurl}
			}
		}
	});
}
$(function(){
	// progress bar
	window.onscroll = function() {myFunction()};
	function myFunction() {
		var winScroll = document.body.scrollTop || document.documentElement.scrollTop;
		var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
		var scrolled = (winScroll / height) * 100;
		document.getElementById("progress-bar").style.width = scrolled + "%";
	}
	var nav1 = $(".progress-wrap").offset().top;
	$(window).scroll(function() {
	var y = $(window).scrollTop();
	if (nav1 < y ) {
		$(".progress-wrap").addClass("fixed");
		$(".progress-wrap").css("top","4.1rem");
	}
	else {
		$(".progress-wrap").removeClass("fixed");
		$(".progress-wrap").css("top","0");
	}
	});
});
</script>
</head>
<body class="default-font body-sub">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="weekly-wallpaper">
			<div class="wallpaper-head">
				<h2><img src="//fiximage.10x10.co.kr/m/2018/wallpaper/tit_wallpaper.png" alt="Wallpaper"></h2>
				<span>매달 새로운 배경화면으로<br>소소한 즐거움을 누리세요!</span>
			</div>

			<!-- progress indicator(20190225) -->
			<div class="progress-wrap">
				<div class="progress-container">
					<div class="progress-bar" id="progress-bar"></div>
				</div>
			</div>
			<!--// progress indicator(20190225) -->

			<ul class="wallpaper-list">
			<!-- #include virtual="/wallpaper/wallpaper_exec.asp" -->
				<li>				
					<a href="/event/eventmain.asp?eventid=92131" onclick="fnAddViewCount(24,92131)">
						<div class="wallpaper-info">
							<div>
								<strong>City gardener</strong>
								<p>View <span><%=FormatNumber(viewcnt24,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2019/92131/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=91868" onclick="fnAddViewCount(23,91868)">
						<div class="wallpaper-info">
							<div>
								<strong>좋은 날</strong>
								<p>View <span><%=FormatNumber(viewcnt23,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2019/91868/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=91671" onclick="fnAddViewCount(22,91671)">
						<div class="wallpaper-info">
							<div>
								<strong>Good Night</strong>
								<p>View <span><%=FormatNumber(viewcnt22,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2019/91671/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=91549" onclick="fnAddViewCount(21,91549)">
						<div class="wallpaper-info">
							<div>
								<strong>happy new year</strong>
								<p>View <span><%=FormatNumber(viewcnt21,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/91549/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=91425" onclick="fnAddViewCount(20,91425)">
						<div class="wallpaper-info">
							<div>
								<strong>야옹이의 선물</strong>
								<p>View <span><%=FormatNumber(viewcnt20,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/91425/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=91323" onclick="fnAddViewCount(19,91323)">
						<div class="wallpaper-info">
							<div>
								<strong>홈얼론</strong>
								<p>View <span><%=FormatNumber(viewcnt19,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/91323/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=91024" onclick="fnAddViewCount(18,91024)">
						<div class="wallpaper-info">
							<div>
								<strong>merry &amp; bright</strong>
								<p>View <span><%=FormatNumber(viewcnt18,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/91024/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=90788" onclick="fnAddViewCount(17,90788)">
						<div class="wallpaper-info">
							<div>
								<strong>snowman</strong>
								<p>View <span><%=FormatNumber(viewcnt17,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90788/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=90695" onclick="fnAddViewCount(16,90695)">
						<div class="wallpaper-info">
							<div>
								<strong>미리크리스마스</strong>
								<p>View <span><%=FormatNumber(viewcnt16,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90695/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=90562" onclick="fnAddViewCount(15,90562)">
						<div class="wallpaper-info">
							<div>
								<strong>아무것도 안했는데</strong>
								<p>View <span><%=FormatNumber(viewcnt15,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90562/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=90391" onclick="fnAddViewCount(14,90391)">
						<div class="wallpaper-info">
							<div>
								<strong>별 헤는 밤</strong>
								<p>View <span><%=FormatNumber(viewcnt14,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90391/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=90254" onclick="fnAddViewCount(13,90254)">
						<div class="wallpaper-info">
							<div>
								<strong>PLAN</strong>
								<p>View <span><%=FormatNumber(viewcnt13,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90254/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=90042" onclick="fnAddViewCount(12,90042)">
						<div class="wallpaper-info">
							<div>
								<strong>따끈해서 좋아</strong>
								<p>View <span><%=FormatNumber(viewcnt12,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90042/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=89996" onclick="fnAddViewCount(11,89996)">
						<div class="wallpaper-info">
							<div>
								<strong>대충사자</strong>
								<p>View <span><%=FormatNumber(viewcnt11,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/89996/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=89829" onclick="fnAddViewCount(10,89829)">
						<div class="wallpaper-info">
							<div>
								<strong>이름표를 붙여줘</strong>
								<p>View <span><%=FormatNumber(viewcnt10,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/89829/m/img_index_thumb.jpg?v=1.0" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=89682" onclick="fnAddViewCount(9,89682)">
						<div class="wallpaper-info">
							<div>
								<strong>가을준비</strong>
								<p>View <span><%=FormatNumber(viewcnt9,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/89682/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88373" onclick="fnAddViewCount(8,88373)">
						<div class="wallpaper-info">
							<div>
								<strong>놀고 싶은 가을</strong>
								<p>View <span><%=FormatNumber(viewcnt8,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88373/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88372" onclick="fnAddViewCount(7,88372)">
						<div class="wallpaper-info">
							<div>
								<strong>With Coffee</strong>
								<p>View <span><%=FormatNumber(viewcnt7,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88372/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88371" onclick="fnAddViewCount(6,88371)">
						<div class="wallpaper-info">
							<div>
								<strong>DON&apos;T TOUCH!</strong>
								<p>View <span><%=FormatNumber(viewcnt6,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88371/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88370" onclick="fnAddViewCount(5,88370)">
						<div class="wallpaper-info">
							<div>
								<strong>다람쥐의 간식</strong>
								<p>View <span><%=FormatNumber(viewcnt5,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88370/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88369" onclick="fnAddViewCount(4,88369)">
						<div class="wallpaper-info">
							<div>
								<strong>무뚝뚝한 내 친구</strong>
								<p>View <span><%=FormatNumber(viewcnt4,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/fixevent/event/2018/88369/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88368" onclick="fnAddViewCount(3,88368)">					
						<div class="wallpaper-info">
							<div>
								<strong>Romentic Sunset</strong>
								<p>View <span><%=FormatNumber(viewcnt3,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/88368/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88367" onclick="fnAddViewCount(2,88367)">
						<div class="wallpaper-info">
							<div>
								<strong>오늘의 날씨</strong>
								<p>View <span><%=FormatNumber(viewcnt2,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/88367/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
				<li>
					<a href="/event/eventmain.asp?eventid=88366" onclick="fnAddViewCount(1,88366)">
						<div class="wallpaper-info">
							<div>
								<strong>SURFING DOG</strong>
								<p>View <span><%=FormatNumber(viewcnt1,0)%></span></p>
								<img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/btn_wallpaper_more.png" alt="더보기" />
							</div>
						</div>
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/88366/m/img_index_thumb.jpg" alt="" />
					</a>
				</li>
			
			</ul>
			<div class="last-wallpaper">
				<h3>지난 배경화면 <span>구경하기</span></h3>
				<p class="tag">#시원한 #여름을 #담은 #월페이퍼</p>
				<div class="swiper-container">
					<ul class="swiper-wrapper">
						<li class="swiper-slide">						
							<a href="/playing/view.asp?didx=78" class="mWeb">		
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/img_last_wallpaper1.jpg" alt="" /></div>
								<p class="name">Flower Window</p>
							</a>
						</li>
						<li class="swiper-slide">
							<a href="/playing/view.asp?didx=209" class="mWeb">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/img_last_wallpaper2.jpg" alt="" /></div>
								<p class="name">데이트</p>
							</a>							
						</li>
						<li class="swiper-slide">
							<a href="/playing/view.asp?didx=111" class="mWeb">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/img_last_wallpaper3.jpg" alt="" /></div>
								<p class="name">Dolphin</p>
							</a>							
						</li>
						<li class="swiper-slide">
							<a href="/playing/view.asp?didx=102" class="mWeb">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/img_last_wallpaper4.jpg" alt="" /></div>
								<p class="name">6월의 피크닉</p>
							</a>							
						</li>
						<li class="swiper-slide">
							<a href="/playing/view.asp?didx=123" class="mWeb">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/img_last_wallpaper5.jpg" alt="" /></div>
								<p class="name">SUMMER NIGHT</p>
							</a>							
						</li>
						<li class="swiper-slide">
							<a href="/playing/view.asp?didx=243" class="mWeb">
								<div class="thumbnail"><img src="http://fiximage.10x10.co.kr/m/2018/wallpaper/img_last_wallpaper6.jpg" alt="" /></div>
								<p class="name">Voyage</p>
							</a>							
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
<%
	'//	SNS 공유 관련 HEADER 포함
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, eOnlyName
	eOnlyName = "텐바이텐 월페이퍼"
	snpTitle = eOnlyName
	snpLink = wwwUrl&CurrURLQ()
	snpPre = "10x10 월페이퍼"
	'//이벤트 명 할인이나 쿠폰시
	'// sns공유용 이미지
%>	
	<!-- //contents -->
	<!-- #include virtual="/common/LayerShare.asp" -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->