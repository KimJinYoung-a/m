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
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=1.00"></script>
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

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
<script type="text/javascript">

if(!navigator.cookieEnabled) alert("쿠키를 허용해주세요.\n쿠키가 허용되어야 로그인을 하실 수 있습니다.");

function Nonmember(frm) {
	//frm.action = '<%=wwwUrl%>/apps/appCom/wish/web2014/inipay/nonmember.asp';
	frm.action = '/login/dobagunilogin.asp';
	frm.chkAgree.value="Y";
	frm.submit();
}

function NonmemberLogin(frm) {
	frm.action = '<%=wwwUrl%>/apps/appCom/wish/web2014/login/login_nonmember.asp';
	frm.submit();
}

function popFindIDPW() {
	fnAPPpopupBrowserURL("아이디/비밀번호 찾기","<%=wwwUrl%>/apps/appCom/wish/web2014/member/find_idpw.asp?t=id");
}

function popMemJoin() {
	fnAPPpopupBrowserURL("회원가입","<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp");
}
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<% response.write fnTestLoginLabel() '//  app 쿠키 테스트용 %>
            <div class="login inner10">
                <% if vType="B" then %><p>비회원 주문시 장바구니 저장, 마일리지 적립 등의 혜택을 받으실 수 없습니다. </p><% end if %>
				<form name="frmLogin4" method="post" action="" style="margin:0px;" onsubmit="return false;">
				<input type="hidden" name="backpath" value="<%=strBackPath%>">
				<input type="hidden" name="strGD" value="<%=strGetData%>">
				<input type="hidden" name="strPD" value="<%=strPostData%>">
				<input type="hidden" name="chkAgree" value="N" />
                <div class="box1 inner10 tMar10">
                	<p><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="calllogin(); return false;">로그인</a></span></p>
                    <% if vType="B" then %><p class="tMar10"><span class="button btB1 btRedBdr cRd1 w100p"><a href="" onclick="Nonmember(frmLogin4); return false;">비회원 구매하기</a></span></p><% end if %>
                    <% if vType="G" then %><p class="tMar10"><span class="button btB1 btRedBdr cRd1 w100p"><a href="" onclick="NonmemberLogin(frmLogin4); return false;">비회원 로그인</a></span></p><% end if %>
                    <div class="loginGuide tMar20">
						<p class="ftLt tMar10 txtLine"><a href="" onclick="popFindIDPW(); return false;"><strong>아이디/비밀번호 찾기</strong></a></p>
						<p class="ftRt"><span class="button btM2 btGry2 cWh1"><a href="" onclick="popMemJoin(); return false;">회원가입</a></span></p>
                    </div>
                </div>
                </form>
            </div>
        </div><!-- #content -->
    </div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->