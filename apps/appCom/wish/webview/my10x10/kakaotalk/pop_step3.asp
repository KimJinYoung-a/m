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
'	Description : 카카오톡
'	History	:  2014.01.08 한용민 모바일페이지 이동/생성
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim sflow, chkCp
	sflow	= requestCheckVar(Request.form("flow"),3)
	chkCp	= requestCheckVar(Request.form("cp"),1)
%>

<script type="text/javascript">

function doComplete() {
	self.location.href='/apps/appcom/wish/webview/my10x10/userinfo/modiUserInfo.asp';
}
	
</script>

<!-- modal#modalKakaoAuth -->
<div class="modal" id="modalKakaoAuth">
    <div class="box">
        <header class="modal-header">
            <h1 class="modal-title">카카오톡 맞춤 정보 서비스 신청</h1>
            <a href="#modalKakaoAuth" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
			<div class="iscroll-area">
	            <div class="red-box">
	                <ul class="process kakao clear">
	                    <li><span class="label">10X10 회원인증</span></li>
	                    <li><span class="label">카카오톡 회원인증</span></li>
	                    <li class="active"><span class="label">신청완료</span></li>
	                </ul>
	            </div>
	            <div class="kakao-friend">
	                <i class="icon-lock"></i>사용자 인증
	            </div>
	            <div class="t-c" style="padding:50px 0">
	                <img src="/apps/appcom/wish/webview/img/love-kakaotalk.png" alt="" width="200">
	                <p class="diff-10"></p>
	                <p class="x-large quotation" style="width:230px;">
	                    <strong>카카오톡 맞춤정보 서비스<br>신청이 완료되었습니다.</strong>
	                </p>
	                <p class="diff-10"></p>
	                <p class="small t-c">
	                    이제 카카오톡으로 텐바이텐의<br>다양하고 알찬 서비스를 만나보실 수 있습니다.
	                </p>
	            </div>
			</div>
        </div>
        <footer class="modal-footer">
            <a href="" onclick="doComplete(); return false;" class="btn type-b full-size">확인</a>
        </footer>
    </div>
</div><!-- modal#modalKakaoAuth -->

<!-- #include virtual="/lib/db/dbclose.asp" -->