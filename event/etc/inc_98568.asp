<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MD 기획전 블랙프라이데이 이벤트
' History : 2019-11-14 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid
IF application("Svr_Info") = "Dev" THEN
	eCode = "90429"
Else
	eCode = "98568"
End If

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount  
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
'currentDate = Cdate("2019-05-04")
'// 오픈시 주석 제거해줘야됨.
'eventStartDate = cdate("2019-11-14")
%>
<style type="text/css">
.mEvt98568 {background-color:#fff;}
.mEvt98568 .topic {position:relative;}
.mEvt98568 .topic h2, .mEvt98568 .topic p {position:absolute; left:0; opacity:0; width:100%; transform:translateY(10px); transition:.8s;}
.mEvt98568 .topic h2 {top:8.8%;}
.mEvt98568 .topic p {top:41.3%;}
.mEvt98568 .topic.on h2 {transform:translateY(0); opacity:1;}
.mEvt98568 .topic.on p {transform:translateY(0); opacity:1; transition-delay:.4s;}
.mEvt98568 .friday-container {padding:4.27rem 8%;}
.mEvt98568 .friday-cont h3 {position:relative; padding-bottom:.8rem; font-size:2.4rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; border-bottom:.26rem solid #000; letter-spacing:.1rem;}
.mEvt98568 .friday-cont h3:after {content:''; position:absolute; right:0; top:.36rem; width:0; height:0; border-style:solid; border-width:.723rem 0 .723rem .723rem; border-color:transparent transparent transparent #000;}
.mEvt98568 .friday-cont h3 a {display:block;}
.mEvt98568 .friday-cont:last-child h3:after {display:none;}
.mEvt98568 .item-list {padding:3.4rem 7% 5rem;}
.mEvt98568 .item-list li {position:relative; margin-top:3.4rem;}
.mEvt98568 .item-list li:first-child {margin-top:0;} 
.mEvt98568 .item-list .price {padding-top:.68rem; font-size:1.8rem; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; color:#ff4040;}
.mEvt98568 .item-list .price s {padding-right:0.5rem; font-size:1.37rem; font-weight:300; color:#959595;}
.mEvt98568 .item-list .price span {display:inline-block; position:absolute; left:.85rem; top:.85rem; height:2.13rem; padding:0 .64rem; line-height:2.16rem; font-weight:bold; font-size:1.3rem; color:#fff; background-color:#000;}
.mEvt98568 #list1 .price span {display:none;}
.mEvt98568 #list1 li b {display:inline-block; position:absolute; left:.85rem; top:.85rem; height:2.13rem; padding:0 .64rem; line-height:2.5rem; font-weight:bold; font-size:1.3rem; color:#fff; background-color:#000;}
.mEvt98568 .brand-list {padding-top:2.56rem;}
.mEvt98568 .brand-list li {position:relative; margin-top:1.7rem;}
.mEvt98568 .brand-list li:first-child {margin-top:0;}
.mEvt98568 .brand-list li a {display:block; width:50%; height:35%; position:absolute; left:0; bottom:0; text-indent:-999em;}
.mEvt98568 .brand-list li a.btn-go {left:50%;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function(){
	$('.mEvt98568 .topic').addClass('on');
	fnApplyItemInfoList({
		items:"2172733,2567787,2453463",
		target:"list1",
		fields:["price","sale"],
		unit:"ew",
		saleBracket:false
    });
    fnApplyItemInfoEach({
		items:"2368878,1922074",
		target:"item",
		fields:["price","sale"],
		unit:"ew",
		saleBracket:false
    });
});

function jsDownCoupon98568(cType){
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    
    <% if Not(IsUserLoginOK) then %>
        jsEventLogin();
    <% else %>
        $.ajax({
            type: "post",
            url: "/apps/appCom/wish/web2014/event/etc/doEvenSubscript98568.asp",		
            data: {
                eCode: '<%=eCode%>',
                couponType: cType
            },
            cache: false,
            success: function(resultData) {
                fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode|couponType','<%=eCode%>|'+cType)
                var reStr = resultData.split("|");				
                
                if(reStr[0]=="OK"){		
                    alert('쿠폰이 발급 되었습니다.\n주문시 사용 가능합니다.');
                }else{
                    var errorMsg = reStr[1].replace(">?n", "\n");
                    alert(errorMsg);					
                }			
            },
            error: function(err) {
                console.log(err.responseText);
            }
        });
    <% end if %>
}

function jsEventLogin(){
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=?" & eCode)%>');
    <% end if %>
        return;
}
</script>
<%' 98568 디지털가전 블랙프라이데이 %>
<div class="mEvt98568">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/tit_black_friday.png" alt="TEN'S BLACK FRIDAY"></h2>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/txt_subcopy.png" alt="11월의 금요일엔 디지털가전 블랙프라이데이"></p>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_topic.jpg" alt=""></div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/txt_desc.png?v=2" alt="11월 8일, 15일, 22일 매주 금요일마다 새로운 특가 상품과 스페셜 쿠폰으로 돌아옵니다 디지털가전 특가 구매찬스를 놓치지 마세요!"></p>

    <div class="friday-container">
        <div class="friday-cont">
            <h3><a href="#group306301">DIGITAL</a></h3>
            <ul id="list1" class="item-list">
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2172733');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2172733&pEtr=98568">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_digital_1.jpg" alt="이그닉 바이북">
                        <b>최저가</b>
                        <p class="price"><s>456,000</s>123,000won</p>
                    </a>
                </li>
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2567787');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2567787&pEtr=98568">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_digital_2.jpg" alt="샤오미 에어닷">
                        <b>최저가</b>
                        <p class="price"><s>456,000</s>123,000won</p>
                    </a>
                </li>
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2453463');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2453463&pEtr=98568">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_digital_3.jpg" alt="이그닉 바이북">
                        <b>사은행사</b>
                        <p class="price"><s>456,000</s>123,000won</p>
                    </a>
                </li>
            </ul>
        </div>
        <div class="friday-cont">
            <h3><a href="#group306302">디자인가전</a></h3>
            <ul id="list2" class="item-list">
                <li class="item2368878">
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2368878');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2368878&pEtr=98568">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_design_1.jpg" alt="네스프레소 에센자미니 D30 레드">
                        <p class="price"><s>456,000</s>123,000won<span>99%</span></p>
                    </a>
                </li>
                <li>
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('2512431');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=2512431&pEtr=98568">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_design_2.jpg" alt="발뮤다 가습기">
                        <p class="price"><s>699,000won</s>489,000won<span>30%</span></p>
                    </a>
                </li>
                <li class="item1922074">
                    <% If isapp="1" Then %>
                        <a href="" onclick="TnGotoProduct('1922074');return false;">
                    <% Else %>
                        <a href="/category/category_itemPrd.asp?itemid=1922074&pEtr=98568">
                    <% End If %>
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/img_design_3.jpg" alt="라쿠진 핸디형 터보 스팀다리미">
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
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/bnr_brand_1.jpg?v=2" alt="BT21"></div>
                    <a href="" onclick="jsDownCoupon98568('cBt21');return false;" class="btn-coupon">BT21 쿠폰 받기</a>
                    <% If isapp="1" Then %>
                        <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98770');return false;" class="btn-go">BT21 상품 보러가기</a>
                    <% Else %>
                        <a href="/event/eventmain.asp?eventid=98770" class="btn-go">BT21 상품 보러가기</a>
                    <% End If %>

                </li>
                <li>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/bnr_brand_2.jpg?v=2" alt="카카오프렌즈"></div>
                    <a href="" onclick="jsDownCoupon98568('cKakaoF');return false;" class="btn-coupon">카카오프렌즈 쿠폰 받기</a>
                    <% If isapp="1" Then %>
                        <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98772');return false;" class="btn-go">카카오프렌즈 상품 보러가기</a>
                    <% Else %>
                        <a href="/event/eventmain.asp?eventid=98772" class="btn-go">카카오프렌즈 상품 보러가기</a>
                    <% End If %>
                </li>
                <li>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/bnr_brand_3.jpg?v=2" alt="샤오미"></div>
                    <a href="" onclick="jsDownCoupon98568('cOa');return false;" class="btn-coupon">오아 쿠폰 받기</a>
                    <% If isapp="1" Then %>
                        <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98771');return false;" class="btn-go">오아 상품 보러가기</a>
                    <% Else %>
                        <a href="/event/eventmain.asp?eventid=98771" class="btn-go">오아 상품 보러가기</a>
                    <% End If %>
                </li>
                <li>
                    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/bnr_brand_4.jpg?v=2" alt="오아"></div>
                    <a href="" onclick="jsDownCoupon98568('cXiaomi');return false;" class="btn-coupon">샤오미 쿠폰 받기</a>
                    <% If isapp="1" Then %>
                        <a href="" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98695');return false;" class="btn-go">샤오미 상품 보러가기</a>
                    <% Else %>
                        <a href="/event/eventmain.asp?eventid=98695" class="btn-go">샤오미 상품 보러가기</a>
                    <% End If %>
                </li>
            </ul>
            <%'// 브랜드 쿠폰 다운로드%>
        </div>
    </div>
    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/98568/m/txt_noti.jpg" alt=""></div>
</div>
<%'// 98568 디지털가전 블랙프라이데이 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->