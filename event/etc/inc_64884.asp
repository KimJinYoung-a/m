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
' Description : ## 하트비트한 순간들
' History : 2015-07-15 유태욱 생성
'####################################################
	Dim vUserID, eCode, nowdate
	Dim strSql , totcnt

	vUserID = GetLoginUserID
	nowdate = date()
'	nowdate = "2015-07-20"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64829"
	Else
		eCode = "64884"
	End If

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
.heartBeat {padding:25px 0; background:url(http://webimage.10x10.co.kr/eventIMG/2015/64884/bg_apply.gif) no-repeat 0 0; background-size:100% 100%;}
.heartBeat ul {overflow:hidden; padding-bottom:10px;}
.heartBeat li {float:left; width:33.33333%; text-align:center;}
.heartBeat li input[type=radio] {display:inline-block; width:20px; height:20px; margin-top:4px; border:0; border-radius:50%;}
.heartBeat li input[type=radio]:checked {position:relative; background-image:none;}
.heartBeat li input[type=radio]:checked:after {content:' '; display:inline-block; position:absolute; left:20%; top:20%; width:60%; height:60%; background:#d50c0c; border-radius:50%;}
.heartBeat .btnSubmit {display:block; width:54%; margin:0 auto;}
.evtNoti {padding:35px 20px 0;}
.evtNoti h3 {position:relative; display:inline-block; font-size:14px; padding-bottom:5px; letter-spacing:3px; color:#2387ee; margin:0 0 15px 14px;}
.evtNoti h3:after {content:' '; display:inline-block; position:absolute; left:0; bottom:0; width:96%; height:3px; background:#2387ee; border-radius:3px;}
.evtNoti li {position:relative; font-size:12px; line-height:1.3; color:#000; padding:0 0 3px 14px;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:2px; height:2px; border:2px solid #2387ee; border-radius:50%;}
@media all and (min-width:480px){
	.heartBeat {padding:38px 0;}
	.heartBeat ul {padding-bottom:15px;}
	.heartBeat li input[type=radio] {width:30px; height:30px; margin-top:6px;}
	.evtNoti {padding:53px 30px 0;}
	.evtNoti h3 {font-size:21px; padding-bottom:7px; letter-spacing:4px; margin:0 0 23px 21px;}
	.evtNoti h3:after {height:4px; border-radius:4px;}
	.evtNoti li {font-size:18px; padding:0 0 4px 21px;}
	.evtNoti li:after {top:5px; width:3px; height:3px; border:3px solid #2387ee;}
}
</style>
<script type="text/javascript">

function jsSubmit(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #07/26/2015 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If nowdate>="2015-07-20" and nowdate<"2015-07-27" Then %>
				<% if totcnt > 0 then %>
					alert("이미 응모 하셨습니다.");
					return;
				<% else %>
					var tmpdateval='';
					for (var i=0; i < frm.dateval.length; i++){
						if (frm.dateval[i].checked){
							tmpdateval = frm.dateval[i].value;
						}
					}
					if (tmpdateval==''){
						alert('하트비트한 순간을 선택해 주세요.');
						return false;
					} else {
				   		frm.mode.value="add";
				   		frm.selectnum.value=tmpdateval;
						frm.action="/event/etc/doeventsubscript/doEventSubscript64884.asp";
						frm.target="evtFrmProc";
						frm.submit();
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
		url: "/event/etc/doeventsubscript/doEventSubscript64884.asp",
		data: "mode=appdowncnt",
		dataType: "text",
		async: false
	}).responseText;

	if (str == "OK"){
		var userAgent = navigator.userAgent.toLowerCase();
			parent.top.location.href='http://m.10x10.co.kr/apps/link/?7820150715';
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
	<!-- 하트비트한 순간들 -->
	<div class="mEvt64884">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64884/tit_heart_beat.gif" alt="지금 무엇을 하고 있나요? 하트비트한 순간들" /></h2>
		<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
		<input type="hidden" name="selectnum">
			<div class="heartBeat">
				<ul>
					<li>
						<label for="moment01"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64884/img_select01.png" alt="버스안에서" /></label>
						<input type="radio" name="dateval" value="1" id="moment01" />
					</li>
					<li>
						<label for="moment02"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64884/img_select02.png" alt="카페에서" /></label>
						<input type="radio" name="dateval" value="2" id="moment02" />
					</li>
					<li>
						<label for="moment03"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64884/img_select03.png" alt="집에서" /></label>
						<input type="radio" name="dateval" value="3" id="moment03" />
					</li>
				</ul>
				<input type="image" onclick="jsSubmit(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/64884/btn_apply.png" alt="응모하기" class="btnSubmit" />
			</div>
		</form>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64884/img_gift.jpg" alt="GIFT" /></div>
		<!-- 앱 설치 바로가기 --><p><a href="" onclick="fnappdowncnt();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64884/btn_go_app.gif" alt="지금 텐바이텐 APP을 설치하면 재밌는 이벤트가 가득! - 설치하러 가기" /></a></p>
		<div class="evtNoti">
			<h3><strong>유의사항</strong></h3>
			<ul>
				<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
				<li>본 이벤트는 ID당 1회만 응모가능합니다.</li>
				<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 고객부담입니다. </li>
				<li>당첨된 고객께는 익일 당첨안내 문자가 전송될 예정입니다.</li>
				<li>당첨된 상품은 당첨안내 확인 후에 발송됩니다! 마이텐바이텐에서 당첨안내를 확인해주세요.</li>
				<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
			</ul>
		</div>
	</div>
	<!--// 하트비트한 순간들 -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->
