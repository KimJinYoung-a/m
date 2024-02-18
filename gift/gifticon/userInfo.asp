<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/emscls.asp" -->
<!-- #include virtual="/lib/classes/orderCls/clsMyAddress.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<script type="application/x-javascript" src="/lib/js/iui_clickEffect.js"></script>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<%
	Dim vQuery, vIdx, vResult, vItemID, vItemOption, vRequiredetail, vCouponNO, vOptionname, vMakerID, vBrandName, vListImage, vItemName
	vIdx = requestCheckVar(request("idx"),10)
	vItemID = requestCheckVar(request("itemid"),10)

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
	end If

Dim countryCode  : countryCode = request("ctrCd")
dim reload : reload = requestcheckvar(request("reload"),2)
Dim jumunDiv : jumunDiv = request("bTp")
Dim IsForeignDlv : IsForeignDlv = (jumunDiv="f")        ''해외 배송 여부
Dim cOldMy, vOldCnt, vMyCnt, vKRdeliNotOrder, vGiftTabView, vGiftTabTemp
vOldCnt = 0
vMyCnt = 0
vGiftTabView = 0
vKRdeliNotOrder = "x"
if (IsUserLoginOK) then
	Set cOldMy = New clsMyAddress
	cOldMy.FRectUserId = userid
	cOldMy.FRectCountryCode = CHKIIF(IsForeignDlv,"","KR")
	cOldMy.fnRecentCntMyCnt
	vOldCnt = cOldMy.FOLDCnt
	vMyCnt = cOldMy.FMYCnt
	Set cOldMy = Nothing
	
	'### 국내배송 and 최근배송이 없을때 기본 셋팅
	If IsForeignDlv = False AND CInt(vOldCnt) < 1 Then
		vKRdeliNotOrder = "o"
	End If
end if
Dim vIsTravelItemExist, vIsDeliveItemExist, vIsTravelIPExist, vIsTravelJAExist
vIsDeliveItemExist = False
vIsTravelItemExist = False
vIsTravelIPExist = False
vIsTravelJAExist = False

dim oItem, ItemContent
set oItem = new CatePrdCls
oItem.GetItemData vItemID

'//옵션 HTML생성
dim ioptionBoxHtml
IF (oitem.Prd.FOptionCnt>0) then
	ioptionBoxHtml = GetOptionBoxHTML(vItemID, oitem.Prd.IsSoldOut)
End IF

	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end Function

''EMail ComboBox
function DrawEamilBoxHTML2(frmName,txBoxName, cbBoxName,emailVal,classNm)
    dim RetVal, i, isExists : isExists=false
    dim eArr : eArr = Array("naver.com", "daum.net", "hanmail.net", "gmail.com", "nate.com", "empal.com")
	emailVal = LCase(emailVal)

    RetVal = "<input name='"&txBoxName&"' type='text' value='' style='display:none;width:61%;'/>&nbsp;"
    RetVal = RetVal & "<select name='"&cbBoxName&"' id='select3' style='width:60%' class='"&classNm&"' onChange=""jsShowMailBox('"&frmName&"','"&cbBoxName&"','"&txBoxName&"');""\>"
    ''RetVal = RetVal & "<option value=''>메일선택</option>"
    for i=LBound(eArr) to UBound(eArr)
        if (eArr(i)=emailVal) then
            isExists = true
            RetVal = RetVal & "<option value='"&eArr(i)&"' selected>"&eArr(i)&"</option>"
        else
            RetVal = RetVal & "<option value='"&eArr(i)&"' >"&eArr(i)&"</option>"
        end if
    next

    if (Not isExists) and (emailVal<>"") then
        RetVal = RetVal & "<option value='"&emailVal&"' selected>"&emailVal&"</option>"
    end if
    RetVal = RetVal & "<option value='etc' >직접 입력</option>"
    RetVal = RetVal & "</select>"

    response.write RetVal

