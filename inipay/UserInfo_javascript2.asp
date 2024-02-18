<script>
var mobileDetect = new MobileDetect(navigator.userAgent);
$(function() {
	/* show-hide */
	$('.showHideV16a .tglBtnV16a').click(function(){
	// 	if($(this).parent().parent().hasClass('freebieSltV16a')) {
	// 		$('.freebieSltV16a .showHideV16a .tglContV16a').hide();
	// 		$('.freebieSltV16a .showHideV16a .tglBtnV16a').addClass('showToggle');
	// 	} 
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

	// $('.freebieSltV16a .showHideV16a').find('.tglContV16a').hide();
	// $('.freebieSltV16a .showHideV16a').eq(<%=vGiftTabView%>).find('.tglContV16a').show(); /* 처음 열려있어야 하는 사은품 그룹 제어(현재는 첫번째 그룹으로 설정되어 있음) */

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

	$('#userSame').click(function(){
		if ($(this).is(':checked')) {
			if ($("input[name=buyname]").val()=="" || $("input[name=buyhp1]").val()=="") {
				alert("주문고객 정보를 입력하셔야 해당 기능을 사용하실 수 있습니다.");
				return false;
			}
			else {
				$("input[name=reqname]").val($("input[name=buyname]").val());
				$("input[name=reqhp1]").val($("input[name=buyhp1]").val());
				$("input[name=reqhp2]").val($("input[name=buyhp2]").val());
				$("input[name=reqhp3]").val($("input[name=buyhp3]").val());
			}
		}
		else {
			$("input[name=reqname]").val("");
			$("input[name=reqhp1]").val("");
			$("input[name=reqhp2]").val("");
			$("input[name=reqhp3]").val("");
		}
	});

	$('#userSameFlower').click(function(){
		if ($(this).is(':checked')) {
			if ($("input[name=buyname]").val()=="") {
				alert("주문고객 정보를 입력하셔야 해당 기능을 사용하실 수 있습니다.");
				return false;
			}
			else {
				$("input[name=fromname]").val($("input[name=buyname]").val());
			}
		}
		else {
			$("input[name=fromname]").val("");
		}
	});

	<%' 비회원 구매 관련 개선사항 %>
	<% If Trim(userid)="" Then %>
		//$("#SaleInfoDiv").hide();
	<% end if %>
	
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
	
	// 결제수단 > 신용카드 기본 선택
	setTimeout(function(){
		$("#paymethodtab > ul > li").removeClass("current");
		if($("input[name='Tn_paymethod']").val()=="") {
			$("input[name='Tn_paymethod']").val('100');
		}
		$("#paymethodtab > ul > li").eq(0).addClass("current");
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
	},300);

	/* non member agree check */
	$("#agree-yes").on("click", function(e){
		$(this).parent().toggleClass("btn-line-red");
		$('input:checkbox[id="agree-yes"]').attr("checked", true);
		$(".nonmember-notice .artcle").slideToggle();
		$("#mask").toggle();
	});

	<%' amplitude 이벤트 로깅 %>
		//tagScriptSend('', 'userinfo', '', 'amplitude');
		fnAmplitudeEventAction("view_userinfo","","");
	<%'// amplitude 이벤트 로깅 %>

	<%
		'// 배송 요청사항
		dim myLastOrderComment : myLastOrderComment = fnGetMyLastOrderComment(userid)
		if myLastOrderComment <> "" and not(IsForeignDlv) then
	%>
		var x = document.frmorder.comment.options;
		var etc = document.frmorder.comment_etc;
		for ( var i = 0; i < x.length; i++ ) {
			var commentValue = x[i].value;
			if (commentValue.indexOf("<%=myLastOrderComment%>") > -1 ) {
				x[i].selected = true;
				break;
			} else {
				if (commentValue.indexOf("etc") > -1) {
					x[i].selected = true;
					document.getElementById("delivmsg").style.display = "block";
					etc.value = "<%=myLastOrderComment%>";
				}
			}
		}
	<%
		end if 
	%>
});

/* 모바일 웹에서만 적용 */
// $(window).resize(function () {
// 	var lyrH = $("#lyGiftNoti .lyGiftNoti").outerHeight();
// 	$(".lyGiftNoti").css('margin-top', -lyrH/2);
// });
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
		$("#myaddress").hide();
		$("#recentOrder").hide();
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
						//vRtn = '<div class="tPad10 bPad10 cGy1 fs15 ct">등록된 나의 주소록이 없습니다.</div>';
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
		$("#myaddress").show();
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

function checkQuickArea(){
    var reTest = new RegExp('서울');
    if (document.frmorder.txAddr1.value.length>0){
        return reTest.test(document.frmorder.txAddr1.value);
    }else{
        return true;
    }

}

function checkQuickMaxNo(){
    var frm = document.baguniFrm;
    var maxEa = <%=C_MxQuickAvailMaxNo%>;
    if (frm.itemea.length){
        for(var i=0;i<frm.itemea.length;i++){
        	if (frm.itemea[i].value*1>maxEa){
        	    return false;
        	}
        }
    }else{
        if (frm.itemea.value*1>maxEa){
            return false;
        }
    }
    return true;
}

function chkQuickDlv(comp){
    var quickchked = (comp.id=="barobtn_q");
    if (document.frmorder.quickdlv){
        if (quickchked){
            document.frmorder.quickdlv.value="QQ";
        }else{
            document.frmorder.quickdlv.value="";
        }
    }
    if (quickchked){
        if (!checkQuickArea()){
            chkQuickDlv(document.getElementById("barobtn_n"));
            alert('바로 배송(퀵배송)은 서울지역만 가능합니다.');   
            return;
        } 
    }
    
    if (quickchked){
        $("#barobtn_n").removeClass("btn-line-red");
        $("#barobtn_q").removeClass("btn-line-grey");
        $("#barobtn_q").addClass("btn-line-red");
        document.getElementById("baronoti2").style.display="";
        $("#paymethodtab > ul > .accP").hide();
        if (document.getElementById("DISP_DLVPRICE")){
            document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(<%=C_QUICKDLVPRICE%>);
        }
        document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(<%= oshoppingbag.GetTotalItemOrgPrice + C_QUICKDLVPRICE + pojangcash - oshoppingbag.GetMileageShopItemPrice %>);
    }else{
        $("#barobtn_n").removeClass("btn-line-grey");
        $("#barobtn_q").removeClass("btn-line-red");
        $("#barobtn_n").addClass("btn-line-red");
        document.getElementById("baronoti2").style.display="none";
        <% if NOT (oshoppingbag.IsBuyOrderItemExists) then %>
          $("#paymethodtab > ul > .accP").show();
        <% end if %>
        if (document.getElementById("DISP_DLVPRICE")){
            document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(<%=oshoppingbag.GetOrgBeasongPrice%>);
        }
        document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(<%= subtotalprice %>);
    }
    RecalcuSubTotal(comp);

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

function CheckPayMethod(comp){
	if (!CheckForm(document.frmorder))
	{
		$("input[name='Tn_paymethod']").val("");
		$("#paymethodtab > ul > li").removeClass("current");
		return;
	}else{
		$("#paymethodtab > ul > li").removeClass("current");
		$("input[name='Tn_paymethod']").val(comp);
	}
	$("#refundInfo").hide();

	var paymethod = comp;

	if (paymethod=="110") paymethod="100";

	if(paymethod == "400")
	{
		$("#paymethodtab > ul > .mobileP").addClass("current");
		//PopMobileOrder(paymethod);
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "none";		
	}
	<% if not (oshoppingbag.IsBuyOrderItemExists) then '### 선착순구매상품은 무통장 안됨. %>
	else if(paymethod == "7")
	{
		$("#paymethodtab > ul > .accP").addClass("current");
		//PopMobileOrder(paymethod);
		document.getElementById("paymethod_desc1_7").style.display = "block";
		document.getElementById("payDescSub1_7").style.display = "block";
		document.getElementById("payDescSub2_7").style.display = "block";
		document.getElementById("payDescSub3_7").style.display = "block";
		document.getElementById("payDescSub3_900").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "none";
		$("#refundInfo").show();				
	}
	<% end if %>
	else if(paymethod == "100")
	{
		$("#tabCard").addClass("current");
		//PopMobileOrder(paymethod);
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "none";				
	}
    <% if (G_PG_KAKAOPAY_ENABLE) then %>
	else if(paymethod == "800")
	{
		$("#paymethodtab > ul > .kakaoP").addClass("current");
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "none";				
	}
    <% end if %>

    <% if (G_PG_NAVERPAY_ENABLE) then %>
	else if(paymethod == "900")
	{
		$("#paymethodtab > ul > .naverP").addClass("current");
		document.getElementById("paymethod_desc1_7").style.display = "block";
		document.getElementById("payDescSub1_7").style.display = "none";
		document.getElementById("payDescSub2_7").style.display = "none";
		document.getElementById("payDescSub3_7").style.display = "none";
		document.getElementById("payDescSub3_900").style.display = "block";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "none";				
	}
    <% end if %>

    <% if (G_PG_PAYCO_ENABLE) then %>
	else if(paymethod == "950")
	{
		$("#paymethodtab > ul > .payco").addClass("current");
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "block";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "none";				
	}
    <% end if %>
    else if(paymethod == "190")
	{
		$("#paymethodtab > ul > .hanaten").addClass("current");
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "block";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "none";				
	}
	else if(paymethod == "980")
	{
		$("#paymethodtab > ul > .toss").addClass("current");
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "block";
		document.getElementById("paymethod_desc1_990").style.display = "none";				
	}
    <% if (G_PG_CHAIPAYNEW_ENABLE) then %>	
	else if(paymethod == "990")
	{
		$("#paymethodtab > ul > .chai").addClass("current");
		document.getElementById("paymethod_desc1_7").style.display = "none";
		document.getElementById("paymethod_desc1_400").style.display = "none";
		document.getElementById("paymethod_desc1_950").style.display = "none";
		document.getElementById("paymethod_desc1_190").style.display = "none";
		document.getElementById("paymethod_desc1_980").style.display = "none";
		document.getElementById("paymethod_desc1_990").style.display = "block";				
	}
	<% End If %>
	<% if (Not IsCyberAccountEnable) then %>
	if (paymethod=='7'){
		alert('현재 가상계좌 오류로 가상계좌는 발급되지 않으며 아래 선택한 텐바이텐 계좌로 입금해 주시기 바랍니다..');
	}
	<% end if %>

	<% if IsTicketOrder then %>
	if (paymethod=='7'){
		alert('티켓상품은 무통장 입금 마감일이 티켓예약 익일 24:00까지 입니다. 이점 양해해 주시기 바랍니다.');
	}
	<% end if %>
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

function CheckForm(frm){
	//var paymethod = frm.Tn_paymethod[getCheckedIndex(frm.Tn_paymethod)].value;

	if (frm.buyname.value.length<1){
		alert('[주문자]를 입력하세요');
		frm.buyname.focus();
		return false;
	}

	if (frm.buyemail.value.length<1){
		alert('[주문자 이메일]을 입력하세요');
		frm.buyemail.focus();
		return false;
	}
	if (!check_form_email(frm.buyemail.value)){
		alert('[주문자 이메일] 주소가 올바르지 않습니다.');
		frm.buyemail.focus();
		return false;
	}

	if ((frm.buyhp1.value.length<1)||(!IsDigit(frm.buyhp1.value))){
		alert('[주문자 휴대폰]을 입력하세요');
		frm.buyhp1.focus();
		return false;
	}

	if ((frm.buyhp2.value.length<1)||(!IsDigit(frm.buyhp2.value))){
		alert('[주문자 휴대폰]을 입력하세요');
		frm.buyhp2.focus();
		return false;
	}

	if ((frm.buyhp3.value.length<1)||(!IsDigit(frm.buyhp3.value))){
		alert('[주문자 휴대폰]을 입력하세요');
		frm.buyhp3.focus();
		return false;
	}


	<% If vIsDeliveItemExist Then %>
		<% if (IsForeignDlv) then %>
			if (frm.reqname.value.length<1){
				alert('[Name]을 입력하세요');
				frm.reqname.focus();
				return false;
			}
			
			if (frm.emsCountry.value.length<1){
				alert('[해외 배송 국가]를 선택하세요');
				frm.emsCountry.focus();
				return false;
			}
		
			if (frm.emsZipCode.value.length<1){
				alert('[Zip Code]를 입력하세요');
				frm.emsZipCode.focus();
				return false;
			}
		
			//필수인지 확인.
			if ((frm.reqphone3.value.length<1)||(!IsDigit(frm.reqphone3.value))){
				alert('[Tel.No]를 입력하세요');
				frm.reqphone3.focus();
				return false;
			}
		
			if ((frm.reqphone4.value.length<1)||(!IsDigit(frm.reqphone4.value))){
				alert('[Tel.No]를 입력하세요');
				frm.reqphone4.focus();
				return false;
			}
		
			if (frm.txAddr2.value.length<1){
				alert('[Address]를 입력하세요  ');
				frm.txAddr2.focus();
				return false;
			}
			
			if (frm.txAddr1.value.length<1){
				alert('[City/State]를 입력하세요  ');
				frm.txAddr1.focus();
				return false;
			}
		
			//영문 체크
			if (!checkAsc(frm.reqname.value)){
				alert('영문으로 입력해 주세요.');
				frm.reqname.focus();
				return;
			}
		
			if (!checkAsc(frm.reqemail.value)){
				alert('영문으로 입력해 주세요.');
				frm.reqemail.focus();
				return;
			}
		
			if (!checkAsc(frm.emsZipCode.value)){
				alert('영문으로 입력해 주세요.');
				frm.emsZipCode.focus();
				return;
			}
		
			if (!checkAsc(frm.txAddr2.value)){
				alert('영문으로 입력해 주세요.');
				frm.txAddr2.focus();
				return;
			}
		
			if (!checkAsc(frm.txAddr1.value)){
				alert('영문으로 입력해 주세요.');
				frm.txAddr1.focus();
				return;
			}
		
			if (!frm.overseaDlvYak.checked){
				alert('해외배송 약관에 동의 하셔야 주문 가능합니다.');
				frm.overseaDlvYak.focus();
				return;
			}
		<% else %>
			if (frm.reqname.value.length<1){
				alert('[받는 분]을 입력하세요');
				frm.reqname.focus();
				return false;
			}
			
			if ((frm.reqhp1.value.length<1)||(!IsDigit(frm.reqhp1.value))){
				alert('[받는 분 휴대폰]을 입력하세요');
				frm.reqhp1.focus();
				return false;
			}
		
			if ((frm.reqhp2.value.length<1)||(!IsDigit(frm.reqhp2.value))){
				alert('[받는 분 휴대폰]을 입력하세요');
				frm.reqhp2.focus();
				return false;
			}
		
			if ((frm.reqhp3.value.length<1)||(!IsDigit(frm.reqhp3.value))){
				alert('[받는 분 휴대폰]을 입력하세요');
				frm.reqhp3.focus();
				return false;
			}

			<% if Not(IsRsvSiteOrder or IsTicketOrder) then %>
			    try{
					if ((frm.txZip.value.length<2)||(frm.txAddr1.value.length<1)){
						alert('[받는 분 주소]를 입력하세요');
						return false;
					}
			
					/*
					if (frm.txAddr2.value.length<1){
						alert('[받는 분 상세 주소]를  입력하세요.');
						frm.txAddr2.focus();
						return false;
					}
					*/
				} catch (e) {}
			<% end if %>
			
			if ((frm.comment)&&(frm.comment.value=="etc")&&(frm.comment_etc)&&(frm.comment_etc.value.length>0)&&(isExceptCharExists(frm.comment_etc.value))){
			    alert('죄송합니다. 이모티콘및 특수 문자는 사용불가능합니다.');
				frm.comment_etc.focus();
				return false;
			}
		<% end if %>
	<% end if %>
    
    //바로배송 체크
	if ((frm.quickdlv)&&(frm.quickdlv.value=="QQ")){
	    if (!checkQuickArea()) {
	        //chkQuickDlv(document.getElementById("barobtn_n"));
	        alert('바로 배송(퀵배송)은 서울지역만 가능합니다.');   
	        return;
	    }
	    
	    if (!checkQuickMaxNo()) {
	        //chkQuickDlv(document.getElementById("barobtn_n"));
	        alert('바로 배송(퀵배송) 상품당 최대 구매 수량은 <%=C_MxQuickAvailMaxNo%>개 까지 가능합니다.');   
	        return;
	    }
	}
	
	//플라워 관련
	<% if (oshoppingbag.IsFixDeliverItemExists) then %>

	var oyear = <%= yyyy %>;
	var omonth = <%= mm %>;
	var odate = <%= dd %>;
	var ohours = <%= hh %>;
	var MinTime = <%= tt %>;

	//Date함수는 0월부터 시작
	var reqDate = new Date(frm.yyyy.value,frm.mm.value-1,frm.dd.value,frm.tt.value);
	var nowDate = new Date(oyear,omonth-1,odate,ohours);
	var nextDay = new Date(oyear,omonth-1,odate,24);
	var fixDate = new Date(oyear,omonth-1,odate,MinTime);

	if (frm.fromname!=undefined){
		if (frm.fromname.value.length<1){
			alert('플라워 메세지 보내는 분 정보를 입력하세요.');
			frm.fromname.focus();
			return false;
		}
	}

	if (nowDate>reqDate){
		alert("지난 시간은 선택하실 수 없습니다.");
		frm.tt.focus();
		return false;
	}else if (fixDate>reqDate){
		alert("상품준비 시간이 최소 <%=oshoppingbag.getFixDeliverOrderLimitTime-1 &"-"& oshoppingbag.getFixDeliverOrderLimitTime%>시간입니다!\n좀더 넉넉한 시간을 선택해주세요!");
		frm.tt.focus();
		return false;
	}

	<% end if %>

	frm.gift_code.value="";
	frm.gift_kind_option.value="";
	frm.gift_kind_option.value="";

	<% if (OpenGiftExists) then %>
		//사은품 관련 추가
		var vgift_code = "";
		var vgiftkind_code = "";
		var vgift_kind_option = "";
		var openRdCnt = 0;
		if (frm.rRange){
			if (frm.rRange.length){
				for(var i=0;i<frm.rRange.length;i++){
					if (!frm.rRange[i].disabled) openRdCnt++;
					if (frm.rRange[i].checked){
						vgift_code     = frm.rGiftCode[i].value;
						vgiftkind_code = frm.rRange[i].value;
	
						if (eval("document.frmorder.gOpt_" + frm.rRange[i].value)){
							var comp = eval("document.frmorder.gOpt_" + frm.rRange[i].value);
							if (comp.type!="hidden"){
								if (comp.value ==""){
									alert('사은품 옵션을 선택하세요');
									comp.focus();
									return false;
									//if (!confirm('사은품 옵션을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
									//    comp.focus();
									//    return false;
									//}
								}else if (comp.options[comp.selectedIndex].id =="S"){
									alert('품절된 옵션은 선택 불가 합니다.');
									comp.focus();
									return false;
								}
	
								vgift_kind_option = comp[comp.selectedIndex].value;
							}else{
								vgift_kind_option = comp.value;
	
							}
						}
					}
				}
	
			}else{
				if (!frm.rRange.disabled) openRdCnt++;
				if (frm.rRange.checked){
					vgift_code     = frm.rGiftCode.value;
					vgiftkind_code = frm.rRange.value;
					if (eval("document.frmorder.gOpt_" + frm.rRange.value)){
						var comp = eval("frmorder.gOpt_" + frm.rRange.value);
						if (comp.type!="hidden"){
							if (comp.value ==""){
								alert('사은품 옵션을 선택하세요');
								comp.focus();
								return false;
	
								//if (!confirm('사은품 옵션을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
								//    comp.focus();
								//    return false;
								//}
							}else if (comp.options[comp.selectedIndex].id =="S"){
								alert('품절된 옵션은 선택 불가 합니다.');
								comp.focus();
								return false;
							}
	
							vgift_kind_option = comp[comp.selectedIndex].value;
						}else{
							vgift_kind_option = comp.value;
						}
					}
				}
			 }
		}
	    
	    <% '20170810 전체 사은이벤트 쿠폰사용으로 disabled 되었을경우   %>
        if ((openRdCnt==0)&&(vgift_code!="")){
            vgift_code ="";
            vgiftkind_code ="";
            vgift_kind_option ="";
        }
        
		frm.gift_code.value=vgift_code;
		frm.giftkind_code.value=vgiftkind_code;
		frm.gift_kind_option.value=vgift_kind_option;
	
		//사은품을 선택 안한경우
		if ((openRdCnt>0)&&(vgift_code=="")){
			if (!confirm('사은품을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
				return false;
			}
		}
	<% end if %>

	<% if (DiaryOpenGiftExists) then %>
	    //다이어리 사은품 관련 추가
		var dgift_code = "";
		var dgiftkind_code = "";
		var dgift_kind_option = "";
		var openRdCnt = 0;
		try {
			if (frm.dRange){
				if (frm.dRange.length){
					for(var i=0;i<frm.dRange.length;i++){
						if (!frm.dRange[i].disabled) openRdCnt++;
		
						if (frm.dRange[i].checked){
		
							dgift_code     = frm.dtGiftCode[i].value;
							dgiftkind_code = frm.dRange[i].value;
		
							if (eval("document.frmorder.gOpt_" + frm.dRange[i].value)){
								var comp = eval("document.frmorder.gOpt_" + frm.dRange[i].value);
								if (comp.type!="hidden"){
									if (comp.value ==""){
										alert('사은품 옵션을 선택하세요');
										comp.focus();
										return false;
									}else if (comp.options[comp.selectedIndex].id =="S"){
										alert('품절된 옵션은 선택 불가 합니다.');
										comp.focus();
										return false;
									}
									dgift_kind_option = comp[comp.selectedIndex].value;
								}else{
									dgift_kind_option = comp.value;
								}
							}
						}
					}
				}else{
					if (!frm.dRange.disabled) openRdCnt++;
					if (frm.dRange.checked){
						dgift_code     = frm.dtGiftCode.value;
						dgiftkind_code = frm.dRange.value;
						if (eval("document.frmorder.gOpt_" + frm.dRange.value)){
							var comp = eval("frmorder.gOpt_" + frm.dRange.value);
							if (comp.type!="hidden"){
								if (comp.value ==""){
									alert('사은품 옵션을 선택하세요');
									comp.focus();
									return false;
								}else if (comp.options[comp.selectedIndex].id =="S"){
									alert('품절된 옵션은 선택 불가 합니다.');
									comp.focus();
									return false;
								}
		
								dgift_kind_option = comp[comp.selectedIndex].value;
							}else{
								dgift_kind_option = comp.value;
							}
						}
					}
				}
			}
		
			frm.dGiftCode.value=dgift_code;
			//frm.giftkind_code.value=vgiftkind_code;
			//frm.gift_kind_option.value=vgift_kind_option;
		} catch(e) {
			
		}
	
		//사은품을 선택 안한경우
		//if ((openRdCnt>0)&&(dgift_code=="")){
		//	if (!confirm('사은품을 선택하지 않으시면 랜덤 발송 됩니다. 계속 하시겠습니까?')){
		//		return false;
		//	}
		//}
	<% end if %>

	<% if (FALSE) and (DiaryOpenGiftExists) then %>
		//다이어리 사은품 관련 추가
		var dgMaxVal = <%=DiaryGiftCNT %>;
		var ttlDiVal = 0;
		var diAlldisable = true;
	
		if (frm.DiNo){
			for (var i=0;i<frm.DiNo.length;i++){
				if (frm.DiNo_disable[i].value=="Y"){
					frm.DiNo[i].value=0;
				}else{
					diAlldisable=false;
					ttlDiVal=ttlDiVal+frm.DiNo[i].value*1;
				}
	
			}
	
			if ((!diAlldisable)&&(ttlDiVal!=dgMaxVal)){
				alert('다이어리 사은품 증정가능수량 : '+dgMaxVal + '\n\n다이어리 사은품 선택수량 : '+ttlDiVal +'\n\n사은품을 더 선택해 주세요.');
				return false;
			}
		}
	<% end if %>
	try {
		if (frm.txAddr2.value.length > 0){
			frm.txAddr2.value = frm.txAddr2.value.replace(/・/g,"/")
		}		
	} catch (error) {
		return true
	}
	
	return true;
}

function isExceptCharExists(str) {
    var ranges = [
        '\ud83c[\udf00-\udfff]', // U+1F300 to U+1F3FF
        '\ud83d[\udc00-\ude4f]', // U+1F400 to U+1F64F
        '\ud83d[\ude80-\udeff]', // U+1F680 to U+1F6FF
        '\u2764','\u2661'
    ];
    
    if (str.match(ranges.join('|'))) {
        return true;
    } else {
        return false;
    }
}

<% if (isTenLocalUser) then %>
	var ilocalConfirmd = false;
	function fnTenLocalUserOrdCountCheck(){
	    var frm = document.baguniFrm;
	    var maxEa = 3;
	    if (frm.itemea.length){
	        for(var i=0;i<frm.itemea.length;i++){
	        	if (frm.itemea[i].value*1>maxEa){
	        	    return false;
	        	}
	        }
	    }else{
	        if (frm.itemea.value*1>maxEa){
	            return false;
	        }
	
	    }
	
	    return true;
	}
	
	function fnTenLocalUserConfirm(){
	    var popwin=window.open('popLocalUserConfirm.asp','enLocalUserConfirm','width=460,height=360,scrollbars=yes,resizable=yes')
	    popwin.focus();
	}
	
	function authPs(){
	    ilocalConfirmd = true;
	    setTimeout("PayNext(document.frmorder,'');",500);
	}
<% end if %>

var iclicked = false;

function PayNext(frm, iErrMsg){
	//alert('잠시 결제 점검중입니다.');
	//return;
	
	var OrderForm = document.getElementById("frmorder");
	
	<% If vIsTravelItemExist Then	'### 여행상품있을경우 %>
	if(!OrderForm.travelagree1.checked){
		alert('개인정보 제 3자 제공 동의에 체크해주세요.');
		return;
	}
	if(!OrderForm.travelagree2.checked){
		alert('별도의 환불규정 동의에 체크해주세요.');
		return;
	}
	<% End If %>

	<% If (Not IsForeignDlv) and (oshoppingbag.IsGlobalShoppingServiceExists) then '## 직구 관련 개인통관고유부호 입력 여부 %>
    	if(!OrderForm.customNumber.value || OrderForm.customNumber.value.length < 13){
    		alert('13자리의 개인통관 고유부호를 입력해주세요.');
    		OrderForm.customNumber.focus();
    		return;
    	}
    
    	var str1 = OrderForm.customNumber.value.substring(0,1);
    	var str2 = OrderForm.customNumber.value.substring(1,13);
    
    	if((str1.indexOf("P") < 0)&&(str1.indexOf("p") < 0)){
    		alert('P로 시작하는 13자리 번호를 입력 해주세요.');
    		OrderForm.customNumber.focus();
    		return;
    	}
    
    	var regNumber = /^[0-9]*$/;
    	if (!regNumber.test(str2)){
    		alert('숫자만 입력해주세요.');
    		OrderForm.customNumber.focus();
    		return;
    	}
    
    	if($("input:checkbox[id='intlAgree']").is(":checked") == false){
    		alert('개인통관 고유부호 정보 제공에 동의해주세요.');
    		$("#entryY").focus();
    		return;
    	}
	<% End If %>

	if(!$("#soldoutAgree").is(":checked")){
		alert("품절 시 처리 방법을 확인해주세요.");
		return;
	}

	if(!$("#orderAgree").is(":checked")){
		alert("상품, 가격, 할인, 배송정보에 동의하셔야 주문이 가능합니다");
		return;
	}

	if(OrderForm.price.value*1>0) {
		if(OrderForm.Tn_paymethod.value == "")
		{
			alert("결제수단을 선택하세요!");
			return;
		}
		
		var paymethod = OrderForm.Tn_paymethod.value;
	}
    
    if ((paymethod=="7")&&(frm.quickdlv)&&(frm.quickdlv.value=="QQ")){
        alert('바로배송(퀵배송) 서비스는 무통장 입금 결제 사용이 불가능 합니다.');
		return;
    }
    
	if (iErrMsg){
		alert(iErrMsg);
		return;
	}

	// 0원결제 (마일리지, 예치금 또는 Gift카드 사용시)
	if (OrderForm.price.value*1==0){
		paymethod = "000";
	}
    
    //couponmoney check 2015/11/19
    if (OrderForm.couponmoney.value*1==0){
	    OrderForm.sailcoupon.value="";
	    //OrderForm.appcoupon.value=""; 
	}
	
	//Check Default Form
	if (!CheckForm(OrderForm)){
		return;
	}

    <% if (isTenLocalUser)and(isTenLocalUserOrderCheck) then %>
    //직원 SMS 인증
    if ((OrderForm.itemcouponOrsailcoupon[0].checked)&&(OrderForm.sailcoupon.value.length>0)){
        var compid = OrderForm.sailcoupon[OrderForm.sailcoupon.selectedIndex].id;
        var icoupontype  = compid.split("|")[0]; //compid.substr(0,1);
        var icouponvalue = compid.split("|")[1]; //compid.substr(2,255);
        var icouponmxdis = compid.split("|")[2];

        if (((icoupontype*1==1)&&(icouponvalue*1>=15))||((icoupontype*1==2)&&(icouponvalue*1>=10000))){
            //if (!fnTenLocalUserOrdCountCheck()) {
            //    alert('직원쿠폰 구매시 한번에 최대 3개로 수량을 제한합니다.');
            //    return; //수량체크
            //}

            <% if session("tnsmsok")<>"ok" then %>
            if (!ilocalConfirmd){
                alert('직원 SMS 인증을 시작합니다.');
                fnTenLocalUserConfirm();
                return;
            }
            <% end if %>
        }
    }
    <% end if %>

	//신용카드
	if ((paymethod=="100")||(paymethod=="110")||(paymethod=="190")){
		//alert('현재 BC, 국민카드등 ISP 결제를 이용한 카드결제가 장애로 인해 지연되고 있습니다. \n\n가능한 다른 카드를 이용 부탁드립니다.');
        //alert('현재 삼성카드 카드결제가 장애로 인해 지연되고 있습니다. \n\n가능한 다른 카드를 이용 부탁드립니다.');

		if (paymethod=="190") {
			if (mobileDetect.tablet()!=null) {
				alert("안전한 결제를 위해 태블릿에서는\n텐바이텐 체크카드 결제를 지원하지 않습니다.");
				return;
			}
		} else {
			if (mobileDetect.tablet()!=null) {
				alert("안전한 결제를 위해 태블릿에서는\n신용카드 결제를 지원하지 않습니다.");
				return;
			}
		}

		if (OrderForm.price.value<100){
			alert('신용카드 최소 결제 금액은 100원 이상입니다.');
			return;
		}
		
        //if ((paymethod=="190")&&(OrderForm.price.value*1<1053)){
        //    alert('신용카드 최소 결제 금액은 1000원 이상입니다.');
		//	return;
        //}
        
		if (paymethod=="110"){
			OrderForm.gopaymethod.value = "onlyocbplus";
		}else{
			OrderForm.gopaymethod.value = "onlycard";
		}

		OrderForm.buyername.value = OrderForm.buyname.value;

		OrderForm.buyertel.value = OrderForm.buyhp1.value + "-" + OrderForm.buyhp2.value + OrderForm.buyhp3.value;

		if (OrderForm.itemcouponOrsailcoupon[1].checked){
			OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
		}else{
			OrderForm.checkitemcouponlist.value = "";
		}
		OrderForm.method="post";
		
		<% if (G_USE_BAGUNITEMP) then %>
        OrderForm.action = "<%=M_SSLUrl%>/inipay/card/ordertemp_ini.asp";
        <% else %>        
		OrderForm.action = "<%=M_SSLUrl%>/inipay/card/order_temp_save.asp";
	    <% end if %>
		OrderForm.submit();

	}

	//실시간 이체

	//All@

	//모바일
	if (paymethod=="400"){
		if(OrderForm.price.value*1 > 500000){
			alert("휴대폰결제는 결제 최대 금액이 50만원 이하 입니다.");
			return;
		}else if(OrderForm.price.value*1 <100){
			alert("휴대폰결제는 결제 최소 금액은 100원 이상입니다.");
			return;
		}else{
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}
		}
		OrderForm.method="post";
		
        OrderForm.buyername.value = OrderForm.buyname.value;
		OrderForm.buyertel.value = OrderForm.buyhp1.value + "-" + OrderForm.buyhp2.value + OrderForm.buyhp3.value;
        <% if (G_USE_BAGUNITEMP) then %>
        OrderForm.action = "<%=M_SSLUrl%>/inipay/card/ordertemp_ini.asp";    
        <% else %>
		OrderForm.action = "<%=M_SSLUrl%>/inipay/card/order_temp_save.asp";
	    <% end if %>
		OrderForm.submit();
		
	}
    
    <% if (G_PG_KAKAOPAY_ENABLE) then %>
	    //카카오페이
	    if (paymethod=="800"){
			if (mobileDetect.tablet()!=null) {
				alert("안전한 결제를 위해 태블릿에서는\n카카오페이를 지원하지 않습니다.");
				return;
			}

	        if(OrderForm.price.value*1 >= 5000000){
				alert("카카오페이 결제 최대 금액이 500만원 미만입니다.");
				return;
			}
			/* 1000원 이하 결제도 허용함
			else if(OrderForm.price.value*1 <100){
				alert("카카오페이 결제 최소 금액은 100원 이상입니다.");
				return;
			}
			*/
			
	        OrderForm.buyername.value = OrderForm.buyname.value;
			OrderForm.buyertel.value = OrderForm.buyhp1.value + "-" + OrderForm.buyhp2.value + OrderForm.buyhp3.value;
	
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}
			OrderForm.method="post";
			<% if (G_USE_BAGUNITEMP) then %>
				<% if (G_PG_KAKAOPAYNEW_ENABLE) Then %>
					// 신버전 카카오페이 연결
					OrderForm.action = "<%=M_SSLUrl%>/inipay/kakaoapi/ordertemp_kakao.asp";
				<% Else %>
					// 구버전 카카오페이 연결
					OrderForm.action = "<%=M_SSLUrl%>/inipay/kakao/ordertemp_kakao.asp";
				<% End If %>
			<% else %>
    			<% if (Request.ServerVariables("HTTPS")="on") then %>
    			OrderForm.action = "/inipay/kakao/order_temp_save_kakao.asp";
    			<% else %>
    			OrderForm.action = "<%=M_SSLUrl%>/inipay/kakao/order_temp_save_kakao.asp";
    		    <% end if %>
    		<% end if %>
		    OrderForm.submit();
	    }
    <% end if %>

    <% if (G_PG_TOSSPAYNEW_ENABLE) then %>
	    //토스페이
	    if (paymethod=="980"){
	        if(OrderForm.price.value*1 >= 2000000){
				alert("토스 결제 최대 금액이 200만원 이하입니다.");
				return;
			}
			/* 1000원 이하 결제도 허용함
			else if(OrderForm.price.value*1 <100){
				alert("카카오페이 결제 최소 금액은 100원 이상입니다.");
				return;
			}
			*/
			
	        OrderForm.buyername.value = OrderForm.buyname.value;
			OrderForm.buyertel.value = OrderForm.buyhp1.value + "-" + OrderForm.buyhp2.value + OrderForm.buyhp3.value;
	
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}
			OrderForm.method="post";
			<% if (application("Svr_Info")="Dev") then %>
				OrderForm.action = "/inipay/tosspay/ordertemp_toss.asp";
			<% Else %>
				OrderForm.action = "<%=M_SSLUrl%>/inipay/tosspay/ordertemp_toss.asp";
			<% End If %>
		    OrderForm.submit();
	    }
    <% end if %>	

    <% if (G_PG_CHAIPAYNEW_ENABLE) then %>
	    //차이페이
	    if (paymethod=="990"){
	        if(OrderForm.price.value*1 >= 2000000){
				alert("차이 결제 최대 금액이 200만원 이하입니다.");
				return;
			}
			/* 1000원 이하 결제도 허용함
			else if(OrderForm.price.value*1 <100){
				alert("카카오페이 결제 최소 금액은 100원 이상입니다.");
				return;
			}
			*/
			
	        OrderForm.buyername.value = OrderForm.buyname.value;
			OrderForm.buyertel.value = OrderForm.buyhp1.value + "-" + OrderForm.buyhp2.value + OrderForm.buyhp3.value;
	
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}
			OrderForm.method="post";
			<% if (application("Svr_Info")="Dev") then %>
				OrderForm.action = "/inipay/chaipay/ordertemp_chai.asp";
			<% Else %>
				OrderForm.action = "<%=M_SSLUrl%>/inipay/chaipay/ordertemp_chai.asp";
			<% End If %>
		    OrderForm.submit();
	    }
    <% end if %>	

    <% if (G_PG_NAVERPAY_ENABLE) then %>
	    //네이버페이
	    if (paymethod=="900"){

			// 네이버 페이 장애로 인해 결제 막음 2020-08-12
			<% If Now() >= #08/12/2020 14:00:00# And Now() < #08/12/2020 16:00:01# Then %>
				alert('네이버 페이 서비스 장애로 인해 결제를 하실 수 없습니다.');
				return;
			<% End If %>			
	    	
			// 현금영수증 신청
			if (OrderForm.cashreceiptreq!=undefined){
				if (OrderForm.cashreceiptreq.checked){
				   if (OrderForm.useopt[0].checked){
						if (!checkCashreceiptSSN(0,OrderForm.cashReceipt_ssn)){
							return false;
						}
				   }

				   if (OrderForm.useopt[1].checked){
						if (!checkCashreceiptSSN(1,OrderForm.cashReceipt_ssn)){
							return false;
						}
				   }
				}
			}

	        OrderForm.buyername.value = OrderForm.buyname.value;
			OrderForm.buyertel.value = OrderForm.buyhp1.value + "-" + OrderForm.buyhp2.value + OrderForm.buyhp3.value;
	
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}
			OrderForm.method="post";
			<% if (G_USE_BAGUNITEMP) then %>
			    OrderForm.action = "<%=M_SSLUrl%>/inipay/naverpay/ordertemp_npay.asp";
			<% else %>
    	        <% if (Request.ServerVariables("HTTPS")="on") then %>
    	        OrderForm.action = "/inipay/naverpay/order_temp_save_npay.asp";
    	        <% else %>
    			OrderForm.action = "<%=M_SSLUrl%>/inipay/naverpay/order_temp_save_npay.asp";
    		    <% end if %>
    		<% end if %>
			OrderForm.submit();
	    }
    <% end if %>

	<% if (G_PG_PAYCO_ENABLE) then %>
		//PAYCO 간편결제
		if (paymethod=="950"){
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}
			OrderForm.method="post";
            <% if (G_USE_BAGUNITEMP) then %>
                <% if (Request.ServerVariables("HTTPS")="on") then %>
                OrderForm.action = "/inipay/payco/ordertemp_payco.asp";
                <% else %>
                OrderForm.action = "<%=M_SSLUrl%>/inipay/payco/ordertemp_payco.asp";
                <% end if %>
            <% else %>
                <% if (Request.ServerVariables("HTTPS")="on") then %>
                OrderForm.action = "/inipay/payco/order_temp_save_payco.asp";
                <% else %>
			    OrderForm.action = "<%=M_SSLUrl%>/inipay/payco/order_temp_save_payco.asp";
		        <% end if %>
		    <% end if %>
			OrderForm.submit();
		}
	<% end if %>

	//무통장
	if (paymethod=="7"){
	    //alert('현재 무통장(가상계좌) 서비스에 일부 장애가 있습니다. 타결제수단 이용 또는 잠시 후 이용해 주시기 바랍니다.');
	    
		if (OrderForm.acctno.value.length<1){
			alert('입금하실 은행을 선택하세요. \r\n문자 메세지로 안내해 드립니다.');
			OrderForm.acctno.focus();
			return;
		}

		if (OrderForm.acctname.value.length<1){
			alert('입금자성명을 입력하세요..');
			OrderForm.acctname.focus();
			return;
		}

		if (OrderForm.price.value<0){
			alert('무통장입금 최소 결제 금액은 0원 이상입니다.');
			return;
		}else if (OrderForm.price.value*1==0){
			alert('쿠폰 또는 마일리지 사용으로 결제금액이 0원인 경우 주문 후 고객센터로 연락바랍니다.');
		}

		// 현금영수증 신청
		if (OrderForm.cashreceiptreq!=undefined){
			if (OrderForm.cashreceiptreq.checked){
			   if (OrderForm.useopt[0].checked){
					if (!checkCashreceiptSSN(0,OrderForm.cashReceipt_ssn)){
						return false;
					}
			   }

			   if (OrderForm.useopt[1].checked){
					if (!checkCashreceiptSSN(1,OrderForm.cashReceipt_ssn)){
						return false;
					}
			   }
			}
		}

		// 전자보증서 발급에 필요한 추가 정보 입력 검사 (추가 2006.6.13; 시스템팀 허진원)
		if (OrderForm.reqInsureChk!=undefined){
			if ((OrderForm.reqInsureChk.value=="Y")&&(OrderForm.reqInsureChk.checked)){
				
				if(!OrderForm.insureBdYYYY.value||OrderForm.insureBdYYYY.value.length<4||(!IsDigit(OrderForm.insureBdYYYY.value))) {
					alert("전자보증서 발급에 필요한 생일의 년도를 입력해주십시요.");
					OrderForm.insureBdYYYY.focus();
					return;
				}
				if(!OrderForm.insureBdMM.value) {
					alert("전자보증서 발급에 필요한 생일의 월을 선택해주십시요.");
					OrderForm.insureBdMM.focus();
					return;
				}
				if(!OrderForm.insureBdDD.value) {
					alert("전자보증서 발급에 필요한 주문고객님의 생일을 선택해주십시요.");
					OrderForm.insureBdDD.focus();
					return;
				}
				if(!OrderForm.insureSex[0].checked&&!OrderForm.insureSex[1].checked)
				{
					alert("전자보증서 발급에 필요한 주문고객님의 성별을 선택해주십시요.");
					return;
				}

				if(!OrderForm.agreeInsure.checked)
				{
					alert("전자보증서 발급에 필요한 개인정보이용에 동의를 하지 않으시면 전자보증서를 발급할 수 없습니다.");
					return;
				}
			}
		}

		if(OrderForm.rebankname.value==""){
			alert('환불 받을 계좌의 은행을 선택해주세요.');
			OrderForm.rebankname.focus();
			return;
		}
        if(OrderForm.encaccount.value==""){
			alert('계좌번호를 정확히 입력해주세요.');
			OrderForm.encaccount.focus();
			return;
		}
		if(OrderForm.rebankownername.value==""){
			alert('예금주를 정확히 입력해주세요.');
			OrderForm.rebankownername.focus();
			return;
		}

		var ret = confirm('주문 하시겠습니까?');
		if (ret){
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}

			OrderForm.target = "";
			OrderForm.method="post";
			OrderForm.action = "/inipay/AcctResult_test.asp";
			OrderForm.submit();
		}

	}

	// 0원결제.
	if (paymethod=="000"){
		if (OrderForm.price.value<0){
			alert('최소 결제 금액은 0원 이상입니다.');
			return;
		}

		var ret = confirm('결제하실 금액은 0원입니다. \n\n주문 하시겠습니까?');
		if (ret){
			if (OrderForm.itemcouponOrsailcoupon[1].checked){
				OrderForm.checkitemcouponlist.value = OrderForm.availitemcouponlist.value;
			}else{
				OrderForm.checkitemcouponlist.value = "";
			}

			OrderForm.target = "";
			OrderForm.method="post";
			OrderForm.action = "/inipay/AcctResult_test.asp";
			OrderForm.submit();
		}
	}
}

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

