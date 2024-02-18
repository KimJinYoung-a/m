<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 당신이 너무 눈부셔서(APP이벤트)
' History : 2014.11.07 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event56327Cls.asp" -->
<%
dim eCode, userid, subscriptcount, i
	eCode=getevt_code
	userid = getloginuserid()

dim totalmysubscriptcount, myisusingsubscriptcount, mysubscriptarr, mysubscriptresultval
	totalmysubscriptcount=0
	myisusingsubscriptcount=0
	mysubscriptarr=""
	mysubscriptresultval=""

If IsUserLoginOK() Then
	'//본인 응모수
	totalmysubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")
	'//템프값		'//카카오톡 친구초대시 1회에 한해서 하루에 한번더 참여가능. 체크를 위해 템프값을 넣어놓음
	myisusingsubscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "3", "")
	'//템프값이 0이 아닐경우 응모수에서 템프값을 뺌
	if myisusingsubscriptcount<>0 then
		totalmysubscriptcount=totalmysubscriptcount-myisusingsubscriptcount
	end if
end if
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<style type="text/css">
.mEvt56327 {position:relative;}
.mEvt56327 img {vertical-align:top;}
.mEvt56327 .dazzlingHead {overflow:hidden;}
.mEvt56327 .dazzling {position:relative; width:100%;}
.mEvt56327 .dazzling p,.mEvt56327 .dazzling h3 {position:absolute; left:0; width:100%; z-index:40;}
.mEvt56327 .dazzling .t01 {top:14%;}
.mEvt56327 .dazzling .t02 {top:22%;}
.mEvt56327 .dazzling .t03 {bottom:0;}
.mEvt56327 .dazzling .light {display:block; position:absolute; left:2%; top:0; z-index:30; width:96%; -webkit-animation-duration:6000ms; -webkit-animation-iteration-count:1; -webkit-animation-timing-function: linear; -moz-animation-duration:2000ms; -moz-animation-iteration-count:1; -moz-animation-timing-function: linear; -ms-animation-duration:2000ms; -ms-animation-iteration-count: infinite; -ms-animation-timing-function: linear; animation-duration:2000ms; animation-iteration-count:1; animation-timing-function: linear; animation-name:spin; -webkit-animation-name:spin; -moz-animation-name: spin; -ms-animation-name: spin;
}
.mEvt56327 .applyEvent {padding-bottom:27px; background:#d6f9ff;}
.mEvt56327 .applyEvent ul {overflow:hidden; padding:0 8px 15px; }
.mEvt56327 .applyEvent li {float:left; width:50%; padding:0 5px; text-align:center;}
.mEvt56327 .applyEvent li input[type=radio] {position:relative; margin:5px 0 15px; border-radius:50%; box-shadow:0 0 4px #8ea3a6; border:0;}
.mEvt56327 .applyEvent li input[type=radio]:checked {background:#fff;}
.mEvt56327 .applyEvent li input[type=radio]:checked:after {content:' '; display:inline-block; position:absolute; left:5px; top:5px; width:10px; height:10px; border-radius:50%; background:#000;}
.mEvt56327 .applyEvent .talkArea {position:relative;}
.mEvt56327 .applyEvent .talkArea .q {position:absolute; left:0; top:0; width:100%;}
.mEvt56327 .applyEvent .talkArea .a {position:absolute; left:0; top:30%; width:100%;}
.mEvt56327 .applyEvent .talk02 .talkArea .a {top:27%;}
.mEvt56327 .applyEvent .talkArea .goPdt {display:block; position:absolute; left:5%; bottom:5%; width:90%; height:46%; text-indent:-9999em;}
.mEvt56327 .btnApply {width:80%; margin:0 auto;}
.mEvt56327 .btnApply input {width:100%;}
.mEvt56327 .btnApply a {width:100%;}
.mEvt56327 .oneMore {position:relative;}
.mEvt56327 .oneMore a {display:block; position:absolute; width:40%; left:4%; bottom:16%;}
.mEvt56327 .phone {display:inline-block; position:absolute; right:5%; top:14%; width:18%;}
.mEvt56327 .balloon {display:inline-block; position:absolute; right:24%; top:10%; width:21%;}
.mEvt56327 .evtNoti {padding:25px 14px; background:#fff; margin-bottom:-50px;}
.mEvt56327 .evtNoti dt {display:inline-block; margin-bottom:12px; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; border-bottom:2px solid #222;}
.mEvt56327 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.mEvt56327 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
@-ms-keyframes spin {from {-ms-transform: rotate(0deg);} to {-ms-transform: rotate(360deg);}}
@-moz-keyframes spin {from { -moz-transform: rotate(0deg);} to { -moz-transform: rotate(360deg);}}
@-webkit-keyframes spin {from { -webkit-transform: rotate(0deg);} to { -webkit-transform: rotate(360deg);}}
@keyframes spin {from {transform:rotate(0deg);} to { transform:rotate(-360deg);}}

@media all and (min-width:480px){
	.mEvt56327 .applyEvent {padding-bottom:41px;}
	.mEvt56327 .applyEvent ul {padding:0 12px 23px; }
	.mEvt56327 .applyEvent li {padding:0 7px;}
	.mEvt56327 .applyEvent li input[type=radio] {margin:7px 0 23px; box-shadow:0 0 6px #8ea3a6;}
	.mEvt56327 .applyEvent li input[type=radio]:checked:after {left:7px; top:7px; width:15px; height:15px;}

	.mEvt56327 .evtNoti {padding:38px 21px;}
	.mEvt56327 .evtNoti dt {font-size:21px; margin-bottom:18px;}
	.mEvt56327 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt56327 .evtNoti li:after {top:4px; border-width:5px 0 5px 7px;}
}
</style>
<script type="text/javascript" src="http://10x10.co.kr/lib/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
$(function(){
	$('.dazzling .t02').delay(2000).effect("pulsate", {times:3},600);
});

function sendval() {
	<% If IsUserLoginOK Then %>
		<% If getnowdate>="2014-11-13" and getnowdate<"2014-11-18" Then %>
			<% if totalmysubscriptcount < 2 then %>
				<% if myisusingsubscriptcount = 0 then %>
			   		//evtfrm.mode.value="eventreg";
					//evtfrm.action="/apps/appcom/wish/web2014/event/etc/doEventSubscript56327.asp";
					//evtfrm.target="evtFrmProc";
					//evtfrm.submit();

					var giftrndNo;
					var tmpgiftrndNogubun='';
					giftrndNo = document.getElementsByName("giftrndNo")
	
					for (i=0; i < giftrndNo.length; i++){
						if (giftrndNo[i].checked){
							tmpgiftrndNogubun=giftrndNo[i].value;
						}
					}
					if (tmpgiftrndNogubun==''){
						alert("상품을 선택해 주세요.");
						return;
					}
					
					var str = $.ajax({
						type: "GET",
						url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript56327.asp",
						data: "mode=eventreg&giftrndNo="+tmpgiftrndNogubun ,
						dataType: "text",
						async: false
					}).responseText;
					if (str==''){
						alert('정상적인 경로가 아닙니다');
						return;
					}else{
						if (String(str).length=='3'){
							if (str=='000'){
								alert('이벤트 응모가 완료되었습니다.당첨자 발표일: 11월 19일! 중복 당첨이 가능하니, 내일 또 응모해보세요~'); top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_codepage %>'
							}else if (str=='222'){
								alert('이벤트 응모 기간이 아닙니다.');
								return;
							}else{
								alert('정상적인 경로가 아닙니다.'); top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_codepage %>'
							}
						}else{
							alert('정상적인 값이 아닙니다');
							return;
						}								
					}
				<% else %>
					alert("이미 응모 하셨습니다. 카카오톡 친구초대시 한번더 응모 하실수 있습니다.");
					return;
				<% end if %>
			<% else %>
				alert("하루에 두번까지만 참여가 가능합니다.");
				return;
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		//회원가입 완료 후 이벤트 페이지로 올 수 있는 아이콘 생성하려고 쿠키꾸움
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript56327.asp",
			data: "mode=notlogin",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr == "111"){
			calllogin();
			return false;
		}else if (rstStr=='222'){
			alert('이벤트 응모 기간이 아닙니다.');
			return false;
		}else{
			alert('오류가 발생했습니다.');
			return false;
		}
	<% End If %>
}

Kakao.init('c967f6e67b0492478080bcf386390fdd');

function kakaosendcall(){
	<% If IsUserLoginOK Then %>
		<% If getnowdate>="2014-11-13" and getnowdate<"2014-11-18" Then %>
			<% if totalmysubscriptcount < 2 then %>
				<% if totalmysubscriptcount > 0 then %>
					<% if myisusingsubscriptcount > 0 then %>
				   		evtfrm.mode.value="kakaoreg";
						evtfrm.action="/apps/appcom/wish/web2014/event/etc/doEventSubscript56327.asp";
						evtfrm.target="evtFrmProc";
						evtfrm.submit();
					<% else %>
						alert("오늘 친구 초대를 이미 하셨네요~ 내일 다시 초대해주세요~ 감사합니다!");
						return;
					<% end if %>
				<% else %>
					alert("응모를 먼저 해주세요.");
					return;
				<% end if %>
			<% else %>
				alert("오늘 친구 초대를 이미 하셨네요~ 내일 다시 응모해주세요~ 감사합니다!");
				return;
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		calllogin();
		return;
	<% End If %>

	kakaosend54471();
}

function kakaosend54471(){
	  Kakao.Link.sendTalkLink({
		  label: '[텐바이텐]들어오실 때, 창문을 닫아주세요.\n당신이 너무 눈부셔서~ 손발을 오그라질 매력 넘치는 선물이 가득!\n지금 이벤트에 참여하세요!',
		  image: {
			src: 'http://imgstatic.10x10.co.kr/offshop/temp/2014/201411/56327.jpg',
			width: '200',
			height: '200'
		  },
		 appButton: {
			text: '이벤트 응모하러 가기',
			execParams :{
			<% IF application("Svr_Info") = "Dev" THEN %>
				android: { url: encodeURIComponent('http://testm.10x10.co.kr:8080/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_codepage %>')},
				iphone: { url: 'http://testm.10x10.co.kr:8080/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_codepage %>'}
			<% Else %>
				android: { url: encodeURIComponent('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_codepage %>')},
				iphone: { url: 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= getevt_codepage %>'}
			<% End If %>
			}
		  },
		  installTalk : Boolean
	  });
}
</script>
</head>
<body>
<div class="evtCont">
	<!-- 당신이 너무 눈부셔서(APP) -->
	<div class="mEvt56327">
		<div class="dazzlingHead">
			<div class="dazzling">
				<p class="t01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/tit_dazzling01.png" alt="들어 올 땐, 창문을 닫아주세요." /></p>
				<h3 class="t02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/tit_dazzling02.png" alt="당신이 너무 눈부셔서" /></h3>
				<p class="t03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/tit_dazzling03.png" alt="들어 올 땐, 창문을 닫아주세요. 당신이 너무 눈부셔서" /></p>
				<span class="light"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/bg_light.png" alt="" /></span>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/bg_head.png" alt="" />
			</div>
			<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/tit_apply.png" alt="당신이 원하는 매력 상품을 골라서 응모해주세요! 매일매일, 하루에 한 번만요." /></h4>
		</div>

		<!-- 이벤트 응모하기 -->
		<div class="applyEvent">
			<ul>
				<li class="talk01">
					<div class="talkArea">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk01.png" alt="" /></p>
						<p class="a"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk01_a.png" alt="" /></p>
						<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1143507" class="goPdt">샤오미 보조배터리</a>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/img_selet_product01.png" alt="샤오미 보조배터리" /></p>
					</div>
					<input type="radio" name="giftrndNo" value="1" />
				</li>
				<li class="talk02">
					<div class="talkArea">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk02.png" alt="" /></p>
						<p class="a"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk02_a.png" alt="" /></p>
						<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=934792" class="goPdt">허니 남자친구 쿠션</a>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/img_selet_product02.png" alt="허니 남자친구 쿠션" /></p>
					</div>
					<input type="radio" name="giftrndNo" value="2" />
				</li>
				<li class="talk03">
					<div class="talkArea">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk03.png" alt="" /></p>
						<p class="a"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk03_a.png" alt="" /></p>
						<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=297934" class="goPdt">로즈 페탈 살브</a>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/img_selet_product03.png" alt="로즈 페탈 살브" /></p>
					</div>
					<input type="radio" name="giftrndNo" value="3" />
				</li>
				<li class="talk04">
					<div class="talkArea">
						<p class="q"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk04.png" alt="" /></p>
						<p class="a"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_talk04_a.png" alt="" /></p>
						<a href="/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=1080351" class="goPdt">바이오더마 클렌징 워터</a>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/img_selet_product04.png" alt="바이오더마 클렌징 워터" /></p>
					</div>
					<input type="radio" name="giftrndNo" value="4" />
				</li>
			</ul>
			<p class="btnApply"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/56327/btn_apply.png" onclick="sendval(); return false;" alt="응모하기" /></p>
		</div>
		<div class="oneMore">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_one_more.png" alt="카톡으로 친구에게 이벤트를 알려주면, 응모 기회를 한번 더 드려요!" /></p>
			<a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/btn_notify.png" alt="이벤트 알리기" /></a>
			<span class="phone"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/img_phone.png" alt="" /></span>
			<span class="balloon"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56327/txt_balloon.png" alt="" /></span>
		</div>
		<!--// 이벤트 응모하기 -->
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
					<li>매일 이벤트를 참여하실 때는, 앱을 닫고, 다시 실행해주세요. (앱 실행 후, 이벤트 배너를 클릭하셔야 참여가 가능합니다.)</li>
					<li>하루에 ID당 1회 응모가 가능하며, 중복 당첨이 가능합니다.</li>
					<li>당첨자 분들 중, 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<!--// 당신이 너무 눈부셔서(APP) -->
</div>

<form name="evtfrm" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->