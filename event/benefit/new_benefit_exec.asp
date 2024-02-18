<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  혜택페이지
' History : 2021-07-12 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%

'첫 구매 혜택
dim eventStartDate, eventEndDate, currentDate, LoginUserid, eCode
dim mktTest, vQuery, i, itemid(3), soldoutcheck

IF application("Svr_Info") = "Dev" THEN
    eCode = "103267"
    mktTest = true
    itemid(0) = "3324406"
    itemid(1) = "3297090"
    itemid(2) = "3218030"
    itemid(3) = "3801773"
ElseIf application("Svr_Info")="staging" Then
    eCode = "107535"
    mktTest = true
    itemid(0) = "4423212" '산리오 투명 키링
    itemid(1) = "4358392" '스누피 다꾸 스티커팩
    itemid(2) = "4404247" '스누피 담요
    itemid(3) = "4423211" '산리오 빅스티커
Else
    eCode = "107535"
    mktTest = false
    itemid(0) = "4423212" '산리오 투명 키링
    itemid(1) = "4358392" '스누피 다꾸 스티커팩
    itemid(2) = "4404247" '스누피 담요
    itemid(3) = "4423211" '산리오 빅스티커
End If

eventStartDate      = cdate("2020-11-18")		'이벤트 시작일
eventEndDate 	    = cdate("2022-12-31")		'이벤트 종료일(소진시 종료)
LoginUserid		    = getencLoginUserid()
if mktTest then
    '// 테스트용
    currentDate = cdate("2021-07-12")
else
    currentDate = date()
end if

