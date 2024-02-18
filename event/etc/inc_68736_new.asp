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
'	History		: 2016.06.07 유태욱 수정,추가(쿠폰발급)
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->

<%
Dim chkid, eCode
dim subscriptcount, subscripttotalcount
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

'//본인 참여 여부
if chkid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, chkid, "", "", "201606")
end if

'//총 참여수
subscripttotalcount = getevent_subscripttotalcount(eCode, "", "", "201606")
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
.catchBall {position:relative; padding-bottom:7%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68736/m/bg_ground.png) repeat-y 0 0; background-size:100% auto;}
.catchBall .date {position:absolute; left:0; top:61%; width:100%;}
.catchBall .ball {display:block; width:100%; background:transparent url(http://webimage.10x10.co.kr/eventIMG/2016/68736/m/btn_ball.png) no-repeat 50% 50%; background-size:100%;}
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

.catchBall .scene05 button {display:block; width:88.125%; margin:5.5% auto 0; background-color:transparent;}

.evtNoti {color:#fff; padding:2rem 4.8%; background:#384337;}
.evtNoti h3 {padding-bottom:1.2rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.4rem; line-height:2rem; padding-left:2.5rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68736/m/ico_mark.png) no-repeat 0 0; background-size:1.9rem 1.9rem;}
.evtNoti li {position:relative; padding-left:1rem; font-size:1.1rem; line-height:1.4;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.4rem; height:1px; background:#fff;}
</style>
	<div class="mEvt68736">
		<div class="intro" style="display:none;">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/txt_intro.png" alt="오랫동안 돌아오지않은 여러분을 위해 준비했습니다." /></p>
			<span class="click">눌러보세요</p>
		</div>

		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/tit_comeback_v1.png" alt="사람은~ 돌아오는거야아래 공을 한번 눌러보세요! 놀라운 선물이 당신을 찾아갑니다!" /></h2>
		<div class="catchBall" id="catchBall">
			<div class="scene01">
				<button class="ball"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/bg_ball.png" alt="공을 눌러서 던져보세요" /></button>
				<div class="speedometer"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_speedometer_01.gif" alt="" /></div>
			</div>

			<% if subscripttotalcount < 280 then %>
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
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/txt_catch_v2.jpg" alt="나이스 캐치! 배송지를 입력하면 캐치볼을 보내드려요!" /></p>
					<div class="enterAddr">
						<div class="deliverInfo">
							<h3>배송지정보</h3>
							<dl>
								<dt><label for="name">이름</label></dt>
								<dd><span><input type="text" class="txtInp" name="reqname" id="name" disabled maxlength="10" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<%=GetLoginUserName%>" /></span></dd>
							</dl>
							<dl>
								<dt><label for="tel01">전화번호</label></dt>
								<dd class="inpTel">
									<span><input type="text" name="userphone1" id="up01" maxlength="3" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",0) end if %>" title="전화번호 국번 입력" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span><input type="text" name="userphone2" id="up02" maxlength="4" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",1) end if %>" title="전화번호 가운데자리 입력" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span><input type="text" name="userphone3" id="up03" maxlength="4" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.Fuserphone,"-",2) end if %>" title="전화번호 뒷자리 입력" /></span>
								</dd>
							</dl>
							<dl>
								<dt>주소</dt>
								<dd>
									<span><input type="text" name="txZip1" readOnly onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.FZipCode,"-",0) end if %>" title="우편번호 앞자리" /></span>
									<span>&nbsp;-&nbsp;</span>
									<span><input type="text" name="txZip2" readOnly onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" value="<% If IsUserLoginOK() Then response.write Splitvalue(oUserInfo.FOneItem.FZipCode,"-",1) end if %>" title="우편번호 뒷자리" /> </span>
									<% If IsUserLoginOK() Then %>
										<span><a href="" onclick="TnFindZip('frmorder',''); return false;" class="btnPost">우편번호 찾기</a><span>
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
			<% else %>
				<div class="scene04">
					<div class="ball"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/bg_ball.png" alt="" /></div>
					<div class="speedometer">
						<p class="km01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_speedometer_02.gif" alt="" /></p>
						<p class="km02"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_speedometer_04.gif" alt="" /></p>
					</div>
				</div>
				<div class="scene05">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/img_coupon.png" alt="와우! 만원 이상 구매시 오천원 쿠폰이에요 발급 후 24시간 이내에 꼭 사용하세요!" /></p>
					<button type="button" onclick="jscpSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68736/m/btn_coupon.png"  alt="쿠폰 발급받기" /></button>
				</div>
			<% end if %>
		</div>
		<div class="evtNoti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>본 이벤트는 텐바이텐 휴면 정책에 따라 1년간 로그인하지 않은 고객 대상으로 진행되는 이벤트입니다.</li>
				<li>사은품은 한정수량으로 조기 마감될 수 있습니다.</li>
				<li>사은품 신청 후에는 주소 변경이 불가하며, 6월 13일부터 배송될 예정입니다.</li>
				<li>지급된 쿠폰은 발급 후 24시간까지 사용할 수 있습니다.</li>
			</ul>
		</div>
	</div>
<script type="text/javascript">
$(function(){
	$(".intro .click").click(function(){
		$(".intro").fadeOut(300);
	});

	/* catch ball */
	$(".scene01 .ball").click(function(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-22" and left(currenttime,10)<"2017-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if subscriptcount <> 0 then %>
				alert("이미 참여하셨습니다.");
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
							<% if subscripttotalcount < 280 then %>
								$(".scene02").show();
								playBall1();
							<% else %>
								$(".scene04").show();
								playBall2();
							<% end if %>
						}
					}
				});
			<% end if %>
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
	function playBall1() {
		$('.scene02 .ball').delay(100).animate({backgroundSize:'100%'},700);
		$(".scene02 .km01").delay(800).hide(1);
		$(".scene02").delay(1400).fadeOut(50);
		$(".scene03").delay(1400).fadeIn(50);
	}

	$(".scene04").hide();
	$(".scene05").hide();
	function playBall2() {
		$('.scene04 .ball').delay(100).animate({backgroundSize:'100%'},700);
		$(".scene04 .km01").delay(800).hide(1);
		$(".scene04").delay(1400).fadeOut(50);
		$(".scene05").delay(1400).fadeIn(50);
	}
});

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-22" and left(currenttime,10)<"2017-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
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

function jscpSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-01-22" and left(currenttime,10)<"2017-01-01" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript68736.asp",
				data: "mode=cp",
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
						alert("로그인을 해야합니다.");
						return;
					}
					else if (result.chcode=="88")
					{
						alert("이벤트 기간이 아닙니다.");
						return;
					}
					else if (result.chcode=="22")
					{
						alert("이미 발급 받으셨습니다.");
						return;
					}
					else if (result.chcode=="99")
					{
						alert("이벤트 대상자가 아닙니다.");
						return;
					}
					else if (result.chcode=="11")
					{
						alert("발급이 완료 되었습니다.");
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
		if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
			var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
			winLogin.focus();
			return false;
		}
		return false;
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
<!-- #include virtual="/lib/db/dbclose.asp" -->