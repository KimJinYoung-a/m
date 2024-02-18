<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	function setLGDResult() {
		if(document.getElementById('LGD_RESPCODE').value == '0000' ){
		    var fdo = opener.document.frmorder;
		    if (fdo.itemcouponOrsailcoupon[1].checked){
			    fdo.checkitemcouponlist.value = opener.document.frmorder.availitemcouponlist.value;
			}else{
			    fdo.checkitemcouponlist.value = "";
			}
			setEnableComp();
	        fdo.LGD_PAYKEY.value = document.getElementById('LGD_PAYKEY').value;
			fdo.target = "";
			fdo.price.value = document.getElementById('LGD_AMOUNT').value; //2013/07/08
			fdo.action = "/apps/appcom/between/inipay/MobileResult_Dacom.asp";
			fdo.submit();
			opener.focus();
			window.close();
		} else {
            setEnableComp();
            alert("인증이 실패하였습니다. " + document.getElementById('LGD_RESPMSG').value);
            opener.focus();
            window.close();
            //parent.document.getElementById("LGD_PAYMENTWINDOW_TOP").style.display = "none";
            //parent.HidePopLayerDcom();
            /*
             * 인증실패 화면 처리
            */

		}
	}

	function setEnableComp(){
        var f=opener.document.frmorder;
		var cnj_var;
		if (f.rdDlvOpt){
    		for(i=0;i<f.rdDlvOpt.length;i++) {
    			cnj_var = f.rdDlvOpt[i];
    			cnj_var.disabled = false;
    		}
    	}
    	if (f.Tn_paymethod){
    		for(i=0;i<f.Tn_paymethod.length;i++) {
    			cnj_var = f.Tn_paymethod[i];
    			cnj_var.disabled = false;
    		}
		}
		if (f.itemcouponOrsailcoupon){
    		for(i=0;i<f.itemcouponOrsailcoupon.length;i++) {
    			cnj_var = f.itemcouponOrsailcoupon[i];
    			cnj_var.disabled = false;
    		}
    	}
    	if (f.sailcoupon){
            f.sailcoupon.disabled = false;
        }
        opener.enable_click();
    }
</script>

</HEAD>

<body onload="setLGDResult()">
<%
Dim i
    ''주석처리하면 안됨.
	For Each i In Request.Form
        Response.Write "<input type=hidden id=" & i & " " & "value='" & Request.Form(i)  & "' >"
  	Next
%>
</BODY>
</HTML>
