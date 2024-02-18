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
' Description : 6월 리텐션 프로모션 For App
' History : 2015-06-01 원승현 생성
'####################################################
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	Dim sKey , sDays , totalbonuscouponcount , couponidx

	sDays = Date()

	vUserID = GetLoginUserID
	IF application("Svr_Info") = "Dev" THEN
		eCode = "63777"
		couponidx = "396"
	Else
		eCode = "63122"
		couponidx = "741"
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
		Case "2015-06-02"
			sKey = "오늘의 시크릿 넘버는 [5231] 입니다."
		Case "2015-06-03"
			sKey = "오늘의 시크릿 넘버는 [8687] 입니다."
		Case "2015-06-04"
			sKey = "오늘의 시크릿 넘버는 [0407] 입니다."
		Case "2015-06-05"
			sKey = "오늘의 시크릿 넘버는 [2116] 입니다."
		Case "2015-06-06"
			sKey = "주말은 쉽니다 ^^"
		Case "2015-06-07"
			sKey = "주말은 쉽니다 ^^"
		Case "2015-06-08"
			sKey = "오늘의 시크릿 넘버는 [6301] 입니다."
		Case "2015-06-09"
			sKey = "오늘의 시크릿 넘버는 [5397] 입니다."
		Case "2015-06-10"
			sKey = "오늘의 시크릿 넘버는 [3958] 입니다."
		Case "2015-06-11"
			sKey = "오늘의 시크릿 넘버는 [8519] 입니다."
		Case "2015-06-12"
			sKey = "오늘의 시크릿 넘버는 [4575] 입니다."
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
img {vertical-align:top;}
.mEvt63122 {}
input[type=number]::-webkit-inner-spin-button, 
input[type=number]::-webkit-outer-spin-button {-webkit-appearance:none;}
input[type=number] {-moz-appearance:textfield;}

