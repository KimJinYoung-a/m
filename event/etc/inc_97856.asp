<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 텐x텐 쿠폰 이벤트
' History : 2019-10-11
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "90412"  
Else
	eCode = "97856"
End If
%>
<style>
.mEvt97856, .mEvt97856 > div {position: relative;}
.mEvt97856 .posa {position: absolute; width: 100%; top: 0; left: 0;}
.mEvt97856 .ani-area {position: absolute; top: 15%; left: 50%; margin-left: -14rem;}
.mEvt97856 .ani {display: inline-block; width: 26%; vertical-align: top; opacity: 0; animation: scale1 both .55s cubic-bezier(0.18, 0.89, 0.32, 1.28)}
.mEvt97856 .ani1 {margin: 1rem .7rem; transform-origin: 100% 100%;}
.mEvt97856 .ani2 {animation-delay: .5s; transform-origin: 0% 100%;}
.mEvt97856 .inputbox input {left: 20%; width: 60%; padding: 2.5rem 0; border: 0; font-size: 1.37rem; color: #444; font-weight: 500; text-align: center;}
.mEvt97856 .inputbox input:focus::-webkit-input-placeholder {opacity: 0;} 
.mEvt97856 .motion2 {font-size: 1.37rem; color: #444; font-weight: 600; }
.mEvt97856 .motion2 {position: absolute; top: 55.2%; left: 31%; width: auto; margin-left: -1rem;}
.mEvt97856 .motion2 .typed { color: #222; white-space: nowrap; overflow: hidden; width: 11rem; font-family: 'Noto Sans KR','malgun Gothic','맑은고딕',sans-serif; text-align: left; animation: typed 3s steps(20, end) infinite;}
@keyframes scale1 { from { transform: scale(0); } to {transform: scale(1); opacity: 1;}} 
@keyframes typed { from {width: 0;} 40%,to {width:100%}} 
</style>
<script>
function jsDownCustomCoupon(){
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>	
	$.ajax({
		type: "post",
		url: "/event/etc/doEventSubscript97856.asp",				
		data: {
			couponname: $("#couponname").val()		
		},
		cache: false,
		success: function(resultData) {
			var reStr = resultData.split("|");		
			if(reStr[0]=="OK"){		
				fnAmplitudeEventMultiPropertiesAction('click_custom_coupon_btn','evtcode|couponname','<%=eCode%>|'+$("#couponname").val());
			    alert('4,000원 할인 쿠폰이 지급되었습니다!');
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

<!-- MKT_97856_텐X텐쿠폰 -->
<div class="mEvt97856">
    <div class="topic">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/tit_tencpu.jpg" alt="텐X텐쿠폰"></span>
        <div class="posa ani-area">
            <span class="ani ani1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/tit_ani_1.png" alt="텐바이텐"></span>
            <span class="ani ani2"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/tit_ani_2.png" alt="텐텐쇼퍼"></span>
        </div>
    </div>
    <div class="inputbox">
        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/bg_input.jpg" alt=""></span>
        <input id="couponname" type="text" placeholder="쿠폰명을 입력해주세요!" class="posa">
    </div>
    <button onclick="jsDownCustomCoupon();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/btn_tencpu.jpg" alt="쿠폰 등록"></button>
    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/img_guide.jpg" alt="쿠폰 등록 방법">
        <span class="motion2 posa"><p class="typed">텐바이텐 18주년</p></span>
    </div>
    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/97856/m/txt_noti.jpg" alt="유의사항"></span>
</div>
<!-- // MKT_97856_텐X텐쿠폰 -->

<!-- #include virtual="/lib/db/dbclose.asp" -->