<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2017 하나은행 웨이크업 쿠폰
' History : 2017-06-14 유태욱
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
dim getbonuscoupon1, getbonuscoupon2, getbonuscoupon3, couponcnt1
dim totalbonuscouponcountusingy1, totalbonuscouponcountusingy2, totalbonuscouponcountusingy3
dim hanauser, hanaeCode, hanauserreal

IF application("Svr_Info") = "Dev" THEN
	eCode = 66342
	hanaeCode = 66323
	getbonuscoupon1 = 2845	
Else
	eCode = 78488
	hanaeCode = 77767
	getbonuscoupon1 = 986	'5000/20000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
end if

dim sqlstr
hanauser = 999
hanauserreal = 999

if userid <> "" then
	sqlstr = "select count(*) From [db_event].[dbo].[tbl_event_subscript] as s " + vbcrlf
	sqlstr = sqlstr & " join db_user.dbo.tbl_logindata as l " + vbcrlf
	sqlstr = sqlstr & " 	on s.userid=l.userid " + vbcrlf
	sqlstr = sqlstr & " Where s.evt_code="& hanaeCode &" and s.userid='"& userid &"' and l.userlevel=5 "
	rsget.Open sqlstr, dbget, 1
		hanauser = rsget(0)
	rsget.close

	if hanauser > 0 then
		sqlstr = "select count(*) From db_order.dbo.tbl_order_master as m " + vbcrlf
		sqlstr = sqlstr & " Where m.userid='"& userid &"' "
		rsget.Open sqlstr, dbget, 1
			hanauserreal = rsget(0)
		rsget.close
	end if 
end if
%>
<style type="text/css">
.evtNoti {padding:4rem 6.25% 3.2rem; color:#fff; background:#999;}
.evtNoti h3 {padding-bottom:1.5rem; font-size:1.5rem; font-weight:bold;}
.evtNoti li {position:relative; font-size:1.1rem; padding:0 0 0.6rem 1.1rem;}
.evtNoti li strong {color:#ffdc52;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.3rem; width:0.3rem; height:0.3rem; background-color:#fff; border-radius:50%;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt78488").offset().top}, 0);
});

function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #06/15/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			<% if hanauserreal < 1 then %>
				var str = $.ajax({
					type: "POST",
					url: "/event/etc/coupon/couponshop_process.asp",
					data: "mode=cpok&stype="+stype+"&idx="+idx,
					dataType: "text",
					async: false
				}).responseText;
				var str1 = str.split("||")
				if (str1[0] == "11"){
					alert('쿠폰이 발급 되었습니다.\n오늘 밤 23시 59분 59초까지 사용할 수 있어요!');
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
				alert('이벤트 대상자가 아닙니다.');
				return false;
			<% end if %>
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
	<!-- 웰컴쿠폰 -->
	<div class="mEvt78488">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78488/m/tit_welcome.png" alt="WELCOME! 오늘 하루 5천원 할인" /></h2>
		<div class="coupon">
			<a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon1 %>'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78488/m/btn_coupon.png" alt="2만원이상 구매시 5천원 할인 쿠폰 발급 받기" /></a>
		</div>
		<div class="evtNoti">
			<h3><span>이벤트 유의사항</span></h3>
			<ul>
				<li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
				<li>텐바이텐 <strong>orange 등급</strong>을 대상으로 하는 이벤트 입니다.</li>
				<li>쿠폰은 6/15(목) 23시59분59초에 종료됩니다.</li>
				<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
				<li>이벤트는 조기 마감될 수 있습니다.</li>
			</ul>
		</div>
		<%
		if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" then
			response.write couponcnt&"-발행수량<br>"
			response.write totalbonuscouponcountusingy1&"-사용수량<br>"
		end  if
		%>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->
	