%>
<style type="text/css">
.newBenefitGuide {position:relative;}
.newBenefitGuide .topic {position:relative;}
.newBenefitGuide .btn-member {position:absolute; left:0; top:46%; width:54vw; height:16vw;}
.newBenefitGuide .tab-benefit {width:100%; display:flex; background:#fff; z-index:10;}
.newBenefitGuide .tab-benefit div {position:relative; width:33.3%; text-align:center;}
.newBenefitGuide .tab-benefit a {display:inline-block; width:100%; padding:1.52rem 0; font-size:1.39rem; color:#a1a1a1; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold'}
.newBenefitGuide .tab-benefit a span {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.newBenefitGuide .tab-benefit a.on,
.newBenefitGuide .tab-benefit a.first_on {color:#121212;}
.newBenefitGuide .tab-benefit .on::before,
.newBenefitGuide .tab-benefit .first_on::before {content:""; width:100%; height:0.17rem; background:#ff214f; position:absolute; left:0; bottom:0;}
.newBenefitGuide .tab-benefit.fixed {position:fixed; left:0; top:0;}
.newBenefitGuide .tab-benefit.hides {display:none;}
.newBenefitGuide .sec-benefit {position:relative;}
.newBenefitGuide .first-benefit {display:flex; flex-wrap:wrap; width:100%; padding:0 2.60rem 5.87rem; background:#fff;}
.newBenefitGuide .first-benefit div {width:calc(50% - 0.69rem);}
.newBenefitGuide .first-benefit div:nth-child(odd) {margin-right:0.69rem;}
.newBenefitGuide .first-benefit div:nth-child(even) {margin-left:0.69rem;}
.newBenefitGuide .btn-push {width:54vw; height:16vw; position:absolute; left:0; top:74%; background:transparent;}
.newBenefitGuide .sec-benefit.coupon-pack {padding-bottom:5.87rem; background:#ff214f;}
.newBenefitGuide .btn-members {display:none; position:fixed; left:0; bottom:2.60rem; z-index:10;}
.newBenefitGuide .btn-members.on {display:block;}
.newBenefitGuide .item-area {position:absolute; right:2.82rem; bottom:4.78rem;}
.newBenefitGuide .item-area .thumb .item1,
.newBenefitGuide .item-area .thumb .item2,
.newBenefitGuide .item-area .thumb .item3,
.newBenefitGuide .item-area .thumb .item4 {width:40.53vw; transition: .5s ease-in;}
</style>
<script>
$(document).ready(function(){
    changingImg();
	function changingImg(){
		var i=1;
		var repeat = setInterval(function(){
			i++;
			if(i>4){i=1;}
            $('.newBenefitGuide .item-area .thumb img').attr('src','//fiximage.10x10.co.kr/web2021/memberGuide/m/img_item0'+ i +'.png?v=3.2').attr('class','item' + i);
            //console.log(i);
            /* if(i == 5) {
                clearInterval(repeat);
            } */

        },1200);
    }
    var didScrolls; 
    // 스크롤시에 사용자가 스크롤했다는 것을 알림 
    $(window).scroll(function(event){ 
        didScrolls = true; 
        //console.log('scroll1:'+didScrolls);
    }); // hasScrolled()를 실행하고 didScrolls 상태를 재설정 
    setInterval(function() { 
        if (didScrolls){
            hasScrolled();
            didScrolls = false;
            //console.log('scroll2:'+didScrolls);
        }
    }, 250);
    
    // 탭 클릭시 활성화
    $('.tab-benefit a').on('click',function(){
        if($(this).hasClass('on')) {
            $('.tab-benefit a').removeClass('on')
        } else {
            $('.tab-benefit a').removeClass('on')
            $(this).addClass('on')
        }
    });

    function hasScrolled() { // 동작을 구현 
    var lastScrollTop = 0; 
    var tabBenefitStart = $('.sec-benefit').offset().top - 120; // 동작의 구현이 시작되는 위치
    var tabBenefitEnd = $('.sec-recome').offset().top - 100; // 동작의 구현이 끝나는 위치
    var tabRemove = $('#benefit01').offset().top;
    var tabRemoveFirst = $('#benefit02').offset().top;
    var header = $('#header').height(); // 영향을 받을 요소를 선택

    // 접근하기 쉽게 현재 스크롤의 위치를 저장한다. 
    var st = $(this).scrollTop();
    if (st > tabBenefitStart){
        $('.tab-benefit').addClass('fixed').css('top',header);
        $('.btn-members').addClass('on');
        $('.tab-benefit .tab1 a').removeClass('first_on');
    } else {
        $('.tab-benefit').removeClass('fixed');
        $('.btn-members').removeClass('on');
        $('.tab-benefit .tab1 a').addClass('first_on');
    }

    if (st <= tabRemove) {
        $('.tab-benefit .tab1 a').addClass('first_on');
    }

    if (st >= tabRemoveFirst) {
        $('.tab-benefit .tab1 a').removeClass('first_on');
    }

    if(st > tabBenefitEnd){
        $('.tab-benefit').addClass('hides'); 
    }else { 
        $('.tab-benefit').removeClass('hides'); 
    }

    //스크롤시 특정위치서 탭 활성화
    var scrollPos = $(document).scrollTop();
    $('.tab-benefit a').each(function () {
        var currLink = $(this);
        var refElement = $(currLink.attr("href"));
        if (refElement.position().top <= scrollPos && refElement.position().top + refElement.height() >= scrollPos) {
            $('.tab-benefit a').removeClass("on");
            
            currLink.addClass("on");
        }
        else{
            currLink.removeClass("on");
        }
    });

}

});

function goDirOrdItem(ino) {
    <% If Not(IsUserLoginOK) Then %>
        <% if isApp=1 then %>
            calllogin();
            return false;
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
            return false;
        <% end if %>
    <% else %>
        <% If (currentDate >= eventStartDate And currentDate <= eventEndDate) Then %>    
            $.ajax({
                type:"GET",
                url:"/apps/appCom/wish/web2014/event/etc/doEventSubscript107535.asp",
                data: "mode=order&ino="+ino,
                dataType: "text",
                async:false,
                cache:true,
                success: function(resultData) {
                    var reStr = resultData.split("|");
                    if(reStr[0]=="OK"){
                        fnAmplitudeEventMultiPropertiesAction('click_event_buy','itemid',reStr[1])
                        $("#itemid").val(reStr[1]);
                        document.directOrd.submit();
                        return false;
                    }else if(reStr[0]=="Err"){
                        var errorMsg = reStr[1].replace(">?n", "\n");
                        alert(errorMsg);										
                    }			
                },
                error: function(err) {
                    console.log(err.responseText);
                }
            });
        <% Else %>
            alert("이벤트 응모 기간이 아닙니다.");
            return;
        <% End If %>        
    <% End IF %>
}

function popMemJoin() {
	fnAPPpopupBrowserURL("회원가입","<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp");
}

function fnMoveAPPInstall(){
    location.href="https://tenten.app.link/Chjht0BxQhb?%24deeplink_no_attribution=true";
}
</script>
<div class="newBenefitGuide">
    <div class="topic">
        <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_main.jpg" alt="지금 가입하면 귀여운 아이템이 500원부터">
        <!-- 상품이미지 순차 노출 -->
        <div class="item-area">
            <div class="thumb item1"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_item01.png?v=2.7" alt="item" class="item1"></div>
        </div>
        <% if isapp then %>
        <% If IsUserLoginOK Then %>
        <a href="" onclick="alert('이미 회원가입한 고객입니다.'); return false;" class="btn-member"></a>
        <% else %>
        <a href="" onclick="popMemJoin(); return false;" class="btn-member"></a>
        <% End IF %>
        <% else %>
        <a href="/member/join.asp" class="btn-member"></a>
        <% End IF %>
    </div>
    <div class="tab-benefit">
        <div class="tab1">
            <a href="#benefit01" class="first_on">첫 구매 <span>500</span>원</a>
        </div>
        <div class="tab2">
            <a href="#benefit02"><span>+3,000P</span></a>
        </div>
        <div class="tab3">
            <a href="#benefit03"><span>45,000</span>원 쿠폰</a>
        </div>
    </div>
    <div id="benefit01" class="sec-benefit">
        <h2><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/tit_benefit01.jpg" alt="텐바이텐에서의 특별한 첫 구매 혜택"></h2>
        <!-- for dev msg : APP설치하러 가기 mW 일때만 노출 -->
        <% if isapp then %>
        <% else %>
        <button type="button" onclick="fnMoveAPPInstall();"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_app.jpg" alt="APP 설치하러 가기"></button>
        <% end if %>
        <div class="first-benefit">
            <div>
                <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_itme04.jpg?v=3.2" alt="산리오 투명 키링">
                <% if isapp then %>
                    <% If getitemlimitcnt(itemid(0)) < 1 Then %>
                        <button type="button"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_soldout.jpg" alt="sold out"></button>
                    <% else %>
                        <button type="button" onclick="goDirOrdItem(1);return false;"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_buy.jpg" alt="바로 구매하기"></button>
                    <% end if %>
                <% end if %>
            </div>
            <div>
                <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_itme01.jpg?v=3.2" alt="스누피 다꾸 스티커팩">
                <% if isapp then %>
                    <% If getitemlimitcnt(itemid(1)) < 1 Then %>
                        <button type="button"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_soldout.jpg" alt="sold out"></button>
                    <% else %>
                        <button type="button" onclick="goDirOrdItem(2);return false;"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_buy.jpg" alt="바로 구매하기"></button>
                    <% end if %>
                <% end if %>
            </div>
            <div>
                <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_itme03.jpg?v=3.2" alt="스누피 담요">
                <% if isapp then %>
                    <% If getitemlimitcnt(itemid(2)) < 1 Then %>
                        <button type="button"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_soldout.jpg" alt="sold out"></button>
                    <% else %>
                        <button type="button" onclick="goDirOrdItem(3);return false;"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_buy.jpg" alt="바로 구매하기"></button>
                    <% end if %>
                <% end if %>
            </div>
            <div>
                <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_itme02.jpg?v=3.2" alt="산리오 빅스티커">
                <% if isapp then %>
                    <% If getitemlimitcnt(itemid(3)) < 1 Then %>
                        <button type="button"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_soldout.jpg" alt="sold out"></button>
                    <% else %>
                        <button type="button" onclick="goDirOrdItem(4);return false;"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_buy.jpg" alt="바로 구매하기"></button>
                    <% end if %>
                <% end if %>
            </div>
        </div>
        <form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
            <input type="hidden" name="itemid" id="itemid" value="">
            <input type="hidden" name="itemoption" value="0000">
            <input type="hidden" name="itemea" readonly value="1">
            <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
            <input type="hidden" name="isPresentItem" value="" />
            <input type="hidden" name="mode" value="DO3">
        </form>
    </div>
    <div id="benefit02" class="sec-benefit">
        <% if isapp then %>
        <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_benefit02.jpg" alt="가입만 해도 2,000p 즉시 지급!">
        <button type="button" class="btn-push" onclick="fnAPPpopupSetting();"></button>
        <% else %>
        <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_benefit02_mw.jpg" alt="가입만 해도 2,000p 즉시 지급!">
        <button type="button" class="btn-push" onclick="fnMoveAPPInstall();"></button>
        <% end if %>
    </div>
    <div id="benefit03" class="sec-benefit coupon-pack">
        <h2><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/tit_benefit03.jpg" alt="총 45,000원의 웰컴 쿠폰 팩까지!"></h2>
        <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_coupon01.jpg" alt="5,000원">
        <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_coupon02.jpg" alt="10,000원">
        <img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/img_coupon03.jpg" alt="30,000원">
    </div>
    <div class="sec-recome">
        <% server.Execute("/event/benefit/steady/exc_steady.asp") %>
    </div>
    <% If Not(IsUserLoginOK) Then %>
        <% if isapp then %>
            <a href="" onclick="popMemJoin(); return false;" class="btn-members"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_benefit.png" alt="지금 가입하고 혜택 받기"></a>
        <% else %>
            <a href="/member/join.asp" class="btn-members"><img src="//fiximage.10x10.co.kr/web2021/memberGuide/m/btn_benefit.png" alt="지금 가입하고 혜택 받기"></a>
        <% End IF %>
    <% end if %>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->