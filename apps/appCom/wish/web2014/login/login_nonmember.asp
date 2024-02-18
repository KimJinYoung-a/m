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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
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

    frm.action = '<%=wwwUrl%>/apps/appCom/wish/web2014/login/doguestlogin.asp';
    frm.submit();
}

function popFindIDPW(gb) {
	fnAPPpopupBrowserURL("아이디/비밀번호 찾기","<%=wwwUrl%>/apps/appCom/wish/web2014/member/find_idpw.asp?t="+gb);
}

function popMemJoin() {
	fnAPPpopupBrowserURL("회원가입","<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp");
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
            <div class="login-form">
                <form name="frmLoginGuest" method="post" action="" style="margin:0px;" onsubmit="return false;">
                <input type="hidden" name="backpath" value="<%=strBackPath%>">
                <input type="hidden" name="strGD" value="<%=strGetData%>">
                <input type="hidden" name="strPD" value="<%=strPostData%>">
                    <fieldset>
                    <legend class="hidden">비회원 로그인 폼</legend>
                        <div class="form-group">
                            <input type="number" name="orderserial" autocorrect="off" autocapitalize="off"  maxlength="11" onKeyPress="if (event.keyCode == 13) frmLoginGuest.buyemail.focus();" id="orderno" required />
                            <label for="orderno">주문번호</label>
                        </div>
                        <div class="form-group">
                            <input type="email" id="email" autocorrect="off" autocapitalize="off"  name="buyemail" onKeyPress="if (event.keyCode == 13) TnDoGuestLogin(frmLoginGuest);" maxlength="128" required />
                            <label for="email">주문고객 이메일</label>
                        </div>
                        <div class="btn-group">
                            <input type="submit" value="비회원 로그인" onclick="TnDoGuestLogin(frmLoginGuest); return false;" class="btn btn-red btn-xlarge btn-block" />
                        </div>
                    </fieldset>
                </form>
            </div>

            <div class="login-utility">
                <div class="utility-link">
                    <a href="" onclick="popMemJoin(); return false;">회원가입</a>
                    <a href="" onclick="popFindIDPW('id'); return false;">아이디/비밀번호 찾기</a>
                </div>
            </div>
        </div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->