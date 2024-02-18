<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 귀여움 저장소 이벤트
' History : 2021.04.29 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
dim currentDate, eventStartDate, eventEndDate
dim eCode, userid, mktTest, subscriptcount, sqlstr, myTeaSet

IF application("Svr_Info") = "Dev" THEN
	eCode = "105352"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "110972"
    mktTest = true    
Else
	eCode = "110972"
    mktTest = false
End If

if mktTest then
    currentDate = #05/03/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-05-03")		'이벤트 시작일
eventEndDate = cdate("2021-05-16")		'이벤트 종료일

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink
snpTitle	= Server.URLEncode("[귀여움 저장소 이벤트]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/110972/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[귀여움 저장소 이벤트]"
Dim kakaodescription : kakaodescription = "귀여운 건 못 참지. 귀여운 것만 모으고 기프트카드를 받아가세요!"
Dim kakaooldver : kakaooldver = "귀여운 건 못 참지. 귀여운 것만 모으고 기프트카드를 받아가세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/110972/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt110972{position: relative;overflow: hidden;}
.mEvt110972 .topic{position: relative;}
.mEvt110972 .ani-txt{position: absolute;top: 0;animation: fade-in-top 1s linear both;width: 100%;}
.mEvt110972 .cont-how li{position: relative;}
.mEvt110972 .cont-how li button{width: 100%;}
.mEvt110972 .cont-how li.ani-box{width: 100%;}
.mEvt110972 .cont-how li .ani-heart{position:absolute;display: block}
.mEvt110972 .cont-how li .ani-heart.active{background-image: url('//webimage.10x10.co.kr/fixevent/event/2021/110972/m/txt_wish_1_off.jpg');;background-size: 100%;
width: 100%;height: 20rem;top: 0;left: 0;background-position: center top;text-indent: -9999px;z-index: 10;}
@keyframes fade-in-top {
    from {transform: translateY(-50px);opacity: 0;}
  to {transform: translateY(0);opacity: 1;}
}
.mEvt110972 .cont-wish {position:relative; padding-bottom:10vw; background:#fff;}
.mEvt110972 .cont-wish ul {overflow:hidden; margin:0 6.5vw;}
.mEvt110972 .cont-wish li {float:left; width:50%;}
.mEvt110972 .cont-wish li a {display:block; margin:0.67vw;}

/* popup */
.layer-pop {position: fixed;left: 0;top: 0;bottom: 0;width: 100vw;height: 100vh;z-index: 200;display: none;overflow-y: auto;}
.layer-pop .bg {position: fixed;left: 0;top: 0;width: 100vw;height: 100vh;z-index: 1;background: #000;opacity: 0.6;-ms-filter: 'progid:DXImageTransform.Microsoft.Alpha(Opacity=60)';filter: alpha(opacity=60);}
.layer-pop .pop-in {width: 100%;position: relative;width: 100%;height: 100%;padding: 5rem 2.56rem;overflow-y: scroll;z-index: 2;}
.layer-pop .pop-cont{position: relative;width: 100%;height: 100%;}
.layer-pop .pop-in .close-pop {position: absolute;right: 1.70rem;top: 1.70rem;z-index: 40;width: 1.8rem;height: 1.8rem;background: url('//webimage.10x10.co.kr/fixevent/event/2021/110972/m/btn_close.png')no-repeat;background-size:cover;text-indent: -9999px;}
.layer-pop .pop-in .btn-apply{background:transparent;width: 100%;}
</style>
<script>
$(function () {
    // 하트 on/off 
    function ani_heart() {
        $('.ani-heart').toggleClass('active');
    }
    setInterval(ani_heart, 700);
    // layerpop close
    $('.close-pop').on('click', function () {
        $('.layer-pop').fadeOut();
    });
});

var numOfTry="<%=subscriptcount%>";
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
    <% If IsUserLoginOK() Then %>
        if(numOfTry == "1"){
			alert("이미 신청하셨습니다! 위시에 상품을 5개 이상 담으셨다면 자동으로 응모됩니다.");
			return false;
		};
        $.ajax({
            type: "POST",
            url:"/event/etc/doeventsubscript/doEventSubscript110972.asp",
            data: {
                mode: 'add'
            },
            dataType: "JSON",
            success: function(data){
                if(data.response == "ok"){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')
                    $('.layer-pop').fadeIn();
                }else if(data.response == "retry"){
                    alert("이미 신청하셨습니다! 위시에 상품을 5개 이상 담으셨다면 자동으로 응모됩니다.");
                }
            },
            error: function(data){
                alert('시스템 오류입니다.');
            }
        })
    <% else %>
        <% if isApp="1" then %>
            calllogin();
        <% else %>
            jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
        <% end if %>
        return false;
    <% end if %>
}

function fnGoToWishlist(){
    var offset = $("#wishlist").offset();
    $('html, body').animate({scrollTop : offset.top}, 400);
    $('.layer-pop').fadeOut();
}

function snschk(snsnum) {		
    if(snsnum=="fb"){
        <% if isapp then %>
        fnAPPShareSNS('fb','<%=appfblink%>');
        return false;
        <% else %>
        popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
        <% end if %>
    }else{
        <% if isapp then %>		
            fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
            return false;
        <% else %>
            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
        <% end if %>
    }		
}

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}
</script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.7.4/lottie_svg.min.js"></script>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<script src="https://unpkg.com/vuex"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% Else %>
<script src="/vue/2.5/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<script src="/vue/vuex.min.js"></script>
<% End If %>
<div class="mEvt110972">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/tit_topic.jpg" alt="귀여움 페스티벌"></h2>
        <span class="ani-txt"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/ani_cute.png" alt="귀여움 저장소"></span>
    </div>

    <div class="cont-how">
    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/tit_how.jpg" alt="참여방법"></h3>
        <ul>
            <li>
                <button type="button" class="btn-popopen" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/btn_try.jpg" alt="참여하기"></button>
            </li>
            <li class="ani-box">
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/txt_wish_1_on.jpg" alt="">
                <span class="ani-heart">좋아요</span>
            </li>
            <li>
                <img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/txt_wish_2.jpg" alt="응모 완료!">
            </li>
        </ul>
    </div>

    <div class="cont-btns">
        <ul>
            <!--<li><a href="/event/eventmain.asp?eventid=110936" onclick="jsEventlinkURL(110936);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/btn_see.jpg" alt="귀여운 페스티벌 구경하기"></a></li> -->
            <li>
                <button type="button" onclick="snschk('ka');">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/btn_kakao.jpg" alt="친구에게도 알려줄래요!">
                </button>
            </li>
        </ul>
    </div>

    <div class="cont-notice">
        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/txt_notice.jpg" alt="유의사항">
    </div>

    <div class="cont-wish" id="wishlist">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/tit_wishlist.jpg" alt="다른 사람들의 지금 위시 폴더에는 무엇이 있을까 ?"></h3>
        <div id="app"></div>
    </div>

    <!-- 신청팝업 -->
    <div class="layer-pop apply">
        <div class="bg"></div>
            <div class="pop-in">
                <div class="pop-cont">
                    <button type="button" class="close-pop">닫기</button>
                    <button type="button" class="btn-apply" onclick="fnGoToWishlist();">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110972/m/pop_apply.png" alt="담으러가기">
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/event/etc/vue_110972.js?v=1.01"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->