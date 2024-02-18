<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 천원의 기적
' History : 2018-11-02 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
%>
<style type="text/css">
.mEvt90303 {background-color:#143ab7;}
.mEvt90303 img {width:100%;}
.bg-img {position:relative;}
.bg-img span.ico-img {display:block; animation:bounce2 1s 100 ease-in-out; position:absolute; top:29%; right:7%; width:28%;}
@keyframes bounce2 {from, to{transform:translateY(0);} 50%{transform:translateY(10px)}}
.mEvt90303 .info {position:relative;}
.mEvt90303 .btn-deposit {display:block; position:absolute; left:0; bottom:0; width:100%; height:30%; text-indent:-999em; color:transparent;}
</style>
<script>
function TnAddShoppingBag90303(){
	var frm = document.sbagfrm;
	var optCode = "0000";

	if (!frm.itemea.value){
		alert('장바구니에 넣을 수량을 입력해주세요.');
		return;
	}
	frm.itemoption.value = optCode;
	frm.mode.value = "DO3"; //2014 분기
	//frm.target = "_self";
	frm.target = "evtFrmProc"; //2014 변경
	frm.action="<%= appUrlPath %>/inipay/shoppingbag_process.asp";
	frm.submit();

	//setTimeout("parent.top.location.replace('<% '= appUrlPath %>/event/eventmain.asp?eventid=<%'= eCode %>')",500)
	return false;
}
</script>
<div class="mEvt90303">
	<div class="bg-img">
		<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/img_01.png?v=1.01" alt="1,000원의 기적">
		<span class="ico-img mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/ico_img.png" alt="only app"></span>
	</div>
	<% if isapp="1" then %>
		<a href="" onclick="TnAddShoppingBag90303();return false;" class="mApp"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/btn_img_app.png" alt="구매하러 가기"></a>
	<% else %>
		<a href="/apps/link/?12720181102" class="mWeb"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/btn_img_mw.png" alt="APP 설치하고 구매하러 가기"></a>
	<% End If %>
	<div class="info">
		<img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/img_info.png" alt="응모기간">
		<a href="<%=wwwUrl%>/my10x10/popDeposit.asp" class="btn-deposit mWeb">예치금이란?</a>
		<a href="" onclick="fnAPPpopupBrowserURL('예치금 안내','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/popDeposit.asp','bottom'); return false;" class="btn-deposit mApp">예치금이란?</a>
	</div>
	<p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/img_notice.png" alt="유의사항"></p>
	<% if isapp="1" then %>
		<a href="" onclick="fnAPPpopupEvent('90248');return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/bnr_img.png" alt="아이폰 케이스는 텐바이텐"></a>
	<% else %>
		<a href="/event/eventmain.asp?eventid=90248"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90303/m/bnr_img.png" alt="아이폰 케이스는 텐바이텐"></a>
	<% End If %>
</div>
<form name="sbagfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="itemid" value="2135191" />
<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
<input type="hidden" name="itemoption" value="0000" />
<input type="hidden" name="userid" value="<%= getEncloginuserid() %>" />
<input type="hidden" name="isPresentItem" value="" />
<input type="hidden" name="itemea" readonly value="1" />
</form>	
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->