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
.mEvt88275 {background-color:#5391e4;}
.mEvt88275 a {position:relative;}
.mEvt88275 .hurry {display:inline-block; position:absolute; top:1.28rem; left:5.54rem; width:6.86rem; animation:bounce1 .6s 100;}
.noti {padding:3.41rem 0; color:#fff; background:#344983;}
.noti h3 {padding-bottom:1.5rem; text-align:center;}
.noti h3 strong {display:inline-block; padding-bottom:0.1rem; font-size:1.6rem; border-bottom:0.17rem solid #fff;}
.noti ul {padding:0 9%; font-size:1.1rem; line-height:1.2;}
.noti li {position:relative; padding:0.5rem 0 0 1.54rem; line-height:1.7rem;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0; top:1rem; width:0.6rem; height:0.13rem; background:#fff;}
.noti li a {display:inline-block; position:relative; height:2.13rem; margin:0.2rem 0; padding:0 1.7rem 0 0.9rem; color:#fff; font-weight:600; font-size:1rem; line-height:2.2rem; background:#383838;}
.noti li a:after {content:''; display:inline-block; position:absolute; right:1rem; top:0.76rem; width:0.4rem; height:0.4rem; border-right:0.11rem solid #fff;border-bottom:0.11rem solid #fff; transform:rotate(-45deg);}
@keyframes bounce1 {
	from,to {transform:translateY(-3px); animation-timing-function:ease-in;}
	50% {transform:translateY(6px); animation-timing-function:ease-out;}
}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #07/30/2018 00:00:00# and now() < #07/30/2018 23:59:59# then %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n7월 30일 자정까지 사용하세요. ');
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
<div class="mEvt88275">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/88275/m/img_coupon.jpg" alt="월요쿠폰" /></h2>
	<% If isapp="1" Then %>
	<a href="" onclick="jsevtDownCoupon('evttosel,evttosel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88275/m/btn_down_app.jpg" alt="쿠폰 한번에 다운받기" /><% If Left(FormatDateTime(Now(),4),2) > 17 Then %><span class="hurry"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88275/m/txt_hurry.png" alt="마감임박" /></span><% End If %></a>
	<% Else %>
	<a href="http://m.10x10.co.kr/apps/link/?11820180727"><img src="http://webimage.10x10.co.kr/eventIMG/2018/88275/m/btn_down_mw.jpg" alt="앱에서 쿠폰 받으러 가기"/></a>
	<% End If %>
	<div class="noti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
			<li>쿠폰은 텐바이텐 APP에서만 <%=chkiif(isapp,"사용","발급")%> 가능 합니다.</li>
			<li>쿠폰은 7/30(월) 23시 59분 59초에 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
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