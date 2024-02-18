<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : GS 핫딜 2차
' History : 2014.12.03 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/etc/event56701Cls.asp" -->

<%
dim eCode, userid
dim kakaotalksubscriptcount, gsshopsubscriptcount, subscriptcount, couponexistscount, totalcouponexistscount, dateitemlimitcnt, totalsubscriptcount
	eCode=getevt_code
	userid = getloginuserid()

kakaotalksubscriptcount=0
gsshopsubscriptcount=0
subscriptcount=0
dateitemlimitcnt=0
totalcouponexistscount=0
totalsubscriptcount=0
couponexistscount=0

'//본인 참여 여부
if userid<>"" then
	'//카카오톡 본인 응모수
	'kakaotalksubscriptcount = getevent_subscriptexistscount(eCode, userid, "kakaotalk", "", "")
	'//gsshop 본인 이동수
	'gsshopsubscriptcount = getevent_subscriptexistscount(eCode, userid, "gsshop", "", "")
	'//본인참여수
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "coupon", "", "")
	'//본인쿠폰다운로드수
	couponexistscount = getbonuscouponexistscount(userid, datecouponval(), "", "", "")
end if

'/상품 제한수량
dateitemlimitcnt=itemlimitcnt( dateitemval() )
'//전체 응모수
'totalsubscriptcount=getevent_subscripttotalcount(eCode, "coupon", "", "")
'//전체 상품 쿠폰 발행수량
'totalcouponexistscount=getbonuscoupontotalcount(datecouponval(),"", "", "")

