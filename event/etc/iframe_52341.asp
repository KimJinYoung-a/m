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
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/event52341Cls.asp" -->

<%
dim eCode, userid, totalsubscriptcount, subscriptcount, dateitemlimitcnt, totalitemcouponexistscount
	eCode=getevt_code
	userid = getloginuserid()

totalitemcouponexistscount=0
totalsubscriptcount=0
subscriptcount=0
dateitemlimitcnt=0

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "1", "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, left(currenttime,10), "1", "1")
'//전체 상품 쿠폰 발행수량
totalitemcouponexistscount=getitemcouponexistscount("", datecouponval(left(currenttime,10)), "", "")

'/상품 제한수량
dateitemlimitcnt=itemlimitcnt( dateitemval(left(currenttime,10)) )

dim currentitem		'//지금 표시 되고 있는 상품

dim ename, emimg, cEvent
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	eCode		= cEvent.FECode
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 와썹! 만원 팔이 피플</title>
<style type="text/css">
.mEvt52618 {}
.mEvt52618 img {vertical-align:top; width:100%;}
.mEvt52618 p {max-width:100%;}
.mEvt52618 .checkIt {background:#f7f7f7;}
.mEvt52618 .checkIt ul {overflow:hidden; padding:0 3.5%;}
.mEvt52618 .checkIt li {float:left; width:50%; padding:5% 1.7% 0 1.7%; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52618 .checkIt li a {position:relative; display:block;}
.mEvt52618 .checkIt li .close {display:block; position:absolute; left:0; top:0; width:100%; height:100%; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52618/txt_close.png) left top no-repeat; background-size:100% 100%;}
.mEvt52618 .appDownload {position:relative;}
.mEvt52618 .appDownload a {display:block; position:absolute; left:24%; bottom:8%; width:52%;}
.mEvt52618 .evtNoti {padding:24px 0 18px; text-align:left; background:#6fd8e7;}
.mEvt52618 .evtNoti dt {padding:0 0 12px 22px;}
.mEvt52618 .evtNoti ul {overflow:hidden; padding:0 12px;}
.mEvt52618 .evtNoti li {padding:0 0 3px 10px; font-size:11px; color:#444; line-height:12px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52618/blt_arrow.png) left 4px no-repeat; background-size:4px 4px;}
.mEvt52618 .evtNoti li strong {color:#f4ff4c;}
.mEvt52618 .today {position:relative;}
.mEvt52618 .today .soon {position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52618/img_coming_soon.png) left top repeat; background-size:100% 100%;}
.mEvt52618 .today .soldout {position:absolute; left:0; top:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/52618/img_soldout.png) left top repeat; background-size:100% 100%;}
</style>
<script type="text/javascript">
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipad')) { //아이패드
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipod')) { //아이팟
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('android')) { //안드로이드 기기
		document.location="market://details?id=kr.tenbyten.shopping"
	} else { //그 외
		document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
	}
};
</script>
</head>
<body>

