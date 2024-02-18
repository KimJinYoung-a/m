<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/MD5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<% If isApp = 1 Then %>
<!-- #include virtual="/lib/inc/head.asp" -->
<% End If %>
<style type="text/css">
.mHitchhikerVip .topic {padding:3.41rem 0 3.07rem; text-align:center; color:#000; border:0.85rem solid #eee; background:#fff url("http://fiximage.10x10.co.kr/m/2018/hitchhiker/bg_hitchhiker_vip.png") 0 100% no-repeat; background-size:100% auto;}
.mHitchhikerVip .topic h2 {font-size:2.56rem; line-height:1.2; letter-spacing:-0.08rem;}
.mHitchhikerVip .topic h2 strong {font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
.mHitchhikerVip .topic p {padding:0.85rem 0 2.56rem;font-size:1.2rem; line-height:1.29;}
.mHitchhikerVip .topic em {font-size:1.37rem; line-height:1.25; font-weight:bold;}

.mHitchhikerVip .adrInput {padding:0.5rem 1.71rem 2.56rem; background:#eee;}
.mHitchhikerVip .adrInput .contTit {position:relative;}
.mHitchhikerVip .adrInput .contTit p {display:inline-block; margin-bottom:-1px; padding:0 0.5rem; border-bottom:1px solid #000; font-size:1.28rem; line-height:1.6; font-weight:bold;}
.mHitchhikerVip .adrInput .adrSelect {position:absolute; top:0; right:0; padding-bottom:6px; list-style:none;}
.mHitchhikerVip .adrInput .adrSelect li {float:left; padding:0 5px 0 7px; font-size:0.75em;}

.mHitchhikerVip .adrInput .textInput {color:#888;}
.mHitchhikerVip .adrInput .btnPost {vertical-align:middle; height:22px; -webkit-border-radius:0;-webkit-appearance:none;}
.mHitchhikerVip .adrInput dl {overflow:hidden; padding:1rem 0; font-size:1.1rem; border-top:1px solid #fff; color:#555;}
.mHitchhikerVip .adrInput dl dt {font-weight:600;}
.mHitchhikerVip .adrInput dl dt label {display:inline-block; padding-bottom:0.5rem;}
.mHitchhikerVip .adrInput p {line-height:1.375em;}

.mHitchhikerVip .hitchNotice {padding:1.71rem; border-bottom:.2rem solid #ddd; background:#f9f9f9;}
.mHitchhikerVip .hitchNotice li {margin-top:0.3rem; padding-left:0.85rem; line-height:1.3; color:#333; background:url("http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_blt_arrow.png") left 0.3em no-repeat; background-size:5px 6px;}
.mHitchhikerVip .hitchNotice li:first-child {margin-top:0;}
.mHitchhikerVip .hitchNotice li:last-child {margin-top:0.8rem;}
</style>
<%
'// 2018 회원등급 개편
Dim oUserInfo
Dim chkid, chklevel, i, j, iHVol, HHVol, evtID
dim startweekDate, endweekDate, deliweekDate
dim startdate, enddate, delidate
chkid = GetEncLoginUserID
chklevel =  GetLoginUserLevel
HHVol = ""

rsget.open "select top 1 * from db_event.dbo.tbl_vip_hitchhiker where isusing= 'Y' and getdate()>startdate and getdate() <= enddate",dbget,1
If not rsget.eof Then
	evtID = rsget("mevt_code")
	iHVol = rsget("Hvol")
	startdate =  rsget("startdate")	'시작일
	enddate =  rsget("enddate")		'종료일
	delidate =  rsget("delidate")	'배송일
Else
	evtID = ""
	iHVol = "91"
End If
rsget.close

function weekDayName(wd)
	select case wd
	case "1" wd = "일"
	case "2" wd = "월"
	case "3" wd = "화"
	case "4" wd = "수"
	case "5" wd = "목"
	case "6" wd = "금"
	case "7" wd = "토"
	end select
	weekDayName = wd
end function
if chklevel <> 7 then 
	If isApp <> 1 Then				'모바일일때
		If IsUserLoginOK = False Then
			response.write "<script>alert('로그인이 필요한 서비스입니다.');top.location.href='"&M_SSLUrl&"/login/login.asp?backpath=/event/eventmain.asp?eventid="&evtID&"';</script>"
			response.end
		End If

		IF (chklevel <> 3 and chklevel <> 4 and chklevel <> 6 and chkid <> "kjy8517" and chkid <> "dream1103" and chkid <> "kobula" and chkid <> "star088" And chkid <> "motions" and chkid <> "okkang77" and chkid <> "baboytw" and chkid <> "tozzinet" and chkid <> "thensi7" ) THEN
			response.write "<script>alert('마이텐바이텐의 회원등급을 확인해주세요!');top.location.href='"&wwwURL&"';</script>"
			response.end
		END If

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

		If evtID="" and chkid <> "kjy8517" and chkid <> "dream1103" and chkid <> "kobula" and chkid <> "star088" And chkid <> "motions" and chkid <> "okkang77" and chkid <> "baboytw" and chkid <> "tozzinet" and chkid <> "thensi7"   Then
			response.write "<script>alert('지금은 주소 입력 기간이 아닙니다.');top.location.href='"&wwwURL&"';</script>"
			response.End
		End If
	Else							'앱일때
		If IsUserLoginOK = False Then
	%>
			<script>$(function(){calllogin();return false;});</script>
	<%
			response.end
		Else
			IF (chklevel <> 3 and chklevel <> 4 and chklevel <> 6 and chkid <> "kjy8517" and chkid <> "dream1103" and chkid <> "kobula" and chkid <> "star088" And chkid <> "motions" and chkid <> "okkang77" and chkid <> "baboytw" and chkid <> "tozzinet" and chkid <> "thensi7" ) THEN
	%>
				<script>$(function(){alert('마이텐바이텐의 회원등급을 확인해주세요!');callmain();return false;});</script>
	<%
				response.end
			END If

			rsget.open "select top 1 * from [db_user].[dbo].[tbl_user_hitchhiker] where HVol = '"&iHVol&"' and userid = '"&chkid&"'",dbget,1
			If not rsget.eof Then
				HHVol = rsget("Hvol")
			Else
				HHVol = ""
			End If
			rsget.close

			If HHVol <> "" Then
	%>
				<script>$(function(){alert('고객님께서는 이미 히치하이커를 신청하셨습니다.\n배송지 수정을 원하실 경우 고객센터로 문의 바랍니다.');callmain();return false;});</script>
	<%
				response.End
			End If

			If evtID="" and chkid <> "kjy8517" and chkid <> "dream1103" and chkid <> "kobula" and chkid <> "star088" And chkid <> "motions" and chkid <> "okkang77" and chkid <> "baboytw" and chkid <> "tozzinet" and chkid <> "thensi7" Then
	%>
				<script>$(function(){alert('지금은 주소 입력 기간이 아닙니다.');callmain();return false;});</script>
	<%
				response.End
			End If
		End If
	End If
end if
Set oUserInfo = new CUserInfo
	oUserInfo.FRectUserID = chkid
If (chkid<>"") Then
    oUserInfo.GetUserData
End If
%>
<div class="evtCont">
	<div class="mHitchhikerVip">
		<form name="frmHitchVIP" id="frmHitchVIP"  method="post" action="/event/etc/processhitchreceive.asp" style="margin:0px;">
		<input type="hidden" name="chkid" value="<%=chkid%>">
		<input type="hidden" name="chklevel" value="<%=chklevel%>">
		<input type="hidden" name="iHVol" value="<%=iHVol%>">
		<!--p><img src="http://webimage.10x10.co.kr/eventIMG/hitchhiker/txt_hitchhiker_vol<%=iHVol%>.png" alt="텐바이텐 VIP고객님께 HITCHHIKER vol.<%=iHVol%>를 선물합니다! 히치하이커는 격월간으로 발행되는 텐바이텐의 감성매거진입니다." style="width:100%;" /></p-->
		<div class="topic">
			<h2>텐바이텐 <strong><%=GetUserLevelStr(GetLoginUserLevel())%> 고객님</strong><br /><strong>vol.<%=iHVol%> HITCHHIKER</strong>를<br />선물합니다!</h2>
			<p>히치하이커는 격월간으로 발행되는<br />텐바이텐의 감성매거진입니다.</p>
			<em><%=GetUserLevelStr(GetLoginUserLevel())%> 고객님께서는 하단의 배송지 입력을 통해<br />무료로 받아보실 수 있습니다.</em>
		</div>
		<div class="adrInput">
			<div class="contTit">
				<p>
					<%' for dev msg : old 버전 %>
					<!--img src="http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_addr_tit.png" alt="주소입력" style="width:80px;" /-->
					주소입력
				</p>
<!-- 			<ul class="adrSelect"> -->
<!-- 				<li><input type="radio" name="r1" onclick="javascript:defaultAddr();" id="add01" /> <label for="add01">기본 배송지 주소</label></li> -->
<!-- 				<li><input type="radio" name="r1" onclick="javascript:clearFields();" id="add02" /> <label for="add02">새로운 주소</label></li> -->
<!-- 			</ul> -->
			</div>
			<dl style="overflow:hidden;">
				<dt class="ftLt">아이디</dt>
				<dd class="ftLt lPad1r"><span><%=chkid%></span></dd>
			</dl>
			<dl>
				<dt><label for="hName">이름</label></dt>
				<dd><input type="text" class="textInput" id="hName" name="reqname" style="width:130px;" title="배송받으시는 분의 이름을 입력해주세요." /></dd>
			</dl>
			<dl>
				<dt><label for="hAdd">주소</label></dt>
				<dd>
					<p>
						<!--
						<input type="tel" name="txZip1" readOnly class="textInput" id="hAdd" style="width:25%;" title="우편번호찾기 버튼을 클릭해 주세요." /> -
						<input type="tel" name="txZip2" readOnly class="textInput" style="width:25%;" title="우편번호찾기 버튼을 클릭해 주세요." />
						-->
						<input type="tel" name="txZip" readOnly class="textInput" id="hAdd" style="width:130px;" title="우편번호찾기 버튼을 클릭해 주세요." />
						<%' for dev msg : old 버전 %>
						<!--input type="image" src="http://fiximage.10x10.co.kr/m/2013/event/hitchhiker/vip_addr_btn_zipcode.png" alt="우편번호찾기" class="btnPost" /-->
						<span class="button btB2 btGry2 cWh1">
						<% If isApp <> 1 Then %>
							<a href="#" onclick="TnFindZipNew('frmHitchVIP',''); return false;">우편번호 찾기</a>
						<% Else %>
							<a href="#" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/lib/pop_searchzipNew.asp?target=frmHitchVIP'); return false;">우편번호 찾기</a>
						<% End If %>
						</span>
					</p>
					<p style="padding-top:.5rem;"><input type="text" name="txAddr1" readOnly class="textInput" style="width:99%;" title="배송받으시는 곳의 주소 앞부분이 입력됩니다." /></p>
					<p style="padding-top:.5rem;"><input type="text" name="txAddr2" class="textInput" style="width:99%;" title="배송받으시는 곳의 상세주소를 입력해주세요." /></p>
					<p style="padding-top:.5rem; font-size:.9rem">택배가 아닌 우편으로 발송되기 때문에 번지/동/호수 등 상세주소를 정확히 입력해주시기 바랍니다.</p>
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
			<p class="ct tMar1-8r"><a href="#" onclick="jsSubmit(document.frmHitchVIP);return false;" class="btn btn-default btn-black btn-radius btn-block">확인</a></p>
		</div>
		<div class="hitchNotice">
			<ul>
				<li>기본 회원정보와 주소가 동일하더라도 기간 내에 배송지 입력 및 확인 절차를 거쳐야 정상 발송됩니다.</li>
				<li>우편으로 발송되기 때문에 고객님께서 수령하시기까지는 발송일 기준으로 최대 1주일 가량 소요됩니다.</li>
				<li><strong>주소 입력 기간 및 일괄 발송일 안내</strong>
					<p><%= FormatDate(startdate,"0000/00/00") %>(<%= weekDayName(Weekday(startdate)) %>) ~ <%= FormatDate(enddate,"0000/00/00") %>(<%= weekDayName(Weekday(enddate)) %>) / 발송일 : <%= FormatDate(delidate,"0000/00/00") %>(<%= weekDayName(Weekday(delidate)) %>)</p>
				</li>
			</ul>
		</div>
		</form>
	</div>
</div>
<div id="modalLayer" style="display:none;"></div>
<script language="javascript">
function clearFields() {
    var frm = document.getElementById('frmHitchVIP');
    var em = frm.elements;
    //frm.reset();
    for(var i=0; i<em.length; i++) {
        if(em[i].type == 'text') em[i].value = '';
        if(em[i].type == 'tel') em[i].value = '';
        if(em[i].type == 'number') em[i].value = '';
        if(em[i].type == 'checkbox') em[i].checked = false;
       // if(em[i].type == 'radio') em[i].checked = false;
        if(em[i].type == 'select-one') em[i].options[0].selected = true;
        if(em[i].type == 'textarea') em[i].value = '';
    }
    return;
}

function defaultAddr(){
	var frm = document.frmHitchVIP;
	frm.reqname.value = "<%=GetLoginUserName%>";

	//frm.txZip1.value = "<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>"
	//frm.txZip2.value = "<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>"

	frm.txZip.value = "<%= oUserInfo.FOneItem.FZipCode %>"
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
	if (frm.reqname.value == ''){
		alert('이름을 입력해 주세요.');
		frm.reqname.focus();
		return;
	}
	// 주소, 전화번호, 핸드폰 필수 정보입력
	if (frm.txZip.value.length<5){
		alert('우편번호를 입력해 주세요.');
		frm.txZip.focus();
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
<% Set oUserInfo = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->