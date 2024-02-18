<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<%
	Dim vQuery, vIdx, vResult, vItemID, vItemOption, vRequiredetail, vCouponNO, vOptionname, vMakerID, vBrandName, vListImage, vItemName
	vIdx = requestCheckVar(request("idx"),10)
	vItemID = requestCheckVar(request("itemid"),10)
	vIdx = "54"
	If vIdx = "" Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	IF IsNumeric(vIdx) = false Then
		Response.Write "<script language='javascript'>alert('잘못된 접근입니다.');document.location.href = '/';</script>"
		dbget.close()
		Response.End
	End If
	
	vQuery = "SELECT itemid, itemname, itemoption, couponno, itemoption, optionname, makerid, brandname, listimage, isNull(requiredetail,'') AS requiredetail "
	vQuery = vQuery & "From [db_order].[dbo].[tbl_mobile_gift] Where idx = '" & vIdx & "' AND gubun = 'gifticon'"
	rsget.Open vQuery,dbget,1
	IF Not rsget.EOF THEN
		vItemID			= rsget("itemid")
		vItemName		= rsget("itemname")
		vItemOption		= rsget("itemoption")
		vOptionname		= rsget("optionname")
		vCouponNO		= rsget("couponno")
		vItemOption 	= rsget("itemoption")
		vMakerID		= rsget("makerid")
		vBrandName		= rsget("brandname")
		vListImage		= rsget("listimage")
		vRequiredetail 	= db2html(rsget("requiredetail"))
	End IF
	rsget.close
	
	
	Dim userid, guestSessionID, i
	userid = GetLoginUserID
	guestSessionID = GetGuestSessionKey

	Dim oUserInfo
	set oUserInfo = new CUserInfo
	oUserInfo.FRectUserID = userid
	if (userid<>"") then
	    oUserInfo.GetUserData
	end if
	
	if (oUserInfo.FresultCount<1) then
	    ''Default Setting
	    set oUserInfo.FOneItem    = new CUserInfoItem
	end if

%>
<style type="text/css">
<!--
#boxscroll3 {
	height: 0px;
}
#boxscroll4 {
	height: 0px;
}
-->
</style>

<meta name="viewport" content="user-scalable=no" />

<script language="javascript">
var ChkErrMsg;

function check_form_email(email){
	var pos;
	pos = email.indexOf('@');
	if (pos < 0){				//@가 포함되어 있지 않음
		return(false);
	}else{
		
		pos = email.indexOf('@', pos + 1)
		if (pos >= 0)			//@가 두번이상 포함되어 있음
			return(false);
	}


	pos = email.indexOf('.');

	if (pos < 0){				//@가 포함되어 있지 않음
		return false;
    }
	return(true);
}

function copyDefaultinfo(comp){
    var frm = document.frmorder;
    
    if (comp.value=="O"){
        frm.reqname.value=frm.buyname.value;

		frm.reqphone1.value=frm.buyphone1.value;
		frm.reqphone2.value=frm.buyphone2.value;
		frm.reqphone3.value=frm.buyphone3.value;

		frm.reqhp1.value=frm.buyhp1.value;
		frm.reqhp2.value=frm.buyhp2.value;
		frm.reqhp3.value=frm.buyhp3.value;
		
		if (frm.buyZip1){
		    frm.txZip1.value = frm.buyZip1.value;
		    frm.txZip2.value = frm.buyZip2.value;
		    frm.txAddr1.value = frm.buyAddr1.value;
		    frm.txAddr2.value = frm.buyAddr2.value;
		}
		
    }else if (comp.value=="N"){
        frm.reqname.value = "";
        frm.reqphone1.value = "";
        frm.reqphone2.value = "";
        frm.reqphone3.value = "";
        frm.reqhp1.value = "";
        frm.reqhp2.value = "";
        frm.reqhp3.value = "";
        frm.txZip1.value = "";
        frm.txZip2.value = "";
        frm.txAddr1.value = "";
        frm.txAddr2.value = "";
    }else if (comp.value=="M"){     //해외주소New
        frm.reqname.value = "";
        frm.reqphone1.value = "";
        frm.reqphone2.value = "";
        frm.reqphone3.value = "";
        frm.reqphone4.value = "";
        
        frm.reqemail.value = "";
        frm.emsZipCode.value = "";
        
        frm.txAddr1.value = "";
        frm.txAddr2.value = "";
    }else if (comp.value=="F"){
        PopSeaAddress();
    }else if (comp.value=="P"){
        PopOldAddress();
    }
    
    
}

