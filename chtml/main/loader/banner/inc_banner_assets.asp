<%'쿠폰배너 공통 스크립트, css%>	
<style>	
.item-etc-info ul,
.deal-item .item-etc-info p {border-top:0;}
.lyr-coupon {display:none; position:fixed; top:0; left:0; z-index:99999; width:100vw; height:100vh; background-color:rgba(91, 91, 91, 0.52);}
.lyr-coupon .inner {position:absolute; left:6.5%; top:50%; width:87%; padding:12.28vw 0 10vw; transform:translateY(-50%); text-align:center; background-color:#fff; -webkit-border-radius:0.2rem; border-radius:0.2rem;}
.lyr-coupon .btn-close1 {position:absolute; top:0; right:0; width:16vw; height:16vw; font-size:0; color:transparent; background:url(//fiximage.10x10.co.kr/web2019/common/ico_x.png) no-repeat 50% / 5.4vw;}
.lyr-coupon h2 {font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; font-size:1.88rem;}
.lyr-coupon .cpn {position:relative; width:54.13vw; margin:2.35rem auto 1.2rem;}
.lyr-coupon .cpn p {position:absolute; left:0; width:100%;}
.lyr-coupon .cpn .amt {top:20%; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:2.17rem; color:#fff;}
.lyr-coupon .cpn .amt b {margin-right:0.2rem; font-size:3.16rem; vertical-align:text-bottom;}
.lyr-coupon .cpn .txt1 {top:66%; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; font-size:1.02rem; color:#919ff2; letter-spacing:-.05rem;}
.lyr-coupon .cpn .txt1 b {margin-right:0.1rem; font-size:1.11rem;}
.lyr-coupon .txt2 {font-size:1.28rem; color:#999; line-height:1.96rem;}
.lyr-coupon .txt2 strong {font-weight:normal; color:#ff3434;}
.lyr-coupon .btn-area {margin-top:1.9rem; padding-bottom:0.6vw; font-size:0;}
.lyr-coupon .btn-area button {height:3.93rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; -webkit-border-radius:0.2rem; border-radius:0.2rem;}
.lyr-coupon .btn-area .btn-close2 {width:9.3rem; font-size:1.28rem; background-color:#c2c2c2; color:#444;}
.lyr-coupon .btn-area .btn-down {width:12.2rem; margin-left:0.7rem; font-size:1.24rem; background-color:#222; color:#fff;}
</style>
<script>
$(function(){
	$('.lyr-coupon .btn-close').click(function(e){
		e.preventDefault();
		$('.lyr-coupon').hide();
	});
});
function jsEvtCouponDown(stype, idx, cb) {
	<% If IsUserLoginOK() Then %>
	$.ajax({
			type: "POST",
			url: "/event/etc/coupon/couponshop_process.asp",
			data: "mode=cpok&stype="+stype+"&idx="+idx,
			dataType: "text",
			success: function(message) {
				if(message) {
					var str1 = message.split("||")
					if (str1[0] == "11"){
						fnAmplitudeEventMultiPropertiesAction('click_marketing_top_bnr','','')
						cb();
						return false;
					}else if (str1[0] == "12"){
						alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
						return false;
					}else if (str1[0] == "13"){
						alert('이미 다운로드 받으셨습니다.');
						return false;
					}else if (str1[0] == "02"){
						alert('로그인 후 쿠폰을 받을 수 있습니다!');
						return false;
					}else if (str1[0] == "01"){
						alert('잘못된 접속입니다.');
						return false;
					}else if (str1[0] == "00"){
						alert('정상적인 경로가 아닙니다.');
						return false;
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				}
			}
	})
	<% Else %>
		jsEventLogin();
		return false;
	<% End IF %>
}
function handleClicKBanner(isapp, link, bannerType, couponidx, lyrId){
	var couponType

	if(bannerType == 1){ //링크배너
		if(isapp == 1){
			fnAmplitudeEventMultiPropertiesAction('click_marketing_top_bnr','','', function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014'+link);return false;}});
		}else{
			fnAmplitudeEventMultiPropertiesAction('click_marketing_top_bnr','','')
			window.location.href = link
		}
	}else if(bannerType == 2){ //쿠폰배너
		couponType = couponidx == 1190 ? 'month' : 'evtsel'
		jsEvtCouponDown(couponType, couponidx, function(){
			popupLayer(lyrId)
		})
	}else{ // 레어어팝업 배너
		fnAmplitudeEventMultiPropertiesAction('click_marketing_top_bnr','','')
		popupLayer(lyrId)
	}
}
function handleClickBtn(url){
	<% if isapp = 1 then %>
	<% else %>
		window.location.href = url
	<% end if %>
}
function popupLayer(lyrId){
	$("#"+lyrId).show();
}
function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(request.serverVariables("SCRIPT_NAME")&"?"&Request.ServerVariables("QUERY_STRING")) %>";
<% end if %>
	return;
}

function eventClicKBanner(isapp, link, actionEvent, actionEventProperty, actionEventPropertyValue){
	if(isapp == 1){
		fnAmplitudeEventMultiPropertiesAction(actionEvent, actionEventProperty, actionEventPropertyValue, function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014'+link);return false;}});
	}else{
		fnAmplitudeEventMultiPropertiesAction(actionEvent, actionEventProperty, actionEventPropertyValue)
		window.location.href = link
	}	
}
</script>
<%'쿠폰배너 공통 스크립트, css%>