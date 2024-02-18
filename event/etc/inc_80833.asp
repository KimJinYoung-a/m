<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description :  Wedding Membership
' History : 2016.09.12 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim vGubun, i, evt_code, userid, totalbonuscouponcountusingy, device', returnb
dim apps

userid = GetEncLoginUserID()

'returnb = requestCheckVar(Request("returnb"),3)

IF application("Svr_Info") = "Dev" THEN
	evt_code   =  67439
Else
	evt_code   =  80833
End If

																								If date() < "2017-10-12" Then
																								'	response.end
																									'response.redirect("/")
																								End If
																								
if isapp then
	device = "A"
	apps = "apps"
else
	device = "M"
	apps = ""
end if

dim subscriptcount, subscriptcountsub
subscriptcount=0
subscriptcountsub=0
totalbonuscouponcountusingy=0

'' 실섭 1003-무배, 1004-60만/7만, 1005-100만/15마
'' 테섭 2855-무배, 2856-60만/7만, 2857-100만/15마

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(evt_code, userid, "", "", "")
	subscriptcountsub = getevent_subscriptexistscount(evt_code, userid, "subevt", "", "")
'	totalbonuscouponcountusingy = getbonuscoupontotalcount("1003,1004,1005", "N", "Y","")
end if

'Dim vImgURL
'vImgURL = staticImgUpUrl & "/contents/contest/" & evt_code & "/"

dim iandOrIos, iappVer, vProcess
iappVer = getAppVerByAgent(iandOrIos)
if (iandOrIos="a") then
    if (FnIsAndroidKiKatUp) then
        if (iappVer>="1.48") then
            ''신규 업노드    
            vProcess = "A"
        else
            ''어플리케이션 1.48 이상 버전업이 필요하다.
            vProcess = "I"
        end if
    else
        '' 기존
        vProcess = "I"
    end if
else
    ''기존.
    vProcess = "I"
