<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 양/우산 패스티벌
' History : 2020-06-30 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , eventStartDate , eventEndDate
dim bonuscountcount : bonuscountcount = 0
dim bonusCouponNumber 
IF application("Svr_Info") = "Dev" THEN
	eCode = "102188"
    bonusCouponNumber = "2957"
Else
	eCode = "103915"
    bonusCouponNumber = "1762"
End If

eventStartDate = cdate("2021-07-27")	'이벤트 시작일
eventEndDate = cdate("2021-08-31")		'이벤트 종료일
currentDate = date()
'currentDate = "2020-08-04"

userid = GetEncLoginUserID()

if IsUserLoginOK() then 
    bonuscountcount = getbonuscouponexistscount(userid, bonusCouponNumber, "", "", "")
end if 

%>
<style>
.parasol2020 {background-color:#fff;}
.parasol2020 button {background-color:transparent;}
.parasol2020 .btn-more {display:block; width:56%; height:3.84rem; margin:0 auto; border:solid 0.13rem #000; border-radius:1.71rem; font-size:1.28rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.parasol2020 .topic {background-color:#54ff98;} /* 2021-07-28 수정 */

.parasol2020 .nav-evt {display:flex; margin-left:1.28rem; border-bottom:solid .3rem #efefef;}
.parasol2020 .nav-evt li {position:relative; bottom:-.3rem; margin-right:1.79rem; padding-top:.55rem; padding-bottom:.55rem;}
.parasol2020 .nav-evt li.on {border-bottom:solid .3rem #fd55bc;}
.parasol2020 .nav-evt li a {display:flex; justify-content:center; align-items:center; width:100%; height:100%; color:#999; font-size:1.37rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.parasol2020 .nav-evt li.on a {color:#000; font-size:1.79rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}

.parasol2020 .cont-parasol {padding-bottom:5.12rem;}

.coupon-section .btn-cpn {width:100%; height:100%;}

.cont-parasol h3 {padding:0 1.28rem; margin:1.54rem 0; font-size:1.37rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.cont-parasol h3:before {display:inline-block; width:.3rem; height:.3rem; margin-right:.6rem; border-radius:50%; background-color:#fd55bc; vertical-align:middle; content:'';}

.cont-story .story-slide {position:relative; overflow:hidden; height:51.2rem;}
.cont-story .story-slide .swiper-slide {height:100%;}
.cont-story .story-slide .pagination {overflow:hidden; display:block; position:absolute; bottom:0; left:0; z-index:10; width:100%; height:0.55rem; padding:0; background:#e2f8e7;}
.cont-story .story-slide .pagination-fill {position:absolute; left:0; top:0; width:100%; height:100%; background-color: #73ff94; -webkit-transform:scaleX(0); -ms-transform:scaleX(0); transform:scaleX(0); -webkit-transform-origin:left top; -ms-transform-origin:left top; border-bottom-left-radius: .7rem; transform-origin:left top; transition-duration:300ms;}
.cont-story .staff-review .txt {overflow:hidden; position:relative; width:100%; height:0; padding-bottom:145%;}
.cont-story .staff-review .txt.on {height:auto; padding-bottom:0;}
.cont-story .staff-review .txt.on + .btn-more {display:none;}
.cont-story .staff-review .txt .staff-pick {position:absolute; bottom:0; left:0; width:100%; height:100%;}
.cont-story .staff-review .txt .staff-pick li {height:100%;}
.cont-story .staff-review .txt .staff-pick li a {display:block; width:100%; height:100%; color:transparent;}
.cont-story .staff-review .txt.on .staff-pick li {height:16.67%; width:100%;}
.cont-story .staff-review .btn-more {margin-top:2.35rem;}

.cont-theme .parasol-theme li {margin-bottom:1.07rem;}
.cont-theme .parasol-theme li:nth-child(6),
.cont-theme .parasol-theme li:nth-child(7),
.cont-theme .parasol-theme li:nth-child(8) {display:none;}
.cont-theme .parasol-theme li:last-child {margin-bottom:0;}
.cont-theme .parasol-theme li a {display:block; width:100%; height:100%;}
.cont-theme .btn-more {margin-top:2.35rem;}

.cont-best .sort {display:flex; justify-content:flex-end; margin-right:1.28rem; margin-top:.43rem;}
.cont-best .sort li {margin-left:.85rem;}
.cont-best .sort li button {font-size:1.28rem; color:#666;}
.cont-best .sort li.on button {color:#222; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.cont-best .sort li.on button {border-bottom:solid .17rem #1eff8d;}
.cont-best .items {margin-top:.86rem; border-top:none;}
.cont-best .items ul {padding:0 .85rem; margin-bottom:1.71rem;}
.cont-best .items .thumbnail {width:14.29rem; height:14.29rem; border-radius:.68rem;}
.cont-best .items .badge {display:inline-block; position:absolute; top:.94rem; left:.94rem; z-index:4; width:2.4rem; height:2.4rem; border:solid .17rem #3db8ec; border-radius:50%; background-color:#b9eaff; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; font-size:1.1rem; line-height:2.3rem; text-align:center;}
.cont-best .items .badge-time {width:unset; padding:0 .7rem; border-radius:2.2rem; line-height:2.4rem;}
.cont-best .items .desc {height:7.32rem; margin:0; padding-top:0.98rem;}
.cont-best .items .desc .name {height:3.22rem; margin:.5rem .2rem; font-size:1.15rem; line-height:1.4;}
.cont-best .items .desc .price {margin-top:0;}
.cont-best .items .desc .price b {font-size:1.37rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.cont-best .items .desc .price .discount {color:#ff2b74; font-size:1.15rem; margin-left:.4rem; font-family:'CoreSansCMedium';}
.cont-best .items .desc .price .color-green {color:#00cfcb;}
.cont-best .items .desc .won {display:none;}
.cont-best .items .desc .brand {font-size:.94rem;}
.cont-best .items .etc {bottom:.2rem;}

.cont-benefit .benefit-list li {margin-bottom:1.02rem;}
.cont-benefit .benefit-list li a {display:block; height:100%;}
</style>
<script>
$(function(){
    // click nav
    $('.nav-evt a[href*=#]').bind('click', function(e) {
        e.preventDefault();
        var target = $(this).attr("href"),
            targetY = $(target).offset().top;
        $('html, body').stop().animate({scrollTop: targetY}, 600);
    });
    
	// changing img
	(function changingImg(){
		var i=1;
		var repeat = setInterval(function(){
			i++;
			if(i>30){i=1;}
			$('.evt103915 .topic .parasol-thumb img').attr('src','//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_parasol'+ i +'.png');
		},260);
	})();

	// slide
	var $total = $('.story-slide').find(".swiper-slide").length;
	var $initScale = 1 / $total;
	var $progressFill = $('.story-slide').find(".pagination-fill");
	$progressFill.css("transform", "scaleX(" + $initScale + ")");
	$('.story-slide').swiper({
		autoplay:2400,
		loop:true,
		speed:500,
		effect:'fade',
		onSlideChangeStart: function (slideProgressbar) {
			var $current = slideProgressbar.activeIndex;
			if ($current == 0) {
				var $scale = 1;
			} else if ($current > $total) {
				var $scale = $initScale;
			} else {
				var $scale = $initScale * $current;
			}
			$progressFill.css("transform", "scaleX(" + $scale + ")");
		}
	});

	// btn more
	$('.cont-story .btn-more').click(function (e) { 
		e.preventDefault();
		$('.cont-story .txt').toggleClass('on');
		$(this).hide();
	});
	$('.cont-theme .btn-more').click(function (e) { 
		e.preventDefault();
		$('.cont-theme .parasol-theme li').show();
		$(this).hide();
	});

    // init
    fnAwardItems('d');
});

// 이벤트 이동
function goEventLink(evtid) {
	<% if isApp then %>
		fnAPPpopupBrowserURL('이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+evtid);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evtid;
	<% end if %>
	return false;
}

// 상품 링크 이동
function goProduct(itemid) {
	<% if isApp then %>
		parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

var cpg = 0;
var dgubun = "";
function fnAwardItems(datagubun) {
    $(event.target).parents('li').addClass('on').siblings("li").removeClass("on");
    if (datagubun != "") {
        dgubun = datagubun;
    }
    
    if (datagubun == "") {
        cpg++;
    } else {
        cpg = 1;
    }

	$.ajax({
		url: '/event/lib/cateawarditem.asp',
        data : {
            "cpg" : cpg,
            "disp" : 116110,
            "atype" : "dt",
            "dategubun" : dgubun,
        },
		cache: false,
		success: function(message) {
			if(message!="") {
                $(".btn-more").show();
                if (cpg == 1) {
                    $("#awardlist").empty().append(message);
                } else {
                    $("#awardlist").append(message);
                }
			} else {
                $(".btn-more").hide();
            }
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}

function fnDownCoupon(stype,idx){
    <% If IsUserLoginOK() Then %>
        var str = $.ajax({
            type: "POST",
            url: "/event/etc/coupon/couponshop_process.asp",
            data: "mode=cpok&stype="+stype+"&idx="+idx,
            dataType: "text",
            async: false
        }).responseText;
        var str1 = str.split("||")
        if (str1[0] == "11"){
            alert('쿠폰이 발급 되었습니다.\n7월 30일까지 사용하세요 :)');
            return false;
        }else if (str1[0] == "12"){
            alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
            return false;
        }else if (str1[0] == "13"){
            alert('이미 다운로드 받으셨습니다.');
            return false;
        }else if (str1[0] == "02"){
            alert('로그인 후 쿠폰을 받을 수 있습니다!');
            return false;
        }else if (str1[0] == "01"){
            alert('잘못된 접속입니다.');
            return false;
        }else if (str1[0] == "00"){
            alert('정상적인 경로가 아닙니다.');
            return false;
        }else{
            alert('오류가 발생했습니다.');
            return false;
        }
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<div class="evt103915 parasol2020">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/tit_parasol.png?v=2" alt="양산 대유행"></h2>
        <div class="parasol-thumb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_parasol1.png" alt=""></div>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/txt_sale.png?v=2" alt="8,000개의 양산 촤대 50% 할인"></p>
    </div>
								
    <div class="just-section">
        <% if currentdate = "2020-07-14" then %>
        <a href="" onclick="goProduct(2819537);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_just1.jpg" alt="just 1 day"></a>
        <% elseIf currentdate = "2020-07-16" then %>
        <a href="" onclick="goProduct(3017824);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_just2.jpg" alt="just 1 day 2차"></a>
        <% end If%>
    </div>

    <%'!-- for dev msg 쿠폰 다운 받은 후 숨김 --%>
    <% if bonuscountcount = 0 then %>
    <div class="coupon-section">
        <button class="btn-cpn" onclick="fnDownCoupon('evtsel','<%=bonusCouponNumber%>'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/btn_cp.jpg?v=2" alt="쿠폰다운 받기"></button>
    </div>
    <% end if %>
    <div class="cont-wrap">
    
        <%'!-- 스토리 --%>
        <div id="cont1" class="cont-parasol cont-story">
            <ul class="nav-evt">
                <li class="nav1 on"><a href="#cont1">스토리</a></li>
                <li class="nav2"><a href="#cont2">테마별</a></li>
                <li class="nav3"><a href="#cont3">베스트</a></li>
                <li class="nav4"><a href="#cont4">혜택</a></li>
            </ul>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/txt_topic.jpg?v=1.01" alt="Do you know 양산?"></p>
            <div class="story-slide">
                <div class="swiper-wrapper">
                    <div class="swiper-slide"><a href="" onclick="goProduct(2799855);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_slide1_1.jpg" alt="노랑"></a></div>
                    <div class="swiper-slide"><a href="" onclick="goProduct(2259271);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_slide1_2.jpg" alt="핑크"></a></div>
                    <div class="swiper-slide"><a href="" onclick="goProduct(2259271);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_slide1_3.jpg" alt="핑크"></a></div>
                    <div class="swiper-slide"><a href="" onclick="goProduct(2361918);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_slide1_4.jpg" alt="하늘"></a></div>
                    <div class="swiper-slide"><a href="" onclick="goProduct(2799855);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_slide1_5.jpg?v=1.01" alt="노랑"></a></div>
                    <div class="swiper-slide"><a href="" onclick="goProduct(2799855);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_slide1_6.jpg" alt="노랑"></a></div>
                    <div class="swiper-slide"><a href="" onclick="goProduct(1911206);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_slide1_7.jpg" alt="초록노랑"></a></div>
                </div>
                <div class="pagination"><span class="pagination-fill"></span></div>
            </div>
            <div class="staff-review">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/tit_reivew.jpg" alt="화.제.집.중 텐바이텐 Z세대가 말한다, 양산이 대세!"></p>
                <div class="txt">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/txt_review.jpg" alt="스태프 인터뷰">
                    <ul class="staff-pick">
                        <li><a href="" onclick="goProduct(2361918);return false;">혜림</a></li>
                        <li><a href="" onclick="goProduct(2819537);return false;">은비</a></li>
                        <li><a href="" onclick="goProduct(2259275);return false;">지혜</a></li>
                        <li><a href="" onclick="goProduct(2832775);return false;">원주</a></li>
                        <li><a href="" onclick="goProduct(1496942);return false;">별해</a></li>
                        <li><a href="" onclick="goProduct(2385631);return false;">지아</a></li>
                    </ul>
                </div>
                <button class="btn-more">더 보기 +</button>
            </div>
        </div>

        <%'!-- 테마별 --%>
        <div id="cont2" class="cont-parasol cont-theme">
            <ul class="nav-evt">
                <li class="nav1"><a href="#cont1">스토리</a></li>
                <li class="nav2 on"><a href="#cont2">테마별</a></li>
                <li class="nav3"><a href="#cont3">베스트</a></li>
                <li class="nav4"><a href="#cont4">혜택</a></li>
            </ul>
            <h3>센스있게 골라보자 나만의 양산!</h3>
            <% if currentdate = "2020-07-14" OR currentdate = "2020-07-16" OR currentdate = "2020-07-18" OR currentdate = "2020-07-20" OR currentdate = "2020-07-22" OR currentdate = "2020-07-24" OR currentdate = "2020-07-26" OR currentdate = "2020-07-28" OR currentdate = "2020-07-30"then %>
            <ul class="parasol-theme">
                <li><a href="" onclick="goEventLink(104045);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_4.jpg" alt="초경량 양산"></a></li>
                <li><a href="" onclick="goEventLink(104052);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_5.jpg" alt="디자인 양산"></a></li>
                <li><a href="" onclick="goEventLink(104042);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_1.jpg" alt="양우산"></a></li>
                <li><a href="" onclick="goEventLink(104043);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_2.jpg" alt="컬러별 양산"></a></li>
                <li><a href="" onclick="goEventLink(104044);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_3.jpg" alt="길다란 양산"></a></li>
                <li><a href="" onclick="goEventLink(103091);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_6.jpg" alt="장마 기획전"></a></li>
                <li><a href="" onclick="goEventLink(103142);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_7.jpg" alt="선풍기 모음전"></a></li>
                <li><a href="" onclick="goEventLink(103787);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_8.jpg" alt="여름 에코백"></a></li>
            </ul>
            <% Else %>
            <ul class="parasol-theme">
                <li><a href="" onclick="goEventLink(104042);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_1.jpg" alt="양우산"></a></li>
                <li><a href="" onclick="goEventLink(104043);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_2.jpg" alt="컬러별 양산"></a></li>
                <li><a href="" onclick="goEventLink(104044);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_3.jpg" alt="길다란 양산"></a></li>
                <li><a href="" onclick="goEventLink(104045);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_4.jpg" alt="초경량 양산"></a></li>
                <li><a href="" onclick="goEventLink(104052);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_5.jpg" alt="디자인 양산"></a></li>
                <li><a href="" onclick="goEventLink(103091);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_6.jpg" alt="장마 기획전"></a></li>
                <li><a href="" onclick="goEventLink(103142);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_7.jpg" alt="선풍기 모음전"></a></li>
                <li><a href="" onclick="goEventLink(103787);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/bnr_8.jpg" alt="여름 에코백"></a></li>
            </ul>
            <% End If %>
            <button class="btn-more">더 보기 +</button>
        </div>

        <%'!-- 베스트 --%>
        <div id="cont3" class="cont-parasol cont-best">
            <ul class="nav-evt">
                <li class="nav1"><a href="#cont1">스토리</a></li>
                <li class="nav2"><a href="#cont2">테마별</a></li>
                <li class="nav3 on"><a href="#cont3">베스트</a></li>
                <li class="nav4"><a href="#cont4">혜택</a></li>
            </ul>
            <h3>인기 많은 힛-트 상품만 모았어요</h3>
            <ul class="sort">
                <li class="on" onclick="fnAwardItems('d');"><button>일간</button></li>
                <li onclick="fnAwardItems('w');"><button>주간</button></li>
                <li onclick="fnAwardItems('m');"><button>월간</button></li>
            </ul>
            <div class="items type-grid">
                <ul id="awardlist"></ul>
                <button class="btn-more" onclick="fnAwardItems('');">더 보기 +</button>
            </div>
        </div> 

        <%'!-- 혜택 --%>
        <div id="cont4" class="cont-parasol cont-benefit">
            <ul class="nav-evt">
                <li class="nav1"><a href="#cont1">스토리</a></li>
                <li class="nav2"><a href="#cont2">테마별</a></li>
                <li class="nav3"><a href="#cont3">베스트</a></li>
                <li class="nav4 on"><a href="#cont4">혜택</a></li>
            </ul>
            <h3>놓칠 수 없는 보나스 혜택</h3>
            <% if currentdate = "2020-07-13" Then %>
            <ul class="benefit-list">
                <li>
                    <a href="" onclick="goEventLink(104006);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit2.jpg" alt="연속로그인"></a>
                </li>						
                <li>
                    <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"> <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                </li>
            </ul>
            <% ElseIf currentdate >= "2020-07-14" AND currentdate <= "2020-07-16" Then %>
            <ul class="benefit-list">
                <li>
                    <a href="/my10x10/couponbook.asp" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit3.jpg" alt="쿠폰"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('마이텐바이텐','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit3.jpg" alt="쿠폰"></a>
                </li>						
                <li>
                    <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"> <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                </li>
                <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit4.jpg" alt="페이코"></li>
                <li>
                    <a href="" onclick="goEventLink(104006);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit2.jpg" alt="연속로그인"></a>
                </li>
            </ul>
            <% ElseIf currentdate >= "2020-07-17" AND currentdate <= "2020-07-19" Then %>
            <ul class="benefit-list">						
                <li>
                    <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"> <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                </li>
                <li><a href="" onclick="goEventLink(104006);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit2.jpg" alt="연속로그인"></a></li>
                <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit4.jpg" alt="페이코"></li>
            </ul>
            <% ElseIf currentdate >= "2020-07-20" AND currentdate <= "2020-07-26" Then %>
            <ul class="benefit-list">
                <li><a href="" onclick="goEventLink(104372);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit6.jpg" alt="BC카드"></a></li>							
                <li>
                    <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb"> <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기"></a>
                </li>
            </ul>
            <% ElseIf currentdate >= "2020-07-27" AND currentdate <= "2020-07-31" Then %>
            <ul class="benefit-list">
                <li>
                    <a href="/event/eventmain.asp?eventid=104373" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit7.jpg" alt="유입이벤트"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104374');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit7.jpg" alt="유입이벤트"></a>
                </li>
                <li><a href="" onclick="goEventLink(104372);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit6.jpg" alt="BC카드"></a></li>							
                <li>
                    <a href="/my10x10/goodsusing.asp" target="_blank" class="mWeb">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기">
                    </a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsusing.asp');" target="_blank" class="mApp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit1.jpg" alt="양산포토후기">
                    </a>
                </li>
            </ul>
            <% ElseIf currentdate = "2020-08-03" Then %>
            <ul class="benefit-list">
                <li>
                    <a href="" onclick="goEventLink(103173);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit8.jpg" alt="무료배송"></a>
                </li>
                <li>
                    <a href="/event/benefit/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="혜택"></a>
                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="mApp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="혜택">
                    </a>
                </li>
            </ul>
            <% ElseIf currentdate >= "2020-08-04" AND currentdate <= "2020-08-08" Then %>
            <ul class="benefit-list">
                <li>
                    <a href="" onclick="goEventLink(103173);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit8.jpg" alt="무료배송"></a>
                </li>
                <li>
                    <a href="/event/benefit/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="혜택"></a>
                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="mApp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="혜택">
                    </a>
                </li>
                <li>
                    <a href="/event/eventmain.asp?eventid=104813" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit7.jpg" alt="메몽"></a>
                    <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104812');" target="_blank" class="mApp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit7.jpg" alt="메몽">
                    </a>
                </li>
            </ul>
            <% ElseIf currentdate >= "2020-08-09" AND currentdate <= "2020-08-16" Then %>
            <ul class="benefit-list">
                <li>
                    <a href="" onclick="goEventLink(103173);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit8.jpg" alt="무료배송"></a>
                </li>
                <li>
                    <a href="/event/benefit/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="혜택"></a>
                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="mApp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="혜택">
                    </a>
                </li>
                <li>
                    <a href="/event/eventmain.asp?eventid=104894" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit10.jpg" alt="줍줍"></a>
                    <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104895');" target="_blank" class="mApp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit10.jpg" alt="줍줍">
                    </a>
                </li>
            </ul>
            <% ElseIf currentdate >= "2020-08-17" Then %>

            <ul class="benefit-list">
                <li>
                    <a href="https://m.10x10.co.kr/event/benefit/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit8.jpg" alt="첫구매샵"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit8.jpg" alt="첫구매샵"></a>
                </li>
                <li>
                    <a href="https://m.10x10.co.kr/event/eventmain.asp?eventid=101616" target="_blank" class="mWeb">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="텐텐 무료배송">
                    </a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','https://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101616');return false;" target="_blank" class="mApp">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103915/m/img_benefit9.jpg" alt="텐텐 무료배송">
                    </a>
                </li>
            </ul>
            <% End If%>
        </div>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->