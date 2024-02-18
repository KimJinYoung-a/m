<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 17주년 100원으로 인생역전 게이트 페이지
' History : 2018-09-27 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<style type="text/css">
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%;justify-content:flex-end; align-items:center; margin-right:2.21rem; }
.sns-share li {width:4.05rem; margin-left:.77rem;}

.lottery-head {position:relative; overflow:hidden;}
.lottery-head span {display:block; position:absolute;}
.lottery-head .star1 {width:4.8%; top:32.5%; left:8.4%; opacity:0; animation:twinkle1 3s 1s 100;}
.lottery-head .star2 {width:8%; top:16%; right:21.47%; opacity:0; animation:twinkle1 3s 2s 100;}
.lottery-head .star3 {width:100%; top:0; left:0; animation:twinkle3 3s 2s infinite;}
@keyframes twinkle1 {0% {opacity:0;} 30%,80% {opacity:1;} 100% {opacity:0;}}
@keyframes twinkle3 {0% {opacity:1;} 30% {opacity:0;} 50% {opacity:1;}}
.challenge {position:relative; background:url(http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/bg_challenge.jpg) center 0 no-repeat; background-size:100% auto;}
.challenge .round {position:absolute; right:12%; top:3%; width:22%; animation:bounce 1s 50; z-index:20;}
.challenge .slideshow {position:absolute; top:0; left:0; width:100%;}
#slideshow div {position:absolute; top:0; left:0; z-index:8; width:100%; opacity:0;}
#slideshow div.active {z-index:10; opacity:1;}
#slideshow div.last-active {z-index:9;}
@keyframes bounce {from, to {transform:translateY(0);} 50% {transform:translateY(-3px); animation-timing-function:ease-in;}}
.twinkle {position:relative; overflow:hidden;}
.twinkle span {display:block; position:absolute; top:50%; left:50%; width:64%; transform:translate(-50%,-50%);}
.challenge .btn-area {position:relative; overflow:hidden;}
.challenge .btn-down-app {display:block; position:absolute; top:8.3%; left:22%; width:56.5%; animation:shake 1s 50;}
@keyframes shake {from, to {transform:translateX(-3px); animation-timing-function:ease-out;} 50% {transform:translateX(3px); animation-timing-function:ease-in;}}
.challenge .btn-schedule {display:block; position:absolute; top:33.56%; left:24%; width:33%; background-color:transparent;}
.noti {background:#232341;}
.noti ul {padding:0 9% 4.2rem;}
.noti li {padding:0.5rem 0 0 0.65rem; color:#fff; font-size:1.06rem; line-height:1.8rem; text-indent:-0.65rem; word-break:keep-all;}
.noti li:first-child {padding-top:0;}
.noti li strong {font-weight:normal; text-decoration:underline;}
.layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;}
.layer-popup .layer {overflow:hidden; position:absolute; left:7%; top:0; z-index:99999; width:86%;}
.layer-popup .layer .btn-close {position:absolute; right:0; top:0; width:16%; background:transparent;}
.layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.7);}
#lyrSch .layer {top:10rem; left:6%; width:88%; background:#aff7ff; border:0.3rem solid #0db3e3; border-radius:2rem;}
#lyrSch .list {position:relative;}
#lyrSch .list ul {overflow:hidden; position:absolute; left:2%; top:0; width:96%; height:90%;}
#lyrSch .list li {float:left; width:33.33333%; height:100%;}
#lyrSch .list a {display:block; width:100%; height:100%; text-indent:-999em;}
#lyrSch .list li span {display:block; text-indent:-999em;}
#lyrSch .scroll {overflow-y:scroll; height:33rem; -webkit-overflow-scrolling:touch;}
#lyrSch .layer .btn-close {top:0.5rem; right:0.25rem; width:14.3%;}
</style>
<script>
function slideSwitch() {
	var $active = $("#slideshow div.active");
	if ($active.length == 0) $active = $("#slideshow div:last");
	var $next = $active.next().length ? $active.next() : $("#slideshow div:first");

	$active.addClass("last-active");

	$next.css({opacity:0}).addClass("active").animate({opacity:1}, 0, function() {
		$active.removeClass("active last-active").animate({opacity:0}, 0);
	});
}
$(function() {
    fnAmplitudeEventMultiPropertiesAction('view_17th_100win_mw','','');
	// 이미지 gif
	setInterval(function() {
		slideSwitch();
	}, 800);

	// 일정보기
	$('.btn-schedule').click(function(){
		$('#lyrSch').fadeIn();
		window.parent.$('html,body').animate({scrollTop:$('#lyrSch').offset().top}, 800);
	});

	// 레이어닫기
	$('.layer-popup .btn-close').click(function(){
		$('.layer-popup').fadeOut();
	});
	$('.layer-popup .mask').click(function(){
		$('.layer-popup').fadeOut();
	});
});
</script>
<div class="mEvt89309 lottery">
    <div class="lottery-head">
        <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/tit_lottery_mw.jpg" alt="100원으로 인생역전" /></h2>
        <span class="star1"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_star1.png" alt="" /></span>
        <span class="star2"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_star2.png" alt="" /></span>
        <span class="star3"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_star3.png" alt="" /></span>
    </div>
    <div class="challenge">
        <div class="today-item">
            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/today_mw.jpg" alt="100원" /></p>
            <div id="slideshow" class="slideshow">
                <div class="active"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_slide_1.png?v=1.0" alt="아이폰XS (5.8) 골드 256GB" /></div>
                <div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_slide_2.png?v=1.0" alt="애플 에어팟" /></div>
                <div><a href="/category/category_itemPrd.asp?itemid=1796388&pEtr=89309"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_slide_3.png?v=1.0" alt="다이슨 V8 카본 파이버" /></a></div>
                <div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_slide_4.png?v=1.0" alt="애플워치 시리즈4" /></div>
                <div><a href="/category/category_itemPrd.asp?itemid=1865049&pEtr=89309"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_slide_5.png?v=1.0" alt="닌텐도 스위치" /></a></div>
                <div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_slide_6.png?v=1.0" alt="아이패드 프로 256GB" /></div>
            </div>
        </div>
        <div class="round">
            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/txt_only_app.png" alt="ONLY APP" /></p>
        </div>
        <div class="twinkle">
            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_neck_mw.gif" alt="" /></p>
            <span><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_twinkle.gif" alt="" /></span>
        </div>
        <div class="btn-area">
            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_btn_area_mw.jpg" alt="텐바이텐 APP이 있다면, 다운받기 탭 - 해당 이벤트로 이동" /></p>
            <a href="http://m.10x10.co.kr/apps/link/?12320180912" class="btn-down-app"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_down_app.png" alt="APP 다운받기" /></a>
            <button class="btn-schedule"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_schedule.png" alt="일정 보기" /></button>
        </div>
    </div>
    <div id="lyrSch" class="layer-popup">
        <div class="layer">
            <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/tit_schedule.png" alt="100원으로 인생역전 상품 일정표" /></h3>
            <div class="scroll">
                <div class="list">
                    <div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_1.png" alt="" /></div>
                    <ul>
                        <li><span>애플 에어팟</span></li>
                        <li><span>아이패드 프로 256GB</span></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1865049&pEtr=89309">닌텐도 스위치</a></li>
                    </ul>
                </div>
                <div class="list">
                    <div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_2.png?v=1.0" alt="" /></div>
                    <ul>
                        <li><span>아이폰XS (5.8) 골드 256GB</span></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1804105&pEtr=89309">LG전자 시네빔</a></li>
                        <li><span>애플워치 시리즈4</span></li>
                    </ul>
                </div>
                <div class="list">
                    <div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_3.png" alt="" /></div>
                    <ul>
                        <li><a href="/category/category_itemPrd.asp?itemid=1796388&pEtr=89309">다이슨 V8 카본 파이버</a></li>
                        <li style="color:transparent">치후 360 로봇 청소기</li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1596055&pEtr=89309">즉석카메라 인화기</a></li>
                    </ul>
                </div>
                <div class="list">
                    <div><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/img_item_4.png" alt="" /></div>
                    <ul>
                        <li></li>
                        <li><a href="/category/category_itemPrd.asp?itemid=1555093&pEtr=89309">다이슨 헤어드라이어</a></li>
                        <li></li>
                    </ul>
                </div>
            </div>
            <button type="button" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/btn_close.png" alt="닫기" /></button>
        </div>
        <div class="mask"></div>
    </div>
    <div class="noti">
        <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88940/m/tit_noti.jpg" alt="유의사항" /></h3>
        <ul>
            <li>- 100원으로 인생역전은 매번 다른 상품 (총 10개로) 새롭게 구성됩니다.</li>
            <li>- 당첨자에게는 상품에 따라 세무신고에 필요한 개인정보를 요청할 수 있습니다. (제세공과금은 텐바이텐 부담입니다.)</li>
            <li>- 본 이벤트의 상품은 즉시 결제로만 구매할 수 있으며, 배송 후 반품/교환/구매취소가 불가합니다.</li>
            <li>- 하루에 ID당 최대 2회 응모 가능합니다.</li>
            <li>- 본 이벤트는 APP전용 이벤트 입니다.</li>
            <li>- <strong>아이폰 XS 5.8형 골드 (256GB), 애플워치 시리즈4 (40mm)상품은 국내 출시 후 구매해서 배송 될 예정입니다.</strong></li>
        </ul>
    </div>
</div>
		<% If Now() > #10/10/2018 00:00:00# AND Now() < #10/31/2018 23:59:59# Then  %>		
			<% if isApp = 1 then %>		
			<a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/17th/');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% else %>
			<a href="/event/17th/index.asp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_bnr_main.jpg" alt="텐텐 슬기로운 생활 17주년 메인으로 이동" /></a>				
			<% end if %>				
		<% end if %>


