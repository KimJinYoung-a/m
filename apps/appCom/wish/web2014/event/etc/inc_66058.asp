<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 오! 나의 삼세판
' History : 2015-09-07 이종화 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid , strSql , totcnt
IF application("Svr_Info") = "Dev" THEN
	eCode = "64879"
Else
	eCode = "66058"
End If

userid = getEncLoginUserID

If IsUserLoginOK() Then

	strSql = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE userid = '" & userid & "' AND evt_code = '" & eCode & "' "
	rsget.CursorLocation = adUseClient
	rsget.Open strSql, dbget, adOpenForwardOnly, adLockReadOnly

	IF Not rsget.Eof Then
		totcnt = rsget(0) '// 0 1 2 3
	End IF
	rsget.close

Else
	'// 회원가입이 안되어 있음 쿠키 굽는다.(추후 가입완료시 이벤트 페이지 이동을 위해)
	response.cookies("etc").domain="10x10.co.kr"
	response.cookies("etc")("evtcode") = 66058
End If 
%>
<style type="text/css">
img {vertical-align:top;}
.threeChance li {position:relative;}
.threeChance li .getChance {display:block; position:absolute; left:11%; top:34.5%; width:78%; height:55%; z-index:20; font-size:0; color:transparent; background:transparent;}
.threeChance li:first-child .getChance {top:32%; height:57%;}
.threeChance li .lock {position:absolute; left:0; top:0; width:100%; z-index:40;}
.evtNoti {padding:25px 7.8%; background:#fff7ec;}
.evtNoti h3 {text-align:center;}
.evtNoti h3 strong {display:inline-block; font-size:15px; font-weight:bold; color:#333; padding-bottom:1px; margin-bottom:13px; border-bottom:2px solid #000;}
.evtNoti li {position:relative; color:#6e6e6e; font-size:11px; line-height:1.4; padding-left:15px;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:5px; width:6px; height:2px; background:#99948e;}
@media all and (min-width:480px){
	.evtNoti {padding:38px 7.8%;}
	.evtNoti h3 strong {font-size:23px; margin-bottom:20px; border-bottom:3px solid #000;}
	.evtNoti li {font-size:17px; padding-left:23px;}
	.evtNoti li:after {top:7px; width:9px; height:3px;}
}
</style>
<script>
function getcoupon(v){
	<% If IsUserLoginOK() Then %>
		<% If date()= "2015-09-09"  or date()= "2015-09-10" or date()= "2015-09-16" Then %>
			var frm = document.evtFrm1;
			<% if isApp=1 then %>
				frm.action="/apps/appcom/wish/web2014/event/etc/doeventsubscript/doEventSubscript66058.asp";
				frm.target="evtFrmProc";
				//frm.target="_blank";
				frm.cnum.value = v ;
				frm.submit();
			<% else %>
				alert('APP 에서만 진행 되는 이벤트 입니다.');
				return false;
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			alert('APP 에서만 진행 되는 이벤트 입니다.');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
<div class="mEvt66058">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/66058/tit_my_three_chance.gif" alt="오! 나의 삼세판 - 인생의 즐거움을 찾는 당신에게 텐바이텐이 세 번의 놀라운 기회를 드립니다." /></h2>
	<ol class="threeChance">
		<li>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66058/img_chance01.gif" alt="첫번째 판" /></p>
			<a href="" class="getChance" onclick="getcoupon('1');return false;">쿠폰받기</a>
		</li>
		<li>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66058/img_chance02.gif" alt="두번째 판" /></p>
			<a href="" class="getChance" onclick="getcoupon('2');return false;">쿠폰받기</a>
			<% if	totcnt >= 1 And datediff("D","2015-09-10",date()) = 0 then %>
			<% Else %>
			<p class="lock"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66058/img_lock01.png" alt="09.10 Coming soon!" /></p>
			<% end if %>
		</li>
		<li>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/66058/img_chance03.gif" alt="세번째 판" /></p>
			<a href="" class="getChance" onclick="getcoupon('3');return false;">마일리지받기</a>
			<% If totcnt >= 2 And datediff("D","2015-09-16",date()) = 0 then %>
			<% Else %>
			<p class="lock"><img src="http://webimage.10x10.co.kr/eventIMG/2015/66058/img_lock02.png" alt="09.16 Coming soon!" /></p>
			<% end if %>
		</li>
	</ol>
	<div class="evtNoti">
		<h3><strong>이벤트 유의사항</strong></h3>
		<ul>
			<li>이벤트는 ID 당 1일 1회만 참여할 수 있습니다.</li>
			<li>지급된 쿠폰은 텐바이텐 APP에서만 사용 가능합니다.</li>
			<li>쿠폰은 발급된 일자의 23시 59분 59초까지 사용 가능하며 그 이후에는 자동 소멸됩니다.</li>
			<li>지급된 마일리지는 텐바이텐 온라인에서만 사용 가능합니다.</li>
			<li>쿠폰과 마일리지는 마이텐바이텐에서 확인하실 수 있습니다.</li>
			<li>주문한 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
			<li>이벤트는 조기 마감될 수 있습니다.</li>
		</ul>
	</div>
</div>
<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
<input type="hidden" name="cnum" />
</form>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->