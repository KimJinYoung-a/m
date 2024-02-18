<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 크리스머니의 기적
' History : 2014.12.16 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->


<%


dim eCode, vUserID, userid, myuserLevel, vPageSize, vPage, vLinkECode, prevEventJoinChk, EventJoinChk, usrSelectItemid, preveCode, sqlStr, EventTotalChk
	vUserID = GetLoginUserID()
	myuserLevel = GetLoginUserLevel
	userid = vUserID
	
	IF application("Svr_Info") = "Dev" Then
		eCode = "21408"
	Else
		eCode = "57691"
	End If


	EventTotalChk = 0

	sqlStr = ""
	sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
	sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
	sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' "
	rsget.Open sqlStr, dbget, 1
		EventTotalChk = rsget(0) '// 현재 이벤트 토탈 참여갯수
	rsget.Close

	EventTotalChk = 5000-EventTotalChk


	If IsUserLoginOK Then
		sqlStr = ""
		sqlStr = sqlStr & " SELECT count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " FROM db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='"&eCode&"' " &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "' "
		rsget.Open sqlStr, dbget, 1
			EventJoinChk = rsget(0) '// 현재 이벤트 참여여부
		rsget.Close
	Else
		'// 회원가입이 안되어 있음 쿠키 굽는다.(추후 가입완료시 이벤트 페이지 이동을 위해)
		response.cookies("etc").domain="10x10.co.kr"
		response.cookies("etc")("evtcode") = 57691
	End If

