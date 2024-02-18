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
dim eCode : eCode = chkiif(application("Svr_Info") = "Dev","101599","101774")
%>
<style type="text/css">
.mEvt101774 {position:relative; overflow:hidden;}
.mEvt101774 .topic {position:relative; background:#fff558;}
.mEvt101774 .btn-sale {position:absolute; right:0; top:0; width:32.5%; }
.mEvt101774 .inp {position:absolute; top:59.5%; left:25%; width:50%; height:9%;}
.mEvt101774 .inp input[type=text] {display:block; width:100%; height:100%; padding:0; font-size:4vw; color:#000; text-align:center; border:0; background:none;}
.mEvt101774 .btn-cpn {display:block; width:100%;}
</style>
<%'!-- MKT 비밀쿠폰 101774 --%>
<div class="mEvt101774">
	<div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/tit_secret_coupon.png" alt="텐바이텐과 인플루언서가 비밀쿠폰을 드려요"></h2>
        <div class="btn-sale">
            <a href="/event/eventmain.asp?eventid=101722" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/btn_sale.png" alt="정기세일 바로가기"></a>
            <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101722');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/btn_sale.png" alt="정기세일 바로가기"></a>
        </div>
		<div class="inp"><input type="text" id="couponname" placeholder="쿠폰코드를 입력해주세요!"></div>
		<button type="button" onclick="jsDownCustomCoupon();" class="btn-cpn"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/btn_cpn.png" alt="쿠폰 발급받기"></button>
	</div>
	<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/img_howto.png" alt="쿠폰 등록 방법"></p>
	<% if date() <= "2020-04-18" then %>
	<div>
        <a href="/event/eventmain.asp?eventid=101392" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/bnr_event_1.png" alt="알림 신청만 하면 1,000P 무료 지급!"></a>
        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101392');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/bnr_event_1.png" alt=""></a>
    </div>
	<% end if %>
    <div>
        <a href="/event/eventmain.asp?eventid=101305" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/bnr_event_2.png" alt="지금 토스로 6만원 이상 결제하면 5천원 추가 중복 할인!"></a>
        <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=101305');" target="_blank" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/bnr_event_2.png" alt=""></a>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/101774/m/txt_noti.png" alt="이벤트 유의사항"></p>
</div>
<%'!-- // MKT 비밀쿠폰 101774 --%>
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