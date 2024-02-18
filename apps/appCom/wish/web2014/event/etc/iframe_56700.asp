<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : GS 핫딜 (장바구니 바로감)
' History : 2014.11.19 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/etc/event56700Cls.asp" -->

<%
dim eCode, userid
dim kakaotalksubscriptcount, gsshopsubscriptcount, subscriptcount, itemcouponexistscount, totalitemcouponexistscount, dateitemlimitcnt, totalsubscriptcount
	eCode=getevt_code
	userid = getloginuserid()

kakaotalksubscriptcount=0
gsshopsubscriptcount=0
subscriptcount=0
dateitemlimitcnt=0
totalitemcouponexistscount=0
totalsubscriptcount=0
itemcouponexistscount=0

'//본인 참여 여부
if userid<>"" then
	'//카카오톡 본인 응모수
	kakaotalksubscriptcount = getevent_subscriptexistscount(eCode, userid, "kakaotalk", "", "")
	'//gsshop 본인 이동수
	'gsshopsubscriptcount = getevent_subscriptexistscount(eCode, userid, "gsshop", "", "")
	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "itemcoupon", "", "")
	'//본인쿠폰다운로드수
	itemcouponexistscount = getitemcouponexistscount(userid, datecouponval(), "", "")
end if

'/상품 제한수량
dateitemlimitcnt=itemlimitcnt( dateitemval() )
'//전체 응모수
'totalsubscriptcount=getevent_subscripttotalcount(eCode, "itemcoupon", "", "")
'//전체 상품 쿠폰 발행수량
'totalitemcouponexistscount=getitemcouponexistscount("", datecouponval(), "", "")

'response.write dateitemlimitcnt & "/" & totalsubscriptcount & "<br>"