%>

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt56701 img {vertical-align:top;}
.mEvt56701 .hotCoupon {position:relative; padding:20px 6%; background:#fff;}
.mEvt56701 .hotCoupon a {display:block;}
.mEvt56701 .hotCoupon a.free {width:42%; right:5.5%; top:11%;}
a.buy {display:block;}
.mEvt56701 .evtNoti {padding:27px 15px; background:#fff;}
.mEvt56701 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#222; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #222;}
.mEvt56701 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.4; padding-left:11px;}
.mEvt56701 .evtNoti li span {color:#ff0000;}
.mEvt56701 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:0; height:0; border-style:solid; border-width:3.5px 0 3.5px 5px; border-color:transparent transparent transparent #5c5c5c;}

.tip {text-align:center; padding:10px 0; font-size:14px; color:#d60000; font-weight:bold;}
@media all and (min-width:480px){
	.mEvt56701 .evtNoti {padding:40px 23px;}
	.mEvt56701 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt56701 .evtNoti li {font-size:17px; padding-left:17px;}
	.mEvt56701 .evtNoti li:after {top:4px; border-width:5px 0 5px 7px;}
	.tip {padding:15px 0; font-size:19px;}
}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

function jsitemSubmit(){
	<% ' If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-12-04" and left(currenttime,10)<"2014-12-05" Then %>
			<% if not (Hour(currenttime) > 11) then %>
				alert("오후 12시 쿠폰 다운후 구매해 주시기 바랍니다.");
				return;
			<% else %>
				<% ' if couponexistscount < 1 or subscriptcount < 1 then %>
					//alert("쿠폰을 먼저 다운받고 구매해주세요. 그냥 구매하면 혜택을 못 받아요!");
					//return;
				<% ' else %>
					<% if isApp=1 then %>
						parent.fnAPPpopupProduct('<%= dateitemval() %>')
						return false;
					<% else %>
						parent.location.href='/category/category_itemPrd.asp?itemid=<%= dateitemval() %>'
						return false;
					<% end if %>
				<% ' end if %>
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% ' Else %>
		<% ' if isApp=1 then %>
			//parent.calllogin();
			//return false;
		<% ' else %>
			//parent.jsChklogin_mobile('','<% '=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			//return false;
		<% ' end if %>
	<% ' End IF %>
}

function jscouponSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-12-04" and left(currenttime,10)<"2014-12-05" Then %>
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
						frm.action="/event/etc/doEventSubscript56701.asp";
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
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			return false;
		<% end if %>
	<% End IF %>
}

function sendgsshop() {
	<% ' If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-12-04" and left(currenttime,10)<"2014-12-05" Then %>
			<% ' if gsshopsubscriptcount>=10 then %>
				//alert("gsshop 핫딜 보러가기는 10회 까지만 가능 합니다.");
				//return;
			<% ' else %>
				var str = $.ajax({
					type: "GET",
					url: "/event/etc/doEventSubscript56701.asp",
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
					<% if isApp=1 then %>
						parent.fnAPPpopupExternalBrowser('http://m.gsshop.com/event/apply_hotdeal.jsp');
						return false;
					<% else %>
						evtFrmpop.target='_blank';
						evtFrmpop.action='http://m.gsshop.com/event/apply_hotdeal.jsp';
						evtFrmpop.submit();
						return false;
					<% end if %>
				}
			<% ' End IF %>
		<%  else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<%  end if %>
	<% ' Else %>
		<% ' if isApp=1 then %>
			//parent.calllogin();
			//return false;
		<% 'else %>
			//parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			//return false;
		<% 'end if %>
	<% ' End IF %>
}

Kakao.init('c967f6e67b0492478080bcf386390fdd');
			
function sendkakaotalk() {
	<% ' If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-12-04" and left(currenttime,10)<"2014-12-05" Then %>
			<% ' if kakaotalksubscriptcount>=5 then %>
				//alert("친구초대는 5회 까지만 가능 합니다.");
				//return;
			<% ' else %>
				var str = $.ajax({
					type: "GET",
					url: "/event/etc/doEventSubscript56701.asp",
					data: "mode=invitereg",
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
				//	alert('친구초대는 5회 까지만 가능 합니다.');
				//	return;
				}else if (str=='01'){

			      Kakao.Link.sendTalkLink({
					  label: '오후 12시! 함께하자! 텐바이텐 핫딜!\n단 하루 동안만 만나는 특별한 혜택! \n\n당신의 침샘을 자극할 극강의 맛! \n허니버터칩에 맞먹는 중독성!\n하바나 옥수수!! 22%할인 +무료배송!\n\n500명 한정 수량! 서두르세요!',
					  image: {
						src: 'http://imgstatic.10x10.co.kr/offshop/temp/2014/201412/56701_hot.jpg',
						width: '200',
						height: '200'
					  },
					 appButton: {
						text: '10X10 앱으로 이동',
						execParams :{
						<% IF application("Svr_Info") = "Dev" THEN %>
							android: { url: encodeURIComponent('http://testm.10x10.co.kr/event/eventmain.asp?eventid=<%= eCode %>')},
							iphone: { url: 'http://testm.10x10.co.kr/event/eventmain.asp?eventid=<%= eCode %>'}
						<% Else %>
							android: { url: encodeURIComponent('http://m.10x10.co.kr/event/eventmain.asp?eventid=<%= eCode %>')},
							iphone: { url: 'http://m.10x10.co.kr/event/eventmain.asp?eventid=<%= eCode %>'}
						<% End If %>
						}
					  },
					  installTalk : Boolean
			      });
	
	  				//top.location.href='<%=appUrlPath%>/event/eventmain.asp?eventid=<%=eCode%>';
	  				//return;
				}

			<% ' end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% ' Else %>
		<% ' if isApp=1 then %>
			//parent.calllogin();
			//return false;
		<% ' else %>
			//parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
			//return false;
		<% ' end if %>
	<% ' End IF %>
}

</script>
</head>
<body>

<!-- 함께하자 핫딜(M+APP) -->
<div class="mEvt56701">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/tit_hot_deal.png" alt="목요일12시, 함께하자 핫딜!" /></h2>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/img_hot_product.png" alt="한정수량 500개 멕시칸 하바나 옥수수" /></p>
	<div class="hotCoupon">
		<!--
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/txt_coupon.png" alt="핫딜가에 무료배송 혜택까지 받으려면, 무료배송 쿠폰을 꼭 다운받아 주세요! 타 상품에는 적용할 수 없습니다." /></p>
		<a href="" class="free" onclick="jscouponSubmit(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/btn_free_delivery.png" alt="핫딜 무료배송 쿠폰 다운받기" /></a>
		-->
		<a href="" class="buy" onclick="jsitemSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/btn_go_buy.png" alt="구매하러가기" /></a>
		<p class="tip" style="">선착순 500개 무료배송</p>
	</div>
	<dl>
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/tit_havana.png" alt="HAVANA SWEET CORN 뉴욕 하바나 옥수수 그대로의 맛을 집에서 느껴보세요!" /></dt>
		<dd>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/img_option01.png" alt="옵션" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/img_option02.png" alt="옵션" /></p>
		</dd>
		<dd><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/img_howto_eat.png" alt="HOW TO EAT" /></dd>
		<dd><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/img_detail.png" alt="DETAIL" /></dd>
	</dl>
	<dl class="evtNoti">
		<dt>이벤트 유의사항</dt>
		<dd>
			<ul>
				<li>본 이벤트는 로그인 후에 참여가능합니다.</li>
				<!--<li>쿠폰은 ID당 1회만 다운받을 수 있습니다.</li>-->
				<li>선착순 500개만 무료배송 해택이 있습니다.</li>
				<li>상품은 조기 품절 될 수 있습니다.</li>
				<!--<li>무료배송 쿠폰은 텐바이텐 앱에서만 사용가능하며, 타 상품에는 적용할 수 없습니다.</li>-->
			</ul>
		</dd>
	</dl>
	<p><a href="" onclick="sendkakaotalk(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/btn_noti_friends.png" alt="친구에게 맛있는 핫딜 알려주기" /></a></p>
	<p><a href="" onclick="sendgsshop(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/56701/btn_gs_deal.png" alt="GS SHOP 핫딜 보러가기" /></a></p>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
	</form>
	<form name="evtFrmpop" action="" onsubmit="return false;" method="get" style="margin:0px;">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
<!--// 함께하자 핫딜(M+APP) -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->