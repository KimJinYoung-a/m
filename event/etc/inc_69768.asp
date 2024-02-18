<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description :  [2016 S/S 웨딩] Wedding Membership
' History : 2016.03.16 유태욱
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
Dim vGubun, i, evt_code, userid, totalbonuscouponcountusingy, device

userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	evt_code   =  66067
Else
	evt_code   =  69768
End If

if isapp then
	device = "A"
else
	device = "M"
end if

dim subscriptcount
subscriptcount=0
totalbonuscouponcountusingy=0

'' 실섭 833,834,835,836,837
'' 테섭 2774,2775,2776,2777,2778
		
'//본인 참여 여부
if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(evt_code, userid, "", "", "")
	totalbonuscouponcountusingy = getbonuscoupontotalcount("2774,2775,2776,2777,2778", "N", "Y","")
end if

Dim vImgURL
vImgURL = staticImgUrl & "/contents/contest/" & evt_code & "/"

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
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.weddingMembership {overflow:hidden;}
.weddingMembership button {background-color:transparent;}
.weddingMembership legend {visibility:hidden; width:0; height:0;}
.weddingMembership table caption {visibility:hidden; width:0; height:0;}

.topic {position:relative;}
.topic h2 {position:absolute; top:6%; left:0; width:100%;}
.topic h2 {animation-name:pulse; animation-timing-function:linear; animation-duration:2s; animation-fill-mode:both; animation-iteration-count:1;}
.topic h2 {-webkit-animation-name:pulse; -webkit-animation-timing-function:linear; -webkit-animation-duration:2s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:1;}
@keyframes pulse {
	0% {transform:scale(0.9);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(0.9);}
	100% {-webkit-transform:scale(1);}
}

.topic .btnRegister {position:absolute; bottom:6%; left:50%; width:78.12%; margin-left:-39.06%;}

