<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : just 1 week big gate page
' History : 2016-03-25 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" --> 
<%
	If date() >= "2016-03-28" and date() < "2016-04-04" Then
		response.redirect("/event/eventmain.asp?eventid=69757")
	elseif date() >= "2016-04-04" and date() < "2016-04-11" Then
		response.redirect("/event/eventmain.asp?eventid=69758")
	elseif date() >= "2016-04-11" and date() < "2016-04-18" Then
		response.redirect("/event/eventmain.asp?eventid=69759")
	elseif date() >= "2016-04-18" Then
		response.redirect("/event/eventmain.asp?eventid=69760")
	End If
%>
<style type="text/css">
img {vertical-align:top;}

/* navigator */
.navigatorWrap {position:relative; height:120px; background:#f4e7d3 url(http://webimage.10x10.co.kr/eventIMG/2016/69756/m/bg_color.png) no-repeat 50% 0; background-size:100% 100%;}
.navigatorWrap .navigator {position:absolute; top:10px; left:50%; width:320px; height:105px; margin-left:-160px;}
.navigatorWrap .navigator iframe {width:320px; margin:0 auto;}

@media all and (min-width:360px){
	.navigatorWrap {height:130px;}
	.navigatorWrap .navigator {width:360px; height:120px; margin-left:-180px;}
	.navigatorWrap .navigator iframe {width:360px; margin:0 auto;}
}

@media all and (min-width:480px){
	.navigatorWrap {height:166px;}
	.navigatorWrap .navigator {width:480px; height:157px; margin-left:-240px;}
	.navigatorWrap .navigator iframe {width:480px; margin:0 auto;}
}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content evtDetailV15" id="contentArea">
				<div class="evtHeadV15">
					<h2>JUST 1 WEEK BIG SALE #메인</h2>
					<p class="date">2016.03.28 ~ 2016.04.24</p>
					<div class="btnWrap">
						<p class="evtShareV15"><a href="#evtShare">공유</a></p>
						<p class="wishViewV15 wishActive"><span>찜하기</span></p><!-- for dev msg : 관심이벤트 등록시 클래스 wishActive -->
					</div>
				</div>
				<!-- 이벤트 배너 등록 영역 -->
				<div class="evtCont">

					<!-- [M/A] 2016 S/S 웨딩 UST 1 WEEK BIG SALE / 이벤트 코드 : 69756 -->
					<div class="mEvt69757">
						<div class="bnr">
							<a href="eventmain.asp?eventid=69755"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/img_bnr_main.png" alt="2016 S/S 웨딩 기프트 당신의 결혼에 초대해주세요" /></a>
						</div>

						<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69756/m/txt_just_one_week_big_sale.png" alt="Just 1 week big sale 매주 달라지는 일주일의 특가!" /></p>

						<!-- navigator -->
						<!--
								69757 JUST 1 WEEK BIG SALE #1
								69758 JUST 1 WEEK BIG SALE #2
								69756 JUST 1 WEEK BIG SALE #3
								69760 JUST 1 WEEK BIG SALE #4
						-->
						<div class="navigatorWrap">
							<div class="navigator">
								<iframe id="iframe_69756" src="/event/etc/group/iframe_69756.asp?eventid=69756" frameborder="0" scrolling="no" title="Just 1 week big sale"></iframe>
							</div>
						</div>
					</div>

				</div>
				<!--// 이벤트 배너 등록 영역 -->
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>