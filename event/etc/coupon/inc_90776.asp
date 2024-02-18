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
' Description : 월요쿠폰
' History : 2018-07-27 이종화
'####################################################
Dim eCode, couponcnt,  getbonuscoupon1 , getbonuscoupon2 , totalbonuscouponcountusingy1 , totalbonuscouponcountusingy2
Dim userid :  userid = getencloginuserid()
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67488
	getbonuscoupon1 = 2863
	getbonuscoupon2 = 2864
Else
	eCode   =  88275
	getbonuscoupon1 = 1068
	getbonuscoupon2 = 1069
End If

'// 쿠폰 카운트
couponcnt = getbonuscoupontotalcount(getbonuscoupon1&","&getbonuscoupon2, "", "", "")

if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" or userid = "motions" Or userid = "leelee49" Then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
end if

%>
<style type="text/css">
    .mEvt90776 {background-color: #fec168;}
    .mEvt90776 a {position:relative;}
    .mEvt90776 .hurry {display:inline-block; position:absolute; top:1.28rem; left:5.54rem; width:6.86rem; animation:bounce1 .6s 100;}
    .noti {padding:3.41rem 0; color:#fff; background:#282f39;}
    .noti h3 {padding-bottom:1.5rem; text-align:center;}
    .noti h3 strong {display:inline-block; padding-bottom:0.1rem; font-size:1.6rem; border-bottom:0.17rem solid #fff;}
    .noti ul {padding:0 9%; font-size:1.1rem; line-height:1.2;}
    .noti li {position:relative; padding:0.5rem 0 0 1.54rem; line-height:1.7rem;}
    .noti li:after {content:''; display:inline-block; position:absolute; left:0; top:1rem; width:0.6rem; height:0.13rem; background:#fff;}
    .noti li a {display:inline-block; position:relative; height:2.13rem; margin:0.2rem 0; padding:0 1.7rem 0 0.9rem; color:#fff; font-weight:600; font-size:1rem; line-height:2.2rem; background:#383838;}
    .noti li a:after {content:''; display:inline-block; position:absolute; right:1rem; top:0.76rem; width:0.4rem; height:0.4rem; border-right:0.11rem solid #fff;border-bottom:0.11rem solid #fff; transform:rotate(-45deg);}
    .noti li.pointcolor{color: #ff8686; font-weight: bold;}
    @keyframes bounce1 {
        from,to {transform:translateY(-3px); animation-timing-function:ease-in;}
        50% {transform:translateY(6px); animation-timing-function:ease-out;}
    }
    </style>

<div class="mEvt90776">
    <h2><img src="http://webimage.10x10.co.kr/fixevent/event//2018/90776/m/img_coupon.jpg" alt="월요쿠폰" /></h2>
	<a href="http://m.10x10.co.kr/apps/link/?12920181123"><img src="http://webimage.10x10.co.kr/fixevent/event//2018/90776/m/btn_down_mw.jpg" alt="앱에서 쿠폰 받으러 가기" /></a>
	<div class="noti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
            <li>본 이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
            <li class="pointcolor">쿠폰은 텐바이텐 APP에서만 발급 가능 합니다.</li>
            <li>쿠폰은 11/26(월) 23시 59분 59초에 종료됩니다.</li>
            <li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
            <li>이벤트는 조기 마감될 수 있습니다.</li>
        </ul>
	</div>
</div>

<!-- #include virtual="/lib/db/dbclose.asp" -->