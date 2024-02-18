<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 1:1 상담
' History : 2015.05.27 이상구 생성
'			2016.03.25 한용민 수정(문의분야 모두 DB화 시킴)
'			2016.04.26 이종화 수정(상품문의 상품코드 입력시 post전송으로 데이터를 못불러옴 (상품검색 GET 최종 등록 POST))
'###########################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checkUserGuestLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/ordercls/pack_cls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/myqnacls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'SSL확인 및 이동
if request.ServerVariables("SERVER_PORT_SECURE")<>1 then
    IF application("Svr_Info")="Dev" THEN
    	'response.redirect "https://2009www.10x10.co.kr/my10x10/qna/myqnawrite.asp"
    else
    	'response.redirect "https://www.10x10.co.kr/my10x10/qna/myqnawrite.asp"
    end if
    'response.end
end if

dim orderserial, itemid, qadiv, userid, i, tmpqadivname, tmpqadivcnt, offshopqna, qnatitle, shopid, shopname, offshopinfo
	orderserial = requestCheckVar(request("orderserial"),11)
	qadiv       = requestCheckVar(request("qadiv"),4)
	itemid      = requestCheckVar(getNumeric(request("itemid")),9)

	shopid = requestCheckVar(request("shopid"),16)
	Set  offshopinfo = New COffShop
	offshopinfo.FRectShopID=shopid
	offshopinfo.GetOneOffShopContents
	shopname = offshopinfo.FOneItem.FShopName
	Set offshopinfo = Nothing
	If shopname<>"" Then
		qnatitle = "[매장문의] " + shopname +" 문의드립니다."
	End If 
' querystring으로 못 받아오면 form으로 받아온다.
If itemID = "" Then
	itemID = request.Form("itemID")
End If

'if (orderserial<>"") then itemid=""

if IsGuestLoginOK() then orderserial = GetGuestLoginOrderserial()

dim OUserInfo, usermail
if IsUserLoginOK() then
	set OUserInfo = new CUserInfo
	OUserInfo.FRectUserID = getEncLoginUserID()
	OUserInfo.GetUserData()

	if OUserInfo.FResultCount > 0 then
		usermail = OUserInfo.FOneItem.FUsermail
	end if

	set OUserInfo = Nothing
end if

dim myorder
set myorder = new CMyOrder
	if (orderserial<>"") then
	    if IsUserLoginOK() then
	        myorder.FRectUserID = userid
	        myorder.FRectOrderserial = orderserial
	        myorder.GetOneOrder
	    elseif IsGuestLoginOK() then
	        myorder.FRectOrderserial = orderserial
	        myorder.GetOneOrder
	    end if
	end if

dim oItem, ItemExists
set oItem = New CatePrdCls
	if (itemid<>"") then
	    oItem.GetItemData itemid

	    if (oItem.Prd.FItemid="") then
	        response.write "<script language='javascript'>alert('검색된 상품이 없습니다.');</script>"
	    else
	        ItemExists = True
	    end if
	end if

Dim vImgURL
	vImgURL = staticImgUrl & "/contents/my10x10" & "/myqna_temp/" & Year(Now) & "/"

dim cqadiv
set cqadiv = new CMyQNA
	cqadiv.FPageSize = 500
	cqadiv.FCurrPage = 1
	cqadiv.frectcomm_isdel = "N"
	cqadiv.frectdispyn = "Y"
	cqadiv.getqadiv_list()
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
/* global fnAPPpopupBrowserURL, getCheckedIndex, $, IsDigit, getValue, setValue, callNativeFunction */

var CurrDisp = "";

function popMyOrderNo(){
	var url = "/apps/appCom/wish/web2014/my10x10/orderPopup/popMyOrderNo.asp";

	fnAPPpopupBrowserURL("주문번호 찾기","http://m.10x10.co.kr" + url,"right","myqna_search_orderserial");
}