end Function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/oldContent.css">
<title>10x10: 배송지 정보입력</title>
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
    var frmopt = document.frm1;
    var optCode = "0000";

    var MOptPreFixCode="Z";

    if (!frmopt.item_option){
        //옵션 없는경우

    }else if (!frmopt.item_option[0].length){
        //단일 옵션
        if (frmopt.item_option.value.length<1){
            alert('옵션을 선택 하세요.');
            frmopt.item_option.focus();
            return;
        }

        if (frmopt.item_option.options[frmopt.item_option.selectedIndex].id=="S"){
            alert('품절된 옵션은 구매하실 수 없습니다.');
            frmopt.item_option.focus();
            return;
        }

        optCode = frmopt.item_option.value;
    }else{
        //이중 옵션 경우

        for (var i=0;i<frmopt.item_option.length;i++){
            if (frmopt.item_option[i].value.length<1){
                alert('옵션을 선택 하세요.');
                frmopt.item_option[i].focus();
                return;
            }

            if (frmopt.item_option[i].options[frmopt.item_option[i].selectedIndex].id=="S"){
                alert('품절된 옵션은 구매하실 수 없습니다.');
                frmopt.item_option[i].focus();
                return;
            }

            if (i==0){
                optCode = MOptPreFixCode + frmopt.item_option[i].value.substr(1,1);
            }else if (i==1){
                optCode = optCode + frmopt.item_option[i].value.substr(1,1);
            }else if (i==2){
                optCode = optCode + frmopt.item_option[i].value.substr(1,1);
            }
        }

        if (optCode.length==2){
            optCode = optCode + "00";
        }

        if (optCode.length==3){
            optCode = optCode + "0";
        }
    }

    frmopt.itemoption.value = optCode;

    if (frmopt.requiredetail){

		if (frmopt.requiredetail.value.length<1){
			alert('주문 제작 상품 문구를 작성해 주세요.');
			frmopt.requiredetail.focus();
			return;
		}

		if(GetByteLength(frmopt.requiredetail.value)>255){
			alert('문구 입력은 한글 최대 120자 까지 가능합니다.');
			frmopt.requiredetail.focus();
			return;
		}
	}

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

    if ((frm.txZip.value.length<1)||(frm.txAddr1.value.length<1)){
        alert('수령지 주소를  입력하세요.');
        return false;
    }

	/*
    if (frm.txAddr2.value.length<1){
        alert('수령지 상세 주소를  입력하세요.');
        frm.txAddr2.focus();
        return false;
	}
	*/

    return true;
}

