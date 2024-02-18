<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  쿠폰 마일리지 이벤트
' History : 2021-11-15 정태훈
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/event/benefit/NewmemberAdvantageCls.asp" -->
<%
dim newmemberInfoObj, couponList, i, mileageInfo
    set newmemberInfoObj = new NewmemberAdvantageCls
    couponList = newmemberInfoObj.getNewAutoCouponList()
    mileageInfo = newmemberInfoObj.getAutoMileageInfo()
%>
<style type="text/css">
.special-benefit {background:#f8f8f8;}
.special-benefit a {display:inline-block;}
.special-benefit .topic {position:relative; width:100%; height:51.24rem; background:url(//fiximage.10x10.co.kr/web2021/specialBenefit/m/bg_main.gif) no-repeat 0 0; background-size:100%; text-align:center;}
.special-benefit .topic h2 {padding:5.9rem 0 1.5rem; line-height:6.4rem; letter-spacing:-0.13rem; font-size:4.91rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.special-benefit .topic .sub-txt {font-size:1.36rem; color:#fff; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight';}
.special-benefit .topic .txt-rolling {position:absolute; left:50%; bottom:17.3rem; transform:translateX(-50%); display:flex; align-items:flex-end; justify-content:center;}
.special-benefit .num-group {display:flex; align-items:flex-end; color:#9a807e;}
.special-benefit .num-group ul {height:5.38rem; overflow: hidden;}
.special-benefit .num-group li {font-size:5.38rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.special-benefit .num-group .comma {margin:0 -0.5rem; font-size:5.38rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium';}
.special-benefit .num-group .won {padding-bottom:0.5rem; font-size:1.49rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.special-benefit .head-area {height:16.21rem; padding-top:6.4rem; text-align:center;}
.special-benefit .head-area h3 {padding-bottom:1.70rem; font-size:2.77rem; color:#121212; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.special-benefit .head-area h3 span {color:#ff214f;}
.special-benefit .head-area .day {font-size:1.36rem; color:#121212;}
.special-benefit .coupon-area li {width:100%; height:10.67rem; background:url(//fiximage.10x10.co.kr/web2021/specialBenefit/m/bg_coupon.jpg) no-repeat 0 0; background-size:100%; text-align:center;}
.special-benefit .coupon-area .num {padding-top:2.2rem; font-size:3.41rem; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.special-benefit .coupon-area .num span {padding-left:0.2rem; font-size:1.62rem; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Regular', 'NotoSansKRRegular', sans-serif;}
.special-benefit .coupon-area .txt {padding-top:1rem; font-size:1.36rem; color:#ffbac8;}
.special-benefit .noti-area {min-height:22.19rem; padding:6.4rem 2.99rem 0; background:#4e4e4e;}
.special-benefit .noti-area .tit {padding-bottom:1.49rem; font-size:1.49rem; text-align:center; color:#fff; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.special-benefit .noti-area li {position:relative; padding:0 0 0.64rem 0.85rem; font-size:1.20rem; color:#fff; text-align:left; line-height:1.8; font-family:'CoreSansCLight', 'AppleSDGothicNeo-Light', 'NotoSansKRLight';}
.special-benefit .noti-area li::before {content:""; position:absolute; left:0; top:0.9rem; width:0.47rem; height:0.08rem; background:#fff;}
.special-benefit .item-area {padding:6.4rem 0 4.27rem; background:#fff;}
.special-benefit .item-area .tit {padding-bottom:6.40rem; font-size:2.77rem; color:#121212; line-height:3.5rem; letter-spacing:-0.13rem; text-align:center; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
</style>
<style>[v-cloak] { display: none; }</style>
<link rel="stylesheet" type="text/css" href="/lib/css/commonV20.css?v=1.42" />
<link rel="stylesheet" type="text/css" href="/lib/css/contentV20.css?v=1.85" />
<script>
    $(function() {
        var $rootEl = $("#mktbanner")
        var itemEle = tmpEl = ""
        $rootEl.empty();
        $.ajax({
            type: "POST",
            url:"/chtml/main/loader/2017loader/json_main_loader.asp",
            dataType: "JSON",
            success: function(data){
                data.forEach(function(item){
                    if(item.poscode==2078){
                        tmpEl = `
                        <% if isApp="1" then %>
                        <a href="" onclick="fnAPPpopupAutoUrl('` + item.link + `');return false;" class="mApp"><div class="thumbnail"><img src="` + item.imgsrc + `"></div></a>
                        <% else %>
                        <a href="` + item.link + `" class="mWeb"><div class="thumbnail"><img src="` + item.imgsrc + `"></div></a>
                        <% end if %>
                        `
                        itemEle += tmpEl
                    }
                });
                $rootEl.append(itemEle);
            }
        })
    });
</script>
			<div class="special-benefit">
				<div class="topic">
                    <h2>이번 주<br/>깜짝 혜택</h2>
                    <p class="sub-txt">지금만 누릴 수 있는 혜택을 확인하세요</p>
				</div>
            <%
                if isArray(couponList) then
                dim sdt : sdt = formatDate(couponList(3,0),"00.00.00")
                dim edt : edt = formatDate(couponList(4,0),"00.00")
                dim restDt : restDt = couponList(5,0)
            %>
				<div class="head-area">
                    <h3 class="tit">#전 상품 <span>할인쿠폰</span></h3>
                    <p class="day">사용 기간 : <%=sdt%> ~ <%=edt%>까지</p>
                </div>
                <div class="coupon-area">
                    <ul>
                        <% for i=0 to uBound(couponList,2) %>
                        <li>
                            <p class="num"><%=FormatNumber(couponList(1,i), 0)%><span><%=chkiif(couponList(6,i) = 1,"%","원")%></span></p>
                            <p class="txt"><%=FormatNumber(couponList(2,i), 0)%>원 이상 주문 시</p>
                        </li>
                        <% next %>
                    </ul>
                </div>
                <!-- 쿠폰 확인하러 가기 -->
                <a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=2');return false;" class="mApp"><img src="//fiximage.10x10.co.kr/web2021/specialBenefit/m/btn_copon.jpg" alt="쿠폰 확인하러 가기"></a>
                <a href="/my10x10/couponbook.asp?tab=2" class="mWeb"><img src="//fiximage.10x10.co.kr/web2021/specialBenefit/m/btn_copon.jpg" alt="쿠폰 확인하러 가기"></a>
            <% end if %>
            <%
                if isArray(mileageInfo) then
                dim msdt : msdt = formatDate(mileageInfo(0,0),"00.00.00")
                dim medt : medt = formatDate(mileageInfo(1,0),"00.00")
                dim mileage : mileage = mileageInfo(2,0)
            %>
				<div class="head-area">
                    <h3 class="tit">#보너스 <span>마일리지</span></h3>
                    <p class="day">사용 기간 : <%=msdt%> ~ <%=medt%>까지</p>
                </div>
                <div class="coupon-area">
                    <ul>
                        <li>
                            <p class="num"><%=FormatNumber(mileage, 0)%><span>원</span></p>
                            <p class="txt">30,000원 이상 주문 시</p>
                        </li>
                    </ul>
                </div>
                <!-- 마일리지 확인하러 가기 -->
                <a href="" onclick="fnAPPpopupBrowserURL('쿠폰함','http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/mymain.asp');return false;" class="mApp"><img src="//fiximage.10x10.co.kr/web2021/specialBenefit/m/btn_milige.jpg" alt="마일리지 확인하러 가기"></a>
                <a href="/my10x10/mymain.asp" class="mWeb"><img src="//fiximage.10x10.co.kr/web2021/specialBenefit/m/btn_milige.jpg" alt="마일리지 확인하러 가기"></a>
            <% end if %>
                <div class="noti-area">
                    <p class="tit">유의사항</p>
                    <ul>
                        <li>마일리지는 결제 시, 현금처럼 사용할 수 있습니다.</li>
                        <li>결제 시 할인정보 > 마일리지 칸에 사용 금액을 입력 후 적용 (3만원 이상 구매 시 사용 가능)</li>
                    </ul>
                </div>
                <%'// 마케팅 배너 %>
                <div id="mktbanner" class="marketing-bnr"></div>
                <div class="item-area">
                    <div class="tit"><h4>따근따근<br/>방금 나온 신상</h4></div>
                    <%' 상품 리스트 %>
                    <div id="app"></div>
                </div>
            </div>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/babel-core/5.8.34/browser.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="/vue/vue_dev.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<% End If %>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<%'!-- common component --%>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/components/common/functions/common_mixins.js?v=1.1"></script>
<script src="/vue/components/common/functions/modal_mixins.js?v=1.1"></script>
<script src="/vue/components/common/wish.js?v=1.0"></script>
<script src="/vue/components/common/no_data.js?v=1.0"></script>
<script src="/vue/components/common/modal.js?v=1.0"></script>
<script src="/vue/components/common/btn_top.js?v=1.0"></script>
<%'!-- common component --%>

<%'!-- share component --%>
<script src="/vue/components/product/prd_badge.js?v=1.0"></script>
<script src="/vue/components/product/prd_brand.js?v=1.0"></script>
<script src="/vue/components/product/prd_evaluate.js?v=1.0"></script>
<script src="/vue/components/product/prd_name.js?v=1.0"></script>
<script src="/vue/components/product/prd_price.js?v=1.0"></script>
<script src="/vue/components/product/prd_rank.js?v=1.0"></script>
<script src="/vue/components/product/prd_img.js?v=1.0"></script>
<script src="/vue/components/product/prd_more_button.js?v=1.0"></script>
<script src="/vue/components/product/prd_big_sale.js?v=1.0"></script>
<script src="/vue/components/product/prd_item_basic_product.js?v=1.0"></script>
<script src="/vue/components/product/new_product_more.js?v=1.0"></script>
<script src="/vue/components/product/prd_slider_type4.js?v=1.0"></script>
<%'!-- share component --%>

<%'!-- ui component --%>
<script src="/vue/components/category/ctgr_nav_type2.js?v=1.0"></script>
<%'!-- ui component --%>

<%'!-- store component--%>
<script src="/vue/list/store/store.js?v=1.0"></script>
<%'!-- store component--%>

<%'!-- main component--%>
<script src="/vue/list/new/new_detail_cm_event.js?v=1.1"></script>
<%'!-- main component--%>
<!-- #include virtual="/lib/db/dbclose.asp" -->