function copyinfo(comp){
	var frm = document.frmorder;

	if (comp.checked==true){
		frm.reqname.value=frm.buyname.value;

		frm.reqphone1.value=frm.buyphone1.value;
		frm.reqphone2.value=frm.buyphone2.value;
		frm.reqphone3.value=frm.buyphone3.value;

		frm.reqhp1.value=frm.buyhp1.value;
		frm.reqhp2.value=frm.buyhp2.value;
		frm.reqhp3.value=frm.buyhp3.value;
	}else{
		frm.reqname.value="";

		frm.reqphone1.value="";
		frm.reqphone2.value="";
		frm.reqphone3.value="";

		frm.reqhp1.value="";
		frm.reqhp2.value="";
		frm.reqhp3.value="";
	};

}

function checkArmiDlv(){
    var reTest = new RegExp('사서함'); 
    return reTest.test(frmorder.txAddr2.value);
    
}

function searchzip(frmName){
	$("#boxscroll4").css("height","250px");
	$("#boxscroll4").css("display","block");
	zipcodeiframe.location.href = "/gift/lib/searchzip.asp?target=" + frmName;
}

function searchzipBuyer(frmName){
	$("#boxscroll3").css("height","250px");
	$("#boxscroll3").css("display","block");
	zipcodeiframe0.location.href = "/gift/lib/searchzip.asp?target=" + frmName + "&strMode=buyer";
}

function PopOldAddress(){
	var popwin = window.open('/my10x10/MyAddress/popMyAddressList.asp','popMyAddressList','width=600,height=300,scrollbars=yes,resizable=yes');
	popwin.focus();
}

function PopSeaAddress(){
	var popwin = window.open('/my10x10/MyAddress/popSeaAddressList.asp','popSeaAddressList','width=600,height=300,scrollbars=yes,resizable=yes');
	popwin.focus();
}


function CheckForm(frm){
    if (frm.buyname.value.length<1){
        alert('주문자 명을 입력하세요.');
        frm.buyname.focus();
        return false;
    }
    
    if ((frm.buyphone1.value.length<1)||(!IsDigit(frm.buyphone1.value))){
        alert('주문자 전화번호를 입력하세요.');
        frm.buyphone1.focus();
        return false;
    }
    
    if ((frm.buyphone2.value.length<1)||(!IsDigit(frm.buyphone2.value))){
        alert('주문자 전화번호를 입력하세요.');
        frm.buyphone2.focus();
        return false;
    }
    
    if ((frm.buyphone3.value.length<1)||(!IsDigit(frm.buyphone3.value))){
        alert('주문자 전화번호를 입력하세요.');
        frm.buyphone3.focus();
        return false;
    }
    
    
    if ((frm.buyhp1.value.length<1)||(!IsDigit(frm.buyhp1.value))){
        alert('주문자 핸드폰번호를 입력하세요.');
        frm.buyhp1.focus();
        return false;
    }
    
    if ((frm.buyhp2.value.length<1)||(!IsDigit(frm.buyhp2.value))){
        alert('주문자 핸드폰번호를 입력하세요.');
        frm.buyhp2.focus();
        return false;
    }
    
    if ((frm.buyhp3.value.length<1)||(!IsDigit(frm.buyhp3.value))){
        alert('주문자 핸드폰번호를 입력하세요.');
        frm.buyhp3.focus();
        return false;
    }
    
    if (frm.buyemail_Pre.value.length<1){
        alert('주문자 이메일 주소를 입력하세요.');
        frm.buyemail_Pre.focus();
        return false;
    }
    
    if (frm.buyemail_Bx.value.length<4){
        if (!check_form_email(frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value)){
            alert('주문자 이메일 주소가 올바르지 않습니다.');
            frm.buyemail_Tx.focus();
            return false;
        }
    }
    
    if (frm.buyemail_Bx.value.length<4){
        frm.buyeremail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Tx.value;
        frm.buyemail.value   = frm.buyeremail.value;
    }else{
        frm.buyeremail.value = frm.buyemail_Pre.value + '@' + frm.buyemail_Bx.value;
        frm.buyemail.value   = frm.buyeremail.value;
    }
	    
    
    // 수령인
    if (frm.reqname.value.length<1){
        alert('수령인 명을 입력하세요.');
        frm.reqname.focus();
        return false;
    }
    
    if ((frm.reqphone1.value.length<1)||(!IsDigit(frm.reqphone1.value))){
        alert('수령인 전화번호를 입력하세요.');
        frm.reqphone1.focus();
        return false;
    }
    
    if ((frm.reqphone2.value.length<1)||(!IsDigit(frm.reqphone2.value))){
        alert('수령인 전화번호를 입력하세요.');
        frm.reqphone2.focus();
        return false;
    }
    
    if ((frm.reqphone3.value.length<1)||(!IsDigit(frm.reqphone3.value))){
        alert('수령인 전화번호를 입력하세요.');
        frm.reqphone3.focus();
        return false;
    }
    
    if ((frm.reqhp1.value.length<1)||(!IsDigit(frm.reqhp1.value))){
        alert('수령인 핸드폰번호를 입력하세요.');
        frm.reqhp1.focus();
        return false;
    }
    
    if ((frm.reqhp2.value.length<1)||(!IsDigit(frm.reqhp2.value))){
        alert('수령인 핸드폰번호를 입력하세요.');
        frm.reqhp2.focus();
        return false;
    }
    
    if ((frm.reqhp3.value.length<1)||(!IsDigit(frm.reqhp3.value))){
        alert('수령인 핸드폰번호를 입력하세요.');
        frm.reqhp3.focus();
        return false;
    }
    
    if ((frm.txZip1.value.length<1)||(frm.txZip2.value.length<1)||(frm.txAddr1.value.length<1)){
        alert('수령지 주소를  입력하세요.');
        return false;
    }
    
    if (frm.txAddr2.value.length<1){
        alert('수령지 상세 주소를  입력하세요.');
        frm.txAddr2.focus();
        return false;
    }
    
    return true;
}
    
