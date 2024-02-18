<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
'####################################################
' Description : 9월 쇼핑혜택
' History : 2020-09-02 허진원
'####################################################
dim currentDate
dim aType : aType = Request.Cookies("sale2020")("atype")
dim vDisp : vDisp = Request.Cookies("sale2020")("disp")
dim dateGubun : dateGubun = Request.Cookies("sale2020")("dategubun")
dim page : page = 1
dim dataUrl
dim eCode

currentDate = date()
if atype="" then atype="si"

IF application("Svr_Info") = "Dev" THEN
	eCode   =  102219
Else
	eCode   =  105514
End If

dim iscouponeDown, vQuery, eventCoupons
iscouponeDown = false
IF application("Svr_Info") = "Dev" THEN
	eventCoupons = "22245,22246"
Else
	eventCoupons = "89651,89652"
End If

vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] where userid = '" & getencLoginUserid() & "'"
vQuery = vQuery + " and itemcouponidx in ("&eventCoupons&") "
vQuery = vQuery + " and usedyn = 'N' "
rsget.CursorLocation = adUseClient
rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
If rsget(0) = 7 Then
	iscouponeDown = true
End IF
rsget.close
%>
<style>
.sep20 {position:relative; overflow:hidden; background:#fff;}
.sep20 button {background:none;}
.sep20 .topic {position:relative; background:#f74949;}
.sep20 .topic .only {position:absolute; top:33.8%; right:3.3%; width:22.9%; animation:bounce 1s 10 both;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(10%); animation-timing-function:ease-out;}
}
.sep20 .topic .btn-cpn {display:block; width:100%;}

.sep20 .tab-wrap {position:relative; height:0; padding-top:5.12rem;}
.sep20 .tab-list {position:absolute; left:0; top:0; z-index:15; display:-webkit-box; display:-ms-flexbox; display:flex; width:100%; height:5.12rem; background:#c31919; /* transition:top 0.2s ease-in-out; */}
.sep20 .tab-list li {-webkit-box-flex:1; -ms-flex:1; flex:1;}
.sep20 .tab-list li.active {background:#8f0202;}
.sep20 .tab-list li a {display:-webkit-box; display:-ms-flexbox; display:flex; height:100%; align-items:center; justify-content:center; text-align:center;}
.sep20 .tab-list li a span {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.45rem; line-height:1.2; color:#fff;}
.sep20 .tab-list.tab-up {position:fixed; top:4.44rem;}
.sep20 .tab-list.tab-down {position:fixed; top:calc(4.78rem + 4.44rem);}

.sep20 .section {position:relative;}
.sep20 .section .ttl {padding:3.5rem 0 2.3rem 6.4%; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; font-size:2.56rem; line-height:1.15; color:#101010; letter-spacing:-1px;}
.sep20 .section#hot .ttl {padding-bottom:3rem;}

.items-list {position:relative;}
.items-list ul {display:flex; flex-flow:row wrap; padding:0 2%;}
.items-list ul:after {content:' '; display:block; clear:both;}
.items-list li {position:relative; float:left; width:50%; padding:0 2.08%;}
.items-list li > a {display:block; position:relative;}
.items-list .label-time {display:inline-block; position:absolute; left:0; top:-1.54rem; z-index:10; height:2.4rem; padding:0 1.07rem; color:#111; font:normal 1.1rem/2.8rem 'CoreSansCBold','AppleSDGothicNeo-Bold','NotoSansKRBold'; background:#D1FF59; border-radius:.85rem .85rem .85rem 0;}
.items-list .label-time:after {content:''; display:inline-block; position:absolute; left:0; bottom:-.4rem; width:0; height:0; border-style:solid; border-width:.43rem .51rem 0 0; border-color:#D1FF59 transparent transparent transparent;}
.items-list .desc {position:relative; height:13rem; padding-top:1.7rem; color:#111; font-family:'CoreSansCRegular','AppleSDGothicNeo-Regular','NotoSansKRRegular'; }
.sep20 .section#hot .items-list .desc {height:14.2rem;}
.items-list .price {font-size:1.7rem; font-family:'CoreSansCBold','AppleSDGothicNeo-Bold','NotoSansKRBold';}
.items-list .price span {padding-left:.3rem; font-size:1.3rem; color:#ff214f; vertical-align:1px;}
.items-list .price span em {font-size:1.37rem;}
.items-list .name {overflow:hidden; max-height:3rem; margin-top:.64rem; font-size:1.2rem; line-height:1.29; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-break:break-all;}
.items-list .brand {padding-top:.7rem; color:#999;}
.items-list .badge {overflow:hidden; padding-top:1.45rem;}
.items-list .badge span {display:inline-block; float:left; height:1.45rem; padding:0 .34rem; border:1px solid #111; font:normal .85rem/1.35rem 'NotoSansKRBold';}
.items-list .badge span:nth-child(2n) {color:#fff; background-color:#111;}
.items-list .review {padding-top:.7rem;}
.items-list .review span {display:inline-block;}
.items-list .review .rating,
.items-list .review .rating i {height:.86rem; background:url(//fiximage.10x10.co.kr/m/2020/common/ico_star.svg) repeat-x 0 0 / .94rem auto;}
.items-list .review .rating {width:4.7rem; }
.items-list .review .rating i {display:inline-block; background-position-y:-1.7rem;}
.items-list .review .counting {color:#666; font-family:'CoreSansCLight';}
.items-list .btn-wish {display:inline-block; position:absolute; right:0; top:1.37rem; width:1.7rem; height:1.7rem; font-size:0; color:transparent; background:rgba(0,0,0,.3) url(//fiximage.10x10.co.kr/web2020/common/ico_heart.svg?=v2) no-repeat 0 0 / 100% auto;}
.items-list .btn-wish.on {background-position-y:100%;}
.items-list div.thumbnail:before {left:0; top:0; z-index:5; width:100%; height:100%; margin:0; background:rgba(0,0,0,.02);}
.items-list .soldout .thumbnail:before {content:'일시 품절'; padding-top:41%; text-align:center; color:#fff; font:normal 2rem/1.2 'AppleSDGothicNeo-SemiBold','NotoSansKRMedium'; background:rgba(0,0,0,.4); box-sizing:border-box;}
.items-list .adult .thumbnail:before {background:#f5f5f5;}
.items-list .adult .thumbnail:after {content:'19'; position:absolute; left:50%; top:50%; z-index:6; width:6.84rem; height:6.84rem; margin:-3.59rem 0 0 -3.59rem; color:#ccc; text-align:center; font:normal 3rem/6.84rem 'CoreSansCMedium'; border:.34rem solid #ddd; border-radius:50%;}
.items-list .btn-more {display:block; width:100%; margin-bottom:4rem;}

.sep20 .bnf-lst {padding:0 4.3% 10%;}
.sep20 .bnf-lst li {padding-bottom:4.7%;}
</style>
<div class="mEvt105514 sep20">
	<div class="topic">
		<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/tit_sale.png" alt="쇼핑지원 특별할인쿠폰"></h2>
		<span class="only"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/txt_only.png" alt="선착순"></span>
		<% If isapp="1" Then %>
		<button type="button" class="btn-cpn"onclick="fnNewCouponIssued('105514','1420');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/btn_cpn.png" alt="쿠폰 받기"></button>
		<% Else %>
		<a href="https://tenten.app.link/IkbnAxeBk9?%24deeplink_no_attribution=true"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/btn_app.png" alt="APP 설치하고 쿠폰 받기"></a>
		<% end If %>
		<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/txt_noti.png" alt="9월 7일부터 21일까지"></p>
	</div>
	<nav class="tab-wrap">
		<ul class="tab-list">
			<li class="active"><a href="#sale"><span>지금<br>할인중</span></a></li>
			<li><a href="#thanksgiving"><span>추석 선물</span></a></li>
			<li><a href="#hot"><span>방금<br>판매된</span></a></li>
			<li><a href="#benefit"><span>혜택</span></a></li>
		</ul>
	</nav>

	<!-- 지금 할인중 -->
	<section class="section section-sale" id="sale">
		<h3 class="ttl">지금 할인 중인<br>상품을 만나보세요!</h3>
		<div class="items-list">
			<ul id="lyr_saleitemList"></ul>
			<div id="sLoading" style="position:relative;text-align:center;margin:10px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
			<button type="button" id="btn_sMore" class="btn-more" onclick="expandList('sale');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/btn_more.png" alt="더보기"></button>
		</div>
	</section>

	<!-- 추석 선물 -->
	<section class="section section-thgv" id="thanksgiving">
		<h3 class="ttl">추석선물 고민하지 말고<br>여기서 골라보세요!</h3>
		<div class="items-list">
			<ul id="lyr_giftitemList"></ul>
			<div id="gLoading" style="position:relative;text-align:center;margin:10px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
			<button type="button" id="btn_gMore" class="btn-more" onclick="expandList('gift');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/btn_more.png" alt="더보기"></button>
		</div>
	</section>

	<!-- 방금 판매된 -->
	<section class="section section-hot" id="hot">
		<h3 class="ttl">방금<br>판매되었어요!</h3>
		<div class="items-list">
			<ul id="lyr_justitemList"></ul>
			<div id="jLoading" style="position:relative;text-align:center;margin:10px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
			<button type="button" id="btn_jMore" class="btn-more" onclick="expandList('just');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/btn_more.png" alt="더보기"></button>
		</div>
	</section>

	<!-- 혜택 -->
	<section class="section section-bnf" id="benefit">
		<h3 class="ttl">지금 누려보세요!<br>혜택과 함께 더 즐거운 쇼핑</h3>
		<ul class="bnf-lst">
			<li>
				<a href="/event/eventmain.asp?eventid=105500" target="_blank" class="mWeb">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/bn_1.png" alt="장바구니 이벤트">
				</a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105500');" target="_blank" class="mApp">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/bn_1.png" alt="장바구니 이벤트">
				</a>
			</li>
			<li>
				<a href="http://m.10x10.co.kr/event/benefit/index.asp" target="_blank" class="mWeb">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/bn_2.png" alt="APP 쿠폰 5천원 할인">
				</a>
				<a href="" onclick="fnAPPpopupBrowserURL('혜택 가이드','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/index.asp');" target="_blank" class="mApp">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/bn_2.png" alt="APP 쿠폰 5천원 할인">
				</a>
			</li>
			<li>
				<img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/bn_3.png" alt="차이 첫 결제 50% 할인">
			</li>
			<li>
				<a href="/event/eventmain.asp?eventid=105034" target="_blank" class="mWeb">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/bn_4.png" alt="토스 이벤트">
				</a>
				<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105034');" target="_blank" class="mApp">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/105514/m/bn_4.png" alt="토스 이벤트">
				</a>
			</li>
		</ul>
	</section>
</div>
<script>
$(function(){
	var didScroll;
	var lastScrollTop = 0;
	var delta = 5;
	var hdH = $('.header-main').outerHeight(),
		gnbH = $('.nav-gnb').outerHeight(),
		tabTop = $('.tab-wrap').offset().top,
		tabH = $('.tab-list').outerHeight();
	$(window).on('scroll', function() {
		if ($("body").hasClass("body-main")) {
			didScroll = true;
		} else {
			controlTabSub();
		}
	});
	setInterval(function() {
		if (didScroll) {
			hasScrolled();
			didScroll = false;
		}
	}, 250);
	// main
	function hasScrolled() {
		var st = $(window).scrollTop();
		if (Math.abs(lastScrollTop - st) <= delta)
			return;
		if (st > lastScrollTop) {
			if (st+gnbH > tabTop) {
				$('.tab-list').removeClass('tab-down').addClass('tab-up');
				controlTabActive(st+gnbH+tabH);
			} else {
				$('.tab-list').attr('class', 'tab-list');
			}
		} else {
			if (st + $(window).height() < $(document).height()) {
				if (st+hdH > tabTop) {
					$('.tab-list').removeClass('tab-up').addClass('tab-down');
					controlTabActive(st+hdH+tabH);
				} else {
					$('.tab-list').attr('class', 'tab-list');
				}
			}
		}
		lastScrollTop = st;
	}
	// sub
	function controlTabSub() {
		var st = $(window).scrollTop();
		if (st > tabTop) {
			$('.tab-list').css('position', 'fixed');
			controlTabActive(st+tabH);
		} else {
			$('.tab-list').css('position', 'absolute');
		}
	}
	// common
	function controlTabActive(st) {
		var current = 0;
		$('.section').each(function(i, el) {
			var max = $('.section').length-1;
			if (st >= $(el).offset().top) {
				if (i < max && st < $('.section').eq(i+1).offset().top) {
					current = i;
				} else {
					current = max;
				}
			}
		});
		$('.tab-list li.active').removeClass('active');
		$('.tab-list li').eq(current).addClass('active');
	}
	$('.tab-list a').on('click', function(e) {
		e.preventDefault();
		var target;
		if ($("body").hasClass("body-main")) {
			target = $(this.hash).offset().top-tabH-gnbH;
		} else {
			target = $(this.hash).offset().top-tabH;
		}
		$('html, body').animate({scrollTop: target+10}, 0);
	});

	//init
	getSaleItemList("sale");
	getSaleItemList("gift");
	getSaleItemList("just");
});

//sale item List
function getSaleItemList(gubun) {
	var lyr, btn, ild, url
	switch (gubun) {
		case "sale":
			url = "/event/etc/act_105514_saleItem.asp";
			lyr = "#lyr_saleitemList";
			btn = "#btn_sMore";
			ild = "#sLoading";
			break;
		case "gift":
			url = "/event/etc/act_105514_saleItem.asp";
			lyr = "#lyr_giftitemList";
			btn = "#btn_gMore";
			ild = "#gLoading";
			break;
		case "just":
			url = "/event/sale2020/act_justsold_105514.asp";
			lyr = "#lyr_justitemList";
			btn = "#btn_jMore";
			ild = "#jLoading";
			break;
		default:
			break;
	}

	$.ajax({
		url: url,
		data: "gb="+gubun,
		cache: false,
		beforeSend: function() {
			$(ild).show();
		},
		success: function(message) {
			if(message!="") {
				$(ild).hide();
				$(lyr).append(message);
				$(lyr+" li").slice(0,10).show();
			} else {
				$(ild).hide();
				$(btn).hide();
			}
		}
		,error: function(err) {
			console.error(err.responseText);
		}
	});
}

function expandList(gubun) {
	switch (gubun) {
		case "sale":
			$("#lyr_saleitemList li").not(":visible").slice(0,16).fadeIn("fast");
			if($("#lyr_saleitemList li").length==$("#lyr_saleitemList li:visible").length) {
				$("#btn_sMore").hide();
			}
			break;
		case "gift":
			$("#lyr_giftitemList li").not(":visible").slice(0,16).fadeIn("fast");
			if($("#lyr_giftitemList li").length==$("#lyr_giftitemList li:visible").length) {
				$("#btn_gMore").hide();
			}
			break;
		case "just":
			$("#lyr_justitemList li").not(":visible").slice(0,16).fadeIn("fast");
			if($("#lyr_justitemList li").length==$("#lyr_justitemList li:visible").length) {
				$("#btn_jMore").hide();
			}
			break;
		default:
			break;
	}
}
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->