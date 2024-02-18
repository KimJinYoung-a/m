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
	'currentDate = "2020-06-15"
	today_code = "000"

	if currentdate >= "2020-08-26" AND currentdate <= "2020-08-31" Then
		today_code = "1881035"
	ElseIf currentdate = "2020-09-01" Then
		today_code = "1596901"
	ElseIf currentdate = "2020-09-02" Then
        today_code = "2201871"
    ElseIf currentdate = "2020-09-03" Then
        today_code = "2063632"
    ElseIf currentdate = "2020-09-04" Then
        today_code = "2452641"
    ElseIf currentdate = "2020-09-05" Then
        today_code = "2835760"
    ElseIf currentdate = "2020-09-06" Then
        today_code = "1616984"
    ElseIf currentdate = "2020-09-07" Then
        today_code = "1891858"
    ElseIf currentdate = "2020-09-08" Then
        today_code = "3176200"
    ElseIf currentdate = "2020-09-09" Then
        today_code = "3116416"
    ElseIf currentdate = "2020-09-10" Then
        today_code = "1781907"
    ElseIf currentdate = "2020-09-11" Then
        today_code = "3136956"
    ElseIf currentdate = "2020-09-12" Then
        today_code = "1638559"
    ElseIf currentdate = "2020-09-13" Then
        today_code = "3136959"
    ElseIf currentdate = "2020-09-14" Then
        today_code = "3134662"
    ElseIf currentdate = "2020-09-15" Then
        today_code = "2201871"
    ElseIf currentdate = "2020-09-16" Then
        today_code = "1781907"
    ElseIf currentdate = "2020-09-17" Then
        today_code = "1253348"
    ElseIf currentdate = "2020-09-18" Then
        today_code = "2467072"
    ElseIf currentdate = "2020-09-19" Then
        today_code = "1881035"
    ElseIf currentdate = "2020-09-20" Then
        today_code = "1596901"
    ElseIf currentdate = "2020-09-21" Then
        today_code = "2041233"
    ElseIf currentdate = "2020-09-22" Then
        today_code = "2073519"
    ElseIf currentdate = "2020-09-23" Then
        today_code = "3206903"
    ElseIf currentdate = "2020-09-24" Then
        today_code = "3200960"
    ElseIf currentdate = "2020-09-25" Then
		today_code = "3177120"
	End If
