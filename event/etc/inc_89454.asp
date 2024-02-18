<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 카테고리쿠폰 89454
' History : 2018-09-21 최종원 
'####################################################
dim eCode, couponIdx

IF application("Svr_Info") = "Dev" THEN
	eCode = "89173"
	couponIdx = "2890,2891,2892,2893"
Else
	eCode = "89454"
	couponIdx = "1084,1085,1086,1087"
End If

%>
<style type="text/css">
.mEvt89454 .coupon {position:relative}
.mEvt89454 button{background:none}
.mEvt89454 .coupon > button {position:absolute;width: 75%;bottom: 9%;left: calc(50% - 37.5%);}
.layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;}
.layer-popup .layer {overflow:hidden; position:absolute; left:calc(50% - 44%); top:0; z-index:99999; width:88%;}
.layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.7);}
#lyrSch .layer {top:10rem; left:6%; width:88%; background-color:#fff2c4; border-radius:1rem;}
#lyrSch .layer p{padding: 3.7rem 3rem 0;}
#lyrSch .layer button{padding: 2.5rem 6rem;}
</style>
<script type="text/javascript">
$(function() {
	// 레이어 열기


	// 레이어 닫기
	$('.layer-popup .btn-close').click(function(){
		$('.layer-popup').fadeOut();
	});
	$('.layer-popup .mask').click(function(){
		$('.layer-popup').fadeOut();
	});
});
function jsDownCoupon2(stype,idx){						
	<% if Not(IsUserLoginOK) then %>
		jsEventLogin();
	<% else %>
	$.ajax({
		type: "post",
		url: "/shoppingtoday/act_couponshop_process.asp",
		data: "idx="+idx+"&stype="+stype,
		cache: false,
		success: function(message) {
			if(typeof(message)=="object") {
				if(message.response=="Ok") {
					$('#lyrSch').fadeIn();
					window.parent.$('html,body').animate({scrollTop:$('#lyrSch').offset().top}, 800);
				} else {
					alert(message.message);
				}
			} else {
				alert("처리중 오류가 발생했습니다.");
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
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}
function linkMycoupon(){
	<% if isApp="1" then %>
		fnAPPpopupBrowserURL('마이텐바이텐','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/couponbook.asp');
	<% else %>
		location.href='/my10x10/couponbook.asp'
	<% end if %>
	return false;
}
</script>
            <div class="mEvt89454">
                <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89454/m/tit-top.png" alt="쿠폰 쓰고시퐁"></h2>
                <div class="coupon">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89454/m/bg-img.png" alt=""></p>
                    <!-- 쿠폰 한번에 다운받기 버튼 -->
                    <button class="btn-layer" type="button" onclick="jsDownCoupon2('event,event,event,event','<%=couponIdx%>');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89454/m/btn-onestop.png" alt="쿠폰 한번에 다운받기" /></button>
                </div>
                <!-- 레이어 -->
				<div id="lyrSch" class="layer-popup">
					<div class="layer">
						<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89454/m/layer-tit.png" alt="카테고리쿠폰 발급! 쿠폰함을 확인해주세요"></p>
                        <!-- 쿠폰함으로 가기 버튼 -->						
                        <button class="layer-btn" type="button" onclick="linkMycoupon();"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89454/m/layer-btn.png" alt="쿠폰함으로 가기" /></button>						
					</div>
					<div class="mask"></div>
				</div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->