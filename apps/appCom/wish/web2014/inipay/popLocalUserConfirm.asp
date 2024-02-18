<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.Charset = "UTF-8"
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<%
Dim userid : userid=getEncLoginUserID
Dim empno, isIdentify, usercell
Dim smsconfirm : smsconfirm = requestCheckvar(request("smsconfirm"),10)
if Not (GetLoginUserLevel()="7" or GetLoginUserLevel()="8") then
    response.write "<script>alert('직원만 접속 가능합니다.(1)');</script>"
    dbget.close()	: response.end
end if

Dim sqlStr
sqlStr = "select A.empno, isNULL(A.isIdentify,'N') as isIdentify, isNULL(A.usercell,'') as usercell "&VbCRLF
sqlStr = sqlStr&"FROM db_partner.dbo.tbl_user_tenbyten as A "&VbCRLF
sqlStr = sqlStr&"where A.isusing=1 "&VbCRLF
sqlStr = sqlStr&"	and A.frontid='"&userid&"' "&VbCRLF
sqlStr = sqlStr&"	and (A.statediv='Y' or (A.statediv='N' and datediff(d,getdate(),A.retireday)>=0)) "
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not (rsget.EOF OR rsget.BOF) THEN
    empno = rsget("empno")
    isIdentify = rsget("isIdentify")
    usercell   = rsget("usercell")
END IF
rsget.Close()

if (empno="") then
    response.write "<script>alert('직원만 접속 가능합니다.(2)');</script>"
    dbget.close()	: response.end
end if

''인증번호 확인
if (smsconfirm<>"") then
    sqlStr = "select USBTokenSn " &VbCRLF
    sqlStr = sqlStr & " from db_log.dbo.tbl_partner_login_log " &VbCRLF
    sqlStr = sqlStr & " where userid='" & empno & "' " &VbCRLF
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
    	    response.write("fnAPPopenerJsCallClose('authPs()');")
	        response.write("</script>")
            dbget.close()	:	response.End
    	end if
    end if
    rsget.Close
end if
%>


<script language='javascript'>
function popSMSAuthNo() {
    document.getElementById("smsInput").style.display = "block";
	document.frmauth.smsconfirm.focus();
    <% if (request.ServerVariables("SERVER_PORT_SECURE")<>1) then %>
    document.hidFrm.location.href="http://<%= CHKIIF(application("Svr_Info")="Dev","test","") %>scm.10x10.co.kr/admin/member/tenbyten/do_LocalUser_SendSMS.asp?empno=<%=empno%>"+"&lstp=W";
    <% else %>
	document.hidFrm.location.href="<%= CHKIIF(application("Svr_Info")="http:","https:","") %>//<%= CHKIIF(application("Svr_Info")="Dev","test","") %>scm.10x10.co.kr/admin/member/tenbyten/do_LocalUser_SendSMS.asp?empno=<%=empno%>"+"&lstp=W";
	<% end if %>
}

function PopChgHPNum() {
    alert('본인확인을 아직 받지 않은 아이디입니다.\nn웹어드민 본인 확인 후 이용가능합니다.');
}

function confirmSMS(){
    if (document.frmauth.smsconfirm.value.length<1){
        alert('인증번호를 입력해 주세요.');
        return;
    }
    //document.frmauth.target="hidFrm";
    document.frmauth.submit();
}

function systemAlert(message) {
    alert(message);
}
window.addEventListener("message",function(event) {
    var data = event.data;
    if (typeof(window[data.action]) == "function") {
        window[data.action].call(null, data.message);
    }  
},false);
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="content" id="contentArea">
			<form name="frmauth" method="post" action="popLocalUserConfirm.asp" onsubmit="confirmSMS();return false;">
			<div class="staff-confirm">
				<div class="step1">
					<p>인증번호 발송 휴대폰 번호 : <strong><%= usercell %></strong></p>
					<a href="#" onclick="popSMSAuthNo();return false;" class="btn btn-xlarge btn-line-red btn-block">인증번호 발송</a>
				</div>
				<div class="step2" id="smsInput" style="display:<%=CHKIIF(smsconfirm<>"","","none")%>;">
					<p>
						<label for="certifyNo" class="input-label">인증번호 입력 </label>
						<input type="number" pattern="[0-9]*" inputmode="numeric" name="smsconfirm" title="인증번호를 입력해주세요." />
					</p>
					<a href="" onclick="confirmSMS();return false;" class="btn btn-xlarge btn-red btn-block">인증번호 확인</a>
				</div>
				<p class="tip"><i></i> 인증번호가 도착하지 않으면 스팸 문자함 또는<br />차단설정을 확인해주세요.</p>
			</div>
			</form>
		</div>
	</div>
</div>
<iframe id="hidFrm" name="hidFrm" frameborder="0" width="0" height="0"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->