%>
<script type="text/javascript" src="/event/lib/countdownforevent.js"></script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function () {
    $('.topic').addClass('on');
    fnApplyItemInfoEach({
        items:<%=today_code%>,
        target:"todayitem",
        fields:["image","name","price","sale"],
        unit:"none",
        saleBracket:false
    });

    mySwiper1 = new Swiper('.thx1 .swiper-container',{
        pagination:".thx1 .pagination",
        effect:'fade'
    });
    mySwiper2 = new Swiper('.thx2 .swiper-container',{
        pagination:".thx2 .pagination",
        effect:'fade'
    });
    mySwiper3 = new Swiper('.thx3 .swiper-container',{
        pagination:".thx3 .pagination",
        effect:'fade'
    });

    var tabTop = $(".thx1").offset().top;
    $(window).scroll(function(){
        var y = $(window).scrollTop();
        if ( tabTop <= y ) {
            $(".btn-today").addClass("sticky");
        } else {
            $(".btn-today").removeClass("sticky");
        }
    });
    $(".btn-today").click(function(e){
		e.preventDefault();
		$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

    $(".itemcode").each(function(){
        var e = $(this);
        for (var i = 0; i < 5; i++) {
        e.clone().insertAfter(e);
        }
    });
    var codes = [
    3134662,2830277,3100545,1881035,1549045,1947191,
    2644354,2835760,3136956,1862657,1616984,1212217,
    2452641,3015550,3136959,2049907,2473351,1552103];
    var i = 0;
    var url1,url2,cls1,cls2,fnc1,fnc2 = "";
    $(".item-list li:visible").each(function(){
        url1 = $(this).find("a").attr("href");
        url2 = url1.replace("code",codes[i]);
        $(this).find("a").attr("href",url2);
        fnc1 = $(this).find("a").attr("onclick");
        fnc2 = fnc1.replace("code",codes[i]);
        $(this).find("a").attr("onclick",fnc2);
        cls1 = $(this).attr("class");
        cls2 = cls1.replace("code",codes[i]);
        $(this).attr("class",cls2);
        i++;
    });

    fnApplyItemInfoEach({
        items:codes.slice(0,6),
        target:"item",
        fields:["image","name","price","sale","soldout"],
        unit:"none",
        saleBracket:false
    });
    fnApplyItemInfoEach({
        items:codes.slice(6,12),
        target:"item",
        fields:["image","name","price","sale","soldout"],
        unit:"none",
        saleBracket:false
    });
    fnApplyItemInfoEach({
        items:codes.slice(12,18),
        target:"item",
        fields:["image","name","price","sale","soldout"],
        unit:"none",
        saleBracket:false
    });
    countDownEventTimer({
        eventid:105176,
        useDay: true
    });
});
</script>
<style>
.jungdam .pagination {height:auto; padding:3.73vw 0 8.27vw;}
.jungdam .pagination span {width:2.4vw; height:2.4vw; margin:0 1.3vw; background:#d4bbb3;}
.jungdam .pagination span.swiper-active-switch {background:#ff8972;}
.jungdam .item-list {display:flex; flex-wrap:wrap; justify-content:space-between; width:29rem; margin:0 auto; padding-bottom:1.28rem;}
.jungdam .item-list li {width:50%; padding:0 .85rem 2.36rem;}
.jungdam .item-list li .thumbnail {min-height:12.8rem;}
.jungdam .item-list li .thumbnail .ico-soldout {display:none; justify-content:center; align-items:center; position:absolute; top:0; left:0; right:0; bottom:0; width:100%; height:100%; padding-top:0; color:#fff; background-color:rgba(0, 0, 0, 0.5); font-size:1rem;}
.jungdam .item-list li .thumbnail .ico-soldout span:before {content:''; display:block; width:2.99rem; height:2.99rem; margin:.5rem auto; background-image:url(//fiximage.10x10.co.kr/m/2019/diary2020/ico_soldout.png); background-size:contain; background-repeat:no-repeat;}
.jungdam .item-list li.soldout .ico-soldout {display:flex; z-index:10;}
.jungdam .item-list .desc {font:normal 1.2rem/1.15 'CoreSansCBold','NotoSansKRBold';}
.jungdam .name {overflow:hidden; padding:1.28rem 0 1rem; color:#222; text-overflow:ellipsis; white-space:nowrap;}
.jungdam .price {display:inline-block; font-size:1.28rem; color:#ff2241;}
.jungdam .price:after {content:'원'}
.jungdam .price s {display:block; padding-bottom:.5vw; color:#5d5d5d; font-size:1.1rem; font-family:'CoreSansCMedium'; text-decoration:none;}
.jungdam .price span {float:left; padding-right:2.5vw;}
.jungdam .link li {position:absolute;}
.jungdam .link li a {display:block; height:100%;}
.topic {position:relative;}
.topic h2 img,.topic p,.topic .deco img {position:absolute; left:0; top:0; width:100%; transition:all 1.8s;}
.topic h2 img {opacity:0; transform:translateX(2rem);}
.topic h2 img:nth-child(2),.topic h2 img:nth-child(4) {transform:translateX(-2rem);}
.topic p {opacity:0; transform:translateY(1rem); transition:all 1s 1s;}
.topic.on h2 img {opacity:1; transform:translateX(0);}
.topic.on p {opacity:1; transform:translateY(0);}
.topic .point {position:absolute; left:0; bottom:30%;}
.today {position:relative;}
.today a {position:absolute; left:50%; top:13.5%; width:50vw; height:73%; text-align:center; font-size:4vw; margin-left:-25vw;}
.today .thumbnail {height:50vw;}
.today .name {padding:4vw 2vw 2.6vw; font-family:'CoreSansCBold','NotoSansKRBold';}
.today .price {font-family:'CoreSansCBold','NotoSansKRBold'; font-size:4vw;}
.today .price:after {font-family:'CoreSansCRegular','NotoSansKRRegular';}
.today .price s {display:inline-block; float:left; padding-right:2.4vw; font-size:4vw; color:#989898;}
.today .price span { padding-right:1vw;}
.today .time {position:absolute; left:0; bottom:0; z-index:10; width:100%; height:8vw; padding-left:52%; font:500 3.47vw/8vw verdana; text-align:left; color:#fff; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105176/m/txt_time.png) no-repeat 50% / 100%;}
.today .time #day {display:none;}
.today .deal .price span,
.today .deal .price:after {display:none;}
.thx1 {background:#ffe6de;}
.thx1 .link li:nth-child(1) {left:0; top:0; width:51%; height:35%;}
.thx1 .link li:nth-child(2) {left:53%; top:0; width:40%; height:22%;}
.thx1 .link li:nth-child(3) {left:51.5%; top:23%; width:38%; height:14%;}
.thx1 .link li:nth-child(4) {left:24%; top:41%; width:54%; height:24%;}
.thx1 .link li:nth-child(5) {right:0; top:35%; width:20%; height:20%;}
.thx1 .link li:nth-child(6) {left:7%; bottom:0; width:20%; height:35%;}
.thx1 .link li:nth-child(7) {left:31%; bottom:0; width:40%; height:32%;}
.thx1 .link li:nth-child(8) {right:5%; bottom:0; width:20%; height:32%;}
.thx2 {background:#f6f6ce;}
.thx2 .link li:nth-child(1) {left:0; top:30%; width:26%; height:24%;}
.thx2 .link li:nth-child(2) {left:26%; top:15%; width:24%; height:20%;}
.thx2 .link li:nth-child(3) {left:36%; top:35%; width:24%; height:19%;}
.thx2 .link li:nth-child(4) {right:0; top:30%; width:33%; height:38%;}
.thx2 .link li:nth-child(5) {left:20%; bottom:11%; width:30%; height:21%;}
.thx2 .link li:nth-child(6) {right:0; bottom:0; width:42%; height:30%;}
.thx2 .pagination span {background:#d3d39f;}
.thx2 .pagination span.swiper-active-switch {background:#b9b940;}
.thx3 {background:#e3f2f3;}
.thx3 .link li:nth-child(1) {left:40%; top:31%; width:11%; height:24%;}
.thx3 .link li:nth-child(2) {left:51%; top:38%; width:21%; height:22%;}
.thx3 .link li:nth-child(3) {right:0; top:20%; width:28%; height:30%;}
.thx3 .link li:nth-child(4) {left:0; top:60%; width:29%; height:16%;}
.thx3 .link li:nth-child(5) {left:29%; top:60%; width:23%; height:16%;}
.thx3 .link li:nth-child(6) {left:5%; bottom:6%; width:36%; height:18%;}
.thx3 .link li:nth-child(7) {right:0; bottom:6%; width:33%; height:24%;}
.thx3 .pagination span {background:#c6d0d1;}
.thx3 .pagination span.swiper-active-switch {background:#94c0c3;}

.related-event {position:relative;}
.related-event ul {overflow:hidden; position:absolute; left:0; top:0; width:100%; height:100%;}
.related-event li {float:left; width:50%; height:34%;}
.related-event li:first-child {width:100%; height:32%;}
.related-event a {display:block; height:100%; text-indent:-999em;}

.btn-today {position:fixed; right:-26%; top:50%; z-index:10011; width:25.73%; transition:all .7s cubic-bezier(0.6, -0.28, 0.735, 0.045);}
.btn-today.sticky {right:0;}
</style>
<div class="mEvt105176 jungdam">	
    <div class="topic">
        <h2>
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/tit_jungdam_1.png" alt="정담 추석">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/tit_jungdam_2.png" alt="">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/tit_jungdam_3.png" alt="">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/tit_jungdam_4.png" alt="">
        </h2>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/txt_sub.png" alt=""></p>
        <div class="deco">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/bg_cloud_1.png" alt="">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/bg_cloud_2.png" alt="">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/bg_cloud_3.png" alt="">
        </div>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/bg_topic.png" alt=""></div>
        <div id="point" class="point"></div>
    </div>

    <!-- 오늘의 특가 -->
    <div class="today" id="todayPrd">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/txt_today.png" alt="오늘만 이 가격"></h3>
        <a href="/category/category_itemPrd.asp?itemid=<%=today_code%>&pEtr=105176" onclick="TnGotoProduct('<%=today_code%>');return false;" class="todayitem<%=today_code%> <%=CHKIIF(today_code="3176200"," deal","")%>">
            <div class="thumbnail">
                <img src="" alt="">
                <div class="time">
                    <span id="day"></span>
                    <span id="hour"></span>:<span id="min"></span>:<span id="sec"></span>
                </div>
            </div>
            <p class="name"></p>
            <div class="price-wrap"><p class="price"></p></div>
        </a>                   
    </div>

    <a href="#point" class="btn-today"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/btn_today.png" alt="오늘의 특가 선물"></a>

    <!-- 부모님 -->
    <div class="section thx1">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/txt_talk_1.png" alt=""></h3>
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide1_1.jpg" alt="">
                    <ul class="link">
                        <li><a href="/category/category_itemPrd.asp?itemid=3134663&pEtr=105176" onclick="TnGotoProduct('3134663');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2195928&pEtr=105176" onclick="TnGotoProduct('2195928');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1549045&pEtr=105176" onclick="TnGotoProduct('1549045');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=3134662&pEtr=105176" onclick="TnGotoProduct('3134662');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1881035&pEtr=105176" onclick="TnGotoProduct('1881035');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2195928&pEtr=105176" onclick="TnGotoProduct('2195928');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2063632&pEtr=105176" onclick="TnGotoProduct('2063632');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=3006026&pEtr=105176" onclick="TnGotoProduct('3006026');return false;"></a></li>
                    </ul>
                </div>
                <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=3134662&pEtr=105176" onclick="TnGotoProduct('3134662');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide1_2.jpg" alt=""></a></div>
                <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=3134663&pEtr=105176" onclick="TnGotoProduct('3134663');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide1_3.jpg" alt=""></a></div>
            </div>
            <div class="pagination"></div>
        </div>
        <ul class="item-list">
            <li class="itemcode">
                <a href="/category/category_itemPrd.asp?itemid=code&pEtr=105176" onclick="TnGotoProduct('code');return false;">
                    <div class="thumbnail">
                        <div class="ico-soldout"><span>일시품절</span></div>
                        <img src="" alt="">
                    </div>
                    <div class="desc">
                        <p class="name"></p>
                        <p class="price"></p>
                    </div>
                </a>
            </li>
        </ul>
        <a href="/event/eventmain.asp?eventid=105243" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/btn_more_1.png" alt="더 많은 상품 보러가기"></a>
        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105243');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/btn_more_1.png" alt="더 많은 상품 보러가기"></a>
    </div>

    <!-- 은사님 -->
    <div class="section thx2">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/txt_talk_2.png" alt=""></h3>
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide2_1.jpg" alt="">
                    <ul class="link">
                        <li><a href="/category/category_itemPrd.asp?itemid=3136956&pEtr=105176" onclick="TnGotoProduct('3136956');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=3006021&pEtr=105176" onclick="TnGotoProduct('3006021');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1212217&pEtr=105176" onclick="TnGotoProduct('1212217');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2644354&pEtr=105176" onclick="TnGotoProduct('2644354');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1616984&pEtr=105176" onclick="TnGotoProduct('1616984');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2835760&pEtr=105176" onclick="TnGotoProduct('2835760');return false;"></a></li>
                    </ul>
                </div>
                <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2644354&pEtr=105176" onclick="TnGotoProduct('2644354');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide2_2.jpg" alt=""></a></div>
                <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=3136956&pEtr=105176" onclick="TnGotoProduct('3136956');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide2_3.jpg" alt=""></a></div>
            </div>
            <div class="pagination"></div>
        </div>
        <ul class="item-list">
            <li class="itemcode">
                <a href="/category/category_itemPrd.asp?itemid=code&pEtr=105176" onclick="TnGotoProduct('code');return false;">
                    <div class="thumbnail">
                        <div class="ico-soldout"><span>일시품절</span></div>
                        <img src="" alt="">
                    </div>
                    <div class="desc">
                        <p class="name"></p>
                        <p class="price"></p>
                    </div>
                </a>
            </li>
        </ul>
        <a href="/event/eventmain.asp?eventid=105244" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/btn_more_2.png" alt="더 많은 상품 보러가기"></a>
        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105244');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/btn_more_2.png" alt="더 많은 상품 보러가기"></a>
    </div>

    <!-- 첫인사 -->
    <div class="section thx3">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/txt_talk_3.png" alt=""></h3>
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide3_1.jpg" alt="">
                    <ul class="link">
                        <li><a href="/category/category_itemPrd.asp?itemid=3136957&pEtr=105176" onclick="TnGotoProduct('3136957');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=3136959&pEtr=105176" onclick="TnGotoProduct('3136959');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2702511&pEtr=105176" onclick="TnGotoProduct('2702511');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1596901&pEtr=105176" onclick="TnGotoProduct('1596901');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2473351&pEtr=105176" onclick="TnGotoProduct('2473351');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=2452641&pEtr=105176" onclick="TnGotoProduct('2452641');return false;"></a></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1791964&pEtr=105176" onclick="TnGotoProduct('1791964');return false;"></a></li>
                    </ul>
                </div>
                <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=1596901&pEtr=105176" onclick="TnGotoProduct('1596901');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide3_2.jpg" alt=""></a></div>
                <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=3136959&pEtr=105176" onclick="TnGotoProduct('3136959');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/slide3_3.jpg" alt=""></a></div>
            </div>
            <div class="pagination"></div>
        </div>
        <ul class="item-list">
            <li class="itemcode">
                <a href="/category/category_itemPrd.asp?itemid=code&pEtr=105176" onclick="TnGotoProduct('code');return false;">
                    <div class="thumbnail">
                        <div class="ico-soldout"><span>일시품절</span></div>
                        <img src="" alt="">
                    </div>
                    <div class="desc">
                        <p class="name"></p>
                        <p class="price"></p>
                    </div>
                </a>
            </li>
        </ul>
        <a href="/event/eventmain.asp?eventid=105245" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/btn_more_3.png" alt="더 많은 상품 보러가기"></a>
        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105245');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/btn_more_3.png" alt="더 많은 상품 보러가기"></a>
    </div>
    
    <!-- 관련 기획전 -->
    <div class="related-event">
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/105176/m/bnr_event.jpg" alt=""></div>
        <ul>
            <li>
                <a href="/event/eventmain.asp?eventid=105246" class="mWeb">누구나 좋아하는 명절 선물</a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105246');" target="_blank" class="mApp">누구나 좋아하는 명절 선물</a>
            </li>
            <li>
                <a href="/event/eventmain.asp?eventid=105247" class="mWeb">기분좋게 드리는 용돈</a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105247');" target="_blank" class="mApp">기분좋게 드리는 용돈</a>
            </li>
            <li>
                <a href="/event/eventmain.asp?eventid=105248" class="mWeb">보다 쉽게 준비하는 명절요리</a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105248');" target="_blank" class="mApp">보다 쉽게 준비하는 명절요리</a>
            </li>
            <li>
                <a href="/event/eventmain.asp?eventid=105249" class="mWeb">주인공은 나! 한복 추천템</a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105249');" target="_blank" class="mApp">주인공은 나! 한복 추천템</a>
            </li>
            <li>
                <a href="/event/eventmain.asp?eventid=105250" class="mWeb">조카 선물 고민이라면?</a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=105250');" target="_blank" class="mApp">조카 선물 고민이라면?</a>
            </li>
        </ul>
    </div>

</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->