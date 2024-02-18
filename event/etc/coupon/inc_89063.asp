<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2018 추석 쿠폰
' History : 2018-09-07 원승현
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

IF application("Svr_Info") = "Dev" THEN
	eCode = 89063
	getbonuscoupon1 = 2885
	getbonuscoupon2 = 2886
	getbonuscoupon3 = 2887
Else
	eCode = 89063
	getbonuscoupon1 = 1078	'3000/40000
	getbonuscoupon2 = 1079	'10000/70000
	getbonuscoupon3 = 1080  '30000/200000
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0
totalbonuscouponcountusingy2=0
totalbonuscouponcountusingy3=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
	totalbonuscouponcountusingy2 = getbonuscoupontotalcount(getbonuscoupon2, "", "Y","")
	totalbonuscouponcountusingy3 = getbonuscoupontotalcount(getbonuscoupon3, "", "Y","")
end if
%>
<style type="text/css">
.mEvt89063 .coupon {position:relative;}
.mEvt89063 .coupon a {display:block;}
.mEvt89063 .coupon .hurry {position:absolute; bottom:10%; left:6%; z-index:10; width:16.5%; animation:blinker 1s linear infinite;}
.mEvt89063 .related {position:relative;}
.mEvt89063 .related a {display:block; position:absolute; text-indent:-999em;}
.mEvt89063 .related .bnr1 {top:17%; left:0; width:50%; height:29%;}
.mEvt89063 .related .bnr2 {top:17%; right:0; width:50%; height:29%;}
.mEvt89063 .related .bnr3 {top:46.5%; left:0; width:50%; height:28%;}
.mEvt89063 .related .bnr4 {top:46.5%; right:0; width:50%; height:28%;}
.mEvt89063 .related .bnr5 {top:75%; left:0; width:100%; height:19%;}
.evtNoti {padding:3.6rem 0; background:#303030;}
.evtNoti h3 {padding-bottom:2.4rem; font-size:1.6rem; font-weight:bold; color:#fff; text-align:center;}
.evtNoti h3 span {border-bottom:0.14rem solid #fff;}
.evtNoti ul {padding:0 6.6%;}
.evtNoti li {position:relative; font-family:'AppleSDGothicNeo-Regular'; font-size:1.11rem; line-height:1.87rem; color:#fff; padding-left:1.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.8rem; width:0.6rem; height:0.14rem; background-color:#fff;}
@keyframes blinker {
    0% {opacity:1;}
    50% {opacity:1;}
    75% {opacity:0;}
    100% {opacity:1;}
}
</style>
<script type="text/javascript">

function jsevtDownCoupon(stype,idx){
    <% If IsUserLoginOK() Then %>
        fnAmplitudeEventMultiPropertiesAction('click_couponevent','eventcode|platform','89063|app');
		<% If not(now() >= #09/10/2018 00:00:00# And now() < #09/12/2018 00:00:00#) then %>
			alert("이벤트 기간이 아닙니다.");
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
				alert('쿠폰이 발급 되었습니다.\n9월 11일까지 알차게 사용하세요 :) ');
				return false;
			}else if (str1[0] == "12"){
				alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 다운로드 받으셨습니다.');
				<% If isapp="1" Then %>
					var scmove = $('#appEvtBanner89063').offset().top;
					$('html, body').animate( { scrollTop : scmove }, 400 );
				<% End If %>
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

<div class="mEvt89063">
    <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89063/m/tit_coupon.jpg" alt="추석 쿠폰세트"></h2>
    <div class="coupon">
        <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89063/m/img_coupon.jpg" alt=""></p>

		<%' 18시 이후부터 마감임박 시 노출 %>
		<% If now() >= #09/11/2018 18:00:00# then %>
            <span class="hurry"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89063/m/img_hurry.png" alt="마감임박"></span>
        <% End If %>

        <% If isApp="1" Then %>
            <a href="" onclick="jsevtDownCoupon('evtsel,evtsel,evtsel','<%= getbonuscoupon1 %>,<%= getbonuscoupon2 %>,<%=getbonuscoupon3%>'); return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89063/m/app_btn.jpg" alt="쿠폰 한번에 다운받기"></a>
        <% Else %>
            <a href="http://m.10x10.co.kr/apps/link/?12020180904" onclick="fnAmplitudeEventMultiPropertiesAction('click_couponevent','eventcode|platform','89063|mobile');" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/89063/m/mw_btn.jpg" alt="APP에서 쿠폰 받기"></a>
        <% End If %>
    </div>

    <%' for dev msg : APP에서만 노출 배너 %>
    <% if isApp="1" Then %>
        <div class="related" id="appEvtBanner89063">
            <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89124');return false;" class="bnr1 mApp">추석 선물 준비!</a>
            <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89125');return false;" class="bnr2 mApp">작은 홈 좋은 가격</a>
            <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88603');return false;" class="bnr3 mApp">가을 신상 리빙템</a>
            <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=89089');return false;" class="bnr4 mApp">가을 페스티벌</a>
            <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=88892');return false;" class="bnr5 mApp">반짝반짝 추석 선물</a>
            <img src="http://webimage.10x10.co.kr/fixevent/event/2018/89063/m/bnr_related.jpg" alt="쿠폰받아 쇼핑하자!">
        </div>
    <% End If %>

    <div class="evtNoti">
        <h3><span>이벤트 유의사항</span></h3>
        <ul>
            <li>이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
            <li>쿠폰은 9/11(화) 23시 59분 59초에 종료됩니다.</li>
            <li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
            <li>이벤트는 조기 마감될 수 있습니다.</li>
        </ul>
    </div>

	<%
	if userid = "baboytw" or userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" then
		response.write couponcnt&"-발행수량<br>"
		response.write totalbonuscouponcountusingy1&"-사용수량(3,000/40,000)<br>"
		response.write totalbonuscouponcountusingy2&"-사용수량(10,000/70,000)<br>"
		response.write totalbonuscouponcountusingy3&"-사용수량(30,000/200,000)<br>"
	end if
	%>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->