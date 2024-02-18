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
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim errcode, vSavedID, vSavedPW, strTarget
	errcode = request("errcode")
	vSavedID = tenDec(request.cookies("SAVED_ID"))
	vSavedPW = tenDec(request.cookies("SAVED_PW"))
	strTarget	= requestCheckVar(Request("target"),32)
%>

<script type='text/javascript'>

function TnConfirmlogin(frm,t){
	var frmp = eval("parent." + t);
	
	if (frm.userpass.value.length<1) {
		alert('패스워드를 입력하세요.');
		frm.userpass.focus();
		return false;
	}

	var rstStr = $.ajax({
		type: "POST",
		url: "/apps/appCom/wish/web2014/my10x10/userinfo/doConfirmUser.asp",
		data: "userpass="+frm.userpass.value,
		dataType: "text",
		async: false
	}).responseText;

	if (rstStr == "ERR"){
		alert('오류가 발생했습니다.');
		return false;
	}else if (rstStr == "2"){
		alert('패스워드를 다시 입력해주세요.');
		return false;
	}else if (rstStr == "3"){
		alert('패스워드가 틀렸습니다. 다시 입력해주세요.');
		return false;
	}else if (rstStr == "4"){
		alert('업체 및 기타권한은 이곳에서 수정하실 수 없습니다.');
		return false;
	}else if (rstStr == "1"){
		frmp.oldpass.value=frm.userpass.value
		parent.ChangeMyInfo(document.frminfo)
		return false;
	}else if (rstStr == "9"){
		alert('로그인을 해주세요.');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

</script>

<!-- modal#modalReaffirmationPassword  -->
<div class="modal popup" id="modalReaffirmationPassword">
    <div class="box" style="top:50%;margin-top:-120px;">
        <header class="modal-header">
            <h1 class="modal-title">비밀번호 재확인</h1>
            <a href="" onclick="fnAPPclosePopup();" class="btn-close">&times;</a>
        </header>
		<form name="frmLoginConfirm" method="post" action="" onSubmit="return TnConfirmlogin(this,'<%= strTarget %>');">
        <div class="modal-body">
            <div class="inner">
                <p class="t-c">정보를 수정하시려면 <strong>현재 비밀번호</strong>를<br>다시 한번 입력하시기 바랍니다. </p>
                <div class="diff-10"></div>
                <div class="input-block">
                    <label for="pwd" class="input-label">비밀번호</label>
                    <div class="input-controls">
                        <input type="password" name="userpass" maxlength="32" onKeyPress="if (event.keyCode == 13) TnConfirmlogin(frmLoginConfirm,'<%= strTarget %>');" id="pwd" class="form full-size">
                    </div>
                </div>
                <div class="diff-10"></div>
            </div>
        </div>
        </form>
        <footer class="modal-footer t-c">
            <button onclick="TnConfirmlogin(frmLoginConfirm,'<%= strTarget %>')" class="btn type-a full-size">확인</button>
        </footer>
    </div>
</div><!-- modal#modalReaffirmationPassword  -->

<!-- #include virtual="/lib/db/dbclose.asp" -->