function jsReActWithOrderserial(orderserial) {
	var frm = document.SubmitFrm;
	frm.orderserial.value = orderserial;
	return false;
}

function popMyOrderItemID(){
	var f = document.SubmitFrm;
	var url = "/apps/appCom/wish/web2014/my10x10/orderPopup/popMyOrderItemID.asp?orderserial=" + f.orderserial.value;

	fnAPPpopupBrowserURL("상품코드 찾기","http://m.10x10.co.kr" + url,"right","myqna_search_itemid");

}

function jsReActWithItemID(orderserial, itemid) {
	var frm = document.SubmitFrm;
	frm.orderserial.value = orderserial;
	frm.itemid.value = itemid;
	return false;
}

function SubmitForm(frm) {
	var qaIdx = getCheckedIndex(frm.qadiv);

	if (qaIdx<0){
		alert("상담구분을 선택해주세요!!");
		frm.qadiv[0].focus();
		return;
	}
	var qadiv = frm.qadiv[qaIdx].value;

	if ((CurrDisp=="1")&&(frm.s_orderserial.value.length<1)){
		alert('주문번호를 조회해 주세요');
		return;
	}

	if ((CurrDisp=="2")&&(frm.s_itemid.value.length<1)){
		alert('문의하실 상품번호를 조회해 주세요');
		return;
	}

	if (frm.username.value.length<1) {
		alert("성함을 입력하세요.");
		frm.username.focus();
		return;
	}

	if (frm.title.value.length<1) {
		alert("제목을 입력하세요.");
		frm.title.focus();
		return;
	}

	if (frm.contentsView.value.length<1) {
		alert("내용을 입력하세요.");
		frm.contentsView.focus();
		return;
	}

	if (frm.usermail.value.length<1) {
		alert("이메일을 입력하세요.");
		frm.usermail.focus();
		return;
	}

	if (!check_form_email(frm.usermail.value)){
		alert("이메일 주소가 유효하지 않습니다.");
		frm.usermail.focus();
		return;
	}

	// <% if flgDevice <> "A" then %>
	if (frm.sfile.value != "") {
		if (window.File && window.FileReader && window.FileList && window.Blob) {
			var fsize = $('#sfile')[0].files[0].size;

			if (fsize > 10*1024*1024) {
				alert("이미지는 최대 3메가까지만 허용됩니다.");
				return;
			}
		}
	}
	if (frm.sfile2.value != "") {
		if (window.File && window.FileReader && window.FileList && window.Blob) {
			var fsize = $('#sfile2')[0].files[0].size;

			if (fsize > 10*1024*1024) {
				alert("이미지는 최대 3메가까지만 허용됩니다.");
				return;
			}
		}
	}
	// <% end if %>

	if (qadiv == "14") {
		if (frm.orderserial.value == "") {
			alert("주문번호를 선택하세요");
			return;
		}

		if (frm.itemid.value == "") {
			alert("상품코드를 선택하세요");
			return;
		}

		if ((frm.returnItemNo.value == "") || (IsDigit(frm.returnItemNo.value) != true)) {
			alert("반품수량을 입력하세요.");
			return;
		}

		if (frm.returnReason.selectedIndex == 0) {
			alert("반품사유를 선택하세요.");
			return;
		}
	}

	if (confirm("내용을 정확히 입력하셨습니까?")) {
		if (qadiv == "14") {
			frm.contents.value = "\n&gt;&gt;&gt; <b>반품정보 : 수량 :" + frm.returnItemNo.value + "개 / 사유 : " + frm.returnReason.value + "</b>\n\n" + frm.contentsView.value;
		}else{
		    frm.contents.value =frm.contentsView.value;
		}

		$("#regbtn").hide();
		$("#lyLoading").show();
		setTimeout(reOpenSaveBtn,5000);

		// <% '2016-04-26 이종화 추가/수정 %>
		frm.backurl.value = "/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp";
		frm.method = 'post';

		if (frm.sfile.value != "" || frm.sfile2.value != "") {
			document.getElementById('idfrm').enctype = 'multipart/form-data';
			frm.action = '<%= Replace(uploadImgUrl, "http://", "https://") %>/linkweb/my10x10/uploadMyQnaFileUTF8_MOBILE_New.asp';
		} else {
			frm.action = "myqna_process.asp";
		}
		// <% '2016-04-26 이종화 추가/수정 %>
		frm.submit();
	}
}

