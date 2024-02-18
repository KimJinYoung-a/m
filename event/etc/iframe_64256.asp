<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 말할 수 없는 비밀번호 
' History : 2015.07.16 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim vUserID, eCode, cMil, vMileValue, vMileArr
Dim sKey , totalbonuscouponcount , couponidx
	vUserID = GetLoginUserID

dim currenttime
	currenttime =  now()
	'currenttime = #07/21/2015 09:00:00#
	
IF application("Svr_Info") = "Dev" THEN
	eCode = "64825"
	couponidx = "2724"
Else
	eCode = "64256"
	couponidx = "757"
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
Select Case left(currenttime,10)
	Case "2015-07-20"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
	Case "2015-07-21"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
	Case "2015-07-22"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
	Case "2015-07-23"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
	Case "2015-07-24"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
	Case "2015-07-25"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
	Case "2015-07-26"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
		'sKey = "주말은 쉽니다 ^^"
	Case "2015-07-16"
		sKey = "오늘의 시크릿 넘버는 [1116] 입니다."
	Case Else
		sKey = "이벤트 기간이 아닙니다."
End Select

totalbonuscouponcount = getbonuscoupontotalcount(couponidx, "", "", left(currenttime,10))

%>

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.mEvt64256 {}
.mEvt64256 input[type=number]::-webkit-inner-spin-button, 
.mEvt64256 input[type=number]::-webkit-outer-spin-button {-webkit-appearance:none;}
.mEvt64256 input[type=number] {-moz-appearance:textfield;}

