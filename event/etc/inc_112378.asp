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
'############################################################
' Description : 2021 [텐바이텐X키덜트빈] Welcome to 키덜트빈 Shop!
' History : 2021-06-29 정태훈
'############################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, couponCode, isCouponShow, vQuery

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "108376"
    couponCode = "23271"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "112378"
    couponCode = "145729"
    mktTest = True
Else
	eCode = "112378"
    couponCode = "145729"
    mktTest = False
End If

eventStartDate  = cdate("2021-07-01")		'이벤트 시작일
eventEndDate 	= cdate("2021-07-28")		'이벤트 종료일

LoginUserid		= getencLoginUserid()
isCouponShow = True

if mktTest then
    currentDate = cdate("2021-07-01")
else
    currentDate = date()
end if

If IsUserLoginOK Then
    vQuery = "select count(1) from [db_item].[dbo].[tbl_user_item_coupon] where userid = '" & LoginUserid & "'"
    vQuery = vQuery + " and itemcouponidx='"&couponCode&"'"
    vQuery = vQuery + " and usedyn = 'N' "
    rsget.CursorLocation = adUseClient
    rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
    If rsget(0) = 7 Then
        isCouponShow = False
    Else
        isCouponShow = True
    End IF
    rsget.close
End If
%>
<style>
.mEvt112378 .topic {position:relative; overflow:hidden;}
.mEvt112378 .topic .tit {position:absolute; left:50%; top:0; width:85.33vw; margin-left:-41.66vw; animation: bounce 2s; animation-fill-mode: both; will-change: transform;}
.mEvt112378 .topic .icon {position:absolute; right:1%; top:37%; width:23.33vw; animation: bounce02 1s ease-in-out alternate infinite;}
.mEvt112378 .topic .btn-coupon {position:absolute; left:0; bottom:4%; width:100%; height:17rem; background:transparent;}
.mEvt112378 .prd-list {padding:0 1.30rem; background:#ffd3eb;}
.mEvt112378 .prd-list ul {display:flex; justify-content:space-between; flex-wrap:wrap; width:100%;}
.mEvt112378 .prd-list ul li {width:48%; padding-top:1.73rem;}
.mEvt112378 .prd-list ul li:nth-child(1),
.mEvt112378 .prd-list ul li:nth-child(2) {padding-top:0;}
.mEvt112378 .prd-list ul li .thumbnail {height:44.1vw; overflow:hidden;}
.mEvt112378 .prd-list ul li .thumbnail img {width:100%;}
.mEvt112378 .prd-list ul li a {display:inline-block; width:100%; height:100%;}
.mEvt112378 .prd-list .desc {padding:1.65rem 0 1.34rem; }
.mEvt112378 .prd-list .price {font-size:1.52rem; letter-spacing:-1px; color:#141414; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt112378 .prd-list .price span {padding-left:0.3rem; font-size:1.17rem; color:#a74dff;}
.mEvt112378 .prd-list .price s {font-size:1.17rem; color:#716e5d;}
.mEvt112378 .prd-list .desc .name {height:3.5rem; padding-top:0.86rem; color:#141414; font-size:1.17rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; line-height:1.2; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;}
.mEvt112378 .prd-list .desc .brand {padding-top:0.65rem; color:#141414; font-size:1.08rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt112378 .tit-video {padding:0 1.30rem; background:#b86fff;} 
.mEvt112378 .show-list .item-list {padding:0 1.30rem 3.04rem; background:#b86fff;}
.mEvt112378 .show-list .item-list li {padding-top:1.73rem; background:#fff;}
.mEvt112378 .show-list .item-list li:nth-child(1) {padding-top:0;}
.mEvt112378 .show-list .item-list li:last-child, 
.mEvt112378 .show-list .item-list li:last-child .prd-wrap {border-radius:0 0 12px 12px;}
.mEvt112378 .show-list .item-list li:last-child {padding-bottom:2.73rem;}
.mEvt112378 .show-list .item-list.itemList04 {padding-bottom:7.52rem;}
.mEvt112378 .show-list a {display:inline-block; width:100%; height:100%;}
.mEvt112378 .show-list .prd-wrap {display:flex; background:#fff; overflow:hidden;}
.mEvt112378 .show-list .thumbnail {width:23.33vw; height:23.33vw; margin-left: 1.73rem; overflow:hidden;}
.mEvt112378 .show-list .info {width:65%; margin-left:1.08rem;}
.mEvt112378 .show-list .price {padding-top:0.34rem; letter-spacing:-1px; font-size:1.52rem; color:#141414; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt112378 .show-list .price span {color:#a74dff; font-size:1.17rem;}
.mEvt112378 .show-list .price s {color:#6d6d6d; font-size:1.17rem;}
.mEvt112378 .show-list .desc .name { padding-top:0.56rem; color:#141414; font-size:1.17rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt112378 .show-list .desc .brand {padding:0.60rem 0 0.85rem; color:#141414; font-size:1.08rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt112378 .link-sns {position:relative;}
.mEvt112378 .link-sns .link-you {position:absolute; left:6%; top:74%; display:inline-block; width:9.56rem; height:9.56rem;}
.mEvt112378 .link-sns .link-insta {position:absolute; left:34%; top:74%; display:inline-block; width:9.56rem; height:9.56rem;}
.mEvt112378 .link-sns .link-face {position:absolute; left:64%; top:74%; display:inline-block; width:9.56rem; height:9.56rem;}
.mEvt112378 .link-apply {position:relative;}
.mEvt112378 .link-apply a {display:inline-block; width:100%; height:20rem; position:absolute; left:0; bottom:0;}

.mEvt112378 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(92, 92, 92,0.902); z-index:150;}
.mEvt112378 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt112378 .pop-container .pop-inner a {display:inline-block;}
.mEvt112378 .pop-container .pop-inner .btn-close {position:absolute; right:3.1rem; top:3.8rem; width:1.96rem; height:1.96rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111375/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt112378 .sec-video {padding:0 1.30rem; background:#b86fff;}
.mEvt112378 .sec-video .video-inner {position:relative; padding-bottom:56.25%; height:0;}
.mEvt112378 .sec-video .video-inner iframe {position:absolute; top:0; left:0; width:100%; height:100%; border-radius:12px 12px 0 0;}
.itemList02 .price span,
.itemList03 .price span,
.itemList04 .price span {padding-left:0.32rem;}
.list-wrap {padding-bottom:7.17rem; background: #ff879f;}
.list-wrap .list-shop {padding-left:4.34rem; display:flex; align-items:flex-start; overflow-x:scroll; scrollbar-width:none;}
.list-wrap .list-shop::-webkit-scrollbar {display: none; /* Chrome, Safari, Opera*/}
.list-wrap .list-shop div {margin-right:3.47rem; }
.list-wrap .shop a {display:block;}
.list-wrap .shop img{width:28.27vw;}
.list-wrap .shop.size img {width: 28.93vw;}
.list-wrap .size-type02 img {width: 33vw;}

.mEvt112378 .pop-container.pop-live {display:block;}
.mEvt112378 .pop-live .pop-inner .btn-close {background:url(//webimage.10x10.co.kr/fixevent/event/2021/112378/m/icon_close.png) no-repeat 0 0;position:absolute; right:3.1rem; top:3.8rem; width:1.96rem; height:1.96rem; background-size:100%; text-indent:-9999px;}
.mEvt112378 .pop-live .pop-contents {position:relative;}
.mEvt112378 .link-show {width:100%; position:absolute; left:0; bottom:0;}
.mEvt112378 .link-show a {display:inline-block; width:100%; height:15rem;}

@keyframes bounce {
    0% {transform: translate3d(0, -18rem, 0);}
    20%, 50%, 80% {transform: translate3d(0, 0, 0);}
    40% {transform: translate3d(0, -9rem, 0); animation-timing-function: ease;}
    60% {transform: translate3d(0, -8rem, 0); animation-timing-function: ease;}
    90% {transform: translate3d(0, -7rem, 0); animation-timing-function: ease;}
    100% {transform: translate3d(0, -7rem, 0);}
}
@keyframes bounce02 {
    0% {transform: translateY(-1rem)}
    100% {transform: translateY(1rem)}
}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_111375.js?v=1.05"></script>
<script type="text/javascript">
$(function(){
    codeGrp = [2772006,3765399,3765426,2391691,3515169,2310094,3449982,3730417,3602145,3730261,2849183,3779635,3806528,3074850,3751928,3631586,2339541,3000161];
    var $rootEl = $("#itemList")
    var itemEle = tmpEl = ""
    var ix1 = 1;
    var iy1 = "";
    $rootEl.empty();

    codeGrp.forEach(function(item){
        if(ix1 < 10){
            iy1 = "0" + ix1;
        }else{
            iy1 = ix1;
        }
        tmpEl = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="thumbnail"><img src="" alt=""></div>\
                        <div class="desc">\
                            <div class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></div>\
                            <p class="name">상품명상품명상품명상품명상품명상품명</p>\
                            <p class="brand">brand name</p>\
                        </div>\
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/txt_comment' + iy1 + '.jpg?v=2.2">\
                    </a>\
                </li>\
                '
        itemEle += tmpEl;
        ++ix1;
    });
    
    $rootEl.append(itemEle)

    fnApplyItemInfoList({
        items:codeGrp,
        target:"itemList",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp2 = [2873097,2580220,2902413,2651838,3727948];
    var $rootEl2 = $("#itemList2")
    var itemEle2 = tmpEl2 = ""
    var ix2 = 1;
    var iy2 = "";
    $rootEl2.empty();

    codeGrp2.forEach(function(item){
        tmpEl2 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="prd-wrap">\
                            <div class="thumbnail"><img src="" alt=""></div>\
                            <div class="info">\
                                <div class="desc">\
                                    <p class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></p>\
                                    <p class="name">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>\
                                    <p class="brand">brand name</p>\
                                </div>\
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/txt_list01_comment0' + ix2 + '.jpg">\
                            </div>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle2 += tmpEl2;
        ++ix2;
    });
    
    $rootEl2.append(itemEle2)

    fnApplyItemInfoList2({
        items:codeGrp2,
        target:"itemList2",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp3 = [3755476,3752205];
    var $rootEl3 = $("#itemList3")
    var itemEle3 = tmpEl3 = ""
    var ix3 = 1;
    $rootEl3.empty();

    codeGrp3.forEach(function(item){
        tmpEl3 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="prd-wrap">\
                            <div class="thumbnail"><img src="" alt=""></div>\
                            <div class="info">\
                                <div class="desc">\
                                    <p class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></p>\
                                    <p class="name">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>\
                                    <p class="brand">brand name</p>\
                                </div>\
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/txt_list02_comment0' + ix3 + '.jpg">\
                            </div>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle3 += tmpEl3;
        ++ix3;
    });
    
    $rootEl3.append(itemEle3)

    fnApplyItemInfoList3({
        items:codeGrp3,
        target:"itemList3",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    codeGrp4 = [3785302,3757908,3757861,3757433,3747611];
    var $rootEl4 = $("#itemList4")
    var itemEle4 = tmpEl4 = ""
    var ix4 = 1;
    $rootEl4.empty();

    codeGrp4.forEach(function(item){
        tmpEl4 = '<li>\
                    <a href="" onclick="goProduct('+item+');return false;">\
                        <div class="prd-wrap">\
                            <div class="thumbnail"><img src="" alt=""></div>\
                            <div class="info">\
                                <div class="desc">\
                                    <p class="price"><s>정가</s> 할인가<span class="sale">할인율%</span></p>\
                                    <p class="name">상품명상품명상품명상품명상품명상품명상품명상품명상품명상품명</p>\
                                    <p class="brand">brand name</p>\
                                </div>\
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/txt_list03_comment0' + ix4 + '.jpg">\
                            </div>\
                        </div>\
                    </a>\
                </li>\
                '
        itemEle4 += tmpEl4;
        ++ix4;
    });
    
    $rootEl4.append(itemEle4)

    fnApplyItemInfoList4({
        items:codeGrp4,
        target:"itemList4",
        fields:["image","name","price","sale","brand"],
        unit:"none",
        saleBracket:false
    });

    //팝업
    /* 팝업 닫기 */
    $('.mEvt112378 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});

function goProduct(itemid) {
	<% if isApp then %>
		parent.location.href= 'javascript:fnAPPpopupProduct('+itemid+')'
	<% else %>
		parent.location.href='/category/category_itemprd.asp?itemid='+itemid;
	<% end if %>
	return false;
}

function jsDownCoupon2(stype,idx){
<% If Not(IsUserLoginOK) Then %>
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
    <% end if %>
    return false;
<% else %>
    <% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>
        alert("이벤트 참여기간이 아닙니다.");
        return false;
    <% end if %>
    $.ajax({
        type: "post",
        url: "/shoppingtoday/act_couponshop_process.asp",
        data: "idx="+idx+"&stype="+stype,
        cache: false,
        success: function(message) {
            fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode','<%=eCode%>')
            if(typeof(message)=="object") {
                if(message.response=="Ok") {
                    $('.pop-container.coupon').fadeIn();
                } else {
                    alert(message.message);
                }
            } else {
                alert("처리중 오류가 발생했습니다.");
            }
        },
        error: function(err) {
            console.log(err.responseText);
        }
    });
<% end if %>
}
</script>
            <div class="mEvt112378">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/bg_main.jpg" alt="키덜트빈 shop">
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/img_tit.png" alt="키덜트빈 shop"></div>
                    <div class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/icon_kidult.png" alt="키덜트빈"></div>
                    <button type="button" class="btn-coupon" onclick="jsDownCoupon2('prd','<%=couponCode%>');"></button>
                </div>
                <!-- 추천상품 리스트 -->
                <div class="prd-list">
                    <ul class="itemList" id="itemList"></ul>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/tit_list.jpg" alt="키덜트빈 컨텐츠 속 상품이 궁금해!">
                <div class="sec-video">
                    <div class="video-inner">
                        <iframe width="" height="" src="https://www.youtube.com/embed/rKUTJ0gEUUs" title="이상한 나라의 앨리스 아이템 언박싱" frameborder="0" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="tit-video">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/tit_video01.jpg" alt="Enjoy my 덕질타임 이상한 나라의 앨리스 아이템 언박싱">
                </div>
                <!-- 영상 속 노출 상품 리스트 -->
                <div class="show-list">
                    <ul class="itemList02 item-list" id="itemList2"></ul>
                </div>
                <div class="sec-video">
                    <div class="video-inner">
                        <iframe width="" height="" src="https://www.youtube.com/embed/cmtujaXPFZA" title="일상과 언박싱을 더한 뒤죽박죽 브이로그" frameborder="0" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="tit-video">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/tit_video02.jpg" alt="일상과 언박싱을 더한 뒤죽박죽 브이로그 친구들에게 선물주기">
                </div>
                <!-- 영상 속 노출 상품 리스트 -->
                <div class="show-list">
                    <ul class="itemList03 item-list" id="itemList3"></ul>
                </div>
                <% If currentDate > #2021-07-05 00:00:00# Then %> 
                <div class="sec-video">
                    <div class="video-inner">
                        <iframe width="" height="" src="https://www.youtube.com/embed/so6JYGrUzOA" title="텐바이텐 하울 키덜트빈 shop 오픈했습니다" frameborder="0" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="tit-video">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/tit_video03.jpg?v=2" alt="텐바이텐 하울 키덜트빈 shop 오픈했습니다">
                </div>
                <div>
                    <div class="show-list">
                        <ul class="itemList04 item-list" id="itemList4"></ul>
                    </div>
                </div>
                <% end if %>
                <!-- sns -->
                <div class="link-sns">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/img_sns.jpg" alt="키덜트빈님 SNS 채널 구경가기">
                    <a href="https://bit.ly/3zV0rC0" target="_blank" class="mWeb link-you"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/3zV0rC0'); return false;" class="mApp link-you"></a>
                    <a href="https://bit.ly/2UyUISb" target="_blank" class="mWeb link-insta"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/2UyUISb'); return false;" class="mApp link-insta"></a>
                    <a href="https://bit.ly/3wSeDtj" target="_blank" class="mWeb link-face"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/3wSeDtj'); return false;" class="mApp link-face"></a>
                </div>
                <!-- newest shop -->
                <div class="list-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/tit_prev.png" alt="newest shop">
                    <div class="list-shop">
                        <% If currentDate < #2021-08-04 00:00:00# Then %>
                        <div class="shop size-type02">
                            <a href="/event/eventmain.asp?eventid=112487" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112487/m/icon_shop_noah_type01.png" alt="수봉"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112487');return false;" class="mApp" style="display: none;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112487/m/icon_shop_noah_type01.png" alt="노아"></a>
                        </div>
                        <% end if %>
                        <% If currentDate < #2021-07-22 00:00:00# Then %>
                        <div class="shop">
                            <a href="/event/eventmain.asp?eventid=112122" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/icon_shop_subong.png" alt="수봉"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112122');return false;" class="mApp" style="display: none;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/icon_shop_subong.png" alt="수봉"></a>
                        </div>
                        <% end if %>
                        <% If currentDate < #2021-07-15 00:00:00# Then %>
                        <div class="shop size">
                            <a href="/event/eventmain.asp?eventid=111794" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_mango.png" alt="망고펜슬"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111794');return false;" class="mApp" style="display: none;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_mango.png" alt="망고펜슬"></a>
                        </div>
                        <% end if %>
                        <% If currentDate < #2021-07-08 00:00:00# Then %>
                        <div class="shop">
                            <a href="/event/eventmain.asp?eventid=111545" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_zzan.png" alt="보쨘"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111545');return false;" class="mApp" style="display: none;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_zzan.png" alt="보쨘"></a>
                        </div>
                        <% end if %>
                        <% If currentDate < #2021-07-01 00:00:00# Then %>
                        <div class="shop">
                            <a href="/event/eventmain.asp?eventid=111375" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_bumg.png" alt="bumg"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111375');return false;" class="mApp" style="display: none;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_bumg.png" alt="bumg"></a>
                        </div>
                        <% end if %>
                        <div class="shop soon">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_soon.png" alt="comming soon">
                        </div>
                    </div>
                </div>
                <!-- 인풀루언서 지원하기 -->
                <div class="link-apply">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/img_apply.jpg" alt="인플루언서 지원하기">
                    <a href="https://bit.ly/33Ih2d7" target="_blank" class="mWeb"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/33Ih2d7'); return false;" class="mApp"></a>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/img_noti.jpg" alt="유의사항">
                <!-- 팝업 - 할인 쿠폰 받기 -->
                <div class="pop-container coupon">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/pop_coupon.jpg" alt="쿠폰사용방법">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                <% If currentDate < #2021-07-14 21:00:00# Then %>
                   <!-- 팝업 - 라이브안내 -->
                  <div class="pop-container pop-live">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/pop_live.jpg" alt="오늘 단 하루 라방 구경가기">
                            <!-- 바로 보러가기 -->
                            <div class="link-show">
                                <a href="https://bit.ly/3gtKMSw" target="_blank" class="mWeb"></a>
                                <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/3gtKMSw'); return false;" class="mApp"></a>
                            </div>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
                 <% end if %>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->