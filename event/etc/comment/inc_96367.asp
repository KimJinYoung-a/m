<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 인스타그램
' History : 2019-08-16
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<%
dim evtStartDate, evtEndDate, currentDate
	currentDate =  date()
    evtStartDate = Cdate("2019-08-19")
    evtEndDate = Cdate("2019-08-31")

dim vAdrVer

vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90369
Else
	eCode   =  96367
End If
%>
<style type="text/css">
.mEvt96367 {background-color: #fff;}
.mEvt96367 ,.mEvt96367 > div {position: relative;}
.mEvt96367 .pos {position: absolute; top: 0; left: 0;}
.mEvt96367 .posr {position: relative;}
.mEvt96367 p img {width: 100%;}
.topic .pos {top: 4.1rem; left: 3.37rem;}
.topic p {font-size: 3.54rem; font-weight: 500; line-height: 4.9rem; color: #fff; animation: blink 3s steps(1) 20; animation-delay: 0s}
.topic p.delay {animation-delay: 1s}
.topic p.delay1 {animation-delay: 2s}
    @keyframes blink {
        from,66%,to {color: #fff;}
        33% {color: #ffd87a;}
    }
.slide2 .swiper-wrapper {position: absolute; top: 42%;}
.slide2 .swiper-slide {width: 10.24rem;}
span.shake {position: absolute; top: 20%; right: 21%; width: 11%; animation: shake .7s 40;}
    @keyframes shake {
        from, to {transform:translateX(3px);}
        50% {transform:translateX(-3px);}
    }
.input-box {position: relative; width: 32rem; margin: 0 auto;}
.input-box div.pos {top: 5.9rem; left: 50%; width: 19rem; margin-left: -7rem;}


.input-box input {overflow:hidden; width:70%; height:4rem; padding: 0; border:0; background-color:transparent; color:#444; font-size:1.3rem; font-weight:600; text-align: center; box-sizing: border-box; vertical-align: top;}
.input-box input::-webkit-input-placeholder {color:#999;}
.input-box input:focus::-webkit-input-placeholder {opacity: 0;} 
.input-box .btn-submit {display: inline-block; width: 28%; height: 4rem; background: none; text-indent: -999rem; }
.insta-prd .pos {width: 100%;}
.insta-prd ul:after {content: ''; display: block; clear: both;}
.insta-prd li {float: left; width: 33.33%;}
.insta-prd li a {display: block; padding-bottom: 92.5%; text-indent: -999rem;}
.noti {background-color: #ededed; padding:3.2rem 6.67% ; color: #222; }
.noti h3 {margin-bottom: 1.55rem; font-weight: bold; font-size: 1.7rem; text-align: center;}
.noti li {padding-left: .7rem; margin:.68rem 0; font-size:1.11rem; line-height:1.6; word-break: keep-all}
.noti li:before {content: '-'; display: inline-block; width: .7rem; margin-left: -.7rem;}
</style>
<script type="text/javascript" src="/lib/js/TweenMax.min.js"></script>
<script>
$(function(){
    swiper1 = new Swiper(".slide1",{loop: true, pagination:'.slide1 .pagination', paginationClickable:true, autoplay:3500});
    swiper = new Swiper('.slide2', {
        loop: true, 
        slidesPerView:'auto',
        centeredSlides:true, autoplay:2500
    })
})
</script>
<script type="text/javascript">
function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( currentDate >= evtStartDate and currentDate <= evtEndDate ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
            if(frm.txtcomm.value == ""){
                alert('아이디를 입력해주세요.')
                frm.txtcomm.focus()
                return false;
            }                        
            frm.action = "/event/lib/doEventComment.asp";
            frm.submit();
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
}
function fnSearchEventText(stext){
	<% If flgDevice="A" Then %>
		fnAPPpopupSearch(stext);
	<% Else %>
		<% If vAdrVer>="2.24" Then %>
			fnAPPpopupSearchOnNormal(stext);
		<% Else %>
			fnAPPpopupSearch(stext);
		<% End If %>
	<% End If %>
}
</script>
            <!-- MKT_96367_#텐바이텐#인스타그램#팔로팔로미 -->
            <div class="mEvt96367">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_top.jpg" alt="텐바이텐 인스타그램을 팔로우하신 분 중 추첨을 통해 10분께 선물이 팡! 팡!">
                    <div class="pos">
                        <p>#텐바이텐</p>
                        <p class="delay">#인스타그램</p>
                        <p class="delay1">#팔로팔로미</p>
                    </div>
                </div>
                <div class="slide1 slideTemplateV15 ">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_up_1.jpg" alt=""/></div>
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_up_2.jpg" alt=""/></div>
                        <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_up_3.jpg" alt=""/></div>
                     </div>
                    <div class="pagination"></div>
                </div>
                <div class="slide2">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/bg_gift.png" alt="텐바이텐이 드리는 선물">
                    <div class="swiper-wrapper">
                        <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2439464&pEtr=96367" onclick="TnGotoProduct('2439464');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_slide_1.png" alt=""/></a></div>
                        <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2369273&pEtr=96367" onclick="TnGotoProduct('2369273');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_slide_2.png" alt=""/></a></div>
                        <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2324114&pEtr=96367" onclick="TnGotoProduct('2324114');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_slide_3.png" alt=""/></a></div>
                        <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2242441&pEtr=96367" onclick="TnGotoProduct('2242441');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_slide_4.png" alt=""/></a></div>
                        <div class="swiper-slide"><a href="/category/category_itemPrd.asp?itemid=2339541&pEtr=96367" onclick="TnGotoProduct('2339541');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_slide_5.png" alt=""/></a></div>
                    </div>
                </div>
                <div class="join-guide">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/txt_join.jpg" alt=""/></p>
                    <div class="posr">
                    <% if isapp = 1 then %>
                        <a href="javascript:fnAPPpopupExternalBrowser('https://tenten.app.link/FpZ0TaRo8Y');">
                    <% else %>
                        <a href="https://tenten.app.link/FpZ0TaRo8Y">
                    <% end if %>
                            <img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/btn_follow.jpg" alt="팔로우"/>
                        </a>
                        <span class="shake"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/ico_click.png" alt="click"/></span>
                    </div>
                    <form name="frmcom" method="post" onSubmit="return false;">
                    <input type="hidden" name="mode" value="add">
                    <input type="hidden" name="iCC" value="1">
                    <input type="hidden" name="eventid" value="<%= eCode %>">
                    <input type="hidden" name="linkevt" value="<%= eCode %>">
                    <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
                    <input type="hidden" id="spoint" name="spoint" value="1">                            
                    <input type="hidden" name="isApp" value="<%= isApp %>">
                    <input type="hidden" name="alertTxt" value="당첨자 발표일을 기다려주세요.">
                    <div class="input-box">
                        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/bg_input.jpg" alt="텐바이텐에서 인스타그램 ID를 기입한다."/></p>
                        <div class="pos">
                            <input type="text" name="txtcomm" autocomplete="off" onClick="jsCheckLimit();" maxlength="100" placeholder="ID를 입력해주세요." >
                            <button type="button" class="btn-submit" onclick="jsSubmitComment(document.frmcom);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/bg_input.jpg" alt="등록"/></button>
                        </div>
                    </div>
                    </form>                         
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/btn_insta.jpg" alt="텐바이텐 인스타그램 인기 상품 구경하기" /></p>
                </div>
                <div class="insta-prd">
                    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96367/m/img_insta.jpg" alt="텐바이텐 인스타그램 인기 상품 구경하기" /></p>
                    <div class="pos">
                        <ul>
                            <li><a href="/category/category_itemPrd.asp?itemid=2383744&pEtr=96367" onclick="TnGotoProduct('2383744');return false;">상품</a></li>
                            <li>
                                <a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=캔디카메라" class="mWeb"><span>캔디카메라</span></a>
                                <a href="javascript:fnSearchEventText('캔디카메라');" class="mApp"><span>캔디카메라</span></a>
                            </li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2369273&pEtr=96367" onclick="TnGotoProduct('2369273');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2421868&pEtr=96367" onclick="TnGotoProduct('2421868');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2339541&pEtr=96367" onclick="TnGotoProduct('2339541');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2367258&pEtr=96367" onclick="TnGotoProduct('2367258');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2420649&pEtr=96367" onclick="TnGotoProduct('2420649');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2360312&pEtr=96367" onclick="TnGotoProduct('2360312');return false;">상품</a></li>
                            <li>
                                <a href="/search/search_item.asp?cpg=1&burl=http%3A%2F%2Fm.10x10.co.kr%2F&prectcnt=&rect=이딸라" class="mWeb"><span>이딸라</span></a>
                                <a href="javascript:fnSearchEventText('이딸라');" class="mApp"><span>이딸라</span></a>
                            </li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2436410&pEtr=96367" onclick="TnGotoProduct('2436410');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2242441&pEtr=96367" onclick="TnGotoProduct('2242441');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2036806&pEtr=96367" onclick="TnGotoProduct('2036806');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2330710&pEtr=96367" onclick="TnGotoProduct('2330710');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2414079&pEtr=96367" onclick="TnGotoProduct('2414079');return false;">상품</a></li>
                            <li><a href="/category/category_itemPrd.asp?itemid=2420121&pEtr=96367" onclick="TnGotoProduct('2420121');return false;">상품</a></li>
                        </ul>
                    </div>
                </div>
                <div class="noti">
                    <h3>유의사항</h3>
                    <ul>
                        <li>해당 이벤트는 로그인 후 참여 가능합니다.</li>
                        <li>등록된 인스타그램 ID가 확인되지 않거나 비공개일 경우, 당첨이 어려움을 알려드립니다.</li>
                        <li>텐바이텐 인스타그램 팔로우 여부 확인 후 이벤트 상품이 지급됩니다.</li>
                        <li>텐바이텐 인스타그램 팔로우 유지기간은 1개월이며, 1개월 이내 팔로우가 취소 될 경우 이벤트 상품 반환 요청이 될 수 있습니다.</li>
                    </ul>
                </div>
            </div>
            <!-- // MKT_96367_#텐바이텐#인스타그램#팔로팔로미 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->