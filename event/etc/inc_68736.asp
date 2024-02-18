<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
'#############################################################
'	Description : 사람은 돌아오는거야 M
'	History		: 2015.01.20 유태욱 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->

<%
Dim chkid, eCode
dim currenttime
	currenttime =  now()

'														currenttime = #01/23/2016 09:00:00#

IF application("Svr_Info") = "Dev" THEN
	eCode   =  66005
Else
	eCode   =  68736
End If

chkid = GetEncLoginUserID()

If IsUserLoginOK() Then
	Dim oUserInfo
	Set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = chkid
	If (chkid<>"") then
	    oUserInfo.GetUserData
	End If
end if
%>
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt68736 {overflow:hidden; position:relative; background:#f5c061;}
.intro {position:absolute; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,.85); z-index:100;}
.intro .click {position:absolute; left:0; top:8%; width:100%; height:30%; z-index:50; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68588/m/bg_blank.png) repeat 0 0; background-size:100% 100%; text-indent:-999em; cursor:pointer;}
.catchBall {position:relative; padding-bottom:2rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68736/m/bg_ground.png) repeat-y 0 0; background-size:100% auto;}
.catchBall .date {position:absolute; left:0; top:61%; width:100%;}
.catchBall .ball {display:block; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/68736/m/btn_ball.png) no-repeat 50% 50%; background-size:100%;}
.catchBall .scene02 .ball {background-image:url(http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_ball.png); background-size:20%;}
.catchBall .scene03 {text-align:center;}
.catchBall .scene03 h3 {font-size:1.6rem; color:#343434; font-weight:bold;}
.catchBall .scene03 .enterAddr {width:84%; margin:0 auto 1.2rem; text-align:center; padding:0.5rem; background:#343434; border-radius:0.5rem;}
.catchBall .scene03 .deliverInfo {padding:1.5rem; border-radius:0.4rem; background:#fff; box-shadow:0 -2px 8px 1px rgba(0,0,0,.2) inset;}
.catchBall .scene03 .deliverInfo dl {overflow:hidden; padding-top:2rem; text-align:left;}
.catchBall .scene03 .deliverInfo dt {padding-bottom:1rem; font-size:1.3rem; color:#555; font-weight:600;}
.catchBall .scene03 .deliverInfo dd {display:table; width:100%;}
.catchBall .scene03 .deliverInfo dd span {display:table-cell; vertical-align:middle; color:#777;}
.catchBall .scene03 .deliverInfo dd input {width:100%;}
.catchBall .scene03 .deliverInfo .btnPost {display:block; width:10rem; height:3.2rem; line-height:3.3rem; margin-left:0.4rem; font-weight:bold; text-align:center; font-size:1.1rem; color:#fff; background:#343434; border-radius:0.4rem;}
.catchBall .scene03 .btnApply {display:block; width:88%; margin:0 auto;}
.catchBall .speedometer {position:relative;}
.catchBall .speedometer .km01 {position:absolute; left:0; top:0; width:100%;}
.evtNoti {color:#fff; padding:2rem 4.8%; background:#384337;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68736/m/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:1rem; font-size:1.1rem; line-height:1.4;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.4rem; height:1px; background:#fff;}
</style>
<script type="text/javascript">
$(function(){
	$(".intro .click").click(function(){
		$(".intro").fadeOut(300);
	});
	$(".scene01 .ball").click(function(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-22" and left(currenttime,10)<"2017-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript68736.asp",
				data: "mode=ballstart",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.chcode=="55")
					{
						alert("잘못된 접속 입니다.");
						return;
					}
					else if (result.chcode=="77")
					{
						alert("신청하려면 로그인을 해야합니다.");
						return;
					}
					else if (result.chcode=="88")
					{
						alert("이벤트 기간이 아닙니다.");
						return;
					}
					else if (result.chcode=="99")
					{
						alert("이벤트 대상자가 아닙니다.");
						return;
					}
					else if (result.chcode=="999")
					{
						alert("오류 입니다.");
						return;
					}
					else if (result.chcode=="44")
					{
						window.parent.$('html,body').animate({scrollTop:$('#catchBall').offset().top}, 800);
						$(".scene01").hide();
						$(".scene02").show();
						playBall();
					}
				}
			});

		<% end if %>
	<% else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return;
		<% end if %>	
	<% end if %>
	});
	$(".scene02").hide();
	$(".scene03").hide();
	function playBall() {
		$('.scene02 .ball').delay(100).animate({backgroundSize:'100%'},700);
		$(".scene02 .km01").delay(800).hide(1);
		$(".scene02").delay(1400).fadeOut(50);
		$(".scene03").delay(1400).fadeIn(50);
	}
});

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-22" and left(currenttime,10)<"2017-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
//			if (document.frmorder.reqname.value == ''){
//				alert('이름을 입력해 주세요.');
//				document.frmorder.reqname.focus();
//				return;
//			}

			if (jsChkBlank(document.frmorder.userphone1.value)||document.frmorder.userphone1.value.length<3){
			    alert("전화번호를 입력해주세요");
				document.frmorder.userphone1.focus();
				return ;
			}

			if (jsChkBlank(document.frmorder.userphone2.value)||document.frmorder.userphone2.value.length<3){
			    alert("전화번호를 입력해주세요");
				document.frmorder.userphone2.focus();
				return ;
			}
		
			if (jsChkBlank(document.frmorder.userphone3.value)||document.frmorder.userphone3.value.length<4){
			    alert("전화번호를 입력해주세요");
				document.frmorder.userphone3.focus();
				return ;
			}
		
			if (!jsChkNumber(document.frmorder.userphone1.value) || !jsChkNumber(document.frmorder.userphone2.value) || !jsChkNumber(document.frmorder.userphone3.value)){
			    alert("전화번호는 공백없는 숫자로 입력해주세요.");
				document.frmorder.userphone1.focus();
				return ;
			}

//			if (jsChkBlank(document.frmorder.reqhp1.value)||document.frmorder.reqhp1.value.length<3){
//			    alert("휴대전화 번호를 입력해주세요");
//				document.frmorder.reqhp1.focus();
//				return ;
//			}
//
//			if (jsChkBlank(document.frmorder.reqhp2.value)||document.frmorder.reqhp2.value.length<3){
//			    alert("휴대전화 번호를 입력해주세요");
//				document.frmorder.reqhp2.focus();
//				return ;
//			}
//		
//			if (jsChkBlank(document.frmorder.reqhp3.value)||document.frmorder.reqhp3.value.length<4){
//			    alert("휴대전화 번호를 입력해주세요");
//				document.frmorder.reqhp3.focus();
//				return ;
//			}
//		
//			if (!jsChkNumber(document.frmorder.reqhp1.value) || !jsChkNumber(document.frmorder.reqhp2.value) || !jsChkNumber(document.frmorder.reqhp3.value)){
//			    alert("휴대전화 번호는 공백없는 숫자로 입력해주세요.");
//				frm.usercell2.focus();
//				return ;
//			}

			if (document.frmorder.txZip2.value.length<3){
				alert('우편번호를 입력해 주세요.');
				document.frmorder.txZip2.focus();
				return;
			}

			if (document.frmorder.txAddr2.value.length<1){
				alert('나머지 주소를 입력해 주세요.');
				document.frmorder.txAddr2.focus();
				return;
			}

			if (GetByteLength(document.frmorder.txAddr2.value)>80){
				alert('나머지 주소가 너무 깁니다. 80byte이내로 작성해주세요.\n※한글 1글자는 2byte입니다.');
				document.frmorder.txAddr2.focus();
				return;
			}

			var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript68736.asp",
				data: $("#frmorder").serialize(),
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);

					if (result.chcode=="55")
					{
						alert("잘못된 접속 입니다.");
						return;
					}
					else if (result.chcode=="77")
					{
						alert("신청하려면 로그인을 해야합니다.");
						return;
					}
					else if (result.chcode=="88")
					{
						alert("이벤트 기간이 아닙니다.");
						return;
					}
					else if (result.chcode=="22")
					{
						alert("이미 신청하셨습니다.");
						return;
					}
					else if (result.chcode=="99")
					{
						alert("이벤트 대상자가 아닙니다.");
						return;
					}
					else if (result.chcode=="66")
					{
						alert("주소 입력이 잘못되었습니다.");
						return;
					}
					else if (result.chcode=="33")
					{
						alert("신청이 완료 되었습니다.");
						return;
					}
					else if (result.chcode=="999")
					{
						alert("오류 입니다.");
						return;
					}
				}
			});
		<% end if %>
	<% Else %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return;
		<% end if %>	
	<% End IF %>
}

