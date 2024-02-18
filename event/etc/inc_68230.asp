<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 루돌프 사슴 쿠폰
' History : 2015.12.21 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, getbonuscoupon, currenttime, getlimitcnt
	IF application("Svr_Info") = "Dev" THEN
		eCode = "65989"
	Else
		eCode = "68230"
	End If
	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2759"
	Else
		getbonuscoupon = "812"
	End If

	currenttime = now()
	'currenttime = #12/22/2015 10:05:00#

	userid = GetEncLoginUserID()
	getlimitcnt = 30000

dim bonuscouponcount, subscriptcount, totalsubscriptcount, totalbonuscouponcount
bonuscouponcount=0
subscriptcount=0
totalsubscriptcount=0
totalbonuscouponcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", left(currenttime,10))
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount = getbonuscoupontotalcount(getbonuscoupon, "", "", left(currenttime,10))

'totalsubscriptcount = 25005		'25005		'/30000
'totalbonuscouponcount = 25005		'25005		'/30000

if GetLoginUserID="greenteenz" or GetLoginUserID="cogusdk" or GetLoginUserID="tozzinet" then
	response.write "발행건: " & totalbonuscouponcount
	
	dim sqlstr
	sqlstr = "select count(*) as cnt"
	sqlstr = sqlstr & " from [db_user].dbo.tbl_user_coupon"
	sqlstr = sqlstr & " where masteridx in ("& getbonuscoupon &")"
	sqlstr = sqlstr & " and isnull(deleteyn,'')='N'"
	sqlstr = sqlstr & " and isnull(isusing,'')='Y'"
	sqlstr = sqlstr & " and isnull(convert(varchar(10),regdate,121),'')='"& left(currenttime,10) &"'"

	'response.write sqlstr & "<Br>"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		response.write " 사용건: " & rsget("cnt")
	END IF
	rsget.close
end if

%>

<% '<!-- #include virtual="/lib/inc/head.asp" --> %>

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}

.mEvt68230 {position:relative;}
.mEvt68230 .hidden {visibility:hidden; width:0; height:0;}
.mEvt68230 button {background:transparent;}

.snow {position:absolute; top:0; left:0; z-index:5; width:100%; height:50%; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2015/68230/m/img_snow_v2.png) repeat-y 0 0; background-size:100% auto;}
.snowing {
/* chrome, safari, opera */-webkit-animation-name:snowing; -webkit-animation-duration:30s; -webkit-animation-timing-function:linear; -webkit-animation-iteration-count:1;
/* standard syntax */animation-name:snowing; animation-duration:30s; animation-timing-function:linear; animation-iteration-count:1;}
/* chrome, safari, opera */
@-webkit-keyframes snowing {
	0% {background-position:0 0}
	100%{background-position:0 500px}
}
@keyframes snowing {
	0% {background-position:0 0}
	100%{background-position:0 500px}
}

.coupon {position:relative;}
.coupon .btnClick {position:absolute; top:21%; left:50%; z-index:10; width:44.84%; margin-left:-22.42%;}

.coupon .btnCoupon {display:none; position:absolute; top:44.6%; left:0; width:100%;}
.coupon .deadline {position:absolute; top:10%; left:7.6%; width:21.25%;}
.coupon .soldout {position:absolute; top:-0.1%; left:0; z-index:15; width:100%;}

