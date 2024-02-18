<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 기승전쇼핑_빼주세요, APP 쿠폰 (M)
' History : 2014.09.04 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event54760Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->

<%
dim eCode, userid, subscriptcount, subscriptcountdate, bonuscouponcount, totalsubscriptcount, totalbonuscouponcount
dim ename, cEvent, emimg, usercell, currentcouponid ,subscriptcount1 ,subscriptcount2 ,subscriptcount3
	eCode=getevt_code
Dim vUserID
	vUserID = GetLoginUserID
	userid = vUserID

	bonuscouponcount=0
	subscriptcount=0
	totalsubscriptcount=0
	totalbonuscouponcount=0
	subscriptcount1=0
	subscriptcount2=0
	subscriptcount3=0
	usercell=""

	if getnowdate="2014-09-10" then
		currentcouponid=getbonuscoupon15pro
	elseif getnowdate="2014-09-11" then
		currentcouponid=getbonuscoupon5000
	elseif getnowdate="2014-09-12" then
		currentcouponid=getbonuscoupon10000
	end if

	'//본인 참여 여부
	if userid<>"" then
		subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
		subscriptcount1 = getevent_subscriptexistscount(eCode, userid, "2014-09-10", "", "")
		subscriptcount2 = getevent_subscriptexistscount(eCode, userid, "2014-09-11", "", "")
		subscriptcount3 = getevent_subscriptexistscount(eCode, userid, "2014-09-12", "", "")

		bonuscouponcount = getbonuscouponexistscount(userid, currentcouponid, "", "", "")
	end if

	'//전체 참여수
	totalsubscriptcount = getevent_subscripttotalcount(eCode, getnowdate, "", "")

	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode
		cEvent.fnGetEvent

		eCode		= cEvent.FECode
		ename		= cEvent.FEName
		emimg		= cEvent.FEMimg
	set cEvent = nothing

