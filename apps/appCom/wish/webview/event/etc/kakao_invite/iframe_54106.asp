<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 친구하나! 치킨둘 kakao 친구초대
' History : 2014.08.11 한용민
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/rndSerial.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/kakao_invite/event54106Cls.asp" -->

<%
dim eCode, userid
	eCode=getevt_code
	userid = getloginuserid()

Dim upin
	upin = requestCheckVar(request("upin"),50)

dim oinvite, subscriptcount, subscriptcount1, subscriptcount2, tmpusername, tmpval, tmpvalarr
	subscriptcount=0
	subscriptcount1=0
	subscriptcount2=0
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<title>생활감성채널, 텐바이텐 > 이벤트 > 친구하나! 치킨둘</title>

<%
'//초대수락
if upin<>"" then
	set oinvite = new Cevent_etc_common_list
		oinvite.frectsub_idx=rdmSerialDec(upin)
		oinvite.frectevt_code=eCode
		oinvite.frectsub_opt1=getnowdate

		if upin<>"" then
			oinvite.event_subscript_one
		end if
	
		if oinvite.ftotalcount >0 then
			subscriptcount=1

			if oinvite.FOneItem.fsub_opt2=2 then
				subscriptcount2=1
			end if
		end if
	set oinvite=nothing
%>
	<style type="text/css">
	.mEvt54106 {position:relative;}
	.mEvt54106 img {vertical-align:top; width:100%;}
	.mEvt54106 p {max-width:100%;}
	.chicken .section, .chicken .section h2, .chicken .section h3 {margin:0; padding:0;}
	.chicken .section1 {position:relative;}
	.chicken .section1 .total {position:absolute; top:50%; left:32%; width:22%;}
	.chicken .section2 {padding:0 3%;padding-bottom:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/54106/bg_pager_mint.gif) repeat-y 0 0; background-size:100% auto;}
	.chicken .section2 .part fieldset {border:0;}
	.chicken .section2 .part legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
	.chicken .section2 .part {padding:5% 4%; background-color:#a8ece5; border-radius:12px; box-shadow:0 5px #5cc7ba;}
	.chicken .section2 .part label {display:block; padding-top:15px;}
	.chicken .section2 .part label:first-child {padding-top:0;}
	.chicken .section2 .part input[type=text], .chicken .section2 .part input[type=tel] {width:100%; height:40px; padding:0 10px; border:2px solid #64cfc4; border-radius:5px; box-shadow:0 1px #fff; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; color:#000; font-weight:bold; line-height:40px;}
	.chicken .section2 .part input[type=checkbox] {margin:0; padding:0; -webkit-appearance:none; border-radius:0;}
	.chicken .section2 .part input[type=checkbox] {position:absolute; left:0; top:50%; width:30px; height:30px; margin-top:-15px; border:2px solid #64cfc4; border-radius:5px; box-shadow:0 1px #fff; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; background-color:#fff;}
	.chicken .section2 .part input[type=checkbox]:checked {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54106/ico_check.gif); background-repeat:no-repeat; background-position:50% 50%; background-size:14px auto;}
	.chicken .section2 .part .agree {position:relative;}
	.chicken .section2 .part .btnView {position:absolute; right:0; bottom:25%; width:17%;}
	.chicken .section2 .part input[type=image] {width:100%; margin:1% 0 3%;}
	.chicken .section2 .part .terms {padding:5px 0 10px; color:#4b6a66;}
	.chicken .section2 .part .terms p {line-height:1.5em;}
	@media all and (max-width:480px){
		.chicken .section2 .part input[type=checkbox] {width:20px; height:20px; margin-top:-10px;}
	}
	@media all and (min-width:768px){
		.chicken .section2 .part input[type=text], .chicken .section2 .part input[type=tel] {height:60px;}
		.chicken .section2 .part input[type=checkbox] {width:30px; height:30px; margin-top:-20px;}
		.chicken .section2 .part .terms p {font-size:15px; line-height:1.5em;}
		.chicken .section2 .part .btnView {bottom:30%;}
	}
	.chicken .section3 {position:relative;}
	.chicken .section3 .btnCheck {position:absolute; top:10%; right:5%; width:30.83333%;}
	.chicken .section4 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/54106/bg_paper.gif) repeat-y 0 0; background-size:100% auto; text-align:left;}
	.chicken .section4 h2 {padding:5% 0 2%;}
	.chicken .section4 ul {padding:0 4.79166% 5%;}
	.chicken .section4 ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54106/blt_dot_grey.png); background-repeat:no-repeat; background-position:0 8px; background-size:6px auto; color:#333; font-size:16px; line-height:1.5em;}
	.chicken .section4 ul li a {color:#333; text-decoration:none;}
	@media all and (max-width:480px){
		.chicken .section4 ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 5px; background-size:4px auto;}
	}
	.animated {-webkit-animation-fill-mode:both; animation-fill-mode:both;}
	/* Bounce animation */
	@-webkit-keyframes bounce {
		0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
		40% {-webkit-transform: translateY(-5px);}
		60% {-webkit-transform: translateY(-5px);}
	}
	@keyframes bounce {
		0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
		40% {transform: translateY(-5px);}
		60% {transform: translateY(-5px);}
	}
	.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
	/* Flash animation */
	@-webkit-keyframes flash {
		0%, 50%, 100% {opacity: 1;}
		25%, 75% {opacity:0.7;}
	}
	@keyframes flash {
		0%, 50%, 100% {opacity: 1;}
		25%, 75% {opacity:0.7;}
	}
	.flash {-webkit-animation-name:flash; animation-name:flash; -webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
	</style>

	<script type="text/javascript">

	function IsDouble(v){
		if (v.length<1) return false;
	
		for (var j=0; j < v.length; j++){
			if ("0123456789.".indexOf(v.charAt(j)) < 0) {
				return false;
			}
		}
		return true;
	}

	$(function(){
		$(".chicken .terms").hide();
		$(".chicken .btnView").click(function(){
			var imgChange = $(this).find("img").attr("src").replace("_on.gif", "_off.gif");
			$(this).find("img").attr("src", imgChange);
			$(".chicken .terms").slideDown();
			return false;
		});
	});

	function sendval() {
		if ('<%= upin %>'==''){
			alert('정상적인 경로가 아닙니다.');
			return;
		}

		<% If getnowdate>="2014-08-13" and getnowdate<"2014-08-21" Then %>
			<% if subscriptcount2=0 then %>
				<% if subscriptcount>0 then %>
					var username = document.getElementById("username")
					var userhp = document.getElementById("userhp")
					var checkagree = document.getElementById("checkagree")
					if (!checkagree.checked){
						alert('개인정보 수집 정책에 동의해 주세요.');
						checkagree.focus();
						return;
					}
					if (username.value==''){
						alert('이름을 입력해 주세요.');
						username.focus();
						return;
					}
					if (userhp.value==''){
						alert('휴대폰번호를 입력해 주세요.');
						userhp.focus();
						return;
					}
					if (!IsDouble(userhp.value)){
						alert('휴대폰번호는 숫자만 입력해 주세요.');
						userhp.focus();
						return;
					}
					
					evtfrm.upin.value='<%= upin %>';
			   		evtfrm.mode.value="replyreg";
			   		evtfrm.username.value=username.value;
			   		evtfrm.userhp.value=userhp.value;
					evtfrm.action="/apps/appcom/wish/webview/event/etc/kakao_invite/doEventSubscript54106.asp";
					evtfrm.target="evtFrmProc";
					evtfrm.submit();
				<% else %>
					alert("친구초대된 내역이 없습니다. 내일 다시 도전해 주세요.!");
					return;
				<% end if %>
			<% else %>
				alert("이미 친구초대가 완료 되었습니다. 내일 다시 도전해 주세요.!");
				return;
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
    }

	</script>
	
	<!-- 친구하나!치킨둘! -->
	<div class="mEvt54106">
		<div class="chicken">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_chicken_with_friend.jpg" alt="텐바이텐말복앵콜이벤트 친구하나! 치킨둘! 이벤트 기간은 8월 13일 수요일부터 8월 20일 수요일까지이며, 당첨자 발표는 8월 22일 금요일입니다." /></p>
				<p><a href="http://m.10x10.co.kr/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=544920" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_gift.jpg" alt="친구 1명에게 카톡으로 이벤트를 알려주면, 치킨 총 2마리를 드려요! 친구와 사이 좋게 나눠 드세요" /></a></p>
				<strong class="total animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_total_100peoples.png" alt="총 100명에서 200마리" /></strong>
			</div>

			<!-- for dev msg : 이벤트에 참여하기 -->
			<div class="section section2">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/tit_event_take.gif" alt="응모 방법 알려드려요" /></h2>
				<div class="part">
					<form action="">
						<fieldset>
						<legend>이름과 휴대폰 번호 입력하기</legend>
							<label for="yourname"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_label_name.gif" alt="이름을 입력하세요" /></label>
							<input type="text" name="username" id="username" />
							<label for="yourphone"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_label_phone.gif" alt="휴대폰 번호를 입력하세요" /></label>
							<input type="tel" name="userhp" id="userhp" />
							<div class="agree">
								<input type="checkbox" name="checkagree" id="checkagree" />
								<label for="youragree"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_agree.gif" alt="개인정보 수집 정책에 동의합니다." /></label>
								<a href="#terms" class="btnView"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/btn_view.gif" alt="내용보기" /></a>
							</div>
							<div id="terms" class="terms">
								<p>
									1. 수집하는 개인정보 항목- 이름, 전화번호<br />
									2. 수집 목적 - 경품의 정확한 전달을 위한 확보<br />
									3. 수집 방법 - 고객의 정보 입력<br />
									<!--4. 개인정보 취급 위탁 - 인포뱅크(주) : 경품지급 안내를 위한 SMS, MMS등 문자메세지 전송 - (주)옴니텔 : 모바일 상품권 발송 대행 - (주)GS25리테일 : 모바일 상품권 사용처<br />-->
									4. 개인정보 보유기간 - 수집일로부터 3개월 (이벤트 종료 후 파기)<br />
									본 이벤트를 통해 취합된 개인정보는 오직 이벤트 응모를 통한 경품 지급에만 활용될 예정이며, 이외의 마케팅/광고 목적으로 사용되지 않습니다.
								</p>
							</div>
							<input type="image" onclick="sendval(); return false;" src="http://webimage.10x10.co.kr/eventIMG/2014/54106/btn_entry.png" alt="이벤트 응모하기" />
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_reason.gif" alt="휴대폰 번호 입력은 이벤트 당첨 여부를 알려드리기 위함입니다." /></p>
						</fieldset>
					</form>
				</div>
			</div>
			<div class="section section3">
				<!-- for dev msg : 응모여부 체크 -->
				<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_code %>" target="_top">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_check_u.jpg" alt="당신도 치킨에 도전해 보세요! 이벤트에 응모완료하셨다면! 당신도 직접 치킨에 도전해 보세요 : )" /></p>
					<div class="btnCheck animated flash"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/btn_check.png" alt="" /></div>
				</a>
			</div>
			<div class="section section4">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/tit_noti.png" alt="이벤트 유의사항" /></h2>
				<ul>
					<li>본 이벤트는 텐바이텐 앱 전용이벤트입니다. 로그인 후에만 참여하실 수 있습니다.</li>
					<li>이벤트는 아이디당 하루에 1회만 참여 가능합니다.</li>
					<li>당첨 시, 바베큐치킨봉은 이벤트를 알려준 친구에게 2마리 모두 배송됩니다.</li>
					<li>이벤트 문의는 텐바이텐CS <a href="tel:1644-6030">1644-6030</a>으로 주시기 바랍니다.</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- //친구하나!치킨둘! -->

<%
'//초대신청
else

	set oinvite = new Cevent_etc_common_list
		oinvite.frectuserid=userid
		oinvite.frectevt_code=eCode
		oinvite.frectsub_opt1=getnowdate
		
		If IsUserLoginOK() Then
			oinvite.event_subscript_one()
		end if
		
		if oinvite.ftotalcount >0 then
			subscriptcount=1
			tmpval = oinvite.foneitem.fsub_opt3
			
			if tmpval<>"" then
				tmpvalarr=split(tmpval,"!@#")
				
				if ubound(tmpvalarr)=1 then
					tmpusername=tmpvalarr(0)
				end if
			end if
			if oinvite.FOneItem.fsub_opt2=2 then
				subscriptcount2=1
			end if
		end if
	set oinvite=nothing
%>
	<style type="text/css">
	.mEvt54106 {position:relative;}
	.mEvt54106 img {vertical-align:top; width:100%;}
	.mEvt54106 p {max-width:100%;}
	.chicken .section, .chicken .section h2, .chicken .section h3 {margin:0; padding:0;}
	.chicken .section1 {position:relative;}
	.chicken .section1 .total {position:absolute; top:50%; left:32%; width:22%;}
	.chicken .section2 {position:relative;}
	.chicken .section2 ol {overflow:hidden;}
	.chicken .section2 ol li {float:left; width:50%;}
	.chicken .section2 .btnEntry {position:absolute; bottom:4%; left:0; width:100%; padding:0 8%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
	.chicken .section3 {position:relative;}
	.chicken .section3 .btnCheck {position:absolute; top:13%; right:5%; width:30.83333%;}
	.chicken .section4 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/54106/bg_paper.gif) repeat-y 0 0; background-size:100% auto; text-align:left;}
	.chicken .section4 h2 {padding:5% 0 2%;}
	.chicken .section4 ul {padding:0 4.79166% 5%;}
	.chicken .section4 ul li {margin-top:7px; padding-left:15px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/54106/blt_dot_grey.png); background-repeat:no-repeat; background-position:0 8px; background-size:6px auto; color:#333; font-size:16px; line-height:1.5em;}
	.chicken .section4 ul li a {color:#333; text-decoration:none;}
	@media all and (max-width:480px){
		.chicken .section4 ul li {margin-top:2px; padding-left:10px; font-size:11px; background-position:0 5px; background-size:4px auto;}
	}
	.animated {-webkit-animation-fill-mode:both; animation-fill-mode:both;}
	/* Bounce animation */
	@-webkit-keyframes bounce {
		0%, 20%, 50%, 80%, 100% {-webkit-transform: translateY(0);}
		40% {-webkit-transform: translateY(-5px);}
		60% {-webkit-transform: translateY(-5px);}
	}
	@keyframes bounce {
		0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
		40% {transform: translateY(-5px);}
		60% {transform: translateY(-5px);}
	}
	.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
	/* Flash animation */
	@-webkit-keyframes flash {
		0%, 50%, 100% {opacity: 1;}
		25%, 75% {opacity:0.7;}
	}
	@keyframes flash {
		0%, 50%, 100% {opacity: 1;}
		25%, 75% {opacity:0.7;}
	}
	.flash {-webkit-animation-name:flash; animation-name:flash; -webkit-animation-duration:2s; animation-duration:2s; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
	</style>
	
	<script type="text/javascript">
	</script>
	</head>
	<body class="event">
	
	<!-- 친구하나!치킨둘! -->
	<div class="mEvt54106">
		<div class="chicken">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_chicken_with_friend.jpg" alt="텐바이텐말복앵콜이벤트 친구하나! 치킨둘! 이벤트 기간은 8월 13일 수요일부터 8월 20일 수요일까지이며, 당첨자 발표는 8월 22일 금요일입니다." /></p>
				<p><a href="http://m.10x10.co.kr/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=544920" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_gift.jpg" alt="친구 1명에게 카톡으로 이벤트를 알려주면, 치킨 총 2마리를 드려요! 친구와 사이 좋게 나눠 드세요" /></a></p>
				<strong class="total animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_total_100peoples.png" alt="총 100명에서 200마리" /></strong>
			</div>
	
			<div class="section section2">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/tit_event_entry.jpg" alt="응모 방법 알려드려요" /></h2>
				<ol>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_event_entry_01.jpg" alt="스텝 1 친구에게 카카오톡 보내기" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_event_entry_02.jpg" alt="스텝 2 내 친구 1명 선택하고, 이벤트 알려주기" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_event_entry_03.jpg" alt="스텝 3 친구가 카톡 메시지 받고 이벤트 페이지에 응모하기" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_event_entry_04.jpg" alt="스텝 4 당첨되면 치킨 두 마리를 친구와 사이 좋게 나눠 먹기" /></li>
				</ol>
				<!-- for dev msg : 친구에게 카톡 보내기 -->
				<div class="btnEntry"><a id="kakaoa" href="javascript:sendLink();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/btn_kakaotalk.png" alt="친구에게 카카오톡 보내기" /></a></div>
				<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
				<script>
					
			    Kakao.init('c967f6e67b0492478080bcf386390fdd');
			
				function sendLink() {
					<% If IsUserLoginOK() Then %>
						<% If getnowdate>="2014-08-13" and getnowdate<"2014-08-21" Then %>
							<% if subscriptcount2=0 then %>
								<% if subscriptcount<1 then %>
									var str = $.ajax({
										type: "GET",
										url: "/apps/appcom/wish/webview/event/etc/kakao_invite/doEventSubscript54106.asp",
										data: "mode=invitereg",
										dataType: "text",
										async: false
									}).responseText;
									if (str==''){
										alert('정상적인 경로가 아닙니다');
										return;
									}

							      Kakao.Link.sendTalkLink({
									  label: '[텐바이텐 EVENT]친구1명 오면, 치킨 2마리가 간다!친구야~우리 같이 치킨 먹자~',
									  image: {
										src: 'http://imgstatic.10x10.co.kr/offshop/temp/2014/20140812/event54106kakao.jpg',
										width: '300',
										height: '200'
									  },
									 appButton: {
										text: '10X10 앱으로 이동',
										execParams :{
										<% IF application("Svr_Info") = "Dev" THEN %>
											android: { url: encodeURIComponent('http://testm.10x10.co.kr:8080/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_code %>&upin='+str)},
											iphone: { url: 'http://testm.10x10.co.kr:8080/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_code %>&upin='+str}
										<% Else %>
											android: { url: encodeURIComponent('http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_code %>&upin='+str)},
											iphone: { url: 'http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= getevt_code %>&upin='+str}
										<% End If %>
										}
									  },
									  installTalk : Boolean
							      });
	
				      				top.location.href='/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%=getevt_code%>';
								<% else %>
									alert("이미 친구초대를 하셨습니다. 내일 다시 도전해 주세요.!");
									return;
								<% end if %>
							<% else %>
								alert("이미 친구초대가 완료 되었습니다. 내일 다시 도전해 주세요.!");
								return;
							<% end if %>
						<% else %>
							alert("이벤트 응모 기간이 아닙니다.");
							return;
						<% end if %>
					<% Else %>
						calllogin();
						return;
						//parent.jsevtlogin();
						//return;
						//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
						//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
						//	winLogin.focus();
						//	return;
						//}
					<% End IF %>
			    }

				function sendwinner() {
					<% If IsUserLoginOK() Then %>
						<% If getnowdate>="2014-08-13" and getnowdate<"2014-08-21" Then %>
					   		evtfrm.mode.value="winnerreg";
							evtfrm.action="/apps/appcom/wish/webview/event/etc/kakao_invite/doEventSubscript54106.asp";
							evtfrm.target="evtFrmProc";
							evtfrm.submit();
						<% else %>
							alert("이벤트 응모 기간이 아닙니다.");
							return;
						<% end if %>
					<% Else %>
						calllogin();
						return;
						//parent.jsevtlogin();
						//return;
						//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
						//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
						//	winLogin.focus();
						//	return;
						//}
					<% End IF %>
			    }

				</script>
			</div>
			<div class="section section3">
				<% ' for dev msg : 응모여부 체크 %>
				<a href="" onclick="sendwinner(); return false;">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/txt_check.jpg" alt="친구야~ 이벤트 응모했니?? 카톡을 보낸 친구가 이벤트에 응모했는지 궁금하면, 치킨무를 눌러 확인해보세요~" /></p>
					<div class="btnCheck animated flash"><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/btn_check.png" alt="치킨무" /></div>
				</a>
			</div>
			<div class="section section4">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/54106/tit_noti.png" alt="이벤트 유의사항" /></h2>
				<ul>
					<li>본 이벤트는 텐바이텐 앱 전용이벤트입니다. 로그인 후에만 참여하실 수 있습니다.</li>
					<li>이벤트는 아이디당 하루에 1회만 참여 가능합니다.</li>
					<li>당첨 시, 바베큐치킨봉은 이벤트를 알려준 친구에게 2마리 모두 배송됩니다.</li>
					<li>이벤트 문의는 텐바이텐CS <a href="tel:1644-6030">1644-6030</a>으로 주시기 바랍니다.</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- //친구하나!치킨둘! -->

<% end if %>

<form name="evtfrm" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="username">
	<input type="hidden" name="userhp">
	<input type="hidden" name="upin">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->