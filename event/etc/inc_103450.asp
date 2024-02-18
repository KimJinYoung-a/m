<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 여름에 뭐 입지?
' History : 2020-06-08 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate
IF application("Svr_Info") = "Dev" THEN
	eCode = "102182"
Else
	eCode = "103450"
End If

eventStartDate = cdate("2020-06-16")	'이벤트 시작일
eventEndDate = cdate("2020-06-23")		'이벤트 종료일
currentDate = date()
'currentDate = "2020-06-17"

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[여름에 뭐 입지?]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = " [여름에 뭐 입지?]"
Dim kakaodescription : kakaodescription = "올 여름 입고 싶은 옷을 20만 원 이상 고르면, 텐바이텐 그대로 쏩니다!"
Dim kakaooldver : kakaooldver = "올 여름 입고 싶은 옷을 20만 원 이상 고르면, 텐바이텐 그대로 쏩니다!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
[v-cloak] { display: none; }
.shpbag-evt {position:relative; background-color:#009dd0;}
.shpbag-evt button {width:100%; background-color:transparent;}
.shpbag-evt .topic {position:relative;}
.shpbag-evt .login {position:relative; color:#000; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; text-align:center;}
.shpbag-evt .login .inner {position:absolute; top:2.87rem; left:0; width:100%;}
.shpbag-evt .login .txt {font-size:1.38rem; line-height:1.54rem;}
.shpbag-evt .login .txt span {color:#000fd9;}
.shpbag-evt .login .price {margin-top:.44rem; line-height:1.2;}
.shpbag-evt .login .price span {font-size:1.71rem;}
.shpbag-evt .login .price span b {font-family:'CoreSansCBold'; color:#ec4800; font-size:2.56rem; vertical-align:-.2rem;}
.shpbag-evt .login .price:after {position:relative; top:-.1rem; display:inline-block; width:.8rem; height:.8rem; border-top:.18rem solid #ec4800; border-right:.18rem solid #ec4800; transform:rotate(45deg); content:'';}
.shpbag-evt .lyr {display:flex; align-items:center; overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.6);}
.shpbag-evt .lyr .inner {position:relative; width:32rem; margin:auto;}
.shpbag-evt .lyr .inner a {position:absolute; bottom:0; display:block; width:100%; height:5rem; text-indent:-999rem;}
.shpbag-evt .lyr .btn-close {display:inline-block; position:absolute; top:0; right:10%; width:13%; height:5rem; text-indent:-999em;}
.shpbag-evt .bnr-area {position:relative;}
.shpbag-evt .bnr-area a {display:block; position:absolute; top:0; left:0; width:100%; height:100%;}
.shpbag-evt .noti {background-color:#707070;}
.shpbag-evt .noti #btnNoti {position:relative;}
.shpbag-evt .noti #btnNoti:after {display:inline-block; position:absolute; top:50%; left:44.8%; width:.45rem; height:.45rem; margin-top:-.35rem; border-width:0 .13rem .13rem 0; border-color:#fff; border-style:solid; transform:rotate(45deg); content:'';}
.shpbag-evt .noti #notiCont {display:none;}
.shpbag-evt .noti.on #btnNoti:after {transform:rotate(-135deg);}
.shpbag-evt .noti.on #notiCont {display:block;}
.shpbag-evt .wish-list {background-color:#caf3ff; padding-bottom:3.84rem;}
.shpbag-evt .wish-list ul {display:flex; flex-wrap:wrap; width:32rem; margin:0 auto; padding:0 1.074rem;}
.shpbag-evt .wish-list li {flex-basis:50%; margin-top:1.28rem;}
.shpbag-evt .wish-list li:nth-child(1), .wish-list li:nth-child(2) {margin-top:0;}
.shpbag-evt .wish-list a {display:block; width:13.65rem; margin:0 auto;}
.shpbag-evt .wish-list .thumbnail {width:100%; height:13.65rem;}
.shpbag-evt .wish-list .desc {padding:.77rem .77rem 0 .77rem; background-color:#fff; color:#222;}
.shpbag-evt .wish-list .name {overflow:hidden; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; height:2.8rem; padding-right:0; font-size:1.15rem; line-height:1.26; text-overflow:ellipsis;}
.shpbag-evt .wish-list .price {margin:.77rem 0 .85rem; font-size:1.5rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; letter-spacing:-.02rem;}
.shpbag-evt .wish-list .unit {display:inline-block; margin:0 .54rem 0 .17rem; font-size:1.2rem;}
.shpbag-evt .wish-list .sale {color:#ff3232; font-size:1.28rem;}
.shpbag-evt .wish-list .btn-bag {position:relative; padding:.85rem 0 .85rem 0; border-top:solid #7fc8df .043rem; background-color:transparent; color:#0091c0; font-size:1.12rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.shpbag-evt .wish-list .btn-bag:after {display:inline-block; position:relative; top:-0.1rem; width:.45rem; height:.45rem; margin-left:.35rem; border-width:0 .13rem .13rem 0; border-color:#0091c0; border-style:solid; transform:rotate(-45deg); content:'';}
</style>
<script>
$(function(){
    $('.shpbag-evt .lyr .btn-close').click(function(){
        $(this).closest('.lyr').fadeOut();
	})

    // noti
    $('#btnNoti').click(function (e) { 
        e.preventDefault();
        $('.noti').toggleClass('on');
    });
    
    <% If IsUserLoginOK() Then %>
        getCartTotalAmount();
    <% end if %>
})

var isApp = "<%=isapp%>"
var isApply = false
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
            url:"/event/etc/doeventsubscript/do_103450.asp",
            data: {
                mode: 'add'
            },
            success: function(data){
                if(data.response == 'ok'){
                    fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')                        
                    isApply = true
                    $("#btnImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/103450/m/btn_comp.jpg")
                    $('.lyr').show();		
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
        url:"/event/etc/doeventsubscript/do_103450.asp",
        data: {
            mode: 'cart'
        },
        success: function(data){
            if(data.response == 'ok'){
                (data.cartTotalAmount < 200000) ? $("#act1").show() : $("#act2").show() ;
                (data.cartTotalAmount > 0) ? $("#totalAmount").text(data.cartTotalAmount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")) : $("#totalAmount").text("0");
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
    $(".lyr").css("display") != "none" ? $(".lyr").hide() : "";
    
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
</script>
<div class="shpbag-evt mEvt103450">
    <div class="topic">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/tit_summer.jpg" alt="여름에 뭐 입지">
        <% if not IsUserLoginOK() then %>
        <div class="logout"><a href="javascript:jsEventLogin()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_login_bfr.jpg" alt="로그인하고 확인하기"></a></div>
        <% else %>
        <div class="login">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_login_aftr.jpg" alt="장바구니 금액">
            <div class="inner">
                <div class="txt"><span><%=GetLoginUserName()%>님</span>의 장바구니 금액</div>
                <div class="price" onclick=<%=chkiif(isapp,"fnAPPpopupBaguni()","gotoCart()")%>><span><b id="totalAmount"></b> 원 </span></div>
            </div> 
        </div>
        <% end if %>
        <% if subscriptcount > 0 then %>
        <div class="btn-area"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/btn_comp.jpg" alt="응모완료"></div>
        <% else %>
        <div class="btn-area" style="display:none;" id="act1" onclick="doAction()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/btn_submit_off.jpg" alt="응모하기 비활성화"></div>
        <button class="btn-area btn-submit" onclick="doAction()" id="act2" style="display:none;"><img id="btnImg" src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/btn_submit_on.jpg" alt="응모하기 활성화"></button>
        <% end if %>
        <%'!-- 팝업레이어 --%>
        <div class="lyr" style="display:none;">
            <div class="inner">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/pop_txt.png" alt="20만원 상품 담기 성공!"></p>
                <button class="share" onclick="snschk('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/pop_share.png" alt="친구들에게  이벤트 소식 알려주기!"></button>
                <button class="btn-close"></button>
            </div>
        </div>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/txt_way.jpg?v=1.01" alt="참여 방법"></div>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_prize_v2.jpg?v=1.01" alt="당첨상품"></div>
        <button class="share" onclick="snschk('ka')"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_bnr1.jpg" alt="친구들에게  이벤트 소식 알려주기!"></button>
        <div class="bnr-area">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_bnr2.jpg" alt="판도라특가전">
            <a href="/event/eventmain.asp?eventid=102776" target="_blank" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102776');" target="_blank" class="mApp"></a>
        </div>
        <% if currentdate >= "2020-06-18" Then %>
        <div class="bnr-area">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/img_bnr3.jpg" alt="여름의시작">
            <a href="/event/eventmain.asp?eventid=102902" target="_blank" class="mWeb"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102902');" target="_blank" class="mApp"></a>
        </div>
        <% End If %>
        <div class="noti">
            <button id="btnNoti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/tit_noti.png" alt="유의사항"></button>
            <div id="notiCont"><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/txt_noti.png" alt="유의사항"></div>
        </div>
        <%'!-- 위시리스트 --%>
        <div class="wish-list">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/103450/m/tit_wish.jpg" alt="다른 사람들은 어떤 상품을 담았을까?"></p>
            <div id="wishlist" v-cloak></div>
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
<script src="/vue/wish/components/wishlist_103450.js?v=1.00"></script>
<script src="/vue/wish/view/index_103450.js?v=1.00"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->