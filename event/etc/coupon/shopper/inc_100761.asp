<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 텐x텐 쿠폰 이벤트
' History : 2020-02-17 이종화
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
dim eCode : eCode = chkiif(application("Svr_Info") = "Dev","90470","100761")
%>
<style>
.mEvt100761 {position:relative; overflow:hidden;}
.mEvt100761 .topic {position:relative; background:#fff558;}
.mEvt100761 .inp {position:absolute; top:60%; left:0; width:100%; height:9%;}
.mEvt100761 .inp input[type=text] {display:block; width:60%; height:100%; margin:0 auto; padding:0; font-size:4vw; color:#444; text-align:center; border:0; background:none;}
.mEvt100761 .btn-cpn {display:block; width:100%;}
</style>
<%'!-- MKT 텐X텐 쿠폰 100761 --%>
<div class="mEvt100761">
	<div class="topic">
		<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/tit_tenten.jpg" alt="텐X텐 쿠폰"></h2>
		<div class="inp"><input type="text" id="couponname" placeholder="쿠폰코드를 입력해주세요!"></div>
		<button type="button" onclick="jsDownCustomCoupon();" class="btn-cpn"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/btn_cpn.jpg" alt="쿠폰 발급받기"></button>
	</div>
	<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/txt_howto.jpg" alt="쿠폰 등록 방법"></p>
	<!-- 마케팅이벤트 띠배너 -->
	<!-- FLEX 유입이벤트 2020-02-24 ~ 2020-03-05 동안에만 노출 -->
	<% If Date() <= "2020-03-05" Then %>
	<a href="/event/eventmain.asp?eventid=100730" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/bnr_evt_1.jpg" alt="샤넬 가방"></a>
	<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=100731');" target="_blank" class="mApp">
		<img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/bnr_evt_1.jpg" alt="샤넬 가방">
	</a>
	<% End If %>
	<a href="/event/eventmain.asp?eventid=96333" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/bnr_evt_2.jpg" alt="텐바이텐 메일 구독"></a>
	<a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96333');" target="_blank" class="mApp">
		<img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/bnr_evt_2.jpg" alt="텐바이텐 메일 구독">
	</a>
	<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100761/m/txt_noti.jpg" alt="이벤트 유의사항"></p>
</div>
<%'!-- // MKT 텐X텐 쿠폰 100761 --%>
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