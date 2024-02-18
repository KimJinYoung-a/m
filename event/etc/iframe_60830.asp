<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2015오픈이벤트
' History : 2015.04.08 한용민 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event60830Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid
	eCode = getevt_code()
	userid = getloginuserid()

dim subscriptcountclear, mileagescount, totalsubscriptcountclear
	subscriptcountclear=0
	mileagescount=0
	totalsubscriptcountclear=0

if getloginuserid<>"" then
	subscriptcountclear = getevent_subscriptexistscount(eCode, userid, "", "4", "")
	'mileagescount = getmileageexistscount(userid, eCode, "", "", "N")
end if

totalsubscriptcountclear = getevent_subscripttotalcount(eCode, getnowdate, "4", "")
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.aprilHoney img {vertical-align:top;}
.aprilHoney button {background-color:transparent;}
.honeyMileage .topic h1 {visibility:hidden; width:0; height:0;}
.honeyMileage .give {padding:8% 0; background-color:#52e4c0; text-align:center;}
.step {position:relative;}
.step .clear {display:none; position:absolute; top:21%; left:7.9%; width:35.62%;}
.step2 .clear {position:absolute; top:15.7%;}
.step3 .clear {position:absolute; top:14.3%;}
.step .btnwrap {position:absolute; top:70%; left:50%; width:29.8%;}
.step2 .btnwrap {top:67%;}
.step3 .btnwrap {top:60%;}
.step .btnwrap button {width:100%;}
.step .btnwrap strong {display:block; display:none; position:relative; text-align:center;}
.step .btnwrap strong span {position:absolute; top:50%; left:0; width:100%; height:20px; margin-top:-10px; font-size:13px; line-height:1.5em; color:#d50c0c;}

.give .before button {width:75%; margin:0 auto;}
.give .before button + p {margin:5% 0;}
.give .before p strong {font-size:13px; line-height:1.063em;}
.give .before p img {vertical-align:middle;}
.give .before .word1 img {width:23px;}
.give .before .word2 img {width:160px;}
.give .after p {margin-bottom:5%;}
.give .after a {display:block; width:73.4%; margin:0 auto;}

.noti {padding:30px 10px;}
.noti h2 {color:#444; font-size:13px; line-height:1.25em;}
.noti h2 span {position:relative; padding:0 10px;}
.noti h2 span:after, .noti h2 span:before {content:' '; position:absolute; top:50%; width:2px; height:12px; margin-top:-6px; background-color:#33e4b9;}
.noti h2 span:after {left:0;}
.noti h2 span:before {right:0;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#555; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #ffc101; border-radius:50%; background-color:transparent;}
@media all and (min-width:480px){
	.step .btnwrap strong span {height:30px; margin-top:-15px; font-size:19px;}

	.give .before p strong {font-size:18px;}
	.give .before .word1 img {width:34px;}
	.give .before .word2 img {width:240px;}

	.noti {padding:45px 15px;}
	.noti h2 {font-size:20px;}
	.noti h2 span {padding:0 15px;}
	.noti h2 span:after, .noti h2 span:before {width:3px; height:18px; margin-top:-9px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; padding-left:15px; font-size:16px;}
	.noti ul li:after {top:6px; width:3px; height:3px; border:3px solid #ffc101;}
}
</style>
<script type="text/javascript">

function gowish(){
	<% If IsUserLoginOK Then %>
		<% if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if staffconfirm and  request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				var rstStr = $.ajax({
					type: "POST",
					url: "/event/etc/doEventSubscript60830.asp",
					data: "mode=wish",
					dataType: "text",
					async: false
				}).responseText;
				if (rstStr.substring(0,2) == "01"){
					$("#wishclear").show();
					$("#wishbefore").hide();
					$("#wishaftercount").html( rstStr.substring(5,15) );
					$("#wishafterval").show().css({display:"block"});
					return false;
				}else if (rstStr.substring(0,2) == "02"){
					$("#wishclear").hide();
					$("#wishbefore").hide();
					$("#wishaftercount").html( rstStr.substring(5,15) );
					$("#wishafterval").show().css({display:"block"});
					return false;
				}else if (rstStr == "98"){
					alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
					return false;
				}else if (rstStr == "99"){
					alert('로그인을 해주세요.');
					return false;
//				}else if (rstStr == "14"){
//					alert('이미 오늘 1,000명이 마일리지를 받으셨습니다.');
//					return false;
				}else if (rstStr == "12"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
//				}else if (rstStr == "11"){
//					alert('이미 마일리지를 받으셨습니다.');
//					return false;
				}else{
					alert('정상적인 경로가 아닙니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & getevt_codedisp)%>');
			return false;
		<% end if %>
	<% end if %>
}

function gotalk(){
	<% If IsUserLoginOK Then %>
		<% if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if staffconfirm and  request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				if ( $("#wishclear").css("display")=='none' ){
					alert('위시리스트를 먼저 담아 주세요.');
					return false;
				}
				
				var rstStr = $.ajax({
					type: "POST",
					url: "/event/etc/doEventSubscript60830.asp",
					data: "mode=talk",
					dataType: "text",
					async: false
				}).responseText;
				if (rstStr.substring(0,2) == "01"){
					$("#talkclear").show();
					$("#talkbefore").hide();
					$("#talkaftercount").html( rstStr.substring(5,15) );
					$("#talkafterval").show().css({display:"block"});
					return false;
				}else if (rstStr.substring(0,2) == "02"){
					$("#talkclear").hide();
					$("#talkbefore").hide();
					$("#talkaftercount").html( rstStr.substring(5,15) );
					$("#talkafterval").show().css({display:"block"});
					return false;
				}else if (rstStr == "98"){
					alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
					return false;
				}else if (rstStr == "99"){
					alert('로그인을 해주세요.');
					return false;
//				}else if (rstStr == "14"){
//					alert('이미 오늘 1,000명이 마일리지를 받으셨습니다.');
//					return false;
				}else if (rstStr == "13"){
					alert('위시리스트를 먼저 담아 주세요.');
					return false;
				}else if (rstStr == "12"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
//				}else if (rstStr == "11"){
//					alert('이미 마일리지를 받으셨습니다.');
//					return false;
				}else{
					alert('정상적인 경로가 아닙니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & getevt_codedisp)%>');
			return false;
		<% end if %>
	<% end if %>
}

function gobaguni(){
	<% If IsUserLoginOK Then %>
		<% if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if staffconfirm and  request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW %>
				alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
				return;
			<% else %>
				if ( $("#wishclear").css("display")=='none' ){
					alert('위시리스트를 먼저 담아 주세요.');
					return false;
				}
				if ( $("#talkclear").css("display")=='none' ){
					alert('GIFT TALK에 먼저 투표해 주세요.');
					return false;
				}
				
				var rstStr = $.ajax({
					type: "POST",
					url: "/event/etc/doEventSubscript60830.asp",
					data: "mode=baguni",
					dataType: "text",
					async: false
				}).responseText;
				if (rstStr.substring(0,2) == "01"){
					$("#baguniclear").show();
					$("#bagunibefore").hide();
					$("#baguniaftercount").html( rstStr.substring(5,15) );
					$("#baguniafterval").show().css({display:"block"});
					return false;
				}else if (rstStr.substring(0,2) == "02"){
					$("#baguniclear").hide();
					$("#bagunibefore").hide();
					$("#baguniaftercount").html( rstStr.substring(5,15) );
					$("#baguniafterval").show().css({display:"block"});
					return false;
				}else if (rstStr == "98"){
					alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
					return false;
				}else if (rstStr == "99"){
					alert('로그인을 해주세요.');
					return false;
				}else if (rstStr == "15"){
					alert('GIFT TALK에 먼저 투표해 주세요.');
					return false;
//				}else if (rstStr == "14"){
//					alert('이미 오늘 1,000명이 마일리지를 받으셨습니다.');
//					return false;
				}else if (rstStr == "13"){
					alert('위시리스트를 먼저 담아 주세요.');
					return false;
				}else if (rstStr == "12"){
					alert('이벤트 응모 기간이 아닙니다.');
					return false;
//				}else if (rstStr == "11"){
//					alert('이미 마일리지를 받으셨습니다.');
//					return false;
				}else{
					alert('정상적인 경로가 아닙니다.');
					return false;
				}
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & getevt_codedisp)%>');
			return false;
		<% end if %>
	<% end if %>
}

function gomileage(){
	<% If IsUserLoginOK Then %>
		<% if not( getnowdate>="2015-04-13" and getnowdate<"2015-04-25" ) then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<%
			'if clng(subscriptcountclear) > 0 or clng(mileagescount) > 0 then
			if clng(subscriptcountclear) > 0 then
			%>
				alert('이미 마일리지를 받으셨습니다.');
				return false;
			<% else %>
				<%
				'if clng(totalsubscriptcountclear) > clng(getmileagelimit) or clng(totalmileagescount) > clng(getmileagelimit) then
				if clng(totalsubscriptcountclear) > clng(getmileagelimit) then
				%>
					alert('이미 오늘 1,000명이 마일리지를 받으셨습니다.');
					return false;
				<% else %>
					<% if staffconfirm and  request.cookies("tinfo")("userlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("tinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						if ( $("#wishclear").css("display")=='none' ){
							alert('위시리스트를 먼저 담아 주세요.');
							return false;
						}
						if ( $("#talkclear").css("display")=='none' ){
							alert('GIFT TALK에 먼저 투표해 주세요.');
							return false;
						}
						if ( $("#baguniclear").css("display")=='none' ){
							alert('장바구니에 먼저 상품을 담아 주세요.');
							return false;
						}
		
						var rstStr = $.ajax({
							type: "POST",
							url: "/event/etc/doEventSubscript60830.asp",
							data: "mode=mileage",
							dataType: "text",
							async: false
						}).responseText;
						if (rstStr == "01"){
							alert('3,000 마일리지가 지급 되었습니다.\n삼시세번 이벤트에 참여해주셔서 감사합니다.');
							parent.location.replace('<%= appUrlPath %>/event/eventmain.asp?eventid=<%= getevt_codedisp %>')
							return false;
						}else if (rstStr == "98"){
							alert('텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)');
							return false;
						}else if (rstStr == "99"){
							alert('로그인을 해주세요.');
							return false;
						}else if (rstStr == "15"){
							alert('GIFT TALK에 먼저 투표해 주세요.');
							return false;
						}else if (rstStr == "16"){
							alert('장바구니에 먼저 상품을 담아 주세요.');
							return false;
						}else if (rstStr == "14"){
							alert('이미 오늘 1,000명이 마일리지를 받으셨습니다.');
							return false;
						}else if (rstStr == "13"){
							alert('위시리스트를 먼저 담아 주세요.');
							return false;
						}else if (rstStr == "12"){
							alert('이벤트 응모 기간이 아닙니다.');
							return false;
						}else if (rstStr == "11"){
							alert('이미 마일리지를 받으셨습니다.');
							return false;
						}else if (rstStr == "17"){
							alert('마일리지 발급은 오전 10시부터 가능합니다.');
							return false;
						}else{
							alert('정상적인 경로가 아닙니다.');
							return false;
						}
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & getevt_codedisp)%>');
			return false;
		<% end if %>
	<% end if %>
}

</script>
</head>
<body>

<!-- iframe : 삼시세번 -->
<div class="aprilHoney">
	<div class="honeyMileage">
		<div class="topic">
			<h1>삼시세번</h1>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_mileage.png" alt="당신과 텐바이텐의 연결고리 3단계 미션을 모두 달성하고 3,000마일리지 받자! 매일 오전 10시부터 1,000명에게 선착순으로 선물합니다. 이벤트 기간은 4월 13일부터 4월 24일까지 12일동안 진행됩니다." /></p>
		</div>

		<div class="eventarea">
			<div class="step step1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_step_01.png" alt="1단계 의욕충만 : 위시리스트 담기 위시리스트의 공개 폴더 속에 상품을 10개 이상 담아 주세요. (4/13 이후로 담은 기준)" /></p>
				<% '<!-- for dev msg : 미션완료후 보여주세요 --> %>
				<strong class="clear" id="wishclear"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_mission_clear.png" alt="미션완료" /></strong>
				<div class="btnwrap">
					<% '<!-- for dev msg : 확인 전 --> %>
					<button type="button" id="wishbefore" onclick="gowish();" class="btncheck"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_check.png" alt="확인하기" /></button>
					<% '<!-- for dev msg : 확인 후 style="display:block;" --> %>
					<strong id="wishafterval" style="display:none;">
						<span id="wishaftercount">0</span>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_count.png" alt="" />
					</strong>
				</div>
			</div>

			<div class="step step2">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_step_02.png" alt="2단계 물어보기 : Gift Talk 하기 Gift Talk에서 질문에 3가지 이상 투표를 남겨주세요." /></p>
				<strong class="clear" id="talkclear"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_mission_clear.png" alt="미션완료" /></strong>
				<div class="btnwrap">
					<% '<!-- for dev msg : 확인 전 --> %>
					<button type="button" id="talkbefore" onclick="gotalk();" class="btncheck"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_check.png" alt="확인하기" /></button>
					<% '<!-- for dev msg : 확인 후 --> %>
					<strong id="talkafterval" style="display:none;">
						<span id="talkaftercount">0</span>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_count.png" alt="" />
					</strong>
				</div>
			</div>

			<div class="step step3">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_step_03.png" alt="3단계 결제준비 : 장바구니 담기 장바구니 속에 사고 싶은 상품을 5개 이상 담아 주세요. " /></p>
				<strong class="clear" id="baguniclear"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_mission_clear.png" alt="미션완료" /></strong>
				<div class="btnwrap">
					<% '<!-- for dev msg : 확인 전 --> %>
					<button type="button" id="bagunibefore" onclick="gobaguni();" class="btncheck"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_check.png" alt="확인하기" /></button>
					<% '<!-- for dev msg : 확인 후 --> %>
					<strong id="baguniafterval" style="display:none;">
						<span id="baguniaftercount">555</span>
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_count.png" alt="" />
					</strong>
				</div>
			</div>
		</div>

		<div class="give">
			<%
			'if clng(subscriptcountclear) > 0 or clng(mileagescount) > 0 then
			if clng(subscriptcountclear) > 0 then
			%>
				<% '<!-- for dev msg : 마일리지받기 후 --> %>
				<div class="after">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_thanks.png" alt="삼시세번 이벤트에 참여해주셔서 감사합니다. 적립된 마일리지를 활용해 더욱 즐거운 쇼핑을 즐겨보세요 !" /></p>

					<% if isApp=1 then %>
						<a href="" onclick="parent.fnAPPpopupBrowserURL('ENJOY EVENT','<%= wwwUrl %>/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp'); return false;">
					<% else %>
						<a href="/shoppingtoday/shoppingchance_allevent.asp" target="_blank">
					<% end if %>

					<img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_go.png" alt="상품 기획전 보러가기" /></a>
				</div>
			<% else %>
				<% '<!-- for dev msg : 마일리지받기 전 --> %>
				<div class="before">
					<button type="button" onclick="gomileage();" class="btngive"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/btn_give_mileage.png" alt="3천 마일리지 주세요" /></button>
					<p>
						<span class="word1"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_today.png" alt="오늘" /></span>
						<% If Now() > #04/13/2015 10:00:00# Then %>
							<strong><%= CurrFormat(totalsubscriptcountclear) %></strong>
						<% Else %>
							<strong>0</strong>
						<% End If %>
						<span class="word2"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_get_mileage.png" alt="명이 마일리지를 받으셨습니다." /></span>
					</p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/txt_limited.png" alt="이벤트 기간 중 한 ID 당 1회만 가능합니다. 매일 1,000명 선착순으로 종료 됩니다." /></p>
				</div>
			<% end if %>
		</div>

		<div class="noti">
			<h2><span>이벤트 유의사항</span></h2>
			<ul>
				<li>텐바이텐 고객님을 위한 이벤트 입니다. (비회원 참여 불가) </li>
				<li>마일리지 지급은 매일 오전 10시 부터 선착순으로 1,000명에게 지급됩니다.</li>
				<li>한 ID 당 1회만 마일리지를 지급받을 수 있습니다.</li>
				<li>위시리스트는 4월 13일 이후 공개된 폴더에 담긴 상품을 기준으로 적용됩니다.</li>
				<li>미션은 1단계부터 차례대로 수행해주세요.</li>
				<li>장바구니 속에 담긴 상품은 14일 동안만 보관됩니다.</li>
			</ul>
		</div>

		<div class="bnr">
			<% if isApp=1 then %>
				<a href="" onclick="parent.fnAPPpopupBrowserURL('이벤트','<%= wwwUrl %>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=61490'); return false;">
			<% else %>
				<a href="<%= appUrlPath %>/event/eventmain.asp?eventid=61490" target="_blank">
			<% end if %>

			<img src="http://webimage.10x10.co.kr/eventIMG/2015/60830/m/img_event_bnr.png" alt="사월의 꿀맛 덤&amp;무민 사은이벤트 가기" /></a>
		</div>
	</div>

</div>
<!-- //iframe -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->