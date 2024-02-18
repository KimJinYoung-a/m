<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마일리지를 사수하라
' History : 2015.03.20 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/etc/event60274Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->

<%
dim eCode, subscriptcount, itembuycount, userid
	eCode=getevt_code
	userid = getloginuserid()

subscriptcount=0
itembuycount=0

subscriptcount = getevent_subscriptexistscount(eCode, userid, "", "", "")
itembuycount = get10x10onlineordercount(userid, "2015-03-11", "2015-03-16", "", "'app_wish2'", "7", "N")
'itembuycount = 1
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt60274 img {width:100%; vertical-align:top;}
.evtNoti {padding:22px 10px; background:#e8e8e8;}
.evtNoti dt {display:inline-block; margin:0 0 10px 10px;  border-bottom:2px solid #dc0610; color:#dc0610; font-size:14px; line-height:1; padding-bottom:2px; font-weight:bold;}
.evtNoti dd li {position:relative; padding:0 0 5px 10px; font-size:11px; line-height:1.2; color:#444;}
.evtNoti dd li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:4px; height:4px; background:#aaa; border-radius:50%;}
@media all and (min-width:480px){
	.evtNoti {padding:33px 15px;}
	.evtNoti dt {margin:0 0 15px 15px; border-bottom:3px solid #dc0610; font-size:20px; padding-bottom:3px;}
	.evtNoti dd li {padding:0 0 7px 15px; font-size:17px;}
	.evtNoti dd li:after {top:5px; width:6px; height:6px;}
}
</style>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.mw').css('display','none');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsSubmit(){
	<% If IsUserLoginOK() Then %>
		<% If getnowdate>="2015-03-11" and getnowdate<"2015-03-16" Then %>
			<% if subscriptcount>0 then %>
				alert("이미 응모 하셨습니다.");
				return;
			<% else %>
				<% if staffconfirm and  request.cookies("uinfo")("muserlevel")=7 then		'request.cookies("uinfo")("muserlevel")		'/M , A		'response.cookies("uinfo")("userlevel")		'/WWW %>
					alert("텐바이텐 스탭이시군요! 죄송합니다. 참여가 어렵습니다. :)");
					return;
				<% else %>
					<% if itembuycount<1 then %>
						alert("텐바이텐 APP 구매 내역이 없습니다.");
						return;
					<% end if %>
					
					if ( confirm('응모하시겠습니까?') ){
						evtFrm1.action="/event/etc/doEventSubscript60274.asp";
						evtFrm1.target="evtFrmProc";
						evtFrm1.mode.value='valinsert';
						evtFrm1.submit();
					}else{
						return;
					}
				<% end if %>
			<% end if %>
		<% else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&getevt_codedisp)%>');
			return false;
		<% end if %>
	<% End IF %>
}

</script>
</head>
<body>

<!-- 마일리지를 사수하라 -->
<div class="mEvt60274">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60274/tit_get_mileage.gif" alt="마일리지를 사수하라" /></h2>
	<div class="getMileage">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60274/txt_process.gif" alt="마일리지를 사수방법" /></p>
		<a href="" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60274/btn_apply.gif" alt="응모하기" /></a>
	</div>

	<% if isApp<>1 then %>
		<p class="mw"><a href="/apps/link/?2820150310" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60274/btn_go_app.gif" alt="텐바이텐 APP 바로가기" /></a></p>
	<% end if %>

	<dl class="evtNoti">
		<dt>이벤트 유의사항</dt>
		<dd>
			<ul>
				<li>이벤트를 안내 받으신 고객님만을 위한 이벤트 입니다.</li>
				<li>3/11(수) ~ 15(일) 까지 app에서 구매한 내역만 구매금액으로 카운트 됩니다.</li>
				<li>이벤트 기간 중, 한 아이디 당 1회만 응모가 가능합니다.</li>
				<li>당첨자 발표 후, 환불이나 교환 건 발생 시 마일리지는 자동 소멸 됩니다.</li>
			</ul>
		</dd>
	</dl>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
	<input type="hidden" name="mode">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
<!--// 마일리지를 사수하라 -->

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->