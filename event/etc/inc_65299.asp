<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 잠자는 사자를 깨워라! 휴먼계정 고객 대상 event
' History : 2015.08.06 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
dim eCode, userid, currenttime
IF application("Svr_Info") = "Dev" THEN
	eCode = "64845"
Else
	eCode = "65299"
End If

currenttime = now()
'currenttime = #08/10/2015 14:05:00#

userid = getloginuserid()

dim getlimitcnt
getlimitcnt = 690

dim oUserInfo
set oUserInfo = new CUserInfo
	oUserInfo.FRectUserID = userid

	if (userid<>"") then
		oUserInfo.GetUserData
	end If

'//전체 응모자수 체크
dim vQuery, allcnt
vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"&eCode&"'"

'response.write vQuery & "<br>"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	allcnt = rsget(0)
End If
rsget.close()

'//본인 응모 확인
dim vTotalCount2
vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code='"&eCode&"' and userid = '" & userid & "'"

'response.write vQuery & "<br>"
rsget.Open vQuery,dbget,1
IF Not rsget.Eof Then
	vTotalCount2 = rsget(0)
End If
rsget.close()

'// 로그인후 휴먼고객 체크
dim totcnt
If userid <> "" Then
	vQuery = "SELECT count(*) FROM [db_user_hold].[dbo].[tbl_UHold_Target] "
	vQuery = vQuery & " WHERE userid = '"& userid &"'"

	'response.write vQuery & "<br>"
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End If
	rsget.close()
End If

'//태스트 계정
dim vadminconfirmyn
	vadminconfirmyn="N"
if userid="tozzinet" or userid="jinyeonmi" or userid="cogusdk" or userid="helele223" then
	vadminconfirmyn="Y"
	totcnt=1
end if
%>

