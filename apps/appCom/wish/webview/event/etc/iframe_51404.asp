<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐바이텐 웰컴 투 APP어랜드 
' History : 2014.04.25 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event51404Cls.asp" -->

<%
dim eCode, userid, kakaotalkscriptcount, giftscriptcount, ridescriptcount
	eCode=getevt_code
	userid = getloginuserid()

kakaotalkscriptcount=0
giftscriptcount=0
ridescriptcount=0

if userid<>"" then
	kakaotalkscriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")	'//카카오톡 초대여부
	giftscriptcount = getevent_subscriptexistscount(eCode, userid, "", "3", "")		'//기프트 응모여부
	ridescriptcount = getevent_subscriptexistscount(eCode, userid, "", "4", "")		'//놀이기구 응모여부
end if

%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<style type="text/css">
dl, dt, dd, ol, ul, li {margin:0; padding:0; border:0; font:inherit; vertical-align:baseline;}
ol, ul {list-style:none;}
.mEvt51404 {position:relative;}
.mEvt51404 p {max-width:100%;}
.mEvt51404 img {vertical-align:top; width:100%;}
.mEvt51404 .enterAppLand {}
.mEvt51404 .enterAppLand li {position:relative;}
.mEvt51404 .enterAppLand li span {display:block; position:absolute; left:23%; bottom:8%; width:54%;}
.mEvt51404 .enterAppLand li span .eBtn {width:100%;}
.mEvt51404 .evtNotice {padding:18px 10px 0;}
.mEvt51404 .evtNotice dt {padding-bottom:5px;}
.mEvt51404 .evtNotice li {padding:0 0 7px 5px; font-size:11px; line-height:14px; letter-spacing:-0.063em; color:#3e3e3e; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_blt_square.png) left 6px no-repeat; background-size:1px 1px;}
.mEvt51404 .viewPresent {display:none; position:absolute; left:0; top:0; width:100%; height:100%; z-index:30;}
.mEvt51404 .viewPresent .pCont {position:absolute; left:5%; top:38%; z-index:30; width:90%; padding-bottom:25px; background:#fff;}
.mEvt51404 .viewPresent .myPresent {margin:0 10px 15px; padding:10px; background:#f5f5f5;}
.mEvt51404 .viewPresent .myPresent .gifticon {padding:8px 0; background:#fff;}
.mEvt51404 .viewPresent .myPresent .gifticon .img {margin:0 auto; background:#fff;}
.mEvt51404 .viewPresent .myPresent .barcode {margin:0 10px 10px; padding:15px 10px; border:1px solid #ddd; border-radius:5px; background:#f3f3f3;}
.mEvt51404 .viewPresent .closeBtn {display:block; width:54%; margin:0 auto;}
.mEvt51404 .viewPresent .bg {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.5); z-index:20;}
</style>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">

function jsgift_ajax(){
	var str = $.ajax({
			type: "GET",
	        url: "/apps/appcom/wish/webview/event/etc/iframe_51404_gift_ajax.asp",
			cache: false,
	        dataType: "text",
	        async: false
	}).responseText;
	//alert( str );
	$(".viewPresent").empty().html(str);
	$('.viewPresent').fadeIn();

	$('.viewPresent .closeBtn').click(function(){
		//$('.viewPresent').fadeOut();
		top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid=<%= eCode %>'
	});
}

function jsSubmitgift_ajax(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #05/30/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다."); return;
		<% Else %>
			<% If getnowdate>="2014-04-30" and getnowdate<"2014-06-01" Then %>
				<% if kakaotalkscriptcount <> 0 then	'/카카오톡 참여여부 %>				
					<% if giftscriptcount <> 0 then %>
						jsgift_ajax();
					<% else %>
						alert("선물가게 참여 내역이 없습니다."); return;
					<% end if %>
				<% else %>
					alert('카카오톡 초대후, 참여 하실수 있습니다.'); return;
				<% end if %>
			<% else %>
				alert("이벤트 참여 기간이 아닙니다."); return;
			<% end if %>				
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다'); document.location.reload(); return;
	<% End IF %>
}

function jsSubmitgift(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #05/06/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다."); return;
		<% Else %>
			<% If getnowdate>="2014-04-30" and getnowdate<"2014-05-07" Then %>
				<% if kakaotalkscriptcount <> 0 then	'//카카오톡 참여여부 %>
					<% if giftscriptcount = 0 then %>
				   		evtfrm.mode.value="giftadd";
						evtfrm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript51404.asp";
						evtfrm.target="evtFrmProc";
						evtfrm.submit();
						return;
					<% else %>
						alert("이미 참여하셨습니다."); return;
					<% end if %>
				<% else %>
					alert('카카오톡 초대후, 참여 하실수 있습니다.'); return;
				<% end if %>
			<% else %>
				alert("이벤트 참여 기간이 아닙니다."); return;
			<% end if %>				
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다'); document.location.reload(); return;
	<% End IF %>
}

function jsSubmitride(){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #05/06/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다."); return;
		<% Else %>
			<% If getnowdate>="2014-04-30" and getnowdate<"2014-05-07" Then %>
				<% if kakaotalkscriptcount <> 0 then	'//카카오톡 참여여부 %>		
					<% if ridescriptcount = 0 then %>
				   		evtfrm.mode.value="rideadd";
						evtfrm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript51404.asp";
						evtfrm.target="evtFrmProc";
						evtfrm.submit();
						return;
					<% else %>
						alert("이미 참여하셨습니다."); return;
					<% end if %>
				<% else %>
					alert('카카오톡 초대후, 참여 하실수 있습니다.'); return;
				<% end if %>
			<% else %>
				alert("이벤트 참여 기간이 아닙니다."); return;
			<% end if %>				
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다'); document.location.reload(); return;
	<% End IF %>
}

function jsSubmitkakaotalk(eventtype){
	if (eventtype==''){
		alert('이벤트참여를 정상적인 경로로 해주세요.'); return;
	}
	<% If IsUserLoginOK() Then %>
		<% If Now() > #05/06/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다."); return;
		<% Else %>
			<% If getnowdate>="2014-04-30" and getnowdate<"2014-05-07" Then %>
				<% if kakaotalkscriptcount = 0 then %>
			   		evtfrm.mode.value="kakaotalkadd";
			   		evtfrm.eventtype.value=eventtype;
					evtfrm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript51404.asp";
					evtfrm.target="evtFrmProc";
					evtfrm.submit();
				<% else %>
					alert("이미 참여하셨습니다."); return;
				<% end if %>
			<% else %>
				alert("이벤트 참여 기간이 아닙니다."); return;
			<% end if %>				
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다'); document.location.reload(); return;
	<% End IF %>
}

function kakaosend(){
	var url =  "http://bit.ly/1hFTJU0";
	kakao.link("talk").send({
		msg : "웰컴 투 WISH APP어랜드!\n황금연휴를 맞이하여 특별히 APP어랜드를 오픈합니다.\n100% 선물 이벤트와 환상의 퍼레이드가 여러분을 기다립니다.",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "텐바이텐과 썸타는 이벤트",
		type : "link"
	});
}

</script>
</head>
<body>

<!-- 웰컴 투 WISH APP어랜드 -->
<div class="mEvt51404">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_head_new.png" alt="웰컴 투 WISH APP어랜드" /></h2>
	<ul class="enterAppLand">
		<!--<li>
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_ticket.png" alt="매표소 - 카카오톡으로 함께 가고 싶은 친구를 초대하세요!" />
			<span onclick="jsSubmitkakaotalk(2);"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_invite.png" alt="초대하기" class="eBtn" /></span>
		</li>-->
		<li id="getPresent">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_present.png" alt="선물가게 - WISH APP어랜드의 랜드마크! 100% 선물당첨" />
			<span class="eBtn openPresent"  id="giftbutton">
				<% If IsUserLoginOK() Then %>
					<%
					'//카카오톡 참여여부
					if kakaotalkscriptcount <> 0 then
					%>
						<%
						'선물 참여여부
						if giftscriptcount = 0 then
						%>
							<a href="#" onclick="jsSubmitgift(); return false;">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_present.png" alt="선물받기" />
							</a>
						<% else %>
							<a href="#" onclick="jsSubmitgift_ajax(); return false;">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_storage.png" alt="보관함" />
							</a>
						<% end if %>
					<% else %>
						<a href="#" onclick="alert('카카오톡 초대후, 참여 하실수 있습니다.'); return false;">
							<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_present.png" alt="선물받기" />
						</a>
					<% end if %>
				<% else %>
					<a href="#" onclick="alert('로그인후 참여 하실수 있습니다.'); document.location.reload(); return false;">
						<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_present.png" alt="선물받기" />
					</a>
				<% end if %>
			</span>
		</li>
		<!--<li>
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_ride.png" alt="놀이기구 - APP어랜드 말고 에버랜드 자유이용권 2매" />

			<% If IsUserLoginOK() Then %>
				<%
				'//카카오톡 참여여부
				if kakaotalkscriptcount <> 0 then
				%>
					<span onclick="jsSubmitride();"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_apply.png" alt="응모하기" class="eBtn" /></span>
				<% else %>
					<span onclick="alert('카카오톡 초대후, 참여 하실수 있습니다.');"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_apply.png" alt="응모하기" class="eBtn" /></span>
				<% end if %>
			<% else %>
				<span onclick="alert('로그인후 참여 하실수 있습니다.'); document.location.reload();"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_apply.png" alt="응모하기" class="eBtn" /></span>
			<% end if %>
		</li>-->
		<li>
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_parade.png" alt="퍼레이드 - 환상의 이벤트 퍼레이드! 브랜드 런칭, 세일 기획전" />
			<span><a href="/apps/appcom/wish/webview/event/eventlist.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_enter.png" alt="입장하기" class="eBtn" /></a></span>
		</li>
	</ul>
	<dl class="evtNotice">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_tit_notice.png" alt="이벤트 유의사항" style="width:73px;" /></dt>
		<dd>
			<ul>
				<li>매표소에서 친구에게 카카오톡 메시지를 보내야 이벤트 참여가 가능합니다.</li>
				<li>선물가게는 한ID당 1회 참여 가능합니다.</li>
				<li>당첨 발표 당시의 재고 수량에 따라 상품이 변경될 수 있습니다.</li>
				<li>당첨 시 상품 수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
				<li>에버랜드 자유이용권은 5분에게 2매씩 드립니다.</li>
				<li>에버랜드 당첨자는 5월 9일 발표합니다.</li>
				<li>맥북 당첨자는 5월 7일 개별 통보합니다.</li>
			</ul>
		</dd>
	</dl>

	<!-- 선물 당첨 레이어 -->
	<div class="viewPresent">

	</div>
	<!-- // 선물 당첨 레이어 -->
</div>
<!-- //웰컴 투 WISH APP어랜드 -->

<form name="evtfrm" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="mode">
<input type="hidden" name="eventtype">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->