<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2019 브랜드쿠폰 - 달콤한 향으로 기억될 12월
' History : 2019-12-10 이종화
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
dim totalbonuscouponcountusingy1

IF application("Svr_Info") = "Dev" THEN
	eCode = 90443
	getbonuscoupon1 = 2943
Else
	eCode = 99271
	getbonuscoupon1 = 1262	
End If

userid = getencloginuserid()

couponcnt=0
totalbonuscouponcountusingy1=0

couponcnt = getbonuscoupontotalcount(getbonuscoupon1, "", "", "")

if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" Or userid="motions" then
	totalbonuscouponcountusingy1 = getbonuscoupontotalcount(getbonuscoupon1, "", "Y","")
end if
%>
<script type="text/javascript">
function jsevtDownCoupon(stype,idx){
    <% If IsUserLoginOK() Then %>
        fnAmplitudeEventMultiPropertiesAction('click_couponevent','eventcode|platform','99271|<%=chkiif(isapp = 1 ,"APP","MOBILE")%>');
		<% If not(now() >= #12/10/2019 00:00:00# And now() < #12/31/2019 23:59:59#) then %>
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
				alert('쿠폰이 발급 되었습니다.\n12월 31일까지 사용하세요 :)');
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
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<div class="mEvt99271">
    <%
        if userid = "greenteenz" or userid = "cogusdk" or userid = "helele223" or userid = "ksy92630" or userid = "thensi7" Or userid="leelee49" Or userid="motions" then
            response.write couponcnt&"-발행수량<br>"
            response.write totalbonuscouponcountusingy1&"-사용수량<br>"
        end if
    %>
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99271/m/tit.jpg" alt="달콤한 향으로 기억될 12월"></h2>
    <a href="" onclick="jsevtDownCoupon('evtsel','<%= getbonuscoupon1 %>'); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99271/m/img_coupon.jpg" alt="쿠폰 다운받기"></a>
    <a href="#group308726"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99271/m/btn_1.jpg" alt="WOMAN"></a>
    <a href="/category/category_itemPrd.asp?itemid=2593945&pEtr=98531" onclick="TnGotoProduct('2593945');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99271/m/img_prd1.jpg" alt="랑방 에끌라 드 아르페쥬 EDP 30ml "></a>
    <a href="#group308727"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99271/m/btn_2.jpg" alt="MAN"></a>
    <a href="/category/category_itemPrd.asp?itemid=2599688&pEtr=98531" onclick="TnGotoProduct('2599688');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99271/m/img_prd2.jpg" alt="존바바토스 아티산 EDT 125ml "></a>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->