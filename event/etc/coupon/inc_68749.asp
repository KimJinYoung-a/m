<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 발렌타임 - 쿠폰
' History : 2016-01-27 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql
Dim getbonuscoupon1 , getbonuscoupon2 , getlimitcnt1, getlimitcnt2 , currenttime
Dim totcnt1 , totcoupon
Dim extratime , HH , MM

	IF application("Svr_Info") = "Dev" THEN
		eCode = "66016"
	Else
		eCode = "68749"
	End If

	IF application("Svr_Info") = "Dev" THEN
		getbonuscoupon1 = "2763"
		getbonuscoupon2 = "2764"
	Else
		getbonuscoupon1 = "818" '오전
		getbonuscoupon2 = "819" '오후
	End If

	userid = getEncLoginUserID()
	getlimitcnt1 = 3000		'3000
	getlimitcnt2 = 6000		'3000
	currenttime = now()

If hour(now()) < 13 then
		totcoupon = getbonuscoupon1
	Else
		totcoupon = getbonuscoupon2
	End If 

dim bonuscouponcount1, subscriptcount1, totalsubscriptcount, totalbonuscouponcount1
dim bonuscouponcount2, totalbonuscouponcount2
Dim use_bonuscouponcount1 , use_bonuscouponcount2

Dim d_bonuscouponcount1 , d_bonuscouponcount2 , u_bonuscouponcount1 , u_bonuscouponcount2

bonuscouponcount1=0
subscriptcount1=0
totalsubscriptcount=0
totalbonuscouponcount1=0

bonuscouponcount2=0
totalbonuscouponcount2=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount1 = getevent_subscriptexistscount(eCode, userid, "", "", Date())
	bonuscouponcount1 = getbonuscouponexistscount(userid, getbonuscoupon1, "", "", "")
	use_bonuscouponcount1 = getbonuscouponexistscount(userid, getbonuscoupon1, "", "Y", Date())
	bonuscouponcount2 = getbonuscouponexistscount(userid, getbonuscoupon2, "", "", "")
	use_bonuscouponcount2 = getbonuscouponexistscount(userid, getbonuscoupon2, "", "Y", Date())


	d_bonuscouponcount1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")
	d_bonuscouponcount2 = getbonuscoupontotalcount(getbonuscoupon2, "", "", "")

	u_bonuscouponcount1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y", "")
	u_bonuscouponcount2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y", "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, Date(), totcoupon, "")
