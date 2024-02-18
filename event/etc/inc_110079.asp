<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마니또 장바구니 이벤트
' History : 2021-03-17 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate, mktTest
IF application("Svr_Info") = "Dev" THEN
	eCode = "104328"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "110079"
    mktTest = true
Else
	eCode = "110079"
    mktTest = false
End If

eventStartDate = cdate("2021-03-22")	'이벤트 시작일
eventEndDate = cdate("2021-03-28")		'이벤트 종료일
if mktTest then
currentDate = cdate("2021-03-22")
else
currentDate = date()
end if

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[당신의 마니또가 쏜다!]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[당신의 마니또가 쏜다!]"
Dim kakaodescription : kakaodescription = "받고 싶은 상품을 30만 원 고르면, 마니또가 대신 결제해준대요!"
Dim kakaooldver : kakaooldver = "받고 싶은 상품을 30만 원 고르면, 마니또가 대신 결제해준대요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/110079/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt110079 {position:relative; background-color:#309ae3;}
.mEvt110079 .topic {position:relative;}
.mEvt110079 .topic .box-logout {width:80.66vw; position:absolute; left:50%; top:65%; transform:translate(-50%,0);}
.mEvt110079 .topic .box-logout a {display:inline-block; width:100%; height:100%;}
.mEvt110079 .topic .box-login {width:82vw; position:absolute; left:50%; top:65%; transform:translate(-50%,0);}
.mEvt110079 .topic .box-login .inner-info {position:relative; color:#fff; text-align:center;}
.mEvt110079 .topic .box-login .pos {position:absolute; top:2.2rem; left:0; width:100%;}
.mEvt110079 .topic .box-login .txt {height:2rem; font-size:1.73rem;}
.mEvt110079 .topic .box-login .txt span {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt110079 .topic .box-login .txt span b {color:#fff440; }
.mEvt110079 .topic .box-login .price {display:flex; align-items:center; justify-content:center; height:3.5rem; margin-top:0.8rem; line-height:1.2;}
.mEvt110079 .topic .box-login .price span {display:flex; align-items:center; justify-content:center; font-size:3.13rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mEvt110079 .topic .box-login .price img {width:.8rem; margin-left:1rem; vertical-align:baseline;}
.mEvt110079 .topic .box-login .go-link {display:inline-block; width:100%; height:100%;}
.mEvt110079 .topic button {width:66.4vw; position:absolute; left:50%; bottom:6%; transform:translate(-50%,0); background:transparent;}
.mEvt110079 .topic button.apply-off {pointer-events:none;}

.mEvt110079 .event-info {position:relative;}
.mEvt110079 .event-info .icon-num {position:absolute; right:8%; bottom:26%; width:16.13vw; animation:updown 1s ease-in-out alternate infinite;}

.mEvt110079 .noti .btn-noti {position:relative;}
.mEvt110079 .noti .hidden-noti {display:none;}
.mEvt110079 .noti .hidden-noti.on {display:block;}
.mEvt110079 .noti .icon {position:absolute; left:70%; top:50%; width:3.33vw; height:1.86vw; transform:rotate(180deg);}
.mEvt110079 .noti .icon.on {transform:rotate(0);}

.mEvt110079 .share {position:relative;}
.mEvt110079 .share .pos {display:flex; position:absolute; bottom:24%; left:5%; width:90%;}
.mEvt110079 .share .pos button,
.mEvt110079 .share .pos a {padding-bottom:18%; text-indent:-999rem; background-color:transparent;}
.mEvt110079 .share .pos button {width:25%;}
.mEvt110079 .share .pos a {width:50%;}
.mEvt110079 .bnr-area ul li {position:relative;}
.mEvt110079 .bnr-area ul li a {position:absolute; top:0; left:0; width:100%; height:100%;}

.mEvt110079 .wish-list {padding-bottom:3rem; background-color:#fff;}
.mEvt110079 .wish-list .items {background:transparent;}
.mEvt110079 .wish-list ul {display:flex; flex-wrap:wrap; width:29.87rem; margin:0 auto;}
.mEvt110079 .wish-list li {flex-basis:50%; margin-top:3.04rem;}
.mEvt110079 .wish-list li:nth-child(1),
.mEvt110079 .wish-list li:nth-child(2) {margin-top:0;}
.mEvt110079 .wish-list .thumbnail {height:13.4rem; margin:0 0.77rem; overflow:hidden;}
.mEvt110079 .wish-list .desc {padding:.77rem .77rem 0 .77rem; background-color:#fff; color:#222;}
.mEvt110079 .wish-list .name {overflow:hidden; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; height:2.8rem; padding-right:0; font-size:1.19rem; line-height:1.26; text-overflow:ellipsis; color: var(--c_111); font-family: var(--md);}
.mEvt110079 .wish-list .price {display:flex; align-items:center; margin:.77rem 0 .85rem; font-size:1.5rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; letter-spacing:-.02rem;}
.mEvt110079 .wish-list .unit {display:inline-block; margin:0 .54rem 0 .17rem; font-size:1.2rem;}
.mEvt110079 .wish-list .sale {color:#ff3232; font-size:1.28rem;}
.mEvt110079 .wish-list .btn-bag {position:relative; width:100%; background:transparent;}

.mEvt110079 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt110079 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt110079 .pop-container .pop-inner a {display:inline-block;}
.mEvt110079 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110079/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt110079 .pop-container .pop-contents {position:relative;}
.mEvt110079 .pop-container .pop-contents .btn-share {width:100%; height:27rem; position:absolute; left:0; bottom:0; background:transparent;}
@keyframes updown {
    0% {transform: translateY(-5%);}
    100% {transform: translateY(10%);}
}
</style>
<script>
$(function(){
    $(".btn-noti").on("click",function(){
        $(".hidden-noti").toggleClass("on");
        $(".btn-noti > .icon").toggleClass("on");
    });
    //팝업
    /* 팝업 닫기 */
    $('.mEvt110079 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});

var isApp = "<%=isapp%>";
var isApply = false;
function jsEventLogin() {
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}
function doAction() {
    if(isApply) return false;
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
    <% end if %>
    <% If IsUserLoginOK() Then %>
            $.ajax({
                type: "POST",
                url:"/event/etc/doeventsubscript/doEventSubScript110079.asp",
                data: {
                    mode: 'add'
                },
                success: function(data){
                    if(data.response == 'ok'){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')                        
                        isApply = true
                        $('.pop-container.apply').fadeIn();		
                    }else{
                        alert(data.message);
                    }
                },
                error: function(data){
                    alert('시스템 오류입니다.');
                }
            })
    <% else %>
        jsEventLogin();
    <% end if %>
}
function getCartTotalAmount(){
    $.ajax({
        type: "GET",
        url:"/event/etc/doeventsubscript/doEventSubScript110079.asp",
        data: {
            mode: 'cart'
        },
        success: function(data){
            if(data.response == 'ok'){
                $("#totalAmount").text(data.cartTotalAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","))
            }else{
                alert(data.message)
            }
        },
        error: function(data){
            alert('시스템 오류입니다.')
        }
    })    
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
function fnsbagly(){
    
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

function gotoCart() {
    location.href = "/inipay/ShoppingBag.asp"
}

function jsPickingUpPushSubmit(){

    fnAmplitudeEventMultiPropertiesAction('click_event_apply','eventcode|actype','<%=ecode%>|alarm','');

    <% If not(IsUserLoginOK) Then %>
        parent.calllogin();
        return false;
    <% end if %>

    $.ajax({
        type:"GET",
        url:"/event/etc/doeventsubscript/doEventSubScript110079.asp?mode=pushadd&evt_code=<%=eCode%>",
        dataType: "json",
        success : function(result){
            if(result.response == "ok"){
                alert('신청 되었습니다.')
				//$('.lyr-alarm').fadeIn();
                return false;
            }else{
                alert(result.faildesc);
                return false;
            }
        },
        error:function(err){
            console.log(err);
            return false;
        }
    });
}
</script>
			<div class="mEvt110079">
				<div class="topic">
					<img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/img_main.jpg" alt="마니또가 대신 결제해드립니다">
					<% if not IsUserLoginOK() then %>
                    <div class="box-logout"><a href="javascript:jsEventLogin()"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/btn_logout.png" alt="로그인하고 확인하기"></a></div>
                    <% else %>
					<!--로그인시-->
					<div class="box-login">
                        <div class="inner-info">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/btn_login.png" alt="장바구니 금액">
                            <div class="pos">
                                <div class="txt">
                                    <span><b><%=GetLoginUserName()%></b>님</span>의 장바구니 금액
                                </div>
                                <!-- 클릭시 장바구니 페이지로 랜딩 -->
                                <a href="#"  onclick=<%=chkiif(isapp,"fnAPPpopupBaguni()","gotoCart()")%> class="go-link">
                                    <div class="price">
                                        <span><b id="totalAmount"><%= FormatNumber(getCartTotalAmount(userid), 0) %></b> <span>원</span></span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/ico_arrow.png" alt="">
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                    <% end if %>
                    <% if subscriptcount > 0 then %>
                    <button type="button" class="apply-off" disabled="disabled" onclick="alert('이미 응모 완료되었습니다. 3월 31일 당첨일을 기다려주세요!');"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/btn_apply_done.png" alt="응모완료"></button>
                    <% else %>
                    <button type="button" class="btn-apply" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/btn_apply.png" alt="응모하기"></button>
                    <% end if %>
                </div>
				<div class="event-info">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/img_sub01.jpg" alt="참여 방법">
                    <div class="icon-num"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/icon_num.png" alt="10명"></div>
                </div>
                <div class="share">
                    <a href="" onclick="snschk('ka');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/img_link01.jpg" alt="이벤트 소식 공유하기"></a>
                    <a href="" onclick="jsPickingUpPushSubmit();return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/img_link02.jpg" alt="push 신청하기"></a>
                </div>
                <div class="noti">
                    <button type="button" class="btn-noti">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/img_noti_top.jpg" alt="유의사항 제목">
                        <div class="icon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/icon_arrow.png" alt=""></div>
                    </button>
                    <div class="hidden-noti">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/img_noti.jpg" alt="유의사항 내용">
                    </div>
                </div>
                <!-- 위시리스트 -->
                <div class="wish-list">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/tit_wish.jpg" alt="다른 사람들은 어떤 상품을 담았을까?"></p>
                    <div id="wishlist" v-cloak></div>
                </div>
                <!-- 팝업 - 응모완료 -->
                <div class="pop-container apply">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110079/m/pop_done.png" alt="30만 원 담기 성공!">
                            <button type="button" class="btn-share" onclick="snschk('ka');return false;"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
			</div>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
    <input type="hidden" name="mode" value="add" />
    <input type="hidden" name="itemid" value="" />
    <input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
    <input type="hidden" name="itemoption" value="0000" />
    <input type="hidden" name="itemea" readonly value="1" />    
</form>
<iframe src="" name="iiBagWin" frameborder="0" width="0" height="0" style="display:none"></iframe>
<% IF application("Svr_Info") = "Dev" THEN %>
<script src="https://unpkg.com/vue"></script>
<% Else %>
<script src="/vue/vue.min.js"></script>
<script src="/vue/vue.lazyimg.min.js"></script>
<% End If %>
<script src="/vue/wish/components/wishlist_110079.js?v=1.01"></script>
<script src="/vue/wish/view/index_110079.js?v=1.01"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->