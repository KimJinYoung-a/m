<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2020 팬스티벌 
' History : 2020-06-04 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "102178"
Else
	eCode = "103142"
End If
%>
<style>
.fan2020 {background-color:#fff;}
.fan2020 .top-vod h2 {display:none;}
.fan2020 .top-vod video {width:100vw; height:140vw;}
.fan2020 .today {width:28.45rem; margin:2.35rem auto 3.75rem;}
.fan2020 .today a {display:flex; justify-content:space-between; align-items:center; position:relative;}
.fan2020 .today a:before {display:inline-block; position:absolute; bottom:0; left:0; width:78.6%; height:.34rem; background-color:#e4e4e4; content:'';}
.fan2020 .today .desc {display:flex; flex-direction:column; justify-content:space-between; height:11.5rem;}
.fan2020 .today h3 {width:12.89rem;}
.fan2020 .today .name {overflow:hidden; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; text-overflow:ellipsis; word-break:keep-all; width:12.22rem; margin-top:1rem; font-size:1.19rem; line-height:1.3; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; text-align:right;}
.fan2020 .today .price {position:relative; width:12.22rem; padding-top:1.41rem; margin-bottom:.7rem; font-size:1.71rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'; text-align:right; letter-spacing:-.08rem;}
.fan2020 .today .price s {margin-right:.3rem; color:#aeaeae; font-style:italic; font-size:1.28rem; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight';}
.fan2020 .today .price span {position:absolute; top:0; right:0; font-size:1.02rem; color:#ff4b4b;}
.fan2020 .today .thumbnail {overflow:hidden; width:12.8rem; height:12.8rem; border-radius:50%; border:solid .34rem #e4e4e4;}

.fan2020 .nav-fan {width:100%; background-color:#fff;}
.fan2020 .nav-fan ul {display:flex; background-color:#fff;}
.fan2020 .nav-fan li {width:25%; border:none; font-size:1.19rem; color:#a6a6a6; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.fan2020 .nav-fan li.on {border-bottom:solid .26rem #18a6ff; color:#18a6ff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.fan2020 .nav-fan li a {display:inline-block; width:100%; height:100%;}
.fan2020 .nav-fan li .ico {display:block; height:2.77rem;}
.fan2020 .nav-fan li .ico img {height:100%; width:auto;}
.fan2020 .nav-fan li span {display:inline-block; margin-top:1.29rem; margin-bottom:.84rem; }

.fan2020 .nav-fan.fixed {position:fixed; top:-4.78rem; left:0; z-index:10; transition:top 0.2s ease-in-out;}
.fan2020 .nav-fan.nav-down, .fan2020 .nav-fan.nav-up {padding-top:9.22rem;}
.fan2020 .nav-fan.nav-down {top:0;}
.fan2020 .nav-fan.fixed li .ico {display:none;}

.body-sub .fan2020 .nav-fan.nav-down, .body-sub .fan2020 .nav-fan.nav-up {padding-top:0;}
.body-sub .fan2020 .nav-fan.fixed {top:0;}

.section-top {padding:2.26rem 0; background-color:#e4f7ff; text-align:center;}
.section-top h3 {font-size:1.96rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.section-top > p {margin-top:1.19rem; font-size:1.19rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}

.fan2020 .nav-sub ul {margin:1.71rem auto 0; font-size:0;}
.fan2020 .nav-sub ul li {display:inline-block; margin:0 .35rem;}
.fan2020 .nav-sub ul li a {display:inline-block; padding:0 .85rem; height:1.96rem; border:solid .09rem #a5a5a5; border-radius:.85rem; background-color:#fff; color:#a6a6a6; font-size:1.19rem; line-height:1.8;font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.fan2020 .nav-sub ul li.on a {border-color:#18a6ff; color:#18a6ff;}

.fan2020 .items {margin-top:.86rem; margin-bottom:4.27rem; border-top:none;}
.fan2020 .items ul {padding:0 .85rem; margin-bottom:1.71rem;}
.fan2020 .items .thumbnail {width:14.29rem; height:14.29rem; border-radius:.68rem;}
.fan2020 .items .badge {display:inline-block; position:absolute; top:.94rem; left:.94rem; z-index:4; width:2.4rem; height:2.4rem; border:solid .17rem #3db8ec; border-radius:50%; background-color:#b9eaff; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.1rem; line-height:2.3rem; text-align:center;}
.fan2020 .items .badge-time {width:unset; padding:0 .7rem; border-radius:2.2rem; line-height:2.4rem;}
.fan2020 .items .desc {height:9.32rem; margin:0; padding-top:0.98rem;}
.fan2020 .items .desc .name {height:3.22rem; margin:.5rem .2rem; font-size:1.15rem; line-height:1.4;}
.fan2020 .items .desc .price {margin-top:0;}
.fan2020 .items .desc .won {display:none;}
.fan2020 .items .desc .brand {font-size:.94rem;}
.fan2020 .items .etc {bottom:.2rem;}

.fan2020 .section-func .items .desc .price, .fan2020 .items .price b {font-size:1.37rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.fan2020 .section-func .items .desc .price s {display:none;}
.fan2020 .section-func .items .desc .price span, .fan2020 .items .price .discount {color:#ff2b74; font-size:1.15rem; margin-left:.4rem; font-family:'CoreSansCMedium';}
.fan2020 .section-func .items .desc .price .coupon, .fan2020 .items .price .color-green {color:#00cfcb;}

.fan2020 .section-yt .section-top {padding:3.62rem 0;}
.fan2020 .section-yt .vod-wrap {padding:0 1.28rem 4.27rem;}
.fan2020 .section-yt .vod {width:100%; height:0; padding-bottom:56.07%;}
.fan2020 .section-yt .yt2 {background-color:#eef2ff;}

.fan2020 .btn-more {display:block; width:23rem; height:2.97rem; margin:0 auto; color:#111111; font-size:1.15rem; line-height:3.2rem; text-align:center; border-radius:2.97rem; border:1px solid #cbcbcb; background-color:transparent;}
.fan2020 .btn-more:after {content:''; display:inline-block; width:10px; height:16px; margin-left:7px; transform:rotate(90deg); vertical-align:-5px; background:url(//fiximage.10x10.co.kr/m/2019/diary2020/ico.svg) -100px 0;}

.fan-brand {position:relative;}
.fan-brand ul {display:flex; flex-wrap:wrap; position:absolute; bottom:6%; left:0; width:100%; height:75%;}
.fan-brand ul li {width:33.33%; height:50%;}
.fan-brand ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
</style>
<%
	Dim today_code, currentDate
	currentDate = date()
	'currentDate = "2020-06-15"
	today_code = "2955051"

	if currentdate = "2020-06-09" Then
		today_code = "2922292"
	ElseIf currentdate = "2020-06-10" Then
		today_code = "2928972"
	ElseIf currentdate = "2020-06-11" Then
		today_code = "2930481"
	ElseIf currentdate >= "2020-06-12" AND currentdate <= "2020-06-14" Then
		today_code = "2930529"
	ElseIf currentdate >= "2020-06-15" AND currentdate <= "2020-06-16" Then
		today_code = "2936675"
	ElseIf currentdate = "2020-06-17" Then
		today_code = "2941119"
	ElseIf currentdate = "2020-06-18" Then
		today_code = "2941101"
	ElseIf currentdate >= "2020-06-19" AND currentdate <= "2020-06-21" Then
		today_code = "2930529"
	ElseIf currentdate = "2020-06-22" Then
		today_code = "2954995"
	ElseIf currentdate = "2020-06-23" Then
		today_code = "2955047"
	ElseIf currentdate = "2020-06-24" Then
		today_code = "2955048"
	ElseIf currentdate = "2020-06-25" Then
		today_code = "2955051"
	ElseIf currentdate = "2020-06-26" AND currentdate <= "2020-06-28" Then
		today_code = "2955062"
	ElseIf currentdate = "2020-06-29" Then
		today_code = "2954995"
	ElseIf currentdate = "2020-06-30" Then
		today_code = "2955047"
	ElseIf currentdate = "2020-07-01" Then
		today_code = "2955048"
	ElseIf currentdate = "2020-07-02" Then
		today_code = "2955051"
	ElseIf currentdate = "2020-07-03" AND currentdate <= "2020-07-05" Then
		today_code = "2955062"
	ElseIf currentdate = "2020-07-06" Then
		today_code = "2954995"
	ElseIf currentdate = "2020-07-07" Then
		today_code = "2955047"
	ElseIf currentdate = "2020-07-08" Then
		today_code = "2955048"
	ElseIf currentdate = "2020-07-09" Then
		today_code = "2955051"
	ElseIf currentdate = "2020-07-10" AND currentdate <= "2020-07-12" Then
		today_code = "2955062"
	ElseIf currentdate = "2020-07-13" Then
		today_code = "2954995"
	ElseIf currentdate = "2020-07-14" Then
		today_code = "2955047"
	ElseIf currentdate = "2020-07-15" Then
		today_code = "2955048"
	ElseIf currentdate = "2020-07-16" Then
		today_code = "2955051"
	ElseIf currentdate = "2020-07-17" AND currentdate <= "2020-07-19" Then
		today_code = "2955062"
	ElseIf currentdate = "2020-07-20" Then
		today_code = "2954995"
	ElseIf currentdate = "2020-07-21" Then
		today_code = "2955047"
	ElseIf currentdate = "2020-07-22" Then
		today_code = "2955048"
	ElseIf currentdate = "2020-07-23" Then
		today_code = "2955051"
	ElseIf currentdate = "2020-07-24" AND currentdate <= "2020-07-26" Then
		today_code = "2955062"
	ElseIf currentdate = "2020-07-27" Then
		today_code = "2954995"
	ElseIf currentdate = "2020-07-28" Then
		today_code = "2955047"
	ElseIf currentdate = "2020-07-29" Then
		today_code = "2955048"
	ElseIf currentdate = "2020-07-30" Then
		today_code = "2955051"
	ElseIf currentdate = "2020-07-31" AND currentdate <= "2020-08-02" Then
		today_code = "2955062"
	End If
%>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function () {
	// today item info
	fnApplyItemInfoEach({
		items:<%=today_code%>,
		target:"item",
		fields:["image","name","price","sale"],
		unit:"hw",
		saleBracket:false
	});

	// section-func items
	funcFans = [
		{codeList: [2933363,2878525,2878662,2932416,2943925,2944212,2967365,2366122,1954882,2878664,2895696,2886311]},
		{codeList: [2975756,2904884,2928938,2353564,1702345,2913317,2901678,2360383,2359618,2372348,2791616,2916033]},
		{codeList: [2923535,2920325,2896990,2865619,2901865,2901657,2981631,1934911,2956806,2380063,2400866,2890418]}
	]
	$.each(funcFans, function (i, item) {
		var codeGrp = funcFans[i].codeList
		var itemList = "itemList" + (i+1)
		var $rootEl = $("#" + itemList)
		var itemEle = tmpEl = ""
		$rootEl.empty();

		codeGrp.forEach(function(item){
			tmpEl = '<li>\
						<a href="" onclick="goProduct('+item+');return false;">\
							<div class="thumbnail"><img src="" alt=""></div>\
							<div class="desc">\
								<div class="price"><s>원가</s> 판매가<span class="sale">할인율</span> <span class="coupon">쿠폰할인율</span></div>\
								<p class="name">상품명</p>\
								<p class="brand">brandname</p> \
							</div>\
							<div class="etc">\
								<div class="tag review"><span class="icon icon-rating"><i style="width:100%;"></i></span><span class="counting" title="리뷰 개수">999+</span></div>\
							</div>\
						</a>\
					</li>\
					'
			itemEle += tmpEl
		});
		$rootEl.append(itemEle)
	
		fnApplyItemInfoList({
			items:codeGrp,
			target:itemList,
			fields:["image","name","price","salecoupon","brand","evaluate"],
			unit:"none",
			saleBracket:false
		});
	});

	// section-func button.more-item
	$('.section-func ul li:nth-child(7),.section-func ul li:nth-child(8),.section-func ul li:nth-child(9),.section-func ul li:nth-child(10),.section-func ul li:nth-child(11),.section-func ul li:nth-child(12)').addClass('hide');
	$('.btn-more').click(function (e) { 
		e.preventDefault();
		if($(this).parent().parent().hasClass('section-sold')){
			return false;
		} else {
			$(this).hide().siblings('ul').children('li').removeClass('hide');
		}
	});

	// sub-tab
	$(".sub-cont").hide();
	$('#smallFan').show();
	$(".section-func .nav-sub li a").click(function(){
		$(this).parents('li').addClass('on').siblings("li").removeClass("on");
		var thisCont = $(this).attr("href");
		$(".sub-cont").hide();
		$(thisCont).show();
		return false;
	});

	fnSearchPriceItems(1);
	fnJustSoldItems();
});
function goProduct(itemid) {
	<% if isApp then %>
		parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

$(function() {
    // common var
    var nav = $(".nav-fan"),
		navY = nav.offset().top,
        navH = nav.outerHeight(),
		gnbH = $(".nav-gnb").outerHeight();
		
	// fixed nav
	var contWrap = $('#sectionYt');
	$(window).on('scroll', function () {
		var st = $(this).scrollTop();
		if(st > navY) {
			nav.addClass("fixed");
			navH = nav.outerHeight();
			contWrap.css("margin-top", navH);
		} else {
			nav.removeClass("fixed");
			contWrap.css("margin-top", 0);
		}        
	});

	// detect scroll direction
    var prevScrollTop = $(window).scrollTop(),
        nowScrollTop = $(window).scrollTop();
    $(window).on('scroll touchmove', function () {
        nowScrollTop = $(window).scrollTop();
        if(nav.hasClass('fixed')){
            if (nowScrollTop > prevScrollTop) {
                // scroll down
                nav.removeClass("nav-down").addClass("nav-up");
            } else if (nowScrollTop < prevScrollTop) {
                // scrollup
                nav.removeClass("nav-up").addClass("nav-down");
            }
            prevScrollTop = nowScrollTop;
        } else {
            nav.removeClass("nav-up nav-down");
        }
    });

    // click nav
    $('.nav-fan a[href*=#]').bind('click', function(e) {
        e.preventDefault();
        var target = $(this).attr("href"),
            targetY = $(target).offset().top;
        $('html, body').stop().animate({scrollTop: targetY}, 600,
        function() {location.hash = target});
        return false;
    });

    // scrolling nav 
    $(window).scroll(function() {
        var scrollTop = $(window).scrollTop();
        $('.section-fan').each(function(i) {
            if ($(this).position().top <= scrollTop) {
                $('.nav-fan li.on').removeClass('on');
                $('.nav-fan li').eq(i).addClass('on');
            }
        });
    }).scroll();
});

function fnSearchPriceItems(v) {
	$(event.target).parents('li').addClass('on').siblings("li").removeClass("on");
	
	var dataUrl = "";
	switch (v) {
		case 1:
			dataUrl = "/event/lib/act_searchitem.asp?search_on=on&rect=%ED%9C%B4%EB%8C%80%EC%9A%A9%EC%84%A0%ED%92%8D%EA%B8%B0&sflag=n&cpg=1&chkr=False&chke=False&sscp=N&psz=12&srm=bs&minPrc=690&maxPrc=9990&lstDiv=search&listoption=all&prevmode=L"
			break;
		case 2 :
			dataUrl = "/event/lib/act_searchitem.asp?search_on=on&rect=%ED%9C%B4%EB%8C%80%EC%9A%A9%EC%84%A0%ED%92%8D%EA%B8%B0&sflag=n&cpg=1&chkr=False&chke=False&sscp=N&psz=12&srm=bs&minPrc=10000&maxPrc=19990&lstDiv=search&listoption=all&prevmode=L"
			break;
		case 3 :
			dataUrl = "/event/lib/act_searchitem.asp?search_on=on&rect=%ED%9C%B4%EB%8C%80%EC%9A%A9%EC%84%A0%ED%92%8D%EA%B8%B0&sflag=n&cpg=1&chkr=False&chke=False&sscp=N&psz=12&srm=bs&minPrc=20000&maxPrc=29990&lstDiv=search&listoption=all&prevmode=L"
			break;
		case 4 :
			dataUrl = "/event/lib/act_searchitem.asp?search_on=on&rect=%ED%9C%B4%EB%8C%80%EC%9A%A9%EC%84%A0%ED%92%8D%EA%B8%B0&sflag=n&cpg=1&chkr=False&chke=False&sscp=N&psz=12&srm=bs&minPrc=30000&maxPrc=99990&lstDiv=search&listoption=all&prevmode=L"
			break;
		default :
			dataUrl = ""
			break;
	}
	
	$.ajax({
		url: dataUrl,
		cache: false,
		success: function(message) {
			if(message!="") {
				$("#dataList").empty().append(message);
			} 
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

var cpg = 0;
function fnJustSoldItems() {
	cpg++;   

	$.ajax({
		url: '/event/lib/act_justsoldcategory.asp?cpg='+cpg,
		cache: false,
		success: function(message) {
			if(message!="") {
				$("#justsold").append(message);
			} 
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}
</script>
<% if isApp then %>
<div class="mEvt103142 fan2020 app">	
<% else %>
<div class="mEvt103142 fan2020">
<% end if %>
	<div class="top-vod">
		<h2>2020팬스티벌</h2>
		<video preload="auto" autoplay="true" muted="muted" volume="0" playsinline="" poster="http://webimage.10x10.co.kr/video/vid982.jpg">
			<source src="//webimage.10x10.co.kr/video/vid982.mp4" type="video/mp4">
		</video>
	</div>

	<%'!-- 오늘의 특가 --%>
	<div class="today">
		<a href="" onclick="goProduct(<%=today_code%>);return false;" class="item<%=today_code%>">
			<div class="desc">
				<h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/tit_price.png" alt="오늘만 이 가격"></h3>
				<p class="name">상품명</p>
				<div class="price"><s>정가</s> 할인가<span>할인율%</span></div>
			</div>
			<div class="thumbnail"><img src="" alt=""></div>
		</a>
	</div>
	
	<div class="fan-cont">
		<%'!-- 탭 --%>
		<div class="nav-fan">
			<ul>
				<li class="nav-youtube on">
					<a href="#sectionYt">
						<i class="ico"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/ico_yt1.png" alt=""></i>
						<span>유튜버 Pick</span>
					</a>
				</li>
				<li class="nav-func">
					<a href="#sectionFunc">
						<i class="ico"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/ico_func.png" alt=""></i>
						<span>기능</span>
					</a>
				</li>
				<li class="nav-price">
					<a href="#sectionPrice">
						<i class="ico"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/ico_price.png" alt=""></i>
						<span>가격</span>
					</a>
				</li>
				<li class="nav-sold">
					<a href="#sectionSold">
						<i class="ico"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/ico_sold.png" alt=""></i>
						<span>방금 판매된</span>
					</a>
				</li>
			</ul>
		</div>

		<%'!-- 유튜브 --%>
		<div class="section-fan section-yt" id="sectionYt">
			<div class="section-top">
				<h3>유튜버 Pick</h3>
				<p>유튜버가 추천하는 다양한 휴대용선풍기! 지금 바로 구경하자!</p>
			</div>														
			<div class="yt yt1">
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/img_yt1.jpg" alt=""></p>
				<div class="vod-wrap">
					<div class="vod">
						<iframe src="https://www.youtube.com/embed/jYxGy6XeGI8" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen="true"></iframe>
					</div>
				</div>
			</div>
			<div class="yt yt2">
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/img_yt2.jpg" alt=""></p>
				<div class="vod-wrap">
					<div class="vod">
						<iframe src="https://www.youtube.com/embed/HN9tD0Jwwdw" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen="true"></iframe>
					</div>
				</div>
			</div>
			<div class="yt yt3">
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/img_yt3.jpg" alt=""></p>
				<div class="vod-wrap">
					<div class="vod">
						<iframe src="https://www.youtube.com/embed/Q7ZR4oqmDVE" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen="true"></iframe>
					</div>
				</div>
			</div>				
		</div>

		<%'!-- 기능 (퍼블) --%>
		<div class="section-fan section-func" id="sectionFunc">
			<div class="section-top">
				<h3>기 능</h3>
				<p>내게 꼭 필요한 기능이 있는 휴대용 선풍기 찾아보기!</p>
				<div class="nav-sub">
					<ul>
						<li class="on"><a href="#smallFan">#초소형</a></li>
						<li><a href="#silencFan">#저소음</a></li>
						<li><a href="#multiFan">#다기능</a></li>
					</ul>
				</div>
			</div>
			<div class="items type-grid sub-cont" id="smallFan">
				<ul id ="itemList1"></ul>
				<button class="btn-more">더 많은 상품보기</button>
			</div>						
			<div class="items type-grid sub-cont" id="silencFan">
				<ul id ="itemList2"></ul>
				<button class="btn-more">더 많은 상품보기</button>
			</div>					
			<div class="items type-grid sub-cont" id="multiFan">
				<ul id ="itemList3"></ul>
				<button class="btn-more">더 많은 상품보기</button>
			</div>					
		</div>
		
		<%'!-- 가격 --%>
		<div class="section-fan section-price" id="sectionPrice">
			<div class="section-top">
				<h3>가 격</h3>
				<p>금액대별 휴대용 선풍기 똑~소리 나게 확인하자!</p>
				<div class="nav-sub">
					<ul>
						<li class="on"><a href="" onclick="fnSearchPriceItems(1);return false;">#1만원이하</a></li>
						<li><a href="" onclick="fnSearchPriceItems(2);return false;">#1만원대</a></li>
						<li><a href="" onclick="fnSearchPriceItems(3);return false;">#2만원대</a></li>
						<li><a href="" onclick="fnSearchPriceItems(4);return false;">#3만원이상</a></li>
					</ul>
				</div>
			</div>								
			<div class="items type-grid" id="dataList"></div>
		</div>

		<%'!-- 방금 판매된 -- // 더보기 + 6 계속 증가 %>
		<div class="section-fan section-sold" id="sectionSold">
			<div class="section-top">
				<h3>방금 판매된</h3>
				<p>방금 판매된 휴대용 선풍기를 확인해보세요!</p>
			</div>							
			<div class="items type-grid">
				<ul id="justsold"></ul>
				<button class="btn-more" onclick="fnJustSoldItems();">더 많은 상품보기</button>
			</div>
		</div>
	</div>

	<%'!-- 브랜드 --%>
	<div class="fan-brand">
		<img src="//webimage.10x10.co.kr/fixevent/event/2020/103142/m/img_brand.jpg" alt="brand">
		<ul class="mWeb">
			<li><a href="/street/street_brand.asp?makerid=n9&ab=012_a_1">루메나</a></li>
			<li><a href="/street/street_brand.asp?makerid=printec&ab=012_a_1">단순생활</a></li>
			<li><a href="/street/street_brand.asp?makerid=simida170417&ab=012_a_1">스미다</a></li>
			<li><a href="/street/street_brand.asp?makerid=kakaofriends1010">카카오프렌즈</a></li>
			<li><a href="/street/street_brand.asp?makerid=coolean24&ab=012_a_1">쿨린</a></li>
			<li><a href="/street/street_brand.asp?makerid=atoz01&ab=012_a_1">아이리버</a></li>
		</ul>
		<ul class="mApp">
			<li><a href="" onclick="fnAPPpopupBrand('n9'); return false;">루메나</a></li>
			<li><a href="" onclick="fnAPPpopupBrand('printec'); return false;">단순생활</a></li>
			<li><a href="" onclick="fnAPPpopupBrand('simida170417'); return false;">스미다</a></li>
			<li><a href="" onclick="fnAPPpopupBrand('kakaofriends1010'); return false;">카카오프렌즈</a></li>
			<li><a href="" onclick="fnAPPpopupBrand('coolean24'); return false;">쿨린</a></li>
			<li><a href="" onclick="fnAPPpopupBrand('atoz01'); return false;">아이리버</a></li>
		</ul>
	</div>
</div>