end if
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt80833 {position:relative; background:#ffeacf;}
.writeInvitation {width:100%;height:100%; color:#585858; font-size:1.19rem; background:#ffeacf;}
.writeInvitation .writeCont {position:relative; width:92%; margin:0 auto; padding-bottom:2.39rem; background:#fff;}
.writeInvitation .writeForm {padding:0 1.71rem;}
.writeInvitation .writeForm dl {padding:1.28rem 0;}
.writeInvitation .writeForm dl:first-child{padding-top:0;}
.writeInvitation .writeForm dl:after {content:' '; display:block; clear:both;}
.writeInvitation .writeForm dt {position:relative; float:left; width:31.8%; margin-top:1.1rem; padding-left:1.2rem; font-size:1.25rem; line-height:1.25; color:#c3953a; font-weight:bold; letter-spacing:-0.05rem;}
.writeInvitation .writeForm dt:after {display:block; content:' '; position:absolute; top:0.3rem; left:0; width:0.68rem; height:0.6rem; background-color:#c3953a; transform:rotate(-45deg); -webkit-transform:rotate(-45deg);}
.writeInvitation .writeForm dd {float:left; width:65%; line-height:3.4rem;}
.writeInvitation .writeForm dd p {position:relative; font-size:1.5rem;}
.writeInvitation .writeForm dd .desc {padding-top:0.5rem; font-size:0.9rem; line-height:1.2; color:#adadad; letter-spacing:-0.03rem;}
.writeInvitation .writeForm input {width:100%; border-radius:0; height:3.4rem; border:1px solid #ddd; color:#585858;}
.writeInvitation .writeForm input::placeholder{color:#585858;}
.writeInvitation .addFile dt {margin-top:.5rem;}
.writeInvitation .addFile input{display:block; border:1px solid #ddd; height:3.4rem; background:#fff;}
.writeInvitation .noti {margin:2.3rem .85rem 0; padding:2.56rem .94rem 2.05rem; background-color:#c3953a; color:#fff;}
.writeInvitation .noti h4 {padding:0 0 1.28rem 0.8rem; font-size:1.3rem; font-weight:600; text-align:center;}
.writeInvitation .noti li {position:relative; font-size:1.1rem; line-height:1.3; padding:0 0 0.2rem 0.85rem;}
.writeInvitation .noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.6rem; width:0.4rem; height:1px; background:#fff;}
.writeInvitation .policy {position:relative; padding:2.05rem .94rem 0; color:#7e7e7e; font-size:1.1rem;}
.writeInvitation .policy .txt {overflow-y:scroll; -webkit-overflow-scrolling:touch; height:10rem; margin-bottom:2.47rem; padding:1.3rem 1.5rem 1rem; font-size:1rem; line-height:1.4; color:#959595; border:1px solid #ddd; background:#fff;}
.writeInvitation .policy .agree-box {position:relative; font-size:1.19rem; line-height:1.3; vertical-align:middle;}
.writeInvitation .policy .agree-txt {display:inline-block; width:100%; padding-left:3.58rem; font-size:1.3rem; font-weight:bold;}
.writeInvitation .policy label {display:inline-block; letter-spacing:-0.025em;}
.writeInvitation .policy input[type=checkbox] {position:absolute; top:50%; left:.43rem; width:2.56rem; height:2.56rem; margin-top:-1.28rem; border-radius:50%; vertical-align:middle;}
.writeInvitation .policy input[type=checkbox]:checked {position:absolute; top:50%; left:.43rem; margin-top:-1.28rem; background:#fff;}
.writeInvitation .policy input[type=checkbox]:checked:after {content:''; position:absolute; left:50%; top:50%; width:46%; height:46%; margin:-22% 0 0 -22%; background:#db4143; border-radius:50%;}
.writeInvitation .policy .caution {margin-top:1.37rem; font-size:1.1rem; text-align:center; color:#f16554; font-weight:bold;}
.writeInvitation .btn-submit {display:block; width:100%; margin-top:3.58rem;}
</style>
<script type="text/javascript">
function SubmitForm(frm){
<% If IsUserLoginOK() Then %>
	<% If Now() > #11/01/2017 23:59:59# Then %>
		alert("이벤트 기간이 아닙니다.");
		return;
	<% Else %>
		<% if subscriptcount < 1 then %>
			// 내 이름
			if (frm.myArea1.value == '' || frm.myArea1.value == 'ex) 홍길동'){
				alert("본인 이름을 입력해 주세요.");
				frm.myArea1.value = '';
				frm.myArea1.focus();
				return;
			}

			//배우자 이름
			if (frm.myArea2.value == '' || frm.myArea2.value == 'ex) 홍길동'){
				alert("배우자 이름을 입력해 주세요.");
				frm.myArea2.value = '';
				frm.myArea2.focus();
				return;
			}

			//결혼 예정일
			if (frm.myArea3.value == ''){
				alert("결혼 예정일을 입력해 주세요");
				frm.myArea3.focus();
				return;
			}

			if (frm.myArea3.value == '' || GetByteLength(frm.myArea3.value) > 8 || frm.myArea3.value == '00000000'){
				alert("결혼 예정일을 숫자로 8자리로 입력해 주세요.");
				frm.myArea3.focus();
				return;
			}

	        if(isNaN(frm.myArea3.value) == true) {
	            alert("결혼 예정일을 숫자로 8자리로 입력해 주세요..!");
	            frm.myArea3.focus();
	            return false;
	        }

			// 체크 되어 있는지 확인
			var tmpagreecheck = $("#agreeY").prop("checked") ;
			if(!tmpagreecheck){
				alert("개인정보 취급방침을 확인해주세요.");
				frm.agreecheck.focus();
				return;
			}

			for(var ii=1; ii<2; ii++)
			{
				var frmname		 = eval("frm.file"+ii+"");

				if(frmname.value == ""){
					alert('청첩장사진 파일을 등록해 주세요.');
					return;
				}
			}

			frm.optname.value = frm.myArea1.value+"/!/"+frm.myArea2.value+"/!/N";
			frm.mode.value = 'addreg';
			if (confirm("입력사항이 정확합니까?") == true){
				frm.target="evtFrmProc";
				frm.submit();
			}
	   <% else %>
			alert("이미 응모 하셨습니다.");
			return;
		<% end if %>
	<% End if %>
<% Else %>
	<% if isApp then %>
		parent.calllogin();
	<% else %>
		parent.jsevtlogin();
	<% end if %>
<% End IF %>
}

function jsCheckLimit(textgb) {
	<% if NOT(IsUserLoginOK) then %>
		<% if isApp then %>
			parent.calllogin();
		<% else %>
			parent.jsevtlogin();
		<% end if %>
	<% else %>
		if (textgb =='ta1'){
			if (document.FrmGoodusing.myArea1.value == 'ex) 홍길동'){
				document.FrmGoodusing.myArea1.value = '';
			}
		}else if(textgb =='ta2'){
			if (document.FrmGoodusing.myArea2.value == 'ex) 홍길동'){
				document.FrmGoodusing.myArea2.value = '';
			}
		}else if(textgb =='ta3'){
			if (document.FrmGoodusing.myArea3.value == '00000000'){
				document.FrmGoodusing.myArea3.value = '';
			}
		}else{
			alert('잠시 후 다시 시도해 주세요');
			return;
		}
	<% end if %>
}

function maxLengthCheck(object){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) )
	{
		return;
	}
	else
	{
		return false;
	}
}
function showKeyCode(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) )
	{
		return;
	}
	else
	{
		return false;
	}
}

function maxLengthCheck(object)
{
if (object.value.length > object.maxLength)
  object.value = object.value.slice(0, object.maxLength)
}

//이미지 업로드
var _selComp;
var _no;

function fnAPPuploadImage(comp, no) {
<% If IsUserLoginOK() Then %>
	_selComp = comp;
	_no = no;
	var paramname = comp.name;
	var upurl = "<%=staticImgUpUrl%>/linkweb/enjoy/test_doevaluatewithimage_android_onlyimageupload.asp?evtcode=<%=evt_code%>&paramname="+paramname;
	if (no=="1"){
		callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish1});
	}else if(no=="2"){
		callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish2});
	}
	return false;
<% Else %>
	<% if isApp then %>
		parent.calllogin();
	<% else %>
		parent.jsevtlogin();
	<% end if %>
<% End IF %>
}

function _appUploadFinish1(ret,ino){
 //  alert("["+ino+"]");
	if (_selComp){
		_selComp.value=ret.name;
		$('#imgspan1').empty();
		$('#imgspan1').text(ret.name);
		document.FrmGoodusing.imgfile1.value = ret.name;
	}
}

function _appUploadFinish2(ret,ino){
 //  alert("["+ino+"]");
	if (_selComp){
		_selComp.value=ret.name;
		$('#imgspan2').empty();
		$('#imgspan2').text(ret.name);
		document.frmApplyevt.imgfile1.value = ret.name;
	}
}

function appUploadFinish1(ret){
	_appUploadFinish1(ret,1);
}

function appUploadFinish2(ret){
	_appUploadFinish2(ret,2);
}
</script>
	<div class="mEvt73007">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/80833/m/tit_wedding_mem.jpg" alt="Wedding Membership" /></h2>

		<!-- 웨딩쿠폰 3종 세트 -->
		<div class="weddingEvt coupon-set"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80833/m/txt_coupon_set.jpg" alt="1만원 이상 구매 시 무료배송 60만원 이상 구매 시 70,000원 100만원 이상 구매 시 150,000원" /></div>
		<!--// 웨딩쿠폰 3종 세트 -->

		<!--  청첩장 등록 -->
		<% if isapp then %>
			<% If vProcess="A" then %>
				<form name="FrmGoodusing" id="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_app.asp"  onsubmit="return false;">
			<% Else %>
				<form name="FrmGoodusing" id="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data" onsubmit="return false;">
			<% End If %>
		<% else %>
				<form name="FrmGoodusing" id="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data">
		<% end if %>
		<input type="hidden" name="evt_code" value="<%= evt_code %>" />
		<input type="hidden" id="apps" name="apps" value="<%= apps %>" >
		<input type="hidden" name="mode" value="addreg">
		<input type="hidden" name="optname" value="">
		<input type="hidden" name="imgfile1" value="">
		<input type="hidden" name="device" value="<%= device %>">

		<div class="weddingEvt enroll">
			<div id="writeInvitation" class="writeInvitation">
				<div class="writeCont">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80833/m/tit_invitation.png" alt="청첩장 등록" /></h3>
					<div class="writeForm">
						<dl>
							<dt>나의 정보</dt>
							<dd>
								<p><% IF NOT(IsUserLoginOK) THEN %>로그인을 해주세요.<% else %><%= userid %><% END IF %></p>
								<p><input type="text" name="myArea1" onClick="jsCheckLimit('ta1');" onKeyUp="jsCheckLimit('ta1');" placeholder="ex) 홍길동" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="ex) 홍길동"<% END IF %> /></p>
							</dd>
						</dl>
						<dl>
							<dt>배우자 정보</dt>
							<dd>
								<p><input type="text" name="myArea2" onClick="jsCheckLimit('ta2');" onKeyUp="jsCheckLimit('ta2');" placeholder="ex) 홍길동" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="ex) 홍길동"<% END IF %>  /></p>
								<p class="desc">※ 청첩장 정보와 일치여부 판단하기 위해 기입</p>
							</dd>
						</dl>
						<dl>
							<dt>결혼(예정)일</dt>
							<dd>
								<p><input type="text"  oninput="maxLengthCheck(this)" onClick="jsCheckLimit('ta3');" onKeyUp="jsCheckLimit('ta3');" name="myArea3" placeholder="00000000" maxlength="8" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="00000000"<% END IF %>/></p>
							</dd>
						</dl>
						<dl class="addFile">
							<dt>청&nbsp;&nbsp;&nbsp;&nbsp;첩&nbsp;&nbsp;&nbsp;&nbsp;장<br />이미지 첨부</dt>
							<dd>
								<% if isapp then %>
									<% If vProcess="A" Then %>
									<div class="addImage">
										<input type="hidden" name="file1" id="file1" value="">
										<button class="selectFile" onClick="fnAPPuploadImage(this.form.file1, '1'); return false;">파일선택</button>
										<div class="pic" id="imgspan1">이미지를 선택해주세요.</div>
									</div>
									<% Else %>
										<p><input name="file1" id="file1" type="file" class="addFile"/><p>
										<span class="pic"></span>
									<% End If %>
								<% else %>
									<p><input name="file1" id="file1" type="file" class="addFile"/><p>
									<span class="pic"></span>
								<% end if %>
								
								<p class="desc">※ 최대 2MB, JPG(JPEG)파일</p>
							</dd>
						</dl>
					</div>
					<div class="noti">
						<h4>※ 꼭 확인해주세요!</h4>
						<ul>
							<li>2017년 10월 1일 ~ 12월 31일까지가 결혼일(예정일)인 고객님은 모두 등록 가능합니다.</li>
							<li>기입해주신 고객명, 배우자명이 청첩장과 동일해야 합니다.</li>
							<li>기입한 정보는 비공개이며, 이벤트 종료 후 파기됩니다.</li>
							<li>발급된 쿠폰은 2017년 11월 1일까지 사용 가능합니다.</li>
						</ul>
					</div>
					<div class="policy">
						<div class="txt">
							<h4>[수집하는 개인정보 항목 및 수집방법]</h4>
							<div>1. 수집하는 개인정보의 항목<br/>① 회사는 회원가입시 원할한 고객상담, 각종 서비스의 제공을 위해 아래와 같은 최소한의 개인정보를 필수항목을 수집하고 있습니다. - 아이디, 비밀번호, 이름, 성별, 생년월일, 이메일주소, 휴대폰번호, 가입인증정보<br/>② 서비스 이용과정이나 사업 처리과정에서 아래와 같은 정보들이 생성되어 수집될 수 있습니다.<br />- 최근접속일, 접속 IP 정보, 쿠키, 구매로그, 이벤트로그<br />- 물품 주문시 : 이메일주소, 전화번호, 휴대폰번호, 주소<br />- 물품(서비스)구매에 대한 결제 및 환불시 : 은행계좌정보<br />-개인맞춤서비스 이용시 : 은행계좌정보<br />2. 개인정보 수집에 대한 동의<br />회사는 귀하께서 텐바이텐의 개인정보취급방침 및 이용약관의 내용에 대해 「동의한다」버튼 또는 「동의하지 않는다」버튼을 클릭할 수 있는 절차를 마련하여, 「동의한다」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다. 「동의안함」을 선택하실 경우, 회사가 제공하는 기본서비스 제공이 제한됩니다.</div>
							<h4>[개인정보의 수집목적 및 이용 목적]</h4>
							<div>① 회원제 서비스 이용에 따른 본인 식별 절차에 이용<br />② 고지사항 전달, 본인 의사 확인, 불만 처리 등 원활한 의사소통 경로의 확보, 새로운 서비스, 신상품이나 이벤트 정보 등 최신 정보의 안내<br />③ 쇼핑 물품 배송에 대한 정확한 배송지의 확보<br />④ 개인맞춤 서비스를 제공하기 위한 자료<br />⑤ 경품 수령 및 세무신고를 위한 별도의 개인정보 요청</div>
							<h4>[개인정보의 보유, 이용기간]</h4>
							<div>2. 위 개인정보 수집목적 달성시 즉시파기 원칙에도 불구하고 다음과 같이 거래 관련 권리 의무 관계의 확인 등을 이유로 일정기간 보유하여야 할 필요가 있을 경우에는 전자상거래 등에서의 소비자보호에 관한 법률 등에 근거하여 일정기간 보유합니다.<br />① 「전자상거래 등에서의 소비자보호에 관한 법률」에 의한 보관<br />- 계약 또는 청약철회 등에 관한 기록 : 5년<br />- 대금결제 및 재화 등의 공급에 관한 기록 : 5년<br />- 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년<br />② 「통신비밀보호법」 시행령 제41조에 의한 통신사실확인자료 보관 - 컴퓨터통신, 인터넷 로그기록자료, 접속지 추적자료 : 3개월<br />③ 설문조사, 이벤트 등 일시적 목적을 위하여 수집한 경우 : 당해 설문조사, 이벤트 등의 종료 시점</div>
							<h4>[개인정보의 파기 절차]</h4>
							<div>회사는 원칙적으로 개인정보 수집 및 이용목적이 달성되면 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.<br />1. 파기절차<br />① 귀하가 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(제6조 개인정보의 보유, 이용기간 참조) 일정 기간 저장된 후 파기되어집니다.<br />② 동 개인정보는 법률에 의한 경우가 아니고서는 보유되어지는 이외의 다른 목적으로 이용되지 않습니다.<br />2. 파기방법 <br />① 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.<br />② 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.</div>
						</div>
						<p class="agree-box"><input type="checkbox" id="agreeY" value="Y" id="agreecheck" name="agreecheck" /><label for="agreeY"><span class="agree-txt">본 이벤트 참여를 위한 개인정보 취급방침에 동의합니다.</span></label></p>
						<button class="btn-submit" onClick="SubmitForm(FrmGoodusing); return false;"  /><img  src="http://webimage.10x10.co.kr/eventIMG/2017/80833/m/btn_submit.png" alt="청첩장 등록하고 쿠폰 받기" /></button>
						<p class="caution">* 공지사항을 꼭 확인 후 제출하세요!</p>
					</div>
				</div>
			</div>
			<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2017/80833/m/bg_edge.png" alt="" /></div>
		</div>
		</form>
		<!--//  청첩장 등록 -->
	</div>
<%
function getAppVerByAgent(byref iosOrAnd)
    dim agnt : agnt =  Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    dim pos1 : pos1 = Instr(agnt,"tenapp ")
    dim buf 
    dim retver : retver=""
    getAppVerByAgent = retver
    
    if (pos1<1) then exit function
    buf = Mid(agnt,pos1,255)
    
    iosOrAnd = MID(agnt,pos1 + LEN("tenapp "),1)
    getAppVerByAgent = Trim(MID(agnt,pos1 + LEN("tenapp ")+1,4))
end function

function FnIsAndroidKiKatUp()
    dim iiAgent : iiAgent= Lcase(Request.ServerVariables("HTTP_USER_AGENT"))
    FnIsAndroidKiKatUp = (InStr(iiAgent,"android 4.4")>0)
    FnIsAndroidKiKatUp = FnIsAndroidKiKatUp or (InStr(iiAgent,"android 5")>0) or (InStr(iiAgent,"android 6")>0) or (InStr(iiAgent,"android 7")>0)
    
end function

%>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->