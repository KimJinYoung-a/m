<script>
$(function() {
	/* show-hide */
	$('.showHideV16a .tglBtnV16a').click(function(){
		if($(this).parent().parent().hasClass('freebieSltV16a')) {
			$('.freebieSltV16a .showHideV16a .tglContV16a').hide();
			$('.freebieSltV16a .showHideV16a .tglBtnV16a').addClass('showToggle');
		}
		if ($(this).hasClass('showToggle')) {
			$(this).removeClass('showToggle');
			$(this).parents('.showHideV16a').find('.tglContV16a').show();
		} else {
			$(this).addClass('showToggle');
			$(this).parents('.showHideV16a').find('.tglContV16a').hide();
		}
	});

	/* 사은품 선택 그룹 컨트롤 */
	var giftNum = $('.freebieSltV16a').children('.showHideV16a').size();
	if (giftNum==1) {
		$('.freebieSltV16a .showHideV16a').find('.tglContV16a').show();
		$('.freebieSltV16a .tglBtnV16a').removeClass('showToggle');
		$('.freebieSltV16a .tglBtnV16a').find('.hasArrow').removeClass('hasArrow');
	}

	$('.freebieSltV16a .showHideV16a').find('.tglContV16a').hide();
	$('.freebieSltV16a .showHideV16a').eq(<%=vGiftTabView%>).find('.tglContV16a').show(); /* 처음 열려있어야 하는 사은품 그룹 제어(현재는 첫번째 그룹으로 설정되어 있음) */

	$('.freebieSltV16a .showHideV16a .tglContV16a').each(function(){
		if ($(this).is(':hidden')==true){
			$(this).parents('.showHideV16a').find('.tglBtnV16a').addClass('showToggle');
		} else {
			$(this).parents('.showHideV16a').find('.tglBtnV16a').removeClass('showToggle');
		}
	});

	/* 무통장 결제 수단 선택 옵션 컨트롤 */
	$('.bankBookV16a .showHideV16a .tglContV16a').hide();
	$('.bankBookV16a .showHideV16a .tglBtnV16a').click(function(){
		if ($(this).is(':checked')) {
			$(this).parents('.showHideV16a').find('.tglContV16a').show();
		} else {
			$(this).parents('.showHideV16a').find('.tglContV16a').hide();
		}
	});
	
    <% if (IsForeignDlv) and (countryCode<>"") and (countryCode<>"AA") then %>
    document.frmorder.emsCountry.value='<%=countryCode%>';
    emsBoxChange(document.frmorder.emsCountry);
    <% end if %>

    if (ChkErrMsg){
        alert(ChkErrMsg);
    }


	<% If vIsDeliveItemExist Then %>
	    <% If CInt(vOldCnt) > 0 Then %>
	    	copyDefaultinfo($("#overseatab > li").eq(1),'<%=CHKIIF(IsForeignDlv,"","KR")%>')
		<% Else %>
			copyDefaultinfo($("#overseatab > li").eq(0),'<%=CHKIIF(IsForeignDlv,"","KR")%>')
		<% End If %>
	<% End If %>

	<%' amplitude 이벤트 로깅 %>
		tagScriptSend('', 'userinfo', '', 'amplitude');
	<%'// amplitude 이벤트 로깅 %>
});

/* 모바일 웹에서만 적용 */
$(window).resize(function () {
	var lyrH = $("#lyGiftNoti .lyGiftNoti").outerHeight();
	$(".lyGiftNoti").css('margin-top', -lyrH/2);
});
</script>
<script type="text/javascript">

var ChkErrMsg;

// 플러그인 설치(확인)
//StartSmartUpdate();

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

