<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 크리스마스 선물 주세요 moweb
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
dim userid : userid = GetEncLoginUserID()
%>
<style type="text/css">
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
@keyframes star {
    50%{opacity: 0;}
}
@keyframes bounce {
    from to {transform:translateY(0);}
    50% {transform:translateY(-10px);}
}
</style>
<script>
function jsEventLogin() {
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=98975")%>');
	<% end if %>
	return;
}
</script>
            <!-- 98975 mkt 크리스박스 -->
            <div class="mEvt98974">
                <div class="bnr-top">
	                <a href="/christmas" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bnr_top.jpg" alt="당신이 찾고 있는 크리스마스 소품의 모든 것"></a>
                </div>
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/tit_top.jpg" alt="크리스마스 선물주세요!">
                    <div class="ani-move">
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bg_star_1.png" alt=""></span>
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bg_star_2.png" alt=""></span>
                    </div>
                    <p class="bounce"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/ico_bounce_mw.png" alt="app 전용"></p>
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
                            <div class="price" onclick="window.location.href='/inipay/ShoppingBag.asp'">
                                <span><b id="totalAmount"><%= FormatNumber(getCartTotalAmount(userid), 0) %></b> 원 </span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/ico_arrow.png" alt="">
                            </div>
                            <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/txt_mem.png" alt="* 위 금액은 품절 상품 및 배송비를 제외한 금액입니다."></p>
                        </div>
                        <% end if %>
                    </div>
                </div>
                <!-- 앱 다운받고 참여하기 버튼 -->
                <a class="btn-sign" href="https://tenten.app.link/2yeWc7e3M1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/bnr_sign_mw.jpg" alt="앱 다운받고 참여하기"></a>
                <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98974/m/txt_noti_mw.jpg" alt="유의사항"></div>
            </div>
            <!-- // 98975 mkt 크리스박스 -->   
<!-- #include virtual="/lib/db/dbclose.asp" -->