function PayNext(frm, iErrMsg){
    if (!CheckForm(frm)){
        return;
    }

	var ret = confirm('배송 요청 하시겠습니까?');
	if (ret){
		frm.target = "";
		frm.action = "order_real_save.asp";
		frm.submit();
	}
}
function jsChgoptlayer(a){
	return;
}
</script>
<!-- #include file="UserInfo_javascript.asp" -->
</head>
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content gifticon gifticon-item">
		<div class="gifticon-section">
			<div class="items type-list">
				<div class="thumbnail">
					<% if ImageExists(vListImage) then %>
					<img src="<%=vListImage%>" alt="" />
					<% end if %>
				</div>
				<div class="desc">
					<p class="name">[<%=UCase(vBrandName)%>] <%=vItemName%></p>
				</div>
			</div>
			<div class="itemFloatingV17">
			<form name="frm1" method="post" action="option_select_proc.asp">
			<input type="hidden" name="idx" value="<%=vIdx%>">
			<input type="hidden" name="itemid" value="<%=vItemID%>">
			<input type="hidden" name="itemoption" value="">
				<div class="itemOptWrapV16a">
					<div class="itemOptV16a">
						<div class="itemoption">
							<%=ioptionBoxHtml%>
						</div>
						<% if oItem.Prd.FItemDiv = "06" then %>
						<div class="rqtxt onlyTxt tPad0-9r">
							<div class="txtBoxV16a current">
								<textarea name="requiredetail" placeholder="[문구입력란] 문구를 입력해 주세요!"></textarea>
							</div>
						</div>
						<% End If %>
					</div>
				</div>
			</form>
			</div>
		</div>
		<!-- for dev msg : 주문결제 페이지와 동일 -->
		<div class="cartV16a">
		<form name="frmorder" method="post">
		<input type="hidden" name="idx" value="<%=vIdx%>">
		<input type="hidden" name="itemid" value="<%=vItemID%>">
		<input type="hidden" name="itemoption" value="<%=vItemOption%>">
		<input type=hidden name="paymethod" value="560">
		<input type=hidden name="price" value="">
		<input type=hidden name="goodname" value='<%= vItemName %>'>
		<input type=hidden name="buyername" value="">
		<input type=hidden name="buyeremail" value="">
		<input type=hidden name="buyemail" value="">
		<input type=hidden name="buyertel" value="">
			<div class="orderInfoV16a tMar1-3r">
				<!-- 주문고객 정보 -->
				<div class="cartGrpV16a">
					<div class="bxLGy2V16a grpTitV16a">
						<h2>주문고객 정보</h2>
					</div>
					<div class="bxWt1V16a infoUnitV16a">
						<dl class="infoArrayV16a">
							<dt>주문자</dt>
							<dd><input type="text" style="width:100%;" name="buyname" maxlength="16" value="<%= doubleQuote(oUserInfo.FOneItem.FUserName) %>" /></dd>
						</dl>
						<dl class="infoArrayV16a">
							<dt>이메일</dt>
							<dd>
								<input type="email" style="width:30%;" name="buyemail_Pre" maxlength="40" value="<%= Splitvalue(oUserInfo.FOneItem.FUserMail,"@",0) %>" />
								@
								<% call DrawEamilBoxHTML2("frmorder","buyemail_Tx","buyemail_Bx",Splitvalue(oUserInfo.FOneItem.FUserMail,"@",1),"mailinput") %>
							</dd>
						</dl>
						<dl class="infoArrayV16a">
							<dt>휴대전화</dt>
							<dd><input type="tel" class="ct" style="width:5rem;" min="0" max="4" name="buyhp1" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" onfocus="this.type='tel';" /> - <input type="tel" class="ct" style="width:5rem;" min="0" max="4" name="buyhp2" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" /> - <input type="tel" name="buyhp3" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" class="ct" style="width:5rem;" min="0" max="4" /></dd>
						</dl>
						<dl class="infoArrayV16a">
							<dt>전화번호</dt>
							<dd><input type="tel" name="buyphone1" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>" class="ct" style="width:5rem;" min="0" max="4" onfocus="this.type='tel';" /> - <input type="tel" name="buyphone2" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>" class="ct" style="width:5rem;" min="0" max="4" /> - <input type="tel" name="buyphone3" value="<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>" class="ct" style="width:5rem;" min="0" max="4" /></dd>
						</dl>
					</div>
				</div>
				<!--// 주문고객 정보 -->

				<!-- 배송지 정보 -->
				<div class="cartGrpV16a">
					<div class="bxLGy2V16a grpTitV16a">
						<h2>배송지 정보</h2>
					</div>
					<div class="bxWt1V16a infoUnitV16a">
						<div class="infoArrayV16a">
							<ul class="btnBarV16a"  id="overseatab">
								<% if (IsUserLoginOK) then %>
								<li style="width:33%;" opt="R" onclick="copyDefaultinfo(this,'KR');"><div>기본 배송지</div></li>
								<li style="width:34%;" opt="P" onclick="copyDefaultinfo(this,'KR');"><div>최근 배송지</div></li>
								<li style="width:33%;" opt="N" onclick="copyDefaultinfo(this,'KR');"><div>신규 배송지</div></li>
								<% End If %>
							</ul>
							<input type="hidden" name="rdDlvOpt" value="" />
						</div>
						<% if (IsUserLoginOK) then %>
							<!-- 나의주소록/과거주문 클릭시 노출 -->
							<div class="infoArrayV16a" id="myaddress" style="display:none;"></div>
							<div class="infoArrayV16a" id="recentOrder" style="display:none;"></div>
						<% End If %>
						<dl class="infoArrayV16a">
							<dt>받는분</dt>
							<dd><input type="text" style="width:100%;" name="reqname" maxlength="16" value="" autocomplete="off" /></dd>
						</dl>
						<dl class="infoArrayV16a">
							<dt>휴대전화</dt>
							<dd>
								<input type="number" class="ct" style="width:5rem;" name="reqhp1" onkeyup="fnNemberNextFocus('reqhp1','reqhp2',3);" pattern="[0-9]*" value="" title="휴대전화번호 국번" onfocus="this.type='number';" autocomplete="off" /> - 
								<input type="number" class="ct" style="width:5rem;" name="reqhp2" onkeyup="fnNemberNextFocus('reqhp2','reqhp3',4);" pattern="[0-9]*" value="" title="휴대전화번호 앞자리" autocomplete="off" /> - 
								<input type="number" class="ct" style="width:5rem;" name="reqhp3" onkeyup="fnOverNumberCut('reqhp3',4);" pattern="[0-9]*" value="" title="휴대전화번호 뒷자리" autocomplete="off" />
							</dd>
						</dl>
						<dl class="infoArrayV16a">
							<dt>전화번호</dt>
							<dd>
								<input type="number" class="ct" style="width:5rem;" name="reqphone1" onkeyup="fnNemberNextFocus('reqphone1','reqphone2',4);" pattern="[0-9]*" value="" title="전화번호 국번" onfocus="this.type='number';" autocomplete="off" /> - 
								<input type="number" class="ct" style="width:5rem;" name="reqphone2" onkeyup="fnNemberNextFocus('reqphone2','reqphone3',4);" pattern="[0-9]*" value="" title="전화번호 앞자리" autocomplete="off" /> - 
								<input type="number" class="ct" style="width:5rem;" name="reqphone3" onkeyup="fnOverNumberCut('reqphone3',4);" pattern="[0-9]*" value="" title="전화번호 뒷자리" autocomplete="off" />
							</dd>
						</dl>
						<dl class="infoArrayV16a">
							<dt class="vTop">주소</dt>
							<dd>
								<p><input type="text" class="ct" style="width:8.5rem;" name="txZip" value="" ReadOnly /> <input type="button" class="btnV16a btnLGryV16a lMar0-5r" style="width:10.25rem;" value="우편번호 찾기" onclick="searchZipKakao('searchZipWrap','frmorder'); return false;" /></p>
								<p id="searchZipWrap" style="display:none;border:1px solid;width:100%;height:300px;margin:5px 0;position:relative">
									<img src="//fiximage.10x10.co.kr/m/2019/common/btn_delete.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-36px;z-index:1;width:35px;height:35px;" onclick="foldDaumPostcode('searchZipWrap')" alt="접기 버튼">
								</p>								
								<style>
									.cartV16a .inp-box {display:block; padding:0.4rem 0.6rem; font-size:1.2rem; color:#000; border-radius:0.2rem; border:1px solid #cbcbcb; width:100%;}
								</style>											
								<p class="tMar0-5r">
									<textarea name="txAddr1" title="주소" ReadOnly class="inp-box" ></textarea>
								</p>
								<p class="tMar0-5r"><input type="text" style="width:100%;" name="txAddr2" title="상세주소" maxlength="60" value="" autocomplete="off" /></p>
								<!-- <p class="tMar0-5r"><input type="checkbox" checked="checked" id="basicAddr" /> <span class="cMGy1V16a lPad0-5r"><label for="basicAddr">이 주소를 기본 배송지로 저장</label></span></p> -->
							</dd>
						</dl>
						<dl class="infoArrayV16a">
							<dt class="vTop">배송 메시지</dt>
							<dd>
								<p>
									<select style="width:100%;" name="comment" onChange="fnCommentMsg(this.value);">
										<option value="">배송메시지 선택</option>
										<option value="배송 전 연락 바랍니다.">배송 전 연락 바랍니다.</option>
										<option value="부재시 경비실(관리실)에 맡겨주세요.">부재시 경비실(관리실)에 맡겨주세요.</option>
										<option value="부재시 휴대폰으로 연락 바랍니다.">부재시 휴대폰으로 연락 바랍니다.</option>
										<option value="etc">직접입력</option>
									</select>
								</p>
								<p class="tMar0-5r" id="delivmsg" style="display:none;"><textarea rows="3" style="width:100%;" placeholder="30자 이내로 등록해주세요. 30자 이내로 등록해주세요. 30자 이내로 등록해주세요." name="comment_etc" maxlength="60" value="" autocomplete="off"></textarea></p>
							</dd>
						</dl> 
						<!-- <dl class="infoArrayV16a" style="padding:0.4rem 0 0.25rem 0">
							<dt style="padding-top:0">주문서 여부</dt>
							<dd>
								<span class="cBk1V16a"><input type="radio" id="have" checked="checked" /><label for="have" class="lMar0-5r">포함</label></span>
								<span class="cBk1V16a lMar2-5r"><input type="radio" id="haveNot" /><label for="haveNot" class="lMar0-5r">미포함</label></span>
							</dd>
						</dl> -->
					</div>
				</div>
				<!--// 배송지 정보 -->
			</div>
		</form>
		</div>
		<div class="btn-group">
			<button type="submit" class="btn btn-xlarge btn-red btn-block" onClick="PayNext(frmorder,'');">확인</button>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
<script type="text/javascript">
<!--
$(function(){
	<% If CInt(vOldCnt) > 0 Then %>
		copyDefaultinfo($("#overseatab > li").eq(1),'<%=CHKIIF(IsForeignDlv,"","KR")%>')
	<% Else %>
		copyDefaultinfo($("#overseatab > li").eq(0),'<%=CHKIIF(IsForeignDlv,"","KR")%>')
	<% End If %>
});
//-->
</script>
<form name="tranFrmApi" id="tranFrmApi" method="post">
	<input type="hidden" name="tzip" id="tzip">
	<input type="hidden" name="taddr1" id="taddr1">
	<input type="hidden" name="taddr2" id="taddr2">
	<input type="hidden" name="extraAddr" id="extraAddr">
</form>
</body>
</html>
<% set oUserInfo   = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->