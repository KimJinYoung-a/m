<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 만원 팔이피플
' History : 2014.06.11 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event52619Cls.asp" -->

<%
dim eCode, userid, totalsubscriptcount, subscriptcount, dateitemlimitcnt, totalitemcouponexistscount, winnersubscriptcount
	eCode=getevt_code
	userid = getloginuserid()

totalitemcouponexistscount=0
totalsubscriptcount=0
subscriptcount=0
dateitemlimitcnt=0
winnersubscriptcount=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "")
	winnersubscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "1")		'//당첨여부
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "1", "1")
'//전체 상품 쿠폰 발행수량
totalitemcouponexistscount=getitemcouponexistscount("", datecouponval(left(currenttime,10)), "", "")

'/상품 제한수량
dateitemlimitcnt=itemlimitcnt( dateitemval(left(currenttime,10)) )

'response.write left(currenttime,10) & "/subscriptcount:" & subscriptcount & "/totalsubscriptcount:" & totalsubscriptcount & "/totalitemcouponexistscount:" & totalitemcouponexistscount & "/dateitemlimitcnt:" & dateitemlimitcnt

dim currentitem		'//지금 표시 되고 있는 상품
%>

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<title>생활감성채널, 텐바이텐 > 이벤트 > 와썹! 만원 팔이 피플</title>
<style type="text/css">
.mEvt52619 {}
.mEvt52619 img {vertical-align:top; width:100%;}
.mEvt52619 p {max-width:100%;}
.mEvt52619 .checkIt {background:#f7f7f7;}
.mEvt52619 .checkIt ul {overflow:hidden; padding:0 3.5%;}
.mEvt52619 .checkIt li {float:left; width:50%; padding:5% 1.7% 0 1.7%; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52619 .checkIt li a {position:relative; display:block;}
.mEvt52619 .checkIt li .close {display:block; position:absolute; left:0; top:0; width:100%; height:100%; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52619/txt_close.png) left top no-repeat; background-size:100% 100%;}
.mEvt52619 .goBuy {padding-bottom:6%;}
.mEvt52619 .goBuy a {display:block; width:80%; margin:0 auto;}
.mEvt52619 .evtNoti {padding:24px 0 18px; margin:0; text-align:left; background:#6fd8e7;}
.mEvt52619 .evtNoti dt {padding:0 0 12px 22px;}
.mEvt52619 .evtNoti dd {padding:0; margin:0; text-align:left;}
.mEvt52619 .evtNoti ul {overflow:hidden; padding:0 12px;}
.mEvt52619 .evtNoti li {padding:0 0 3px 10px; font-size:11px; color:#444; line-height:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52619/blt_arrow.png) left 4px no-repeat; background-size:4px 4px;}
.mEvt52619 .evtNoti li strong {color:#f4ff4c;}
.mEvt52619 .today {position:relative;}
.mEvt52619 .today .soon {position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52618/img_coming_soon.png) left top repeat; background-size:100% 100%;}
.mEvt52619 .today .soldout {position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52618/img_soldout.png) left top repeat; background-size:100% 100%;}
</style>
<script type="text/javascript">

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If left(currenttime,10)>="2014-06-16" and left(currenttime,10)<"2014-06-21" Then %>
			<% if subscriptcount=0 then %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					alert("오늘의 만원 팔이피플 상품이 전부 소진되었습니다. 아쉽네요.\n만원 팔이피플을 사랑해주셔서 감사합니다.\n다음에 또 찾아볼게요! :)");
					return;
				<% else %>
					<% if totalitemcouponexistscount>=dateitemlimitcnt then %>
						alert("오늘의 만원 팔이피플 상품이 전부 소진되었습니다. 아쉽네요.\n만원 팔이피플을 사랑해주셔서 감사합니다.\n다음에 또 찾아볼게요! :)");
						return;
					<% else %>
						<% if not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
							alert("오후 1시부터 5시까지만 응모가 가능합니다.");
							return;
						<% else %>
							<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
								alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
								return;
							<% else %>
								frm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript52619.asp";
								frm.target="evtFrmProc";
								frm.mode.value='iteminsert';
								frm.submit();
							<% end if %>
						<% end if %>
					<% end if %>
				<% end if %>
			<% else %>
				alert("한 개의 아이디당 하루 한 번만 응모하실 수 있습니다.");
				return;
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% End IF %>
}

</script>
</head>
<body>

<!-- 만원 팔이 피플 -->
<div class="mEvt52619">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/tit_seller_people.jpg" alt="먼저 사면 임자, 텐바이텐에서 놀자! 와썹! 만원 팔이 피플" /></h3>
	<div class="today">
		<% if left(currenttime,10)<="2014-06-16" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0616_soon.png" alt="6월 16일 오늘의 만원 팔이" />
				<% currentitem = "0616" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0617_soon.png" alt="6월 17일 오늘의 만원 팔이" />
				<% currentitem = "0617" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0616.png" alt="6월 16일 오늘의 만원 팔이" />
				<% currentitem = "0616" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)="2014-06-17" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0617.png" alt="6월 17일 오늘의 만원 팔이" />
				<% currentitem = "0617" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0618_soon.png" alt="6월 18일 오늘의 만원 팔이" />
				<% currentitem = "0618" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0617.png" alt="6월 17일 오늘의 만원 팔이" />
				<% currentitem = "0617" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)="2014-06-18" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0618.png" alt="6월 18일 오늘의 만원 팔이" />
				<% currentitem = "0618" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0619_soon.png" alt="6월 19일 오늘의 만원 팔이" />
				<% currentitem = "0619" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0618.png" alt="6월 18일 오늘의 만원 팔이" />
				<% currentitem = "0618" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)="2014-06-19" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0619.png" alt="6월 19일 오늘의 만원 팔이" />
				<% currentitem = "0619" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0620_soon.png" alt="6월 20일 오늘의 만원 팔이" />
				<% currentitem = "0620" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0619.png" alt="6월 19일 오늘의 만원 팔이" />
				<% currentitem = "0619" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)>="2014-06-20" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0620.png" alt="6월 20일 오늘의 만원 팔이" />
				<% currentitem = "0620" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soldout"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0620.png" alt="6월 20일 오늘의 만원 팔이" />				
				<% currentitem = "0620" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_today_product_0620.png" alt="6월 20일 오늘의 만원 팔이" />
				<% currentitem = "0620" %>
			<% end if %>
		<% end if %>
	</div>
	<div class="checkIt">
		<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/tit_check_it.png" alt="Check it up now!" /></h4>
		
		<% If left(currenttime,10)>="2014-06-16" and left(currenttime,10)<"2014-06-21" Then %>
			<% if winnersubscriptcount=1 then %>
				<p class="goBuy">
					<a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%= dateitemval(left(currenttime,10)) %><%= dateitemlinkval(left(currenttime,10)) %>" target="_top">
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/btn_buy.png" alt="오늘의 상품 구매하러 가기" /></a>
				</p>
			<% elseif subscriptcount=0 then %>
				<p class="goBuy">
					<a href="" onclick="jseventSubmit(evtFrm1); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/btn_apply.png" alt="만원 팔이피플 응모하기" /></a>
				</p>
			<% elseif subscriptcount=1 and winnersubscriptcount=0 then %>
				<!--<p class="goBuy">
					<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/txt_apply_already.png" alt="오늘은 이미 응모하셨습니다. 내일 다시 도전해주세요!" /></span>
				</p>-->
			<% end if %>
		<% end if %>

		<ul>
			<% if currentitem<>"0616" then %>
				<li><a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=1073195" target="_top">
				<% if left(currenttime,10)>"2014-06-15" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_product_0616.png" alt="6월16일 팔이" /></a></li>
			<% end if %>
			<% if currentitem<>"0617" then %>
				<li><a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=1073237" target="_top">
				<% if left(currenttime,10)>"2014-06-16" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_product_0617.png" alt="6월17 팔이" /></a></li>			
			<% end if %>			
			<% if currentitem<>"0618" then %>
				<li><a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=1073229" target="_top">
				<% if left(currenttime,10)>"2014-06-17" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_product_0618.png" alt="6월18 팔이" /></a></li>
			<% end if %>
			<% if currentitem<>"0619" then %>
				<li><a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=1073224" target="_top">
				<% if left(currenttime,10)>"2014-06-18" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_product_0619.png" alt="6월19 팔이" /></a></li>
			<% end if %>			
			<% if currentitem<>"0620" then %>
				<li><a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=1073520" target="_top">
				<% if left(currenttime,10)>"2014-06-19" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/img_product_0620.png" alt="6월20 팔이" /></a></li>
			<% end if %>				
		</ul>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/bg_product.png" alt="" /></p>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52619/tit_notice.png" alt="유의사항 이에YO!" style="width:90px;" /></dt>
		<dd>
			<ul>
				<li>텐바이텐 고객님을 위한 특가 이벤트 입니다. (비회원 구매 불가)</li>
				<li>텐바이텐 <strong>APP의 이벤트를 통해 상품 및 이벤트 당첨여부를 확인하셔야 할인 적용이 가능</strong>합니다.</li>
				<li>이벤트 당첨 기회를 얻으신 후에는 쿠폰 적용을 하여 구매하셔야 만원에 구매가 가능합니다.</li>
				<li>주문 후 결제 시, 쿠폰을 꼭 적용해주세요.</li>
				<li>상품은 구매 후 환불 및 옵션 교환/변경이 불가합니다.</li>
				<li>한 ID당 하루 한 개만 구매하실 수 있습니다. (중복 구매 확인 시 1건을 초과한 주문은 배송이 불가합니다.)</li>
			</ul>
		</dd>
	</dl>
</div>
<!-- //만원 팔이 피플 -->

<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->