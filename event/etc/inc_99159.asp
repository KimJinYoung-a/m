<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : MD 기획전 패션뷰티 할인 이벤트
' History : 2019-12-06 원승현
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
	eCode = "90438"
Else
	eCode = "99159"
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
'// STAFF 아이디는 테스트를 위해 시작일을 테스트 일자로 부터 시작하게 변경
If GetLoginUserLevel() = "7" Then
    eventStartDate = cdate("2019-12-06")
End If
%>
<style type="text/css">
.mEvt99159 {position:relative;}
.mEvt99159 button {background-color:transparent;}
.mEvt99159 .section {position:relative;}
.mEvt99159 .s1,.mEvt99159 .s3 {background-color:#f9f2e6;}
.mEvt99159 .s2,.mEvt99159 .s4 {background-color:#ffcdb8;}
.mEvt99159 .slider {position:relative; padding:0 13% 8vw;}
.mEvt99159 .slider .btn-nav {position:absolute; top:0; height:93vw; width:11.6%; z-index:10; background-color:rgba(0,0,0,0.5); font-size:0; color:transparent;}
.mEvt99159 .slider .btn-prev {left:0;}
.mEvt99159 .slider .btn-next {right:0;}
.mEvt99159 .slider .swiper-slide a {display:block; margin:0 1.3vw;}
.mEvt99159 .slider .pagination {height:auto; padding-top:7vw;}
.mEvt99159 .swiper-pagination-switch {background-color:rgba(34,34,34,0.3);}
.mEvt99159 .swiper-active-switch {background-color:#222;}
.mEvt99159 .coupon {position:relative; background:#fff url(//webimage.10x10.co.kr/fixevent/event/2019/99159/m/bg_cpn.png) no-repeat 50% / cover;}
.mEvt99159 .coupon .cpn-list {padding-bottom:5%;}
.mEvt99159 .coupon .cpn-list button {display:block; width:100%;}
.mEvt99159 .popup {display:none; position:absolute; top:29vw; left:5%; width:90%; background-color:#ffebe3; box-shadow:0 0.64rem 1.5rem rgba(212,94,94,0.5);}
.mEvt99159 .popup > p {padding-bottom:9%;}
.mEvt99159 .popup .btn-close {position:absolute; right:6.7vw; top:7vw; width:6vw; height:6vw; background-color:#222; font-size:0; color:transparent;}
.mEvt99159 .popup .btn-close:before,
.mEvt99159 .popup .btn-close:after {content:' '; position:absolute; top:0; right:0; bottom:0; left:0; margin:auto; width:4.3vw; height:1px; background-color:#f5efe3;}
.mEvt99159 .popup .btn-close:before {transform:rotate(45deg);}
.mEvt99159 .popup .btn-close:after {transform:rotate(-45deg);}
.mEvt99159 .popup .link {position:absolute; left:0; top:25vw; width:100%;}
.mEvt99159 .popup .link li {float:left; width:50%;}
.mEvt99159 .popup .link li:nth-child(3) {width:100%;}
.mEvt99159 .popup .link li a {display:block; height:40.5vw; text-align:center; font-size:0; color:transparent;}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
<script>
$(function(){

	var swiper1 = new Swiper ('.mEvt99159 .slider1', {
		speed: 700,
		autoplay: 3000,
		autoplayDisableOnInteraction: false,
		loop: true,
		prevButton: '.slider1 .btn-prev',
		nextButton: '.slider1 .btn-next',
		pagination: '.slider1 .pagination'
	});
	var swiper2 = new Swiper ('.mEvt99159 .slider2', {
		speed: 700,
		autoplay: 3000,
		autoplayDisableOnInteraction: false,
		loop: true,
		prevButton: '.slider2 .btn-prev',
		nextButton: '.slider2 .btn-next',
		pagination: '.slider2 .pagination'
	});
	var swiper3 = new Swiper ('.mEvt99159 .slider3', {
		speed: 700,
		autoplay: 3000,
		autoplayDisableOnInteraction: false,
		loop: true,
		prevButton: '.slider3 .btn-prev',
		nextButton: '.slider3 .btn-next',
		pagination: '.slider3 .pagination'
	});
	var swiper4 = new Swiper ('.mEvt99159 .slider4', {
		speed: 700,
		autoplay: 3000,
		autoplayDisableOnInteraction: false,
		loop: true,
		prevButton: '.slider4 .btn-prev',
		nextButton: '.slider4 .btn-next',
		pagination: '.slider4 .pagination'
	});
	$('.popup .btn-close').click(function(){
		$('.popup').hide();
	});

});

function getItemInfo(itemId){
	var makerName = []
	var makerID = []
	switch (itemId) {
		case 1 :
			makerName = ["스파오","커먼유니크","유라고","김양리빙","프롬비기닝"]
			makerID = ["spao","commonunique","urago","kimyangliving","beginning0"]
			break;
		case 2 :
			makerName = ["얼모스트블루","아이띵소","닥터마틴","마크모크","폴더"]
			makerID = ["almostblue10","ithinkso","sfootwearhunter","macmoc","folderstyle"]
			break;
		case 3 :
			makerName = ["더블유드레스룸","클레어스","포니이펙트","29데이즈","피에스씨 코스메틱"]
			makerID = ["trendi","klairs","PONYEFFECT","29days","cosmetics"]
			break;
		case 4 :
			makerName = ["마사인더가렛","트랜드메카","JULIUS","OST","CLUE"]
			makerID = ["marthainthegarret","trendmecca","julius10","ost","elandclue"]
			break;
		default :
			break;
	}
	return {
		makerName: makerName,
		makerID: makerID
	}
}

function cpnPopup(idx) {
	$('.popup h4 img').attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_cpn_0"+idx+".png");
	$('.popup p img').attr("src", "//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_cpn_0"+idx+".png");
	for (var i = 0; i < 5; i++) {
		var target = $('.link li:nth-child('+(i+1)+')');
		target.find('a').text( getItemInfo(idx).makerName[i] + ' 상품 보러가기' );
		target.find('.mWeb').attr("href", "/street/street_brand.asp?makerid=" + getItemInfo(idx).makerID[i] );
		target.find('.mApp').attr("onclick", "fnAPPpopupBrand('"+ getItemInfo(idx).makerID[i] +"'); return false;");
	}
	$('.popup').show();
}

function jsDownCoupon99159(cType){
	<% if not (currentDate >= eventStartDate and currentDate <= eventEndDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    
    <% if Not(IsUserLoginOK) then %>
        jsEventLogin();
    <% else %>
        $.ajax({
            type: "post",
            url: "/apps/appCom/wish/web2014/event/etc/doEvenSubscript99159.asp",		
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

<%' 99159 패션뷰티 결산베스트 %>
<div class="mEvt99159">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_best.jpg" alt="2019 패션뷰티 결산베스트"></h2>
    <section class="section s1">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_s1.png" alt="패션의류"></h3>
        <div class="slider slider1 swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2558780&pEtr=99159" onclick="TnGotoProduct('2558780');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide1_1.jpg" alt="스파오">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2583938&pEtr=99159" onclick="TnGotoProduct('2583938');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide1_2.jpg" alt="커먼유니크">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2593345&pEtr=99159" onclick="TnGotoProduct('2593345');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide1_3.jpg" alt="유라고">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2583915&pEtr=99159" onclick="TnGotoProduct('2583915');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide1_4.jpg" alt="김양리빙">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2566592&pEtr=99159" onclick="TnGotoProduct('2566592');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide1_5.jpg" alt="프롬비기닝">
                    </a>
                </div>
            </div>
            <button type="button" class="btn-nav btn-prev">이전</button>
            <button type="button" class="btn-nav btn-next">다음</button>
            <div class="pagination"></div>
        </div>
    </section>
    <section class="section s2">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_s2.png" alt="패션잡화"></h3>
        <div class="slider slider2 swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=1984470&pEtr=99159" onclick="TnGotoProduct('1984470');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide2_1.jpg" alt="얼모스트블루">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=1350644&pEtr=99159" onclick="TnGotoProduct('1350644');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide2_2.jpg" alt="아이띵소">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2108758&pEtr=99159" onclick="TnGotoProduct('2108758');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide2_3.jpg" alt="닥터마틴">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2565698&pEtr=99159" onclick="TnGotoProduct('2565698');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide2_4.jpg" alt="마크모크">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2592365&pEtr=99159" onclick="TnGotoProduct('2592365');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide2_5_v2.jpg" alt="폴더">
                    </a>
                </div>
            </div>
            <button type="button" class="btn-nav btn-prev">이전</button>
            <button type="button" class="btn-nav btn-next">다음</button>
            <div class="pagination"></div>
        </div>
    </section>
    <section class="section s3">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_s3.png" alt="뷰티"></h3>
        <div class="slider slider3 swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=1157791&pEtr=99159" onclick="TnGotoProduct('1157791');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide3_1.jpg" alt="더블유드레스룸">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=863241&pEtr=99159" onclick="TnGotoProduct('863241');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide3_2.jpg" alt="클레어스">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=1956792&pEtr=99159" onclick="TnGotoProduct('1956792');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide3_3.jpg" alt="포니이펙트">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2522139&pEtr=99159" onclick="TnGotoProduct('2522139');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide3_4.jpg" alt="29데이즈">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2593945&pEtr=99159" onclick="TnGotoProduct('2593945');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide3_5.jpg" alt="피에스씨 코스메틱">
                    </a>
                </div>
            </div>
            <button type="button" class="btn-nav btn-prev">이전</button>
            <button type="button" class="btn-nav btn-next">다음</button>
            <div class="pagination"></div>
        </div>
    </section>
    <section class="section s4">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_s4.png" alt="주얼리"></h3>
        <div class="slider slider4 swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=1820720&pEtr=99159" onclick="TnGotoProduct('1820720');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide4_1.jpg" alt="마사인더가렛">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2501734&pEtr=99159" onclick="TnGotoProduct('2501734');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide4_2.jpg" alt="TRENDMECCA">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2599376&pEtr=99159" onclick="TnGotoProduct('2599376');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide4_3.jpg" alt="CLUE">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=1883102&pEtr=99159" onclick="TnGotoProduct('1883102');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide4_4.jpg" alt="JULIUS">
                    </a>
                </div>
                <div class="swiper-slide">
                    <a href="/category/category_itemPrd.asp?itemid=2208460&pEtr=99159" onclick="TnGotoProduct('2208460');return false;">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_slide4_5.jpg" alt="OST">
                    </a>
                </div>
            </div>
            <button type="button" class="btn-nav btn-prev">이전</button>
            <button type="button" class="btn-nav btn-next">다음</button>
            <div class="pagination"></div>
        </div>
    </section>
    <div class="coupon">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_cpn.png" alt="BRAND COUPON"></h3>
        <ul class="cpn-list">
            <li>
                <button type="button" onclick="cpnPopup(1)"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/txt_cpn_01.png?v=1.0" alt="패션의류"></button>
                <%' for dev msg : 패션의류 쿠폰 ID (1252,1253,1254,1255,1256) %>
                <button type="button" onclick="jsDownCoupon99159('cFashioncloth');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/btn_cpn.png" alt="패션의류 쿠폰 전체 다운받기"></button>
            </li>
            <li>
                <button type="button" onclick="cpnPopup(2)"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/txt_cpn_02.png?v=1.0" alt="패션잡화"></button>
                <%' for dev msg : 패션잡화 쿠폰 ID (1264,1265,1266,1267,1268) %>
                <button type="button" onclick="jsDownCoupon99159('cFashiongoods');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/btn_cpn.png" alt="패션잡화 쿠폰 전체 다운받기"></button>
            </li>
            <li>
                <button type="button" onclick="cpnPopup(3)"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/txt_cpn_03.png?v=1.0" alt="뷰티"></button>
                <%' for dev msg : 뷰티 쿠폰 ID (1263,1259,1260,1261,1262) %>
                <button type="button" onclick="jsDownCoupon99159('cBeauty');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/btn_cpn.png" alt="뷰티 쿠폰 전체 다운받기"></button>
            </li>
            <li>
                <button type="button" onclick="cpnPopup(4)"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/txt_cpn_04.png?v=1.0" alt="주얼리"></button>
                <%' for dev msg : 주얼리 쿠폰 ID (1269,1270,1271,1272,1273) %>
                <button type="button" onclick="jsDownCoupon99159('cJewelry');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/btn_cpn.png" alt="주얼리 쿠폰 전체 다운받기"></button>
            </li>
        </ul>
        <div class="popup">
            <h4><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/tit_cpn_01.png" alt=""></h4>
            <button type="button" class="btn-close">닫기</button>
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/img_cpn_01.png" alt=""></p>
            <ul class="link">
                <li>
                    <a href="/street/street_brand.asp?makerid=spao" class="mWeb">스파오 상품 보러가기</a>
                    <a href="" onclick="fnAPPpopupBrand('spao'); return false;" class="mApp">스파오 상품 보러가기</a>
                </li>
                <li>
                    <a href="/street/street_brand.asp?makerid=commonunique" class="mWeb">커먼유니크 상품 보러가기</a>
                    <a href="" onclick="fnAPPpopupBrand('commonunique'); return false;" class="mApp">커먼유니크 상품 보러가기</a>
                </li>
                <li>
                    <a href="/street/street_brand.asp?makerid=urago" class="mWeb">유라고 상품 보러가기</a>
                    <a href="" onclick="fnAPPpopupBrand('urago'); return false;" class="mApp">유라고 상품 보러가기</a>
                </li>
                <li>
                    <a href="/street/street_brand.asp?makerid=kimyangliving" class="mWeb">김양리빙 상품 보러가기</a>
                    <a href="" onclick="fnAPPpopupBrand('kimyangliving'); return false;" class="mApp">김양리빙 상품 보러가기</a>
                </li>
                <li>
                    <a href="/street/street_brand.asp?makerid=beginning0" class="mWeb">프롬비기닝 상품 보러가기</a>
                    <a href="" onclick="fnAPPpopupBrand('beginning0'); return false;" class="mApp">프롬비기닝 상품 보러가기</a>
                </li>
            </ul>
        </div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99159/m/txt_noti.gif" alt="쿠폰 사용 유의사항"></p>
</div>
<%' // 99159 패션뷰티 결산베스트 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->