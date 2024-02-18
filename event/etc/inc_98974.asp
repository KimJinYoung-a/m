<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 크리스마스 선물 주세요
' History : 2019-11-26 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currentDate , subscriptcount , eventStartDate , eventEndDate, moECode
IF application("Svr_Info") = "Dev" THEN
	eCode = "90432"
    moECode = "90433"
Else
	eCode = "98974"
    moECode = "98975"
End If

If isapp <> "1" Then 
	Response.redirect "/event/eventmain.asp?eventid="& moECode
	Response.End
End If

eventStartDate = cdate("2019-11-26")	'이벤트 시작일
eventEndDate = cdate("2019-12-15")		'이벤트 종료일
currentDate = date()

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
end if
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[크리스마스 선물 주세요!]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/98974/kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = "[크리스마스 선물 주세요!]"
	Dim kakaodescription : kakaodescription = "100만 원 이상 받고 싶은 상품을 고르면, 텐바이텐이 대신 결제해드립니다!"
	Dim kakaooldver : kakaooldver = "100만 원 이상 받고 싶은 상품을 고르면, 텐바이텐이 대신 결제해드립니다!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/98974/kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
[v-cloak] { display: none; }
.mEvt98974 {position: relative; background-color: #19243a;}
.mEvt98974 .topic {position: relative;}
.mEvt98974 .topic .ani-move span {position: absolute; top: 0; left: 0; animation:star 2s ease-in infinite;}
.mEvt98974 .topic .ani-move span:nth-child(2) {animation-delay: .7s;}
.mEvt98974 .topic .bounce {position: absolute; top: 46%; right: 6%; width: 22.4%; animation:bounce .7s 20;}
.mEvt98974 .topic .pos {position: absolute; top: 80%; width: 100%;}
.mEvt98974 .topic .pos .mem {color: #fff; text-align: center;}
.mEvt98974 .topic .pos .mem .txt {height: 2rem; font-size: 1.49rem;}
.mEvt98974 .topic .pos .mem .txt span {color: #11ff33; }
.mEvt98974 .topic .pos .mem .txt span b {font-weight: normal;}
.mEvt98974 .topic .pos .mem .price {height: 3.5rem; line-height: 1.2;}
.mEvt98974 .topic .pos .mem .price span {font-size: 1.8rem;}
.mEvt98974 .topic .pos .mem .price span b {font-family: 'CoreSansCBold'; font-size: 2.56rem; vertical-align: -.2rem;}
.mEvt98974 .topic .pos .mem .price img {width: 1rem; vertical-align: baseline; }
.mEvt98974 .topic .pos .mem p {margin-top:2rem;}
.mEvt98974 .btn-sign {width: 100%;}
.mEvt98974 .share {position: relative;}
.mEvt98974 .share .pos {position: absolute; display: flex; bottom: 17%; left: 5%; width: 90%;}
.mEvt98974 .share .pos button,.share .pos a {padding-bottom: 18%; text-indent: -999rem; background-color:transparent;}
.mEvt98974 .share .pos button {width: 25%;}
.mEvt98974 .share .pos a {width: 50%;}
.mEvt98974 .items ul {display: flex; width: 29.02rem; margin: 0 auto; flex-wrap: wrap;}
.mEvt98974 .items li {width: 13.65rem; margin: 1.4rem .43rem 0;}
.mEvt98974 .items li .name {font-size: 1.13rem; line-height: 1.4;}
.mEvt98974 .items li .price .sum {font-size: 1.33rem; font-family: 'CoreSansCBold';}
.mEvt98974 .items li .price .sum .won {font-size: 1.13rem; font-family: 'CoreSansCMedium';}
.mEvt98974 .items li .price .discount.color-red {margin-right: .3rem;}
.mEvt98974 .items li .btn-cart {margin-top: 1rem; }
.mEvt98974 .lyr {overflow-y:scroll; position:fixed; top:0; left:0; z-index:100; width:100vw; height:100vh; background:rgba(0,0,0,.9);}
.mEvt98974 .lyr .inner {position: relative; width: 32rem; margin: auto;}
.mEvt98974 .lyr .btn-close {position: absolute; top: 0; right: 0; width: 5rem; height: 5rem; background-color: transparent;}
.mEvt98974 .lyr .inner a {position: absolute; bottom: 0; display: block; width: 100%; height: 8rem; text-indent: -999rem;}
@keyframes star {
    50%{opacity: 0;}
}
@keyframes bounce {
    from to {transform:translateY(0);}
    50% {transform:translateY(-10px);}
}
</style>
<script type="text/javascript">
$(function(){
    $('.lyr .btn-close').click(function(){
        $(this).closest('.lyr').fadeOut();
    })
})
</script>
<script>
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
                url:"/event/etc/doeventsubscript/doEventSubScript98974.asp",
                data: {
                    mode: 'add'
                },
                success: function(data){
                    if(data.response == 'ok'){
                        fnAmplitudeEventMultiPropertiesAction('click_event_apply','evtcode','<%=eCode%>')                        
                        isApply = true
                        $("#btnImg").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2019/98974/m/bnr_fin.jpg")
                        $('.lyr-fin').show();		
                    }else{
                        alert(data.message)
                    }
                },
                error: function(data){
                    alert('시스템 오류입니다.')
                }
            })
    <% else %>
        jsEventLogin();
    <% end if %>
}
function getCartTotalAmount(){
    $.ajax({
        type: "GET",
        url:"/event/etc/doeventsubscript/doEventSubScript98974.asp",
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
</script>
   <!-- 98975 mkt 크리스박스 -->
            <div class="mEvt98974">
                <div class="bnr-top">
                    <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bnr_top.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a>
                </div>
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/tit_top.jpg" alt="크리스마스 선물주세요!">
                    <div class="ani-move">
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bg_star_1.png" alt=""></span>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bg_star_2.png" alt=""></span>
                    </div>
                    <p class="bounce"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/ico_bounce.png" alt="10명"></p>
                    <div class="pos">
                        <% if not IsUserLoginOK() then %>
                        <div class="non">
                            <a href="javascript:jsEventLogin()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/txt_non.png" alt="내가 담은 금액은? 로그인하고 확인하기"></a>
                        </div>
                        <% else %>
                        <div class="mem">
                            <div class="txt">
                                <span><b><%=GetLoginUserName()%></b>님</span>의 장바구니 금액
                            </div>
                            <div class="price" onclick="fnAPPpopupBaguni();">
                                <span><b id="totalAmount"><%= FormatNumber(getCartTotalAmount(userid), 0) %></b> 원 </span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/ico_arrow.png" alt="">
                            </div>
                            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/txt_mem.png" alt="* 위 금액은 품절 상품 및 배송비를 제외한 금액입니다."></p>
                        </div>
                        <% end if %>
                    </div>
                </div>
                <!-- 참여하기 버튼 -->
            <% if subscriptcount > 0 then %>
                <button class="btn-sign"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/98974/m/bnr_fin.jpg" alt="참여완료"></button>
            <% else %>                
                <button class="btn-sign" onclick="doAction()"><img id="btnImg" src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bnr_sign.jpg" alt="참여하기"></button>
            <% end if %>                
                <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/img_guide.jpg" alt="참여방법"></p>
                <div class="share">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bnr_share.jpg" alt="">
                    <!-- 공유하기 -->
                    <div class="pos">
                        <button class="btn-sns" onclick="snschk('fb')">페이스북으로 공유하기</button>
                        <button class="btn-sns" onclick="snschk('ka')">카카오톡으로 공유하기</button>
                        <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97629');return false;" >push 신청하기</a>
                    </div>
                </div>
                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/txt_noti.jpg" alt="유의사항"></div>
                <div class="other_cart">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/tit_cart.jpg" alt="다른 사람들은 어떤 상품을 담고 있을까?"></h3>
                    <div id="wishlist" v-cloak></div>
                </div>
                <!-- 이벤트 참여 완료 레이어 -->
                <div class="lyr lyr-fin" style="display:none;">
					<div class="inner">
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/img_pop.png" alt="100만 원 상품 담기 성공!"></p>
                        <a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" >당신이 찾고 있는 크리스마스 소품의 모든 것</a>
						<button class="btn-close"></button>
					</div>
				</div>
            </div>
            <!-- // 98975 mkt 크리스박스  -->
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