<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 귀여움 페스티벌
' History : 2021.05.06 정태훈 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currentDate, eventStartDate, eventEndDate
dim eCode, userid, mktTest, subscriptcount, sqlstr, myTeaSet

IF application("Svr_Info") = "Dev" THEN
	eCode = "105355"
    mktTest = true
ElseIf application("Svr_Info")="staging" Then
	eCode = "110936"
    mktTest = true    
Else
	eCode = "110936"
    mktTest = false
End If

if mktTest then
    currentDate = #05/10/2021 09:00:00#
else
    currentDate = date()
end if

eventStartDate = cdate("2021-05-10")		'이벤트 시작일
eventEndDate = cdate("2021-05-23")		'이벤트 종료일

userid = GetEncLoginUserID()

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, left(currentDate,10), 2, "")
	sqlstr = "select top 1 sub_opt2"
	sqlstr = sqlstr & " from [db_event].[dbo].[tbl_event_subscript]"
	sqlstr = sqlstr & " where evt_code="& eCode &""
	sqlstr = sqlstr & " and userid='"& userid &"'"
    sqlstr = sqlstr & " and sub_opt1='"& left(currentDate,10) &"'"
	rsget.Open sqlstr,dbget
	IF not rsget.EOF THEN
		myTeaSet = rsget("sub_opt2")
	END IF
	rsget.close