.topic {position:relative;}
.secret legend {visibility:hidden; width:0; height:0;}
.secret {position:absolute; top:60.8%; left:50%; width:65.8%; margin-left:-32.9%;}
.secret .itext {overflow:hidden; display:block; position:relative; height:0; padding-bottom:20.25%;}
.secret .itext input {position:absolute; top:0; left:0; width:100%; height:100%; border:0; border-radius:0; color:#aaa; font-size:24px; text-align:center;}
.secret .btnsubmit {width:76%; margin:5% auto 0;}
.secret .btnsubmit input[type=image] {width:100%;}
::-webkit-input-placeholder {color:#aaa; font-size:24px; line-height:1.5em;}
::-moz-placeholder {color:#aaa; font-size:24px; line-height:1.5em;} /* firefox 19+ */
:-ms-input-placeholder {color:#aaa; font-size:24px; line-height:1.5em;} /* ie */
input:-moz-placeholder {color:#aaa; font-size:24px; line-height:1.5em;}
.btnforgot {position:absolute; bottom:4%; left:50%; width:51.6%; margin-left:-25.8%; background-color:transparent;}
.btnforgot span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.soldout {position:absolute; top:39%; left:0; z-index:10; width:100%;}

.layer {position:absolute; top:5%; left:50%; z-index:210; width:94%; margin-left:-47%;}
.layer .inner {position:relative;}
.layer .btnclose {position:absolute; bottom:6%; left:50%; width:50%; margin-left:-25%; background-color:transparent;}
.layer .btnclose span {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.mask {display:none; position:absolute; top:0; left:0; z-index:200; width:100%; height:100%; background:rgba(0,0,0,.50);}

.noti {padding:20px 10px;}
.noti h2 {color:#dc0610; font-size:14px;}
.noti h2 strong {padding-bottom:2px; border-bottom:2px solid #dc0610;}
.noti ul {margin-top:13px;}
.noti ul li {position:relative; padding-left:10px; color:#444; font-size:11px; line-height:1.5em;}
.noti ul li:after {content:' '; position:absolute; top:6px; left:0; width:4px; height:1px; background-color:#444;}
@media all and (min-width:480px){
	.noti {padding:25px 15px;}
	.noti ul {margin-top:16px;}
	.noti h2 {font-size:17px;}
	.noti ul li {margin-top:2px; font-size:13px;}
}
@media all and (min-width:768px){
	.noti h2 {font-size:20px;}
	.noti ul {margin-top:20px;}
	.noti ul li {margin-top:4px; font-size:16px;}
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
		alert("시크릿넘버를 입력해주세요.");
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
				url:"/apps/appcom/wish/web2014/event/etc/doEventSubscript63122.asp",
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
						alert('시크릿 넘버를 확인 해주세요.');
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
						$('.layer').show();
						$('.mask').show();
						frm.secretkey.value="";
						return;
					}
				}
			});
		 <% End If %>
	<% End If %>
}
</script>
</head>
<body>

<div class="mEvt63122">
	<div class="topic">
		<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/63122/txt_only_you.png" alt="너에게만 알려줄게! 시크릿 넘버를 넣으면 놀라운 선물이!" /></h1>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63122/txt_no.png" alt="시크릿 넘버를 입력한 당신에게 놀라운 할인선물을 드립니다." /></p>

		<div class="secret">
			<form name="frmcom" id="frmcom" method="get" style="margin:0px;">
			<input type="hidden" name="mode" value="coupon"/>
				<fieldset>
				<legend>시크릿 넘버 입력하기</legend>
					<div class="itext"><input type="tel" class="wCode" placeholder="* * * *" name="secretkey" maxlength="4" autocomplete="off"/></div>
					<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/63122/btn_submit.png" alt="시크릿넘버 입력하기" onclick="checkform();return false;" /></div>
				</fieldset>
			</form>
		</div>

		<%' for dev msg : 쿠폰이 발급되면 레이어창 display:block;으로 바꿔주세요 / class="mask"(이벤트 유의사항 끝나고 있어요)이 부분도 같이 변경해주세요 %>
		<div class="layer" style="display:none;">
			<div class="inner">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63122/txt_finish.png" alt="쿠폰 발급 완료 오늘 자정까지 앱에서만 사용가능 합니다! 만원 이상 구매시 오천원 쿠폰" /></p>
				<button type="button" class="btnclose"><span>확인</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/63122/btn_confirm.png" alt="" /></button>
			</div>
		</div>

		<%' for dev msg : alert으로 시크릿 넘버 알려주세요 %>
		<button type="button" class="btnforgot" onclick="alert('<%=sKey%>');"><span>시크릿 넘버를 잊으셨나요?</span><img src="http://webimage.10x10.co.kr/eventIMG/2015/63122/btn_check.png" alt="" /></button>
		<%' for dev msg : 솔드아웃 %>
		<% If totalbonuscouponcount >= 1000 Then %>
			<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63122/txt_soldout.png" alt="앗, 스크릿 쿠폰이 모두 소진되었어요!" /></p>
		<% End If %>
	</div>

	<div class="noti">
		<h2><strong>이벤트 유의사항</strong></h2>
		<ul>
			<li>본 이벤트는 로그인 후에 참여가 가능합니다.</li>
			<li>본 이벤트는 신규 앱 설치한 고객을 대상으로 한 시크릿 이벤트입니다.</li>
			<li>시크릿 쿠폰은 한정수량으로 조기 소진될 수도 있습니다.</li>
			<li>ID 당 1회만 쿠폰 다운이 가능합니다.</li>
			<li>지급된 쿠폰은 자정 기준으로 자동 소멸되며, 1만원 이상 구매시 사용 가능합니다. 단, APP에서 만 사용이 가능합니다. <br />(PC, 모바일웹에서 사용불가)</li>
			<li>다른 쿠폰과 함께 사용 수 없습니다.</li>
		</ul>
	</div>
	<div class="bnr">
		<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=63373" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/63122/img_bnr.png" alt="특별한 당신에게만, 단 5일간 열리는 비둘기 마켓 보러가기" /></a>
	</div>

	<%' for dev msg : 쿠폰이 발급되면 마스크 display:block;으로 바꿔주세요 %>
	<div class="mask" style="display:none;"></div>
</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
<script type="text/javascript">
	/* layer */
	$(function() {
		$(".mask, .layer .btnclose").click(function(){
			$(".layer").hide();
			$(".mask").hide();
		});
	});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->