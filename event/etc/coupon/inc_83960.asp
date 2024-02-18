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
' Description : APP 첫 구매 쿠폰
' History : 2018-01-23 이종화
'####################################################
Dim eCode, couponcnt,  getbonuscoupon1 , totalbonuscouponcountusingy1
Dim userid :  userid = getencloginuserid()
Dim appdowncheck , itemordercheck
Dim couponImage

appdowncheck = True '// default 설치경험 있음
itemordercheck = True  '// 구매이력 있음
couponImage = "http://webimage.10x10.co.kr/eventIMG/2018/83960/m/img_coupon_v2.jpg"

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67488
	getbonuscoupon1 = 2863
Else
	eCode   =  83960
	getbonuscoupon1 = 1059
	If(datediff("d",now(),"2018-06-14") > 0) then
		getbonuscoupon1 = 1059
	Else
		getbonuscoupon1 = 1060
		couponImage = "http://webimage.10x10.co.kr/eventIMG/2018/83960/m/img_coupon_v3.jpg"
	End if
End If

'// 쿠폰 카운트
couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

'// 구매 이력 유무 (ID, 채널)
itemordercheck = fnUserGetOrderCheck(userid,"APP")

if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" or userid = "motions" Then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
end if
%>
<style type="text/css">
.mEvt83960 {background-color:#ff78c7;}
.mEvt83960 button {width:100%; background-color:transparent;}
.event-noti {padding:4.2rem 1rem 3.75rem 2.43rem ; background-color:#db3496; color:#fff;}
.event-noti h3 {position:relative; padding-right:.85rem; font-size:1.62rem; font-weight:bold; text-align:center; letter-spacing:.01rem;}
.event-noti h3:after {content:' '; display:block; position:absolute; bottom:-0.6rem; left:50%; width:10rem; height:2px; margin-left:-5.45rem; background-color:#fff;}
.event-noti ul {margin-top:2.39rem;}
.event-noti ul li {position:relative; padding-left:1.45rem; font-size:1.28rem; line-height:1.68em; font-weight:500;}
.event-noti ul li:after {content:' '; display:block; position:absolute; top:.8rem; left:0; width:.6rem; height:2px; background-color:#fff;}
.event-noti ul li.ylw{color:#fffd53;}
.event-noti ul li.ylw:after {background-color:#fffd53;}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt83960").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #01/24/2018 00:00:00# then %>
			<%' if not(itemordercheck) then  '// 두가지 조건이 모두 통과 해야 받음%>
				var str = $.ajax({
					type: "POST",
					url: "/common/appCouponIssued2.asp",
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str;
				if(str1 == 1){
					alert('쿠폰이 발급 되었습니다.\n24시간 이내 꼭 사용하세요.');
					return false;
				}else if(str1 == 77){
					alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
					return false;
				}else if(str1 == 88 || str1 == 99 ){
					alert('이벤트 대상이 아닙니다.');
					return false;
				}else if(str1 == 66 || str1 == 55 || str1 == 44){
					alert('이미 다운로드 받으셨습니다.');
					return false;
				}else{
					alert('오류가 발생했습니다.');
					return false;
				}
				// if (str1[0] == "11"){
				// 	alert('쿠폰이 발급 되었습니다.\n24시간 이내 꼭 사용하세요.');
				// 	return false;
				// }else if (str1[0] == "12"){
				// 	alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				// 	return false;
				// }else if (str1[0] == "13"){
				// 	alert('이미 다운로드 받으셨습니다.');
				// 	return false;
				// }else if (str1[0] == "02"){
				// 	alert('로그인 후 쿠폰을 받을 수 있습니다!');
				// 	return false;
				// }else if (str1[0] == "01"){
				// 	alert('잘못된 접속입니다.');
				// 	return false;
				// }else if (str1[0] == "00"){
				// 	alert('정상적인 경로가 아닙니다.');
				// 	return false;
				// }else{
				// 	alert('오류가 발생했습니다.');
				// 	return false;
				// }
			<%' else %>
				// alert("이벤트 대상이 아닙니다.");
				// return;
			<%' end if %>
		<% else %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<div class="mEvt83960">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/83960/m/tit_first_app.jpg" alt="APP 첫 구매 쿠폰 아직 APP에서 한번도 구매하지 않은 당신에게 보너스 쿠폰을 드립니다!" /></h2>
	<div><img src="<%=couponImage%>" alt="10,000원 * 사용기간 : 다운로드 후 24시간 * ID당 1회 사용가능" /></div>
	<button onclick="jsevtDownCoupon('evttosel24','<%= getbonuscoupon1 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/83960/m/btn_coupon.jpg" alt="쿠폰 다운받기" /></button>
	<div class="event-noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>본 이벤트의 대상자는 APP에서 구매 경험이 한 번도 없는 고객 기준으로 쿠폰을 발급받을 수 있습니다.</li>
			<li>이벤트는 ID 당 1회만 참여할 수 있습니다. </li>
			<li class="ylw">지급된 쿠폰은 텐바이텐 APP에서만 사용 가능 합니다.</li>
			<li>쿠폰은 발급 이후 24시간 이내 사용 가능합니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<%
if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" or userid = "motions" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량 : 쿠폰번호 "&getbonuscoupon1&"<br>"
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->