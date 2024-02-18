<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 나의 예치금
' History : 2018-11-30 이종화 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_tenCashCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    dim userid , username , vCurrentDeposit
    userid = getEncLoginUserID
    username = getLoginUserName

    if Not(IsUserLoginOK) then
        Response.write "<script>alert('로그인하셔야 사용할 수 있습니다.');fnAPPclosePopup();</script>"
        dbget.close()
        Response.End
    end if

    dim oTenCash
    set oTenCash = new CTenCash
    oTenCash.FRectUserID = userid
    oTenCash.getUserCurrentTenCash

    vCurrentDeposit = oTenCash.Fcurrentdeposit

    if oTenCash.Fcurrentdeposit = 0 then 
        Response.Write "<script>alert('예치금이 0원 입니다.');fnAPPclosePopup();</script>"
        dbget.close()
        Response.End
    end if

%>
<script type="text/javascript">
function returnToBankCash()
{
	var frm = document.frmReturnToBankCash;
    var sel = frm.rebankname;
    var selval = sel.options[sel.selectedIndex].value;

	if(!frm.returncash.value){
		alert("반환 받으실 금액을 입력 해주세요.");
		frm.returncash.focus();
		return;
	}

	if(!IsDigit(frm.returncash.value))
	{
		alert("반환 받으실 금액을 정확히 입력해주세요");
		frm.returncash.value.replace(/[^0-9]/g, "");
		frm.returncash.focus();
		return;
	}

	if(!selval){
		alert("반환 받으실 계좌의 은행을 선택해주세요");
		return;
	}

	if(!frm.rebankaccount.value)
	{
		alert("반환 받으실 계좌번호를 입력해주세요.");
		frm.rebankaccount.focus();
		return;
	}

	if(!IsDigit(frm.rebankaccount.value)){
		alert("반환받으실 계좌번호를 정확히 입력해주세요.");
		frm.rebankaccount.value.replace(/[^0-9]/g, "");
		frm.rebankaccount.focus();
		return;
	}

	if (!frm.rebankownername.value){
		alert("반환 받으실 계좌의 예금주를 입력해주세요.");
		frm.rebankownername.value = "";
		frm.rebankownername.focus();
		return;
	}

	if((<%=vCurrentDeposit%>-document.getElementById("returncash").value) < 0)
	{
		alert("환불할 예치금이 <%=vCurrentDeposit%>보다 큽니다.\n<%=vCurrentDeposit%>이하로 입력해 주세요.");
		document.getElementById("returncash").value = "<%=vCurrentDeposit%>";
		document.getElementById("returncash").focus();
		return;
	}

	if(confirm("입력하신 계좌로\n예치금 반환을 신청하시겠습니까?") == true) {
		document.frmReturnToBankCash.submit();
	} else {
		return;
	}
}

function allreturn(){
	$("#returncash").val(<%=vCurrentDeposit%>);
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
        <div class="content pop-deposit">
            <div>
                <div class="total-deposit">
                    <div class="inner">
                        <h2>반환 가능한 예치금</h2>
                        <p><em><%= FormatNumber(vCurrentDeposit,0) %></em>원</p>
                    </div>
                </div>
                <form name="frmReturnToBankCash" method="post" action="/apps/appcom/wish/web2014/my10x10/deposit/depositproc.asp" style="margin:0px;">
                <input type="hidden" name="orderserial" value="">
                <div class="section return-deposit">
                    <input type="tel" class="returnDeposit" name="returncash" id="returncash" style="ime-mode:disabled;" placeholder="반환 받을 금액(원)">
                    <button class="btn btn-all" onclick="allreturn();return false;">전액</button>
                    <!--<table>
                        <caption>반환받을 금액 입력</caption>
                        <tbody>
                            <tr>
                                <th>반환 받을 금액(원)</th>
                                <td>
                                    <input type="tel" class="returnDeposit" name="returncash" id="returncash" style="width:136px;ime-mode:disabled;">
                                    <button class="btn btn-line-red btn-all" onclick="allreturn();return false;">전액</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>-->
                </div>
                <div class="account">
                    <h3>반환 받을 계좌</h2>
                    <p>입금 사고를 예방하기 위해<br/>정확한 계좌정보를 입력해주세요.</p>
                    <div class="table-wrap">
                        <table>
                            <caption>반환받을 계좌 입력</caption>
                            <tbody>
                                <tr>
                                    <th>은행 선택</th>
                                    <td>
                                        <% Call DrawBankComboForSCM("rebankname","") %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>계좌번호</th>
                                    <td><input type="tel" name="rebankaccount" style="width:216px;ime-mode:disabled;"></td>
                                </tr>
                                <tr>
                                    <th>예금주</th>
                                    <td><input type="text" class="" style="width:216px;" name="rebankownername" placeholder="예금주 (주문자와 동일해야 합니다.)" value="<%=chkiif(username<>"",username,"")%>"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                </form>
                <div class="noti"><i class="icon"></i>신청 후 약 2-3일 내 예치금 반환이 완료됩니다.</div>
                <div class="btn-wrap"><button class="btn btn-xlarge btn-submit" onclick="returnToBankCash();return false;">신청하기</button></div>
            </div>
        </div>
	</div>
</div>
</body>
</html>
<%
    Set oTenCash = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->