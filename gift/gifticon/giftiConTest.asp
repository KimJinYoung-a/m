<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/header.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/ordercls/giftiConCls.asp"-->
<%
Dim cpnNum: cpnNum = requestCheckvar(request("cpnNum"),20)
Dim mode  : mode   = requestCheckvar(request("mode"),20)

dim oGicon
dim ret, bufStr


IF (mode="P100") THEN  ''조회
    set oGicon = new CGiftiCon
    ret = oGicon.reqCouponState(cpnNum,"100100")  ''쿠폰번호, 추적번호
    
    if (ret) then
        bufStr =          "SERVICE_CODE:" & oGicon.FConResult.FSERVICE_CODE & VbCRLF
        bufStr = bufStr & "COUPON_NUMBER:" & oGicon.FConResult.FCOUPON_NUMBER & VbCRLF
        bufStr = bufStr & "ERROR_CODE:" & oGicon.FConResult.getResultCode & VbCRLF
        bufStr = bufStr & "MESSAGE:" & oGicon.FConResult.FMESSAGE & VbCRLF
        bufStr = bufStr & "EXCHANGE_COUNT:" & oGicon.FConResult.FEXCHANGE_COUNT & VbCRLF
        
        bufStr = bufStr & "SubItemCode:" & oGicon.FConResult.FSubItemCode & VbCRLF
        bufStr = bufStr & "SubItemBarCode:" & oGicon.FConResult.FSubItemBarCode & VbCRLF
        bufStr = bufStr & "SubItemEa:" & oGicon.FConResult.FSubItemEa & VbCRLF
        bufStr = bufStr & "SubSupplyID:" & oGicon.FConResult.FSubSupplyID    & VbCRLF   
        bufStr = bufStr & "ItemPrice:" & oGicon.FConResult.getItemPrice & VbCRLF 
        bufStr = bufStr & "SubSupplyPrice:" & oGicon.FConResult.FSubSupplyPrice  & VbCRLF  
        bufStr = bufStr & "SubPartnerCharge:" & oGicon.FConResult.FSubPartnerCharge  & VbCRLF
        bufStr = bufStr & "SubSupplyerCharge:" & oGicon.FConResult.FSubSupplyerCharge & VbCRLF
        bufStr = bufStr & "FSubSubItemType:"&oGicon.FConResult.FSubSubItemType    & VbCRLF
        bufStr = bufStr & "LimitPrice:"    &oGicon.FConResult.FSubLimitPrice     & VbCRLF
        bufStr = bufStr & "DiscountPrice:" &oGicon.FConResult.FSubDiscountPrice  & VbCRLF
        bufStr = bufStr & "SubNotice:[" &oGicon.FConResult.FSubNotice&"]"   & VbCRLF
        bufStr = bufStr & "SubFiller:[" &oGicon.FConResult.FSubFiller&"]"   & VbCRLF 
        
    end if
    set oGicon = Nothing

ELSEIF (mode="P110") THEN ''승인 
    set oGicon = new CGiftiCon
    ret = oGicon.reqCouponApproval(cpnNum,"100100",10000) ''쿠폰번호, 추적번호, 상품 교환가
    
    if (ret) then
        bufStr =          "SERVICE_CODE:" & oGicon.FConResult.FSERVICE_CODE & VbCRLF
        bufStr = bufStr & "COUPON_NUMBER:" & oGicon.FConResult.FCOUPON_NUMBER & VbCRLF
        bufStr = bufStr & "ERROR_CODE:" & oGicon.FConResult.getResultCode & VbCRLF
        bufStr = bufStr & "MESSAGE:" & oGicon.FConResult.FMESSAGE & VbCRLF
        bufStr = bufStr & "EXCHANGE_COUNT:" & oGicon.FConResult.FEXCHANGE_COUNT & VbCRLF
        
        bufStr = bufStr & "ApprovNO:" & oGicon.FConResult.FApprovNO & VbCRLF
        bufStr = bufStr & "ExchangePrice:" & oGicon.FConResult.FExchangePrice & VbCRLF
    
    end if
    set oGicon = Nothing
