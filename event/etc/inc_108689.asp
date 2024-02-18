<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'####################################################
' Description : 추석 기획전 정담추석
' History : 2020-08-26 조경애
'####################################################

	Dim today_code, currentDate
	currentDate = date()
	'currentDate = "2021-01-19"
	today_code = "000"

	if currentdate >= "2021-01-14" AND currentdate <= "2021-01-28" Then
		today_code = "3284058"
	ElseIf currentdate = "2021-01-15" Then
		today_code = "2678551"
	ElseIf currentdate = "2021-01-16" Then
        today_code = "1694782"
	End If
%>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function () {
    $('.mEvt108689 .top-txt h2').addClass('on');
    /* 상품 더보기 버튼 */
    $('.btn-more').click(function(){
        $(this).parents('.btn-area').prev('.hidden-price').toggleClass('show');

        if($('.btn03').parents('.btn-area').prev('.hidden-price').hasClass('show')) {
            $('.btn03').children("img").attr("src","//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more1_02.png")
        }
        else {
            $('.btn03').children("img").attr("src","//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more1_01.png")
        };

        if($('.btn04').parents('.btn-area').prev('.hidden-price').hasClass('show')) {
            $('.btn04').children("img").attr("src","//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more2_02.png")
        }
        else {
            $('.btn04').children("img").attr("src","//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more2_01.png")
        };

        if($('.btn05').parents('.btn-area').prev('.hidden-price').hasClass('show')) {
            $('.btn05').children("img").attr("src","//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more3_02.png")
        }
        else {
            $('.btn05').children("img").attr("src","//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more3_01.png")
        };
    });

    /* slide */
    $(".section-08 .slide-area").each(function(index, slider) {
		var slider = $(this).find('.swiper-container');
		var amt = slider.find('.swiper-slide').length;
		var progress = $(this).find('.pagination-progressbar-fill');
		if (amt > 1) {
			var evtSwiper = new Swiper(slider, {
				autoplay: 2500,
				loop: true,
				speed: 1000,
				autoplayDisableOnInteraction: false,
				onInit: function(evtSwiper) {
					var init = (1 / amt).toFixed(2);
					progress.css('transform', 'scaleX(' + init + ') scaleY(1)');
				},
				onSlideChangeStart: function(evtSwiper) {
					var activeIndex = evtSwiper.activeIndex;
					var realIndex = parseInt(evtSwiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
					var calc = ( (realIndex+1) / amt ).toFixed(2);
					progress.css('transform', 'scaleX(' + calc + ') scaleY(1)');
				}
			});
		} else {
			var evtSwiper = new Swiper(slider, {
				noSwiping: true,
				noSwipingClass: '.noswiping'
			});
			$(this).find('.pagination-progressbar').hide();
		}
	});
    /* 가격연동 */
    fnApplyItemInfoList({
        items:<%=today_code%>,
        target:"todayitem",
        fields:["image"],
        unit:"none",
        saleBracket:false
    });
    fnApplyItemInfoList({
		items:"1877154,1877157,2678551,2684608,3340403,3544322,3544321,2692517,2123900,1876029,3546483,3321538,1580948,1877156,1814209,1000605",
		target:"list1",
		fields:["price","sale"],
		unit:"hw",
		saleBracket:false
    });
    fnApplyItemInfoList({
		items:"2698228,2110061,2689541,3478100,3535826,2433370,3546150,3546151,3510935,2734711,1926844,2300700,2003665,2325505,3546152,2678596",
		target:"list2",
		fields:["price","sale"],
		unit:"hw",
		saleBracket:false
    });
    fnApplyItemInfoList({
		items:"3479815,3497991,2051611,1982958,1646098,2529382,3503795,2928933,3193835,2959439,2494857,2454767,2238268,3426928",
		target:"list3",
		fields:["price","sale"],
		unit:"hw",
		saleBracket:false
    });
});
</script>
<style>
.mEvt108689 .topic {position:relative;}
.mEvt108689 .topic .top-txt {position:absolute; left:50%; top:9%; transform: translate(-50%,0);}
.mEvt108689 .topic .top-txt .txt01 {width:60.4vw; margin:0 auto; opacity:0; transition:1s; transform: translateY(-1rem);}
.mEvt108689 .topic .top-txt .txt02 {width:88.73vw; margin:0 auto; opacity:0; transition:1.5s; transform: translateY(-1.5rem);}
.mEvt108689 .topic .icon01 {position:absolute; left:1%; top:7%; width:7.82rem; animation: 1s updown01 ease-in-out alternate infinite;}
.mEvt108689 .topic .icon02 {position:absolute; right:0; top:7%; width:9.43rem; animation: 1s updown01 ease-in-out alternate infinite;}
.mEvt108689 .topic .icon03 {position:absolute; left:50%; top:29%; width:7.39rem; transform: translate(-50%,0); animation: 1s updown02 ease-in-out alternate infinite;}
.mEvt108689 .topic .icon04 {position:absolute; left:50%; bottom:12%; width:2.73rem; transform: translate(-50%,0); animation: 1s updown03 ease-in-out alternate infinite;}
.mEvt108689 .topic .top-txt .txt01.on {transform: translateY(0); opacity:1;}
.mEvt108689 .topic .top-txt .txt02.on {transform: translateY(0); opacity:1;}
.mEvt108689 li .price {font:normal 3.74vw/1.1 'CoreSansCBold'; color:#000;}
.mEvt108689 li .price s {display:none;}
.mEvt108689 li .price span {display:inline-block; height:4.53vw; margin:-.5vw 0 0 1.6vw; padding:0 1.33vw; color:#fff; font-size:3.3vw; line-height:5.1vw; background:#ff3737; vertical-align:middle; border-radius:7px;}

.mEvt108689 .section-03,
.mEvt108689 .section-05,
.mEvt108689 .section-07,
.mEvt108689 .section-09 {position:relative;}
.mEvt108689 .default-price {position:relative;}

.mEvt108689 .hidden-price {display:none; position:relative;}
.mEvt108689 .hidden-price.show {display:block;} 
.mEvt108689 .btn-area {position:relative; margin-top:-1px;}
.mEvt108689 .btn-area .btn-more {display:inline-block; width:18.26rem; position:absolute; left:50%; bottom:52%; transform:translate(-50%,0); background:transparent;}
.mEvt108689 .list.list02 {position:absolute; left:0; top:0%; width:100%; height:67%; display:flex; align-items:flex-end; flex-wrap:wrap;}
.mEvt108689 .list.list03 {position:absolute; left:0; top:0%; width:100%; height:100%; display:flex; align-items:flex-end; flex-wrap:wrap;}
.mEvt108689 .list.list02 li {position:relative; width:50%; height:30%;}
.mEvt108689 .list.list03 li {position:relative; width:50%; height:25%;}

.mEvt108689 .list {position:absolute; left:0; top:33%; width:100%; height:66%; padding:0 1rem; display:flex; align-items:flex-end; flex-wrap:wrap;}
.mEvt108689 .list.list2,
.mEvt108689 .list.list3 {top:34%;}
.mEvt108689 .list li {position:relative; width:50%; height:33%;}
.mEvt108689 .list li a {display:inline-block; width:100%; height:100%;}
.mEvt108689 .list li a .price {width:100%; position:absolute; left:50%; bottom:8%; transform: translate(-50%,0); text-align:center;}

.mEvt108689 .section-07 {position:relative;}
.mEvt108689 .section-07 a {display:inline-block; width:100%; height:100%;}
.mEvt108689 .section-07 .link01 {position:absolute; left:0; top:19%; width:100%; height:13rem;}
.mEvt108689 .section-07 .link02 {position:absolute; left:0; bottom:0; width:50%; height:25rem;}
.mEvt108689 .section-07 .link03 {position:absolute; right:0; bottom:0; width:50%; height:25rem;}

.mEvt108689 .swiper-slide {width:100%; height:27rem; position:relative;}
.mEvt108689 .swiper-slide a {display:inline-block; width:100%; height:100%; position:absolute; left:0; top:0;}
.mEvt108689 .swiper-slide .thumbnail {height:100%;}
.mEvt108689 .section-08 {position:relative; background:#ff8087;}
.mEvt108689 .section-08 .slide-area {width:80%; margin:0 10%;}
.mEvt108689 .section-08 .pagination-progressbar {position:absolute; width:100%; height:0.43rem; left:0; bottom:0; background:#fff; z-index:10;}
.mEvt108689 .section-08 .pagination-progressbar-fill {position:absolute; left:0; top:0; width:100%; height:100%; transform:scale(0); transform-origin:left top; transition-duration:300ms; background:#ff6666;}
@keyframes updown01 {
    0% {top:10%}
    100% {top:7%;}
}
@keyframes updown02 {
    0% {top:30%}
    100% {top:29%;}
}
@keyframes updown03 {
    0% {bottom:14%}
    100% {bottom:12%;}
}
</style>
<div class="mEvt108689">
    <div class="topic">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_tit.jpg" alt="">
        <div class="top-txt">
            <h2 class="txt01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_tit_txt01.png" alt="lovely"></h2>
            <h2 class="txt02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_tit_txt02.png" alt="valen time day"></h2>
        </div>
        <span class="icon01"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_hart01.png" alt=""></span>
        <span class="icon02"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_hart02.png" alt=""></span>
        <span class="icon03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_hart03.png" alt=""></span>
        <span class="icon04"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/icon_look_down.png" alt=""></span>
    </div>

    <!-- 롤링 영역 -->
    <div class="section-08">
        <div class="slide-area todayitem">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide">
                        <a href="/category/category_itemPrd.asp?itemid=<%=today_code%>&pEtr=108689" onclick="TnGotoProduct('<%=today_code%>');return false;" class="todayitem<%=today_code%> <%=CHKIIF(today_code=""," deal","")%>">
                            <div class="thumbnail">
                                <img src="" alt="">
                            </div>
                        </a>  
                    </div>
                </div>
                <div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
            </div>
        </div>
    </div>

    <div class="section-02">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_sub.jpg" alt="할인혜택 이벤트">
    </div>
    <!-- 가격 연동 -->
    <div class="section-03">
        <div class="default-price">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price1_01.jpg" alt="너와 함께 달콤한 타임 01">
            <ul id="list1" class="list list1">
                <li class="item1877154">
                    <a href="/category/category_itemPrd.asp?itemid=1877154&pEtr=108689" onclick="TnGotoProduct('1877154');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1877157">
                    <a href="/category/category_itemPrd.asp?itemid=1877157&pEtr=108689" onclick="TnGotoProduct('1877157');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2678551">
                    <a href="/category/category_itemPrd.asp?itemid=2678551&pEtr=108689" onclick="TnGotoProduct('2678551');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2684608">
                    <a href="/category/category_itemPrd.asp?itemid=2684608&pEtr=108689" onclick="TnGotoProduct('2684608');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3340403">
                    <a href="/category/category_itemPrd.asp?itemid=3340403&pEtr=108689" onclick="TnGotoProduct('3340403');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3544322">
                    <a href="/category/category_itemPrd.asp?itemid=3544322&pEtr=108689" onclick="TnGotoProduct('3544322');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
            </ul>
        </div>
        <div class="hidden-price">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price1_02.jpg" alt="너와 함께 달콤한 타임 01">
            <ul id="list1" class="list list02 list1">
                <li class="item3544321">
                    <a href="/category/category_itemPrd.asp?itemid=3544321&pEtr=108689" onclick="TnGotoProduct('3544321');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2692517">
                    <a href="/category/category_itemPrd.asp?itemid=2692517&pEtr=108689" onclick="TnGotoProduct('2692517');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2123900">
                    <a href="/category/category_itemPrd.asp?itemid=2123900&pEtr=108689" onclick="TnGotoProduct('2123900');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1876029">
                    <a href="/category/category_itemPrd.asp?itemid=1876029&pEtr=108689" onclick="TnGotoProduct('1876029 ');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3546483">
                    <a href="/category/category_itemPrd.asp?itemid=3546483&pEtr=108689" onclick="TnGotoProduct('3546483');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3321538">
                    <a href="/category/category_itemPrd.asp?itemid=3321538&pEtr=108689" onclick="TnGotoProduct('3321538 ');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1580948">
                    <a href="/category/category_itemPrd.asp?itemid=1580948&pEtr=108689" onclick="TnGotoProduct('1580948');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1877156">
                    <a href="/category/category_itemPrd.asp?itemid=1877156&pEtr=108689" onclick="TnGotoProduct('1877156');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1814209">
                    <a href="/category/category_itemPrd.asp?itemid=1814209&pEtr=108689" onclick="TnGotoProduct('1814209');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1000605">
                    <a href="/category/category_itemPrd.asp?itemid=1000605&pEtr=108689" onclick="TnGotoProduct('1000605');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
            </ul>
        </div>
        <div class="btn-area">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price1_03.jpg" alt="">
            <button type="button" class="btn-more btn03"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more1_01.png" alt="상품 더보기"></button>
        </div>
    </div>

    <!-- 가격 연동 -->
    <div class="section-04">
        <div class="default-price">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price2_01.jpg" alt="완벽해서 더 좋은 행복한 타임 01">
            <ul id="list2" class="list list2">
                <li class="item2698228">
                    <a href="/category/category_itemPrd.asp?itemid=2698228&pEtr=108689" onclick="TnGotoProduct('2698228');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2110061">
                    <a href="/category/category_itemPrd.asp?itemid=2110061&pEtr=108689" onclick="TnGotoProduct('2110061');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2689541">
                    <a href="/category/category_itemPrd.asp?itemid=2689541&pEtr=108689" onclick="TnGotoProduct('2689541');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3478100">
                    <a href="/category/category_itemPrd.asp?itemid=3478100&pEtr=108689" onclick="TnGotoProduct('3478100');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3535826">
                    <a href="/category/category_itemPrd.asp?itemid=3535826&pEtr=108689" onclick="TnGotoProduct('3535826');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2433370">
                    <a href="/category/category_itemPrd.asp?itemid=2433370&pEtr=108689" onclick="TnGotoProduct('2433370');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
            </ul>
        </div>
        <div class="hidden-price">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price2_02.jpg" alt="완벽해서 더 좋은 행복한 타임 01">
            <ul id="list2" class="list list02">
                <li class="item3546150">
                    <a href="/category/category_itemPrd.asp?itemid=3546150&pEtr=108689" onclick="TnGotoProduct('3546150');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3546151">
                    <a href="/category/category_itemPrd.asp?itemid=3546151&pEtr=108689" onclick="TnGotoProduct('3546151');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3510935">
                    <a href="/category/category_itemPrd.asp?itemid=3510935&pEtr=108689" onclick="TnGotoProduct('3510935');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2734711">
                    <a href="/category/category_itemPrd.asp?itemid=2734711&pEtr=108689" onclick="TnGotoProduct('2734711');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1926844">
                    <a href="/category/category_itemPrd.asp?itemid=1926844&pEtr=108689" onclick="TnGotoProduct('1926844');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2300700">
                    <a href="/category/category_itemPrd.asp?itemid=2300700&pEtr=108689" onclick="TnGotoProduct('2300700');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2003665">
                    <a href="/category/category_itemPrd.asp?itemid=2003665&pEtr=108689" onclick="TnGotoProduct('2003665');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2325505">
                    <a href="/category/category_itemPrd.asp?itemid=2325505&pEtr=108689" onclick="TnGotoProduct('2325505');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3546152">
                    <a href="/category/category_itemPrd.asp?itemid=3546152&pEtr=108689" onclick="TnGotoProduct('3546152');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2678596">
                    <a href="/category/category_itemPrd.asp?itemid=2678596&pEtr=108689" onclick="TnGotoProduct('2678596');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
            </ul>
        </div>
        <div class="btn-area">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price2_03.jpg" alt="">
            <button type="button" class="btn-more btn04"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more2_01.png" alt="상품 더보기"></button>
        </div>
    </div>
    
    <!-- 가격 연동 -->
    <div class="section-05">
        <div class="default-price">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price3_01.jpg" alt="둘이라서 더 행복한 타임 01">
            <ul id="list3" class="list list3">
                <li class="item3479815">
                    <a href="/category/category_itemPrd.asp?itemid=3479815&pEtr=108689" onclick="TnGotoProduct('3479815');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3497991">
                    <a href="/category/category_itemPrd.asp?itemid=3497991&pEtr=108689" onclick="TnGotoProduct('3497991');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2051611">
                    <a href="/category/category_itemPrd.asp?itemid=2051611&pEtr=108689" onclick="TnGotoProduct('2051611');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1982958">
                    <a href="/category/category_itemPrd.asp?itemid=1982958&pEtr=108689" onclick="TnGotoProduct('1982958');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item1646098">
                    <a href="/category/category_itemPrd.asp?itemid=1646098&pEtr=108689" onclick="TnGotoProduct('1646098');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2529382">
                    <a href="/category/category_itemPrd.asp?itemid=2529382&pEtr=108689" onclick="TnGotoProduct('2529382');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
            </ul>
        </div>
        <div class="hidden-price">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price3_02.jpg" alt="둘이라서 더 행복한 타임 01">
            <ul id="list3" class="list list03">
                <li class="item3503795">
                    <a href="/category/category_itemPrd.asp?itemid=3503795&pEtr=108689" onclick="TnGotoProduct('3503795');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2928933">
                    <a href="/category/category_itemPrd.asp?itemid=2928933&pEtr=108689" onclick="TnGotoProduct('2928933');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3193835">
                    <a href="/category/category_itemPrd.asp?itemid=3193835&pEtr=108689" onclick="TnGotoProduct('3193835');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2959439">
                    <a href="/category/category_itemPrd.asp?itemid=2959439&pEtr=108689" onclick="TnGotoProduct('2959439');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2494857">
                    <a href="/category/category_itemPrd.asp?itemid=2494857&pEtr=108689" onclick="TnGotoProduct('2494857');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2454767">
                    <a href="/category/category_itemPrd.asp?itemid=2454767&pEtr=108689" onclick="TnGotoProduct('2454767');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item2238268">
                    <a href="/category/category_itemPrd.asp?itemid=2238268&pEtr=108689" onclick="TnGotoProduct('2238268');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
                <li class="item3426928">
                    <a href="/category/category_itemPrd.asp?itemid=3426928&pEtr=108689" onclick="TnGotoProduct('3426928');return false;"><div class="price"><s>39,000</s> 33,000<span>30%</span></div></a>
                </li>
            </ul>
        </div>
        <div class="btn-area">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_price3_03.jpg" alt="">
            <button type="button" class="btn-more btn05"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/btn_more3_01.png" alt="상품 더보기"></button>
        </div>
    </div>

    <div class="section-07">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/108689/m/img_sub02.jpg" alt="행복한 이야기 더보기">
        <div class="link01">
            <a href="/event/eventmain.asp?eventid=108900" target="_blank" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108900');return false;" class="mApp"></a>
        </div>
        <div class="link02">
            <a href="/event/eventmain.asp?eventid=108901" target="_blank" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108901');return false;" class="mApp"></a>
        </div>
        <div class="link03">
            <a href="/event/eventmain.asp?eventid=108903" target="_blank" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=108903');return false;" class="mApp"></a>
        </div>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->