function PayNext(frm, iErrMsg){
    if (!CheckForm(frm)){
        return;
    }
    
	var ret = confirm('배송 요청 하시겠습니까?');
	if (ret){
		frm.target = "";
		frm.action = "/test/formsubmittest.asp";
		frm.submit();
	}
}
</script>

<div class="toolbar">
	<!-- #INCLUDE Virtual="/lib/inc_topMenu.asp" -->
	<!--- 로그인시 아이디 노출 ---->
	<% if IsUserLoginOK then %><div id="top_login"><%=GetLoginUserID %>님, 즐거운 하루되세요!</div><% end if %>
</div>
<div selected="true">
<div id="kakao_gifting">
	<h2><img src="http://fiximage.10x10.co.kr/m/kakaotalk/m_kakao_gifting_tit.png" width="136" height="21" /></h2>
	<div class="gifting_product">
		<ul>
			<li>
				<table width="95%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="100"><label for="coupon_num">쿠폰번호</label></td>
					<td><input name="coupon_num" id="coupon_num" type="text" class="coupon_num" value="<%=vCouponNO%>" readonly /></td>
				</tr>
				</table>
			</li>
			<li>
				<div class="gifting_pd">
					<div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="pd_image"><a href=""><img src="<%=vListImage%>" width="90" height="90" /></a></td>
							<td>
								<div class="pd_info">
								<p class="brand">[<%=UCase(vBrandName)%>]</p>
								<p class="name"><a href=""><%=vItemName%></a></p>
								<% If vItemOption <> "" Then %>
									<form name="frm1" method="post" action="option_select.asp">
									<input type="hidden" name="idx" value="<%=vIdx%>">
									<input type="hidden" name="itemid" value="<%=vItemID%>">
									</form>
									<p class="option_apply">선택옵션 : <span class="select"><%=vOptionname%></span><a href="javascript:" onClick="frm1.submit();"><img src="http://fiximage.10x10.co.kr/m/kakaotalk/btn_option_modify.png" width="57" height="27" /></a></p>
								<% End If %>
								</div>
							</td>
						</tr>
						</table>
					</div>
				</div>
			</li>
		</ul>
	</div>
	<div class="customer_info">
	<form name="frmorder" method="post">
	<input type="hidden" name="idx" value="<%=vIdx%>">
	<input type="hidden" name="itemid" value="<%=vItemID%>">
	<input type="hidden" name="itemoption" value="<%=vItemOption%>">
	<input type=hidden name=paymethod value="560">
	<input type=hidden name=price value="">
	<input type=hidden name=goodname value='<%= vItemName %>'>
	<input type=hidden name=buyername value="">
	<input type=hidden name=buyeremail value="">
	<input type=hidden name=buyemail value="">
	<input type=hidden name=buyertel value="">
		<h3><span class="num">01.</span> 요청 고객 정보</h3>
		<div class"info_applier">
			<dl>
				<dt>요청인 성함</dt>
				<dd class="first"><input type="text" name="buyname" maxlength="16" class="input_name" value="<%= doubleQuote(oUserInfo.FOneItem.FUserName) %>"></dd>
				<dt>이메일</dt>
				<dd>
					<p>
					<input name="buyemail_Pre" type="text" maxlength="40" class="input_email" value="<%= Splitvalue(oUserInfo.FOneItem.FUserMail,"@",0) %>"> @
					<% call DrawEamilBoxHTML("frmorder","buyemail_Tx","buyemail_Bx",Splitvalue(oUserInfo.FOneItem.FUserMail,"@",1),"mailinput") %>
					</p>
				</dd>
				<dt>휴대전화</dt>
				<dd>
					<input name="buyhp1" type="text" maxlength=4 class="input_tel" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>">
					-
					<input name="buyhp2" type="text" maxlength=4 value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" class="input_tel">
					-
					<input name="buyhp3" type="text" maxlength=4 value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" class="input_tel">
				</dd>
				<dt>전화번호</dt>
				<dd>
					<input name="buyphone1" type="text" maxlength=4 value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>" class="input_tel">
					-
					<input name="buyphone2" type="text" maxlength=4 value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>" class="input_tel">
					-
					<input name="buyphone3" type="text" maxlength=4 value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>" class="input_tel">
				</dd>
				<% if (IsUserLoginOK) then %>
				<dt>주소</dt>
				<dd>
					<p><input type="text" name="buyZip1" ReadOnly class="input_tel" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>"> - 
					<input name="buyZip2" type="text" ReadOnly class="input_tel" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>">
					<img src="http://fiximage.10x10.co.kr/m/kakaotalk/btn_postnum.png" class="tm-4" width="82" height="27" style="margin:-3px 0 0 5px;cursor:pointer;"  onClick="searchzipBuyer('frmorder')"></p>
					<div id="boxscroll3" style="display:none;margin-left:-100px;">
					<iframe id="zipcodeiframe0" src="about:blank" width="100%" height="250" frameborder="0" scrolling="no"></iframe>
					</div>
					<p style="padding-top:7px;"><input name="buyAddr1" type="text" ReadOnly maxlength="100" class="input_address" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"></p>
					<p style="padding-top:7px;"><input name="buyAddr2" type="text" maxlength="60" class="input_address" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"></p>
				</dd>
				<% end if %>
			</dl>
		</div>
		<h3><span class="num">02.</span> 배송지 정보 입력</h3>
		<div class"info_address">
			<div style="padding:7px 0 12px 0;">
				<% if (IsUserLoginOK) then %>
				<input type="radio" name="rdDlvOpt" id="rdDlvOpt" value="O" onClick="copyDefaultinfo(this);"> 요청 고객 정보와 동일
				<input type="radio" name="rdDlvOpt" id="rdDlvOpt" value="N" checked onClick="copyDefaultinfo(this);"> 새로운 주소 
				<% else %>
				<input type="checkbox" name="ckcopyinfo" id="ckcopyinfo" onClick="copyinfo(this);">요청 고객 정보와 동일</td>
				<% end if %>
			</div>
			<dl>	
				<dt>수령인 성함</dt>
				<dd class="first"><input name="reqname" type="text" maxlength="16" class="input_name" value=""></dd>
				<dt>휴대전화</dt>
				<dd>
					<input type="text" name="reqhp1" maxlength="4" class="input_tel" value="">
					-
					<input type="text" name="reqhp2" maxlength="4" class="input_tel" value="">
					-
					<input type="text" name="reqhp3" maxlength="4" class="input_tel" value="">
				</dd>
				<dt>전화번호</dt>
				<dd>
					<input type="text" name="reqphone1" maxlength="4" class="input_tel" value="">
					-
					<input type="text" name="reqphone2" maxlength="4" class="input_tel" value="">
					-
					<input type="text" name="reqphone3" maxlength="4" class="input_tel" value="">
				</dd>
				<dt>주소</dt>
				<dd>
					<p><input type="text" name="txZip1" ReadOnly class="input_tel"> - 
					<input name="txZip2" type="text" ReadOnly class="input_tel">
					<img src="http://fiximage.10x10.co.kr/m/kakaotalk/btn_postnum.png" class="tm-4" width="82" height="27" style="margin:-3px 0 0 5px;cursor:pointer;"  onClick="searchzip('frmorder')"></p>
					<div id="boxscroll4" style="display:none;margin-left:-100px;">
					<iframe id="zipcodeiframe" src="about:blank" width="100%" height="250" frameborder="0" scrolling="no"></iframe>
					</div>
					<p style="padding-top:7px;"><input name="txAddr1" type="text" ReadOnly maxlength="100" class="input_address" value=""></p>
					<p style="padding-top:7px;"><input name="txAddr2" type="text" maxlength="60" class="input_address" value=""></p>
				</dd>
				<dt>배송 유의 사항</dt>
				<dd><input type="text" name="comment" maxlength="60" class="input_address" value=""></dd>
			</dl>
		</div>
		<div class="btn_request"><a href="javascript:" onClick="PayNext(frmorder,'');" style="cursor:pointer"><img src="http://fiximage.10x10.co.kr/m/kakaotalk/btn_request.png" width="146" height="50"></a></div>
		</div>
	</form>
	</div>
	<div style="clear:both"></div>
	<!-- #INCLUDE Virtual="/lib/inc_bottomMenu.asp" -->
</div>
<%
set oUserInfo   = nothing
%>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->