function jsCheckLimit() {
	<% If not(IsUserLoginOK()) Then %>
		<% If isApp="1" or isApp="2" Then %>
			calllogin();
			return false;
		<% else %>
			jsevtlogin();
			return;
		<% end if %>
	<% end if %>
}
</script>
	<div class="mEvt68736">
		<div class="intro">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/txt_intro.png" alt="오랫동안 돌아오지않은 여러분을 위해 준비했습니다." /></p>
			<span class="click">눌러보세요</p>
		</div>

		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/tit_comeback.png" alt="사람은 돌아오는거야" /></h2>
		<div class="catchBall" id="catchBall">
			<div class="scene01">
				<a href="#catchBall" class="ball"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/bg_ball.png" alt="공을 눌러서 던져보세요" /></a>
				<p class="date"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/txt_date.png" alt="배송날짜 : 2월 29일~(순차배송)" /></p>
				<div class="speedometer"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_speedometer_01.gif" alt="" /></div>
			</div>
			<div class="scene02">
				<div class="ball"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/bg_ball.png" alt="" /></div>
				<div class="speedometer">
					<p class="km01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_speedometer_02.gif" alt="" /></p>
					<p class="km02"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_speedometer_03.gif" alt="" /></p>
				</div>
			</div>


			<form name="frmorder" id="frmorder" onSubmit="return false;" method="post">
			<input type="hidden" name="mode" value="balladd">

			<div class="scene03">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/txt_catch.png" alt="" /></p>
				<div class="enterAddr">
					<div class="deliverInfo">
						<h3>배송지정보</h3>
						<dl>
							<dt><label for="name">이름</label></dt>
							<dd><span><input type="text" class="txtInp" name="reqname" id="name" disabled maxlength="10" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<%=GetLoginUserName%>" /></span></dd>
						</dl>
						<dl>
							<dt><label for="up01">전화번호</label></dt>
							<dd>
								<span><input type="text" name="userphone1" id="up01" maxlength="3" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) end if %>" title="전화번호 국번 입력" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span><input type="text" name="userphone2" id="up02" maxlength="4" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) end if %>" title="전화번호 가운데자리 입력" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span><input type="text" name="userphone3" id="up03" maxlength="4" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) end if %>" title="전화번호 뒷자리 입력" /></span>
							</dd>
						</dl>
						<!--
						<dl>
							<dt><label for="hp01">휴대전화</label></dt>
							<dd>
								<span><input type="text" name="reqhp1" id="hp01" maxlength="3" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<%'' If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) end if %>" title="휴대전화 국번 입력" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span><input type="text" name="reqhp2" id="hp02" maxlength="4" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<%'' If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) end if %>" title="휴대전화 가운데자리 입력" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span><input type="text" name="reqhp3" id="hp03" maxlength="4" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<%'' If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) end if %>" title="휴대전화 뒷자리 입력" /></span>
							</dd>
						</dl>
						-->
						<dl>
							<dt>주소</dt>
							<dd>
								<span><input type="text" name="txZip1" readOnly onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) end if %>" title="우편번호 앞자리" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span><input type="text" name="txZip2" readOnly onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) end if %>" title="우편번호 뒷자리" /> </span>
								<% If IsUserLoginOK() Then %>
									<span><a href="" onclick="TnFindZip('frmorder',''); return false;" class="btnPost">우편번호 검색</a><span>
								<% end if %>
							</dd>
							<dd class="tMar05"><span><input type="text" name="txAddr1" readOnly onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write doubleQuote(oUserInfo.FOneItem.FAddress1) end if %>" /></span></dd>
							<dd class="tMar05"><span><input type="text" name="txAddr2" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write doubleQuote(oUserInfo.FOneItem.FAddress2) end if %>" title="상세주소 입력" /></span></dd>
						</dl>
					</div>
				</div>
				<p class="tip"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/txt_tip.png" alt="" /></p>
				<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/btn_apply.png" onclick="jsSubmit(); return false;" alt="사은품 신청하기" class="btnApply" />
			</div>

			</form>
		</div>
		<div class="evtNoti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>본 이벤트는 텐바이텐 휴면 정책에 따라 1년간 로그인하지 않은 고객대상으로 진행되는 이벤트입니다.</li>
				<li>배송지 주소는 회원정보의 기본주소지이며, 수정 할 수 있습니다.</li>
				<li>경품 신청 후에는 주소 변경이 불가합니다.</li>
				<li>본 사은품은 한정수량으로 조기에 선착순 마감될 수 있으며, 2월 29일부터 배송 될 예정입니다.</li>
				<li>경품은 현금 성 환불 및 옵션 선택이 불가합니다.</li>
			</ul>
		</div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->