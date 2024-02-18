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
' Description : 복덩이쿠폰
' History : 2018-02-02 이종화
'####################################################
Dim eCode, couponcnt,  getbonuscoupon1 , getbonuscoupon2 , totalbonuscouponcountusingy1 , totalbonuscouponcountusingy2
Dim userid :  userid = getencloginuserid()
IF application("Svr_Info") = "Dev" THEN
	eCode   =  67488
	getbonuscoupon1 = 2863
	getbonuscoupon2 = 2864
Else
	eCode   =  84348
	getbonuscoupon1 = 1031
	getbonuscoupon2 = 1032
End If

'// 쿠폰 카운트
couponcnt = getbonuscoupontotalcount(getbonuscoupon1&","&getbonuscoupon2, "", "", "")

if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "corpse2" or userid = "motions" Then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
end if

%>
<style type="text/css">
.noti {padding:4.3rem 0 3.9rem; background:#333;}
.noti h3 {padding-bottom:1.6rem; font-size:1.56rem; font-weight:bold; color:#fff; text-align:center;}
.noti h3 span {display:inline-block; padding-bottom:0.1rem; border-bottom:0.15rem solid #fff;}
.noti ul {padding:0 7.7%;}
.noti li {position:relative; font-size:1.2rem; line-height:1.4; color:#fff; padding:0.1rem 0 0.1rem 1.4rem;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.7rem; width:0.6rem; height:0.13rem; background-color:#fff;}
.noti li span {color:#ffd631;}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #02/05/2018 00:00:00# and now() < #02/06/2018 23:59:59# then %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n2월 6일 자정까지 사용하세요. ');
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
<div class="mEvt84348">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/84348/m/tit_coupon.png" alt="복덩이 쿠폰" /></h2>
	<div class="coupon">
		<a href="" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84348/m/img_coupon.png" alt="7만원 이상 구매 시 1만원, 15만원 이상 구매 시 2만원 할인쿠폰 다운받기" /></a>
	</div>
	<div class="noti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>이벤트는 ID 당 1회만 참여할 수 있습니다. </li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
			<li><span>쿠폰은 2/6(화) 23시 59분 59초에 종료됩니다.</span></li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다. </li>
		</ul>
	</div>
</div>
<%
if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630"or userid = "corpse2" or userid = "motions" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량 : 쿠폰번호 "&getbonuscoupon1&"<br>"
	response.write totalbonuscouponcountusingy2&"-사용수량 : 쿠폰번호 "&getbonuscoupon2&""
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->