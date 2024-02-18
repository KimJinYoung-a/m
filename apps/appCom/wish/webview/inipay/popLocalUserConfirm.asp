<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset = "UTF-8"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim userid : userid=getEncLoginUserID
Dim partnerUserID, isIdentify, usercell
Dim smsconfirm : smsconfirm = requestCheckvar(request("smsconfirm"),10)
if Not (GetLoginUserLevel()="7") then
    response.write "<script>alert('직원만 접속 가능합니다.(1)');</script>"
    dbget.close()	: response.end
end if

Dim sqlStr
sqlStr = "select A.id, isNULL(B.isIdentify,'N') as isIdentify, isNULL(B.usercell,'') as usercell"&VbCRLF
sqlStr = sqlStr&" FROM db_partner.dbo.tbl_partner AS A "&VbCRLF
sqlStr = sqlStr&" INNER JOIN db_partner.dbo.tbl_user_tenbyten as B ON A.id = B.Userid "&VbCRLF
sqlStr = sqlStr&" where B.frontid='"&userid&"'"&VbCRLF
sqlStr = sqlStr&" and (A.userdiv<10 or A.userdiv=101 or A.userdiv=111)"
sqlStr = sqlStr&" and B.statediv='Y'"
sqlStr = sqlStr&" and B.isusing=1"

rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not (rsget.EOF OR rsget.BOF) THEN
    partnerUserID = rsget("id")
    isIdentify = rsget("isIdentify")
    usercell   = rsget("usercell")
END IF
rsget.Close()

if (partnerUserID="") then
    response.write "<script>alert('직원만 접속 가능합니다.(2)');</script>"
    dbget.close()	: response.end
end if

''인증번호 확인
if (smsconfirm<>"") then
    sqlStr = "select USBTokenSn " &VbCRLF
    sqlStr = sqlStr & " from db_log.dbo.tbl_partner_login_log " &VbCRLF
    sqlStr = sqlStr & " where userid='" & partnerUserID & "' " &VbCRLF
    sqlStr = sqlStr & " 	and loginSuccess='W' " &VbCRLF
    sqlStr = sqlStr & " 	and datediff(ss,regdate,getdate()) between 0 and 180"
    rsget.Open sqlStr,dbget,1
    if rsget.EOF or rsget.BOF  then
    	response.write("<script>window.alert('입력 제한시간이 초과되었습니다.\n다시 인증번호를 발급받아 입력해주세요.');location.href='/inipay/popLocalUserConfirm.asp';</script>")
    	dbget.close()	:	response.End
    else
    	if trim(rsget("USBTokenSn"))<>trim(smsconfirm) then
    		response.write("<script>window.alert('휴대폰으로 발송된 인증번호값이 아닙니다.\n정확히 입력해주세요.');</script>")
    	else
    	    '' OK
    	    session("tnsmsok")="ok"
    	    response.write("<script>")
    	    response.write("parent.authPs();")
	        response.write("</script>")
            dbget.close()	:	response.End
    	end if
    end if
    rsget.Close
end if
%>


<script language='javascript'>
function popSMSAuthNo() {
    <% if (request.ServerVariables("SERVER_PORT_SECURE")<>1) then %>
    document.hidFrm.location.href="http://<%= CHKIIF(application("Svr_Info")="Dev","test","") %>scm.10x10.co.kr/admin/member/tenbyten/iframe_adminLogin_SendSMS.asp?uid=<%=partnerUserID%>"+"&lstp=W";
    <% else %>
	document.hidFrm.location.href="<%= CHKIIF(application("Svr_Info")="http:","https:","") %>//<%= CHKIIF(application("Svr_Info")="Dev","test","") %>scm.10x10.co.kr/admin/member/tenbyten/iframe_adminLogin_SendSMS.asp?uid=<%=partnerUserID%>"+"&lstp=W";
	<% end if %>
	document.getElementById("smsInput").style.display = "block";
	document.frmauth.smsconfirm.focus();
}

function PopChgHPNum() {
    alert('본인확인을 아직 받지 않은 아이디입니다.\nSCM 본인 확인 후 이용가능합니다.');
}

function confirmSMS(){
    if (document.frmauth.smsconfirm.value.length<1){
        alert('인증번호를 입력해 주세요.');
        return;
    }
    document.frmauth.target="hidFrm";
    document.frmauth.submit();

}
</script>
<link rel="stylesheet" type="text/css" href="../css/style.css">
<div class="modal" id="modalEMSChart">
    <div class="box">
        <header class="modal-header">
            <h1 class="modal-title">직원 SMS 인증</h1>
            <a href="#modalEMSChart" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
            <div class="inner">
								<div class="cong-info">
										<form name="frmauth" method="post" action="popLocalUserConfirm.asp" onsubmit="confirmSMS();return false;">
										<h2 class="diff-10">인증번호 발송 휴대폰 번호 : <strong><span class="red"><%= usercell %></span></strong></h2>
										<p class="diff"><a href="#" onclick="popSMSAuthNo();return false;" class="btn type-e">인증번호 발송</a></p>
										<div class="input-block center" id="smsInput" style="width:60%; height:auto; display:<%=CHKIIF(smsconfirm<>"","","none")%>;">
												<div class="diff-10">
														<span><label for="certifyNo" class="input-label">인증번호 입력 </label></span>
														<div class="input-controls">
															<div><span><input type="text" name="smsconfirm" style="width:90%" title="인증번호를 입력해주세요." class="form" /></span></div>
														</div>
												</div>
												<p class="diff"><a href="" onclick="confirmSMS();return false;" class="btn type-c">인증번호 확인</a></p>
										</div>
										<p>인증번호가 도착하지 않으면 스팸 문자함 또는<br />차단설정을 확인해주세요.</p>
										</form>
								</div>
            </div>
        </div>
    </div>
</div>
<iframe id="hidFrm" name="hidFrm" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->