ELSEIF (mode="P120") THEN ''승인취소
    set oGicon = new CGiftiCon
    ret = oGicon.reqCouponCancel(cpnNum,"100100",10000) ''쿠폰번호, 추적번호, 상품 교환가
    
    if (ret) then
        bufStr =          "SERVICE_CODE:" & oGicon.FConResult.FSERVICE_CODE & VbCRLF
        bufStr = bufStr & "COUPON_NUMBER:" & oGicon.FConResult.FCOUPON_NUMBER & VbCRLF
        bufStr = bufStr & "ERROR_CODE:" & oGicon.FConResult.getResultCode & VbCRLF
        bufStr = bufStr & "MESSAGE:" & oGicon.FConResult.FMESSAGE & VbCRLF
        bufStr = bufStr & "EXCHANGE_COUNT:" & oGicon.FConResult.FEXCHANGE_COUNT & VbCRLF
        
        bufStr = bufStr & "ApprovNO:" & oGicon.FConResult.FApprovNO & VbCRLF
        bufStr = bufStr & "ExchangePrice:" & oGicon.FConResult.FExchangePrice & VbCRLF
    
    end if
    set oGicon = Nothing
ELSE

END IF
%>
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>

<script language='javascript'>
function reqState(frm){
    if (frm.cpnNum.value.length<12){
        alert('쿠폰번호를 입력하세요.');
        return;
    }
    
    frm.mode.value="P100";
    frm.submit();
}

function appReq(frm){
    if (frm.cpnNum.value.length<12){
        alert('쿠폰번호를 입력하세요.');
        return;
    }
    
    frm.mode.value="P110";
    frm.submit();
}

function cancelReq(frm){
    if (frm.cpnNum.value.length<12){
        alert('쿠폰번호를 입력하세요.');
        return;
    }
    
    frm.mode.value="P120";
    frm.submit();
}

</script>

<div class="toolbar">
	<!-- #INCLUDE Virtual="/lib/inc_topMenu.asp" -->
	<!--- 로그인시 아이디 노출 ---->
	<% if IsUserLoginOK then %><div id="top_login"><%=GetLoginUserID %>님, 즐거운 하루되세요!</div><% end if %>
</div>
<div selected="true">
	<div id="kakao_gifting">
		<table width="800" border=1 cellpadding=1 cellspacing=1>
		<form name="frmGft" method="get" action="">
		<input type="hidden" name="mode" value="">
		<tr>
		    <td>상품</td>
		    <td colspan="2">
		        999033886637<br>
		        999443414267
		    </td>
		</tr>
		<tr>
		    <td>할인권 3,000</td>
		    <td colspan="2">
		        999285852130<br>
		        999692393518<br>
		        999517507629<br>
		        999687233899
		    </td>
		</tr>
		<tr>
		    <td>상품권 10,000</td>
		    <td colspan="2">
		        999003162323<br>
		        999127891875<br>
		        999039073026<br>
		        999690913464
		    </td>
		</tr>
		
		
		<tr>
		    <td>giftCon번호</td>
		    <td><input type="text"name="cpnNum" value="<%=cpnNum%>" maxlength="12" Size="12"></td>
		    <td >
		        <input type="button" value="조회" onClick="reqState(frmGft)">
		        <input type="button" value="승인" onClick="appReq(frmGft)">
		        <input type="button" value="승인취소" onClick="cancelReq(frmGft)">
		    </td>
		</tr>
		<tr>
		    <td>결과MSG</td>
		    <td colspan="2">
		    <textarea cols=100 rows=20><%= bufStr %></textarea>
		    </td>
		</tr>
		</form>
		</table>
	</div>
	<div style="clear:both"></div>
	<!-- #INCLUDE Virtual="/lib/inc_bottomMenu.asp" -->
</div>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->