'//오늘 쿠폰 발행수량
totalbonuscouponcount1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", Date())
totalbonuscouponcount2 = getbonuscoupontotalcount(getbonuscoupon2, "", "", Date())
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt68749 {position:relative;}
.valenTime {overflow:hidden; position:relative;}
.valenTime .deco {position:absolute; left:0; top:0; width:100%; z-index:30;}
.timeCoupon {position:relative;}
.timeCoupon .limit {position:absolute; right:0; top:-10%; width:22%; z-index:20;}
.timeCoupon .soldOut {position:absolute; left:0; top:0; z-index:10; width:100%; height:100%; background-position:0 0; background-repeat:no-repeat; text-indent:-9999px; background-size:100% 100%;}
.timeCoupon .am9 .soldOut {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68749/m/txt_soon_01.png);}
.timeCoupon .pm9 .soldOut {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68749/m/txt_soon_02.png);}
.timeCoupon .soldOut.finish {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68749/m/txt_soon_03.png);}
.timeTab { padding:11% 7.8% 6%; background:#f4b7b6;}
.timeTab ul {overflow:hidden; }
.timeTab li {float:left; width:50%; padding:0 2.2%;}
.timeTab li p {background-position:0 0; background-repeat:no-repeat; background-size:100% 100%;}
.timeTab li.am9 p {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68749/m/tab_am9.png);}
.timeTab li.pm9 p {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68749/m/tab_pm9.png);}
.timeTab li span {opacity:0;}
.timeTab li.current span {opacity:1;}
.btnCoupon {width:100%; vertical-align:top; background:transparent;}
.evtNoti {overflow:hidden; text-align:left; padding:24px 6.25%; background:#8a6565;}
.evtNoti h3 strong {display:inline-block; font-size:15px; line-height:1.2; color:#fefefe; border-bottom:2px solid #fefefe;}
.evtNoti ul {padding-top:15px;}
.evtNoti ul li {position:relative; font-size:11px; line-height:1.1; padding:0 0 5px 13px; color:#faf3f4;}
.evtNoti ul li:after {content:''; display:inline-block; position:absolute; left:0; top:4px; width:5px; height:1px; background:#fff;}
#couponLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.7); z-index:50;}
#couponLayer .cpCont {position:absolute; left:0; top:8%; width:100%;}
#couponLayer .timeCont {position:absolute; left:0; top:0; width:100%;}
#couponLayer .timeCont strong {display:block; position:absolute; left:0; bottom:-80%; width:100%; font-size:12px; color:#ff5855; text-align:center;}
#couponLayer .timeCont strong em {text-decoration:underline;}
#couponLayer .btnConfirm {position:absolute; left:20%; bottom:12%; width:60%; background:transparent;}
#couponLayer .btnClose {position:absolute; right:12%; top:10%; width:7%; background:transparent;}
@media all and (min-width:480px){
	.evtNoti {padding:36px 6.25%;}
	.evtNoti h3 strong {font-size:23px;}
	.evtNoti ul {padding-top:23px;}
	.evtNoti ul li {font-size:17px; padding:0 0 7px 20px;0}
	.evtNoti ul li:after {top:6px; width:7px;}
}
</style>
<script type="text/javascript">
$(function(){
	$("#couponLayer .btnClose").click(function(){
		$("#couponLayer").fadeOut();
	});

	$("#couponLayer .btnConfirm").click(function(){
		$("#couponLayer").fadeOut();
	});
});

function jseventSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( Now() > #02/01/2016 00:00:00# and Now() < #02/03/2016 23:59:59# ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			<% if subscriptcount1>0 or use_bonuscouponcount1>0 or use_bonuscouponcount2>0 then %>
				alert("쿠폰은 한 개의 아이디당 한 번만 다운 받으실 수 있습니다.");
				return;
			<% else %>
				<% if totalbonuscouponcount1>=getlimitcnt1 and totalbonuscouponcount2>=getlimitcnt2 then %>
					alert("죄송합니다. 쿠폰이 모두 소진 되었습니다.");
					return;
				<% else %>
					var result;
						$.ajax({
							type:"POST",
							url:"/event/etc/doeventsubscript/doEventSubscript68749.asp",
							data: "mode=coupon",
							dataType: "text",
							async: false,
							success : function(Data){
								result = jQuery.parseJSON(Data);
								if (result.rtcode=="05")
								{
									alert('잠시 후 다시 시도해 주세요.');
									return;
								}
								else if (result.rtcode=="04")
								{
									alert('한 개의 아이디당 한 번만 발급 가능 합니다.');
									return;
								}
								else if (result.rtcode=="03")
								{
									alert('이벤트 응모 기간이 아닙니다.');
									return;
								}
								else if (result.rtcode=="02")
								{
									alert('로그인을 해주세요.');
									return;
								}
								else if (result.rtcode=="01")
								{
									alert('잘못된 접속입니다.');
									return;
								}
								else if (result.rtcode=="00")
								{
									alert('정상적인 경로가 아닙니다.');
									return;
								}
								else if (result.rtcode=="06")
								{
									alert('이벤트 응모 시간이 아닙니다.');
									return;
								}
								else if (result.rtcode=="07")
								{
									alert('죄송합니다. 쿠폰이 모두 소진 되었습니다.');
									return;
								}
								else if (result.rtcode=="11")
								{
									$("#couponLayer").fadeIn();
									window.parent.$('html,body').animate({scrollTop:100}, 600);
								}
								else
								{
									alert('오류가 발생했습니다.');
									return false;
								}
							}
						});
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
<% If userid = "cogusdk" Or userid = "greenteenz" Or userid = "motions" Or userid = "helele223" Then %>
<div>
	<p>&lt;<%=getbonuscoupon1%>&gt; 쿠폰 발급건수 : <%=d_bonuscouponcount1%> 사용건수 : <%=u_bonuscouponcount1%></p>
	<p>&lt;<%=getbonuscoupon2%>&gt; 쿠폰 발급건수 : <%=d_bonuscouponcount2%> 사용건수 : <%=u_bonuscouponcount2%></p>
</div>
<% End If %>
<div class="mEvt68749">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/tit_valen_time.png" alt="발렌타임쿠폰" /></h2>
	<div class="valenTime">
		<div class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/bg_deco.png" alt="" /></div>
		<div class="getCoupon">
			<div class="timeTab">
				<ul>
					<li onclick="" class="am9 <%=chkiif(hour(now())<12," current","")%>"><p><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/tab_am9_on.png" alt="오전9시" /></span></p></li>
					<li onclick="" class="pm9 <%=chkiif(hour(now())>11," current","")%>"><p><span><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/tab_pm9_on.png" alt="오후9시" /></p></span></li>
				</ul>
			</div>
			<div class="timeCoupon">
				<p class="limit"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/txt_limit.png" alt="선착순 3,000명" /></p>
				<% If hour(now()) >= 9 and hour(now()) < 21  Then %>
				<div class="am9">
					<% if (hour(now()) >= 12 and hour(now()) < 21) Or (totalbonuscouponcount1>=getlimitcnt1) Or (Now() > #02/03/2016 23:59:59#) then %>
					<div class="soldOut <%=chkiif(Now() > #02/03/2016 23:59:59# ," finish","")%>"></div>
					<% End If %>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/img_coupon_01.png" alt="어디 가나?" /></div>
				</div>
				<% End if %>
				<% If hour(now()) >= 21 or hour(now()) < 9 Then %>
				<div class="pm9">
					<% if hour(now()) < 9 Or totalbonuscouponcount2>=getlimitcnt2 then %>
					<div class="soldOut <%=chkiif(Now() > #02/03/2016 23:59:59# ," finish","")%>"></div>
					<% End If %>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/img_coupon_02.png" alt="지금 몇쉬?" /></div>
				</div>
				<% End If %>
			</div>
		</div>
		<button class="btnCoupon" onclick="jseventSubmit();"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/btn_coupon.png" alt="쿠폰받기" /></button>
	</div>
	<div class="couponLayer" id="couponLayer">
		<div class="cpCont">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/txt_bonus_coupon.png" alt="보너스쿠폰이 발급되었습니다!" /></p>
			<% If hour(now()) < 12 Then %>
			<%
				extratime = datediff("s",now(),Date()&" 오후 12:00:00")
				HH	=	fix(extratime / 3600) Mod 24
				MM	=	fix(extratime / 60) Mod 60
			%>
			<div class="timeCont am9">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/tit_coupon_01.png" alt="어디 가나" /></p>
				<strong>쿠폰 마감까지 <em><%=chkiif(HH=0,"",HH&"시간")%><%=chkiif(MM=0,"",MM&"분")%></em> 남았습니다.</strong>
			</div>
			<% Else %>
			<%
				extratime = datediff("s",now(),Date()+1&" 오전 00:00:00")
				HH	=	fix(extratime / 3600) Mod 24
				MM	=	fix(extratime / 60) Mod 60
			%>
			<div class="timeCont pm9">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/tit_coupon_02.png" alt="지금 몇쉬!" /></p>
				<strong>쿠폰 마감까지 <em><%=chkiif(HH=0,"",HH&"시간")%><%=chkiif(MM=0,"",MM&"분")%></em> 남았습니다.</strong>
			</div>
			<% End If %>
			<button class="btnConfirm"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/btn_confirm.png" alt="확인" /></button>
			<button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/btn_close.png" alt="닫기" /></button>
		</div>
	</div>

	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트는 ID당 1일 1회만 쿠폰을 발급받을 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
			<li>발급받은 쿠폰에 따라 정오 / 자정에 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
		</ul>
	</div>
	<div><a href="eventmain.asp?eventid=69024"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68749/m/bnr_delivery.jpg" alt="벌써 설 배송 끝났나요?" /></a></div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->