%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<style type="text/css">
.mEvt56700 {position:relative;}
.mEvt56700 img {vertical-align:top;}
.mEvt56700 .evtNoti {padding:25px 14px; background:#fff;}
.mEvt56700 .evtNoti dt {display:inline-block; margin-bottom:12px; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; border-bottom:2px solid #222;}
.mEvt56700 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;  -webkit-text-size-adjust: 100%;}
.mEvt56700 .evtNoti li span {color:#d60000;}
.mEvt56700 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}
@media all and (min-width:480px){
	.mEvt56700 .evtNoti {padding:38px 21px;}
	.mEvt56700 .evtNoti dt {font-size:21px; margin-bottom:18px;}
	.mEvt56700 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt56700 .evtNoti li:after {top:4px; border-width:5px 0 5px 7px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

function jsitemSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-11-20" and left(currenttime,10)<"2014-11-21" Then %>
			<% if not (Hour(currenttime) > 11) then %>
				alert("오후 12시 쿠폰 다운후 구매해 주시기 바랍니다.");
				return;
			<% else %>
				<% if itemcouponexistscount < 1 or subscriptcount < 1 then %>
					alert("쿠폰을 먼저 다운받고 구매해주세요. 그냥 구매하면 혜택을 못 받아요!");
					return;
				<% else %>
					parent.fnAPPpopupProduct('<%= dateitemval() %>')
					return;
				<% end if %>
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		parent.calllogin();
		return;
	<% End IF %>
}

function jscouponSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-11-20" and left(currenttime,10)<"2014-11-21" Then %>
			<% if subscriptcount <> 0 then %>
				alert("한 개의 아이디당 한 번만 다운로드 하실 수 있습니다.");
				return;
			<% else %>
				<% if not (Hour(currenttime) > 11) then %>
					alert("앗! 오후 12시부터 쿠폰 다운이 가능합니다. 조금만 기다려주세요.");
					return;
				<% else %>
					<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
						alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
						return;
					<% else %>
						frm.action="/apps/appcom/wish/web2014/event/etc/doEventSubscript56700.asp";
						frm.target="evtFrmProc";
						frm.mode.value='couponinsert';
						frm.submit();
					<% end if %>
				<% end if %>
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		parent.calllogin();
		return;
	<% End IF %>
}

function sendgsshop() {
	<% ' If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-11-20" and left(currenttime,10)<"2014-11-21" Then %>
			<% ' if gsshopsubscriptcount>=10 then %>
				//alert("gsshop 핫딜 보러가기는 10회 까지만 가능 합니다.");
				//return;
			<% ' else %>
				var str = $.ajax({
					type: "GET",
					url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript56700.asp",
					data: "mode=gsshopreg",
					dataType: "text",
					async: false
				}).responseText;
				//alert( str );
				if (str==''){
					alert('정상적인 경로가 아닙니다');
					return;
				//}else if (str=='99'){
				//	alert('로그인을 하셔야 참여가 가능 합니다.');
				//	return;
				}else if (str=='02'){
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				//}else if (str=='03'){
				//	alert('gsshop 핫딜 보러가기는 10회 까지만 가능 합니다.');
				//	return;
				}else if (str=='01'){
					parent.fnAPPpopupExternalBrowser('http://m.gsshop.com/event/apply_hotdeal.jsp');
					return;
				}
			<% ' End IF %>
		<%  else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<%  end if %>
	<% ' Else %>
		//parent.calllogin();
		//return;
		//parent.jsevtlogin();
		//return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% ' End IF %>
}

Kakao.init('c967f6e67b0492478080bcf386390fdd');
			
function sendkakaotalk() {
	<% If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-11-20" and left(currenttime,10)<"2014-11-21" Then %>
			<% if kakaotalksubscriptcount>=5 then %>
				alert("친구초대는 5회 까지만 가능 합니다.");
				return;
			<% else %>
				var str = $.ajax({
					type: "GET",
					url: "/apps/appcom/wish/web2014/event/etc/doEventSubscript56700.asp",
					data: "mode=invitereg",
					dataType: "text",
					async: false
				}).responseText;
				//alert( str );
				if (str==''){
					alert('정상적인 경로가 아닙니다');
					return;
				}else if (str=='99'){
					alert('로그인을 하셔야 참여가 가능 합니다.');
					return;
				}else if (str=='02'){
					alert('이벤트 응모 기간이 아닙니다.');
					return;
				}else if (str=='03'){
					alert('친구초대는 5회 까지만 가능 합니다.');
					return;
				}else if (str=='01'){

			      Kakao.Link.sendTalkLink({
					  label: '함께하자! 텐바이텐 핫딜!\n혹시 알고 있어요?\n역대 가습기 베스트 NO1. 토끼터치 무드보틀 가습기가 무려 41%할인!\n오늘 하루만 초특가! 서두르세요!\n',
					  image: {
						src: 'http://imgstatic.10x10.co.kr/offshop/temp/2014/201411/gsshophotdeal.jpg',
						width: '200',
						height: '200'
					  },
					 appButton: {
						text: '10X10 앱으로 이동',
						execParams :{
						<% IF application("Svr_Info") = "Dev" THEN %>
							android: { url: encodeURIComponent('http://testm.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>')},
							iphone: { url: 'http://testm.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>'}
						<% Else %>
							android: { url: encodeURIComponent('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>')},
							iphone: { url: 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>'}
						<% End If %>
						}
					  },
					  installTalk : Boolean
			      });
	
	  				top.location.href='/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=eCode%>';
	  				return;
				}

			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		parent.calllogin();
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
</head>
<body>

<!-- 함께하자! 핫딜!(APP) -->
<div class="mEvt56700">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/txt_cross_deal.png" alt="10X10과 GS SHOP이 함께하는 크로스 핫딜 이벤트!" /></p>
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/tit_hotdeal.png" alt="목요일 열두시 함께하자! HOT DEAL - 텐바이텐에서 만나는 또 하나의 핫딜 이벤트! 인기 베스트 상품을 특별한 가격으로 만나자! 2014년 11월 20일(목요일) 오후 12시" /></h2>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/img_deal_product.png" alt="토끼터치 무드보틀 가습기" /></div>
	<div>
		<a href="" onclick="jscouponSubmit(evtFrm1); return false;">
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/btn_coupon.png" alt="41% 핫딜 전용쿠폰 다운받기 - 반드시 쿠폰을 다운받아야 핫딜가에 구매 가능합니다. 타 상품에는 적용할 수 없습니다." />
		</a>
	</div>
	<div><a href="" onclick="jsitemSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/btn_go_buy.png" alt="구매 하러 가기" /></a></div>
	<div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/img_product_info01.png" alt="상품 정보1" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/img_product_info02.png" alt="상품 정보2" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/img_product_info03.png" alt="상품 정보3" /></p>
	</div>
	<dl class="evtNoti">
		<dt>이벤트 유의사항</dt>
		<dd>
			<ul>
				<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
				<li>쿠폰은 ID당 1회만 다운받을 수 있습니다.</li>
				<li>500개 한정 수량이며, 조기에 품절 될 수 있습니다.</li>
				<li>할인쿠폰은 텐바이텐 앱에서만 사용 가능하며, 타 상품에는 적용할 수 없습니다.</li>
			</ul>
		</dd>
	</dl>
	<p><a href="" onclick="sendkakaotalk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/btn_10x10_hotdeal.png" alt="친구에게 오늘의 핫딜 알려주기" /></a></p>
	<p><a href="" onclick="sendgsshop(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56700/btn_gsshop_hotdeal.png" alt="GS SHOP 핫딜 보러가기" /></a></p>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
<!--// 함께하자! 핫딜!(APP) -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->