function copyDefaultinfo(obj,ctrCd){
	var frm = document.frmorder;
	var comp = $(obj).attr("opt");
	var defaultexist = "x";
	frm.rdDlvOpt.value=comp;
	$("#overseatab li").removeClass('current');
	$(obj).addClass('current');

	if (comp=="N" || comp=="P"){		//신규 배송지N, 최근 배송지P
		frm.reqname.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (comp=="R"){		//기본 배송지
		<% If vKRdeliNotOrder <> "o" Then %>
		frm.reqname.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
		fnKRDefaultSet();
		<% Else %>
			fnKRDefaultSet();
		<% End If %>
	}else if (comp=="OC1" || comp=="OC2" || comp=="OC3"){     //해외주소New
		frm.reqname.value = "";
		frm.reqemail.value = "";
		frm.reqphone1.value = "";
		frm.reqphone2.value = "";
		frm.reqphone3.value = "";
		frm.reqphone4.value = "";
		frm.emsZipCode.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (comp=="F"){
		PopSeaAddress();
	}

	//Select Layer
	<% if (IsUserLoginOK) then %>
	document.getElementById("myaddress").style.display = "none";
	document.getElementById("recentOrder").style.display = "none";
	<% End If %>

	if (comp=="R" || comp=="OC1") {
		//ajax 나의주소 접수
		if($("#myaddress").html()=="") {
			$.ajax({
				url: "/my10x10/Myaddress/act_MyAddressList.asp?ctrCd="+ctrCd+"&psz=100",
				cache: false,
				success: function(rst) {
					var vRtn="", vLp=1;
					if($(rst).find("item").length>0) {
						vRtn = '<select style="width:100%;" title="저장된 나의 주소록" class="chgmyaddr">';
						vRtn += '<option value="" tReqname="" tTxAddr1="" tTxAddr2="" tReqPhone="--" tReqHp="--" tReqZipcode="-" tReqemail="" tCountryCode="" tEmsAreaCode="">주소를 선택 해주세요</option>';
						$(rst).find("item").each(function(){
							vRtn += '<option value="'+ vLp +'" tReqname="'+ $(this).find("name").text() +'" tTxAddr1="'+ $(this).find("addr1").text() +'" tTxAddr2="'+ $(this).find("addr2").text() +'" tReqPhone="'+ $(this).find("tel").text() +'" tReqHp="'+ $(this).find("hp").text() +'" tReqZipcode="'+ $(this).find("zip").text() +'" tReqemail="'+ $(this).find("email").text() +'" tCountryCode="'+ $(this).find("countryCd").text() +'" tEmsAreaCode="'+ $(this).find("emsCd").text() +'"  >';
							if($(this).find("place").text()!="")	vRtn += $(this).find("place").text() + ' | ';
							vRtn += $(this).find("name").text() + ' | ' + $(this).find("addr1").text() + ' ' + $(this).find("addr2").text();
							vRtn += '</option>';
							vLp++;
						});
						vRtn += '</select>';
					} else {
						<% If vKRdeliNotOrder <> "o" Then %>
						vRtn = '<div class="tPad10 bPad10 cGy1 fs15 ct">등록된 나의 주소록이 없습니다.</div>';
						<% End If %>
					}
					$("#myaddress").html(vRtn);
					FnSetChgMyAddr();
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});
		} else {
			$(".chgmyaddr").val('');
		}
		
		<% If vKRdeliNotOrder <> "o" Then %>
		document.getElementById("myaddress").style.display = "block";
		<% End If %>
	} else if (comp=="P" || comp=="OC2") {
		//ajax 최근배송지 접수
		if($("#recentOrder").html()=="") {
			$.ajax({
				url: "/my10x10/Myaddress/act_MyAddressList.asp?ctrCd="+ctrCd+"&div=old&psz=50",
				cache: false,
				success: function(rst) {
					var vRtn="", vLp=1;
					if($(rst).find("item").length>0) {
						vRtn = '<select style="width:100%;" title="과거 배송지" class="chgmyaddr">';
						vRtn += '<option value="" tReqname="" tTxAddr1="" tTxAddr2="" tReqPhone="--" tReqHp="--" tReqZipcode="-" tReqemail="" tCountryCode="" tEmsAreaCode="">배송지를 선택 해주세요</option>';
						$(rst).find("item").each(function(){
							vRtn += '<option value="'+ vLp +'" tReqname="'+ $(this).find("name").text() +'" tTxAddr1="'+ $(this).find("addr1").text() +'" tTxAddr2="'+ $(this).find("addr2").text() +'" tReqPhone="'+ $(this).find("tel").text() +'" tReqHp="'+ $(this).find("hp").text() +'" tReqZipcode="'+ $(this).find("zip").text() +'" tReqemail="'+ $(this).find("email").text() +'" tCountryCode="'+ $(this).find("countryCd").text() +'" tEmsAreaCode="'+ $(this).find("emsCd").text() +'"  >';
							vRtn += $(this).find("name").text() + ' | ' + $(this).find("addr1").text() + ' ' + $(this).find("addr2").text();
							vRtn += '</option>';
							vLp++;
						});
						vRtn += '</select>';
						
						defaultexist = "o";
					} else {
						vRtn = '<div class="tPad10 bPad10 cGy1 fs15 ct">최근 주문배송 내역이 없습니다.</div>';
					}
					$("#recentOrder").html(vRtn);
					if(defaultexist == "o"){
						$(".chgmyaddr > option[value=1]").attr("selected", "true");
					}
					FnSetChgMyAddr();
					if(defaultexist == "o"){
						FnDefaultSetAddr($(".chgmyaddr"));
					}
				}
				,error: function(err) {
					alert(err.responseText);
				}
			});	
		} else {
			$(".chgmyaddr").val('');
			//if(ctrCd == "KR"){
			//	$(".chgmyaddr > option[value=1]").attr("selected", "true");
			//		FnSetChgMyAddr();
			//		FnDefaultSetAddr($(".chgmyaddr"));
			//}
		}
		document.getElementById("recentOrder").style.display = "block";
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

//셀렉트 박스
function FnSetChgMyAddr(){
	$(".chgmyaddr").change(function(){
		FnDefaultSetAddr(this);
	});
}

//셀렉트 박스 기본셋팅
function FnDefaultSetAddr(osel){
	var frm = document.frmorder;

	frm.reqname.value	= $(osel).children("option:selected").attr("tReqname");
	frm.txAddr1.value		= $(osel).children("option:selected").attr("tTxAddr1");
	frm.txAddr2.value	 	= $(osel).children("option:selected").attr("tTxAddr2");

	<% if IsForeignDlv Then %>
		// 해외배송정보
		if(/-/g.test($(osel).children("option:selected").attr("tReqPhone"))) {
			var tel	= $(osel).children("option:selected").attr("tReqPhone").split("-");
			frm.reqphone1.value	= tel[0];
			frm.reqphone2.value	= tel[1];
			frm.reqphone3.value	= tel[2];
			frm.reqphone4.value	= tel[3];
		} else {
			frm.reqphone1.value	= "";
			frm.reqphone2.value	= "";
			frm.reqphone3.value	= "";
			frm.reqphone4.value	= "";
		}

		frm.reqemail.value	= $(osel).children("option:selected").attr("tReqemail");
		frm.emsZipCode.value	= $(osel).children("option:selected").attr("tReqZipcode");

		if (frm.emsCountry)
		{
			frm.emsCountry.value	= $(osel).children("option:selected").attr("tCountryCode");
			frm.countryCode.value	= $(osel).children("option:selected").attr("tCountryCode");
			frm.emsAreaCode.value	= $(osel).children("option:selected").attr("tEmsAreaCode");

			emsBoxChange(frm.emsCountry);
		}

	<% else %>
		// 국내배송정보
		if(/-/g.test($(osel).children("option:selected").attr("tReqPhone"))) {
			var tel	= $(osel).children("option:selected").attr("tReqPhone").split("-");
			frm.reqphone1.value	= tel[0];
			frm.reqphone2.value	= tel[1];
			frm.reqphone3.value	= tel[2];
		} else {
			frm.reqphone1.value	= "";
			frm.reqphone2.value	= "";
			frm.reqphone3.value	= "";
		}

		var hp	= $(osel).children("option:selected").attr("tReqHp").split("-");
		frm.reqhp1.value	= hp[0];
		frm.reqhp2.value	= hp[1];
		frm.reqhp3.value	= hp[2];

		frm.txZip.value = $(osel).children("option:selected").attr("tReqZipcode");
		
	<% end if %>
}

function checkArmiDlv(){
	var reTest = new RegExp('사서함');
	return reTest.test(document.frmorder.txAddr2.value);
}

function PopSeaAddress(){
	var popwin = window.open('/my10x10/MyAddress/popSeaAddressList.asp','popSeaAddressList','width=600,height=300,scrollbars=yes,resizable=yes');
	popwin.focus();
}

var popupMobileWindow;
function PopMobileOrder(paymethod){
	/*
	// mobilians
	if(popupMobileWindow == undefined)
	{
		if(paymethod == "400")
		{
			popupMobileWindow = window.open('/inipay/mobile/step1.asp','popupMobileWindow','');
			popupMobileWindow.focus();
		}
	}
	else
	{
		try{
			if(paymethod == "400")
			{
				popupMobileWindow.location.href = "/inipay/mobile/step1.asp";
				popupMobileWindow.focus();
			}
			else
			{
				popupMobileWindow.close();
				popupMobileWindow = null;
			}
		}
		catch(e){
			if(paymethod == "400")
			{
				popupMobileWindow = window.open('/inipay/mobile/step1.asp','popupMobileWindow','');
				popupMobileWindow.focus();
			}
		}
	}
	*/

	// uplus
	/*
	if(paymethod == "400"){
		document.LGD_FRM.LGD_BUYER.value = document.frmorder.buyname.value;
		document.LGD_FRM.LGD_PRODUCTINFO.value = document.frmorder.mobileprdtnm.value;
		document.LGD_FRM.LGD_AMOUNT.value = document.frmorder.mobileprdprice.value;
		document.LGD_FRM.LGD_BUYEREMAIL.value = document.frmorder.buyemail.value;
		document.LGD_FRM.LGD_BUYERPHONE.value = document.frmorder.buyhp1.value + "" + document.frmorder.buyhp2.value + "" + document.frmorder.buyhp3.value;
		document.LGD_FRM.action="/inipay/xpay/payreq_crossplatform.asp"
		document.LGD_FRM.target="LGD_PAYMENTWINDOW_TOP_IFRAME";

		//setDisableComp();
		document.getElementById('LGD_PAYMENTWINDOW_TOP').style.display = "";
		document.LGD_FRM.isAx.value="";
		document.LGD_FRM.submit();
	}
	*/
}

function setDisableComp(){
	var f=document.frmorder;
	if (f.rdDlvOpt){
		for(i=0;i<f.rdDlvOpt.length;i++) {
			cnj_var = f.rdDlvOpt[i];
			cnj_var.disabled = true;
		}
	}
	if (f.Tn_paymethod){
		for(i=0;i<f.Tn_paymethod.length;i++) {
			cnj_var = f.Tn_paymethod[i];
			cnj_var.disabled = true;
		}
	}
	if (f.itemcouponOrsailcoupon){
		for(i=0;i<f.itemcouponOrsailcoupon.length;i++) {
			cnj_var = f.itemcouponOrsailcoupon[i];
			cnj_var.disabled = true;
		}
	}
	if (f.sailcoupon){
		f.sailcoupon.disabled = true;
	}
}

function popansim(){
	var popwin;
	popwin = window.open('http://www.inicis.com/popup/C_popup/popup_C_02.html','popansim','scrollbars=yes,resizable=yes,width=620,height=600')
}

function popisp(){
	var popispwin;
	popispwin = window.open('http://www.10x10.co.kr/inipay/isp/isp.htm','popisp','scrollbars=yes,resizable=yes,width=580,height=600')
}

function popGongIn(){
	var popwin;
	popwin = window.open('http://www.inicis.com/popup/C_popup/popup_C_01.html','popGongIn','scrollbars=yes,resizable=yes,width=620,height=600')
}

var iclicked = false;

function getCheckedIndex(comp){
	var i =0;
	for( var i = 0 ; i <comp.length;  i++){
		if(comp[i].checked) return i;
	}
	return -1;
}

function defaultCouponSet(comp){
	var frm = document.frmorder;

	if (comp.value=="I"){
		RecalcuSubTotal(comp);
	}else if (comp.value=="S"){
		RecalcuSubTotal(frm.sailcoupon);
	//}else if (comp.value=="M"){
	//	RecalcuSubTotal(frm.appcoupon);
   }else if (comp.value=="K"){
		RecalcuSubTotal(frm.kbcardsalemoney);
	}
}

function giftOptChange(comp){
	if (comp.options[comp.selectedIndex].id=="S"){
		alert('품절된 옵션은 선택 불가합니다.');
		comp.selectedIndex=0;
		comp.focus();
		return;
	}
}

function CheckGift(isFirst){
	var frm = document.frmorder;
	var fixprice = frm.fixprice.value*1;
	var availCnt = 0;
	var ischked = 0;
	if (frm.rRange){
		if (frm.rRange.length){
			for(var i=0;i<frm.rRange.length;i++){
				if (fixprice*1>=frm.rRange[i].id*1){
					frm.rRange[i].disabled = false;
					//default chk tenDlv
					if (frm.rGiftDlv[i].value=="N"){
						if (isFirst){
							frm.rRange[i].checked = true;
							 giftOptEnable(frm.rRange[i]);
							ischked = 1;
						}else{
							if (frm.rRange[i].checked) ischked = 1;
						}
					}

					if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
						eval("document.frmorder.gOpt_" + frm.rRange[i].value).disabled = false;

					}

					availCnt++;
				}else{
					frm.rRange[i].disabled = true;
					frm.rRange[i].checked = false;
					if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
						eval("document.frmorder.gOpt_" + frm.rRange[i].value).disabled = true;
					}
				}
			}
		}else{
			if (fixprice*1>=frm.rRange.id*1){
				frm.rRange.disabled = false;
				if (isFirst){
					frm.rRange.checked = true;
					giftOptEnable(frm.rRange);
					ischked = 1;
				}else{
					if (frm.rRange.checked) ischked = 1;
				}

				if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
					eval("document.frmorder.gOpt_" + frm.rRange.value).disabled = false;
				}
				availCnt++;
			}else{
				frm.rRange.disabled = true;
				frm.rRange.checked = false;
				if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
					eval("document.frmorder.gOpt_" + frm.rRange.value).disabled = true;
				}
			}
		}

		//When NoChecked Check Last
		if (ischked!=1){
			if (frm.rRange.length){
				for(var i=0;i<frm.rRange.length;i++){
					if (frm.rRange[i].disabled!=true){
						frm.rRange[i].checked = true;
						giftOptEnable(frm.rRange[i]);
						ischked = 1;
					}
				}
			}else{
			    <% '20170810 전체 사은이벤트 쿠폰사용으로 disabled 되었을경우   %>
                if (frm.rRange.disabled!=true){  
                    frm.rRange.checked = true;
                    giftOptEnable(frm.rRange);
                    ischked = 1;
                }
			}
		}
		
		<% '20170810 전체 사은이벤트 쿠폰사용으로 disabled 되었을경우   %>
        if (ischked!=1){
            alert('조건이 만족하지 않아 사은품은 지급되지 않습니다.');
        }
	}
    
	//20121012
	checkDiaryGift(isFirst);
}

function plusComma(num){
	if (num < 0) { num *= -1; var minus = true}
	else var minus = false

	var dotPos = (num+"").split(".")
	var dotU = dotPos[0]
	var dotD = dotPos[1]
	var commaFlag = dotU.length%3

	if(commaFlag) {
		var out = dotU.substring(0, commaFlag)
		if (dotU.length > 3) out += ","
	}
	else var out = ""

	for (var i=commaFlag; i < dotU.length; i+=3) {
		out += dotU.substring(i, i+3)
		if( i < dotU.length-3) out += ","
	}

	if(minus) out = "-" + out
	if(dotD) return out + "." + dotD
	else return out
}

function AssignBonusCoupon(bool,icoupontype,icouponvalue){
    var iasgnCouponMoney = 0;
    if ((icoupontype=="2")&&(icouponvalue*1>0)){
        $.ajax({
    		url: "/inipay/getPCpndiscount.asp?icoupontype="+icoupontype+"&icouponvalue="+icouponvalue+"&jumunDiv=<%=jumunDiv%>",
    		cache: false,
    		async: false,
    		success: function(message) {
    			iasgnCouponMoney = message;
    		}
    	});
    }
    return iasgnCouponMoney;
}

function AssignItemCoupon(bool){
	var itemcouponmoney = 0 ;
	var frm = document.baguniFrm;

	if (frm.distinctkey.length==undefined){
		if ((bool)&&(frm.curritemcouponidxflag.value!="")){
			itemcouponmoney = frm.couponsailpriceflag.value * 1;
			//document.all["HTML_itemcouponcost_0"].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag.value) + " <font color='#777777'>원</font>";
			//document.all["HTML_itemcouponcostsum_0"].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10'> " + plusComma(frm.itemcouponsellpriceflag.value*1*frm.itemea.value*1) + " <font color='#777777'>원</font>";
		}else{
			//document.all["HTML_itemcouponcost_0"].innerHTML = "";
			//document.all["HTML_itemcouponcostsum_0"].innerHTML = "";
		}
	}else{
		for (var i=0;i<frm.distinctkey.length;i++){
			if ((bool)&&(frm.curritemcouponidxflag[i].value!="")){
				itemcouponmoney = itemcouponmoney + frm.couponsailpriceflag[i].value * 1;
				distinctkey = frm.distinctkey[i].value;
				//document.all["HTML_itemcouponcost_" + distinctkey].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag[i].value) + " <font color='#777777'>원</font>";
				//document.all["HTML_itemcouponcostsum_" + distinctkey].innerHTML = "<br><img src='/fiximage/web2008/shoppingbag/coupon_icon.gif' width='10' height='10' > " + plusComma(frm.itemcouponsellpriceflag[i].value*1*frm.itemea[i].value*1) + " <font color='#777777'>원</font>";

			}else{
				distinctkey = frm.distinctkey[i].value;
				//document.all["HTML_itemcouponcost_" + distinctkey].innerHTML = "";
				//document.all["HTML_itemcouponcostsum_" + distinctkey].innerHTML = "";
			}
		}
	}

	return itemcouponmoney;
}

function getPCpnDiscountPrice(icouponvalue){
	var pcouponmoney = 0 ;
	var frm = document.baguniFrm;
	if (frm.distinctkey.length==undefined){
		pcouponmoney = parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
	}else{
		for (var i=0;i<frm.distinctkey.length;i++){
			pcouponmoney = pcouponmoney*1 + parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
		}
	}

	return pcouponmoney;
}


function popEmsApplyGoCondition(){
	var nation = 'GR';
	if (document.frmorder.countryCode.value!='') nation = document.frmorder.countryCode.value;

	var popwin = window.open('http://ems.epost.go.kr:8080/front.EmsApplyGoCondition.postal?nation=' + nation,'EmsApplyGoCondition','scrollbars=yes,resizable=yes,width=620,height=600');
}

function popEmsCharge(){
	var areaCode = '';
	if (document.frmorder.emsAreaCode.value!='') areaCode = document.frmorder.emsAreaCode.value;
	if (areaCode=='undefined') areaCode='';

	if (areaCode==''){
		alert('국가를 먼저 선택 하세요.');
		document.frmorder.emsCountry.focus();
		return;
	}

	var popwin = window.open('popEmsCharge.asp?areaCode=' + areaCode,'popEmsCharge','scrollbars=yes,resizable=yes,width=380,height=490');
	popwin.focus();
}

function checkCashreceiptSSN(opttype,ssncomp){
	if (opttype==0){
		if(ssncomp.value.length !=10 && ssncomp.value.length !=11 && ssncomp.value.length !=18){
			alert("올바른 휴대폰 번호 10자리(11자리) 또는 현금영수증카드 번호를 입력하세요.");
			ssncomp.focus();
			return false;
		} else if(ssncomp.value.length == 11 ||ssncomp.value.length == 10 ){
			var obj = ssncomp.value;
			if (obj.substring(0,3)!= "011" && obj.substring(0,3)!= "017" && obj.substring(0,3)!= "016" && obj.substring(0,3)!= "018" && obj.substring(0,3)!= "019" && obj.substring(0,3)!= "010")
			{
				alert("올바른 휴대폰 번호 10자리(11자리)를 입력하세요. ");
				ssncomp.focus();
				return false;
			}

			var chr1;
			for(var i=0; i<obj.length; i++){

					chr1 = obj.substr(i, 1);
					if( chr1 < '0' || chr1 > '9') {
					alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
					ssncomp.focus();
					return false;
				}
			}
		} else if(ssncomp.value.length == 18 ){
			var obj = ssncomp.value;
			var chr1;
			for(var i=0; i<obj.length; i++){
					chr1 = obj.substr(i, 1);
					if( chr1 < '0' || chr1 > '9') {
					alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
					ssncomp.focus();
					return false;
				}
			}
		}
	}

	if (opttype==1){
		if(ssncomp.value.length !=10  && ssncomp.value.length !=11 && ssncomp.value.length !=18){
			alert("올바른 사업자등록번호 10자리, 현금영수증카드 13자리 또는 휴대폰 번호 10자리(11자리)를 입력하세요.");
			ssncomp.focus();
			return false;
		} else if(ssncomp.value.length == 10 && ssncomp.value.substring(0,1)!= "0"){
			var vencod = ssncomp.value;
			var sum1 = 0;
			var getlist =new Array(10);
			var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
			for(var i=0; i<10; i++) { getlist[i] = vencod.substring(i, i+1); }
			for(var i=0; i<9; i++) { sum1 += getlist[i]*chkvalue[i]; }
			sum1 = sum1 + parseInt((getlist[8]*5)/10);
			sidliy = sum1 % 10;
			sidchk = 0;
			if(sidliy != 0) { sidchk = 10 - sidliy; }
			else { sidchk = 0; }
			if(sidchk != getlist[9]) {
				alert("올바른 사업자 번호를 입력하시기 바랍니?¤. ");
				ssncomp.focus();
				return false;
			}
			else
			{
				//alert("number ok");
				//return;
			}

		}
		else if(ssncomp.value.length == 11 ||ssncomp.value.length == 10 )
		{
			var obj = ssncomp.value;
			if (obj.substring(0,3)!= "011" && obj.substring(0,3)!= "017" && obj.substring(0,3)!= "016" && obj.substring(0,3)!= "018" && obj.substring(0,3)!= "019" && obj.substring(0,3)!= "010")
			{
				alert("실제 번호를 입력하시지 않아 실행에 실패하였습니다. 다시 입력하시기 바랍니다. ");
				ssncomp.focus();
				return false;
			}

			var chr;
			for(var i=0; i<obj.length; i++){
				chr = obj.substr(i, 1);
				if( chr < '0' || chr > '9') {
					alert("실제 번호를 입력하시지 않아 실행에 실패하였습니다. 다시 입력하시기 바랍니다. ");
					ssncomp.focus();
					return false;
				}
			}
	   } else if(ssncomp.value.length == 18 ){
			var obj = ssncomp.value;
			var chr1;
			for(var i=0; i<obj.length; i++){
					chr1 = obj.substr(i, 1);
					if( chr1 < '0' || chr1 > '9') {
					alert("숫자가 아닌 문자가 휴대폰 번호에 추가되어 오류가 있습니다, 다시 확인 하십시오. ");
					ssncomp.focus();
					return false;
				}
			}
		}
	}
	return true;
}

//현장수령 선택시 주소입력
function chgRSVSel(){
	var frm = document.frmorder;
	
	if($("input[name='rdDlvOpt']").val()=="N") {
		$("#lyRSVAddr").hide();
		$("#lyRSVCmt").hide();

		frm.reqname.value=frm.buyname.value;

		frm.reqphone1.value=frm.buyphone1.value;
		frm.reqphone2.value=frm.buyphone2.value;
		frm.reqphone3.value=frm.buyphone3.value;

		frm.reqhp1.value=frm.buyhp1.value;
		frm.reqhp2.value=frm.buyhp2.value;
		frm.reqhp3.value=frm.buyhp3.value;

        frm.txZip.value = "";
        frm.txAddr1.value = "";
        frm.txAddr2.value = "";
        frm.comment.value = "현장수령";
	} else {
		$("#lyRSVAddr").show();
		$("#lyRSVCmt").show();
		frm.comment.value = "";
	}
}

function reloadpojang(chval){
	pojangfrm.reload.value=chval;
	pojangfrm.submit();
}

function packreg(reload){
		//신규등록
		if (reload==''){
			if (confirm('이용중 팝업을 강제로 종료할 경우,\n설정된 포장 내용은 저장되지 않습니다.')){
				window.open('/inipay/pack/pack_step_intro.asp','packreg')
				return false;
			}
		}else{
			window.open('/inipay/pack/pack_step1.asp','packreg')
			return false;
		}
}

function chpojangdel(midx){
	if (midx==''){
		alert('일렬번호가 없습니다.');
		return;
	}

	pojangfrm.mode.value='pojangdel_uinfo';
	pojangfrm.midx.value=midx;
	pojangfrm.action = "/inipay/pack/pack_process.asp";
	pojangfrm.submit();
	return;
}

/* 사은품 선택 유의사항 모달레이어 컨트롤 */
function fnOpenPartLayer() {
	$("#modalLayer2Contents").empty().html($("#lyGiftNoti").html());
	$("#modalLayer2").show();
	$("#lyGiftNoti").show();
	$(".lyGiftNoti").show();
	var lyrH = $("#lyGiftNoti .lyGiftNoti").outerHeight();
	$(".lyGiftNoti").css('margin-top', -lyrH/2);
	$("#dimed").click(function(){
		fnClosePartLayer();
	});
}
function fnClosePartLayer() {
	$('.lyGiftNoti').hide(0, function(){
		$("#modalLayer2").hide(0, function(){
			myScroll = null;
			$("#modalLayer2Contents").empty();
		});
		$("#lyGiftNoti").hide();
	});
}

//국내배송 기본 배송지 초기 셋팅
function fnKRDefaultSet(){
<% If Not IsForeignDlv Then %>
var frm = document.frmorder;
frm.reqname.value=frm.buyname.value;
frm.reqphone1.value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>";
frm.reqphone2.value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>";
frm.reqphone3.value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>";
frm.reqhp1.value=frm.buyhp1.value;
frm.reqhp2.value=frm.buyhp2.value;
frm.reqhp3.value=frm.buyhp3.value;
frm.txZip.value = "<%= trim(oUserInfo.FOneItem.FZipCode) %>";
frm.txAddr1.value = "<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>";
frm.txAddr2.value = "<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>";
<% End If %>
}


function fnCommentMsg(v){
	if(v == "etc"){
		$("#delivmsg").show();
		document.frmorder.comment_etc.focus();
	}else{
		$("#delivmsg").hide();
	}
}

function fnNemberNextFocus(p,n,l){
	if($("input[name="+p+"]").val().length >= l){
		fnOverNumberCut(p,l);
		$("input[name="+n+"]").focus();
	}
}

function fnOverNumberCut(p,l){
	var t = $("input[name="+p+"]").val();
	if($("input[name="+p+"]").val().length >= l){
		$("input[name="+p+"]").val(t.substr(0, l));
	}
}

function fnFlowerMsgClear(){
	if($("#message").val() == "메시지 내용을 입력해 주세요."){
		$("#message").val("");
	}
}

function fnFlowerRadioBtn(v){
	if(v == "3"){
		$("#message").attr("disabled",true);
	}else{
		$("#message").attr("disabled",false);
	}
}
</script>