<!-- 만원 팔이 피플 -->
<div class="mEvt52618">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/tit_seller_people.png" alt="먼저 사면 임자, 텐바이텐에서 놀자! 와썹! 만원 팔이 피플" /></h3>
	<!-- 수정-0611 -->
	<div class="today">
		<% if left(currenttime,10)<="2014-06-16" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0616_soon.png" alt="6월 16일 오늘의 만원 팔이" />
				<% currentitem = "0616" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0617_soon.png" alt="6월 17일 오늘의 만원 팔이" />
				<% currentitem = "0617" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0616.png" alt="6월 16일 오늘의 만원 팔이" />
				<% currentitem = "0616" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)="2014-06-17" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0617.png" alt="6월 17일 오늘의 만원 팔이" />
				<% currentitem = "0617" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0618_soon.png" alt="6월 18일 오늘의 만원 팔이" />
				<% currentitem = "0618" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0617.png" alt="6월 17일 오늘의 만원 팔이" />
				<% currentitem = "0617" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)="2014-06-18" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0618.png" alt="6월 18일 오늘의 만원 팔이" />
				<% currentitem = "0618" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0619_soon.png" alt="6월 19일 오늘의 만원 팔이" />
				<% currentitem = "0619" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0618.png" alt="6월 18일 오늘의 만원 팔이" />
				<% currentitem = "0618" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)="2014-06-19" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0619.png" alt="6월 19일 오늘의 만원 팔이" />
				<% currentitem = "0619" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0620_soon.png" alt="6월 20일 오늘의 만원 팔이" />
				<% currentitem = "0620" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0619.png" alt="6월 19일 오늘의 만원 팔이" />
				<% currentitem = "0619" %>
			<% end if %>
		<% end if %>
		<% if left(currenttime,10)>="2014-06-20" then %>
			<% if Hour(currenttime) < 13 then %>
				<p class="soon"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0620.png" alt="6월 20일 오늘의 만원 팔이" />
				<% currentitem = "0620" %>
			<% elseif not (Hour(currenttime) > 12 and Hour(currenttime) < 17) then %>
				<p class="soldout"></p>
				<!--대기 이미지-->
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0620.png" alt="6월 20일 오늘의 만원 팔이" />				
				<% currentitem = "0620" %>
			<% else %>
				<% if totalsubscriptcount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% elseif totalitemcouponexistscount>=dateitemlimitcnt then %>
					<p class="soldout"></p>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_today_product_0620.png" alt="6월 20일 오늘의 만원 팔이" />
				<% currentitem = "0620" %>
			<% end if %>
		<% end if %>
	</div>
	<!--// 수정-0611 -->
	<div class="checkIt">
		<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/tit_check.png" alt="Check it up now!" /></h4>
		<ul>
			<% if currentitem<>"0616" then %>
				<li><a href="/category/category_itemPrd.asp?itemid=1073195" target="_top">
				<% if left(currenttime,10)>"2014-06-15" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_product_0616.png" alt="6월16일 팔이" /></a></li>
			<% end if %>
			<% if currentitem<>"0617" then %>
				<li><a href="/category/category_itemPrd.asp?itemid=1073237" target="_top">
				<% if left(currenttime,10)>"2014-06-16" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_product_0617.png" alt="6월17 팔이" /></a></li>			
			<% end if %>			
			<% if currentitem<>"0618" then %>
				<li><a href="/category/category_itemPrd.asp?itemid=1073229" target="_top">
				<% if left(currenttime,10)>"2014-06-17" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_product_0618.png" alt="6월18 팔이" /></a></li>
			<% end if %>
			<% if currentitem<>"0619" then %>
				<li><a href="/category/category_itemPrd.asp?itemid=1073224" target="_top">
				<% if left(currenttime,10)>"2014-06-18" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_product_0619.png" alt="6월19 팔이" /></a></li>
			<% end if %>			
			<% if currentitem<>"0620" then %>
				<li><a href="/category/category_itemPrd.asp?itemid=1073520" target="_top">
				<% if left(currenttime,10)>"2014-06-19" then %>
					<span class="close">close</span>
				<% end if %>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/img_product_0620.png" alt="6월20 팔이" /></a></li>
			<% end if %>	
		</ul>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/bg_product.png" alt="" /></p>
	<div class="appDownload">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/tit_app_download.png" alt="텐바이텐 APP 로드로드 다운로드!" /></p>
		<a href="#" onclick="gotoDownload()" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/btn_app_download.png" alt="10X10 WISH APP DOWNLOAD" /></a>
	</div>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52618/tit_notice.png" alt="유의사항 이에YO!" style="width:90px;" /></dt>
		<dd>
			<ul>
				<li>텐바이텐 고객님을 위한 특가 이벤트 입니다. (비회원 구매 불가)</li>
				<li><strong>텐바이텐 APP의 이벤트를 통해 응모 후, 당첨이 되신 고객님에 한하여 만원의 구매 혜택이 주어집니다.</strong></li>
				<li>주문 후 결제 시 '상품 쿠폰'을 꼭 적용해주세요.</li>
				<li>이벤트 상품은 구매 후 환불 및 옵션 교환이 불가합니다.</li>
				<li>한 ID당 하루 한 개만 구매하실 수 있습니다.</li>
				<li>만원의 구매기회가 주어지더라도, 당일 24시까지만 유효합니다.</li>
				<li>상품 컬러 및 옵션은 랜덤으로 발송됩니다.</li>
			</ul>
		</dd>
	</dl>
</div>
<!-- //만원 팔이 피플 -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->