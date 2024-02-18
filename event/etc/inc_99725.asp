<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MD 기획전 브랜드 쿠폰 이벤트
' History : 2019-12-23 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<style type="text/css">
.mEvt98870 {background-color:#fff;}
.mEvt98870 .topic {position:relative;}
.mEvt98870 .topic h2, .mEvt98870 .topic p {position:absolute; left:0; opacity:0; width:100%; transform:translateY(10px); transition:.8s;}
.mEvt98870 .topic h2 {top:8.8%;}
.mEvt98870 .topic p {top:41.3%;}
.mEvt98870 .topic.on h2 {transform:translateY(0); opacity:1;}
.mEvt98870 .topic.on p {transform:translateY(0); opacity:1; transition-delay:.4s;}
.mEvt98870 .friday-container {padding:4.27rem 8%;}
.mEvt98870 .friday-cont h3 {position:relative; padding-bottom:.8rem; font-size:2.4rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; border-bottom:.26rem solid #000; letter-spacing:.1rem;}
.mEvt98870 .friday-cont h3:after {content:''; position:absolute; right:0; top:.36rem; width:0; height:0; border-style:solid; border-width:.723rem 0 .723rem .723rem; border-color:transparent transparent transparent #000;}
.mEvt98870 .friday-cont h3 a {display:block;}
.mEvt98870 .friday-cont:last-child h3:after {display:none;}
.mEvt98870 .item-list {padding:3.4rem 7% 5rem;}
.mEvt98870 .item-list li {position:relative; margin-top:3.4rem;}
.mEvt98870 .item-list li:first-child {margin-top:0;} 
.mEvt98870 .item-list .price {padding-top:.68rem; font-size:1.8rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; color:#ff4040;}
.mEvt98870 .item-list .price s {padding-right:0.5rem; font-size:1.37rem; font-weight:300; color:#959595;}
.mEvt98870 .item-list .price span {display:inline-block; position:absolute; left:.85rem; top:.85rem; height:2.13rem; padding:0 .64rem; line-height:2.16rem; font-weight:bold; font-size:1.3rem; color:#fff; background-color:#000;}
.mEvt98870 #list1 .price span {display:none;}
.mEvt98870 #list1 li b {display:inline-block; position:absolute; left:.85rem; top:.85rem; height:2.13rem; padding:0 .64rem; line-height:2.5rem; font-weight:bold; font-size:1.3rem; color:#fff; background-color:#000;}
.mEvt98870 .brand-list {padding-top:2.56rem;}
.mEvt98870 .brand-list li {position:relative; margin-top:1.7rem;}
.mEvt98870 .brand-list li:first-child {margin-top:0;}
.mEvt98870 .brand-list li a {display:block; width:100%; height:72%; position:absolute; left:0; top:0; text-indent:-999em;}
.mEvt98870 .brand-list li a.btn-go {top:73%; height:27%;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function(){
	$('.mEvt98870 .topic').addClass('on');
	fnApplyItemInfoList({
		items:"1804105,2433973,1637376",
		target:"list1",
		fields:["price","sale"],
		unit:"ew",
		saleBracket:false
    });
    fnApplyItemInfoList({
		items:"1906101,2246667,2256859",
		target:"list2",
		fields:["price","sale"],
		unit:"ew",
		saleBracket:false
    });
});

</script>
<%' 98870 디지털가전 블랙프라이데이 %>
<div class="mEvt98870">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/tit_black_friday.png" alt="TEN'S BLACK FRIDAY"></h2>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/txt_subcopy.png" alt="11월의 금요일엔 디지털가전 블랙프라이데이"></p>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_topic.jpg" alt=""></div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/txt_desc.png" alt="11월 8일, 15일, 22일 매주 금요일마다 새로운 특가 상품과 스페셜 쿠폰으로 돌아옵니다 디지털가전 특가 구매찬스를 놓치지 마세요!"></p>

    <div class="friday-container">
        <div class="friday-cont">
            <h3><a href="#group306738">DIGITAL</a></h3>
            <ul id="list1" class="item-list">
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('1804105');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=1804105&pEtr=98870">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/img_digital_1.jpg" alt="LG 시네빔 PH130">
                        <b>사은행사</b>
                        <p class="price"><s>456,000</s>123,000won</p>
                    </a>
                </li>
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2433973');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2433973&pEtr=98870">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/img_digital_2.jpg" alt="JBL TUNE120 블루투스 이어폰">
                        <b>최저가</b>
                        <p class="price"><s>456,000</s>123,000won</p>
                    </a>
                </li>
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('1637376');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=1637376&pEtr=98870">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/img_digital_3.jpg" alt="IDTOO 아이디바 디자인 멀티탭">
                        <b>최저가</b>
                        <p class="price"><s>456,000</s>123,000won</p>
                    </a>
                </li>
            </ul>
        </div>
        <div class="friday-cont">
            <h3><a href="#group306739">디자인가전</a></h3>
            <ul id="list2" class="item-list">
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('1906101');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=1906101&pEtr=98870">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/img_design_1.jpg" alt="VELONIX 침구 청소기">
                        <p class="price"><s>456,000</s>123,000won<span>99%</span></p>
                    </a>
                </li>
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2246667');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2246667&pEtr=98870">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/img_design_2.jpg" alt="HANSSEM 데일리 전기케틀">
                        <p class="price"><s>699,000won</s>489,000won<span>30%</span></p>
                    </a>
                </li>
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2256859');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2256859&pEtr=98870">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/img_design_3.jpg" alt="AVIAIR PTC 컴팩트 온풍기">
                        <p class="price"><s>456,000</s>123,000won<span>99%</span></p>
                    </a>
                </li>
            </ul>
        </div>
        <div class="friday-cont">
            <h3>BRAND COUPON</h3>
            <%' 브랜드 쿠폰 다운로드%>
            <%' 쿠폰 받기 클릭 시 메세지:
                '처음 클릭 - 발급 되었습니다. 주문시 사용 가능합니다.
                '중복 클릭 - 이미 발급된 쿠폰입니다. 구매 페이지에서 적용 가능합니다.
            %>
            <ul class="brand-list">
                <li>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98870/m/bnr_brand_1.jpg?v=2" alt="LOMO&amp;INSTAX"></div>
                    <a href="" onclick="fnNewCouponIssued('90451','2948');return false;" class="btn-coupon">LOMO&amp;INSTAX 쿠폰 받기</a>
                    <% If isapp="1" Then %>
                        <a href="" onclick="fnAPPpopupBrand('tnc01'); return false;" class="btn-go mApp">LOMO&amp;INSTAX 상품 보러가기</a>                    
                    <% Else %>
                        <a href="/street/street_brand.asp?makerid=tnc01" class="btn-go mWeb">LOMO&amp;INSTAX 상품 보러가기</a>                        
                    <% End If %>
                </li>
            </ul>
            <%'// 브랜드 쿠폰 다운로드%>
        </div>
    </div>
    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/txt_noti.jpg" alt=""></div>
</div>
<%'// 98870 디지털가전 블랙프라이데이 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->