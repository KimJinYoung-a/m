<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 텐바이텐X인플루언서 비밀쿠폰
' History : 2020-03-31 조경애
'###########################################################
' UI 개발 가이드
'###########################################################
' <button onclick="jsDownCustomCoupon();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/btn_tencpu.jpg" alt="쿠폰 등록"></button>
' ㄴ 버튼에 스크립트 추가
' <input id="couponname" type="text" placeholder="쿠폰명을 입력해주세요!" class="posa">
' ㄴ 쿠폰명 입력 부분 input id="couponname" 네이밍 그대로 써주세요
' dim eCode : eCode = chkiif(application("Svr_Info") = "Dev","90412","100761")
' ㄴ 이벤트 코드 설정 ex) 90412 - 테스트이벤트코드 , 100761 - 실서버이벤트코드 (2가지 각각 이벤트 코드 생성후 변경)
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode : eCode = chkiif(application("Svr_Info") = "Dev","102155","102229")
%>
<style type="text/css">
.tenten-cpn {overflow:hidden; position:relative;}
.tenten-cpn .topic {background:#fedc23;}
.tenten-cpn .topic h2 {position:relative;}
.tenten-cpn .topic span {display:inline-block; width:25.87%; position:absolute; top:25.59%; left:9.47%; animation:rotateAni 1s 30 forwards; transform-origin:50% 100%;}
.tenten-cpn .topic .t2 {top:22%; left:37.33%; animation-delay:.5s;}
.tenten-cpn .coupon {position:relative;}
.tenten-cpn .coupon #couponname {position:absolute; top:40%; left:50%; width:65.34%; height:5.55rem; margin-left:-32.77%; border:solid .21rem #5de7e5; font-size:1.19rem; text-align:center;}
.tenten-cpn .coupon .btn-cpn {display:block; width:100%;}
.tenten-cpn .ten-sns {position:relative;}
.tenten-cpn .ten-sns .link {position:absolute; top:0; right:0; display:flex; justify-content:flex-end; width:100%; height:100%; padding-right:5%;}
.tenten-cpn .ten-sns .link a {width:17%; text-indent:-999em;}
@keyframes rotateAni {
	0%,100% {transform:rotate(0deg);}
	50% {transform:rotate(-15deg);}
}
</style>
<%'!-- MKT 텐X텐 쿠폰 --%>
<div class="mEvt102229 tenten-cpn">
    <div class="topic">
        <h2>
            <span class="t1"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/img_tenten.png" alt="텐바이텐"></span>
            <span class="t2"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/img_shopper.png" alt="텐텐쇼퍼"></span>
            <p class="t3"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/tit_coupon.png" alt="텐X텐 쿠폰"></p>
        </h2>
        <div class="coupon">
            <img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/img_coupon.png" alt="할인쿠폰">
            <input type="text" id="couponname" placeholder="쿠폰코드를 입력해주세요!">
            <button type="button" onclick="jsDownCustomCoupon();" class="btn-cpn"><img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/btn_coupon.png" alt="쿠폰 발급받기"></button>
        </div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/txt_howto.png" alt="쿠폰 등록 방법"></p>
    <div class="ten-sns">
        <img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/img_sns.png" alt="텐바이텐 sns 팔로우 하고 이벤트 소식 빠르게 받아보기!">
        <div class="link">
            <a href="https://tenten.app.link/e/wCZw6TRbJ5" target="_blank;" class="mWeb">페이스북으로 이동</a>
            <a href="" onclick="fnAPPpopupExternalBrowser('https://tenten.app.link/e/wCZw6TRbJ5'); return false;" class="mApp">페이스북으로 이동</a>
            <a href="https://tenten.app.link/e/UJRc4mWbJ5" target="_blank;" class="mWeb">인스타로 이동</a>
            <a href="" onclick="fnAPPpopupExternalBrowser('https://tenten.app.link/e/UJRc4mWbJ5'); return false;" class="mApp">인스타로 이동</a>
        </div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/102229/m/txt_noti.png" alt="이벤트 유의사항"></p>
</div>
<%'!-- // MKT 텐X텐 쿠폰 --%>
<script>
function jsDownCustomCoupon(){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>	
	$.ajax({
		type: "post",
		url: "/event/etc/coupon/shopper/couponprocess.asp",				
		data: {
			couponname : $("#couponname").val(),
			eventid : <%=eCode%>
		},
		cache: false,
		success: function(resultData) {
			var reStr = resultData.split("|");		
			if(reStr[0]=="OK"){		
				fnAmplitudeEventMultiPropertiesAction('click_custom_coupon_btn','evtcode|couponname','<%=eCode%>|'+$("#couponname").val());
				alert('3,000원 할인 쿠폰이 지급되었습니다!');
			}else if(reStr[0]=="ERR"){
				var errorMsg = reStr[1].replace(">?n", "/n");
				alert(errorMsg);
			}			
		},
		error: function(err) {
			console.log(err.responseText);
		}
	});
	<% end if %>
	$('#couponname').val('');
}

function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
<% end if %>
	return;
}
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->