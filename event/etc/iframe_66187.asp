<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 추석 쿠폰 세트
' History : 2015-09-18 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql
Dim coupon1 , coupon2 , coupon3
Dim totcnt1 , totcnt2 , totcnt3

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64892"
	Else
		eCode = "66187"
	End If

	IF application("Svr_Info") = "Dev" THEN
		coupon1 = "2741"
		coupon2 = "2742"
		coupon3 = "2743"
	Else
		coupon1 = "780"
		coupon2 = "781"
		coupon3 = "782"
	End If

	userid = getEncLoginUserID()

'//본인 참여 여부
if userid<>"" Then
	'//응모 카운트 체크
	strSql = "SELECT " + vbcrlf
	strSql = strSql & " isnull(sum(case when sub_opt2 = 1 then 1 else 0 end),0) as totcnt1  " + vbcrlf
	strSql = strSql & " ,isnull(sum(case when sub_opt2 = 2 then 1 else 0 end),0) as totcnt2  " + vbcrlf
	strSql = strSql & " ,isnull(sum(case when sub_opt2 = 3 then 1 else 0 end),0) as totcnt3  " + vbcrlf
	strSql = strSql & " FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "'"
'	Response.write strSql
''	Response.end
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		totcnt1 = rsget(0) '// 0 1
		totcnt2 = rsget(1) '// 0 1
		totcnt3 = rsget(2) '// 0 1
	End IF
	rsget.close	
end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt66187 {position:relative; overflow:hidden;}
.couponDownload {position:relative;}
.couponDownload li {position:absolute; width:30%; height:75%; font-size:0; line-height:0; color:transparent; cursor:pointer;}
.couponDownload li.cp01 {left:4%; top:2%;}
.couponDownload li.cp02 {left:35%; top:8%;}
.couponDownload li.cp03 {right:4%; top:2%;}
.layerGetCoupon {position:absolute; left:0; top:0; width:100%; height:100%; padding:7% 6% 0; background:rgba(0,0,0,.7);display:none;}
.layerGetCoupon .layerCont {position:relative; }
.layerGetCoupon .layerCont button {position:absolute; background:transparent; font-size:0; line-height:0; color:transparent;}
.layerGetCoupon .layerCont .btnClose {right:0; top:0; width:11%;}
.layerGetCoupon .layerCont .btnConfirm {left:8%; bottom:5%; width:84%; height:11%;}
.goBtn {padding:0 10%; background:#ffe185;}
.goBtn p {padding:25px 0; border-top:1px solid #d9bf71;}
.goBtn p:first-child {border-top:0;}
.evtNoti {padding:25px 7.8%; text-align:left; background:#fff7ec;}
.evtNoti h3 {padding:0 0 15px 13px;}
.evtNoti h3 strong {display:inline-block; font-size:15px; padding-bottom:1px; color:#333; border-bottom:2px solid #333;}
.evtNoti li {position:relative; font-size:11px; line-height:1.3; padding:0 0 4px 13px; color:#6e6e6e; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4.5px; width:5px; height:2px; background:#808080;}
@media all and (min-width:480px){
	.goBtn p {padding:38px 0;}
	.evtNoti {padding:38px 7.8%;}
	.evtNoti h3 {padding:0 0 23px 20px;}
	.evtNoti h3 strong {font-size:23px; border-bottom:3px solid #333;}
	.evtNoti li {font-size:17px; padding:0 0 6px 20px;}
	.evtNoti li:after {top:6px; width:7px; height:3px;}
}
</style>
<script type="text/javascript">
$(function(){
	$('.layerCont .btnClose,.layerCont .btnConfirm').click(function(){
		$('.layerGetCoupon').fadeOut();
	});
});

function layershow(v){
	$('.layerGetCoupon').fadeIn(250);
	$('.layerCont div').hide();
	$('.layerCont div.cp0'+v).show();
	window.parent.$('html,body').animate({scrollTop:50}, 500);
}

function jseventSubmit(v){
	var frm = document.evtFrm1;
	<% If IsUserLoginOK() Then %>
		<% If not( date()>= "2015-09-18" and date() <= "2015-09-22" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% else %>
			frm.cpnum.value = v;
			frm.action="/event/etc/doeventsubscript/doEventSubscript66187.asp";
			frm.target="evtFrmProc";
			frm.mode.value='coupon';
			frm.submit();
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
</head>
<body>
<div class="mEvt66187">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/tit_coupon.gif" alt="추석 쿠폰 세트" /></h2>
	<div class="couponDownload">
		<ul>
			<li class="cp01" onclick="jseventSubmit('1');return false;">굴비쿠폰</li>
			<li class="cp02" onclick="jseventSubmit('2');return false;">한우쿠폰</li>
			<li class="cp03" onclick="jseventSubmit('3');return false;">홍삼쿠폰</li>
		</ul>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/img_coupon.gif" alt="추석 쿠폰 세트" /></div>
	</div>
	<!-- 쿠폰발급 완료 레이어 -->
	<div class="layerGetCoupon">
		<div class="layerCont">
			<button type="button" class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/btn_close.png" alt="닫기" /></button>
			<div class="cp01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/img_get_coupon01.gif" alt="2만원 이상 구매시 1000원 할인" /></div>
			<div class="cp02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/img_get_coupon02.gif" alt="5만원 이상 구매시 4000원 할인" /></div>
			<div class="cp03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/img_get_coupon03.gif" alt="10만원 이상 구매시 10%할인" /></div>
			<button type="button" class="btnConfirm">확인</button>
		</div>
	</div>
	<!--// 쿠폰발급 완료 레이어 -->
	<div class="goBtn">
		<!-- 웹에서만 노출 -->
		<% if not(isApp=1) then %>
			<p><a href="/event/appdown" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/btn_app_down.gif" alt="텐바이텐 APP 다운받기" /></a></p>
		<% end if %>
		<% If userid = "" Then %>
			<% if isApp=1 then %>
			<p><a href="" onClick="parent.fnAPPpopupBrowserURL('회원가입','<%=wwwUrl%>/apps/appCom/wish/web2014/member/join.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/btn_join.gif" alt="회원가입하고 구매하러 가기" /></a></p>
			<% Else %>
			<p><a href="/member/join.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66187/m/btn_join.gif" alt="회원가입하고 구매하러 가기" /></a></p>
			<% End If %>
		<% End If %>
	</div>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>본 쿠폰은 ID 당 1회만 다운받을 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐에서만 사용가능 합니다.</li>
			<li>쿠폰은 9/22(화) 23시59분 종료됩니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생 할 수 있습니다.</li>
			<li>이벤트는 조기 마감 될 수 있습니다.</li>
		</ul>
	</div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	<input type="hidden" name="cpnum" />
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0 style="display:none;"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->