<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2017 선착순 쿠폰
' History : 2017-07-13 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim eCode, couponcnt1, couponcnt2,  getbonuscoupon1, getbonuscoupon2, getbonuscoupon3
Dim logStore : logStore = requestCheckVar(Request("store"),16)

If logStore <> "" And Len(logstore) = 1 Then '// log입력
	sqlStr = " insert into db_temp.dbo.tbl_log_appdown_store (store) values ('"&logStore&"')"
	dbget.Execute sqlStr
End If 
IF application("Svr_Info") = "Dev" THEN
	eCode = 66395
	getbonuscoupon1 = 2851
Else
	eCode = 79116
	getbonuscoupon1 = 993	'5000/10000
End If

couponcnt1=0
couponcnt1 = getbonuscoupontotalcount(getbonuscoupon1, "", "", left(now(),10))
%>
<style>
.mEvt79116 h2 {visibility:hidden; width:0; height:0;}
.coupon {position:relative;}
.coupon p {position:absolute;}
.coupon .download {left:50%; bottom:8.77%; z-index:10; width:80%; margin-left:-40%;}
.coupon .open {left:50%; bottom:8.77%; z-index:10; width:80%; margin-left:-40%;}
.coupon .hurry {right:5%; top:41.5%; width:15.31%;}
.coupon .soldout {left:50%; bottom:8.77%; z-index:10; width:80%; margin-left:-40%;}
.coupon .lastday {right:3%; top:6.8%; width:16.25%; animation:bounce 1s 20;}
.evtNoti {padding-top:2.6rem; background:#737374;}
.evtNoti h3 {padding-bottom:1.4rem; font-size:1.6rem; line-height:1; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {border-bottom:0.15rem solid #fff;}
.evtNoti ul {padding:0 7.8%;}
.evtNoti li {position:relative; font-size:1rem; color:#fff; padding:0.3rem 0 0.3rem 1.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.65rem; width:0.6rem; height:0.15rem; background-color:#fff;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
	<% If IsUserLoginOK() Then %>
		<% If now() > #07/18/2017 23:59:59# then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			<% if GetLoginUserLevel()=7 then %>
				alert("Staff 참여는 불가능합니다.");
				return;
			<% else %>
				<% if getbonuscoupontotalcount(getbonuscoupon1, "", "", left(now(),10)) < 1000 then %>
					var str = $.ajax({
						type: "POST",
						url: "/event/etc/coupon/couponshop_process.asp",
						data: "mode=cpok&stype="+stype+"&idx="+idx,
						dataType: "text",
						async: false
					}).responseText;
					var str1 = str.split("||")
					if (str1[0] == "11"){
						alert('쿠폰이 발급되었습니다. 오늘 하루 app에서 사용하세요.');
						return false;
					}else if (str1[0] == "12"){
						alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
						return false;
					}else if (str1[0] == "13"){
						alert('이미 발급 받으셨습니다. 이벤트는 ID당 1회만 참여 할 수 있습니다.');
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
					alert('쿠폰이 마감되었습니다. 다음에 다시 도전하세요!');
					return false;
				<% end if %>
			<% end if %>
		<% end if %>
	<% Else %>
		if(confirm("로그인 후 쿠폰을 받을 수 있습니다!")){
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		}
		return false;
	<% End IF %>
}

var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	}
};
</script>
<!-- 선착순 쿠폰 -->
<div class="mEvt79116">
	<h2>선착순쿠폰 - 하루 1,000명에게 주어지는 APP 전용쿠폰에 도전하세요!</h2>
	<div class="coupon">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/img_coupon.png" alt="6만원이상 구매시 10,000할인, 10만원이상 구매시 15,000할인 쿠폰 한번에 다운 받기" /></div>
		<% If now() < #07/18/2017 23:59:59# then %>
			<% if couponcnt1 > 500 and couponcnt1 < 1000 then %>
				<!-- 마감임박 --><p class="hurry"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/txt_hurryup.png" alt="마감임박" /></p>
			<% End If %>
			<% if couponcnt1 >= 1000 then %>
				<!-- 마감 --><p class="soldout"><a href="" onclick="jsevtDownCoupon('evttosel,','<%= getbonuscoupon1 %>,'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/txt_finish.png" alt="쿠폰이 마감되었습니다. 다음에 다시 도전하세요!" /></a></p>
			<% Else %>
				<% If now() >= #07/17/2017 10:00:00# And now() <= #07/17/2017 23:59:59# then %>
				<!-- 쿠폰 다운로드 --><p class="download"><a href="" onclick="jsevtDownCoupon('evttosel,','<%= getbonuscoupon1 %>,'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/btn_download.png" alt="쿠폰 다운받기" /></a></p>
				<% ElseIf now() >= #07/18/2017 10:00:00# And now() <= #07/18/2017 23:59:59# then %>
				<!-- 쿠폰 다운로드 --><p class="download"><a href="" onclick="jsevtDownCoupon('evttosel,','<%= getbonuscoupon1 %>,'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/btn_download.png" alt="쿠폰 다운받기" /></a></p>
				<% Else %>
				<!-- 오전10시 오픈 --><p class="open"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/txt_open_10am.png" alt="오전 10시 오픈" /></p>
				<% End If %>
			<% End If %>
		<% Else %>
			<!-- 마지막날 --><p class="lastday"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/txt_last.png" alt="쿠폰이 마감되었습니다. 다음에 다시 도전하세요!" /></p>
			<!-- 마감 --><p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/txt_finish.png" alt="쿠폰이 마감되었습니다. 다음에 다시 도전하세요!" /></p>
		<% End If %>
	</div>
	<a href="javascript:gotoDownload();"><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/btn_app.png" alt="텐바이텐 APP 아직인가요? 텐바이텐 APP 다운받기" /></a>
	<div class="evtNoti">
		<h3><span>이벤트 유의사항</span></h3>
		<ul>
			<li>이벤트는 ID당 1회만 참여할 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐에서 APP만 사용 가능 합니다.</li>
			<li>쿠폰은 발급 당일 자정까지 사용 가능합니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/79116/m/img_ex.png" alt="" /></div>
	</div>
</div>
<!--// 선착순 쿠폰 -->
<%
If GetencLoginUserID="greenteenz" Or GetencLoginUserID="ksy92630" Or GetencLoginUserID="thensi7" Then
Response.write couponcnt1
End if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->