%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.topic {position:relative; padding-bottom:10%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57691/bg_pattern.gif) repeat-y 0 0; background-size:100% auto;}
.soldout {position:absolute; top:33%; left:50%; width:96%; margin-left:-48%;}
.btn-ly {width:63.6%; margin:0 auto;}
/* layer */
.ly-coupon {display:none; position:absolute; top:15.5%; left:50%; z-index:50; width:96%;margin-left:-48%; background-color:#fff;}
.ly-inner {margin:4px; padding-bottom:12%; border:2px solid #d9d9d9;}
.btn-close {margin-top:5%; text-align:center;}
.btn-close .close {width:160px; height:38px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57691/btn_confirm.gif) no-repeat 50% 50%; background-size:160px 38px; text-indent:-999em;}
.define {margin-top:2%;}
.countdown-wrap {width:74%; margin:10% auto 0; padding:6% 0; border-radius:26px; background:rgba(218,193,150,.30); text-align:center;}
.countdown-wrap strong {display:block; width:51.4%; margin:0 auto;}
.countdown {margin-top:8%;}
.countdown em {display:inline-block; width:46px; margin-right:5px;}
.countdown em img {margin-top:-9px;}
.countdown span {display:inline-block; padding:2px 10px 0; background-color:#fff; box-shadow:0 0 2px 2px rgba(218,193,150,0.3); color:#434343; font-size:22px; font-weight:bold; line-height:1.375em; text-align:center;}

.item {padding-bottom:10%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57691/bg_pattern.gif) repeat-y 0 0; background-size:100% auto;}
.item ul {overflow:hidden; padding:2% 5% 0;}
.item ul li {float:left; width:50%; margin-top:6%;}
.item ul li a {display:block; padding:0 5%;}
.btn-more {width:71.7%; margin:12% auto 0;}

.noti {padding-bottom:6%; background-color:#fff;}
.noti ul {padding:0 4.2%;}
.noti ul li {margin-top:6px; padding-left:10px; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/57691/blt_arrow.gif); background-repeat:no-repeat; background-position:0 3px; background-size:6px 7px; color:#444; font-size:12px; line-height:1.25em;}

.mask {display:none; position:absolute; top:0; left:0; z-index:30; width:100%; height:100%; background:rgba(0,0,0,.30);}




@media all and (min-width:480px){
	.countdown em {width:60px;}
	.countdown em img {margin-top:-13px;}
	.countdown span {width:45px; height:43px; padding-top:9px;}
	.btn-close .close {width:240px; height:57px;}
	.noti ul li {padding-left:15px; background-size:9px 10px; font-size:17px;}
}
</style>

<script type="text/javascript">


	function jsSubmitComment(){
		var frm = document.frmcom;
		
		<% If vUserID = "" Then %>
			calllogin();
		<% End If %>

		<% If vUserID <> "" Then %>
			<% if EventJoinChk > 0 then %>
				alert("이미 마일리지를 발급 받으셨습니다.");
				return false;
			<% end if %>

			<% if EventTotalChk > 5000 then %>
				alert("크리스머니가 모두 소진되었습니다.");
				return false;
			<% end if %>


			$.ajax({
				url: "/apps/appCom/wish/web2014/event/etc/doEventSubscript57691.asp",
				cache: false,
				success: function(message) {

					if (message=="99")
					{
						alert('잘못된 접속 입니다.');
						return;
					}
					else if (message=="88")
					{
						alert('로그인을 해주세요');
						return;
					}
					else if (message=="77")
					{
						alert('이벤트 응모 기간이 아닙니다.');
						return;
					}
					else if (message=="66")
					{
						alert('크리스머니가 모두 소진되었습니다.');
						return;
					}
					else if (message=="55")
					{
						alert('이벤트 대상자가 아닙니다.');
						return;
					}
					else if (message=="44")
					{
						alert('이미 마일리지를 발급 받으셨습니다.');
						return;
					}
					else if (message=="00")
					{
						$("#ly-coupon").show();
						$(".mask").show();
					}
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});
		<% End If %>
	}


	$(function() {
		/* layer popup*/
//		$(".btn-ly a").click(function(){
//			$("#ly-coupon").show();
//			$(".mask").show();
//		});

		$("#ly-coupon .close").click(function(){
			$("#ly-coupon").hide();
			$(".mask").hide();
		});

		$(".mask").click(function(){
			$("#ly-coupon").hide();
			$(".mask").hide();
		});

		
		$(".app").hide();
		$(".mo").hide();
		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
				$(".app").show();
		}else{
				$(".mo").show();
		}

	});


</script>

</head>
<body>
	<div class="evtCont">
		<!-- 크리스머니의 기적 -->
		<div class="mEvt57691">
			<div class="chrismoney">
				<div class="topic">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/txt_chrismoney.gif" alt="기적은 아직 끝나지 않았어요 쉿! 이번 기적은 아무도 모르게! 천천히 즐겨주세요. 크리스머니 사용기간은 2014년 12월 16일부터 24일까지입니다." /></p>

					<div class="mileage"><strong><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_5000_mileage.gif" alt="오천 마일리지" /></strong></div>
					<%' for dev msg : 솔드아웃이 style="display:block;"으로 바꿔주세요. %>
					<% If EventTotalChk < 1 Then %>
						<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/txt_soldout.png" alt="솔드아웃" /></p>
					<% End If %>

					<%' for dev msg : 크리스머니 받기 버튼 %>
					<div class="btn-ly">
						<a href="" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/btn_down.png" alt="크리스머니 받기" /></a>
					</div>

					<%' for dev msg : 크리스머니 받기 버튼 시 보이는 레이어팝업 %>
					<div id="ly-coupon" class="ly-coupon" style="display:none;">
						<div class="ly-inner">
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/txt_congratulation.gif" alt="축 크리스머니 5천 마일리지 지급 완료! 3만원 이상 구매 시 사용 가능합니다." /></p>
							<div class="btn-close"><button type="button" class="close" onclick="parent.location.reload();">확인</button></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/txt_hurry_up.gif" alt="상품 결제 시, 지급된 마일리지를 사용하세요. 마일리지는 12월 24일 이후에 자동 소멸됩니다. 서둘러서 사용해주세요!" /></p>
						</div>
					</div>

					<p class="define"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/txt_define.png" alt="크리스머니란? 12월 24일까지 사용할 수 있는 스폐셜 마일리지" /></p>
					<%' for dev msg : 잔여 수량 %>
					<div class="countdown-wrap">
						<strong><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/txt_limited.png" alt="선착순 오천명" /></strong>
						<div class="countdown">
							<em><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/txt_amount.png" alt="현재 잔여 수량" /></em>
							<span><%=FormatNumber(EventTotalChk, 0)%></span>
						</div>
					</div>
				</div>

				<div class="item">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/tit_benefit.png" alt="마일리지 쓰고 할인까지! 특급혜택" /></h3>
					<ul>
						<li><a href="" onclick="parent.fnAPPpopupProduct('965189'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_01.png" alt="클로버 터치폰 장갑" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('1180722'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_02.png" alt="델핀숄더백" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('537237'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_03.png" alt="토끼 터치 무드보틀 가습기" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('1150576'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_04.png" alt="푸르부 멜로디 다이어리" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('1171539'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_05.png" alt="써모머그 엄브렐러 보틀" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('1162836'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_06.png" alt="모그어스 베스트 퍼로퍼" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('1143505'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_07.png" alt="샤오미 보조배터리 5200mAh" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('993104'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_08.png" alt="1+1 loose socks" /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('964210'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_09.png" alt="베이직 벌집 롱 머플러 " /></a></li>
						<li><a href="" onclick="parent.fnAPPpopupProduct('1152526'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/img_item_10.png" alt="데꼴 2014 겨울 피규어" /></a></li>
					</ul>
					<!--div class="btn-more app"><a href="" onclick="fnAPPclosePopup();seltopmenu('best');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/btn_more.png" alt="베스트 상품 더 보러 가기" /></a></div-->
				</div>

				<div class="noti">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57691/tit_noti.gif" alt ="이벤트 유의사항" /></h2>
					<ul>
						<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
						<li>본 이벤트는 12.03~12.9일까지 텐바이텐 app을 설치한 고객들 대상으로 진행하는 시크릿 이벤트입니다.</li>
						<li>ID 당 1회만 크리스머니를 받을 수 있습니다.</li>
						<li>크리스머니는 12월24일 자정에 자동 소멸되며, 결제 시 지급된 5,000원 마일리지를 사용해주시기 바랍니다.</li>
						<li>마일리지는 3만원 이상 구매 시 현금처럼 사용 가능합니다.</li>
						<li>사용하지 않은 마일리지는 사전 통보 없이 자동 소멸됩니다.</li>
						<li>마일리지 사용 후, 남은 잔액은 소멸되지 않습니다.<br /> 기간 내에 꼭 사용해주세요.</li>
						<li></li>
					</ul>
				</div>

				<div class="mask"></div>
			</div>
		</div>
		<!--//크리스머니의 기적 -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->