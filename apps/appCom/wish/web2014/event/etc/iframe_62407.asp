<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 말할 수 없는 비밀번호 
' History : 2015-05-13 유태욱 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim sKey , sDays , totalbonuscouponcount , couponidx

	sDays = Date()

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "61788"
		couponidx = "1720"
	Else
		eCode = "62407"
		couponidx = "735"
	End If

	Dim strSql , totcnt
	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()

	'//오늘의 시크릿 넘버
	Select Case sDays
		Case "2015-05-14"
			sKey = "오늘의 시크릿 넘버는 [5231] 입니다."
		Case "2015-05-15"
			sKey = "오늘의 시크릿 넘버는 [8687] 입니다."
		Case "2015-05-16"
			sKey = "주말은 쉽니다 ^^"
		Case "2015-05-17"
			sKey = "주말은 쉽니다 ^^"
		Case "2015-05-18"
			sKey = "오늘의 시크릿 넘버는 [0518] 입니다."
		Case "2015-05-19"
			sKey = "오늘의 시크릿 넘버는 [2116] 입니다."
		Case "2015-05-20"
			sKey = "오늘의 시크릿 넘버는 [6301] 입니다."
		Case "2015-05-21"
			sKey = "오늘의 시크릿 넘버는 [5397] 입니다."
		Case "2015-05-22"
			sKey = "오늘의 시크릿 넘버는 [3958] 입니다."
		Case "2015-05-23"
			sKey = "주말은 쉽니다 ^^"
		Case "2015-05-24"
			sKey = "주말은 쉽니다 ^^"
		Case "2015-05-25"
			sKey = "석가탄신일은 쉽니다 ^^"
		Case "2015-05-26"
			sKey = "오늘의 시크릿 넘버는 [8519] 입니다."
		Case "2015-05-27"
			sKey = "오늘의 시크릿 넘버는 [8282] 입니다."
		Case "2015-05-28"
			sKey = "오늘의 시크릿 넘버는 [0528] 입니다."
		Case "2015-05-29"
			sKey = "오늘의 시크릿 넘버는 [7777] 입니다."
		Case Else
			sKey = "이벤트 기간이 아닙니다."
	End Select

	totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", Date())
