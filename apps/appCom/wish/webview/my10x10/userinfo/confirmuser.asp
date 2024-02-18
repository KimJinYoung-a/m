<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : 나의정보 / 비밀번호 재확인
'	History	:  2014.03.17 허진원 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<%
dim errcode
errcode = request("errcode")

Dim vSavedID, vSavedPW
vSavedID = tenDec(request.cookies("SAVED_ID"))
vSavedPW = tenDec(request.cookies("SAVED_PW"))
%>
<script type='text/javascript'>
function TnConfirmlogin(frm){
	if (frm.userpass.value.length<1) {
		alert('패스워드를 입력하세요.');
		frm.userpass.focus();
		return false;
	}

	frm.action = '<%=M_SSLUrl%>/apps/appcom/wish/webview/my10x10/userinfo/doConfirmUserByForm.asp';
	frm.submit();
}
</script>
</head>
<body class="mypage default-font">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="modiUserInfo.asp" class="active">나의 정보 관리</a>
                <a href="modiUserPass.asp">비밀번호 변경</a>
            </div>
        </header><!-- #header -->

        <!-- #content -->
        <div id="content">
            <!-- form -->
            <form name="frmLoginConfirm" method="post" action="" onSubmit="return false;">
                <div class="inner">

                    <div class="well">회원님의 정보를 안전하게 보호하기 위해 비밀번호를 다시한번 확인합니다.</div>
            
                    <div class="input-block">
                        <label for="userid" class="input-label">아이디</label>
                        <div class="input-controls">
                            <input type="text" name="userid" id="userid" value="<%= getLoginUserID %>" class="form full-size" maxlength="32" autocomplete="off" ReadOnly />
                        </div>
                    </div>

                    <div class="input-block">
                        <label for="pwd" class="input-label">비밀번호</label>
                        <div class="input-controls">
                            <input type="password" name="userpass" id="pwd" maxlength="32" class="form full-size" onKeyPress="if (event.keyCode == 13) TnConfirmlogin(frmLoginConfirm);" />
                        </div>
                    </div>
                    <% if (errcode="1") then %><em id="lyrFailPass" class="em red">*비밀번호 오류입니다. 비밀번호를 다시 입력해주세요</em><% end if %>
                </div>

                <div class="form-actions">
                    <button onclick="TnConfirmlogin(frmLoginConfirm);" class="btn type-b full-size">LOGIN</button>
                </div>
            </form><!-- form -->
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->