.topic {position:relative;}
.secret legend {visibility:hidden; width:0; height:0;}
.secret {position:absolute; top:63.2%; left:50%; width:65.8%; margin-left:-32.9%;}
.secret .itext {overflow:hidden; display:block; position:relative; height:0; padding-bottom:19.25%;}
.secret .itext input {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; color:#aaa; font-size:24px; text-align:center;}
.secret .btnsubmit {width:76%; margin:5% auto 0;}
.secret .btnsubmit input[type=image] {width:100%;}
::-webkit-input-placeholder {color:#aaa; font-size:24px; line-height:1.5em;}
::-moz-placeholder {color:#aaa; font-size:24px; line-height:1.5em;} /* firefox 19+ */
:-ms-input-placeholder {color:#aaa; font-size:24px; line-height:1.5em;} /* ie */
input:-moz-placeholder {color:#aaa; font-size:24px; line-height:1.5em;}
.btnforgot {position:absolute; bottom:4.5%; left:50%; width:56.2%; margin-left:-28.1%; background-color:transparent;}
.btnforgot span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.soldout {position:absolute; top:43.7%; left:0; z-index:10; width:100%;}

.layer {position:absolute; top:5%; left:50%; z-index:210; width:92.2%; margin-left:-46.1%;}
.layer .inner {position:relative;}
.layer .btnclose {position:absolute; bottom:6%; left:50%; width:50%; margin-left:-25%; background-color:transparent;}
.layer .btnclose span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.70);}

.noti {padding:20px 10px;}
.noti h2 {color:#ff860f; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #ff860f;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; margin-top:2px; padding-left:8px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:4px; left:0; width:4px; height:4px; border-radius:50%; background-color:#fe952e;}
@media all and (min-width:480px){
	.noti {padding:25px 15px;}
	.noti h2 {font-size:17px;}
	.noti ul {margin-top:16px;}
	.noti ul li {margin-top:4px; padding-left:12px; font-size:13px;}
	.noti ul li:after {top:5px; width:5px; height:5px;}
}
@media all and (min-width:768px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:6px; padding-left:20px; font-size:16px;}
	.noti ul li:after {top:9px;}
}
</style>
<script type="text/javascript">

function checkform(){
	var frm = document.frmcom;
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
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
				url:"/event/etc/doeventsubscript/doEventSubscript64256.asp",
				data: $("#frmcom").serialize(),
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data){
					result = jQuery.parseJSON(Data);
					if (result.resultcode=="00"){
						$('.couponfin').show();
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="11"){
						alert('이미 다운받으셨습니다.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="22"){
						alert('이벤트는 ID당 1회만 참여할 수 있습니다.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="33"){
						alert('비밀번호를 확인 해주세요.');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="44"){
						alert('잘못된 접근입니다');
						frm.secretkey.value="";
						return;
					}
					else if (result.resultcode=="99"){
						window.parent.$('html,body').animate({scrollTop:0}, 500);
//						$('.layer').show();
						$(".layer").css("display","block");
						$(".mask").css("display","block");
						frm.secretkey.value="";
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}

function maxLengthCheck(object){
	if (object.value.length > object.maxLength)
	object.value = object.value.slice(0, object.maxLength)
}

function disppassword(){
	var frm = document.frmcom;
	<% If vUserID = "" Then %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>
	
	alert('<%=sKey%>');
	return false;
}

</script>
</head>
<body>
<% '<!-- [APP전용] iframe --> %>
<div class="mEvt64256">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/62047/tit_secret_number_v2.gif" alt="말할 수 없는 비밀번호 비밀번호를 넣으면 놀라운 선물이!" /></h1>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64256/txt_no.png" alt="비밀번호를 입력한 선착순 천명에게 놀라운 할인을! 쿠폰 사용기간은 오늘 자정까지" /></p>

		<div class="secret">
			<form name="frmcom" id="frmcom" method="get" style="margin:0px;">
			<input type="hidden" name="mode" value="coupon"/>
				<fieldset>
				<legend>시크릿 넘버 입력하기</legend>
					<%''<div class="itext"><input type="tel" placeholder="* * * *" name="secretkey" maxlength="4" autocomplete="off"/></div> %>
					<div class="itext"><input placeholder="* * * *" name="secretkey" oninput="maxLengthCheck(this)" type = "number" maxlength = "4" autocomplete="off" /></div>
					<div class="btnsubmit"><input type="image" onclick="checkform(); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/64256/btn_submit.png" alt="비밀번호 입력하기"  /></div>
				</fieldset>
			</form>
		</div>

		<%'' for dev msg : 쿠폰이 발급되면 레이어창 display:block;으로 바꿔주세요 / class="mask"(이벤트 유의사항 끝나고 있어요)이 부분도 같이 변경해주세요 %>
		<div class="layer" style="display:none;">
			<div class="inner">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64256/txt_finish.png" alt="쿠폰 발급 완료! 오늘 자정까지 앱에서만 사용가능 합니다! 만원 이상 구매시 오천원 쿠폰" /></p>
				<button type="button" class="btnclose"><span>확인</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/64256/btn_confirm.png" alt="" /></button>
			</div>
		</div>

		<%'' for dev msg : alert으로 시크릿 넘버 알려주세요 %>
		<button type="button" onclick="disppassword(); return false;" class="btnforgot"><span>혹시 비밀번호를 잊으셨나요?</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/64256/btn_review.png" alt="" /></button>
		<% If totalbonuscouponcount >= 1000 Then %>
			<p class="soldout" id="couponfin" style="display:block;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64256/txt_soldout.png" alt="앗, 비밀 쿠폰이 모두 소진되었어요!" /></p>
		<% end if %>
	</div>

	<div class="noti">
		<h2><strong>이벤트 유의사항</strong></h2>
		<ul>
			<li>본 이벤트는 매일 선착순 1,000명에게 비밀쿠폰이 발급되며, 한정수량으로 조기 소진될 수 있습니다.</li>
			<li>본 이벤트는 로그인 후에 참여 가능합니다.</li>
			<li>본 이벤트는 시럽 내 텐바이텐 멤버십을 발급받은 고객 대상으로 한 시크릿 이벤트입니다.</li>
			<!--<li>비밀쿠폰은 한정수량으로 조기 소진될 수도 있습니다.</li>-->
			<li>ID 당 1회만 쿠폰 발급이 가능합니다.</li>
			<li>비밀 쿠폰은 발급 후 7월 26일까지 사용 가능합니다.</li>
			<li>비밀 쿠폰은 1만원 이상 구매시 사용 가능하며, 다른 쿠폰과 함께 사용하실 수 없습니다.</li>
		</ul>
	</div>

	<%'' for dev msg : 쿠폰이 발급되면 마스크 display:block;으로 바꿔주세요 %>
	<div class="mask" style="display:none;"></div>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</div>
<% '<!-- //iframe --> %>

<script type="text/javascript">

/* layer */
$(function() {
	$(".mask, .layer .btnclose").click(function(){
		$(".layer").hide();
		$(".mask").hide();
		document.location.reload();
	});
});

</script>

</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->