<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  2016년 VIP GIFT
' History : 2016-08-31 이종화 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
	dim oUserInfo
	set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = GetEncLoginUserID
	if (GetEncLoginUserID<>"") then
		oUserInfo.GetUserData
	end If

	chkyn = False

	Dim sqlstr , chkcnt , chkyn
	Dim userid :  userid = GetEncLoginUserID
	if userid <> "" Then
		sqlstr = "select count(userid) as cnt from db_log.[dbo].[tbl_vip_user_log] where ulevel=6 and yyyymm >= '2016-08' and userid = '"& userid &"' "
		rsget.Open sqlstr,dbget,1
			chkcnt = rsget("cnt")
		rsget.Close
	End If

	If chkcnt > 0 Then
		chkyn = True
	Else
		chkyn = False
	End If

	'//테스트용
	If userid = "helele223" Or userid = "motions" Then
		chkyn = true
	End If 
%>
<style type="text/css">
img {vertical-align:top;}

#item .app {display:none;}

.apply {background-color:#f2f2f2;}
.apply .row {padding-bottom:12%;}
.apply .row .btnEnter {display:block; width:78.125%; margin:0 auto;}
.apply .address {margin:0 4.6875% 12%; padding:8% 6.896% 6%; background-color:#fff;}
.apply .address legend {visibility:hidden; width:0; height:0;}
.apply .address h4 {color:#b87407; font-size:1.5rem; font-weight:bold; text-align:center;}
.apply .address .selectOption {margin-top:1.5rem; text-align:center;}
.apply .address .selectOption span {padding:0 0.5rem;}
.apply .address .selectOption input {margin-right:0.5rem; border-radius:50%; vertical-align:top;}
.apply .address .selectOption label {color:#888; font-size:1.1rem; font-weight:bold; line-height:1.75em; vertical-align:middle;}
.apply .address .selectOption input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.apply .address table {margin-top:0.5rem;}
.apply .address table caption {visibility:hidden; width:0; height:0;}
.apply .address table th {width:22%; padding:2rem 0 1rem; color:#595858; font-size:1.2rem; font-weight:bold; text-align:left; vertical-align:top;}
.apply .address table td {width:78%; padding:1rem 0;}
.apply .address table input {width:100%; height:3.4rem; border:1px solid #ddd; border-radius:0; color:#999; font-size:1.2rem;}
.apply .address table .group {display:table; position:relative; width:100%;}
.apply .address table .group span, .apply .address table .group i {display:table-cell; vertical-align:middle; text-align:center;}
.apply .address table .group i {width:6%; height:3.4rem; color:#ddd; text-align:center;}
.apply .address table .group span input {padding:0; text-align:center;}
.apply .address table .group span {width:28.2%; height:3.4rem;}
.apply .address table .group .btnFind {display:table-cell; width:64%; height:3.4rem; line-height:3.4rem; text-align:center;}
.apply .address table .group .btnFind span {display:block; width:100%; background-color:#000; color:#fff; font-size:1.1rem;}
.apply .btnsubmit {margin-top:1rem;}
.apply .btnsubmit input {width:100%;}
.apply ul {margin-top:1.5rem;}
.apply ul li {margin-bottom:0.5rem; padding-left:10px; color:#6b6b6b; font-size:1rem; line-height:1.2em; text-indent:-10px;}

.noti {padding-bottom:8%; background-color:#e1e1e1;}
.noti ul {padding:0 8.125%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#969696; font-size:1.1rem; line-height:1.5em;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#969696;}
</style>
<script>
$(function(){
	$("#address").hide();
	var chkapp = navigator.userAgent.match("tenapp");
	if ( chkapp ){
			$("#item .app").show();
			$("#item .mo").hide();
	}else{
			$("#item .app").hide();
			$("#item .mo").show();
	}
});

function jsvipgo(){
	<% if Not(IsUserLoginOK) then %>
		<% if isApp then %>
			calllogin();
		<% else %>
			jsevtlogin();
		<% end if %>
	<% else %>
		<% if chkyn = true or GetLoginUserLevel() = 6 then %>
			$("#address").slideDown("slow");
			return false;
		<% else %>
			alert('VVIP 등급만 참여 하실 수 있습니다.');
		<% end if %>
	<% end if %>
}

function jsSubmitComment(){
	var frm = document.frmorder
	<% if Not(IsUserLoginOK) then %>
		jsChklogin('<%=IsUserLoginOK%>');
		return false;
	<% end if %>

	if(!frm.reqname.value){
		alert("이름을 입력 해 주세요");
		frm.reqname.focus();
		return false;
	}

	if(!frm.reqhp1.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp1.focus();
		return false;
	}

	if(!frm.reqhp2.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp2.focus();
		return false;
	}

	if(!frm.reqhp3.value){
		alert("휴대폰번호를 입력 해주세요");
		frm.reqhp3.focus();
		return false;
	}

	if(!frm.txZip.value){
		alert("우편번호를 입력 해주세요");
		frm.txZip.focus();
		return false;
	}

	if (frm.txAddr1.value.length<1){
        alert('수령지 도시 및 주를  입력하세요.');
        frm.txAddr1.focus();
        return false;
    }

    if (frm.txAddr2.value.length<1){
        alert('수령지 상세 주소를  입력하세요.');
        frm.txAddr2.focus();
        return false;
    }

	frm.mode.value = "inst";
	frm.action = "/event/etc/doeventsubscript/doEventSubscript72840.asp";
	frm.submit();
	return;
}

function chgaddr(v){
	var frm = document.frmorder

	if (v == "N")
	{
		frm.reqname.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (v == "R"){
		frm.reqname.value = frm.tmp_reqname.value;
		frm.reqhp1.value = frm.tmp_reqhp1.value;
		frm.reqhp2.value = frm.tmp_reqhp2.value;
		frm.reqhp3.value = frm.tmp_reqhp3.value;
		frm.txZip.value = frm.tmp_txZip.value;
		frm.txAddr1.value = frm.tmp_txAddr1.value;
		frm.txAddr2.value = frm.tmp_txAddr2.value;
	}

}
</script>
<div class="mEvt72840">
	<div class="topic">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72840/m/txt_tenbyten_vip.png" alt="특별한 당신을 위한 특별한 선물 VIP고객님을 위한 VIP GIFT를 신청하세요!" /></p>
	</div>

	<div id="item" class="item">
		<a href="/category/category_itemPrd.asp?itemid=1436060&amp;pEtr=72859" class="mo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72840/m/img_gift.jpg" alt="Takus 마리골드 키링 색상 랜덤" /></a>
		<a href="/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=1436060&amp;pEtr=72859" onclick="fnAPPpopupProduct('1436060&amp;pEtr=72859');return false;" class="app"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72840/m/img_gift.jpg" alt="Takus 마리골드 키링 색상 랜덤" /></a>
	</div>

	<div class="apply">
		<div class="row">
			<h3 class="hidden">신청방법</h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/72840/m/txt_way_apply.png" alt="8월, 9월 VVIP 회원 모두 신청 대상이시며, 주소확인기간은는2016년 8월 31일부터 9월 7일 월요일까지 VIP GIFT를 신청해주세요." /></p>
			<a href="" onclick="jsvipgo();return false;" id="btnEnter" class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/72840/m/btn_enter.png" alt="VIP 입장하기" /></a>
		</div>
		<div id="address" class="address" style="display:none;">
			<%If oUserInfo.FresultCount >0 Then %>
			<form name="frmorder" method="post">
			<input type="hidden" name="reqphone1"/>
			<input type="hidden" name="reqphone2"/>
			<input type="hidden" name="reqphone3"/>
			<input type="hidden" name="mode"/>
			<input type="hidden" name="tmp_reqname" value="<%=oUserInfo.FOneItem.FUserName%>"/>
			<input type="hidden" name="tmp_reqhp1" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>"/>
			<input type="hidden" name="tmp_reqhp2" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>"/>
			<input type="hidden" name="tmp_reqhp3" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>"/>
			<input type="hidden" name="tmp_txZip" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>-<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>"/>
			<input type="hidden" name="tmp_txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"/>
			<input type="hidden" name="tmp_txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"/>
				<fieldset>
				<legend>VIP GIFT 배송지 주소 입력</legend>
					<h4>배송지 주소 확인하기</h4>
					<div class="selectOption">
						<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');"  checked/><label for="address01">기본 주소</label></span>
						<span><input type="radio" id="address02" id="addr02" name="addr" value="2" onclick="chgaddr('N');"/><label for="address02">새로운 주소</label></span>
					</div>

					<table style="width:100%;">
						<caption>배송지의 이름, 휴대폰, 주소 정보</caption>
						<tbody>
						<tr>
							<th scope="row" style="width:22%;"><label for="username">이름</label></th>
							<td style="width:78%;"><input type="text" id="username" value="<%=oUserInfo.FOneItem.FUserName%>" name="reqname" /></td>
						</tr>
						<tr>
							<th scope="row">휴대폰</th>
							<td>
								<div class="group">
									<span><input type="text" title="휴대폰번호 앞자리" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" name="reqhp1"/></span><i>-</i>
									<span><input type="text" title="휴대폰번호 가운데 자리" value="0000" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" name="reqhp2"/></span><i>-</i>
									<span><input type="text" title="휴대폰번호 뒷자리" value="0000" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" name="reqhp3"/></span>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">주소</th>
							<td>
								<div class="group zipcode">
									<span><input type="text" title="우편번호" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>-<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>" name="txZip" /></span><i></i>
									<a href="" <% If isapp = "1" Then %>onclick='fnAPPpopupBrowserURL("우편번호 찾기","<%=wwwUrl%>/apps/appCom/wish/web2014/lib/pop_searchzipNew.asp?target=frmorder&gb=zip2016","","zip"); return false;'<% Else %>onclick="fnOpenModal('/lib/pop_searchzipNew.asp?target=frmorder&gb=5'); return false;"<% End If %>class="btnFind"><span>우편번호 찾기</span></a>
								</div>
								<input type="text" title="기본주소" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" style="margin-top:0.5rem;" />
								<input type="text" title="상세주소" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" style="margin-top:0.5rem;" />
							</td>
						</tr>
						</tbody>
					</table>

					<div class="btnsubmit" onclick="jsSubmitComment();return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2016/72840/m/btn_submit.png" alt="VIP GIFT 신청완료" /></div>

					<ul>
						<li>- 기본 회원 정보 주소를 불러오며 수정 가능합니다.</li>
						<li>- 신청이 완료된 후에는 주소를 변경하실 수 없습니다.</li>
					</ul>
				</fieldset>
			</form>
			<% End If %>
		</div>
	</div>

	<div class="noti">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/72840/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
		<ul>
			<li>8월 / 9월 텐바이텐 VVIP 회원만 신청이 가능합니다.</li>
			<li>최초 VVIP 달성 시 지급되는 GIFT로, 1회만 신청 할 수 있습니다.</li>
			<li>사은품은 현금 성 환불이 불가 합니다.</li>
			<li>본 사은품은 한정 수량으로 조기 선착순 마감 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<%
	Set oUserInfo = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->