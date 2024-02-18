<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 웰컴쿠폰
' History : 2017-05-24 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, userid, couponcnt
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3

IF application("Svr_Info") = "Dev" THEN
	eCode = 66331
	getbonuscoupon1 = 2841
'	getbonuscoupon2 = 2842
'	getbonuscoupon3 = 0000
Else
	eCode = 78068
	getbonuscoupon1 = 979	'5000/30000
'	getbonuscoupon2 = 977	'30000/200000
'	getbonuscoupon3 = 000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
'totalbonuscouponcountusingy2=0
'totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
'	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
'	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end If

'// 현재 들어온 회원이 오렌지 등급인지 확인한다.
Dim strsql, chkOrangeUser

chkOrangeUser = False

strsql = " Select userid From db_user.dbo.tbl_logindata with (nolock) Where userlevel=5 And userid='"&userid&"' "
rsget.Open strsql,dbget,1
IF Not rsget.Eof Then
	chkOrangeUser = True
End If
rsget.close

%>
<style type="text/css">
.noti {padding:3.8rem 6.25%; color:#fff; background-color:#999;}
.noti h3 {padding-bottom:1.7rem; font-size:1.5rem; font-weight:bold; line-height:1; padding-bottom:rem;}
.noti li {position:relative; padding:0 0 0.5rem 1rem; font-size:1.1rem;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.25rem; width:0.35rem; height:0.35rem; background-color:#fff; border-radius:50%;}
.noti li strong {color:#ffdc52;}
</style>
<script type="text/javascript">



function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #05/28/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% elseif not(chkOrangeUser) then %>
			alert("본 이벤트는 orange 등급 전용 이벤트 입니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/etc/coupon/couponshop_process.asp",
				data: "mode=cpok&stype="+stype+"&idx="+idx,
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")
			if (str1[0] == "11"){
				alert('쿠폰이 발급 되었습니다.\n5월 28일까지 사용하세요. ');
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

<%' 웰컴 쿠폰 %>
<div class="mEvt78068">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78068/m/tit_welcome.png" alt="웰컴쿠폰 - 텐바이텐에서 아직 한 번도 구매하지 않았다면 4일간의 5천원 할인 찬스를 놓치지 마세요!" /></h2>
	<a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon1 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78068/m/btn_coupon.png" alt="3만원 이상 구매 시 5천원 할인쿠폰 발급받기" /></a>
	<div class="noti">
		<h3>이벤트 유의사항</h3>
		<ul>
			<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
			<li>텐바이텐 <strong>orange 등급</strong>을 대상으로 하는 이벤트 입니다.</li>
			<li>쿠폰은 5/28(일) 23시59분59초에 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<%' //웰컴 쿠폰 %>
<%
if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" Or userid="thensi7" then
	response.write couponcnt&"-발행수량<br>"
	response.write totalbonuscouponcountusingy1&"-사용수량(5,000/30,000)<br>"
end  if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->