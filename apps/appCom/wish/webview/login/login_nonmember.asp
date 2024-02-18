<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
response.charset = "utf-8"
%>
<%
'####################################################
' Description :  비회원 로그인
'	History	:  2014.01.08 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->

<%
dim userid
	userid = GetLoginUserID

if (userid<>"") then
	response.write "<script type='text/javascript'>"
	response.write "	alert('이미 로그인 되어있습니다.');"
	response.write "</script>"
	dbget.close(): response.End
end if

''vType : G : 비회원 로그인포함, B : 장바구니 비회원주문 포함.
dim vType, vLoginFail
	vType = requestCheckVar(request("vType"),1)
	vLoginFail = requestCheckVar(request("loginfail"),1)

dim strBackPath, strGetData, strPostData
	strBackPath = ReplaceRequestSpecialChar(request("backpath"))
	strBackPath = Replace(strBackPath,"^^","&")
	strGetData  = ReplaceRequestSpecialChar(request("strGD"))
	strPostData = ReplaceRequestSpecialChar(request("strPD"))

Dim vSavedAuto, vSavedID, vSavedPW
	vSavedAuto = request.cookies("mSave")("SAVED_AUTO")
	vSavedID = tenDec(request.cookies("mSave")("SAVED_ID"))
	vSavedPW = tenDec(request.cookies("mSave")("SAVED_PW"))
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">

	if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

	function TnDoGuestLogin(frm){
	    if (frm.orderserial.value.length<1) {
	    	alert('주문번호를 입력하세요.');
	    	frm.orderserial.focus();
	    	return;
	    }
	    if (frm.buyemail.value.length<1) {
	    	alert('구매자 이메일을 입력하세요.');
	    	frm.buyemail.focus();
	    	return;
	    }
	
	    frm.action = '<%=wwwUrl%>/apps/appcom/wish/webview/login/doguestlogin.asp';
	    frm.submit();
	}

</script>
</head>
<body class="util">
    <!-- wrapper -->
    <div class="wrapper">
        <!-- #content -->
        <div id="content">
            <div class="inner login">
                <div class="main-title">
                    <h2 class="title"><span class="label">비회원로그인</span></h2>
                </div>
                <p class="well">주문번호와 구매시 입력하셨던 이메일로 로그인하셔서 주문하신 상품조회 및 배송조회를 하실 수 있습니다. </p>
                <div class="diff"></div>
					<form name="frmLoginGuest" method="post" action="" style="margin:0px;" onsubmit="return false;">
					<input type="hidden" name="backpath" value="<%=strBackPath%>">
					<input type="hidden" name="strGD" value="<%=strGetData%>">
					<input type="hidden" name="strPD" value="<%=strPostData%>">
                    <div class="input-block">
                        <label for="orderNo" class="input-label">주문번호</label>
                        <div class="input-controls">
                            <input type="text" name="orderserial" maxlength="11" autocomplete="off" onKeyPress="if (event.keyCode == 13) frmLoginGuest.buyemail.focus();" id="orderNo" class="form full-size">
                        </div>
                    </div>
                    <div class="input-block">
                        <label for="email" class="input-label">구매자 이메일</label>
                        <div class="input-controls">
                            <input type="email" name="buyemail" onKeyPress="if (event.keyCode == 13) TnDoGuestLogin(frmLoginGuest);" maxlength="128" autocomplete="off" id="email" class="form full-size">
                        </div>
                    </div>
                    <div class="diff-10"></div>
                    <div class="two-btns">
                        <div class="col">
                            <a href="" onclick="TnDoGuestLogin(frmLoginGuest); return false;" class="btn type-b">LOGIN</a>
                        </div>
                        <div class="col">
                            <a href="/apps/appcom/wish/webview/member/join.asp" class="btn type-a">회원가입</a>
                        </div>
                    </div>
					</form>
            </div>
        </div><!-- #content -->
        <!-- #footer -->
        <footer id="footer">
        </footer><!-- #footer -->
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->