function RecalcuSubTotal(comp){
	var frm = document.frmorder;
	var spendmileage = 0;
	var spendtencash = 0;
	var spendgiftmoney = 0;
	var itemcouponmoney = 0;
	var couponmoney  = 0;

	var availtotalMile = <%= availtotalMile %>;
	var availtotalTenCash = <%= availtotalTenCash %>;
	var availTotalGiftMoney = <%= availTotalGiftMoney %>;
    var isquickdlv   = ((frm.quickdlv)&&(frm.quickdlv.value=="QQ"));
	var emsprice     = 0;

	<% if (IsForeignDlv) then %>
		var totalbeasongpay= 0;
		var tenbeasongpay= 0;
	    var pojangcash= <%= pojangcash %>;
	<% else %>
	    if (isquickdlv){
            var totalbeasongpay= <%= C_QUICKDLVPRICE %>;
    	    var tenbeasongpay= <%= C_QUICKDLVPRICE %>;
    	    var pojangcash= <%= pojangcash %>;
    	}else{
    		var totalbeasongpay= <%= oshoppingbag.GetOrgBeasongPrice %>;
    		var tenbeasongpay= <%= oshoppingbag.getTenDeliverItemBeasongPrice %>;
    	    var pojangcash= <%= pojangcash %>;
    	}
	<% end if %>

	var subtotalprice  = <%= subtotalprice %>;
	var fixprice  = <%= subtotalprice %>;

	// 상품 합계금액
	var itemsubtotal   = <%= oshoppingbag.GetTotalItemOrgPrice %>;

	// 보너스 쿠폰 사용시 추가 할인 가능 상품합계.
	var duplicateSailAvailItemTotal = <%= oshoppingbag.GetTotalDuplicateSailAvailItemOrgPrice %>;

	//보너스 쿠폰인지 상품쿠폰인지여부.
	var ItemOrSailCoupon = "";
	var compid;

	//KB카드 할인
	var kbcardsalemoney = 0;

	spendmileage = frm.spendmileage.value*1;
	spendtencash = frm.spendtencash.value*1;
	spendgiftmoney = frm.spendgiftmoney.value*1;
	itemcouponmoney = frm.itemcouponmoney.value*1;
	couponmoney     = frm.couponmoney.value*1;

	// 보너스 쿠폰
	//if (comp.name=="sailcoupon"){
    if ((comp.name=="sailcoupon")||((comp.name=="barobtn")&&(frm.itemcouponOrsailcoupon[0].checked))){
		ItemOrSailCoupon = "S";
		frm.itemcouponOrsailcoupon[0].checked = true;
		//frm.appcoupon.value="";

		compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

		coupontype  = compid.split("|")[0]; //compid.substr(0,1);
		couponvalue = compid.split("|")[1]; //compid.substr(2,255);
		couponmxdis = compid.split("|")[2]; 
        couponmxdis = parseInt(couponmxdis);

		if (coupontype=="0"){
			setTimeout(function(){
				alert('적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.');
			}, 100);
			frm.sailcoupon.value=""
			couponmoney = 0;
		}else if (coupontype=="1"){
			// % 보너스쿠폰
			//couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);
			couponmoney = parseInt(getPCpnDiscountPrice(couponvalue,couponmxdis,frm.sailcoupon[frm.sailcoupon.selectedIndex].value));

			// 추가 할인 불가 상품이 있을경우
			if (couponmoney*1==0){
				setTimeout(function(){
					alert('추가 할인되는 상품이 없습니다.\n\n(' + couponvalue + ' %) 보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
				}, 100);
				frm.sailcoupon.value=""
				couponmoney = 0;
			}else if ((itemsubtotal*1-<%= oshoppingbag.GetMileageShopItemPrice %>)!=duplicateSailAvailItemTotal){
			    if ((couponmxdis!=0)&&(Math.abs(100-(couponmoney*1/couponmxdis*1)*100)<1)){
			        if (couponmxdis==couponmoney){
			            setTimeout(function(){
    		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.');
    		 	        }, 100);
    			    }else{
    			        setTimeout(function(){
    		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.\r\n1원미만 단위는 반올림 하여 추가로 할인될 수 있습니다.');
    		 	        }, 100);
		 	        }
		 	    }else{
    				setTimeout(function(){
    					alert( '(' + couponvalue + ' %) 보너스 쿠폰의 경우 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
    				}, 100);
    			}
			}else if ((couponmxdis!=0)&&(Math.abs(100-(couponmoney*1/couponmxdis*1)*100)<1)){
			    if (couponmxdis==couponmoney){
		            setTimeout(function(){
		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.');
		 	        }, 100);
			    }else{
			        setTimeout(function(){
		 	            alert( '최대 '+plusComma(couponmxdis)+'원 까지 할인되는 쿠폰입니다.\r\n1원미만 단위는 반올림 하여 추가로 할인될 수 있습니다.');
		 	        }, 100);
	 	        }
	 	    }
	 	    
		}else if(coupontype=="2"){
			// 금액 보너스 쿠폰
			couponmoney = couponvalue*1;
		}else if(coupontype=="3"){
			//배송비 쿠폰.
			couponmoney = tenbeasongpay;
			<% if (IsForeignDlv) then %>
			if (tenbeasongpay==0){
				setTimeout(function(){
					alert('해외 배송이므로 추가 할인되지 않습니다.');
				}, 100);
				frm.sailcoupon.value=""
			}
			<% elseif (IsArmyDlv) then %>
			if (tenbeasongpay==0){
				setTimeout(function(){
					alert('군부대 배송비는 추가 할인되지 않습니다.');
				}, 100);
				frm.sailcoupon.value=""
			}
			<% else %>
			if (tenbeasongpay==0){
				setTimeout(function(){
					alert('무료 배송이므로 추가 할인되지 않습니다.(텐바이텐 배송비만 할인적용가능)');
				}, 100);
				frm.sailcoupon.value=""
			}else if (isquickdlv){
			    setTimeout(function(){
		            alert('바로배송(퀵배송)은 무료배송쿠폰 적용이 불가합니다..');
		        }, 100);
		        frm.sailcoupon.value=""
		        couponmoney=0
		    }
			<% end if %>
		}else{
			//미선택
			couponmoney = 0;
		}

        if(coupontype=="2"){
            couponmoney = AssignBonusCoupon(true,coupontype,couponvalue);
            if (couponmoney*1<1){
                setTimeout(function(){
                	alert('추가 할인되는 상품이 없습니다.\n\n일부 추가할인 불가상품은 추가할인이 제외되거나 브라우져 새로고침 후 다시시도하시기 바랍니다..');
                }, 100);
                frm.sailcoupon.value=""
                couponmoney = 0;
            }else{
                var altMsg = "금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우,\n상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용되며 이는 주문취소 및 반품시의 기준이 됩니다."
                altMsg+="\n\nex) 1만원상품 X 4개 구매 (2천원 할인쿠폰 사용)"
                altMsg+="\n40,000 - 2,000 (쿠폰) = 38,000원 (상품당 500원 할인)"
                altMsg+="\n4개 중 1개 주문취소 시, 9,500원 환불"
                setTimeout(function(){
                	alert(altMsg);
                }, 100);
            }
        }else if((coupontype=="6")||(coupontype=="7")){
            couponmoney = AssignBCBonusCoupon(coupontype,couponvalue,frm.sailcoupon[frm.sailcoupon.selectedIndex].value);
            if (couponmoney*1<1){
                alert('추가 할인되는 상품이 없습니다.\n\n보너스 쿠폰의 경우 기존 할인 상품, 일부 추가할인 불가상품은 추가할인이 제외됩니다.');
                frm.sailcoupon.value=""
                couponmoney = 0;
            }else{
                if (coupontype=="7"){
                    var altMsg = "금액할인쿠폰을 사용하여 복수의 상품을 구매 하시는 경우,\n상품별 판매가에 따라 쿠폰할인금액이 각각 분할되어 적용되며 이는 주문취소 및 반품시의 기준이 됩니다."
                    altMsg+="\n\nex) 1만원상품 X 4개 구매 (2천원 할인쿠폰 사용)"
                    altMsg+="\n40,000 - 2,000 (쿠폰) = 38,000원 (상품당 500원 할인)"
                    altMsg+="\n4개 중 1개 주문취소 시, 9,500원 환불"
                    alert(altMsg);
                }

            }
        }

		//원 상품대보다 보너스 쿠폰 금액이 많은경우 = 원상품액 (배송비쿠폰은 제외)
		if ((couponmoney*1>itemsubtotal*1)&&(coupontype!="3")){
			couponmoney = itemsubtotal*1;
		}

		itemcouponmoney = 0;

		AssignItemCoupon(false);

		<% if (DiaryOpenGiftExists) then %>
		frm.fixpriceTenItm.value = getCpnDiscountTenPrice(coupontype,couponvalue)
		<% end if %>
	}

	//if (comp.name=="itemcouponOrsailcoupon"){
	if ((comp.name=="itemcouponOrsailcoupon")||((comp.name=="barobtn")&&(frm.itemcouponOrsailcoupon[1].checked))){
		ItemOrSailCoupon = "I";
		frm.itemcouponOrsailcoupon[1].checked = true;
		frm.sailcoupon.value="";

		couponmoney = 0;
		itemcouponmoney = AssignItemCoupon(true);

		<% if (IsItemFreeBeasongCouponExists) then %>
		    if (isquickdlv){
                if (!frm.itemcouponOrsailcoupon[1].disabled){
                    setTimeout(function(){
                        alert('바로배송(퀵배송)은 무료배송쿠폰은 적용되지 않습니다.');
                    }, 100);
                    itemcouponmoney = itemcouponmoney*1;
                    frm.itemcouponOrsailcoupon[0].checked=true;
                }
            }else{
			    itemcouponmoney = itemcouponmoney*1 + tenbeasongpay*1;
			}
		<% end if %>
	}

	//KBCardMall
	if (frm.kbcardsalemoney){
		kbcardsalemoney = frm.kbcardsalemoney.value*1;
	}
	emsprice     = frm.emsprice.value*1;

	if (!IsDigit(frm.spendmileage.value)){
		frm.spendmileage.value = 0;
		alert('마일리지는 숫자만 가능합니다.');
		frm.spendmileage.value = 0;
	}

	if (spendmileage>availtotalMile){
		alert('사용 가능한 최대 마일리지는' + availtotalMile + ' Point 입니다.');
		frm.spendmileage.value = availtotalMile;

	}

	if (!IsDigit(frm.spendtencash.value)){
		frm.spendtencash.value = 0;
		alert('예치금 사용은 숫자만 가능합니다.');
		frm.spendtencash.value = 0;
	}

	if (!IsDigit(frm.spendgiftmoney.value)){
		frm.spendgiftmoney.value = 0;
		alert('Gift카드 사용은 숫자만 가능합니다.');
		frm.spendgiftmoney.value = 0;
	}

	if (spendtencash>availtotalTenCash){
		alert('사용 가능한 최대 예치금은' + availtotalTenCash + ' 원 입니다.');
		frm.spendtencash.value = availtotalTenCash;
	}

	if (spendgiftmoney>availTotalGiftMoney){
		alert('사용 가능한 Gift카드 잔액은' + availTotalGiftMoney + ' 원 입니다.');
		frm.spendgiftmoney.value = availTotalGiftMoney;
	}

	spendmileage = frm.spendmileage.value*1;
	spendtencash = frm.spendtencash.value*1;
	spendgiftmoney = frm.spendgiftmoney.value*1;

	if (spendmileage>(itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1)){
		alert('결제 하실 금액보다 마일리지를 더 사용하실 수 없습니다. 사용가능 마일리지는 ' + (itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1) + ' Point 입니다.');
		frm.spendmileage.value = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1;
		spendmileage = frm.spendmileage.value*1;
	}

	if (spendtencash>(itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1)){
		alert('결제 하실 금액보다 예치금을 더 사용하실 수 없습니다. 사용가능 예치금 ' + (itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1) + ' 원 입니다.');
		frm.spendtencash.value = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1;
		spendtencash = frm.spendtencash.value*1;
	}

	if (spendgiftmoney>(itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1)){
		alert('결제 하실 금액보다 Gift카드를 더 사용하실 수 없습니다. 사용가능 Gift카드 잔액은 ' + (itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1) + ' 원 입니다.');
		frm.spendgiftmoney.value = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + emsprice*1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendmileage*-1 + spendtencash*-1;
		spendgiftmoney = frm.spendgiftmoney.value*1;
	}

	fixprice = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + itemcouponmoney*-1 + couponmoney*-1 + emsprice*1;
	subtotalprice = itemsubtotal*1 + totalbeasongpay*1 + pojangcash*1 + spendmileage*-1 + itemcouponmoney*-1 + couponmoney*-1 + kbcardsalemoney*-1 + spendtencash*-1 + emsprice*1+ spendgiftmoney*-1;

	<% if (IsForeignDlv) then %>
	document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(emsprice*1);
	<% end if %>

	document.getElementById("DISP_SPENDMILEAGE").innerHTML = plusComma(spendmileage*-1);
	document.getElementById("DISP_SPENDTENCASH").innerHTML = plusComma(spendtencash*-1);
	document.getElementById("DISP_SPENDGIFTMONEY").innerHTML = plusComma(spendgiftmoney*-1);

	document.getElementById("DISP_ITEMCOUPON_TOTAL").innerHTML = plusComma(itemcouponmoney*-1);
	document.getElementById("DISP_SAILCOUPON_TOTAL").innerHTML = plusComma(couponmoney*-1);
	if (document.getElementById("DISP_KBCARDSALE_TOTAL")) document.getElementById("DISP_KBCARDSALE_TOTAL").innerHTML = plusComma(kbcardsalemoney*-1);

	//document.getElementById("DISP_FIXPRICE").innerHTML = plusComma(fixprice*1);  //2013-04-12 리뉴얼때 빠짐
	document.getElementById("DISP_SUBTOTALPRICE").innerHTML = plusComma(subtotalprice*1);
	//document.frmorder.mobileprdprice.value = subtotalprice*1;

	//할인금액 토탈
	document.getElementById("DISP_SAILTOTAL").innerHTML = plusComma((couponmoney*-1)+(itemcouponmoney*-1)+(spendmileage*-1)+(spendtencash*-1)+(spendgiftmoney*-1));

	frm.itemcouponmoney.value = itemcouponmoney*1;
	frm.couponmoney.value = couponmoney*1;
	frm.price.value= subtotalprice*1;
	frm.fixprice.value= fixprice*1;

	CheckGift(false);

	if (comp.name=="spendmileage"){
		$("#mige").attr("checked",true);
		$("#mileagedisplay").show();
		if(frm.spendmileage.value == "0" || frm.spendmileage.value == ""){
			$("#mige").attr("checked",false);
		}
	}else if(comp.name=="spendtencash"){
		$("#depositcheck").attr("checked",true);
		$("#depositdisplay").show();
	}else if(comp.name=="spendgiftmoney"){
		$("#giftCdcheck").attr("checked",true);
		$("#giftcarddisplay").show();
	}

	if (subtotalprice==0){
		document.getElementById("i_paymethod").style.display = "none";
		$("#refundInfo").hide();
	}else{
		if (document.getElementById("i_paymethod").style.display=="none"){
			document.getElementById("i_paymethod").style.display = "block";
		}
	}
}

function chkCouponDefaultSelect(comp){
	<% if (flgDevice<>"I") then %>
        return;
    <% end if %>
	var frm = document.frmorder;
	var couponmoney  = 0;

	// 보너스 쿠폰 사용시 추가 할인 가능 상품합계.
	var duplicateSailAvailItemTotal = <%= oshoppingbag.GetTotalDuplicateSailAvailItemOrgPrice %>;

	//보너스 쿠폰인지 상품쿠폰인지여부.
	var ItemOrSailCoupon = "";
	var compid;

	couponmoney     = frm.couponmoney.value*1;

	if (comp.name=="sailcoupon"){
		ItemOrSailCoupon = "S";
		frm.itemcouponOrsailcoupon[0].checked = true;
		//frm.appcoupon.value="";

		compid = frm.sailcoupon[frm.sailcoupon.selectedIndex].id;

		coupontype  = compid.split("|")[0]; //compid.substr(0,1);
		couponvalue = compid.split("|")[1]; //compid.substr(2,255);
		couponmxdis = compid.split("|")[2]; //
		couponmxdis = parseInt(couponmxdis);

		if (coupontype=="0"){
			// 적용 가능 할인쿠폰이 아니거나 해당 상품이 없습니다.
			frm.sailcoupon.value="";
			couponmoney = 0;
		}else if (coupontype=="1"){
			// % 보너스쿠폰
			//couponmoney = parseInt(duplicateSailAvailItemTotal*1 * (couponvalue / 100)*1);
            couponmoney = parseInt(getPCpnDiscountPrice(couponvalue,couponmxdis,frm.sailcoupon[frm.sailcoupon.selectedIndex].value));
			// 추가 할인 불가 상품이 있을경우
			if (couponmoney*1==0){
				//추가 할인되는 상품이 없습니다.
				frm.sailcoupon.value="";
				couponmoney = 0;
			}
		}

		RecalcuSubTotal(comp);
	}
}

function giftOptEnable(comp){
	<% if (OpenGiftExists) then %>
		<% for i=0 to oOpenGift.FResultCount-1 %>
		if (document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>){
			document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>.disabled = true;
			document.frmorder.gOpt_<%= oOpenGift.FItemList(i).Fgiftkind_code %>.selectedIndex=0;
		}
		<% next %>
	<% end if %>

	if (eval("document.frmorder.gOpt_" + comp.value)){
		eval("document.frmorder.gOpt_" + comp.value).disabled = false;
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
							$("#"+frm.rRange[i].id+"").parent().parent().parent().parent().parent().children('dt.tglBtnV16a').trigger("click");
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
					$("#"+frm.rRange[i].id+"").parent().parent().parent().parent().parent().children('dt.tglBtnV16a').trigger("click");
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
						$("#"+frm.rRange[i].id+"").parent().parent().parent().parent().parent().children('dt.tglBtnV16a').trigger("click");
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

function AssignBCBonusCoupon(icoupontype,icouponvalue,icouponid){
    var iasgnCouponMoney = 0;
    if (((icoupontype=="6")||(icoupontype=="7"))&&(icouponvalue*1>0)){
        $.ajax({
    		url: "/inipay/getPCpndiscount.asp?icoupontype="+icoupontype+"&icouponvalue="+icouponvalue+"&icouponid="+icouponid+"&jumunDiv=<%=jumunDiv%>",
    		cache: false,
    		async: false,
    		success: function(message) {
    			iasgnCouponMoney = message;
    		}
    	});
    }
    return iasgnCouponMoney;
}

function AssignMXBonusCoupon(icoupontype,icouponvalue,icouponid){
    var iasgnCouponMoney = 0;
    if ((icoupontype=="1")&&(icouponvalue*1>0)&&(icouponid*1>0)){
        $.ajax({
    		url: "/inipay/getPCpndiscount.asp?icoupontype="+icoupontype+"&icouponvalue="+icouponvalue+"&icouponid="+icouponid+"&jumunDiv=<%=jumunDiv%>",
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

function getPCpnDiscountPriceLimit(icouponvalue){
    var pcouponmoney = 0 ;
    var frm = document.baguniFrm;
    if (frm.distinctkey.length==undefined){
        //pcouponmoney = parseInt(Math.ceil(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
        pcouponmoney = parseInt(Math.ceil(parseInt(frm.pCpnBasePrc.value * icouponvalue*100000)/100000 / 100)*frm.itemea.value*1)*1;
    }else{
        for (var i=0;i<frm.distinctkey.length;i++){
            //pcouponmoney = pcouponmoney*1 + parseInt(Math.ceil(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
            pcouponmoney = pcouponmoney*1 + parseInt(Math.ceil(parseInt(frm.pCpnBasePrc[i].value * icouponvalue*100000)/100000 / 100)*frm.itemea[i].value*1)*1;
        }
    }
    return pcouponmoney;
}

function getPCpnDiscountPrice(icouponvalue,couponmxdis,icouponid){
	var pcouponmoney = 0 ;
	var frm = document.baguniFrm;
	if (frm.distinctkey.length==undefined){
		pcouponmoney = parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
	}else{
		for (var i=0;i<frm.distinctkey.length;i++){
			pcouponmoney = pcouponmoney*1 + parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
		}
	}
	couponmxdis = parseInt(couponmxdis);

	if ((couponmxdis*1>0)&&(pcouponmoney>couponmxdis)){
        pcouponmoney=AssignMXBonusCoupon("1",icouponvalue,icouponid);
        
    }
    return pcouponmoney;
}

function getCpnDiscountTenPrice(icoupontype, icouponvalue){
    var frm = document.baguniFrm;
    var dval = <%=TenDlvItemPriceCpnAssign%>;
    var cval = 0
    var udExsists = false;

    if (icoupontype=='1'){
        if (frm.distinctkey.length==undefined){
            if ((frm.dtypflag.value=="1")||(frm.dtypflag.value=="4")){
                cval = frm.isellprc.value*1*frm.itemea.value*1 - parseInt(Math.round(frm.pCpnBasePrc.value * icouponvalue / 100)*frm.itemea.value*1)*1;
            }
        }else{
            for (var i=0;i<frm.distinctkey.length;i++){
                if ((frm.dtypflag[i].value=="1")||(frm.dtypflag[i].value=="4")){
                    cval = cval*1 + frm.isellprc[i].value*1*frm.itemea[i].value*1 - parseInt(Math.round(frm.pCpnBasePrc[i].value * icouponvalue / 100)*frm.itemea[i].value*1)*1;
                }
            }
        }

        return cval;

    }else if (icoupontype=='2'){
        if (frm.distinctkey.length==undefined){
            if ((frm.dtypflag.value!="1")&&(frm.dtypflag.value!="4")){
                udExsists = true
            }
        }else{
            for (var i=0;i<frm.distinctkey.length;i++){
               if ((frm.dtypflag[i].value!="1")&&(frm.dtypflag[i].value!="4")){
                udExsists = true;
                break;
               }
            }
        }
        if (udExsists){
            return dval;
        }else{
            return dval*1-icouponvalue*1;
            alert(icouponvalue)
        }
    }else{
        return dval;
    }
}

function showCashReceptSubDetail(comp){
	if (comp.value=="0"){
		//document.getElementById("cashReceipt_subdetail1").style.display = "inline";
		//document.getElementById("cashReceipt_subdetail2").style.display = "none";
	}else{
		//document.getElementById("cashReceipt_subdetail1").style.display = "none";
		//document.getElementById("cashReceipt_subdetail2").style.display = "inline";
	}
}

function emsBoxChange(comp){
	var frm = comp.form;
	var iMaxWeight = 30000;  //(g)
	var totalWeight = <%= oshoppingbag.getEmsTotalWeight %>;
	var contryName = '';

	if (comp.value==''){
		frm.countryCode.value = '';
		frm.emsAreaCode.value = '';
		document.getElementById("divEmsAreaCode").innerHTML = "1";
		contryName = frm.countryCode.text;
	}else{
		frm.countryCode.value = comp.value;

		//for firefox
		frm.emsAreaCode.value = comp[comp.selectedIndex].id.split("|")[0]; 
		iMaxWeight = comp[comp.selectedIndex].id.split("|")[1];
		//frm.emsAreaCode.value = comp[comp.selectedIndex].iAreaCode;
		//iMaxWeight = comp[comp.selectedIndex].iMaxWeight;
		document.getElementById("divEmsAreaCode").innerHTML = frm.emsAreaCode.value;
		contryName = comp[comp.selectedIndex].text;
	}


	//iMaxWeight 체크
	if (totalWeight>iMaxWeight){
		alert('죄송합니다. ' + contryName + ' 최대 배송 가능 중량은 ' + iMaxWeight + ' (g)입니다.');
		comp.value='';
		//return;
	}

	//가격 계산.
	calcuEmsPrice(frm.emsAreaCode.value);
}

function calcuEmsPrice(emsAreaCode){
	//divEmsPrice
	var emsprice = 0;

	var _emsAreaCode = new Array(<%= oemsPrice.FResultCount %>);
	var _emsPrice = new Array(<%= oemsPrice.FResultCount %>);

	<% for i=0 to oemsPrice.FResultCount-1 %>
		_emsAreaCode[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsAreaCode %>';
		_emsPrice[<%= i %>] = '<%= oemsPrice.FItemList(i).FemsPrice %>';
	<% next %>

	for (var i=0;i<_emsAreaCode.length;i++){
		if (_emsAreaCode[i]==emsAreaCode){
			emsprice = _emsPrice[i];
			break;
		}
	}

	document.getElementById("divEmsPrice").innerHTML = plusComma(emsprice);
	document.getElementById("DISP_DLVPRICE").innerHTML = plusComma(emsprice);

	document.frmorder.emsprice.value = emsprice;
	RecalcuSubTotal(document.frmorder.emsprice);
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

function UpDnDiaryGift(i,n){
	var frm = document.frmorder;
	var pVal = 0;
	var ttlDiVal = 0;
	var dgMaxVal = <%=DiaryGiftCNT %>;
	var comp=null;

	if (frm.DiNo[i]){
		comp=frm.DiNo[i];
		if (frm.DiNo_disable[i].value!="Y"){
			pVal = comp.value*1;
			comp.value=comp.value*1+n*1;

			if (comp.value*1<1) comp.value=0;

			if (comp.value*1>dgMaxVal){
				comp.value=dgMaxVal;
				alert('받으실 사은품수량 '+dgMaxVal+'개를 초과할 수 없습니다.');
				return;
			}
		}else{
			comp.value=0;
		}
	}

	if (frm.DiNo.length){
		ttlDiVal=0;
		for (var i=0;i<frm.DiNo.length;i++){
			ttlDiVal = ttlDiVal + frm.DiNo[i].value*1;
		}

		if ((n*1>0)&&(ttlDiVal>dgMaxVal)){
			for (var i=0;i<frm.DiNo.length;i++){
				if (comp!=frm.DiNo[i]){
					if (frm.DiNo[i].value*1>=n*1){
						frm.DiNo[i].value=frm.DiNo[i].value*1-n*1;
						break;
					}
				}
			}
		}
		ttlDiVal=0;
		for (var i=0;i<frm.DiNo.length;i++){
			ttlDiVal = ttlDiVal + frm.DiNo[i].value*1;
		}
	}

	if (document.getElementById("HTML_DiaryGiftSelCNT")){
		document.getElementById("HTML_DiaryGiftSelCNT").innerHTML = plusComma(ttlDiVal*1);
	}
}

function checkDiaryGift(isFirst){
	var frm = document.frmorder;
	var availCnt = 0;
	var ischked = 0;
	var TenDlvItemPrice = 0;

	if (frm.TenDlvItemPrice){
		frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnNotAssign%>;
		if (frm.itemcouponOrsailcoupon[1].checked){
			frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnAssign%>;
		}else{
			frm.TenDlvItemPrice.value=frm.fixpriceTenItm.value;
		}

		TenDlvItemPrice = frm.TenDlvItemPrice.value;
	}

	TenDlvItemPrice = frm.fixprice.value*1; //2019/09/04
	
	if (frm.dRange){
		if (frm.dRange.length){
			for(var i=0;i<frm.dRange.length;i++){
				if (TenDlvItemPrice*1>=frm.dRange[i].id*1){
					frm.dRange[i].disabled = false;
					//default chk tenDlv
					if (frm.dGiftDlv[i].value=="N"){
						if (isFirst){
							frm.dRange[i].checked = true;
							 giftOptEnable(frm.dRange[i]);
							ischked = 1;
						}else{
							if (frm.dRange[i].checked) ischked = 1;
						}
					}

					availCnt++;
				}else{
					frm.dRange[i].disabled = true;
					frm.dRange[i].checked = false;
				}
			}
		}else{
			if (TenDlvItemPrice*1>=frm.dRange.id*1){
				frm.dRange.disabled = false;
				if (isFirst){
					frm.dRange.checked = true;
					giftOptEnable(frm.dRange);
					ischked = 1;
				}else{
					if (frm.dRange.checked) ischked = 1;
				}
	
				availCnt++;
			}else{
				frm.dRange.disabled = true;
				frm.dRange.checked = false;
			}
		}
	
		//When NoChecked Check Last
		if (ischked!=1){
			if (frm.dRange.length){
				for(var i=0;i<frm.dRange.length;i++){
					if (frm.dRange[i].disabled!=true){
						frm.dRange[i].checked = true;
						giftOptEnable(frm.dRange[i]);
					}
				}
			}else{
				if (frm.dRange.disabled == false){
					frm.dRange.checked = true;
					giftOptEnable(frm.dRange);
				}
			}
		}
	}
}

function checkDiaryGift_OLD(isFirst){
	var frm = document.frmorder;
	var dgMaxVal = <%=DiaryGiftCNT %>;
	var TenDlvItemPrice = 0;

	if (frm.TenDlvItemPrice){
		frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnNotAssign%>;
		if (frm.itemcouponOrsailcoupon[1].checked){
			frm.TenDlvItemPrice.value=<%=TenDlvItemPriceCpnAssign%>;
		}

		TenDlvItemPrice = frm.TenDlvItemPrice.value;
	}

	if (document.getElementById("HTML_TenDlvItemPrice")){
		document.getElementById("HTML_TenDlvItemPrice").innerHTML = plusComma(TenDlvItemPrice*1);
	}

	//When NoChecked Check Last

	if (frm.DiNo){
		for (var i=0;i<frm.DiNo.length;i++){
			if (TenDlvItemPrice*1>=frm.dRange[i].value*1){
				frm.DiNo_disable[i].value="N";
				frm.DiNo[i].style.backgroundColor="#FFFFFF";
			}else{
				frm.DiNo_disable[i].value="Y";
				frm.DiNo[i].style.backgroundColor="#EFEFEF";
				frm.DiNo[i].value=0;
			}
		}
	}

	if ((isFirst)&&(frm.DiNo)){
		for (var i=0;i<frm.DiNo.length;i++){
			if (frm.DiNo_disable[frm.DiNo.length-i-1].value!="Y"){
				frm.DiNo[frm.DiNo.length-i-1].value=dgMaxVal*1;

				break;
			}
		}
	}
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

//마일리지, 예치금, Gift카드 체크박스 셋팅
function fnMileageCalc(c,v){
	var m = "0";
	if(v == "mileage"){
		m = "<%= oMileage.FTotalMileage %>";
	}else if(v == "deposit"){
		m = "<%= availtotalTenCash %>";
	}else if(v == "giftcard"){
		m = "<%= availTotalGiftMoney %>";
	}
	
	if($("#"+c+"").is(":checked")){
		$("#"+v+"").val(m);
		$("#"+v+"display").show();
	}else{
		$("#"+v+"").val("");
		$("#"+v+"display").hide();
	}
	RecalcuSubTotal($("#"+v+""));
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

<%' 개인통관 고유 부호 관련 %>
function passagreechk(v){
	if (v == "Y"){
		$("#customNumber").attr("disabled",false).attr("readonly",false);
		$("input:checkbox[id='intlAgree']").prop("checked",true);
	}else if (v == "N"){
		$("#customNumber").attr("disabled",true).attr("readonly",false);
		$("input:checkbox[id='intlAgree']").prop("checked",false);
	}
}


</script>