function reOpenSaveBtn() {
	$("#regbtn").show();
	$("#lyLoading").hide();
}

function getItemInfo(frm){
	if (frm.itemid.value.length<1){
		alert("상품번호를 먼저 넣어주세요.");
		frm.itemid.focus();
		return;
	}

	if (!IsDigit(frm.itemid.value)||(frm.itemid.value=="")){
		alert("상품번호는 숫자만 가능합니다.");
		frm.itemid.focus();
		return;
	}
	if (getValue(frm.qadiv)!="02")
	{
		alert("직접입력은 상품문의일때만 가능합니다.");
	}
	else
	{
		frm.orderserial.value= "";
		frm.submit();
	}
}

function check_form_email(email){
	var pos;
	pos = email.indexOf('@');
	if (pos < 0){				//@가 포함되어 있지 않음
		return(false);
	}else{

		pos = email.indexOf('@', pos + 1);
		if (pos >= 0)			//@가 두번이상 포함되어 있음
			return(false);
	}


	pos = email.indexOf('.');

	if (pos < 0){				//@가 포함되어 있지 않음
		return false;
	}
	return(true);
}

function showItemHelp(){
	if (getValue(document.SubmitFrm.qadiv)=="02")
	{
		if (document.getElementById("divItemHelp").style.display == "none")
			document.getElementById("divItemHelp").style.display = "block";
		else
			document.getElementById("divItemHelp").style.display = "none";
	}
}

window.onload = function(){
	setValue(document.SubmitFrm.qadiv,"<%=qaDiv%>");
	initDiv();
};

function initDiv(){
	var f = document.SubmitFrm;
	var qaDiv = getValue(f.qadiv);

	document.getElementById("layoutView1").style.display = "none";
	document.getElementById("layoutView2").style.display = "none";
	document.getElementById("layoutView4").style.display = "none";
	document.getElementById("btnItem1").style.display = "none";
	document.getElementById("btnItem2").style.display = "none";
	document.getElementById("layoutSection").style.display = "none";
	document.getElementById("layoutView5").style.display = "none";

	if (qaDiv=="02") {
		document.getElementById("layoutSection").style.display = "";
		document.getElementById("layoutView2").style.display = "";
		document.getElementById("btnItem1").style.display = "";
	} else if (qaDiv=="00" || qaDiv=="01" || qaDiv=="04" || qaDiv=="14" || qaDiv=="06" || qaDiv=="05"  || qaDiv=="15" || qaDiv=="09" || qaDiv=="23" || qaDiv=="25") {
		document.getElementById("layoutSection").style.display = "";
		document.getElementById("layoutView1").style.display = "";
		document.getElementById("layoutView2").style.display = "";
		document.getElementById("btnItem2").style.display = "";

		if (qaDiv == "14") {
			// 반품문의
			document.getElementById("layoutView4").style.display = "";
		}
	}else if (qaDiv=="10") {
		document.getElementById("layoutSection").style.display = "";
		document.getElementById("layoutView5").style.display = "";
	}
}

function delimage(ifile){
	document.getElementById(ifile).value = "";
}

