<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : [13주년] 즐겨라, 텐바이텐_쌓여라! 스페셜혜택 
' 강준구 이종화 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/head.asp" -->

<%

	Dim eCode, evttotalCnt, vQuery
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21234
	Else
		eCode   =  55502
	End If

	'// 모바일접근 앱점근 구분 
	Dim nowurl : nowurl = LCase(Request.ServerVariables("HTTP_REFERER"))


	vQuery = " SELECT count(userid) From  db_event.dbo.tbl_event_subscript Where evt_code='"&eCode&"' "
	rsget.Open vQuery, dbget, 1
	If Not rsget.Eof Then
		evttotalCnt = rsget(0)
	Else
		evttotalCnt = 0
	End If
	rsget.close()



%>


<style type="text/css">
.mEvt55502 {}
.mEvt55502 img {vertical-align:top; width:100%;}

.bnrAnniversary13th {position:relative;}
.bnrAnniversary13th .mobil {position:absolute; top:15%; left:0; width:100%;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both;}

/* Bounce animation */
@-webkit-keyframes bounce {
	40% {-webkit-transform: translateY(10px);}
}
@keyframes bounce {
	40% {transform: translateY(10px);}
}
.bounce {-webkit-animation-name:bounce; animation-name:bounce; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}

.benefitInfo li {padding-top:15px;}
.benefitInfo li:first-child {padding-top:0;}

