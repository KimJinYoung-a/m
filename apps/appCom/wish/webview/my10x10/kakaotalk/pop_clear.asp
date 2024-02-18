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
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim userid, username, usrHp
	userid = GetLoginUserID
	username = GetLoginUserName

dim myUserInfo, chkKakao
	chkKakao = false
	
set myUserInfo = new CUserInfo
	myUserInfo.FRectUserID = userid
	
	if (userid<>"") then
	    myUserInfo.GetUserData
	    chkKakao = myUserInfo.chkKakaoAuthUser	'// 카카오톡 인증여부
	    usrHp = myUserInfo.FOneItem.Fusercell
	end if
set myUserInfo = Nothing

if Not(chkKakao) then
	response.write "<script language='text/javascript'>"
	response.write "	alert('카카오톡 서비스가 신청되어있지 않습니다.');"
	response.write "</script>"
	dbget.close()	:	Response.End
end if
%>

<script type="text/javascript">

	function chkForm() {
		var frm = document.frm;

		if(confirm("카카오톡 서비스를 해제하시겠습니까?")) {
			var rstStr = $.ajax({
				type: "POST",
				url: "/apps/appCom/wish/webview/my10x10/kakaotalk/ajax_kakaoTalk_proc.asp",
				data: "mode=clear",
				dataType: "text",
				async: false
			}).responseText;
			$("#modalCont").empty().append(rstStr);
			$("#modalCont").fadeIn();
			$('body').css({'overflow':'hidden'});

			if (rstStr == "2"){
				alert('회원님은 텐바이텐의 카카오톡 맞춤정보 서비스가 신청되어있지 않습니다.');
				return false;
			}else if (rstStr == "3"){
				alert('카카오톡 서비스를 이용하고 계시지 않습니다.');
				return false;			
			}else if (rstStr == "1"){
				alert('카카오톡 맞춤정보 서비스가 해제되었습니다.');
				parent.document.location.href='/apps/appcom/wish/webview/my10x10/userinfo/modiUserInfo.asp';
				return false;
			}else{
				alert(rstStr);
				//alert('오류가 발생했습니다.');
				return false;
			}
			
			//$("#modalCont").fadeOut();
			//$('body').css({'overflow':'auto'});
		}
	}

</script>

<!-- modal#modalKakaoCancel -->
<div class="modal" id="modalKakaoCancel">
	<form name="frm" method="POST" style="margin:0px;" onsubmit="return false;">
	<input type="hidden" name="mode" value="clear">
    <div class="box">
        <header class="modal-header">
            <h1 class="modal-title">카카오톡 서비스 해제</h1>
            <a href="#modalKakaoCancel" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
            <div class="iscroll-area">
	            <div class="kakao-friend">
	                <i class="icon-lock"></i>사용자 인증
	            </div>
	            <div class="diff"></div>
	            <div class="inner">
	                <p class="t-c">
	                    카카오톡 맞춤정보 서비스를 해제합니다.<br>서비스를 해제하시면, <br>카카오톡 맞춤정보 서비스를 받을 수 없게 됩니다.<br> 단, 서비스 해제시에도 상품 주문 및 배송 관련 정보는 <br>정보수신 동의와 별도로 SMS 로 자동 발송됩니다. 
	                    <br><br>
	                    
	                    * 서비스 해제할 휴대폰 번호는 아래와 같습니다. <br>
	                    <strong class="red" style="font-size:12px;margin-top:5px; display:block;"><%=usrHp%></strong>
	                </p>
	            </div>
			</div>
        </div>
        <footer class="modal-footer">
            <button onclick="chkForm();" class="btn type-b full-size">서비스 해제</button>
        </footer>
    </div>
    </form>
</div><!-- modal#modalKakaoCancel -->

<!-- #include virtual="/lib/db/dbclose.asp" -->