%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<title></title>
<style type="text/css">
.mEvt62047 {position:relative;}
.mEvt62047 img {vertical-align:top;}
.mEvt62047 .enterCode {position:relative;}
.mEvt62047 .enterCode .finish {position:absolute; left:0; top:0; width:100%; z-index:40;}
.mEvt62047 .enterCode input {display:block; position:absolute;}
.mEvt62047 .enterCode .wCode {left:22%; top:47.5%; width:56%; height:13%; font-size:22px; padding-left:5%; font-weight:bold; letter-spacing:10px; text-align:center; border:0; color:#333; background:transparent;}
.mEvt62047 .enterCode .submitCode {left:25%; top:67%; width:50%;}
.mEvt62047 .forgetCode {position:relative;}
.mEvt62047 .forgetCode span {display:inline-block; position:absolute; left:23%; top:22%; width:54%; height:50%; color:transparent; cursor:pointer;}
.mEvt62047 .evtNoti {padding:20px 10px; background:#f4f7f7;}
.mEvt62047 .evtNoti dt {display:inline-block; font-size:14px; font-weight:bold; color:#ff860f; padding-bottom:1px; margin:0 0 13px 10px; border-bottom:2px solid #ff860f;}
.mEvt62047 .evtNoti li {position:relative; color:#444; font-size:11px; line-height:1.3; padding-left:10px; letter-spacing:-0.015em;}
.mEvt62047 .evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#ff860f; border-radius:50%;}
.couponLayer {position:absolute; left:0; top:0; width:100%; height:100%; padding:8% 3.95% 0; background:rgba(0,0,0,.5); z-index:45;}
.couponLayer .todayCp {position:relative;}
.couponLayer .todayCp a {display:block; position:absolute; left:24%; bottom:7.5%; width:52%; height:11.5%; color:transparent;}
@media all and (min-width:480px){
	.mEvt62047 .evtNoti {padding:30px 15px;}
	.mEvt62047 .evtNoti dt {font-size:21px; margin-bottom:20px;}
	.mEvt62047 .evtNoti li {font-size:17px; padding-left:12px;}
	.mEvt62047 .evtNoti li:after {top:6px; width:4px; height:4px;}
}
</style>
<script type="text/javascript">
function checkform(){
	var frm = document.frmcom;
	<% If vUserID = "" Then %>
		parent.calllogin();
		return false;
	<% End If %>

	if(!frm.secretkey.value||frm.secretkey.value=="****"){
		alert("비밀번호를 입력해주세요.");
		frm.secretkey.value="";
		frm.secretkey.focus();
		return false;
	}

	<% If vUserID <> "" Then %>
		<% If totcnt > 1 then %>
			alert("이미 다운받으셨습니다.");
		<% Else %>
			var result;
			$.ajax({
				type:"GET",
				url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript62407.asp",
				data: $("#frmcom").serialize(),
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="00")
					{
						$('.couponfin').show();
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="11")
					{
						alert('이미 다운받으셨습니다.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="22")
					{
						alert('이벤트는 ID당 1일 1회만 참여할 수 있습니다.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="33")
					{
						alert('비밀번호를 확인 해주세요.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="44")
					{
						alert('잘못된 접근입니다');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="99")
					{
						window.parent.$('html,body').animate({scrollTop:0}, 500);
						$('.couponLayer').show();
						frm.secretkey.value="";
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}
$(function(){
	$('.couponLayer').hide();
	$('.todayCp a').click(function(){
		$('.couponLayer').hide();
	});
});
</script>
</head>
<body>
	<!-- 말할 수 없는 비밀번호 -->
	<div class="mEvt62047">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/62047/tit_secret_number.gif" alt="말할 수 없는 비밀번호" /></h2>
		<!-- 코드 입력, 시크릿넘버 확인 -->
		<form name="frmcom" id="frmcom" method="get" style="margin:0px;">
		<input type="hidden" name="mode" value="coupon"/>
		<div class="enterCode">
			<% If totalbonuscouponcount >= 1000 Then %>
				<p class="finish"><img src="http://webimage.10x10.co.kr/eventIMG/2015/62047/txt_finish.png" alt="앗, 시크릿 쿠폰이 모두 소진되었어요!" /></p>
			<% End If %>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62047/img_secret_number.gif" alt="SECRET NUMBER" /></p>
			<input type="tel" class="wCode" placeholder="****" name="secretkey" maxlength="4" autocomplete="off"/>
			<input type="image" class="submitCode" src="http://webimage.10x10.co.kr/eventIMG/2015/62047/btn_enter_number.gif" alt="비밀번호 입력하기" onclick="checkform();return false;"/>
		</div>
		</form>

		<div class="forgetCode">
			<span onclick="alert('<%=sKey%>')">혹시 비밀번호를 잊으셨나요?</span>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62047/txt_forget_number.gif" alt="" /></p>
		</div>
		<!--// 코드 입력, 시크릿넘버 확인 -->
		<dl class="evtNoti">
			<dt>이벤트 유의사항</dt>
			<dd>
				<ul>
					<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
					<li>본 이벤트는 신규 앱 설치한 고객을 대상으로 한 시크릿 이벤트입니다.</li>
					<li>비밀쿠폰은 한정수량으로 조기 소진될 수도 있습니다.</li>
					<li>ID 당 1회만 쿠폰 다운이 가능합니다.</li>
					<li>지급된 쿠폰은 자정 기준으로 자동 소멸되며, 1만원 이상 구매시 사용 가능합니다. 단, APP에서 만 사용이 가능합니다. (PC, 모바일웹에서 사용불가)</li>
					<li>다른 쿠폰과 함께 사용하실 수 없습니다.</li>
				</ul>
			</dd>
		</dl>
		<!-- 쿠폰발급완료 레이어 -->
		<div class="couponLayer">
			<div class="todayCp">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/62047/img_app_coupon.gif" alt="쿠폰발급완료 - 오늘 자정까지 APP에서만 사용 가능합니다" /></p>
				<a href="" onclick="return false;">확인</a>
			</div>
		</div>
		<!--// 쿠폰발급완료 레이어 -->
	</div>
	<!--// 말할 수 없는 비밀번호 -->
</body>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->