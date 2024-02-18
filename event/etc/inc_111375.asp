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
' Description : 2021 [텐바이텐X범지] Welcome to 범지 Shop!
' History : 2021-05-11 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, couponCode, isCouponShow, vQuery

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "105358"
    couponCode = "23271"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "111375"
    couponCode = "141015"
    mktTest = True
Else
	eCode = "111375"
    couponCode = "141015"
    mktTest = False
End If

eventStartDate  = cdate("2021-06-03")		'이벤트 시작일
eventEndDate 	= cdate("2021-06-30")		'이벤트 종료일

LoginUserid		= getencLoginUserid()
isCouponShow = True

if mktTest then
    currentDate = cdate("2021-06-03")
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
.mEvt111375 .topic {position:relative; overflow:hidden;}
.mEvt111375 .topic .tit {position:absolute; left:50%; top:0; width:73.20vw; margin-left:-36.6vw; animation: bounce 2s; animation-fill-mode: both; will-change: transform;}
.mEvt111375 .topic .icon {position:absolute; right:11%; top:20%; width:23.33vw; animation: bounce02 1s ease-in-out alternate infinite;}
.mEvt111375 .topic .btn-coupon {position:absolute; left:0; bottom:4%; width:100%; height:17rem; background:transparent;}
.mEvt111375 .prd-list {padding:0 1.30rem; background:#fdf4cd;}
.mEvt111375 .prd-list ul {display:flex; justify-content:space-between; flex-wrap:wrap; width:100%;}
.mEvt111375 .prd-list ul li {width:48%; padding-top:1.73rem;}
.mEvt111375 .prd-list ul li:nth-child(1),
.mEvt111375 .prd-list ul li:nth-child(2) {padding-top:0;}
.mEvt111375 .prd-list ul li .thumbnail {height:44.1vw; overflow:hidden;}
.mEvt111375 .prd-list ul li .thumbnail img {width:100%;}
.mEvt111375 .prd-list ul li a {display:inline-block; width:100%; height:100%;}
.mEvt111375 .prd-list .desc {padding:1.65rem 0 1.34rem; }
/* 2021-05-17 수정 */
.mEvt111375 .prd-list .price {font-size:1.52rem; letter-spacing:-1px; color:#141414; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt111375 .prd-list .price span {padding-left:0.3rem; font-size:1.17rem; color:#0ac875;}
.mEvt111375 .prd-list .price s {font-size:1.17rem; color:#716e5d;}
/* //2021-05-17 수정 */
.mEvt111375 .prd-list .desc .name {height:3.5rem; padding-top:0.86rem; color:#141414; font-size:1.17rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; line-height:1.2; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;}
.mEvt111375 .prd-list .desc .brand {padding-top:0.65rem; color:#141414; font-size:1.08rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt111375 .tit-video {padding:0 1.30rem; background:#69dfab;} 
.mEvt111375 .show-list .item-list {padding:0 1.30rem 3.04rem; background:#69dfab;}
.mEvt111375 .show-list .item-list li {padding-top:1.73rem; background:#fff;}
.mEvt111375 .show-list .item-list li:nth-child(1) {padding-top:0;}
.mEvt111375 .show-list .item-list li:last-child, 
.mEvt111375 .show-list .item-list li:last-child .prd-wrap {border-radius:0 0 12px 12px;}
.mEvt111375 .show-list .item-list li:last-child {padding-bottom:2.73rem;}
.mEvt111375 .show-list .item-list.itemList04 {padding-bottom:7.52rem;}
.mEvt111375 .show-list a {display:inline-block; width:100%; height:100%;}
.mEvt111375 .show-list .prd-wrap {display:flex; background:#fff; overflow:hidden;}
.mEvt111375 .show-list .thumbnail {width:23.33vw; height:23.33vw; margin-left: 1.73rem; overflow:hidden;}
.mEvt111375 .show-list .info {width:65%; margin-left:1.08rem;}
.mEvt111375 .show-list .price {padding-top:0.34rem; letter-spacing:-1px; font-size:1.52rem; color:#141414; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt111375 .show-list .price span {color:#0ac875; font-size:1.17rem;}
.mEvt111375 .show-list .price s {color:#6d6d6d; font-size:1.17rem;}
.mEvt111375 .show-list .desc .name {padding-top:0.56rem; color:#141414; font-size:1.17rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt111375 .show-list .desc .brand {padding:0.60rem 0 0.85rem; color:#141414; font-size:1.08rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}
.mEvt111375 .link-sns {position:relative;}
.mEvt111375 .link-sns .link-you {position:absolute; left:20%; top:74%; display:inline-block; width:9.56rem; height:9.56rem;}
.mEvt111375 .link-sns .link-insta {position:absolute; left:50%; top:74%; display:inline-block; width:9.56rem; height:9.56rem;}
.mEvt111375 .link-apply {position:relative;}
.mEvt111375 .link-apply a {display:inline-block; width:100%; height:20rem; position:absolute; left:0; bottom:0;}

.mEvt111375 .pop-container.pop-live {display:block;}
.mEvt111375 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(92, 92, 92,0.902); z-index:150;}
.mEvt111375 .pop-container .pop-contents {position:relative;}
.mEvt111375 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt111375 .pop-container .pop-inner a {display:inline-block;}
.mEvt111375 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111375/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt111375 .pop-container .pop-inner .btn-close02 {position:absolute; right:2.73rem; top:3.60rem; width:2rem; height:2rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111375/m/icon_close02.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt111375 .sec-video {padding:0 1.30rem; background:#69dfab;}
.mEvt111375 .sec-video .video-inner {position:relative; padding-bottom:56.25%; height:0;}
.mEvt111375 .sec-video .video-inner iframe {position:absolute; top:0; left:0; width:100%; height:100%; border-radius:12px 12px 0 0;}
.itemList02 .price span,
.itemList03 .price span,
.itemList04 .price span {padding-left:0.32rem;}
.list-wrap {padding-bottom:7.17rem; background: #d3f9e8;}
.list-wrap .list-shop {padding-left:4.34rem; display:flex; align-items:flex-start; overflow-x:scroll; scrollbar-width:none;}
.list-wrap .list-shop::-webkit-scrollbar {display: none; /* Chrome, Safari, Opera*/}
.list-wrap .list-shop div {margin-right:3.47rem;}
.list-wrap .shop a {display:block;}
.list-wrap .shop img{width:28.27vw;}
.list-wrap .shop.size img{width:28.80vw;}
.mEvt111375 .link-show {width:100%; position:absolute; left:0; bottom:0;}
.mEvt111375 .link-show a {display:inline-block; width:100%; height:15rem;}
@keyframes bounce {
    0% {transform: translate3d(0, -23rem, 0);}
    20%, 50%, 80% {transform: translate3d(0, 0, 0);}
    40% {transform: translate3d(0, -9rem, 0); animation-timing-function: ease;}
    60% {transform: translate3d(0, -8rem, 0); animation-timing-function: ease;}
    90% {transform: translate3d(0, -7rem, 0); animation-timing-function: ease;}
    100% {transform: translate3d(0, -6rem, 0);}
}
@keyframes bounce02 {
    0% {transform: translateY(-1rem)}
    100% {transform: translateY(1rem)}
}
</style>
<script type="text/javascript">
$(function(){
    /* 팝업 닫기 */
    $('.mEvt111375 .btn-close, .mEvt111375 .btn-close02').click(function(){
        $(".pop-container").fadeOut();
    });
});
</script>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_111375.js?v=1.05"></script>
<script>
$(function(){
    codeGrp = [2328799,1923676,2813917,3724810,3571049,2975115,2843719,443152,3627351,2780188,3461784,3751851,3808950,3787772,2845156,3542993]; // 04/14 작업 전
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
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/txt_comment' + iy1 + '.jpg?v=2.2">\
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

    codeGrp2 = [3488204,3488202,2813917,3731819,3030877]; // 04/14 작업 전
    var $rootEl2 = $("#itemList2")
    var itemEle2 = tmpEl2 = ""
    var ix2 = 1;
    var iy2 = "";
    $rootEl2.empty();

    codeGrp2.forEach(function(item){
        if(ix2>=2){
            iy2 = ix2-1;
        }else{
            iy2 = ix2;
        }
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
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/txt_list01_comment0' + iy2 + '.jpg">\
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

    codeGrp3 = [3542993,2997522,3521719,2938793,3058383]; // 04/14 작업 전
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
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/txt_list02_comment0' + ix3 + '.jpg?v=2">\
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

    codeGrp4 = [2798571,2328799,759693,2222950]; // 04/14 작업 전
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
                                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/txt_list03_comment0' + ix4 + '.jpg">\
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
            <div class="mEvt111375">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/bg_main.jpg" alt="범지shop">
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_tit.png" alt="범지shop"></div>
                    <div class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/icon_bumg.png" alt="bumg"></div>
                    <!-- 할인 쿠폰 받기 버튼 -->
                    <button type="button" class="btn-coupon" onclick="jsDownCoupon2('prd','<%=couponCode%>');"></button>
                </div>
                <!-- 추천상품 리스트 -->
                <div class="prd-list">
                    <ul class="itemList" id="itemList"></ul>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/tit_list.jpg" alt="범지 컨텐츠 속 상품이 궁금해!">
                <div class="sec-video">
                    <div class="video-inner">
                        <iframe width="" height="" src="https://www.youtube.com/embed/yfqyHSz5lyc" title="범지 켄텐츠" frameborder="0" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="tit-video">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/tit_video01.jpg?v=2" alt="새 다이어리에 하는 첫번째 처끝다">
                </div>
                <!-- 영상 속 노출 상품 리스트 -->
                <div class="show-list">
                    <ul class="itemList02 item-list" id="itemList2"></ul>
                </div>
                <div class="sec-video">
                    <div class="video-inner">
                        <iframe width="" height="" src="https://www.youtube.com/embed/v2C7mTbnzPA" title="범지 켄텐츠" frameborder="0" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="tit-video">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/tit_video02.jpg?v=2" alt="내돈 내산 1월호">
                </div>
                <!-- 영상 속 노출 상품 리스트 -->
                <div class="show-list">
                    <ul class="itemList03 item-list" id="itemList3"></ul>
                </div>
                <div class="sec-video">
                    <div class="video-inner">
                        <iframe width="" height="" src="https://www.youtube.com/embed/rOJynbkPE3g" title="범지 켄텐츠" frameborder="0" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="tit-video">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/tit_video03.jpg?v=2" alt="추천하는 다꾸템 10가지 소개">
                </div>
                <!-- 영상 속 노출 상품 리스트 -->
                <div>
                    <div class="show-list">
                        <ul class="itemList04 item-list" id="itemList4"></ul>
                    </div>
                </div>
                <!-- sns -->
                <div class="link-sns">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_sns.jpg" alt="범지님 sns 채널 구경가기">
                    <a href="https://bit.ly/2RJG3Ci" target="_blank" class="mWeb link-you"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/2RJG3Ci'); return false;" class="mApp link-you"></a>
                    <a href="https://bit.ly/2R51T3e" target="_blank" class="mWeb link-insta"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/2R51T3e'); return false;" class="mApp link-insta"></a>
                </div>
                <!-- newest shop -->
                <div class="list-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111545/m/tit_newest.png" alt="newest shop">
                    <div class="list-shop">
                        <div class="shop size">
                            <a href="/event/eventmain.asp?eventid=112122" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_subong.png" alt="수봉"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112122');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_subong.png" alt="수봉"></a>
                        </div>
                        <!-- 망고펜슬 배너 7/15일 삭제 -->
                        <div class="shop size">
                            <a href="/event/eventmain.asp?eventid=111794" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_shop_mang.png" alt="망고펜슬"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111794');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_shop_mang.png" alt="망고펜슬"></a>
                        </div>
                        <!-- 보쨘 배너 7/8일 삭제 -->
                        <div class="shop">
                            <a href="/event/eventmain.asp?eventid=111545" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_shop_zzan.png" alt="보쨘"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111545');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_shop_zzan.png" alt="보쨘"></a>
                        </div>
                        <div class="shop">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_shop_soon.png" alt="comming soon">
                        </div>
                    </div>
                </div>
                <!-- 인풀루언서 지원하기 -->
                <div class="link-apply">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_apply.jpg" alt="인플루언서 지원하기">
                    <a href="https://forms.gle/4mmaYb6P4zfyJEqE6" target="_blank" class="mWeb"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://forms.gle/4mmaYb6P4zfyJEqE6'); return false;" class="mApp"></a>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/img_noti.jpg" alt="유의사항">
                <!-- 팝업 - 할인 쿠폰 받기 -->
                <div class="pop-container coupon">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/111375/m/pop_coupon.jpg" alt="쿠폰사용방법">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->