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
' Description : 서프라이즈 쿠폰
' History : 2018-09-28 이종화
'####################################################
Dim eCode, couponcnt,  getbonuscoupon1 , getbonuscoupon2 , totalbonuscouponcountusingy1 , totalbonuscouponcountusingy2
Dim userid :  userid = getencloginuserid()

eCode   =  89550
getbonuscoupon1 = 1092
getbonuscoupon2 = 1093

'// 쿠폰 카운트
couponcnt = getbonuscoupontotalcount(getbonuscoupon1&","&getbonuscoupon2, "", "", "")

if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" or userid = "motions" Or userid = "leelee49" Then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
end if
%>
<style type="text/css">
.mEvt89550 div {position:relative}
.mEvt89550 div span{display:block;position:relative}
.mEvt89550 button {background:none;position:absolute;width: 75%;bottom: 7%;left: calc(50% - 37.5%);}
.mEvt89550 .notice ul{position:absolute;top:38%;padding: 0 1rem 0;}
.mEvt89550 .notice li{font-size: 1.07rem;line-height: 1.87rem;color:#1f5741;}
</style>
<script>
function fnAppCoupon(){
    location.href = "http://m.10x10.co.kr/apps/link/?12420180927";
}
</script>
<div class="mEvt89550">
    <div>
        <span class="img-bg"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89550/m/bg_coupon.png" alt="" /></span>
        <button onclick="fnAppCoupon();"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89550/m/btn_coupon.png" alt="" /></button>
    </div>
    <div class="notice">
        <span class="img-bg"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89550/m/bg_notice.png" alt="" /></span>
        <ul>
            <li>- 본 이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
            <li class="blue">- 지급된 쿠폰은 텐바이텐 APP에서만 사용 가능 합니다.</li>
            <li>- 쿠폰은 10/01(월) 23시 59분 59초에 종료됩니다.</li>
            <li>- 주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
            <li>- 이벤트는 조기 마감될 수 있습니다.</li>
        </ul>
    </div>
</div>
<%
if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" or userid = "motions" Or userid = "leelee49" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량 : 쿠폰번호 "&getbonuscoupon1&"<br>"
	response.write totalbonuscouponcountusingy2&"-사용수량 : 쿠폰번호 "&getbonuscoupon2&""
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->