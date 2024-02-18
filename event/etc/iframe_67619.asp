<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 응답하라 보너스 쿠폰
' History : 2015-11-23 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql
Dim getbonuscoupon , getlimitcnt , currenttime
Dim totcnt1

	IF application("Svr_Info") = "Dev" THEN
		eCode = "65960"
	Else
		eCode = "67619"
	End If

	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon = "2751"
	Else
		getbonuscoupon = "796"
	End If

	userid = getEncLoginUserID()
	getlimitcnt = 30000		'50000
	currenttime = now()

dim bonuscouponcount, subscriptcount, totalsubscriptcount, totalbonuscouponcount
bonuscouponcount=0
subscriptcount=0
totalsubscriptcount=0
totalbonuscouponcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
	bonuscouponcount = getbonuscouponexistscount(userid, getbonuscoupon, "", "", "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, "", "", "")
'//전체 쿠폰 발행수량
totalbonuscouponcount = getbonuscoupontotalcount(getbonuscoupon, "", "", "")


%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt67619 {position:relative;}
.downWrap {background:url(http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_btn_bg.png) no-repeat 50% 0; background-size:100% auto;}
.deadline {display:block; position:absolute; left:5%; top:22.5%; width:17.5%;}
.cpFinish {display:block; position:absolute; left:50%; top:25%; width:90.625%; height:19%; margin-left:-45.3125%; background-color:rgba(0,0,0,.8); border-radius:22px 22px; text-align:center; padding-top:23%; font-size:15px; font-weight:bold; color:#fff; line-height:1.5;}
.lyrCp {display:none; position:absolute; top:18%; left:50%; z-index:50; width:100%; margin-left:-50%;}
.lyrCp div {position:relative;}
.lyrCp span {overflow:hidden; display:block; position:absolute; top:75.5%; left:50%; z-index:50; width:66%; height:12%; margin-left:-33%; text-indent:-999em;}
#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.6);}
.noti {padding:7% 7% 55% 7%; background:#eaefe5 url(http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_notice_bg.png) no-repeat 50% 100%; background-size:100% auto;}
.noti strong {display:block; margin-bottom:4%; color:#345931; font-size:14px; font-weight:bold;}
.noti strong span {border-bottom:2px solid #345931;}
.noti ul li {position:relative; margin-top:3px; padding-left:12px; color:#7a7c7b; font-size:12px; line-height:1.6; letter-spacing:-0.05em;}
.noti ul li:after {content:' '; position:absolute; left:0; top:8px; width:5px; height:1px; background-color:#6e6e6e;}
@media all and (min-width:360px){
	.cpFinish {top:25.5%; font-size:16px;}
	.noti strong {font-size:15px;}
	.noti ul li {padding-left:13px; font-size:13px;}
	.noti ul li:after {top:8px; width:6px; height:2px;}
}
@media all and (min-width:480px){
	.cpFinish {top:25.7%; font-size:22px; border-radius:33px 33px;}
	.noti strong {font-size:21px;}
	.noti strong span {border-bottom:3px solid #345931;}
	.noti ul li {margin-top:4px; padding-left:18px; font-size:18px;}
	.noti ul li:after {top:12px; width:9px; height:3px;}
}
</style>
<script type="text/javascript">
$(function(){
	$("#lyrCp span").click(function(){
		$("#lyrCp").hide();
		$("#mask").fadeOut();
	});

	$("#mask").click(function(){
		$("#lyrCp").hide();
		$("#mask").fadeOut();
	});
});

function layershow(){
	$("#lyrCp").show();
	$("#mask").show();
	var val = $('#lyrCp').offset();
	$('html,body').animate({scrollTop:val.top},200);
}

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) = "2015-11-25") Then %>
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
					frm.action="/event/etc/doeventsubscript/doEventSubscript67619.asp";
					frm.target="evtFrmProc";
					frm.mode.value='coupon';
					frm.submit();
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
<div class="mEvt67619">
	<article>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_tit.png" alt="오랜만에 돌아왔다 - 응답하라 보너스쿠폰" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_radio.gif" alt="" /></p>
		<% if totalsubscriptcount>=getlimitcnt or totalbonuscouponcount>=getlimitcnt then %>
		<div class="cpFinish">
			<p style="color:#fef677;">쿠폰이 모두 소진되었습니다.</p>
			<p>다음 기회를 기다려주세요 : )</p>
		</div>
		<% else %>
			<% if ((getlimitcnt - totalsubscriptcount) < 5000) or ((getlimitcnt - totalbonuscouponcount) < 5000) then %>
				<span class="deadline"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_finish_flag.png" alt="마감임박" /></span>
			<% end if %>
		<% end if %>
		<p class="cpCheck"><a href="#lyrCp" onclick="jseventSubmit(evtFrm1);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_cupon_check.png" alt="쿠폰 확인하기" /></a></p>
		<div class="downWrap">
			<% if not(isApp=1) then %>
			<p><a href="/event/appdown/"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_btn1.png" alt="텐바이텐 APP 다운" /></a></p>
			<% End If %>
			<% If userid = "" Then %>
				<% if isApp=1 then %>
				<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_btn2.png" alt="회원가입하고 구매하러 Go" /></a></p>
				<% Else %>
				<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_btn2.png" alt="회원가입하고 구매하러 Go" /></a></p>
				<% End If %>
			<% End If %>
		</div>
		<div class="noti">
			<strong><span>이벤트 유의사항</span></strong>
			<ul>
				<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
				<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
				<li>쿠폰은 금일 11/25(수) 23시59분 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
				<li>이벤트는 조기 마감 될 수 있습니다.</li>
			</ul>
		</div>

		<div id="lyrCp" class="lyrCp">
			<div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67619/m/bonus_cupon.png" alt="쿠폰이 발급 되었습니다 - 10,000원(6만원 이상 구매시 사용가능하며 11.25(수) 하루 사용 가능합니다.)" /></p>
				<span>확인</span>
			</div>
		</div>
		<div id="mask"></div>
	</article>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->