.lyRegister {display:none; position:absolute; top:8%; left:50%; z-index:60; width:93.75%; margin-left:-46.875%; padding-bottom:10%; border-radius:20px; background-color:#fbfbfb;}
.lyRegister .form {position:relative; padding:10% 6% 0;}
.lyRegister .btnClose {position:absolute; top:1.5%; right:3%; width:8.3%;}

#mask {display:none; position:absolute; top:0; left:0; z-index:55; width:100%; height:100%; background:rgba(0,0,0,.6);}

.table {margin-top:2.2rem;}
.table th, .table td {padding:1.2rem 0; border-bottom:1px solid #f0f0f0; color:#828080; font-size:1.2rem; line-height:1.5em; vertical-align:top;}
.table th {position:relative; width:32%; color:#d1b67f; font-weight:bold; text-align:left;}
.table th span {display:block; position:relative; padding-left:1.2rem;}
.table th span:after {display:block; content:' '; position:absolute; top:0.5rem; left:0; width:0.6rem; height:0.6rem; background-color:#d1b67f; transform:rotate(-45deg); -webkit-transform:rotate(-45deg);}
.table td {width:68%; padding-right:0.5rem;}
.table td input[type=text], .table td input[type=file] {width:100%; height:3.4rem; border:1px solid #ddd; border-radius:0; background-color:#fff; color:#828080; font-size:1.2rem;}

::-webkit-input-placeholder {color:#cdcdcd;}
::-moz-placeholder {color:#cdcdcd;} /* firefox 19+ */
:-ms-input-placeholder {color:#cdcdcd;} /* ie */
input:-moz-placeholder {color:#cdcdcd;}

.table td p {margin-top:0.8rem; color:#cdcdcd; font-size:1.1rem;}
.table td b {padding-left:1rem;}
.table tr:nth-child(1) th, .table tr:nth-child(1) td {padding-top:0;}
.table tr:nth-child(1) td input:first-child {border:0; background:transparent; height:auto; margin-bottom:1rem;}
.table tr:nth-child(2) th, .table tr:nth-child(3) th {padding-top:2rem;}
.table tr:nth-child(3) td {overflow:hidden;}
.table tr:nth-child(3) td b, .table tr:nth-child(3) td input {float:left;}
.table tr:nth-child(3) td b {width:40%; padding-top:0.8rem;}
.table tr:nth-child(3) td input {float:right; width:60%;}

.check .noti {padding:4.53%; background-color:#f3f3f3;}
.check .noti h4 {color:#d1b376; font-size:1.1rem; font-weight:bold;}
.check .noti ul {margin-top:1rem; padding:0;}
.check .noti ul li {font-size:1.1rem; color:#9b9b9b}
.check .noti ul li:after {top:0.7rem; background-color:#9b9b9b;}

.check .policy {overflow-y:scroll; -webkit-overflow-scrolling:touch; height:10rem; margin-top:2rem; padding:1rem 1.2rem; border:1px solid #ddd; background-color:#fff; color:#828080; font-size:1rem; line-height:1.375em;}
.check .policy h4 {visibility:hidden; width:0; height:0;}
.policy h4 + h5 {margin-top:0;}
.policy h5, .policy h6 {margin-top:1rem;}

.form .btnarea {margin-top:3.2rem;}
.form .btnarea input {width:100%;}
.form .btnarea p {margin-top:0.8rem; color:#db4143; text-align:center;}

.agree {margin-top:2rem;}
.agree li {margin-top:1rem; padding-left:2rem; color:#888; font-size:1rem; line-height:1.6em; text-indent:-2rem;}
.agree li:first-child {margin-top:0;}
.agree input {width:1.6rem; height:1.6rem; border-radius:50%; vertical-align:top;}
.agree input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}

.benefit .desc {position:relative;}
.benefit .desc button {position:absolute; bottom:26%; left:50%; width:67.18%; margin-left:-33.59%;}
.benefit .desc2 button {bottom:21%;}

.noti {padding-bottom:8%; background-color:#f6f6f7;}
.noti ul {padding:0 4.53%;}
.noti ul li {position:relative; margin-top:0.2rem; padding-left:1rem; color:#9e9e9e; font-size:1.1rem; line-height:1.5em;}
.noti ul li:first-child {margin-top:0;}
.noti ul li:after {content:' '; display:block; position:absolute; top:0.5rem; left:0; width:0.4rem; height:0.1rem; background-color:#9e9e9e;}

.addImage {overflow:hidden; position:relative; padding:0.5rem; border:1px solid #ddd; border-radius:0.2rem; background:#fff;}
.addImage .selectFile {float:left; width:30%; padding:0.5rem 0; border:1px solid #bebebe; border-radius:0.2rem; background:#dadddd; color:#000; font-size:1rem;}
.addImage .pic {overflow:hidden; float:left; width:70%; font-size:1rem; letter-spacing:-0.05em;}
</style>
<script type="text/javascript">
$(function(){
	/* layer */
	$("#btnRegister").click(function(){
		$("#lyRegister").show();
		$("#mask").show();
		var val = $("#lyRegister").offset();
		$("html,body").animate({scrollTop:val.top},100);
	});

	$("#lyRegister .btnClose, #mask").click(function(){
		$("#lyRegister").hide();
		$("#mask").fadeOut("fast");
	});
});

function SubmitForm(frm){
<% If IsUserLoginOK() Then %>
	<% If Now() > #04/28/2016 23:59:59# Then %>
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

			frm.optname.value = frm.myArea1.value+"/!/"+frm.myArea2.value+"/!/N";

			if (confirm("입력사항이 정확합니까?") == true){
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

function jsdailychk(){
<% If IsUserLoginOK() Then %>
	<% If Now() > #04/28/2016 23:59:59# Then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
		<% if totalbonuscouponcountusingy > 0 then %>
			var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript69768.asp",
				data: "mode=daily",
				dataType: "text",
				async:false,
				cache:false,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="22")
					{
						alert('이미 응모 하셨습니다.');
						return;
					}
					else if (result.resultcode=="44")
					{
						alert('로그인이 필요한 서비스 입니다.');
						return;
					}
					else if (result.resultcode=="11")
					{
						alert('응모가 완료 됬습니다.');
						location.reload();
						return;
					}
					else if (result.resultcode=="88")
					{
						alert('이벤트 기간이 아닙니다.');
						return;
					}
					else if (result.resultcode=="66")
					{
						alert('잘못된 접속 입니다.');
						return;
					}
				}
			});
		<% else %>
			alert('청첩장 제출을 한 후\n발급된 쿠폰을 사용시\n응모 가능 합니다.');
			return;
		<% end if %>
	<% end if %>
<% Else %>
	<% if isApp then %>
		parent.calllogin();
	<% else %>
		parent.jsevtlogin();
	<% end if %>
<% End IF %>
	
}

function showmycouponnbook() {
	<% if isapp then %>
		fnAPPpopupBrowserURL('쿠폰북','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/couponbook.asp');
	<% else %>
		top.location.href = "/my10x10/couponbook.asp";
	<% end if %>
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
	_selComp = comp;
	_no = no;

	var paramname = comp.name;
	var upurl = "<%=staticImgUrl%>/linkweb/enjoy/test_doevaluatewithimage_android_onlyimageupload.asp?evtcode=<%=evt_code%>&paramname="+paramname;
	if (no=="1"){
		callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish1});
	}else if(no=="2"){
		callNativeFunction('uploadImage', {"upurl":upurl,"paramname":paramname,"callback": appUploadFinish2});
	}
	return false;
}

function _appUploadFinish(ret,ino){
   //alert("["+ino+"]");
	if (_selComp){
		_selComp.value=ret.name;
		$('#imgspan'+ino).empty();
		$('#imgspan'+ino).text(ret.name);
		document.FrmGoodusing.imgfile1.value = ret.name;
	}
}

function appUploadFinish1(ret){
	_appUploadFinish(ret,1);
}
</script>

<div class="mEvt69883 weddingMembership">
	<article>
		<div class="topic">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/tit_wedding_membership.png" alt="소중한 나의 웨딩 스토리 Wedding Membership" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/txt_way.jpg" alt="텐바이텐이 여러분의 소중한 시작을 응원합니다! 청첩장을 등록하고 특별한 혜택을 받으세요! 대상은 2016년 3월 1일부터 6월 30일까지 결혼일 예정일인 고객이며, 모집방법은 아이디와 고객명과 동일한 청첩장 업로드해주세요" /></p>
			<div id="btnRegister" class="btnRegister"><a href="#lyRegister"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/btn_register.png" alt="청첩장 등록하기" /></a></div>
		</div>

		<!-- layer -->
		<div id="lyRegister" class="lyRegister">
			<div class="form">
				<% if isapp then %>
					<% If vProcess="A" then %>
						<form name="FrmGoodusing" method="post" action="<%=staticImgUrl%>/linkweb/enjoy/do_test_evaluatewithimage_app.asp"  onsubmit="return false;">
					<% Else %>
						<form name="FrmGoodusing" method="post" action="<%=staticImgUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data" onsubmit="return false;">
					<% End If %>
				<% else %>
						<form name="FrmGoodusing" method="post" action="<%=staticImgUrl%>/linkweb/enjoy/do_test_evaluatewithimage_mobile.asp" EncType="multipart/form-data">
				<% end if %>
				<input type="hidden" name="evt_code" value="<%=evt_code%>" />
				<input type="hidden" id="apps" name="apps" value="apps">
				<input type="hidden" name="mode" value="">
				<input type="hidden" name="optname" value="">
				<input type="hidden" name="imgfile1" value="">
				<input type="hidden" name="device" value="<%= device %>">

					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/tit_invitation_register.png" alt="청첩장 등록하기" /></h3>

					<!-- for dev msg : 청첩장 정보 등록 폼-->
					<div class="table">
						<fieldset>
						<legend>청첩장 정보 등록 폼</legend>
							<table>
								<caption>나의 정보, 배우자 정보, 결혼 예정일, 청첩장 이미지 첨부</caption>
								<tbody>
								<tr>
									<th scope="row"><span>나의 정보</span></th>
									<td>
										<input type="text" title="아이디" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="<%= userid %>"<% END IF %> readonly="readonly" />
										<input type="text" title="이름" name="myArea1" onClick="jsCheckLimit('ta1');" onKeyUp="jsCheckLimit('ta1');" placeholder="ex) 홍길동" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="ex) 홍길동"<% END IF %> />
									</td>
								</tr>
								<tr>
									<th scope="row"><span>배우자 정보</span></th>
									<td>
										<input type="text" title="배우자 이름" name="myArea2" onClick="jsCheckLimit('ta2');" onKeyUp="jsCheckLimit('ta2');" placeholder="ex) 홍길동" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="ex) 홍길동"<% END IF %> />
										<p>※ 청첩장 정보와 일치여부 판단하기 위해 기입</p>
									</td>
								</tr>
								<tr>
									<th scope="row"><span>결혼(예정)일</span></th>
									<td>
										<b>2016년</b>
										<input type="number" title="결혼(예정)일" oninput="maxLengthCheck(this)" onClick="jsCheckLimit('ta3');" onKeyUp="jsCheckLimit('ta3');" name="myArea3" placeholder="0000" maxlength="4" <% IF NOT(IsUserLoginOK) THEN %>value="로그인을 해주세요."<% else %>value="0000"<% END IF %> />
									</td>
								</tr>
								<tr>
									<th scope="row"><span>청첩장<br />이미지 첨부</span></th>
									<td>
										<% if isapp then %>
											<% If vProcess="A" Then %>
											<div class="addImage">
												<input type="hidden" name="file1" id="file1" value="">
												<button class="selectFile" onClick="fnAPPuploadImage(this.form.file1, '1');">파일선택</button>
												<span class="pic" id="imgspan1">이미지를 선택해주세요.</span>
											</div>
											<% Else %>
												<input name="file1" id="file1" type="file" /> 
													<span class="pic"></span>
											<% End If %>
										<% else %>
											<input name="file1" id="file1" type="file" />
											<span class="pic"></span>
										<% end if %>
										<p>※ 최대 2mb, JPG(JPEG) 파일</p>
									</td>
								</tr>
								</tbody>
							</table>
						</fieldset>
					</div>

					<!-- for dev msg : 개인정보 취급방침 -->
					<div class="check">
						<fieldset>
						<legend>텐바이텐 Wedding Membership 개인정보 취급방침</legend>
							<div class="noti">
								<h4>공지사항</h4>
								<ul>
									<li>2016.3.1 ~ 6.30까지 결혼(예정)일인 고객 모두 등록 가능합니다.</li>
									<li>기입해주신 고객명, 배우자명이 청첩장과 동일해야 합니다.</li>
									<li>평일 자정까지 업로드 한 고객에 한하여 익일 오후 2시 일괄 승인됩니다.<br /> (금/토/일 등록자는 월요일 일괄승인)</li>
									<li>기입한 정보는 비공개이며, 이벤트 종료 후 파기 됩니다.</li>
								</ul>
							</div>

							<div class="policy">
								<h4>텐바이텐 Wedding Membership 개인정보 취급방침</h4>
								<h5>[수집하는 개인정보 항목 및 수집방법]</h5>
								<h6>1. 수집하는 개인정보의 항목</h6>
								<p>회사는 해당이벤트의 원활한 고객상담, 각종 서비스의 제공을 위해 아래와 같은 최소한의 개인정보를 필수항목을 수집하고 있습니다. - 아이디, 비밀번호, 이름, 성별, 생년월일, 이메일주소, 휴대폰번호, 가입인증정보</p>
								<h6>2. 개인정보 수집에 대한 동의</h6>
								<p>회사는 귀하께서 텐바이텐의 개인정보취급방침에 따른 이벤트 이용약관의 내용에 대해 「동의한다」버튼 또는 「동의하지 않는다」버튼을 클릭할 수 있는 절차를 마련하여, 「동의한다」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.</p>

								<h5>[개인정보의 수집목적 및 이용 목적]</h5>
								<ul>
									<li>1. 이벤트 참여를 위한 관련 정보 수집 및 증빙 확인 목적</li>
									<li>2. 고지사항 전달, 본인 의사 확인, 불만 처리 등 원활한 의사소통 경로의 확보</li>
								</ul>

								<h5>[개인정보의 보유 및 파기 절차]</h5>
								<p>1. 설문조사, 이벤트 등 일시적 목적을 위하여 수집한 경우 : 당해 설문조사, 이벤트 등의 종료 시점</p>
								<p>2. 회사는 원칙적으로 개인정보 수집 및 이용목적이 달성되면 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.</p>
								<ul>
									<li>① 파기절차 : 귀하가 이벤트등록을 위해 입력하신 정보는 이벤트가 완료 된 후 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라 일정 기간 저장된 후 파기되어집니다.</li>
									<li>② 파기대상 : 배우자 정보, 결혼 예정일, 청첩장 이미지</li>
								</ul>
							</div>

							<ul class="agree">
								<li>
									<input type="radio" id="agreeYes" value="Y" name="agreecheck" />
									<label for="agreeYes">텐바이텐 개인정보취급방침에 따라, 본 이벤트 참여를 위한 개인정보 취급방침에 동의합니다.</label>
								</li>
								<!--
								<li>
									<input type="radio" id="agreeNo" value="N" name="agreecheck" />
									<label for="agreeNo">동의하지 않습니다.</label>
								</li>
								-->
							</ul>
						</fieldset>

						<div class="btnarea">
							<input type="image" onClick="SubmitForm(FrmGoodusing); return false;" src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/btn_submit.png" alt="청첨장 제출하기" />
							<p>* 공지사항을 꼭 확인 후 제출하세요!</p>
						</div>
					</div>
				</form>

				<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
		<!-- //layer -->

		<div class="benefit">
			<div class="desc desc1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/txt_benefit_01.png" alt="청접장을 등록하면 살림에 보탬이 되는 웨딩쿠폰 5종 세트를 자동으로 발급해 드립니다. 20만원 이상 구매 시 2만원, 50만원 이상 구매시 6만원, 100만원 이상 구매시 15만원 할인 쿠폰을 드리며, 텐바이텐 무료배송 쿠폰 2장을 드립니다. 발급 기간은 2016년 4월 24일 일요일까지며 텐바이텐 전 채널에서 사용가능하며, 사용기간은 발급일로부터 3개월입니다. 웨딩 5종 쿠폰은 청첩장 등록일 익일에 해당 아이디로 자동발급되며 금, 토, 일요일 등록자는 월요일에 일괄발급 됩니다." /></p>
				<button type="button" onclick="showmycouponnbook(); return false;" class="btnCoupon"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/btn_coupon.png" alt="쿠폰 확인하기" /></button>
			</div>
			<div class="desc desc2">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/txt_benefit_02.png" alt="웨딩 쿠폰을 사용하여 구매하면 추첨을 통해 10명에게 5만원 권 기프트 카드를 드립니다. 응모기간은 2016년 4월 24일 일요일까지며, 당첨자 발표는 2016년 5월 2일 월요일입니다. 사용기간은 제한 없음" /></p>
				<button type="button" onclick="jsdailychk(); return false;" class="btnEnter"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/btn_enter.png" alt="응모하기" /></button>
			</div>
		</div>

		<div class="bnr">
			<p><a href="eventmain.asp?eventid=69755" title="2016 웨딩 이벤트 바로가기"><img src="http://webimage.10x10.co.kr/eventIMG/2016/69755/m/img_bnr_wedding.png" alt="2016 웨딩 기프트 설레이는 그 날을 위해 텐바이텐이 준비한 특별한 선물" /></a></p>
		</div>
		
		<section class="noti">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/69768/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
			<ul>
				<li>2016년 3월1일 ~ 6월30일 까지 결혼일(예정일)인 고객은 모두 등록 가능합니다.</li>
				<li>청첩장의 내용이 기입한 정보와 일치할 경우, 웨딩쿠폰은 청첩장 등록일 익일 2시 해당ID로 자동 지급됩니다.<br /> (단, 금/토/일 등록자는 월요일 오후 2시에 일괄 지급)</li>
				<li>해당 이벤트에 기입한 정보는 비공개이며, 이벤트 종료 후 파기 됩니다</li>
			</ul>
		</section>

		<div id="mask"></div>
	</article>
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
    FnIsAndroidKiKatUp = FnIsAndroidKiKatUp or (InStr(iiAgent,"android 5")>0) or (InStr(iiAgent,"android 6")>0)
    
end function

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->