.bnr {padding-bottom:8%; background-color:#1f7400;}
.bnr .btnJoin {margin-bottom:-8%;}

.noti {padding:2.5rem 2rem; background-color:#ebebeb;}
.noti h3 {color:#0a662c; font-size:1.4rem;}
.noti h3 strong {border-bottom:2px solid #0a662c;}
.noti ul {margin-top:2rem;}
.noti ul li {position:relative; margin-top:0.5rem; padding-left:1rem; color:#000; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:0.6rem; left:0; width:4px; height:4px; border-radius:50%; background-color:#000;}

/* css3 animation */
@-webkit-keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
@keyframes flash {
	0% {opacity:0;}
	100% {opacity:1;}
}
.flash {
	-webkit-animation-duration:1s;  -webkit-animation-name:flash; -webkit-animation-iteration-count:3;
	animation-duration:1s; animation-name:flash; animation-iteration-count:3;
}

@-webkit-keyframes pulse {
	0% {-webkit-transform: scale(1);}
	50% {-webkit-transform: scale(1.15);}
	100% {-webkit-transform: scale(1);}
} 
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.15);}
	100% {transform:scale(1);}
}
.pulse {
	-webkit-animation-name:pulse; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;
	animation-name:pulse; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:5;
}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-12-22" and left(currenttime,10)<"2015-12-23" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount>0 or bonuscouponcount>0 then %>
				alert("쿠폰은 한 개의 아이디당 한 번만 다운 받으실 수 있습니다.");
				return;
			<% else %>
				<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
					alert("죄송합니다. 쿠폰이 모두 소진 되었습니다.");
					return;
				<% else %>
					<% if Hour(currenttime) < 10 then %>
						alert("쿠폰은 오전 10시부터 다운 받으실수 있습니다.");
						return;
					<% else %>
						frm.action="/event/etc/doeventsubscript/doEventSubscript68230.asp";
						frm.target="evtFrmProc";
						frm.mode.value='couponreg';
						frm.submit();
					<% end if %>
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<!-- 루돌프 사슴쿠폰 -->
<div class="mEvt68230">
	<article>
		<h2 class="hidden">루돌프 사슴쿠폰</h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/txt_rudolph.png" alt="빨간 코를 눌러주세요! 따끈한 보너스 쿠폰이 당신을 찾아갑니다." /></p>
		<div class="snow snowing"></div>

		<div class="coupon">
			<button type="button" id="btnClick" class="btnClick pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/btn_click_v1.png" alt="클릭" /></button>
			<button type="button" onclick="jseventSubmit(evtFrm1); return false;" id="btnCoupon" class="btnCoupon">
				<img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/img_coupon_v1.png" alt="5천원 쿠폰 3만원 이상 구매시 사용가능하며 12월 22일 화요일 하루동안 사용하실 수 있습니다." />
			</button>

			<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
				<% '<!-- for dev msg : 쿠폰이 모두 소진 될 경우 보여주세요 --> %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/txt_soldout.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회에 이용해주세요" /></p>
			<% else %>
				<% if ((getlimitcnt - totalsubscriptcount) < 5000) or ((getlimitcnt - totalbonuscouponcount) < 5000) then %>
					<% '<!-- for dev msg : 마감 임박 --> %>
					<strong class="deadline flash">
						<img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/txt_deadline.png" alt="쿠폰이 모두 소진되었습니다. 다음 기회에 이용해주세요" />
					</strong>
				<% end if %>
			<% end if %>

			<img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/img_rudolph_v1.png" alt="" />
		</div>

		<div class="bnr">
			<% if not(isApp=1) then %>
				<% '<!-- for dev msg : 모바일웹일 경우에만 보여주세요 --> %>
				<p class="btnApp"><a href="/event/appdown/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/btn_down_tentenapp.png" alt="아직이신가요? 텐바이텝 앱 다운받기" /></a></p>
			<% end if %>

			<% If userid = "" Then %>
				<% if isApp=1 then %>
					<p class="btnJoin"><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/btn_join.png" alt="바이텐에 처음 오셨나요? 회원가입하고 구매하러 go" /></a></p>
				<% else %>
					<p class="btnJoin"><a href="/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/68230/m/btn_join.png" alt="바이텐에 처음 오셨나요? 회원가입하고 구매하러 go" /></a></p>
				<% end if %>
			<% end if %>
		</div>

		<section class="noti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다. </li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
				<li>쿠폰은 금일 12/22(화) 23시59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
		</section>
	</article>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="isapp" value="<%= isApp %>">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>

<script type="text/javascript">
$(function(){
	$("#btnClick").click(function(event){
		<% If IsUserLoginOK() Then %>
			<% If not( left(currenttime,10)>="2015-12-22" and left(currenttime,10)<"2015-12-23" ) Then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% if subscriptcount>0 or bonuscouponcount>0 then %>
					alert("쿠폰은 한 개의 아이디당 한 번만 다운 받으실 수 있습니다.");
					return;
				<% else %>
					<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
						alert("죄송합니다. 쿠폰이 모두 소진 되었습니다.");
						return;
					<% else %>
						<% if Hour(currenttime) < 10 then %>
							alert("쿠폰은 오전 10시부터 다운 받으실수 있습니다.");
							return;
						<% else %>
							$("#btnClick").removeClass("pulse");
							$("#btnCoupon").slideDown();
							var val = $("#btnClick").offset();
							$("html,body").animate({scrollTop:val.top},200);
						<% end if %>
					<% end if %>
				<% end if %>
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				parent.calllogin();
				return false;
			<% else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
		<% End IF %>
	});
});
</script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->