.appBenefit {position:relative;}
.appBenefit div {position:relative;}
.appBenefit div strong {position:absolute; left:0; top:20px; width:100%; display:block; text-align:center; font-size:12px;}
.appBenefit div strong span {text-decoration:underline; font-family:helveticaNeue, helvetica, sans-serif !important;font-size:13px;}
.appBenefit div p {position:absolute; left:0; bottom:12px; width:100%; text-align:center; font-size:11px; color:#d50c0c; line-height:1.4;}
.appBenefit .finish {position:absolute; left:0; right:0; bottom:0; height:100%; width:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55081/img_benefit00_ending.png) center bottom no-repeat; background-size:cover;}
.mileageView {position:relative;}
.mileageView p {position:absolute; left:30.5%; top:50%; width:90px; height:20px; font-weight:bold; font-size:12px; line-height:18px; text-align:center;}
.notiCt {background-color:#f0dfb8; padding:15px 10px 22px 10px; position:relative; margin-bottom:30px;}
.notiCt li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 10px; text-align:left; color:#d50c0c;}
.notiCt li:before {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:4px; border-radius:50%; background:#b2ad8f;}
.notiCt .mileageshopBtn {position:absolute; right:15px; bottom:5px; width:106px;}
.evtNoti {margin-top:20px; padding:16px 12px 10px; border-top:1px dotted #9e9e9e; background:#fffce9;}
.evtNoti dt {padding-bottom:15px; text-align:center;}
.evtNoti dt span {display:inline-block; padding:5px 15px; font-size:15px; line-height:1; font-weight:bold; color:#fff; border-radius:15px; background:#b98a74;}
.evtNoti li {position:relative; color:#333; font-size:11px; line-height:1.5; padding:0 0 6px 10px; text-align:left;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:4px; height:4px; border-radius:50%; background:#b2ad8f;}

@media all and (min-width:480px){
	.friendsHope {padding:0 4px 68px;}
	.benefitInfo li {padding-top:22px;}
	.appBenefit div strong {top:30px; font-size:18px;}
	.appBenefit div strong span {font-size:20px;}
	.appBenefit div p {bottom:18px; font-size:15px;}
	.mileageView p {left:32%; top:50.5%; width:135px; height:30px; font-size:18px; line-height:30px;}
	.notiCt {padding:20px 15px 33px 15px; margin-bottom:45px;}
	.notiCt li {font-size:15px; padding:0 0 4px 15px;}
	.notiCt li:before {top:10px; width:5px; height:5px;}
	.notiCt .mileageshopBtn {right:22px; bottom:7px; width:159px;}
	.evtNoti {margin-top:30px; padding:24px 18px 15px; border-top:2px dotted #9e9e9e;}
	.evtNoti dt {padding-bottom:23px;}
	.evtNoti dt span {padding:7px 23px; font-size:23px; border-radius:23px;}
	.evtNoti li {font-size:17px; padding:0 0 9px 15px;}
	.evtNoti li:after {top:8px; width:5px; height:5px;}
}

@media all and (min-width:960px){
	.mileageView p {left:40%; top:52%; width:180px; height:40px; font-size:24px; line-height:40px;}
}

</style>
<script>
function chkmypoint(){
	<% if Not(IsUserLoginOK) then %>
		<% if isApp > 0  then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
			return false;
		<% end if %>
	<% else %>
		$.ajax({
			url: "/apps/appCom/wish/web2014/event/etc/mypoint_proc.asp",
			cache: false,
			success: function(message) {
				//팝업 호출
				$("#tempdiv").empty().append(message);
				$("#mypoint").empty()
				$("#mypoint").text($("div#totmypoint").attr("value"));
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
	<% end if %>
}
function goMigSubmit() {
	<% if Not(IsUserLoginOK) then %>
		<% if isApp > 0  then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
			return false;
		<% end if %>
	<% else %>
		parent.location.href='doEventSubscript55502.asp';
	<% end if %>
}


function jsDownCoupon(stype,idx){
	<% if Not(IsUserLoginOK) then %>
		<% if isApp > 0  then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsevtlogin();
			return false;
		<% end if %>
	<% end if %>
	
	if(confirm('쿠폰을 받으시겠습니까?')) {
		var frm;
		frm = document.frmC;
		frm.stype.value = stype;
		frm.idx.value = idx;
		frm.submit();
	}
}
</script>
</head>
<body>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">
	<!-- 종료된 이벤트일 경우 <div class="finishEvt"><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>-->
	<div class="mEvt55502">
		<div class="anniversary13th">

			<div class="specialBenefit">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/tit_special_benefit.png" alt="쌓여라! 스페셜 혜택! - 텐바이텐 13주년 쿠폰을 받고 쇼핑을 시작하세요!" /></h3>
				<p><a href="" onClick="javascript:jsDownCoupon('prd,prd,prd,prd,prd,prd','9697,9696,9695,9694,9693,9692'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/tit_coupon_down.png" alt="13주년 스페셜 쿠폰 전체 다운로드 받기" /></a></p>
			</div>
			<div class="benefitInfo">
				<ul>
					<li class="appBenefit">
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/subtit_benefit00.png" alt="APP 로그인시" /></h4>
						<div>
							<strong>지금까지 <span class="cRd1">&nbsp;<%=FormatNumber(evttotalCnt, 0)%>&nbsp;</span> 명이 마일리지를 받으셨습니다!</strong>
							<p>이벤트 기간 중 한 ID당 1회만 가능합니다.<br />선착순 마감시 사전 종료 될 수 있습니다.</p>
							<a href="" onclick="goMigSubmit();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_benefit00_app.png" alt="선착순 20,000명 500 마일리지 지급 - 마일리지 받기" /></a>
						</div>
						<% If evttotalCnt > 20000 Then %>
							<p class="finish"></p><%' for dev msg : 종료되면 노출시켜 주세요 %>
						<% End If %>
					</li>
					<li>
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/subtit_benefit01.png" alt="5만원 이상 구매시" /></h4>
						<% If isApp="1" Then %>
							<p><a href="" onclick="parent.fnAPPpopupProduct('1135428');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/5_cup_off_m.gif" alt="13주년 머그컵1" /></a></p>
						<% Else %>
							<p><a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1135428" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/5_cup_off_m.gif" alt="13주년 머그컵 1개(색상 랜덤)" /></a></p>
						<% End If %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_benefit01.png" alt="or 2,000 Mileage 지급" /></p>
					</li>
					<li>
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/subtit_benefit02.png" alt="5만원 이상 구매시" /></h4>
						<% If isApp="1" Then %>
							<p><a href="" onclick="parent.fnAPPpopupProduct('1135428');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/10_cup_off_m.gif" alt="13주년 머그컵 2개(색상 랜덤)" /></a></p>
						<% Else %>
							<p><a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1135428" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/10_cup_off_m.gif" alt="13주년 머그컵 2개(색상 랜덤)" /></a></p>
						<% End If %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_benefit02.png" alt="or 5,000 Mileage 지급" /></p>
					</li>
					<li>
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/subtit_benefit03.png" alt="5만원 이상 구매시" /></h4>
						<% If isApp="1" Then %>
							<p><a href="" onclick="parent.fnAPPpopupProduct('1135428');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/20_cup_off_m.gif" alt="13주년 머그컵 4개" /></a></p>
						<% Else %>
							<p><a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1135428" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/20_cup_off_m.gif" alt="13주년 머그컵 4개" /></a></p>
						<% End If %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_benefit03.png" alt="or 10,000 Mileage 지급" /></p>
					</li>
				</ul>
			</div>
			<div class="mileageCheck">
				<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/subtit_mileage_check.png" alt="예상 마일리지 확인하기" /></h4>
				<div class="mileageView">
					<p id="mypoint"><a href="javascript:chkmypoint();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/btn_check.png" alt="확인하기" /></a></p>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/txt_mileage_check.png" alt="10월 28일 지급 예정 마일리지는 입니다." />
				</div>
				<div class="notiCt">
					<ul>
						<li><span>고객단순변심에 의한 환불, 교환시 마일리지는 취소됩니다.</span></li>
						<li><span>시스템 프로세스 상 실시간 반영이 되지 않아 최종 마일리지 지급 액과 차이가 있을 수 있습니다.</span></li>
						<li><span>APP로그인시 즉시지급된 마일리지는 함께 카운트 되지 않습니다.</span></li>
					</ul>
					<% if isApp > 0  then %>
					<% Else %>
						<p class="mileageshopBtn"><a href="/my10x10/mileage_shop.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/btn_mileage.png" alt="마일리지샵 구경가기" /></a></p>
					<% End If %>
				</div>
				<% If isApp="1" Then %>
					<p><a href="" onclick="parent.fnAPPpopupProduct('1135428');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_mug1.png" alt="13주년 머그컵1" /></a></p>
					<p><a href="" onclick="parent.fnAPPpopupProduct('1135428');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_mug2.png" alt="13주년 머그컵2" /></a></p>
				<% Else %>
					<p><a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1135428" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_mug1.png" alt="13주년 머그컵1" /></a></p>
					<p><a href="<%=appUrlPath%>/category/category_itemprd.asp?itemid=1135428" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55081/img_mug2.png" alt="13주년 머그컵2" /></a></p>
				<% End If %>
			</div>
			<dl class="evtNoti">
				<dt><span>이벤트 안내</span></dt>
				<dd>
					<ul>
						<li>텐바이텐 사은 이벤트는 텐바이텐 회원님을 위한 혜택입니다. (비회원 구매 증정 불가)</li>
						<li>13주년 머그 사은품은 한정수량이므로, 수량이 소진되었을 경우에는 마일리지만 선택이 가능합니다.</li>
						<li>텐바이텐 배송상품을 구매하지 않을 경우, 마일리지받기만 선택 가능합니다.</li>
						<li>마일리지는 <strong class="cRd1">10월28일 일괄 지급</strong>됩니다. <strong>이벤트 페이지 내의 지급예정마일리지를 참고하세요.</strong></li>
						<li>상품쿠폰, 보너스쿠폰, 할인카드 등의 사용 후 <strong class="cRd1">구매확정금액이 5만원/10만원/20만원 이상</strong>이어야 합니다.</li>
						<li>마일리지, 예치금, 기프트카드를 사용하신 경우는 구매확정 금액에 포함되어 사은품을 받으 실 수있습니다.</li>
						<li>한 주문건의 구매금액 기준 이상일 때 증정, 다른 주문에 대한 누적적용이 되지 않습니다.</li>
						<li>주년머그컵 사은품의 경우 구매하신 <span class="cRd1">텐바이텐 배송 상품과 함께 배송</span>됩니다.</li>
						<li>텐바이텐 기프트카드를 구매하신 경우는 사은품과 사은쿠폰이 증정되지 않습니다.</li>
						<li>환불이나 교환 시 최종 구매 가격이 사은품 수령 가능금액 미만이 될 경우, 사은품과 함께 반품해야 하며, 마일리지 또한 취소됩니다.</li>
					</ul>
				</dd>
			</dl>
			<!-- main banner -->
			<div class="bnrAnniversary13th">
				<a href="<%=appUrlPath%>/event/eventmain.asp?eventid=55074" target="_top">
					<%' for dev msg : 메인으로 링크 걸어주세요 %>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_bnr_main.gif" alt="즐겨라 YOUR 텐바이텐 이벤트 메인으로 가기" />
					<span class="mobil animated bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55074/img_small_mobil.png" alt="" /></span>
				</a>
			</div>
			<div id="tempdiv"></div>
		</div>
	</div>
</div>
<form name="frmC" method="get" action="/apps/appcom/wish/web2014/shoppingtoday/couponshop_process.asp">
<input type="hidden" name="stype" value="">
<input type="hidden" name="idx" value="">
</form>
<!--// 이벤트 배너 등록 영역 -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->