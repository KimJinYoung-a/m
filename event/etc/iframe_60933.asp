<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	'####################################################
	'### 셋콤달콤-지니편(모바일 웹)
	'### 2015-04-12 원승현
	'####################################################


	Dim eCode, vDisp, sqlstr, mycouponkey, mygienee, totalcnt
	Dim userid
	Dim nowdate

	nowdate = date()
'	nowdate = "2015-04-13"

	dim LoginUserid
	LoginUserid = getLoginUserid()

	If nowdate >= "2015-04-17" And nowdate < "2015-04-21" Then
		response.write "<script>parent.location.href='/event/eventmain.asp?eventid=61549'</script> "
		response.End
	End If

	If nowdate >= "2015-04-21" Then
		response.write "<script>parent.location.href='/event/eventmain.asp?eventid=61550'</script> "
		response.End
	End If



%>
<style type="text/css">
.threeSweets {position:relative;}
.threeSweets img {vertical-align:top;}
.threeSweets .todaygift {position:relative;}
.threeSweets .todaygift .soldout {position:absolute; left:0; top:-0.5%; width:100%; height:100.5%; background:rgba(0,0,0,.75); z-index:20;}
.threeSweets .todaygift .soldout p {padding-top:65%;}
.threeSweets .todaygift .date {position:absolute; left:0; top:0; width:100%; z-index:15;}
.threeSweets .applyEvt {padding-bottom:28px; background:#f4f7f7;}
.threeSweets .applyEvt .selectLamp {overflow:hidden; padding:0 4% 20px;}
.threeSweets .applyEvt .selectLamp li {float:left; width:33.33333%; padding:0 1%; text-align:center;}
.threeSweets .applyEvt .selectLamp li input {margin-top:8px;}
.threeSweets .applyEvt .applyBtn {width:80%; margin:0 auto;}
.threeSweets .applyEvt .viewNum {padding-top:25px;}
.threeSweets .evtNoti {padding:30px 10px;}
.threeSweets .evtNoti dt {color:#444; margin-bottom:15px;}
.threeSweets .evtNoti dt span {padding:0 10px; font-size:13px; line-height:1; font-weight:bold; border-left:2px solid #33e4b9; border-right:2px solid #33e4b9; vertical-align:top;}
.threeSweets .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.3; padding-left:13px; margin-top:4px;}
.threeSweets .evtNoti li:first-child {margin-top:0;}
.threeSweets .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:2px; height:2px; border:2px solid #ffc101; border-radius:50%;}
.threeSweets .sweetTab {position:absolute; left:0; top:-15.5%; width:100%; padding:0 0 1% 3%;}
.threeSweets .sweetTab:after {content:' '; display:inline-block; position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60930/bg_tab_box.png) left top no-repeat; background-size:100% auto; z-index:10;}
.threeSweets .sweetTab ul {overflow:hidden; width:100%;}
.threeSweets .sweetTab li {position:relative; float:left; width:32.6%; z-index:40; z-index:40;}
.threeSweets .sweetTab li span {display:block; position:absolute; left:0; top:0; width:100%;}

@media all and (min-width:480px){
	.threeSweets .applyEvt {padding-bottom:42px;}
	.threeSweets .applyEvt .selectLamp {padding:0 4% 30px;}
	.threeSweets .applyEvt .selectLamp li input {margin-top:12px;}
	.threeSweets .applyEvt .viewNum {padding-top:38px;}
	.threeSweets .evtNoti {padding:45px 20px;}
	.threeSweets .evtNoti dt {margin-bottom:23px;}
	.threeSweets .evtNoti dt span {padding:0 15px; font-size:20px; border-left:3px solid #33e4b9; border-right:3px solid #33e4b9;}
	.threeSweets .evtNoti li {font-size:17px; padding-left:20px; margin-top:6px;}
	.threeSweets .evtNoti li:after {top:5px; width:3px; height:3px; border:3px solid #ffc101;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script language="javascript">
<!--
	var userAgent = navigator.userAgent.toLowerCase();
	function gotoDownload(){
		parent.top.location.href='http://m.10x10.co.kr/apps/link/?3820150412';
		return false;
	};

	$(function(){
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$("#mo").hide();
		}else{
			$("#mo").show();
		}
	});

function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		parent_kakaolink('[텐바이텐] 셋콤 달콤!\n4월에 꿀맛 제대로 느껴보세요!\n\n-지니 30일 무제한 감상권!\n-요기요 7,000원 식권!\n-메가박스 영화 예매권!\n\n텐바이텐 APP에서 당신의 손으로 직접 당첨을 확인하세요!' , 'http://webimage.10x10.co.kr/eventIMG/2015/60930/60930kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=60930' );
		return false;
	<% Else %>
		jsChklogin('<%=IsUserLoginOK%>');
		return false;
	<% End If %>
}

function goAlertApp()
{
	alert("텐바이텐 앱에서 참여 가능합니다.");
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
	  },
	installTalk : Boolean
  });
}
//-->
</script>
</head>
<body>
<div class="evtCont">
	<!--사월의 꿀맛 : 셋콤달콤-지니뮤직(M) -->
	<div class="threeSweets">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tit_three_sweets.gif" alt="셋콤달콤" /></h2>
		<div class="todaygift">
			<!-- 솔드아웃
			<div class="soldout">
				<p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_soldout.png" alt="SOLD OUT 이벤트 기간이 끝났습니다" />
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_soldout_10am.png" alt="SOLD OUT 내일 오전 10시, 달콤한 행운이 돌아옵니다!" />
				</p>
			</div>
			 -->
			<div class="sweetTab">
				<%' 날짜별로 탭 이미지 변경됩니다.(오픈전/오픈하루전/오픈/마감) %>
				<ul>
					<li class="genie">
						<a href="/event/eventmain.asp?eventid=60933" target="_top">
							<% If nowdate >= "2015-04-13" And nowdate < "2015-04-17" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_genie_on.png" alt="지니뮤직" />
							<% End If %>
							<% If nowdate >= "2015-04-17" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_genie_off.png" alt="지니뮤직 - 기간종료" />
							<% End If %>
						</a>
					</li>
					<li class="yogiyo">
						<a href="/event/eventmain.asp?eventid=61549" target="_top">
							<% If nowdate >= "2015-04-13" And nowdate < "2015-04-16" then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_day17.png" alt="17일 OPEN!" /></span>
							<% End If %>
							<% If nowdate = "2015-04-16" Then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_tomorrow.png" alt="내일 OPEN!" /></span>
							<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_yogiyo.png" alt="요기요" />
							<% If nowdate >= "2015-04-21" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_yogiyo_off.png" alt="요기요 - 기간종료" />
							<% End If %>
						</a>
					</li>
					<li class="megabox">
						<a href="/event/eventmain.asp?eventid=61550" target="_top">
							<% If nowdate >= "2015-04-13" And nowdate < "2015-04-20" then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_day21.png" alt="21일 OPEN!" /></span>
							<% End If %>
							<% If nowdate >= "2015-04-20" Then %>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tag_open_tomorrow.png" alt="내일 OPEN!" /></span>
							<% End If %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_megabox.png" alt="메가박스" />
							<% If nowdate >= "2015-04-25" Then %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/tab_megabox_off.png" alt="메가박스 - 기간종료" />
							<% End If %>
						</a>
					</li>
				</ul>
			</div>
			<% If Hour(Now()) >= 0 And Hour(Now()) < 10 Then %>
			<% Else %>
				<p class="date">
					<%' 날짜별로 이미지 변경됩니다.(이벤트 마감 당일날은 txt_date02.png 이미지 노출) %>
					<% If nowdate >= "2015-04-13" And nowdate < "2015-04-16" Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_date01.png" alt="이벤트 기간:04.13~04.16" />
					<% End If %>
					<% If nowdate = "2015-04-16" Then %>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_date02.png" alt="이벤트 기간:04.13~오늘까지" />
					<% End If %>
				</p>
			<% End If %>
			<div>
				<% If Hour(Now()) >= 0 And Hour(Now()) < 10 Then %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_gift_genie_soon_today.jpg" alt="지니뮤직" />
				<% Else %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_gift_genie.jpg" alt="지니뮤직" />
				<% End If %>
			</div>
		</div>
		<div class="applyEvt">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/txt_select_lamp.jpg" alt="아래 램프 중, 한개를 선택하고 당첨을 확인하세요!" /></p>
			<ul class="selectLamp">
				<li>
					<label for="s01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_lamp01.png" alt="램프1" /></label>
					<input type="radio" id="s01" name="al" onclick="goAlertApp();" />
				</li>
				<li class="tPad15">
					<label for="s02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_lamp02.png" alt="램프2" /></label>
					<input type="radio" id="s02" name="al" onclick="goAlertApp();"  />
				</li>
				<li>
					<label for="s03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/img_lamp03.png" alt="램프3" /></label>
					<input type="radio" id="s03" name="al" onclick="goAlertApp();"  />
				</li>
			</ul>
			<p class="applyBtn"><a href="" onclick="gotoDownload();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/btn_go_app.gif" alt="" /></a></p>
		</div>
		<p><a href="" onclick="kakaosendcall();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/btn_noti_kakao.gif" alt="또 하고 싶을 땐, 친구찬스!" /></a></p>
		<dl class="evtNoti">
			<dt><span>이벤트 유의사항</span></dt>
			<dd>
				<ul>
					<li>본 이벤트는 텐바이텐 app에서만 참여 가능합니다.</li>
					<li>본 이벤트는 ID당 1회만 응모가능하며, 친구 초대 시 한 번 더 응모기회가 주어집니다.</li>
					<li>지니 &lt;스마트폰 음악감상 30일&gt;은 지니 앱에서 등록 후 사용 가능하며, 등록 가능 기간은 8월31일까지입니다.</li>
					<li>등록일 기준으로 30일 동안 사용이 가능합니다.</li>
					<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
					<li>무료배송쿠폰은 ID당 하루에 최대 2회까지 발행되며, 발급 당일 자정 기준으로 자동 소멸됩니다. (1만원 이상 구매 시, 텐바이텐 배송상품만 사용 가능)</li>
					<li>당첨 된 기프티콘은 익일 오후 1시에 발송됩니다! 마이텐바이텐에서 연락처를 확인해주세요.</li>
					<li>지니쿠폰 등록은 지니 유선 사이트 (www.genie.co.kr)와 안드로이드 지니 어플리케이션에서 가능하며 ios는 애플 정책상 유선에서 등록하여 사용 하시면 됩니다.</li>
				</ul>
			</dd>
		</dl>
		<p><a href="/event/eventmain.asp?eventid=61491" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60930/bnr_get_item.gif" alt="쫄깃한 득템 브랜드 이벤트 가기" /></a></p>
	</div>
	<!--// 사월의 꿀맛 : 셋콤달콤-지니뮤직(M) -->
</div>

</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->