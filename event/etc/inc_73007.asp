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
Dim vGubun, i, evt_code, userid, totalbonuscouponcountusingy, device, returnb

userid = GetEncLoginUserID()

returnb = requestCheckVar(Request("returnb"),3)
IF application("Svr_Info") = "Dev" THEN
	evt_code   =  66201
Else
	evt_code   =  73007
End If

if isapp then
	device = "A"
else
	device = "M"
end if

dim subscriptcount, subscriptcountsub
subscriptcount=0
subscriptcountsub=0
totalbonuscouponcountusingy=0

'' 실섭 899,900,901,902,903
'' 테섭 2809,2810,2811,2812,2813

'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(evt_code, userid, "", "", "")
	subscriptcountsub = getevent_subscriptexistscount(evt_code, userid, "subevt", "", "")
'	totalbonuscouponcountusingy = getbonuscoupontotalcount("899,900,901,902,903", "N", "Y","")
end if

Dim vImgURL
vImgURL = staticImgUpUrl & "/contents/contest/" & evt_code & "/"

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
.mEvt73007 {position:relative;}
.goSmall {position:absolute; right:0; top:0; width:34.8%;}
.attachPhoto {position:relative;}
.attachPhoto dl {position:absolute; left:0; top:66%; width:100%;}
.attachPhoto dd {width:66%; margin:0 auto; padding-top:2.6%;}
.attachPhoto dd .addImage {display:block; width:100%; height:3rem; border:1px solid red;}
.attachPhoto dd .addFile {display:block; border:1px solid #ddd; height:3rem; margin:0 0.6rem; background:#fff;}
.attachPhoto dd .btnSubmit {display:block; width:100%; margin-top:4%;}
.evtNoti {padding:3.5rem 2.5rem 3rem; background:#ece7e3;}
.evtNoti h3 {padding-bottom:1.3rem; font-size:1.4rem; color:#a5988f; font-weight:bold;}
.evtNoti li {position:relative; padding:0 0 0.4rem 1.2rem; font-size:1.1rem; line-height:1.3; color:#8e8e8f;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.45rem; width:0.6rem; height:0.15rem; background:#a5988f;}
#writeInvitation {display:none; position:absolute; left:0; top:0; width:100%; padding-top:3rem; z-index:100; height:100%; color:#5d5d5d; font-size:1.2rem; background:rgba(0,0,0,.5);}
#writeInvitation .writeCont {position:relative; width:94%; margin:0 auto; padding-bottom:2.8rem; background:#fbfbfb;}
#writeInvitation .writeForm {padding:0 2rem;}
#writeInvitation .writeForm dl {padding:1.3rem 0; border-top:1px solid #f0f0f0;}
#writeInvitation .writeForm dl:first-child {border-top:0;}
#writeInvitation .writeForm dl:after {content:' '; display:block; clear:both;}
#writeInvitation .writeForm dt {position:relative; float:left; width:34%; margin-top:1.1rem; padding-left:1.2rem; font-size:1.2rem; line-height:1.2; color:#bd9877;}
#writeInvitation .writeForm dt:after {display:block; content:' '; position:absolute; top:0.2rem; left:0; width:0.6rem; height:0.6rem; background-color:#d1b67f; transform:rotate(-45deg); -webkit-transform:rotate(-45deg);}
#writeInvitation .writeForm dd {float:left; width:65%; line-height:3.4rem;}
#writeInvitation .writeForm dd .desc {padding-top:0.5rem; font-size:0.9rem; line-height:1.2; color:#a2a2a2;}
#writeInvitation .writeForm dd p {position:relative;}
#writeInvitation .writeForm dd span {position:absolute; right:0; top:0;}
#writeInvitation .writeForm input {width:100%; border-radius:0; height:3.4rem; border:1px solid #ddd; color:#5d5d5d;}
#writeInvitation .noti {padding:2.4rem 2rem; background:#f3f3f3;}
#writeInvitation .noti h4 {padding:0 0 0.6rem 0.8rem; font-size:1.2rem; font-weight:600; color:#7e7e7e;}
#writeInvitation .noti li {position:relative; font-size:1.1rem; line-height:1.2; padding:0 0 0.4rem 0.8rem; color:#959595;}
#writeInvitation .noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.42rem; width:0.4rem; height:1px; background:#959595;}
#writeInvitation .noti li em {color:#a071dc;}
#writeInvitation .policy {padding:0 2rem; color:#7e7e7e; font-size:1.1rem;}
#writeInvitation .policy .txt {overflow-y:scroll; -webkit-overflow-scrolling:touch; height:10rem; margin:1.5rem 0 1rem; padding:1.3rem 1.5rem 1rem; font-size:1rem; line-height:1.4; color:#959595; border:1px solid #ddd; background:#fff;}
#writeInvitation .policy label {letter-spacing:-0.025em;}
#writeInvitation .policy input[type=checkbox] {width:1.5rem; height:1.5rem; margin-top:-0.5rem; border-radius:50%; vertical-align:middle;}
#writeInvitation .policy input[type=checkbox]:checked {position:relative; background:#fff;}
#writeInvitation .policy input[type=checkbox]:checked:after {content:''; position:absolute; left:50%; top:50%; width:60%; height:60%; margin:-30% 0 0 -30%; background:#ba84ff; border-radius:50%;}
#writeInvitation .policy .caution {padding:2.7rem 0 0.9rem; font-size:1rem; text-align:center; color:#db4143;}
#writeInvitation .btnSubmit {display:block; width:100%; padding:0 0.4rem;}
#writeInvitation .btnClose {position:absolute; right:0; top:0; width:12%; background:transparent;}
</style>
<script type="text/javascript">
$(function(){
	$(".btnEnroll").click(function(){
		$("#writeInvitation").show();
		window.parent.$('html,body').animate({scrollTop:$("#writeInvitation").offset().top}, 600);
	});
	$("#writeInvitation .btnClose").click(function(){
		$("#writeInvitation").hide();
	});

});

function SubmitForm(frm){
<% If IsUserLoginOK() Then %>
	<% If Now() > #10/16/2016 23:59:59# Then %>
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

			if (frm.myArea3.value == '' || GetByteLength(frm.myArea3.value) > 4 || frm.myArea3.value == '0000'){
				alert("결혼 예정일을 숫자로 4자리로 입력해 주세요.");
				frm.myArea3.focus();
				return;
			}

			// 체크 되어 있는지 확인
			var checkCnt = $("input[name=agreecheck]:checked").size();
			var checkval = $("input[name=agreecheck]:checked").val() ;
			if(checkCnt == 0) {
				alert("동의하지 않으면 응모하실 수 없습니다.");
				frm.agreecheck.focus();
				return;
			}else{
				if(checkval == '') {
					alert("개인정보 취급 방침에 동의 하셔야 응모 가능 합니다.");
					frm.agreecheck.focus();
					return;
				}
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
			if (document.FrmGoodusing.myArea3.value == '0000'){
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


function frmSubmitevt2() {

	<% If IsUserLoginOK() Then %>
		<% If Now() > #10/16/2016 23:59:59# Then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% Else %>
			<% if subscriptcount > 0 then %>
				<% if subscriptcountsub < 1 then %>
					var frm = document.frmApplyevt;
	
					for(var ii=1; ii<2; ii++)
					{
						var frmname		 = eval("frm.file"+ii+"");
	
						if(frmname.value == ""){
							alert('웨딩사진 파일을 등록해 주세요.');
							return;
						}
					}

					frm.mode.value = 'addevt';
					frm.target="evtFrmProc";
					frm.submit();
				<% else %>
					alert("이미 응모 하셨습니다.");
					return;
				<% end if %>
			<% else %>
				alert("청첩장 이벤트에 응모 하셔야\n응모 가능 합니다.");
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
</script>
	<!-- WEDDING MEMBERSHIP-->
	<div class="mEvt73007">
		<p class="goSmall"><a href="eventmain.asp?eventid=72792"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/btn_small_wedding.png" alt="웨딩기획전 바로가기" /></a></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/tit_membership.png" alt="PEN themselves" /></h2>
		<!-- event1 청첩장 등록 -->
		<div class="weddingEvt event1">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/txt_event_1.png" alt="EVENT1.청첩장을 등록해주세요! 웨딩쿠폰 5종세트를 드립니다!" /></div>
			<a href="#writeInvitation" class="btnEnroll"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/btn_register.png" alt="청첩장 등록하기" /></a>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/bg_box_btm.png" alt="" /></div>
		</div>
		<!--// event1 청첩장 등록 -->

		<% if isapp then %>
			<% If vProcess="A" then %>
				<form name="FrmGoodusing" id="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_app.asp"  onsubmit="return false;">
			<% Else %>
				<form name="FrmGoodusing" id="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data" onsubmit="return false;">
			<% End If %>
		<% else %>
				<form name="FrmGoodusing" id="FrmGoodusing" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data">
		<% end if %>
		<input type="hidden" name="evt_code" value="<%=evt_code%>" />
		<input type="hidden" id="apps" name="apps" value="apps">
		<input type="hidden" name="mode" value="addreg">
		<input type="hidden" name="optname" value="">
		<input type="hidden" name="imgfile1" value="">
		<input type="hidden" name="device" value="<%= device %>">

		<!-- 청첩장 등록 레이어팝업 -->
		<div id="writeInvitation" class="writeInvitation">
			<div class="writeCont">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/tit_invitation.png" alt="청첩장 등록" /></h3>
				<div class="writeForm">
					<dl>
						<dt>나의정보</dt>
						<dd>
							<p><% IF NOT(IsUserLoginOK) THEN %>로그인을 해주세요.<% else %><%= userid %><% END IF %></p>
							<p><input type="text" name="myArea1" onClick="jsCheckLimit('ta1');" onKeyUp="jsCheckLimit('ta1');" placeholder="ex) 홍길동" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="ex) 홍길동"<% END IF %> /></p>
						</dd>
					</dl>
					<dl>
						<dt>배우자 정보</dt>
						<dd>
							<p><input type="text" name="myArea2" onClick="jsCheckLimit('ta2');" onKeyUp="jsCheckLimit('ta2');" placeholder="ex) 홍길동" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="ex) 홍길동"<% END IF %> /></p>
							<p class="desc">※ 청첩장 정보와 일치여부 판단하기 위해 기입</p>
						</dd>
					</dl>
					<dl>
						<dt>결혼(예정)일</dt>
						<dd>
							<p>2016년 
								<span>
									<input type="number" title="결혼(예정)일" style="width:12rem;" oninput="maxLengthCheck(this)" onClick="jsCheckLimit('ta3');" onKeyUp="jsCheckLimit('ta3');" name="myArea3" placeholder="0000" maxlength="4" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="0000"<% END IF %> />
								</span>
							</p>
						</dd>
					</dl>
					<dl>
						<dt>청첩장<br />이미지 첨부</dt>
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
					<h4>[ 공지사항 ]</h4>
					<ul>
						<li><em>2016/9/1 ~ 11/30 까지 결혼일(예정일)인 고객은 모두 등록 가능합니다.</em></li>
						<li>기입해주신 고객명, 배우자명이 청첩장과 동일해야 합니다.</li>
						<li>평일 자정까지 업로드 한 고객에 한하여 익일 오후 2시 일괄 승인됩니다. (금/토/일 등록자는 월요일 일괄승인)</li>
						<li>기입한 정보는 비공개이며, 이벤트 종료 후 파기 됩니다.</li>
					</ul>
				</div>
				<div class="policy">
					<div class="txt">
						<h4>[수집하는 개인정보 항목 및 수집방법]</h4>
						<div>1. 수집하는 개인정보의 항목<br/>① 회사는 회원가입시 원할한 고객상담, 각종 서비스의 제공을 위해 아래와 같은 최소한의 개인정보를 필수항목을 수집하고 있습니다. - 아이디, 비밀번호, 이름, 성별, 생년월일, 이메일주소, 휴대폰번호, 가입인증정보<br/>② 서비스 이용과정이나 사업 처리과정에서 아래와 같은 정보들이 생성되어 수집될 수 있습니다.<br />- 최근접속일, 접속 IP 정보, 쿠키, 구매로그, 이벤트로그<br />- 물품 주문시 : 이메일주소, 전화번호, 휴대폰번호, 주소<br />- 물품(서비스)구매에 대한 결제 및 환불시 : 은행계좌정보<br />개인맞춤서비스 이용시 : 주소록, 기념일<br /><br />2. 개인정보 수집에 대한 동의<br />회사는 귀하께서 텐바이텐의 개인정보취급방침 및 이용약관의 내용에 대해 「동의한다」버튼 또는 「동의하지 않는다」버튼을 클릭할 수 있는 절차를 마련하여, 「동의한다」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다. 「동의안함」을 선택하실 경우, 회사가 제공하는 기본서비스 제공이 제한됩니다.</div>
						<h4>[개인정보의 수집목적 및 이용 목적]</h4>
						<div>① 회원제 서비스 이용에 따른 본인 식별 절차에 이용<br />② 고지사항 전달, 본인 의사 확인, 불만 처리 등 원활한 의사소통 경로의 확보, 새로운 서비스, 신상품이나 이벤트 정보 등 최신 정보의 안내<br />③ 쇼핑 물품 배송에 대한 정확한 배송지의 확보<br />④ 개인맞춤 서비스를 제공하기 위한 자료<br />⑤ 경품 수령 및 세무신고를 위한 별도의 개인정보 요청</div>
						<h4>[개인정보의 보유, 이용기간]</h4>
						<div>2. 위 개인정보 수집목적 달성시 즉시파기 원칙에도 불구하고 다음과 같이 거래 관련 권리 의무 관계의 확인 등을 이유로 일정기간 보유하여야 할 필요가 있을 경우에는 전자상거래 등에서의 소비자보호에 관한 법률 등에 근거하여 일정기간 보유합니다.<br />① 「전자상거래 등에서의 소비자보호에 관한 법률」에 의한 보관<br />- 계약 또는 청약철회 등에 관한 기록 : 5년<br />- 대금결제 및 재화 등의 공급에 관한 기록 : 5년<br />- 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년<br />② 「통신비밀보호법」 시행령 제41조에 의한 통신사실확인자료 보관 - 컴퓨터통신, 인터넷 로그기록자료, 접속지 추적자료 : 3개월<br />③ 설문조사, 이벤트 등 일시적 목적을 위하여 수집한 경우 : 당해 설문조사, 이벤트 등의 종료 시점</div>
						<h4>[개인정보의 파기 절차]</h4>
						<div>회사는 원칙적으로 개인정보 수집 및 이용목적이 달성되면 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.<br />1. 파기절차<br />① 귀하가 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(제6조 개인정보의 보유, 이용기간 참조) 일정 기간 저장된 후 파기되어집니다.<br />② 동 개인정보는 법률에 의한 경우가 아니고서는 보유되어지는 이외의 다른 목적으로 이용되지 않습니다.<br />2. 파기방법 <br />① 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.<br />② 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.</div>
					</div>
					<p class="ct"><label for="agreeY">이벤트 참여를 위한 개인정보 취급방침에 동의합니다.</label> <input type="radio" id="agreeY" value="Y" name="agreecheck" /></p>
					<p class="caution">* 공지사항을 꼭 확인 후 제출하세요!</p>
					<p><input type="image" onClick="SubmitForm(FrmGoodusing); return false;" class="btnSubmit" src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/btn_send.png" alt="청첩장 제출하기" /></p>
				</div>
				<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
		</form>
		<!--// 청첩장 등록 레이어팝업 -->

		<!-- event2 -->
		<div class="weddingEvt event2">
			<% '' 청첩장 등록 안했을 경우 %>
			<% if subscriptcount < 1 then %>
				<div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/txt_event_2_default.png" alt="EVENT2.웨딩사진을 등록해주세요!  겨울엔 토스트가 좋아에서 5명을 추첨해 여러분의 웨딩사진을 그려드립니다." />
				</div>
			<% else %>
				<% if isapp then %>
					<% If vProcess="A" then %>
						<form name="frmApplyevt" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_app.asp"  onsubmit="return false;">
					<% Else %>
						<form name="frmApplyevt" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data" onsubmit="return false;">
					<% End If %>
				<% else %>
						<form name="frmApplyevt" method="post" action="<%=staticImgUpUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data">
				<% end if %>
				<input type="hidden" name="evt_code" value="<%=evt_code%>" />
				<input type="hidden" id="apps" name="apps" value="apps">
				<input type="hidden" name="mode" value="">
				<input type="hidden" name="optname" value="">
				<input type="hidden" name="imgfile1" value="">
				<input type="hidden" name="device" value="<%= device %>">
					<% '' 청첩장 등록 했을 경우 %>
				<div class="attachPhoto">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/txt_event_2.png" alt="EVENT2.웨딩사진을 등록해주세요! 겨울엔 토스트가 좋아에서 5명을 추첨해 여러분의 웨딩사진을 그려드립니다." /></div>
					<% if subscriptcountsub < 1 then %>
						<dl>
							<dt><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/txt_attach_photo.png" alt="청첩장 첨부" /></dt>
							<dd>
							<% if isapp then %>
								<% If vProcess="A" Then %>
								<div class="addImage">
									<input type="hidden" name="file1" id="file1" value="">
									<button class="selectFile" onClick="fnAPPuploadImage(this.form.file1, '2');">파일선택</button>
									<div class="pic" id="imgspan2">이미지를 선택해주세요.</div>
								</div>
								<% Else %>
									<p><input name="file1" id="file1" type="file" class="addFile"/><p>
									<span class="pic"></span>
								<% End If %>
							<% else %>
								<p><input name="file1" id="file1" type="file" class="addFile"/><p>
								<span class="pic"></span>
							<% end if %>
								<input type="image" onclick="frmSubmitevt2(); return false;" class="btnSubmit" src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/btn_photo.png" alt="사진 제출하기" />
							</dd>
						</dl>
					<% end if %>
				</div>
				</form>
			<% end if %>
		</div>
		<!--// event2 -->

		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/73007/m/bg_gradation.png" alt="" /></div>
		<div class="evtNoti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>2016년 9월 1일 ~ 11월 30일 까지 결혼일(예정일)인 고객은 모두 이벤트에 참여 가능합니다.</li>
				<li>청첩장의 내용이 기입한 정보와 일치할 경우, 웨딩쿠폰은 청첩장 등록일 익일 2시 해당 ID로 자동 지급됩니다.<br />(단, 금/토/일 등록자는 월요일 오후 2시 일괄 지급)</li>
				<li>웨딩사진은 EVENT1 참여자에 한해 참여 할 수 있습니다.</li>
				<li>EVENT2는 5만원 이상 사은품으로 당첨자에게는 텐바이텐 고객센터를 통해 개인정보 요청 예정입니다. (제세공과금은 텐바이텐 부담)</li>
				<li>해당 이벤트에 기입한 정보는 비공개이며, 이벤트 종료 후 파기됩니다.</li>
			</ul>
		</div>
	</div>
	<!--// WEDDING MEMBERSHIP-->
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