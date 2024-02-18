<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<%
	Dim orderserial, userid
	Dim oUniPassNumber
	orderserial = requestCheckVar(request("orderserial"), 11)
	userid = getEncLoginUserID()

    dim myorder, IsBiSearch
    set myorder = new CMyOrder
   
    if IsUserLoginOK() then
        myorder.FRectUserID = userid
        myorder.FRectOrderserial = orderserial
        myorder.GetOneOrder
    elseif IsGuestLoginOK() then
        myorder.FRectOrderserial = GetGuestLoginOrderserial()
        myorder.GetOneOrder
    
        IsBiSearch = True
        orderserial = myorder.FRectOrderserial
    end if

    if myorder.FResultCount<1 then
        dbget.close()
        response.end
    end if
    
    set myorder = Nothing

	If orderserial <> "" Then oUniPassNumber = fnUniPassNumber(orderserial)
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
function fnCustomNumberSubmit(){
	var frm =  document.frm;
	if(!frm.customNumber.value || frm.customNumber.value.length < 13){
		alert('13자리의 개인통관고유부호 를 입력 해주세요.');
		frm.customNumber.focus();
		return;
	}

	var str1 = frm.customNumber.value.substring(0,1);
	var str2 = frm.customNumber.value.substring(1,13);

	if((str1.indexOf("P") < 0) == true){
		alert('P로 시작하는 13자리 번호를 입력 해주세요.');
		frm.customNumber.focus();
		return;
	}

	var regNumber = /^[0-9]*$/;
	if (!regNumber.test(str2)){
		alert('번호를 숫자만 입력해주세요.');
		frm.customNumber.focus();
		return;
	}

	frm.target = "";
	frm.action = "/my10x10/orderPopup/popCustomsIdEdit_proc.asp";
	frm.submit();
}

function chmyorderdetail(orderserial){
	location.replace('/my10x10/order/myorderdetail.asp?idx='+orderserial);
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1>개인통관 고유부호 수정</h1>
			<p class="btnPopClose"><button class="pButton" onclick="chmyorderdetail('<%=orderserial%>');">닫기</button></p>
		</div>
		<div class="content" id="contentArea">
			<div class="userInfo userInfoEidt inner10">
				<form name="frm" method="post" onSubmit="return false">
				<input type="hidden" name="orderserial" value="<%=orderserial%>"/>
					<fieldset>
						<legend>개인통관 고유부호 수정</legend>
							<dl class="infoInput">
								<dt><label for="individualNum">개인통관고유부호</label></dt>
								<dd><input type="text" id="individualNum" style="width:100%;" name="customNumber" value="<%=oUniPassNumber%>" maxlength="13"/></dd>
							</dl>

							<div class="btnWrap">
								<div class="ftLt w50p"><span class="button btB1 btGry2 cWh1 w100p"><button type="button" onclick="chmyorderdetail('<%=orderserial%>');">취소</button></span></div>
								<div class="ftLt w50p"><span class="button btB1 btRed cWh1 w100p"><button type="submit" onclick="fnCustomNumberSubmit();">수정</button></span></div>
							</div>
					</fieldset>
				</form>
			</div>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->