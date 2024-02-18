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
' Description : 2021 [텐바이텐X수봉] Welcome to 수봉 Shop!
' History : 2021-05-24 정태훈
'####################################################

dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, couponCode, isCouponShow, vQuery

mktTest = False

IF application("Svr_Info") = "Dev" THEN
	eCode = "108365"
    couponCode = "23271"
    mktTest = True
ElseIf application("Svr_Info")="staging" Then
	eCode = "112122"
    couponCode = "144546"
    mktTest = True
Else
	eCode = "112122"
    couponCode = "144546"
    mktTest = False
End If

eventStartDate  = cdate("2021-06-24")		'이벤트 시작일
eventEndDate 	= cdate("2021-07-21")		'이벤트 종료일

LoginUserid		= getencLoginUserid()
isCouponShow = True

if mktTest then
    currentDate = cdate("2021-06-24")
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
.mEvt112122 .topic {position:relative; overflow:hidden;}
.mEvt112122 .topic .tit {position:absolute; left:50%; top:0; width:73.20vw; margin-left:-36vw; animation: bounce 2s; animation-fill-mode: both; will-change: transform;}
.mEvt112122 .topic .icon {position:absolute; right:10%; top:20%; width:23.33vw; animation: bounce02 1s ease-in-out alternate infinite;}
.mEvt112122 .topic .btn-coupon {position:absolute; left:0; bottom:4%; width:100%; height:17rem; background:transparent;}
.mEvt112122 .prd-list {padding:0 1.30rem; background:#2ab257;}
.mEvt112122 .prd-list ul {display:flex; justify-content:space-between; flex-wrap:wrap; width:100%;}
.mEvt112122 .prd-list ul li {width:48%; padding-top:1.73rem;}
.mEvt112122 .prd-list ul li:nth-child(1),
.mEvt112122 .prd-list ul li:nth-child(2) {padding-top:0;}
.mEvt112122 .prd-list ul li .thumbnail {height:44.1vw; overflow:hidden;}
.mEvt112122 .prd-list ul li .thumbnail img {width:100%;}
.mEvt112122 .prd-list ul li a {display:inline-block; width:100%; height:100%;}
.mEvt112122 .prd-list .desc {padding:1.65rem 0 1.34rem; }
.mEvt112122 .prd-list .price {font-size:1.52rem; letter-spacing:-1px; color:#141414; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.mEvt112122 .prd-list .price span {padding-left:0.3rem; font-size:1.17rem; color:#9efe00;}
.mEvt112122 .prd-list .price s {font-size:1.17rem; color:#141414;}
.mEvt112122 .prd-list .desc .name {height:3.5rem; padding-top:0.86rem; color:#141414; font-size:1.17rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; line-height:1.2; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;}
.mEvt112122 .prd-list .desc .brand {padding-top:0.65rem; color:#141414; font-size:1.08rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; overflow: hidden; text-overflow: ellipsis; white-space:nowrap;}

.mEvt112122 .pick-list {position:relative;}
.mEvt112122 .pick-list .prd-link {display:flex; flex-wrap:wrap; position:absolute; left:8%; bottom:5%;}
.mEvt112122 .pick-list .prd-link a {display:inline-block; width:8.34rem; height:8.34rem; margin:0 1rem 1rem 0;}
.mEvt112122 .pick-list .prd-link a:nth-last-child(1),
.mEvt112122 .pick-list .prd-link a:nth-last-child(2) {margin-bottom:0;}
.mEvt112122 .pick-list .prd-link a .thumbnail {width:100%; height:100%;}

.mEvt112122 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(92, 92, 92,0.902); z-index:150;}
.mEvt112122 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt112122 .pop-container .pop-inner a {display:inline-block;}
.mEvt112122 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/111375/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt112122 .sec-video {padding:0 1.30rem; background:#ff77df;}
.mEvt112122 .sec-video .video-inner {position:relative; padding-bottom:56.25%; height:0;}
.mEvt112122 .sec-video .video-inner iframe {position:absolute; top:0; left:0; width:100%; height:100%; border-radius:12px 12px 0 0;}
.mEvt112122 .link-sns {position:relative;}
.mEvt112122 .link-sns a {display:inline-block; width:100%; height:29rem; position:absolute; left:0; bottom:0;}
.mEvt112122 .link-apply {position:relative;}
.mEvt112122 .link-apply a {display:inline-block; width:100%; height:20rem; position:absolute; left:0; bottom:0;}
.itemList02 .price span,
.itemList03 .price span,
.itemList04 .price span {padding-left:0.32rem;}
.list-wrap {padding-bottom:7.17rem; background: #13b4ff;}
.list-wrap .list-shop {padding-left:4.34rem; display:flex; align-items:flex-start; overflow-x:scroll; scrollbar-width:none;}
.list-wrap .list-shop::-webkit-scrollbar {display: none; /* Chrome, Safari, Opera*/}
.list-wrap .list-shop div {margin-right:3.47rem;}
.list-wrap .shop a {display:block;}
.list-wrap .shop img{width:28.27vw;}
.list-wrap .shop.size img{width:28.93vw;}
.list-wrap .shop.soon img{width:28.27vw;}
.list-wrap .size-type02 img {width: 33vw;}
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
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo_112122.js?v=1.00"></script>
<script>
$(function(){
    <% If currentDate >= #2021-07-03 00:00:00# Then %>
    codeGrp = [2785591,3493646,3646836,3471386,3471382,3471393,3139597,3668328,2784157,3841387,2534036,3581267,2398236,3581230,2401808,2651798,2698828,2543514,2784156];
    <% else %>
    codeGrp = [2785591,3493646,3646836,3471386,3471382,3471393,3139597,3668328,2784157,3841387,2534036,3581267,2398236,3581230,2401808,2651798,2698828,2543514];
    <% end if %>
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
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/txt_comment' + iy1 + '.jpg?v=2.2">\
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

    <% If currentDate >= #2021-07-03 00:00:00# Then %>
    codeGrp2 = [2784156,2784157];
    <% else %>
    codeGrp2 = [2784157];
    <% end if %>
    var $rootEl2 = $("#itemList2")
    var itemEle2 = tmpEl2 = ""
    $rootEl2.empty();

    codeGrp2.forEach(function(item){
        tmpEl2 = '<a href="" onclick="goProduct('+item+');return false;">\
                    <div class="thumbnail"><img src="" alt=""></div>\
                </a>\
                '
        itemEle2 += tmpEl2;
    });
    
    $rootEl2.append(itemEle2)

    fnApplyItemInfoList2({
        items:codeGrp2,
        target:"itemList2",
        fields:["image"],
        unit:"none",
        saleBracket:false
    });

    codeGrp3 = [3471386,3471382,3471393,3668328,3841387];
    var $rootEl3 = $("#itemList3")
    var itemEle3 = tmpEl3 = ""
    $rootEl3.empty();

    codeGrp3.forEach(function(item){
        tmpEl3 = '<a href="" onclick="goProduct('+item+');return false;">\
                    <div class="thumbnail"><img src="" alt=""></div>\
                </a>\
                '
        itemEle3 += tmpEl3;
    });
    
    $rootEl3.append(itemEle3)

    fnApplyItemInfoList3({
        items:codeGrp3,
        target:"itemList3",
        fields:["image"],
        unit:"none",
        saleBracket:false
    });

    codeGrp4 = [2785591,3668328,3841387];
    var $rootEl4 = $("#itemList4")
    var itemEle4 = tmpEl4 = ""
    $rootEl4.empty();

    codeGrp4.forEach(function(item){
        tmpEl4 = '<a href="" onclick="goProduct('+item+');return false;">\
                    <div class="thumbnail"><img src="" alt=""></div>\
                </a>\
                '
        itemEle4 += tmpEl4;
    });

    $rootEl4.append(itemEle4)

    fnApplyItemInfoList4({
        items:codeGrp4,
        target:"itemList4",
        fields:["image"],
        unit:"none",
        saleBracket:false
    });

    codeGrp5 = [3646836,3581267,3523266];
    var $rootEl5 = $("#itemList5")
    var itemEle5 = tmpEl5 = ""
    $rootEl5.empty();

    codeGrp5.forEach(function(item){
        tmpEl5 = '<a href="" onclick="goProduct('+item+');return false;">\
                    <div class="thumbnail"><img src="" alt=""></div>\
                </a>\
                '
        itemEle5 += tmpEl5;
    });

    $rootEl5.append(itemEle5)

    fnApplyItemInfoList5({
        items:codeGrp5,
        target:"itemList5",
        fields:["image"],
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

$(function(){
    /* 팝업 닫기 */
    $('.mEvt112122 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});
</script>
            <div class="mEvt112122">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/bg_main.jpg" alt="수봉 shop">
                    <div class="tit"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_tit.png" alt="수봉 shop"></div>
                    <div class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/icon_subong.png?v=2" alt="수봉"></div>
                    <!-- 할인 쿠폰 받기 버튼 -->
                    <button type="button" class="btn-coupon" onclick="jsDownCoupon2('prd','<%=couponCode%>');"></button>
                </div>
                <!-- 추천상품 리스트 -->
                <div class="prd-list">
                    <ul class="itemList" id="itemList"></ul>
                </div>
                <!-- pick 수봉 피드 속 상품이 궁금해! -->
                <div>
                    <div class="pick-list">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_item01.jpg?v=2" alt="">
                        <div class="prd-link" id="itemList2"></div>
                    </div>
                    <div class="pick-list">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_item02.jpg?v=2" alt="">
                        <div class="prd-link" id="itemList3"></div>
                    </div>
                    <div class="pick-list">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_item03.jpg?v=2" alt="">
                        <div class="prd-link" id="itemList4"></div>
                    </div>
                    <div class="pick-list">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_item04.jpg?v=2" alt="">
                        <div class="prd-link" style="bottom:10%;" id="itemList5"></div>
                    </div>
                </div>
                <!-- sns -->
                <div class="link-sns">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_sns.jpg?v=2" alt="수봉 sns 채널 구경가기">
                    <a href="https://bit.ly/3gt6AfL" target="_blank" class="mWeb link-insta"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://bit.ly/3gt6AfL'); return false;" class="mApp link-insta"></a>
                </div>
                <!-- newest shop -->
                <div class="list-wrap">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/tit_newest.png?v=2" alt="newest shop">
                    <div class="list-shop">
                        <div class="shop size-type02">
                            <a href="/event/eventmain.asp?eventid=112487" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112487/m/icon_shop_noah_type01.png" alt="노아"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112487');return false;" class="mApp" style="display: none;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112487/m/icon_shop_noah_type01.png" alt="노아"></a>
                        </div>

                        <div class="shop size">
                            <a href="/event/eventmain.asp?eventid=112378" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/img_shop_kidult.png" alt="키덜트빈"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=112378');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112378/m/img_shop_kidult.png" alt="키덜트빈"></a>
                        </div>

                        <% If currentDate < #2021-07-15 00:00:00# Then %>
                        <div class="shop size">
                            <a href="/event/eventmain.asp?eventid=111794" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_mango.png" alt="망고펜슬"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111794');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_mango.png" alt="망고펜슬"></a>
                        </div>
                        <% end if %>
                        <% If currentDate < #2021-07-08 00:00:00# Then %>
                        <div class="shop">
                            <a href="/event/eventmain.asp?eventid=111545" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_zzan.png" alt="보쨘"></a>
                            <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111545');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_zzan.png" alt="보쨘"></a>
                        </div>
                        <% end if %>
                        <div class="shop soon">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_shop_soon.png" alt="comming soon">
                        </div>
                    </div>
                </div>
                <!-- 인풀루언서 지원하기 -->
                <div class="link-apply">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_apply.jpg" alt="인플루언서 지원하기">
                    <a href="https://forms.gle/4mmaYb6P4zfyJEqE6" target="_blank" class="mWeb"></a>
                    <a href="#" onclick="fnAPPpopupExternalBrowser('https://forms.gle/4mmaYb6P4zfyJEqE6'); return false;" class="mApp"></a>
                </div>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/img_noti.jpg" alt="유의사항">
                <!-- 팝업 - 할인 쿠폰 받기 -->
                <div class="pop-container coupon">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/112122/m/pop_coupon.jpg" alt="쿠폰사용방법">
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->