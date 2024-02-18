<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'########################################################
' PLAY FLOWER WEEK
' 2015-04-30 한용민 작성
'########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim eCode, userid
IF application("Svr_Info") = "Dev" THEN
	eCode   =  61772
Else
	eCode   =  62188
End If

userid = getloginuserid()

dim currenttime
	currenttime =  now()
	'currenttime = #05/05/2015 09:00:00#
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.flower .navigator {position:relative;}
.flower .navigator ul {overflow:hidden; position:absolute; top:22%; left:0; width:100%; padding:0 3%;}
.flower .navigator ul li {float:left; width:20%;}
.flower .navigator ul li a {overflow:hidden; display:block; position:relative; height:0; padding-bottom:82.25%; font-size:11px; line-height:11px; text-indent:-999em; text-align:center;}
.flower .navigator ul li a span {position:absolute; top:0; left:0; width:100%; height:100%; /*background-color:red; opacity:0.3;*/}
.flower .navigator ul li a.on {background:url(http://webimage.10x10.co.kr/playmo/ground/20150504/tab_01_on.png) no-repeat 50% 0; background-size:100% auto;}
.flower .navigator ul li.nav2 a.on {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150504/tab_02_on.png);}
.flower .navigator ul li.nav3 a.on {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150504/tab_03_on.png);}
.flower .navigator ul li.nav4 a.on {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150504/tab_04_on.png);}
.flower .navigator ul li.nav5 a.on {background-image:url(http://webimage.10x10.co.kr/playmo/ground/20150504/tab_05_on.png);}
.tab-con .article {padding:8% 0 10%; background:#fdf0ea url(http://webimage.10x10.co.kr/playmo/ground/20150504/bg_pattern_01.png) no-repeat 50% 0; background-size:100% auto;}
.downlist {overflow:hidden; padding:0 6%;}
.downlist .preview {float:left; width:40%;}
.downlist ul {float:left; width:60%;}
.downlist ul li:first-child a {border-top:1px solid #fde7dc;}
.downlist ul li a {display:block; padding:3% 4%; border-bottom:1px solid #fde7dc;}
.typeA ul li {padding-right:10%; padding-left:19%;}
.typeB {padding-top:15%;}
.typeB .preview {float:right;}
.typeB ul li {padding-right:19%; padding-left:10%;}

#cont2 .article {background:#fff6e9 url(http://webimage.10x10.co.kr/playmo/ground/20150504/bg_pattern_02.png) no-repeat 50% 0; background-size:100% auto;}
#cont2 .downlist ul li a {border-color:#ffe0b5;}
#cont2.downlist ul li:first-child a {border-color:#ffe0b5;}
#cont3 .article {background:#eff7db url(http://webimage.10x10.co.kr/playmo/ground/20150504/bg_pattern_03.png) no-repeat 50% 0; background-size:100% auto;}
#cont3 .downlist ul li a {border-color:#d6eab9;}
#cont3.downlist ul li:first-child a {border-color:#d6eab9;}
#cont4 .article {background:#fdeced url(http://webimage.10x10.co.kr/playmo/ground/20150504/bg_pattern_04.png) no-repeat 50% 0; background-size:100% auto;}
#cont4 .downlist ul li a {border-color:#f4d1d3;}
#cont4.downlist ul li:first-child a {border-color:#f4d1d3;}
#cont5 .article {background:#f7eafd url(http://webimage.10x10.co.kr/playmo/ground/20150504/bg_pattern_05.png) no-repeat 50% 0; background-size:100% auto;}
#cont5 .downlist ul li a {border-color:#ead5f4;}
#cont5.downlist ul li:first-child a {border-color:#ead5f4;}
</style>
</head>
<body>

<!-- iframe -->
<div class="mPlay20150504">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/tit_flower.jpg" alt="꽃으로 더 행복해지는 일주일" /></h1>
	</div>

	<div class="present">
		<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/tit_present.jpg" alt="우리의 꽃을 받아주세요" /></h2>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_present_01.png" alt="텐바이텐 플레이에서는 일주일 동안 당신께 꽃을 선물하려고 합니다! 당신과 늘 가까이 있는 휴대폰, 컴퓨터에 우리가 준비한 꽃을 받아 주세요. 이 꽃으로 인해 당신의 일주일이 조금 더 행복해지기를 바랍니다" /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_present_02.png" alt="선물을 드려요. 텐바이텐 PLAY가 드리는 월, 화, 수, 목, 금의 모바일 배경화면을 모두 다운받으신 분들 중 추첨을 통해 5분께는 꽃 바구니를 배달해 드립니다. 기간은 2015년 5월 4일부터 5월 10일까지며 당첨자 발표는 2015년 5월 12일입니다." /></p>
	</div>

	<div class="meet">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_meet.png" alt="우리가 준비한 꽃을 매일 만나보세요. 모바일 배경화면 + 친구에게 보내는 플라워 카드 5일 동안 매일, 하루에 하나씩 여러분을 위한 꽃 선물이 열립니다." />
	</div>

	<div class="flower">
		<div class="navigator">
			<ul>
				<li class="nav1"><a href="#cont1"><span>MON</span></a></li>
				<li class="nav2"><a href="#cont2"><span>TUE</span></a></li>
				<li class="nav3"><a href="#cont3"><span>WED</span></a></li>
				<li class="nav4"><a href="#cont4"><span>THU</span></a></li>
				<li class="nav5"><a href="#cont5"><span>TUE</span></a></li>
			</ul>
			<img src="http://webimage.10x10.co.kr/playmo/ground/20150504/bg_tab.png" alt="" />
		</div>

		<div class="tab-con">
			<div id="cont1" class="section">
				<div class="articlewrap">
					<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_flower_of_monday.png" alt="5월 4일 월요일의 꽃 월요병으로 정신없고 고된 하루지만, 붉은 열정을 담아 응원합니다. 당신의 숨어 있는 에너지를 충전해 줄 월요일의 꽃 고마운 당신이 있기에 오늘도 힘이 납니다." /></h2>
					<div class="article">
						<div class="downlist typeA">
							<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_monday_01.png" alt="" /></div>
							<ul>
								<li><a href="" onclick="fileDownload('3368'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
								<li><a href="" onclick="fileDownload('3369'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
								<li><a href="" onclick="fileDownload('3370'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
								<li><a href="" onclick="fileDownload('3371'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
								<li><a href="" onclick="fileDownload('3372'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
								<li><a href="" onclick="fileDownload('3373'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
							</ul>
						</div>
						<div class="downlist typeB">
							<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_monday_02.png" alt="" /></div>
							<ul>
								<li><a href="" onclick="fileDownload('3374'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
								<li><a href="" onclick="fileDownload('3375'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
								<li><a href="" onclick="fileDownload('3376'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
								<li><a href="" onclick="fileDownload('3377'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
								<li><a href="" onclick="fileDownload('3378'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
								<li><a href="" onclick="fileDownload('3379'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>

			<div id="cont2" class="section">
				<% if left(currenttime,10)>="2015-05-05" then %>
					<!-- for dev msg : 오픈 후 -->
					<div class="articlewrap">
						<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_flower_of_tueday.png" alt="5월 5일 화요일의 꽃 아주 잠깐이라도 시간을 내어 나만의 방식으로 여유를 느끼는 날이 되세요. 당신에게 생기를 불어넣어 줄 화요일의 꽃 잘하고 있어요! 그러니 기운내기!" /></h2>
						<div class="article">
							<div class="downlist typeA">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_tueday_01.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3386'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3387'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3388'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3389'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3390'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3391'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
							<div class="downlist typeB">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_tueday_02.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3392'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3393'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3394'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3395'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3396'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3397'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
						</div>
					</div>
				<% else %>
					<!-- for dev msg : 오픈 전 -->
					<p class="onTue"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_coming_soon_tue.jpg" alt="화요일의 꽃 카라 5월 5일 comming soon" /></p>
				<% end if %>
			</div>

			<div id="cont3" class="section">
				<% if left(currenttime,10)>="2015-05-06" then %>
					<!-- for dev msg : 오픈 후 -->
					<div class="articlewrap">
						<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_flower_of_wednesday.png" alt="5월 7일 수요일의 꽃 남은 요일을 위해 충전이 필요한 날 내가 가장 좋아하는 일을 하세요. 행복의 기운 가득한 수요일의 꽃" /></h2>
						<div class="article">
							<div class="downlist typeA">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_wednesday_01.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3404'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3405'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3406'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3407'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3408'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3409'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
							<div class="downlist typeB">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_wednesday_02.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3410'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3411'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3412'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3413'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3414'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3415'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
						</div>
					</div>
				<% else %>
					<!-- for dev msg : 오픈 전 -->
					<p class="onWed"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_coming_soon_wed.jpg" alt="수요일의 꽃 퐁퐁소국 5월 6일 comming soon" /></p>
				<% end if %>
			</div>

			<div id="cont4" class="section">
				<% if left(currenttime,10)>="2015-05-07" then %>
					<!-- for dev msg : 오픈 후 -->
					<div class="articlewrap">
						<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_flower_of_thursday.png" alt="5월 7일 목요일의 꽃 목요일의 꽃 피로 가득 오늘은 몸과 마음의 릴렉스가 필요한 날. 조용한 시간을 내어 한 주를 정리하세요. 향기로운 목요일의 꽃 당신에게 내 사랑을 가득 담아 보냅니다" /></h2>
						<div class="article">
							<div class="downlist typeA">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_thursday_01.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3422'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3423'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3424'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3425'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3426'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3427'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
							<div class="downlist typeB">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_thursday_02.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3428'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3429'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3430'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3431'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3432'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3433'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
						</div>
					</div>
				<% else %>
					<!-- for dev msg : 오픈 전 -->
					<p class="onThu"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_coming_soon_thu2.jpg" alt="목요일의 꽃 작약 5월 7일 comming soon" /></p>
				<% end if %>
			</div>

			<div id="cont5" class="section">
				<% if left(currenttime,10)>="2015-05-08" then %>
					<!-- for dev msg : 오픈 후 -->
					<div class="articlewrap">
						<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_flower_of_friday.png" alt="5월 8일 금요일의 꽃 고생한 당신에게 주어지는 소중한 시간. 오직 당신을 위한 일들로 주말을 보내세요. 즐거운 추억을 만들어 줄 금요일의 꽃 깜짝 놀랄 좋은 일이 당신에게 생기길!" /></h2>
						<div class="article">
							<div class="downlist typeA">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_friday_01.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3440'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3441'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3442'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3443'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3444'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3445'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
							<div class="downlist typeB">
								<div class="preview"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/img_flower_of_friday_02.png" alt="" /></div>
								<ul>
									<li><a href="" onclick="fileDownload('3446'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_01.png" alt="iPhone 6" /></a></li>
									<li><a href="" onclick="fileDownload('3447'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_02.png" alt="iPhone 6+" /></a></li>
									<li><a href="" onclick="fileDownload('3448'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_03.png" alt="iPhone 5" /></a></li>
									<li><a href="" onclick="fileDownload('3449'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_04.png" alt="Galaxy S5" /></a></li>
									<li><a href="" onclick="fileDownload('3450'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_05.png" alt="Galaxy Edge" /></a></li>
									<li><a href="" onclick="fileDownload('3451'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/btn_down_06.png" alt="Galaxy Note3" /></a></li>
								</ul>
							</div>
						</div>
					</div>
				<% else %>
					<!-- for dev msg : 오픈 전 -->
					<p class="onFri"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_coming_soon_fri.jpg" alt="금요일의 꽃 미스티블루 5월 5일 comming soon" /></p>
				<% end if %>
			</div>
		</div>
	</div>

	<div class="screensaver">
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_screen_saver.jpg" alt="당신의 컴퓨터에도 꽃을 심어 주세요! 텐바이텐 플레이와 히치하이커가 함께 바탕화면 보호기를 준비했습니다. 꽃으로 느낄 수 있는 7가지의 좋은 기분을 컴퓨터에 심어 두세요 화면보호기는 텐바이텐 웹 사이트에서만 다운받으실 수 있습니다. " /></p>

		<% if isApp=1 then %>
			<!--<a href="" onclick="parent.fnAPPpopupBrand('hitchhiker'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/61908/btn_photo_review.png" alt ="포토후기 남기기" /></a>-->
			<a href="" onclick="parent.fnAPPpopupBrand('hitchhiker'); return false;"><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_hitchhiker.png" alt ="이야기로 힘을 얻고, 이야기에 힘이 되는 히치하이커 히치하이커는 텐바이텐의 감성매거진입니다. 격월간으로 발행되는 히치하이커는 일상 속 메시지를 다양한 이미지와 함께 이야기합니다." /></a>
		<% else %>
			<p><a href="/street/street_brand.asp?makerid=hitchhiker" target='_top'><img src="http://webimage.10x10.co.kr/playmo/ground/20150504/txt_hitchhiker.png" alt="이야기로 힘을 얻고, 이야기에 힘이 되는 히치하이커 히치하이커는 텐바이텐의 감성매거진입니다. 격월간으로 발행되는 히치하이커는 일상 속 메시지를 다양한 이미지와 함께 이야기합니다." /></a></p>
		<% end if %>
	</div>
</div>
<!-- //iframe -->

<script type="text/javascript">
$(function(){
	/* tab */
	<% if left(currenttime,10)="2015-05-04" then %>
		$(".navigator li.nav1 a").addClass("on");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(".section:nth-child(1)").show();
	<% elseif left(currenttime,10)="2015-05-05" then %>
		$(".navigator li.nav2 a").addClass("on");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(".section:nth-child(2)").show();
	<% elseif left(currenttime,10)="2015-05-06" then %>
		$(".navigator li.nav3 a").addClass("on");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(".section:nth-child(3)").show();
	<% elseif left(currenttime,10)="2015-05-07" then %>
		$(".navigator li.nav4 a").addClass("on");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(".section:nth-child(4)").show();
	<% elseif left(currenttime,10)="2015-05-08" then %>
		$(".navigator li.nav5 a").addClass("on");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(".section:nth-child(5)").show();
	<% elseif left(currenttime,10)>="2015-05-09" then %>
		$(".navigator li.nav5 a").addClass("on");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(".section:nth-child(5)").show();
	<% else %>
		$(".navigator li.nav1 a").addClass("on");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(".section:nth-child(1)").show();
	<% end if %>



	$(".navigator li a").click(function(){
		$(".navigator li a").removeClass("on");
		$(this).addClass("on");
		var thisCont = $(this).attr("href");
		$(".tab-con").find(".section").hide();
		$(".tab-con").find(thisCont).show();
		return false;
	});
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->