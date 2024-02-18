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
' Description : 2018 봄 쿠폰
' History : 2018-03-02 허진원
'####################################################
Dim eCode, couponcnt,  getbonuscoupon1 , getbonuscoupon2 , totalbonuscouponcountusingy1 , totalbonuscouponcountusingy2
Dim userid :  userid = getencloginuserid()
IF application("Svr_Info") = "Dev" THEN
	eCode = 67512
	getbonuscoupon1 = 2872
	getbonuscoupon2 = 2873
Else
	eCode = 84917
	getbonuscoupon1 = 1035
	getbonuscoupon2 = 1036
End If

'// 쿠폰 카운트
couponcnt = getbonuscoupontotalcount(getbonuscoupon1&","&getbonuscoupon2, "", "", "")

if userid = "greenteenz" or userid = "ley330" or userid = "kobula" or userid = "corpse2" or userid = "motions" or userid = "ttlforyou" Then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
end if

%>
<style type="text/css">
.noti {padding:3.8rem 7.7% 3.2rem; color:#fff; background:#777;}
.noti h3 {text-align:center; font-weight:bold; padding-bottom:1.88rem;}
.noti h3 span {display:inline-block; border-bottom:0.2rem solid #fff; font-size:1.54rem; line-height:1.54rem;}
.noti li {position:relative; padding-left:1.02rem; font-size:1.2rem; line-height:1.88rem;}
.noti li:after {content:' '; display:block; position:absolute; top:0.7rem; left:0; width:0.5rem; height:0.15rem; background-color:#fff;}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% if couponcnt <= 50000 then %>
		<% If IsUserLoginOK() Then %>
			<% If now() > #03/05/2018 00:00:00# and now() < #03/06/2018 23:59:59# then %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process.asp",
					data: "mode=cpok&stype="+stype+"&idx="+idx,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('쿠폰이 발급 되었습니다.\n3월 6일 자정까지 사용하세요. ');
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
	<% else %>
		alert('쿠폰이 모두 소진되었습니다.');
		return false;
	<% end if %>
}
</script>
<div class="mEvt84917">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/84917/m/tit_coupon.jpg" alt="봄쿠폰 - 여러분의 봄 쇼핑을 지원합니다! 쿠폰 다운받고 쇼핑의 꽃을 피우세요!" /></h2>
	<a href="" onclick="jsevtDownCoupon('evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84917/m/img_coupon.jpg" alt="6만원 이상 구매 시 10,000원, 20만원 이상 구매 시 30,000원 할인 쿠폰 다운받기" /></a>
	<a href="/event/appdown/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84917/m/btn_app.png" alt="텐바이텐 APP 아직이신가요? 텐바이텐 APP 다운받기" /></a>
	<% If Not IsUserLoginOK() Then %>
	<a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84917/m/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
	<a href="/member/join.asp" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84917/m/btn_join.png" alt="텐바이텐에 처음 오셨나요? 회원가입하러 가기" /></a>
	<% end if %>
	<div class="noti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
			<li style="color:#fffea7;">지급된 쿠폰은 텐바이텐에서만 사용 가능 합니다.</li>
			<li>쿠폰은 3/6(화) 23시 59분 59초에 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<%
if userid = "greenteenz" or userid = "ley330" or userid = "kobula" or userid = "corpse2" or userid = "motions" or userid = "ttlforyou" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량 : 쿠폰번호 "&getbonuscoupon1&"<br>"
	response.write totalbonuscouponcountusingy2&"-사용수량 : 쿠폰번호 "&getbonuscoupon2&""
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->