<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
'####################################################
' Description : 로우로우 이벤트
' History : 2020.08.17 정태훈
'####################################################

dim eventStartDate, eventEndDate, eCode, currentDate

IF application("Svr_Info") = "Dev" THEN
	eCode = "102206"
Else
	eCode = "105018"
End If

eventStartDate  = cdate("2020-08-17")		'이벤트 시작일
eventEndDate 	= cdate("2020-08-23")		'이벤트 종료일
currentDate 	= date()

function WeekKor(weeknum)
    if weeknum="1" then
        WeekKor="일"
    elseif weeknum="2" then
        WeekKor="월"
    elseif weeknum="3" then
        WeekKor="화"
    elseif weeknum="4" then
        WeekKor="수"
    elseif weeknum="5" then
        WeekKor="목"
    elseif weeknum="6" then
        WeekKor="금"
    elseif weeknum="7" then
        WeekKor="토"
    end if
end function
%>
<style>
.mEvt105017 {position:relative; overflow:hidden; background:#fff;}
.mEvt105017 button {display:block; background:none; -webkit-tap-highlight-color:rgba(255,255,255,0);}
.mEvt105017 .topic {position:relative; background:url(//webimage.10x10.co.kr/fixevent/event/2020/105018/m/bg_topic.jpg) no-repeat center / cover;}
.mEvt105017 .topic > * {opacity:0;}
.mEvt105017 .tit-rawrow {transform:translateY(2rem); transition:1.5s;}
.mEvt105017 .txt-carrier {transform:translateY(5rem); transition:1.8s .5s;}
.mEvt105017 .txt-only {position:absolute; top:19.7%; right:11.7%; width:21.3%; transition:2s .5s;}
.mEvt105017 .topic.on > * {opacity:1; transform:translateY(0);}
.mEvt105017 .txt-intro {position:relative;}
.mEvt105017 .btn-tgl {position:relative; width:100%;}
.mEvt105017 .btn-tgl::after {position:absolute; width:4vw; height:4vw; background:no-repeat center / contain; content:' ';}
.mEvt105017 .btn-notice::after {left:36%; bottom:4vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105018/m/ico_arr_blk.png);}
.mEvt105017 .btn-detail::after {left:59.7%; top:4vw; background-image:url(//webimage.10x10.co.kr/fixevent/event/2020/105018/m/ico_arr_org.png);}
.mEvt105017 .btn-tgl.open::after {transform:rotate(180deg);}
.mEvt105017 .txt-tgl {display:none;}
.mEvt105017 .txt-notice {padding-bottom:3%;}
.mEvt105017 .txt-detail {padding-bottom:4%;}
.mEvt105017 .items {margin-top:9%; padding-bottom:8%; background:#fff3d8;}
.mEvt105017 .link {position:relative;}
.mEvt105017 .link a {position:absolute; left:0; top:0; width:10vw; height:10vw; font-size:0; color:transparent;}
.mEvt105017 .link a:nth-of-type(1) {left:0vw; top:35vw; width:22vw; height:45vw;}
.mEvt105017 .link a:nth-of-type(2) {left:22vw; top:35vw; width:35vw; height:45vw;}
.mEvt105017 .link a:nth-of-type(3) {left:57vw; top:35vw; width:43vw; height:60vw; z-index:5;}
.mEvt105017 .link a:nth-of-type(4) {left:0vw; top:80vw; width:31vw; height:23vw;}
.mEvt105017 .link a:nth-of-type(5) {left:0vw; top:103vw; width:31vw; height:28vw;}
.mEvt105017 .link a:nth-of-type(6) {left:31vw; top:80vw; width:69vw; height:55vw;}
.mEvt105017 .link a:nth-of-type(7) {left:0vw; top:131vw; width:45vw; height:49vw;}
.mEvt105017 .link a:nth-of-type(8) {left:40vw; top:135vw; width:30vw; height:23vw;}
.mEvt105017 .link a:nth-of-type(9) {left:70vw; top:135vw; width:30vw; height:23vw;}
.mEvt105017 .link a:nth-of-type(10) {left:45vw; top:158vw; width:22vw; height:22vw;}
.mEvt105017 .link a:nth-of-type(11) {left:67vw; top:158vw; width:33vw; height:22vw;}
.mEvt105017 .winner {padding-bottom:10%;}
.mEvt105017 .winner .no-winner {display:flex; justify-content:center; align-items:center; font-size:1.1rem; color:#999;}
.mEvt105017 .winner .winner-slider {padding:0 1.5rem;}
.mEvt105017 .winner .swiper-slide {width:5.7rem; margin:0 .5rem;}
.mEvt105017 .winner .user-info {text-align:center; font-size:1rem; line-height:1.4; color:#666;}
.mEvt105017 .winner .user-info > span {display:block;}
.mEvt105017 .winner .user-info .user-grade {margin-bottom:.5rem;}
.mEvt105017 .winner .user-info .user-id {overflow:hidden; text-overflow:ellipsis; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt105017 .lookbook li {opacity:0; transform:translateY(2rem); transition:1s;}
.mEvt105017 .lookbook li.move {opacity:1; transform:translateY(0);}
</style>
<script>
$(function() {
    // ui
    $('.mEvt105017 .topic').addClass('on');
    $(window).scroll(function(){
        var y = $(window).scrollTop() + $(window).height();
        $('.lookbook li').each(function(i, el) {
            var imgTop = $(el).offset().top;
            if (y > imgTop)	$(el).addClass('move');
        });
    });
    $('.mEvt105017 .btn-tgl').on('click', function(e) {
        fnToggle($(e.currentTarget));
    });
    getWinners();
});
function fnToggle(btn) {
    var [btn, target] = [btn, btn.next('.txt-tgl')],
        state = target.is(':visible');
    target.toggle();
    if (state)	btn.removeClass('open');
    else	btn.addClass('open');
}

function getWinners(){
	$.ajax({
		type:"GET",
		url:"/event/etc/realtimeevent/RealtimeEventProc.asp",
		dataType: "JSON",
		data: { mode: "winner" },
		success : function(res){		
			renderWinners(res.data)
		},
		error:function(err){
			//console.log(err)
			alert("잘못된 접근 입니다.");
			return false;
		}
	});
}

function printUserName(name, num, replaceStr){
	<% if GetLoginUserLevel = "7" then %>
		return name
	<% else %>
		return name.substr(0,name.length - num) + replaceStr.repeat(num)
	<% end if %>
}

function renderWinners(data){
	var $rootEl = $("#winners")
	var itemEle = tmpEl = ""
	$rootEl.empty();

	data.forEach(function(winner){
		tmpEl = '<li class="swiper-slide">\
                    <div class="user-info">\
                        <span class="user-grade"><img src="//fiximage.10x10.co.kr/m/2018/common/' + winner.userlevelimg + '" alt=""></span>\
                        <span class="user-id">' + printUserName(winner.userid, 2, "*") + '</span>\
                        <span class="user-name">' + printUserName(winner.username, 1, "*") + '</span>\
                    </div>\
		        </li>\
		'
		itemEle += tmpEl
	});
	$rootEl.append(itemEle)

	// winner slider
	if ($('.winner-slider').find('.swiper-slide').length > 0) {
		var swiper = new Swiper('.winner-slider', {
			slidesPerView: 'auto'
		});
	} else {
		$('.winner').prepend('<p class="no-winner">당첨자가 없습니다.</p>');
	}
}
</script>
<div class="mEvt105017">
    <div class="topic">
        <h2 class="tit-rawrow"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/tit_rawrow.png" alt="텐바이텐 X 로우로우"></h2>
        <p class="txt-carrier"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_carrier.png" alt="캐리어 하나면 충분해"></p>
        <span class="txt-only"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105017/m/txt_only.png" alt=""></span>
    </div>
    <div class="txt-intro">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_intro.png" alt="아 어디든 떠나고 싶다"></p>
        <a href="https://tenten.app.link/jew7JUecR8"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105017/m/btn_try.png" alt="앱 설치하고 응모하기"></a>
    </div>
    <button type="button" class="btn-tgl btn-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_notice.png" alt="유의사항 확인하기"></button>
    <div class="txt-tgl txt-notice"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_notice.png" alt="유의사항"></div>
    <div class="items">
        <div class="link">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_items.jpg" alt="캐리어 구성품">
            <a href="/category/category_itemprd.asp?itemid=2816472&pEtr=105017">1 스누피 무빙펜</a>
            <a href="/category/category_itemprd.asp?itemid=2332829&pEtr=105017">2 아이패드</a>
            <a href="/category/category_itemprd.asp?itemid=2721042&pEtr=105017">3 캐리어 63L</a>
            <a href="/category/category_itemprd.asp?itemid=2937509&pEtr=105017">4 가죽지갑</a>
            <a href="/category/category_itemprd.asp?itemid=2441393&pEtr=105017">5 크로스백</a>
            <a href="/category/category_itemprd.asp?itemid=2734499&pEtr=105017">6 여행 파우치 세트</a>
            <a href="/category/category_itemprd.asp?itemid=2441385&pEtr=105017">7 백팩</a>
            <a href="/category/category_itemprd.asp?itemid=2783619&pEtr=105017">8 아이패드 파우치</a>
            <a href="/category/category_itemprd.asp?itemid=2937365&pEtr=105017">9 스누피 3공 다이어리</a>
            <a href="/category/category_itemprd.asp?itemid=2435183&pEtr=105017">10 선글라스</a>
            <a href="/category/category_itemprd.asp?itemid=2556615&pEtr=105017">11 스누피 키링</a>
        </div>
        <button type="button" class="btn-tgl btn-detail"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_detail.png" alt="자세히 보기"></button>
        <div class="txt-tgl txt-detail"><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_detail.png" alt="상품명"></div>
    </div>
    <ul class="lookbook">
        <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_1.jpg" alt=""></li>
        <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_2.jpg" alt=""></li>
        <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_3.jpg" alt=""></li>
        <li><img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/img_lookbook_4.jpg" alt=""></li>
    </ul>
    <div class="brand">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/txt_brand.jpg" alt="RAWROW 로우로우는">
        <a href="/event/eventmain.asp?eventid=105019" target="_blank">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/105018/m/btn_brand.jpg?v=1.01" alt="신상 라인업 보러가기">
        </a>
    </div>
    <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>
    <div class="winner">
        <div class="winner-slider swiper-container">
            <ul id="winners" class="swiper-wrapper"></ul>
        </div>
    </div>
    <% end if %>
</div>