end if
%>
<style>
.mEvt110936 .topic {position:relative;}
.mEvt110936 .tit-main {position:absolute; left:50%; top:5.4%; transform:translate(-50%,0); width:66.67vw; z-index:10;}
.mEvt110936 .top-flag {position:absolute; left:50%; top:4%; transform:translate(-50%,0); width:82vw;}
.mEvt110936 .img-coupon {position:absolute; right:28%; top:16.8%; width:19.06vw;}
.mEvt110936 .img-event01 {position:absolute; right:11%; top:25.2%; width:29.06vw;}
.mEvt110936 .img-event02 {position:absolute; left:10%; top:32.4%; width:32.80vw;}
.mEvt110936 .img-event03 {position:absolute; right:2%; top:40.3%; width:24.8vw;}
.mEvt110936 .img-event04 {position:absolute; right:7%; top:51.1%; width:32.80vw;}
.mEvt110936 .link01 {position:absolute; right:10%; top:15.5%;}
.mEvt110936 .link01 button {width:40vw; height:25vw; background:transparent;}
.mEvt110936 .link02 {position:absolute; left:13%; top:18.5%;}
.mEvt110936 .link02 a {display:inline-block; width:30vw; height:47vw;}
.mEvt110936 .link03 {position:absolute; right:12%; top:25.5%;}
.mEvt110936 .link03 a {display:inline-block; width:32vw; height:53vw;}
.mEvt110936 .link04 {position:absolute; left:12%; top:31.5%;}
.mEvt110936 .link04 a {display:inline-block; width:32vw; height:53vw;}
.mEvt110936 .link06 {position:absolute; right:0%; top:39.5%;}
.mEvt110936 .link06 a {display:inline-block; width:27vw; height:44vw;}
.mEvt110936 .link07 {position:absolute; left:10%; top:44.5%;}
.mEvt110936 .link07 a {display:inline-block; width:37vw; height:59vw;}
.mEvt110936 .link08 {position:absolute; right:10%; top:50.5%;}
.mEvt110936 .link08 a {display:inline-block; width:37vw; height:59vw;}
.mEvt110936 .link09 {position:absolute; left:10%; top:59.5%;}
.mEvt110936 .link09 a {display:inline-block; width:37vw; height:59vw;}
.mEvt110936 .link10 {position:absolute; right:10%; top:65.5%;}
.mEvt110936 .link10 a {display:inline-block; width:37vw; height:59vw;}
.mEvt110936 .sec-wish {padding-bottom:3.47rem; background:#fff;}
.mEvt110936 .sec-wish .wish-wrap {display:flex; flex-wrap:wrap; justify-content:space-between; margin:0 2.60rem; background:#fff;}
.mEvt110936 .sec-wish .wish-wrap li {width:49%; height:41vw; margin-bottom:0.43rem; background:#ededed;}
.mEvt110936 .sec-wish .wish-wrap li .thum {width:100%; height:100%; overflow:hidden;}

.mEvt110936 .pop-container {display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; background-color:rgba(255, 255, 255,0.902); z-index:150;}
.mEvt110936 .pop-container .pop-inner {position:relative; width:100%; height:100%; padding:2.47rem 1.73rem 4.17rem; overflow-y: scroll;}
.mEvt110936 .pop-container .pop-inner a {display:inline-block;}
.mEvt110936 .pop-container .pop-inner .btn-close {position:absolute; right:2.73rem; top:3.60rem; width:1.73rem; height:1.73rem; background:url(//webimage.10x10.co.kr/fixevent/event/2021/110936/m/icon_close.png) no-repeat 0 0; background-size:100%; text-indent:-9999px;}
.mEvt110936 .pop-container .pop-contents {position:relative;}
.mEvt110936 .pop-container .pop-contents .btn-gocoupon {position:absolute; left:0; bottom:0; width:100%; height:70vw; background:transparent;}
</style>
<script type="text/javascript">
$(function(){
    // 이미지 순차 반복 노출하기
    var num = 1;
    setInterval(function(){
        num++;
        if(num>2) {num = 1};
        $('.top-flag > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_flags_0' + num + '.png');
        $('.img-coupon > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_coupon_0' + num + '.png');
        $('.img-event01 > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event01_0' + num + '.png');
        $('.img-event02 > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event02_0' + num + '.png');
        $('.img-event03 > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event03_0' + num + '.png');
        $('.img-event04 > img').attr('src','//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event02_0' + num + '.png');
    },1000);
    
    /* 팝업 */
    /* 쿠폰 팝업 */
    $('.mEvt110936 .btn-coupon').click(function(){
        
    })
    /* 팝업 닫기 */
    $('.mEvt110936 .btn-close').click(function(){
        $(".pop-container").fadeOut();
    })
});

function fnCuteCouponIssued(eCode, cIdxs) {
<% If Not(IsUserLoginOK) Then %>
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
    <% end if %>
    return false;
<% else %>
	$.ajax({
		type: "post",
		url: "/event/etc/coupon/brandcoupon_process.asp",		
		data: {
			eCode: eCode,
			couponIdxs: cIdxs
		},
		cache: false,
		success: function(resultData) {
			fnAmplitudeEventMultiPropertiesAction('click_coupon_btn','evtcode|couponType',''+eCode+'|'+cIdxs+'')
			var reStr = resultData.split("|");				
			
			if(reStr[0]=="OK"){		
				$('.pop-container.coupon').fadeIn();
			}else if(reStr[0]=="LGN") {
				eval(reStr[1]);
				return false;
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

function fnMyCouponView(){
<% If Not(IsUserLoginOK) Then %>
    <% if isApp="1" then %>
        calllogin();
    <% else %>
        jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
    <% end if %>
    return false;
<% else %>
    <% if isApp="1" then %>
        fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '쿠폰북', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/couponbook.asp?tab=3');
    <% else %>
        location.href="/my10x10/couponbook.asp?tab=3";
    <% end if %>
    return false;
<% end if %>
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
            <div class="mEvt110936">
                <div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_main02.jpg" alt="작고 소중한 것들이 세상을 구한다!">
                    <div class="tit-main"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_flag_txt.png" alt="귀여움 페스티벌"></div>
                    <div class="top-flag"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_flags_01.png" alt="귀여움 페스티벌"></div>
                    <div class="img-coupon"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_coupon_01.png" alt="coupon"></div>
                    <div class="img-event01"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event01_01.png" alt="인형뽑기"></div>
                    <div class="img-event02"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event02_01.png" alt="귀여움 저장소"></div>
                    <div class="img-event03"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event03_01.png" alt="now 즉시할인"></div>
                    <div class="img-event04"><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/img_event02_01.png" alt="sns 이벤트 홀"></div>
                    <div class="link01"><button type="button" class="btn-coupon" onclick="fnCuteCouponIssued('110936','1671');return false;"></button></div>
                    <div class="link02">
                        <a href="/event/eventmain.asp?eventid=111095" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111095');return false;" class="mApp"></a>
                    </div>
                    <div class="link03">
                        <a href="/event/eventmain.asp?eventid=111101" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111102');return false;" class="mApp"></a>
                    </div>
                    <div class="link04">
                        <a href="/event/eventmain.asp?eventid=110972" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=110972');return false;" class="mApp"></a>
                    </div>
                    <div class="link06">
                        <% If (currentDate >= #05/10/2021 00:00:00#) and (currentDate < #05/17/2021 00:00:00#) Then %>
                        <a href="/event/eventmain.asp?eventid=111093" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111093');return false;" class="mApp"></a>
                        <% elseIf (currentDate >= #05/17/2021 00:00:00#) and (currentDate < #05/24/2021 00:00:00#) Then %>
                        <a href="/event/eventmain.asp?eventid=111094" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111094');return false;" class="mApp"></a>
                        <% end if %>
                    </div>
                    <div class="link07">
                        <a href="/event/eventmain.asp?eventid=107535" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=107535');return false;" class="mApp"></a>
                    </div>
                    <div class="link08">
                        <a href="/event/eventmain.asp?eventid=111092" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=111092');return false;" class="mApp"></a>
                    </div>
                    <div class="link09">
                        <a href="http://m.10x10.co.kr/category/category_detail2020.asp?disp=101107102&vt=detail&sm=new#%7B%22disp%22%3A%22101107102%22%2C%22view_type%22%3A%22detail%22%2C%22sort_method%22%3A%22best%22%2C%22page%22%3A1%2C%22deliType%22%3A%5B%5D%2C%22makerIds%22%3A%5B%5D%2C%22minPrice%22%3A%22%22%2C%22maxPrice%22%3A%22%22%7D" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupCategory(101107102);return false;" class="mApp"></a>
                    </div>
                    <div class="link10">
                        <a href="/brand/brand_detail2020.asp?brandid=peanuts10x10" class="mWeb"></a>
                        <a href="#" onclick="fnAPPpopupBrand('peanuts10x10'); return false;" class="mApp"></a>
                    </div>
                </div>
                
                <!-- 위시 리스트 -->
                <div class="sec-wish">
                    <h3><img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/tit_wish.jpg" alt="지금 텐바이텐 유저들이 좋아하는 귀여운 상품들을 만나보세요!"></h3>
                    <div id="app"></div>
                </div>

                <!-- 팝업 - 쿠폰 -->
                <div class="pop-container coupon">
                    <div class="pop-inner">
                        <div class="pop-contents">
                            <img src="//webimage.10x10.co.kr/fixevent/event/2021/110936/m/pop_coupon.png" alt="쿠폰이 발급되었습니다.">
                            <button type="button" class="btn-gocoupon" onclick="fnMyCouponView();"></button>
                        </div>
                        <button type="button" class="btn-close">닫기</button>
                    </div>
                </div>
            </div>
<script src="/vue/components/common/functions/common.js?v=1.0"></script>
<script src="/vue/components/common/functions/item_mixins.js?v=1.0"></script>
<script src="/vue/event/etc/vue_110936.js?v=1.02"></script>
<!-- #include virtual="/lib/db/dbclose.asp" -->