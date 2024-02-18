<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
Dim oUserInfo
Dim chkid, chklevel, i, j, iHVol, HHVol, evtID
chkid = GetLoginUserID
chklevel =  GetLoginUserLevel
HHVol = ""

rsget.open "select top 1 * from db_event.dbo.tbl_vip_hitchhiker where isusing= 'Y' and getdate()>startdate and getdate() <= enddate",dbget,1
If not rsget.eof Then
	evtID = rsget("mevt_code")
	iHVol = rsget("Hvol")
Else
	evtID = ""
	iHVol = "44"
End If
rsget.close

If IsUserLoginOK = False Then
	response.write "<script>alert('로그인이 필요한 서비스입니다.');top.location.href='"&M_SSLUrl&"/login/login.asp?backpath=/event/eventmain.asp?eventid="&evtID&"';</script>"
	response.end
End If

IF (chklevel <> 3 and chklevel <> 4 and chkid <> "kjy8517" and chkid <> "dream1103" and chkid <> "kobula" and chkid <> "star088" And chkid <> "motions" and chkid <> "okkang77" ) THEN
	response.write "<script>alert('마이텐바이텐의 회원등급을 확인해주세요!');top.location.href='"&wwwURL&"';</script>"
	response.end
END IF

rsget.open "select top 1 * from [db_user].[dbo].[tbl_user_hitchhiker] where HVol = '"&iHVol&"' and userid = '"&chkid&"'",dbget,1
If not rsget.eof Then
	HHVol = rsget("Hvol")
Else
	HHVol = ""
End If
rsget.close

If HHVol <> "" Then
	response.write "<script>alert('고객님께서는 이미 히치하이커를 신청하셨습니다.\n배송지 수정을 원하실 경우 고객센터로 문의 바랍니다.');top.location.href='"&wwwURL&"';</script>"
	response.End
End If

If evtID="" and chkid <> "kjy8517" and chkid <> "dream1103" and chkid <> "kobula" and chkid <> "star088" And chkid <> "motions" and chkid <> "okkang77" Then
	response.write "<script>alert('지금은 주소 입력 기간이 아닙니다.');top.location.href='"&wwwURL&"';</script>"
	response.End
End If

Set oUserInfo = new CUserInfo
	oUserInfo.FRectUserID = chkid
If (chkid<>"") Then
    oUserInfo.GetUserData
