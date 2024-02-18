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
'	Description : 회원가입
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->

<%
'## 로그인 여부 확인
if IsUserLoginOK then
	response.write "<script type='text/javascript'>"
	response.write "	alert('이미 회원가입이 되어있습니다.');"
	response.write "	window.location.href = 'custom://gomain.custom';"
	response.write "</script>"
	dbget.close(): response.End
end if
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">

$(document).ready(function() {
    $('#agreeAll').on('click', function(){
        if ( $(this).is(':checked') == true ) {
            $('.agree-container input[type="checkbox"]').attr('checked', true);
        } else {
            $('.agree-container input[type="checkbox"]').attr('checked', false);
        }
    });
});

function JoinAgree() {
	var frm = document.frmsocno;
	
	if(!document.getElementById("agree1").checked) { 
		alert("본인이 만14세 이상임을 확인 후 체크해주세요.");
		document.getElementById("agree1").focus();
		return;
	}
	if(!document.getElementById("agree2").checked) {
		alert("이용약관에 동의 해주세요.");
		document.getElementById("agree2").focus();
		return;
	}
	if(!document.getElementById("agree3").checked) {
		alert("개인정보를 위한 이용자 동의사항에 동의 해주세요.");
		document.getElementById("agree3").focus();
		return;
	}

	frm.target="_self";
	frm.action ="join_step2.asp";
	frm.submit();
}

function AllCheck(){
	document.getElementById("agree1").checked = true;
	document.getElementById("agree2").checked = true;
	document.getElementById("agree3").checked = true;
}

function modalTerms() {
	jsOpenModal("ajax_viewUsageTerms.asp")
}
function modalPrivacy() {
	jsOpenModal("ajax_viewPrivateTerms.asp")
}

</script>
</head>
<body class="util">
    <!-- wrapper -->
    <div class="wrapper">
        <!-- #header -->
        <header id="header">
            <h1 class="page-title">회원가입</h1>
            <ul class="process clear">
                <li class="active"><span class="label">약관동의</span></li>
                <li><span class="label">정보입력</span></li>
                <li><span class="label">본인인증</span></li>
                <li><span class="label">가입완료</span></li>
            </ul>
        </header><!-- #header -->
        <!-- #content -->
        <div id="content">
			<form name="frmsocno" method="POST" style="margin:0px;">
            <div class="inner">
                <div class="main-title">
                    <h2 class="title"><span class="label">회원가입약관</span></h2>
                </div>
                <div class="well">
                    텐바이텐 약관 내용을 확인하시고 동의여부를 결정해 주세요. 
                </div>
                
                <div class="agree-container">
                    <span class="agree-desc">본인은 만 14세 이상 고객입니다.</span>
                    <span class="agree-action">
                        <label for="agree1">
                            <input type="checkbox" class="form" id="agree1" name="agreeUseAdult" value="o">
                            동의
                        </label>
                    </span>
                </div>
                <div class="agree-container">
                    <span class="agree-desc">텐바이텐 이용약관</span>
                    <span class="agree-action">
                        <label for="agree2">
                            <a href="" onclick="modalTerms(); return false;" class="btn type-go btn-show-modal">전체보기</a>
                            <input type="checkbox" class="form" id="agree2" name="agreeUse" value="o">
                            동의
                        </label>
                    </span>
                </div>
                <div class="agree-container">
                    <span class="agree-desc">개인정보 수집 이용안내</span>
                    <span class="agree-action">
                        <label for="agree3">
                        	<a href="" onclick="modalPrivacy(); return false;" class="btn type-go btn-show-modal">전체보기</a>
                            <input type="checkbox" class="form" id="agree3" name="agreePrivate" value="o">
                            동의
                        </label>
                    </span>
                </div>
                <hr class="week">
                <label for="agreeAll">
                    <input type="checkbox" class="form" id="agreeAll">
                    약관 모두동의
                </label>
                
            </div>

            <div class="form-actions highlight">
                <button onclick="JoinAgree();" class="btn type-a full-size">다음</button>
            </div>
            </form>
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
    </div><!-- wrapper -->
	<div id="modalCont" style="display:none;"></div>    
	
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->