function changeReturnDeliveryPay() {
	var frm = document.SubmitFrm;

	if (frm.returnReason.selectedIndex == 1) {
		$( ".returnDeliveryPay" ).html( "환불시 반품배송비가 <em class='cRd1'>차감</em>됩니다." );
	} else if (frm.returnReason.selectedIndex == 2) {
		$( ".returnDeliveryPay" ).html( "반품배송비 : 무료<br />(상품확인 후 '상품불량'이 아닐 경우, 환불시 반품배송비가 차감됩니다.)" );
	} else if (frm.returnReason.selectedIndex == 3) {
		$( ".returnDeliveryPay" ).html( "반품배송비 : 무료<br />(상품확인 후 '누락/오배송'이 아닐 경우, 환불시 반품배송비가 차감됩니다.)" );
	} else {
		$( ".returnDeliveryPay" ).html( "" );
	}
}

var _selComp;
var _no;

function fnAPPuploadImage(comp, no) {
    _selComp = comp;
    _no = no;
    var paramname = comp.name;
    var upurl = '<%= Replace(uploadImgUrl, "http://", "https://") %>/linkweb/my10x10/uploadMyQnaFileUTF8_IMAGE.asp?orderserial=<%= GetGuestLoginOrderserial() %>&paramname='+paramname;
    callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish});
    return false;
}

function fnAPPuploadImage2(comp, no) {
    _selComp = comp;
    _no = no;
    var paramname = comp.name;
    var upurl = '<%= Replace(uploadImgUrl, "http://", "https://") %>/linkweb/my10x10/uploadMyQnaFileUTF8_IMAGE.asp?orderserial=<%= GetGuestLoginOrderserial() %>&paramname='+paramname;
    callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish});
    return false;
}

function appUploadFinish(ret){
    //alert(_no);
    if (_selComp){
        _selComp.value=ret.name;

        $('#imgspan'+_no).empty();
        $('#imgspan'+_no).html('<img src="<%= vImgURL %>'+ret.name+'" height="42" alt="" />');
    }
}

function jsDelImage(a){
	$('#sfile'+a).val('');
	$('#imgspan'+a).empty();
	$('#imgspan'+a).text('이미지를 선택해주세요.');
}

function updateChar(val) {
	var len = calculate_msglen(val);

	document.getElementById("charlen").innerHTML = "" + len + "/16000";
}

