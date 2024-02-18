<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마니또 장바구니 이벤트
' History : 2020-05-19 이종화
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
	eCode = "102170"
Else
	eCode = "102808"
End If

eventStartDate = cdate("2020-05-19")	'이벤트 시작일
eventEndDate = cdate("2020-05-26")		'이벤트 종료일
currentDate = date()

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[마니또가 대신 결제해드립니다]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = " [마니또가 대신 결제해드립니다]"
Dim kakaodescription : kakaodescription = "20만원 이상 상품을 장바구니에 담으면 마니또가 대신 결제해드립니다!"
Dim kakaooldver : kakaooldver = "20만원 이상 상품을 장바구니에 담으면 마니또가 대신 결제해드립니다!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
[v-cloak] { display: none; }
.mEvt102808 {position:relative; background-color:#309ae3;}
.topic {position:relative;}
.mem {position:relative; color:#fff; text-align:center;}
.mem .pos {position:absolute; top:1.83rem; left:0; width:100%;}
.mem .txt {height:2rem; font-size:1.49rem;}
.mem .txt span {color:#11ff33;}
.mem .txt span b {font-weight:normal;}
.mem .price {height:3.5rem; line-height:1.2;}
.mem .price span {font-size:1.8rem;}
.mem .price span b {font-family:'CoreSansCBold'; font-size:2.56rem; vertical-align:-.2rem;}
.mem .price img {width:.8rem; margin-left:.5rem; vertical-align:baseline;}
.mem p {margin-top:2rem;}
.btn-submit {width:100%;}
.lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; padding-top:5vh; background:rgba(0,0,0,.9);}
.lyr .inner {position:relative; width:32rem; margin:auto;}
.lyr .inner a {position:absolute; bottom:0; display:block; width:100%; height:5rem; text-indent:-999rem;}
.lyr .btn-close {display:inline-block; position:absolute; top:-4vw; right:0; width:15vw; height:15vw; background-color:transparent;}
.share {position:relative;}
.share .pos {display:flex; position:absolute; bottom:24%; left:5%; width:90%;}
.share .pos button,
.share .pos a {padding-bottom:18%; text-indent:-999rem; background-color:transparent;}
.share .pos button {width:25%;}
.share .pos a {width:50%;}
.bnr-area ul li {position:relative;}
.bnr-area ul li a {position:absolute; top:0; left:0; width:100%; height:100%;}
.wish-list {background-color:#ddf1ff;}
.wish-list .items {background:transparent;}
.wish-list ul {display:flex; flex-wrap:wrap; width:29.87rem; margin:0 auto;}
.wish-list li {flex-basis:50%; padding:0 .64rem; margin-top:1.28rem;}
.wish-list li:nth-child(1),
.wish-list li:nth-child(2) {margin-top:0;}
.wish-list .thumbnail {width:13.65rem;}
.wish-list .desc {padding:.77rem .77rem 0 .77rem; background-color:#fff; color:#222;}
.wish-list .name {overflow:hidden; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; height:2.8rem; padding-right:0; font-size:1.15rem; line-height:1.26; text-overflow:ellipsis;}
.wish-list .price {margin:.77rem 0 .85rem; font-size:1.5rem; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium'; letter-spacing:-.02rem;}
.wish-list .unit {display:inline-block; margin:0 .54rem 0 .17rem; font-size:1.2rem;}
.wish-list .sale {color:#ff3232; font-size:1.28rem;}
.wish-list .btn-bag {position:relative; width:100%; padding:.85rem 1.28rem .95rem 0; border-top:solid #99cef1 .043rem; background-color:transparent; color:#349de4; font-size:1.1rem;}
.wish-list .btn-bag:after {display:inline-block; position:absolute; top:50%; right:2rem; width:.55rem; height:.55rem; margin-top:-.3rem; border-width:0 .043rem .043rem 0; border-color:#349de4; border-style:solid; transform:rotate(-45deg); content:'';}
</style>
<script>
$(function(){
    $('.lyr .btn-close').click(function(){
        $(this).closest('.lyr').fadeOut();
    })
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
                url:"/event/etc/doeventsubscript/doEventSubScript102808.asp",
                data: {
                    mode: 'add'
                },
                success: function(data){
                    if(data.response == 'ok'){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')                        
                        isApply = true
                        $("#btnImg").attr("src", "//webimage.10x10.co.kr/fixevent/event/2020/102808/m/btn_comp.jpg")
                        $('.lyr-fin').show();		
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
        url:"/event/etc/doeventsubscript/doEventSubScript102808.asp",
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
</script>
<div class="mEvt102808">
    <div class="topic">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/tit_manito.jpg" alt="마니또가 대신 결제해드립니다">
        <% if not IsUserLoginOK() then %>
        <div class="box non"><a href="javascript:jsEventLogin()"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_login_bfr.jpg" alt="로그인하고 확인하기"></a></div>
        <% else %>
        <div class="box mem">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_login_aftr.jpg" alt="장바구니 금액">
                <div class="pos">
                    <div class="txt">
                        <span><b><%=GetLoginUserName()%></b>님</span>의 장바구니 금액
                    </div>
                    <div class="price" onclick=<%=chkiif(isapp,"fnAPPpopupBaguni()","gotoCart()")%>>
                        <span><b id="totalAmount"><%= FormatNumber(getCartTotalAmount(userid), 0) %></b> 원 </span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/ico_arrow.png" alt="">
                    </div>
                </div> 
            </div>
        </div>
        <% end if %>
        <% if subscriptcount > 0 then %>
        <div class="btn-area"><a href="javascript:alert('이미 응모 완료되었습니다. 5월 27일 당첨일을 기다려주세요!');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/btn_comp.jpg" alt="응모완료"></a></div>
        <% else %>
        <button class="btn-area btn-submit" onclick="doAction()"><img id="btnImg" src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/btn_submit_on.jpg" alt="응모하기 활성화"></button>
        <% end if %>
        <!-- 팝업레이어 -->
        <div class="lyr lyr-fin" style="display:none;">
            <div class="inner">
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/pop_txt.png" alt="20만원 상품 담기 성공!"></p>
                <a href="/justsold/index.asp?gnbflag=1" class="mWeb">방금판매된상품구경해보세요!</a>
                <a href="#" onclick="fnAPPselectGNBMenu('justsold','http://m.10x10.co.kr/apps/appCom/wish/web2014/justsold/index.asp?gnbflag=1'); return false;" class="mApp">방금판매된상품구경해보세요!</a>
                <button class="btn-close"></button>
            </div>
        </div>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/txt_way.jpg?v=1.01" alt="참여 방법"></div>
        <div><img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_prize.jpg" alt="gift card 200,000원"></div>
        <%'!-- 공유 --%>
        <div class="share">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_bnr1.jpg" alt="">
            <div class="pos">
                <button class="btn-sns" onclick="snschk('fb')">페이스북으로 공유하기</button>
                <button class="btn-sns" onclick="snschk('ka')">카카오톡으로 공유하기</button>
                <a href="/event/eventmain.asp?eventid=97629" target="_blank" class="mWeb">push 신청하기</a>
                <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97629');" target="_blank" class="mApp">push 신청하기</a>
            </div>
        </div>
        <%'!-- 배너 --%>
        <div class="bnr-area">
            <ul>
                <li>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_bnr2.jpg" alt="주방까지 귀여워지는 스누피 키친 라인">
                    <a href="/event/eventmain.asp?eventid=102358" target="_blank" class="mWeb"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102358');" target="_blank" class="mApp"></a>
                </li>
                <li>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_bnr3.jpg" alt="핸드폰 케이스 바꾸면 기분이 좋아져  ">
                    <a href="/event/eventmain.asp?eventid=102582" target="_blank" class="mWeb"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=102582');" target="_blank" class="mApp"></a>
                </li>
                <li>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_bnr4.jpg" alt="4만원 이상 생애 첫 결제 시 5,000원 할인!">
                </li>
            </ul>
        </div>
        <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/img_noti.jpg" alt="유의사항"></div>
        <%'!-- 위시리스트 --%>
        <div class="wish-list">
            <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102808/m/tit_wish.jpg" alt="다른 사람들은 어떤 상품을 담았을까?"></p>
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
<script src="/vue/wish/components/wishlist_98974.js?v=1.01"></script>
<script src="/vue/wish/view/index_98974.js?v=1.01"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->