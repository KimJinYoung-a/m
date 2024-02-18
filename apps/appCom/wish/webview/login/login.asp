<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
response.charset = "utf-8"
%>
<%
'####################################################
' Description :  로그인
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

'if (userid<>"") then
'	response.write "<script type='text/javascript'>"
'	response.write "	alert('이미 로그인 되어있습니다.');"
'	response.write "	callmain();"
'	response.write "</script>"
'	dbget.close(): response.End
'end if

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

''안드로이드 로그인시 쿠키 날리는 이유로 파라메터로 처리(비회원 장바구니 담은 후 로그인시)
Dim gstGSSN : gstGSSN = requestCheckvar(request("gstGSSN"),32)

'로그인 회원 (웹앱에서 앱의 로그인을 호출하여 로그인한 경우 앱이 현재 페이지를 리플래시하므로 로그인 여부 확인하여 관련 페이지로 이동시킴)
if (userid<>"") then
    ''안드로이드 로그인시 쿠키 날리는 이유로 파라메터로 처리(비회원 장바구니 담은 후 로그인시)//2014/06/16
    if (gstGSSN<>"") then
        if (request.Cookies("shoppingbag")("GSSN")="") then
            response.Cookies("shoppingbag").domain = "10x10.co.kr"
            response.Cookies("shoppingbag")("GSSN") = gstGSSN
        end if
    end if
    ''----------------------
    
	if strBackPath<>"" then
		'백URL 이동
		dbget.close(): response.Redirect(strBackPath & chkIIF(strGetData<>"","?"&strGetData,""))
		response.End
	else
		'백이 없으면 앱의 메인 호출
		response.write "<script type='text/javascript'>"
		response.write "	callmain();"
		response.write "</script>"
		dbget.close(): response.End
	end if
end if

%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">

if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

function Nonmember(frm) {
	frm.action = '<%=wwwUrl%>/apps/appcom/wish/webview/inipay/nonmember.asp';
	frm.submit();
}

function NonmemberLogin(frm) {
	frm.action = '<%=wwwUrl%>/apps/appCom/wish/webview/login/login_nonmember.asp';
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
                    <h2 class="title"><span class="label">로그인</span></h2>
                </div>

                <% if vType="B" then %><p class="well">비회원 주문시 장바구니 저장, 마일리지 적립 등의 혜택을 받으실 수 없습니다. </p><% end if %>
				<form name="frmLogin4" method="post" action="" style="margin:0px;" onsubmit="return false;">
				<input type="hidden" name="backpath" value="<%=strBackPath%>">
				<input type="hidden" name="strGD" value="<%=strGetData%>">
				<input type="hidden" name="strPD" value="<%=strPostData%>">
                <div class="login-btns">
                    <a href="" onclick="return calllogin();" class="btn type-b full-size">LOGIN</a>
                    <% if vType="B" then %><a href="" onclick="Nonmember(frmLogin4); return false;" class="btn type-e full-size">비회원 장바구니 보기</a><% end if %>
                    <% if vType="G" then %><a href="" onclick="NonmemberLogin(frmLogin4); return false;" class="btn type-e full-size">비회원 로그인</a><% end if %>
                    <div class="extras">
                        <a href="/apps/appcom/wish/webview/member/pop_find_id.asp" class="pull-left btn simple small">아이디 / 비밀번호 찾기</a>
                        <a href="/apps/appcom/wish/webview/member/join.asp" class="pull-right btn type-a small" style="width:100px;">회원가입</a>
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