function calculate_msglen(msg) {
	var nbytes = 0;

	for (var i = 0; i < msg.length; i++) {
		var ch = msg.charAt(i);

		if(escape(ch).length > 4) {
			nbytes += 2;
		} else if(ch == '\n') {
			if (msg.charAt(i-1) != '\r') {
				nbytes += 1;
			}
		} else {
			nbytes += 1;
		}
	}

	return nbytes;
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content myQna" id="contentArea">
			<div class="inner10" id="content">
				<ul class="cpNoti">
					<li>문의하실 분야를 선택하신 후 내용을 입력하신 다음 "신청하기" 버튼을 눌러주세요.</li>
					<li>한번 등록한 상담내용은 수정이 불가능하며 수정을 원하시는 경우 삭제 후 재등록 하셔야 합니다.</li>
				</ul>
				<div class="myQnaWrite">
					<form id="idfrm" name="SubmitFrm" method="get" action="" onsubmit="return false;">
					<input type="hidden" name="mode" value="INS">
					<input type="hidden" name="backurl" value="/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp">
					<input type="hidden" name="dtype" value="<%= flgDevice %>">
					<% if myorder.FResultCount>0 then %>
						<input type="hidden" name="s_orderserial" value="<%= myorder.FOneItem.Forderserial %>">
					<% else %>
						<input type="hidden" name="s_orderserial" value="">
					<% end if %>
					<% if (ItemExists) then %>
						<input type="hidden" name="s_itemid" value="<%= oItem.Prd.FItemid %>">
					<% else %>
						<input type="hidden" name="s_itemid" value="">
					<% end if %>
					<section class="tPad15">
						<h2>구매관련 문의</h2>
						<ul class="qnaType">
							<%
							tmpqadivcnt=0
							if cqadiv.FResultCount > 0 then
							%>
								<%
								for i = 0 to cqadiv.FResultCount - 1

								if isarray(split(cqadiv.FItemList(i).fcomm_name,"!@#")) then
									if ubound(split(cqadiv.FItemList(i).fcomm_name,"!@#")) > 0 then
										tmpqadivname =  split(cqadiv.FItemList(i).fcomm_name,"!@#")(1)
									end if
								end if
								%>
									<%
									'/구매관련 문의만 뿌림
									if cqadiv.FItemList(i).fcomm_group="D001" then

									tmpqadivcnt = tmpqadivcnt + 1
									%>
										<% if instr(tmpqadivname,"선물포장")>0 then %>
											<% If G_IsPojangok Then %>
												<li><input type="radio" id="a<%= Format00(2,tmpqadivcnt) %>" name="qadiv" value="<%= right(cqadiv.FItemList(i).fcomm_cd,2) %>" onClick="initDiv();" /> <label for="a<%= Format00(2,tmpqadivcnt) %>"><%= tmpqadivname %></label></li>
											<% End If %>
										<% else %>
											<li><input type="radio" id="a<%= Format00(2,tmpqadivcnt) %>" name="qadiv" value="<%= right(cqadiv.FItemList(i).fcomm_cd,2) %>" onClick="initDiv();" /> <label for="a<%= Format00(2,tmpqadivcnt) %>"><%= tmpqadivname %></label></li>
										<% end if %>
									<% end if %>
								<%
								tmpqadivname = ""

								next
								%>
							<% end if %>
						</ul>

						<h2>일반상담 문의</h2>
						<ul class="qnaType">
							<%
							tmpqadivcnt=0
							if cqadiv.FResultCount > 0 then
							%>
								<%
								for i = 0 to cqadiv.FResultCount - 1

								if isarray(split(cqadiv.FItemList(i).fcomm_name,"!@#")) then
									if ubound(split(cqadiv.FItemList(i).fcomm_name,"!@#")) > 0 then
										tmpqadivname =  split(cqadiv.FItemList(i).fcomm_name,"!@#")(1)
									end if
								end if
								%>
									<%
									'/일반상담 문의만 뿌림
									if cqadiv.FItemList(i).fcomm_group="D002" then

									tmpqadivcnt = tmpqadivcnt + 1
									%>
										<li><input type="radio" id="b<%= Format00(2,tmpqadivcnt) %>" name="qadiv" value="<%= right(cqadiv.FItemList(i).fcomm_cd,2) %>" onClick="initDiv();" /> <label for="b<%= Format00(2,tmpqadivcnt) %>"><%= tmpqadivname %></label></li>
									<% end if %>
								<%
								tmpqadivname = ""

								next
								%>
							<% end if %>
						</ul>

						<h2>기타 문의</h2>
						<ul class="qnaType">
							<%
							tmpqadivcnt=0
							if cqadiv.FResultCount > 0 then
							%>
								<%
								for i = 0 to cqadiv.FResultCount - 1

								if isarray(split(cqadiv.FItemList(i).fcomm_name,"!@#")) then
									if ubound(split(cqadiv.FItemList(i).fcomm_name,"!@#")) > 0 then
										tmpqadivname =  split(cqadiv.FItemList(i).fcomm_name,"!@#")(1)
									end if
								end if
								%>
									<%
									'/기타 문의만 뿌림
									if cqadiv.FItemList(i).fcomm_group="D003" then

									tmpqadivcnt = tmpqadivcnt + 1
									%>
										<li><input type="radio" id="c<%= Format00(2,tmpqadivcnt) %>" name="qadiv" value="<%= right(cqadiv.FItemList(i).fcomm_cd,2) %>"<% If right(cqadiv.FItemList(i).fcomm_cd,2)="16" Then Response.write " checked" %> onClick="initDiv();" /> <label for="c<%= Format00(2,tmpqadivcnt) %>"><%= tmpqadivname %></label></li>
									<% end if %>
								<%
								tmpqadivname = ""

								next
								%>
							<% end if %>
						</ul>
					</section>

					<section class="tPad15" id="layoutSection">
						<table class="writeTbl01">
							<colgroup>
								<col width="20%">
								<col width="">
							</colgroup>
							<tbody>
								<tr id="layoutView1" style="display: none;">
									<th class="ct">주문번호</th>
									<td>
										<input type="number" class="w70p" id="textfield" name="orderserial" value="<%= orderserial %>" maxlength="11" Readonly>
										<span class="button btB2 btGry cBk1 lMar05"><a href="" onClick="popMyOrderNo();return false;">조회</a></span>
										<div id="lyrOrdInf">
											<% if myorder.FResultCount>0 then %>
											<p class="tMar05 fs10 lh12 cRd1">주문일 <%= Left(myorder.FOneItem.FRegdate,10) %><br />총 결제금액 <%= FormatNumber(myorder.FOneItem.FSubTotalPrice,0) %> 원(<%= myorder.FOneItem.getAccountDivName %>)</p>
											<% end if %>
										</div>
									</td>
								</tr>
								<tr id="layoutView2" style="display: none;">
									<th class="ct">상품코드</th>
									<td>
										<input type="number" class="w70p" name="itemid" id="textfield" value="<%= itemid %>" maxlength="9">
										<span class="button btB2 btGry cBk1 lMar05" id="btnItem1"><a href="" onclick="getItemInfo(SubmitFrm);return false;">조회</a></span>
										<span class="button btB2 btGry cBk1 lMar05" id="btnItem2"><a href="" onClick="popMyOrderItemID();return false;">조회</a></span>
										<div id="lyrItmInf">
											<% if (ItemExists) then %>
											<p class="tMar05 fs10 cRd1"><%= chrbyte(oItem.Prd.FItemName,30,"Y") %>&nbsp;<%= FormatNumber(oItem.Prd.FSellcash,0) %> 원</p>
											<% end if %>
										</div>
									</td>
								</tr>
								<tr id="layoutView4" style="display: none;">
									<th class="ct" style="vertical-align:middle;">반품수량 및<br />사유</th>
									<td class="cGy3">
										<p>
											<span>수량 : </span>
											<span class="lPad05"><input type="number" style="width:50px" name="returnItemNo" /></span>
										</p>
										<p class="tPad10">
											<span>사유 : </span>
											<span class="lPad05">
												<select class="select w50p" name="returnReason" onChange="changeReturnDeliveryPay()">
													<option value="">사유를 선택하세요</option>
													<option value="단순변심">단순변심</option>
													<option value="상품불량">상품불량</option>
													<option value="상품누락/오배송">상품누락/오배송</option>
												</select>
											</span>
										</p>
										<p class="tPad05 fs10 lh12">
											<span class="returnDeliveryPay"></span>
										</p>
									</td>
								</tr>
								<tr id="layoutView5" style="display: none;">
									<th class="ct" style="vertical-align:middle;">운영체제 및 기기</th>
									<td class="cGy3">
										<p class="tPad10">
											<span class="lPad05">
												<select class="select w50p" name="OS" id="OS">
													<option value="">선택 안함</option>
													<option value="iOS">iOS</option>
													<option value="Android">Android</option>
												</select>
											</span>
										</p>
										<p class="tPad10">
											<span class="lPad05"><input type="text" style="width:140px" name="OSetc" id="OSetc" placeholder="예:아이폰X" /></span>
										</p>
										<p class="tPad05 fs10 lh12">
											<span class="returnDeliveryPay"></span>
										</p>
									</td>
								</tr>
							</tbody>
						</table>
					</section>

					<section class="tPad20">
						<table class="writeTbl01">
							<colgroup>
								<col width="20%">
								<col width="">
							</colgroup>
							<tbody>
								<tr>
									<th class="ct">주문자</th>
									<td>
										<strong class="cBk1 fs12">
											<%=GetLoginUserName()%>
											<% if getEncLoginUserID() <> "" then %>
											<input type="hidden" name="username" class="text" value="<%=GetLoginUserName()%>">
											<% else %>
											<input type="text" name="username" class="w50p" value="" maxlength="16">
											<% end if %>
										</strong>
									</td>
								</tr>
								<tr>
									<th class="ct">아이디</th>
									<td>
										<strong class="cBk1 fs12">
											<% if getEncLoginUserID()<>"" then %><%= getEncLoginUserID() %> [<%= GetUserLevelStr(GetLoginUserLevel) %>고객]<% else %>비회원입니다.<% end if %>
										</strong>
									</td>
								</tr>

								<tr>
									<th class="ct">이메일</th>
									<td><input type="email" class="w100p" name="usermail" value="<%= usermail %>"></td>
								</tr>
								<tr>
									<td colspan="2"><input type="text" class="w100p" name="title" value="<%=qnatitle%>" placeholder="제목을 입력하세요." /></td>
								</tr>
								<tr>
									<td colspan="2">
										<textarea cols="20" rows="5" class="w100p" name="contentsView" placeholder="내용을 입력하세요" onKeyUp="updateChar(this.value)"></textarea>
										<input type="hidden" name="contents" value="">
										<div class="count bMar05 cGy1 fs12 rt"><div id="charlen">0/16000</div></div>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<div class="addImage mar0">
											<% if flgDevice="A" then %>
											<p>
												<input type="hidden" name="sfile" id="sfile" value="">
												<button class="selectFile" onClick="fnAPPuploadImage(this.form.sfile, '');">파일선택</button>
												<span class="pic" id="imgspan">이미지를 선택해주세요.</span>
												<button class="btnDel" onClick="jsDelImage(''); return false;">파일 삭제</button>
											</p>
											<p>
												<input type="hidden" name="sfile2" id="sfile2" value="">
												<button class="selectFile" onClick="fnAPPuploadImage2(this.form.sfile2, '2');">파일선택</button>
												<span class="pic" id="imgspan2">이미지를 선택해주세요.</span>
												<button class="btnDel" onClick="jsDelImage('2'); return false;">파일 삭제</button>
											</p>
											<% else %>
											<p><input type="file" id="sfile" name="sfile" /> <button class="btnDel" onClick="delimage('sfile');return false;">파일 삭제</button></p>
											<p><input type="file" id="sfile2" name="sfile2" /> <button class="btnDel" onClick="delimage('sfile2');return false;">파일 삭제</button></p>
											<% end if %>
										</div>
										<p class="addTip bPad10" style="text-align:left;"><% if flgDevice="I" then %><span>*</span> 한번에 한장씩 첨부해주세요.<br/><% End If %><span>*</span> 상담시 이미지가 필요하신 경우 첨부해 주세요.<br /><span>*</span> 파일크기는 3MB이하, JPG, PNG 또는 GIF형식의 파일만 가능합니다.</p>
									</td>
								</tr>
								<tr>
									<th class="ct">휴대전화</th>
									<td>
										<input type="text" class="w100p" name="userphone" value="">
										<p class="tPad05 cGy1 fs11">* 답변 등록시 SMS가 발송됩니다.</p>
									</td>
								</tr>
							</tbody>
						</table>
					</section>
					</form>
					<p class="tPad15 ct">
						<span id="regbtn">
							<span class="button btB1 btRed cWh1"><a href="javascript:SubmitForm(SubmitFrm);">신청</a></span>
							<span class="button btB1 btRedBdr cRd1"><a href="" onClick="history.back();return false;">취소</a></span>
						</span>
						<span id="lyLoading" style="display:none;text-align:center;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" />&nbsp;&nbsp;<strong>저장 중 입니다. 잠시만 기다려주세요.</strong></span>
					</p>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>

<%
set cqadiv = nothing
set myorder = Nothing
set oItem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
