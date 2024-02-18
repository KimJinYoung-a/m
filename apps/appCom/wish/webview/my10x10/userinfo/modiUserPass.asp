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
'	Description : 나의정보
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, userpass, myUserInfo, chkKakao
	userid = getEncLoginUserID

chkKakao = false

set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid
	
	if (userid<>"") then
	    myUserInfo.GetUserData 
	    chkKakao = myUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
	end if

if (myUserInfo.FResultCount<1) then
    response.write "<script>alert('정보를 가져올 수 없습니다.');</script>"
    response.end
end if
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script language='javascript'>

	function ChangeMyPass(frm){
		if (frm.oldpass.value.length<1){
			alert('기존 비밀번호를 입력하세요.');
			frm.oldpass.focus();
			return;
		}

		if (frm.newpass1.value.length<8){
			alert('새로운 비밀번호는 8자 이상으로 입력하세요.');
			frm.newpass1.focus();
			return;
		}

		if (frm.newpass1.value=='<%=userid%>'){
			alert('아이디와 동일한 비밀번호는 사용하실 수 없습니다.');
			frm.newpass1.focus();
			return;
		}
	
		if (!fnChkComplexPassword(frm.newpass1.value)) {
			alert('새로운 비밀번호는 영문/숫자 등 두가지 이상의 조합으로 입력하세요.');
			frm.newpass1.focus();
			return;
		}

		if (frm.newpass1.value!=frm.newpass2.value){
			alert('새로운 비밀번호가 일치하지 않습니다.');
			frm.newpass1.focus();
			return;
		}

		var ret = confirm('비밀번호를 수정하시겠습니까?');

		if(ret){
			frm.submit();
		}
	}

</script>

</head>
<body class="mypage default-font">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #header -->
        <header id="header">
            <div class="tabs type-c">
                <a href="modiUserInfo.asp">나의 정보 관리</a>
                <a href="modiUserPass.asp" class="active">비밀번호 변경</a>
            </div>
        </header><!-- #header -->
        <!-- #content -->
        <div id="content">
			<form name="frmpass" method="post" action="<%=M_SSLUrl%>/apps/appcom/wish/webview/my10x10/userinfo/membermodify_process.asp" style="margin:0px;" onsubmit="return false;">
			<input type="hidden" name="mode" value="passmodi">
            <div class="inner">
                <div class="main-title">
                    <h1 class="title"><span class="label">비밀번호 수정</span></h1>
                </div>
                <div class="input-block">
                    <label for="pwd" class="input-label">현재 비밀번호</label>
                    <div class="input-controls">
                        <input type="password" name="oldpass" onKeyPress="if (event.keyCode == 13) ChangeMyPass(frmpass);" id="pwd" class="form full-size">
                    </div>
                </div>
                <div class="input-block">
                    <label for="newPwd" class="input-label">신규 비밀번호</label>
                    <div class="input-controls">
                        <input type="password" name="newpass1" onKeyPress="if (event.keyCode == 13) ChangeMyPass(frmpass);" id="newPwd" class="form full-size">
                    </div>
                </div>
                <div class="input-block">
                    <label for="rePwd" class="input-label">비밀번호 재확인</label>
                    <div class="input-controls">
                        <input type="password" name="newpass2" onKeyPress="if (event.keyCode == 13) ChangeMyPass(frmpass);" id="rePwd" class="form full-size">
                    </div>
                </div>
                <em class="em red">* 비밀번호는 공백없는 8~16자의 영문/숫자 등 두 가지 이상의 조합으로 입력해주세요,</em>
            </div>
            <div class="form-actions highlight">
                <button onclick="ChangeMyPass(document.frmpass);" class="btn type-a full-size">비밀번호 변경</button>
            </div>
            </form>
        </div><!-- #content -->
        <!-- #footer -->
        <footer id="footer">
        </footer><!-- #footer -->
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<%
set myUserInfo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->