%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt54761 {border-bottom:2px solid #9e2020;}
.mEvt54761 img {vertical-align:top; width:100%;}
.mEvt54761 p {max-width:100%;}
.reduce .section, .reduce .section h3 {margin:0; padding:0;}
.reduce .scale {position:relative;}
.reduce .scale .win {position:absolute; top:0; left:0; width:100%;}
.reduce .scale .btnDown {position:absolute; bottom:10%; left:0; width:100%;}
.reduce .scale .btnDown a {display:block; margin:0 24.2375%;}
.reduce .result {padding:8% 0 10%; background-color:#dffbf9;}
.reduce .result ul {overflow:hidden; padding:0 1%;}
.reduce .result ul li {float:left; width:33.33333%;}
.reduce .result ul li div {position:relative; margin:0 1%;}
.reduce .result ul li .close {position:absolute; top:0; left:0; width:100%;}
.reduce .app {position:relative;}
.reduce .app .btnApp {position:absolute; left:0; top:19%; width:100%;}
.reduce .app .btnApp a {display:block; margin:0 26.875%;}
.reduce .noti {background-color:#e1fbff; text-align:left;}
.reduce .noti ul {padding:0 5.41666% 8%;}
.reduce .noti ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54761/blt_hypen.gif); background-repeat:no-repeat; background-position:0 10px; background-size:9px auto; color:#444; font-size:16px; line-height:1.5em;}
.reduce .noti ul li em {color:#d50c0c; font-style:normal;}
@media all and (max-width:480px){
	.reduce .noti ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 6px; background-size:6px auto;}
}
.reduce .tab-area {position:relative; padding:15% 0 4%; border-bottom:1px solid #f05a5a; background-color:#d50c0c;}
.reduce .tab-area strong {display:block; position:absolute; top:8%; left:0; width:100%;}
.reduce .tab-area .tab-nav {overflow:hidden; padding:5% 1.5% 0;}
.reduce .tab-area .tab-nav li {float:left; width:25%; padding:0 0.625%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.reduce .sns-share {position:relative;}
.reduce .sns-share div {overflow:hidden; position:absolute; top:48%; right:16%; width:54%;}
.reduce .sns-share div a {display:block; float:left; width:33.33333%; padding:0 2%; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}
/* Bounce animation */
@-webkit-keyframes bounce {
	0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
	40% {-webkit-transform: translateY(-7px);}
	60% {-webkit-transform: translateY(-4px);}
}
@keyframes bounce {
	0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
	40% {transform: translateY(-7px);}
	60% {transform: translateY(-4px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

Kakao.init('c967f6e67b0492478080bcf386390fdd');

function kakaosendcall(){
	kakaosend54469();
}

function kakaosend54469(){
	  Kakao.Link.sendTalkLink({
		  label: '[10x10 APP EVENT]\n기승전쇼핑_빼주세요\nAPP 쿠폰',
		  image: {
			src: 'http://webimage.10x10.co.kr/eventIMG/2014/54761/banMo20140903170455.JPEG',
			width: '140',
			height: '100'
		  },
		 appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
				android: { url: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=54760'},
				iphone: { url: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=54760'}
			}
		  },
		  installTalk : Boolean
	  });
}
</script>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If vUserID <> "" Then %>
		<% If getnowdate>="2014-09-10" and getnowdate<"2014-09-13" Then %>
			<% if subscriptcount < 1 and bonuscouponcount < 1 then %>
				var str = $.ajax({
					type: "GET",
					url: "/event/etc/doEventSubscript54760.asp",
					data: "mode=couponreg",
					dataType: "text",
					async: false
				}).responseText;
				if (str==''){
					alert('정상적인 값이 아닙니다.');
					return;
				}else{
					if (String(str).length=='2'){
						$("#resultval").attr("src","http://webimage.10x10.co.kr/eventIMG/2014/54760/img_win_"+ str +".gif");
						setTimeout("alert('쿠폰이 발행되었습니다!! 참여해 주셔서 감사합니다.'); top.location.href='/event/eventmain.asp?eventid=<%= getevt_code %>'",500)
					}else{
						alert('이미 참여 하셨거나, 종료된 이벤트 입니다.');
						return;
					}
				}
			<% else %>
				alert("쿠폰은 한 개의 아이디당 하루 한 번만 다운 받으실 수 있습니다.");
				return;
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		alert('로그인을 하셔야 쿠폰을\n다운받을 수가 있습니다.');
		top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=getevt_code%>"
	<% End IF %>
}

</script>

</head>
<body>
	<div class="evtView tMar15" style="padding:0;">
		<!-- 빼주세요 APP 쿠폰 -->
		<div class="mEvt54761">
			<div class="reduce">
				<div class="section heading">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/txt_reduce.gif" alt="연휴의 마무리, 빼야 할 것은 몸무게 뿐이 아니다! 빼주세요, 앱쿠폰!" /></p>
					<p class="gift"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/txt_event.gif" alt="연휴가 끝나면 빼야 할 것은 몸무게 만이 아닙니다. 3일 동안 진행되는 파격적인 APP쿠폰으로 가격도 확실하게 빼세요! 텐바이텐 APP에서만 사용 가능합니다. 다운 후 24시간이내 사용가능해요. 이벤트 기간은 9월 10일부터 9월 12일까지 입니다." /></p>
				</div>

				<div class="section scale">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_scale.gif" id="resultval" alt="" /></div>
					<div class="win">
						<%' <img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_win_01.gif" alt="15% 할인 쿠폰" /> %>
						<%' <img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_win_02.gif" alt="오천원 쿠폰" /> %>
						<%' <img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_win_03.gif" alt="만원 쿠폰" /> %>
					</div>
					<div class="btnDown"><a href="" onclick="jseventSubmit(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/btn_down.png" alt="쿠폰 다운받기" /></a></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_scale_btm.gif" alt="" /></div>
				</div>

				<div class="section result">
					<ul>
						<li>
							<div>
								<% if subscriptcount1<1 then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/tab_01_off.gif" alt="9월 10일 수요일" />
								<% else %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/tab_01_on.gif" alt="15% 할인 쿠폰" />
								<% end if %>
								<span class="close" style="display:<% If getnowdate < "2014-09-11" Then %>none<% else %>block<% end if %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_close.png" alt="종료" /></span>
							</div>
						</li>
						<li>
							<div>
								<% if subscriptcount2<1 then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/tab_02_off.gif" alt="9월 11일 목요일" />
								<% else %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/tab_02_on.gif" alt="만원 이상 구매시 사용 가능한 오천원 할인 쿠폰" />
								<% end if %>
								<span class="close" style="display:<% If getnowdate < "2014-09-12" Then %>none<% else %>block<% end if %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_close.png" alt="종료" /></span>
							</div>
						</li>
						<li>
							<div>
								<% if subscriptcount3<1 then %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/tab_03_off.gif" alt="9월 12일 금요일" />
								<% else %>
									<img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/tab_03_on.gif" alt="3만원 이상 구매시 사용 가능한 만원 할인 쿠폰" />
								<% end if %>
								<span class="close" style="display:<% If getnowdate < "2014-09-13" Then %>none<% else %>block<% end if %>;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_close.png" alt="종료" /></span>
							</div>
						</li>
					</ul>
				</div>

				<div class="section app">
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/img_wave.gif" alt="" />
					<div class="btnApp"><a href="http://m.10x10.co.kr/apps/link/?1120140905" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/btn_app.png" alt="텐바이텐 앱 바로가기" /></a></div>
				</div>

				<div class="section noti">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/tit_noti.gif" alt="이벤트 유의사항" /></h3>
					<ul>
						<li>텐바이텐 APP에서만 사용 가능합니다.</li>
						<li>한 ID당 1회 발금, 1회 사용 할 수 있습니다.</li>
						<li>쿠폰은 다운 후 24시간 이내 사용 가능합니다.</li>
						<li>주문하시는 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
						<li>이벤트는 조기 마감될 수 있습니다.</li>
					</ul>
				</div>

				<!-- sns -->
				<%
				'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
				dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
				snpTitle = Server.URLEncode(ename)
				snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=" & ecode)
				snpPre = Server.URLEncode("텐바이텐 이벤트")
				snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
				snpTag2 = Server.URLEncode("#10x10")
				snpImg = Server.URLEncode(emimg)
				%>
				<div class="section sns-share">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/txt_sns.gif" alt="친구야 너 같이 뺄래?" /></p>
					<div>
						<a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/ico_sns_twitter.gif" alt="트위터" /></a>
						<a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/ico_sns_facebook.gif" alt="페이스북" /></a>
						<a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54761/ico_sns_kakao.gif" alt="카카오톡" /></a>
					</div>
				</div>

				<div class="section tab-area">
					<strong class="animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54591/txt_wellorganized_shopping.png" alt="아침 드라마보다 더 극적인 기승전 쇼핑" /></strong>
					<ul class="tab-nav">
						<!-- #include virtual="/event/etc/iframe_54469_topmenu.asp" -->
					</ul>
				</div>
			</div>
		</div>
		<!-- //빼주세요 APP 쿠폰 -->
	</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->