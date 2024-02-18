<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<%
'####################################################
' Description : ## 텐바이텐x다노(소개) 
' History : 2015-06-15 유태욱 생성
'####################################################
	Dim vUserID, eCode, secretcode, nowdate
	Dim strSql , totcnt

	vUserID = GetLoginUserID
	nowdate = date()
'	nowdate = "2015-06-17"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	IF application("Svr_Info") = "Dev" THEN
		eCode = "63788"
	Else
		eCode = "63556"
	End If

	If left(nowdate,10)="2015-06-16" then
		secretcode="2116"
	elseIf left(nowdate,10)="2015-06-17" then
		secretcode="6301"
	elseIf left(nowdate,10)="2015-06-18" then
		secretcode="5397"
	elseIf left(nowdate,10)="2015-06-19" then
		secretcode="8519"
	elseIf left(nowdate,10)="2015-06-20" then
		secretcode="2546"
	elseIf left(nowdate,10)="2015-06-21" then
		secretcode="8514"
	else
		secretcode="9099"
	end if

	'// 응모여부
	strSql = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& vUserID &"' and evt_code = '"& ecode &"' " 
	rsget.Open strSql,dbget,1
	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
%>
<style type="text/css">
img {vertical-align:top;}
.goDanoApp {position:relative;}
.goDanoApp a {display:block; position:absolute; left:12%; top:23%; width:76%; height:45%; color:transparent;}
.enterNumber {padding-bottom:53px; background:#f1455d;}
.enterNumber .secretNum {display:block; width:72%; height:40px; margin:0 auto 15px; text-align:center; color:#000; font-weight:bold; font-size:15px; border:2px solid #ba273b; border-radius:0;}
.enterNumber .btnSubmit {display:block; width:60%; margin:0 auto}
.evtNoti {padding:30px 20px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/63556/bg_notice.gif) repeat-y 0 0; background-size:100% auto;}
.evtNoti h3 {display:inline-block; font-size:13px; font-weight:bold; line-height:1; padding:6px 14px 4px; color:#ee445c; background:#fff; border-radius:15px;}
.evtNoti ul {padding-top:13px;}
.evtNoti ul li {position:relative; margin-top:2px; font-size:11px; color:#666; padding-left:15px; line-height:1.5em;}
.evtNoti ul li:after {content:' '; position:absolute; top:4px; left:0; width:2px; height:2px; border:2px solid #f1455d; border-radius:50%; background-color:transparent;}
@media all and (min-width:375px){
	.enterNumber .secretNum {height:50px; font-size:18px; border:3px solid #ba273b;}
}
@media all and (min-width:480px){
	.enterNumber {padding-bottom:80px;}
	.enterNumber .secretNum {height:60px; font-size:23px; border:3px solid #ba273b;}
	.evtNoti {padding:40px 35px;}
	.evtNoti ul {padding-top:20px;}
	.evtNoti h3 {font-size:17px;}
	.evtNoti ul li {margin-top:4px; font-size:13px; }
}
::-webkit-input-placeholder {font-weight:normal; color:#ccc;}
::-moz-placeholder {font-weight:normal; color:#ccc;} /* firefox 19+ */
:-ms-input-placeholder {font-weight:normal; color:#ccc;} /* ie */
input:-moz-placeholder {font-weight:normal; color:#ccc;}
</style>
<script type="text/javascript">

function jsSubmitComment(frm){      //코멘트 입력
	<% If IsUserLoginOK() Then %>
		<% If Now() > #06/21/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If nowdate>="2015-06-16" and nowdate<"2015-06-22" Then %>
				<% if totcnt > 0 then %>
					alert("이미 응모 하셨습니다.");
					return;
				<% else %>
					if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 4){
						alert("시크릿 코드 입력해 주세요.");
						frm.txtcomm.focus();
						return;
					}
					
					if(frm.txtcomm.value==frm.secretcode.value){
				   		frm.mode.value="addcomment";
						frm.action="/event/etc/doeventsubscript/doEventSubscript63556.asp";
						frm.target="evtFrmProc";
						frm.submit();
						return;
					} else {
					    alert("시크릿코드가 일치하지 않습니다.");
					    document.frmcom.txtcomm.value="";
					    frm.txtcomm.focus();
					    return;
					}
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function fnappdowncnt(){
	var str = $.ajax({
		type: "GET",
		url: "/event/etc/doeventsubscript/doEventSubscript63556.asp",
		data: "mode=appdowncnt",
		dataType: "text",
		async: false
	}).responseText;

	if (str == "OK"){
		var userAgent = navigator.userAgent.toLowerCase();
			parent.top.location.href='http://goo.gl/rcD55q';
			return false;
	
		$(function(){
			var chkapp = navigator.userAgent.match('tenapp');
			if ( chkapp ){
				$("#mo").hide();
			}else{
				$("#mo").show();
			}
		});
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
}

</script>

	<!-- [모바일+APP] 텐바이텐x다노 소개-->
	<div class="mEvt63556">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/txt_project01.gif" alt="텐.친.소 프로젝트 #01.DANO" /></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/tit_dano.gif" alt="나와 함께 올 여름을 준비해줄 단호한 친구들" /></h2>
		<div class="danoAppInfo">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_diet01.jpg" alt="노출의 계절인 여름이 다가오고, 다이어트는 해야 하는데" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_diet02.jpg" alt="혼자하는 다이어트는 지치고 불안하죠? 어디서부터 시작해야 할 지 모르겠다면?" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_diet03.jpg" alt="더 이상 고민하지 마세요! 당신을 도와줄 APP, 다노를 소개합니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_diet04.jpg" alt="한 눈에 볼 수 있는 수백까지 다이어트 식단!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_diet05.jpg" alt="집에서도 손쉽게 따라할 수 있는 운동팁!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_diet06.jpg" alt="내가 몰랐던 깨알같은 정보공유 까지" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_diet07.jpg" alt="다이어트 습관 만들기, 이젠 자신있어요!" /></p>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_dano_app.jpg" alt="DANO, 함께해요!" /></p>
		<div class="goDanoApp">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/btn_dano_app.gif" alt="" /></p>
			<a href="" onclick="fnappdowncnt();return false;">다노 APP으로 가기</a>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/txt_present_dano.gif" alt="지금 다노와 함께하시면 다이어트를 도와드릴 선물이 찾아갑니다!(기간:06.16~06.21/당첨자발표:06.22)" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/txt_process.gif" alt="이벤트 참여방법:다노APP설치하기→다노APP시크릿 넘버 찾기→10X10 APP시크릿 넘버 기입하기" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/63556/img_gift.jpg" alt="GIFT" /></p>

		<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="secretcode" value="<%=secretcode%>">
			<div class="enterNumber">
				<p><input type="number" name="txtcomm" id="txtcomm" class="secretNum" placeholder="시크릿넘버를 기입해주세요"/></p>
				<% if left(nowdate,10)="2015-06-16" then %>
						<p><input type="image" class="btnSubmit" onclick="jsSubmitComment(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/63556/btn_apply.gif" alt="응모하기" /></p>
				<% else %>
					<p><input type="image" class="btnSubmit" onclick="jsSubmitComment(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/63556/btn_apply.gif" alt="응모하기" /></p>
				<% end if %>
			</div>

		</form>
		<div class="evtNoti">
			<h3><span>유의사항</span></h3>
			<ul>
				<li>본 이벤트는 ID당 1회만 응모가능합니다.</li>
				<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
				<li>당첨된 고객께는 익일 당첨안내 문자가 전송될 예정입니다.</li>
				<li>당첨된 상품은 당첨안내 확인 후에 발송됩니다!<br /> 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
				<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
			</ul>
		</div>
	</div>
	<!--// 텐바이텐x다노 소개 -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->