<style type="text/css">
img {vertical-align:top;}
.mEvt65299 {background-color:#fff;}
.mEvt65299 .topic {position:relative;}
.topic .title {position:absolute; top:17%; left:50%; width:82.96%; margin-left:-41.48%;}
.topic .arm {position:absolute; top:22.4%; left:40.5%; width:9.68%;}

@-webkit-keyframes shake {
	0%, 100% {-webkit-transform:translateX(0);}
	10%, 30%, 50%, 70% {-webkit-transform:translateX(-10px);}
	20%, 40%, 60%, 80% {-webkit-transform:translateX(10px);}
}
@keyframes shake {
	0%, 100% {transform:translateX(0);}
	10%, 30%, 50%, 70% {transform:translateX(-10px);}
	20%, 40%, 60%, 80% {transform:translateX(10px);}
}
.shake {-webkit-animation-name:shake; animation-name:shake; -webkit-animation-duration:1.5s; animation-duration:1.5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:1; animation-iteration-count:1;}

.wake {overflow:hidden; position:relative; padding-bottom:4%; background-color:#522d13;}
.wake .btnwake {width:100%; background-color:transparent; vertical-align:top; outline:none;}
.wake .btnwake .pull {overflow:hidden; position:absolute; top:29%; left:0; width:40%; height:0; padding-bottom:22.25%; transition:left 0.5s;}
.wake .btnwake .pull span {position:absolute; top:0; left:0; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65299/img_hand_v3.png) no-repeat 0 0; background-size:100% auto;}
.wake .btnwake:active .pull {left:-2%;}
.wake .btnwake:active .pull span {background:url(http://webimage.10x10.co.kr/eventIMG/2015/65299/img_hand_v3.png) no-repeat 0 0; background-size:100% auto;}
.wake .btnwake .spit {position:absolute; top:59%; left:37.5%; width:4.53%;}
.pulse {animation-name:pulse; animation-duration:4s; animation-fill-mode:both; animation-iteration-count:5;}
.pulse {-webkit-animation-name:pulse; -webkit-animation-duration:4s; -webkit-animation-fill-mode:both; -webkit-animation-iteration-count:5;}
@keyframes pulse {
	0% {transform:scale(1);}
	50% {transform:scale(1.25);}
	100% {transform:scale(1);}
}
@-webkit-keyframes pulse {
	0% {-webkit-transform:scale(1);}
	50% {-webkit-transform:scale(1.25);}
	100% {-webkit-transform:scale(1);}
}

.wake .done {display:none;}
.wake .address {display:none; padding-top:12%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/65299/bg_roller.png) no-repeat 0 0; background-size:100% auto;}
.address .form {margin:0 3.9%; padding:0 5% 7%; background-color:#fff;}
.address .form .btnWrap {border-top:0;}
.address .navigator {overflow:hidden; margin-bottom:11px; border:1px solid #bebebe; border-radius:3px;}
.address .navigator li {float:left; width:50%; text-align:center;}
.address .navigator li a {display:block; padding:12px 0; background-color:#f4f7f7; color:#555; font-size:12px; font-weight:bold;}
.address .navigator li a.on {background-color:#bebebe; color:#fff;}
.address .userInfo .infoInput dt {width:60px;}
.address .userInfo .infoInput dd {margin-left:60px;}
.address .userInfo .btnWrap {margin-top:12px; padding-top:0;}

.address .noti {margin:0 3.9%; padding:7% 5%; background-color:#efefef;}
.address .noti h3 {font-size:12px;}
.address .noti ul li {padding-left:8px; color:#555; text-indent:-7px;}
.address .noti ul li:after {display:none;}

.noti {padding:10% 3.125%;}
.noti h3 {color:#000; font-size:14px;}
.noti h3 strong {padding-bottom:2px; border-bottom:2px solid #000;}
.noti ul {margin-top:5%;}
.noti ul li {position:relative; margin-top:2px; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:5px; left:0; width:4px; height:4px; border-radius:50%; background-color:#d60000;}

@media all and (min-width:480px){
	.address .navigator {margin-bottom:16px; border-radius:4px;}
	.address .navigator li a, .address .navigator li span {padding:18px 0; font-size:18px;}
	.address .userInfo .infoInput dt {width:90px;}
	.address .userInfo .infoInput dd {margin-left:90px;}
	.address .userInfo .btnWrap {margin-top:18px;}
	.address .noti h3 {font-size:18px;}
	.address .noti ul li {padding-left:10px; color:#555; text-indent:-9px;}

	.noti h3 {font-size:17px;}
	.noti ul li {margin-top:4px; padding-left:15px; font-size:13px;}
	.noti ul li:after {top:5px; width:5px; height:5px;}
}

@media all and (min-width:600px){
	.noti h3 {font-size:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

$(function(){
	/* tab */
	$(".address .navigator li a:first").addClass("on");
	//$(".tabsection").find(".section").hide();
	//$(".tabsection").find(".section:first").show();
	
	$(".address .navigator li a").click(function(){
		$(".address .navigator li a").removeClass("on");
		$(this).addClass("on");
		var thisCont = $(this).attr("href");
		if(thisCont=='#section1'){
			<%
			'//기본회원정보로 셋팅
			If oUserInfo.FresultCount >0 Then
			%>
				frmorder.reqname.value='<%=oUserInfo.FOneItem.FUserName%>';
				frmorder.reqhp1.value='<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>';
				frmorder.reqhp2.value='<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>';
				frmorder.reqhp3.value='<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>';
				frmorder.txZip1.value='<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>';
				frmorder.txZip2.value='<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>';
				frmorder.txAddr1.value='<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>';
				frmorder.txAddr2.value='<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>';
			<% end if %>
			frmorder.buttongubun.value='1';
		}else{
			frmorder.reqname.value='';
			frmorder.reqhp1.value='';
			frmorder.reqhp2.value='';
			frmorder.reqhp3.value='';
			frmorder.txZip1.value='';
			frmorder.txZip2.value='';
			frmorder.txAddr1.value='';
			frmorder.txAddr2.value='';
			frmorder.buttongubun.value='2';
		}
		return false;
	});

	$("#wake .btnwake").click(function(){
		<% If IsUserLoginOK() Then %>
			<% If not( left(currenttime,10)>="2015-08-10" and left(currenttime,10)<"2015-08-15" ) Then %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% else %>
				<% If vTotalCount2 > 0 Then %>
					alert('이벤트는 1회만 참여할 수 있습니다.');
				<% else %>
					<% if allcnt >= getlimitcnt then %>
						alert('죄송합니다\n사은품이 모두 소진 되었습니다.');
						return false;
					<% else %>
						var vadminconfirmyn='<%= vadminconfirmyn %>';
						if(vadminconfirmyn=='Y'){
							alert('텐바이텐에 2014년 8월 1일 부터 로그인하지 않아 휴면고객으로 분류되신 고객님들만 참여 가능합니다.');
							alert('관리자 계정으로 로그인 하셔서 다음 단계로 넘어갑니다.');
							alert('응모가 완료되었습니다.\n선물을 받으려면 주소를 입력해주세요!.');
							$("#wake .done, #wake .address").show();
							$("#wake .btnwake").hide();
						}else{
							<% if totcnt > 0 then %>
								alert('응모가 완료되었습니다.\n선물을 받으려면 주소를 입력해주세요!.');
								$("#wake .done, #wake .address").show();
								$("#wake .btnwake").hide();
							<% else %>
								alert('텐바이텐에 2014년 8월 1일 부터 로그인하지 않아 휴면고객으로 분류되신 고객님들만 참여 가능합니다.');
								return false;
							<% end if %>
						}
					<% end if %>
				<% end if %>
			<% end if %>
		<% Else %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
		<% End IF %>
	});

    <% if allcnt >= getlimitcnt then %>
        alert('죄송합니다. 마감되었습니다.');
    <% else %>
    	<% if Not(IsUserLoginOK) then %>
			<% if isApp=1 then %>
				calllogin();
				return false;
			<% else %>
				jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
				return false;
			<% end if %>
    	<% end if %>
    <% end if %>
});

function jseventSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2015-08-10" and left(currenttime,10)<"2015-08-15" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			if(!frm.reqname.value){
				alert("이름을 입력 해 주세요");
				frm.reqname.focus();
				return false;
			}
			if(!frm.reqhp1.value){
				alert("휴대폰번호를 입력 해주세요");
				frm.reqhp1.focus();
				return false;
			}		
			if(!frm.reqhp2.value){
				alert("휴대폰번호를 입력 해주세요");
				frm.reqhp2.focus();
				return false;
			}
			if(!frm.reqhp3.value){
				alert("휴대폰번호를 입력 해주세요");
				frm.reqhp3.focus();
				return false;
			}
			if (!IsDouble(frm.reqhp1.value)){
				alert('휴대폰번호는 숫자만 가능합니다.');
				frm.reqhp1.focus();
				return;
			}
			if (!IsDouble(frm.reqhp2.value)){
				alert('휴대폰번호는 숫자만 가능합니다.');
				frm.reqhp2.focus();
				return;
			}
			if (!IsDouble(frm.reqhp3.value)){
				alert('휴대폰번호는 숫자만 가능합니다.');
				frm.reqhp3.focus();
				return;
			}
			if(!frm.txZip1.value){
				alert("우편번호를 입력 해주세요");
				frm.txZip1.focus();
				return false;
			}
			if(!frm.txZip2.value){
				alert("우편번호를 입력 해주세요");
				frm.txZip2.focus();
				return false;
			}
			if (!IsDouble(frm.txZip1.value)){
				alert('우편번호는 숫자만 가능합니다.');
				frm.txZip1.focus();
				return;
			}
			if (!IsDouble(frm.txZip2.value)){
				alert('우편번호는 숫자만 가능합니다.');
				frm.txZip2.focus();
				return;
			}
			if (frm.txAddr1.value.length<1){
		        alert('수령지 도시 및 주를  입력하세요.');
		        frm.txAddr1.focus();
		        return false;
		    }
		    if (frm.txAddr2.value.length<1){
		        alert('수령지 상세 주소를  입력하세요.');
		        frm.txAddr2.focus();
		        return false;
		    }
			if (GetByteLength(frm.txAddr2.value)>80){
				alert('수령지 상세 주소가 너무 깁니다. 80byte이내로 작성해주세요.\n※한글 1글자는 2byte입니다.');
				frm.txAddr2.focus();
				return;
			}
			frm.target="evtFrmProc";
			frm.mode.value = "inst";
			frm.action = "/event/etc/doeventsubscript/doEventSubscript65299.asp";
			frm.submit();
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}

function IsDouble(v){
	if (v.length<1) return false;

	for (var j=0; j < v.length; j++){
		if ("0123456789.".indexOf(v.charAt(j)) < 0) {
			return false;
		}
	}
	return true;
}

</script>
</head>
<body>

<% '<!-- [M] 잠자는 사자를 깨워라! --> %>
<div class="mEvt65299">
	<div class="topic">
		<p class="title shake"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65299/txt_wake.png" alt="잠자는 사자를 깨워라!" /></p>
		<span class="arm"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65299/img_arm.png" alt="" /></span>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65299/txt_event_v1.gif" alt="여러분의 계정이 잠자고 있어요! 사자를 깨우면 잠들어있던 선물이 배송됩니다! 응모기간은 8월 10일부터 14일까지며, 배송은 8월 14일부터 순차적으로 배송됩니다." /></p>
		<figure><img src="http://webimage.10x10.co.kr/eventIMG/2015/65299/img_gift_v1.jpg" alt="사은품은 랜덤으로 발송됩니다." /></figure>
	</div>

	<div id="wake" class="wake">
		<button type="button" class="btnwake">
			<span class="pull"><span></span></span>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/65299/btn_wake_before_v1.png" alt="사자 깨우기! Touch" />
			<span class="spit pulse"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65299/img_spit.png" alt="" /></span>
		</button>

		<p class="done"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65299/txt_wake_after.gif" alt="사은품 받을 배송지 정보를 입력하고 사은품 받으세요" /></p>

		<div class="address">
			<div class="form userInfo userInfoEidt">
				<ul class="navigator">
					<li><a href="#section1" id="button1">기본 주소</a></li>
					<li><a href="#section2" id="button2">새로운 주소</a></li>
				</ul>

				<form name="frmorder" method="post" style="margin:0px;">
				<input type="hidden" name="mode">
				<input type="hidden" name="isapp" value="<%= isApp %>">
				<input type="hidden" name="buttongubun" value=1>
				<%If oUserInfo.FresultCount >0 Then %>
					<fieldset>
					<legend>배송지 정보 입력</legend>
						<dl class="infoInput">
							<dt><label for="receiver">이름</label></dt>
							<dd><input type="text" value="<%=oUserInfo.FOneItem.FUserName%>" name="reqname" id="receiver" value="텐텐텐" style="width:100%;" /></dd>
						</dl>
						<dl class="infoInput">
							<dt>주소</dt>
							<dd>
								<p>
									<span style="width:25%;">
										<input type="number" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) %>" name="txZip1" ReadOnly title="우편번호 앞자리" class="ct" style="width:100%;" />
									</span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:25%;" >
										<input type="number" value="<%= Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) %>" name="txZip2" ReadOnly title="우편번호 뒷자리" class="ct" style="width:100%;" />
									</span>
									&nbsp;<span class="button btS1 btGry cBk1"><a href="" onclick="TnFindZip('frmorder',''); return false;">우편번호 검색</a></span>
								</p>
								<p class="tPad05">
									<input type="text" name="txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>" title="기본 주소" style="width:100%;" />
								</p>
								<p class="tPad05">
									<input type="text" name="txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>" title="상세 주소" style="width:100%;" />
								</p>
							</dd>
						</dl>
						<dl class="infoInput">
							<dt>휴대전화</dt>
							<dd>
								<p>
									<span><input type="tel" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>" name="reqhp1" title="휴대전화 앞자리" style="width:100%;" class="ct" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="tel" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>" name="reqhp2" title="휴대전화 가운데자리" class="ct" style="width:100%;" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span style="width:30%;"><input type="tel" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>" name="reqhp3" title="휴대전화 뒷자리" class="ct" style="width:100%;" /></span>
								</p>
							</dd>
						</dl>

						<div class="btnWrap">
							<span class="button btB1 btRed cWh1 w100p"><button type="button" onclick="jseventSubmit(frmorder); return false;">사은품 신청 하기</button></span>
						</div>
					</fieldset>
				<% End If %>
				</form>
			</div>

			<div class="noti">
				<h3>주소입력시 유의사항</h3>
				<ul>
					<li>- 회원 정보에 있는 주소를 기본으로 불러옵니다.</li>
					<li>- 다른 주소로 사은품을 받을 시에는 새로운 주소를 클릭 후 주소를 써주세요.</li>
					<li>- 사은품 신청하기를 눌러야 신청이 완료되며, 완료된 후에는 주소를 변경 하실 수 없습니다.</li>
				</ul>
			</div>
		</div>
	</div>

	<div class="noti">
		<h3><strong>이 벤 트 유 의 사 항</strong></h3>
		<ul>
			<li>텐바이텐에 2014년 8월 1일 이후 로그인하지 않아 휴면고객으로 분류되신  고객님들만 참여 가능합니다.</li>
			<li>이벤트 기간동안 ID당 1회 참여 가능합니다.</li>
			<li>사은품은 한정수량이므로 본 이벤트는 조기 종료될 수 있습니다.</li>
		</ul>
	</div>
</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<% '<!-- //[M] 잠자는 사자를 깨워라! --> %>

</body>
</html>

<%
set oUserInfo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->