End If
%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > HITCHHIKER vol.44 VIP 주소확인</title>
	<style type="text/css">
	.mHitchhikerVip {}
	.mHitchhikerVip .ftLt {float:left;}
	.mHitchhikerVip img {vertical-align:top;}
	.mHitchhikerVip .adrInput {background:#eee; padding:30px 20px;}
	.mHitchhikerVip .adrInput .textInput {border:none; padding:2px 5px; margin:0; height:18px; color:#888; line-height:16px; /*-webkit-border-radius:0;-webkit-appearance:none;*/}
	.mHitchhikerVip .adrInput .btnPost {vertical-align:middle; height:22px; -webkit-border-radius:0;-webkit-appearance:none;}
	.mHitchhikerVip .adrInput dl {border-bottom:1px solid #fff; padding:0.5em 0; color:#555;}
	.mHitchhikerVip .adrInput dl dt {font-size:12px;}
	.mHitchhikerVip .adrInput dl dt, .adrInput dl dd {padding:0.2em 0.5em;}
	.mHitchhikerVip .adrInput .contTit {overflow:hidden; _zoom:1; background:url("http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_addr_line.gif") left bottom no-repeat; padding-bottom:6px;}
	.mHitchhikerVip .adrInput .adrSelect {float:right; list-style:none;}
	.mHitchhikerVip .adrInput .adrSelect li {float:left; padding:0 5px 0 7px; font-size:0.75em;}
	.mHitchhikerVip .adrInput .adrSelect li input {width:17px; height:17px;}

	.mHitchhikerVip .hitchNotice {padding:20px 10px; border-bottom:2px solid #ddd; background:#f9f9f9;}
	.mHitchhikerVip .hitchNotice li {padding-left:10px; font-size:11px; line-height:17px; letter-spacing:-0.05em; color:#333; background:url("http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_blt_arrow.png") left 5px no-repeat; background-size:5px 6px;}
	.mHitchhikerVip .hitchNotice li li {padding-left:0; background:none;}
</style>
<script language="javascript">
function clearFields() {
    var frm = document.getElementById('frminfo');
    var em = frm.elements;
    //frm.reset();
    for(var i=0; i<em.length; i++) {
        if(em[i].type == 'text') em[i].value = '';
        if(em[i].type == 'tel') em[i].value = '';
        if(em[i].type == 'checkbox') em[i].checked = false;
       // if(em[i].type == 'radio') em[i].checked = false;
        if(em[i].type == 'select-one') em[i].options[0].selected = true;
        if(em[i].type == 'textarea') em[i].value = '';
    }
    return;
}
function defaultAddr(){
	var frm = document.frminfo;
	frm.username.value = "<%=GetLoginUserName%>";

	frm.txZip1.value = "<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>"
	frm.txZip2.value = "<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>"
	frm.txAddr1.value = "<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"
	frm.txAddr2.value = "<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"

	frm.userphone1.value = "<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) %>"
	frm.userphone2.value = "<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) %>"
	frm.userphone3.value = "<%= Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) %>"

	frm.usercell1.value = "<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>"
	frm.usercell2.value = "<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>"
	frm.usercell3.value = "<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>"
}
function jsSubmit(frm){
	if (frm.username.value == ''){
		alert('이름을 입력해 주세요.');
		frm.username.focus();
		return;
	}
	// 주소, 전화번호, 핸드폰 필수 정보입력
	if (frm.txZip2.value.length<3){
		alert('우편번호를 입력해 주세요.');
		frm.txZip2.focus();
		return;
	}

	if (frm.txAddr2.value.length<1){
		alert('나머지 주소를 입력해 주세요.');
		frm.txAddr2.focus();
		return;
	}

	if (frm.userphone1.value.length<2){
		alert('전화번호1을 입력해 주세요.');
		frm.userphone1.focus();
		return;
	}

	if (frm.userphone2.value.length<2){
		alert('전화번호2을 입력해 주세요.');
		frm.userphone2.focus();
		return;
	}

	if (frm.userphone3.value.length<2){
		alert('전화번호3을 입력해 주세요.');
		frm.userphone3.focus();
		return;
	}

	if (frm.usercell1.value.length<2){
		alert('핸드폰번호1을 입력해 주세요.');
		frm.usercell1.focus();
		return;
	}

	if (frm.usercell2.value.length<2){
		alert('핸드폰번호2을 입력해 주세요.');
		frm.usercell2.focus();
		return;
	}

	if (frm.usercell3.value.length<2){
		alert('핸드폰번호3을 입력해 주세요.');
		frm.usercell3.focus();
		return;
	}
	frm.submit();
}
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
	<form name="frminfo" id="frminfo"  method="post" action="processhitchreceive.asp" style="margin:0px;">
	<input type="hidden" name="chkid" value="<%=chkid%>">
	<input type="hidden" name="chklevel" value="<%=chklevel%>">
	<input type="hidden" name="iHVol" value="<%=iHVol%>">
				<div class="mHitchhikerVip">
					<p><img src="http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_head_vol44.png" alt="텐바이텐 VIP고객님께 HITCHHIKER vol.44를 선물합니다!" style="width:100%;" /></p>
					<p><img src="http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_txt01.png" alt="히치하이커는 격월간으로 발행되는 텐바이텐의 감성매거진입니다." style="width:100%;" /></p>
					<div class="adrInput">
						<div class="contTit">
							<p class="ftLt"><img src="http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_addr_tit.png" alt="주소입력" style="width:80px;" /></p>
							<ul class="adrSelect">
								<li><input type="radio" name="r1" onclick="javascript:defaultAddr();" id="add01" /> <label for="add01">기본 배송지 주소</label></li>
								<li><input type="radio" name="r1" onclick="javascript:clearFields();" id="add02" /> <label for="add02">새로운 주소</label></li>
							</ul>
						</div>
						<dl style="overflow:hidden;">
							<dt style="float:left; padding-top:7px;">아이디</dt>
							<dd style="float:left;"><span style="color:#000; font-weight:bold; font-size:11px;"><%=chkid%></span></dd>
						</dl>
						<dl>
							<dt><label for="hName">이름</label></dt>
							<dd><input type="text" class="textInput" id="hName" name="username" style="width:130px;" title="배송받으시는 분의 이름을 입력해주세요." /></dd>
						</dl>
						<dl>
							<dt><label for="hAdd">주소</label></dt>
							<dd>
								<p><input type="tel" class="textInput" name="txZip1" readOnly id="hAdd" style="width:25%;" title="우편번호찾기 버튼을 클릭해 주세요." /> - <input type="tel" class="textInput" name="txZip2" readOnly style="width:25%;" title="우편번호찾기 버튼을 클릭해 주세요." /><a href="javascript:TnFindZip('frminfo');" onFocus="blur();"><img src="http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_addr_btn_zipcode.png" alt="우편번호찾기" class="btnPost" /></a></p>
								<p style="padding-top:10px;"><input type="text" name="txAddr1" readOnly class="textInput" style="width:99%;" title="배송받으시는 곳의 주소 앞부분이 입력됩니다." /></p>
								<p style="padding-top:10px;"><input type="text" name="txAddr2" class="textInput" style="width:99%;" title="배송받으시는 곳의 상세주소를 입력해주세요." /></p>
								<p style="padding-top:10px; font-size:11px">택배가 아닌 우편으로 발송되기 때문에 번지/동/호수 등 상세주소를 정확히 입력해주시기 바랍니다.</p>
							</dd>
						</dl>
						<dl>
							<dt><label for="hTel">전화번호</label></dt>
							<dd><input type="tel" name="userphone1" maxlength="3"  class="textInput" id="hTel" style="width:28%;" title="전화번호 국번을 입력해주세요." /> <input type="tel" name="userphone2" maxlength="4"  class="textInput" style="width:28%;" title="전화번호 앞자리를 입력해주세요." /> <input type="tel" name="userphone3" maxlength="4"  class="textInput" style="width:28%;" title="전화번호 뒷자리를 입력해주세요." /></dd>
						</dl>
						<dl>
							<dt><label for="hPhone">휴대전화</label></dt>
							<dd><input type="tel" name="usercell1" maxlength="3" class="textInput" id="hPhone" style="width:28%;" title="휴대전화번호 시작번호를 입력해주세요." /> <input type="tel" name="usercell2" maxlength="4" class="textInput" style="width:28%;" title="휴대전화번호 앞자리를 입력해주세요." /> <input type="tel" name="usercell3" maxlength="4" class="textInput" style="width:28%;" title="휴대전화번호 뒷자리를 입력해주세요." /></dd>
						</dl>
						<p class="ct" style="margin-top:25px;"><a href="javascript:jsSubmit(document.frminfo);"><img src="http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_addr_btn_ok.png" alt="확인" style="width:130px;" /></a></p>
					</div>
					<div class="hitchNotice">
						<ul>
							<li>기본 회원정보와 주소가 동일하더라도 기간 내에 배송지 입력 및 확인 절차를 거쳐야 정상 발송됩니다.</li>
							<li>배송지 입력 일시에 따라 일괄 우편 발송일이 달라지며, 총 4차로 나눠 발송됩니다.</li>
							<li>우편으로 발송되기 때문에 고객님께서 수령하시기까지는 발송일 기준으로 최대 1주일 가량 소요됩니다.</li>
							<li style="margin-top:12px;"><strong>주소 입력 기간 및 일괄 발송일 안내</strong>
								<ol>
									<li>1차 : 2014.03.03(월) ~ 2014.03.09(일) / 발송일 : 2014.03.20(목)</li>
									<li>2차 : 2014.03.10(월) ~ 2014.03.16(일) / 발송일 : 2014.03.26(수)</li>
									<li>3차 : 2014.03.17(월) ~ 2014.03.23(일) / 발송일 : 2014.04.02(수)</li>
									<li>4차 : 2014.03.24(월) ~ 2014.03.30(일) / 발송일 : 2014.04.08(화)</li>
								</ol>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<!-- //content area -->
	</form>
</body>
</html>
<%
set oUserInfo = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->