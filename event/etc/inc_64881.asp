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
' Description : ## 하트비트한 친구들
' History : 2015-07-17 유태욱 생성
'####################################################
	Dim vUserID, eCode, nowdate
	Dim strSql , totcnt

	vUserID = GetLoginUserID
	nowdate = date()
'	nowdate = "2015-07-20"		'''''''''''''''''''''''''''''''''''''''''''''''''''''

	IF application("Svr_Info") = "Dev" THEN
		eCode = "64830"
	Else
		eCode = "64881"
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
.goBeat {position:relative;}
.goBeat a {display:block; position:absolute; left:20%; bottom:8.5%; width:60%; height:14%; font-size:0; color:transparent;}
.tentenMusic {background:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/bg_pattern.jpg) no-repeat 0 0; background-size:100% 100%;}
.tentenMusic .playList {width:240px; margin:0 auto; background:#333; border-radius:9px 9px 0 0;}
.tentenMusic .playList ul {position:relative; padding:5px 15px;}
.tentenMusic .playList ul:after {content:' '; display:inline-block; position:absolute; left:3%; top:0; width:94%; height:2px; background:#fdd21d; border-radius:3px;}
.tentenMusic .playList li {position:relative; padding:15px 0 16px; background:#333 url(http://webimage.10x10.co.kr/eventIMG/2015/64881/bg_line.gif) repeat-x 0 100%; background-size:1px 1px;}
.tentenMusic .playList li:last-child {background:none;}
.tentenMusic .playList li:after {content:' '; display:inline-block; position:absolute; left:0; top:50%; margin-top:-6px; background-position:0 0; background-repeat:no-repeat; width:12px; height:12px; background-size:85px auto; z-index:20;}
.tentenMusic .playList li:nth-child(1):after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song01.png);}
.tentenMusic .playList li:nth-child(2):after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song02.png);}
.tentenMusic .playList li:nth-child(3):after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song03.png);}
.tentenMusic .playList li:nth-child(4):after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song04.png);}
.tentenMusic .playList li:nth-child(5):after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song05.png);}
.tentenMusic .playList li:nth-child(6):after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song06.png);}
.tentenMusic .playList li:nth-child(7):after {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song07.png);}
.tentenMusic .playList li p {position:relative; font-size:1px;}
.tentenMusic .playList li p img {width:85px;}
.tentenMusic .playList li em {display:inline-block; position:absolute; right:0; top:50%; margin-top:-6px;}
.tentenMusic .playList li em img {width:60px;}
.tentenMusic .playList li input {position:relative; margin-left:13px; display:inline-block; width:130px; border:3px solid #ff9b00; color:#333; border-radius:0; box-shadow:3px 3px 5px 4px rgba(0,0,0,.3); z-index:30; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2015/64881/bg_cursor.gif) no-repeat 5px 50%; background-size:2px 14px;}
.tentenMusic .playList .deco {border-top:2px solid #fdd21d;}
.tentenMusic .btnSubmit {display:block; width:58%; margin:0 auto; padding-top:20px;}
.evtNoti {padding:35px 20px 0;}
.evtNoti h3 {position:relative; display:inline-block; font-size:14px; padding-bottom:5px; letter-spacing:3px; color:#2387ee; margin:0 0 15px 14px;}
.evtNoti h3:after {content:' '; display:inline-block; position:absolute; left:0; bottom:0; width:96%; height:3px; background:#2387ee; border-radius:3px;}
.evtNoti li {position:relative; font-size:12px; line-height:1.3; color:#000; padding:0 0 3px 14px;}
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:3px; width:2px; height:2px; border:2px solid #2387ee; border-radius:50%;}
@media all and (min-width:375px){
	.tentenMusic .playList {width:300px;}
	.tentenMusic .playList li input {width:185px;}
}
@media all and (min-width:480px){
	.tentenMusic .playList {width:380px; border-radius:13px 13px 0 0;}
	.tentenMusic .playList ul {padding:7px 23px;}
	.tentenMusic .playList ul:after {height:3px; border-radius:4px;}
	.tentenMusic .playList li {padding:18px 0;}
	.tentenMusic .playList li:after {margin-top:-9px; width:18px; height:18px; background-size:127px auto;}
	.tentenMusic .playList li p img {width:127px;}
	.tentenMusic .playList li em {margin-top:-7px;}
	.tentenMusic .playList li em img {width:90px;}
	.tentenMusic .playList li input {margin-left:20px; border:4px solid #ff9b00; background-position:7px 50%; background-size:3px 21px;}
	.tentenMusic .playList .deco {border-top:3px solid #fdd21d;}
	.tentenMusic .btnSubmit {padding-top:30px;}
	.evtNoti {padding:53px 30px 0;}
	.evtNoti h3 {font-size:21px; padding-bottom:7px; letter-spacing:4px; margin:0 0 23px 21px;}
	.evtNoti h3:after {height:4px; border-radius:4px;}
	.evtNoti li {font-size:18px; padding:0 0 4px 21px;}
	.evtNoti li:after {top:5px; width:3px; height:3px; border:3px solid #2387ee;}
}
</style>
<script type="text/javascript">
$(function(){
	$('.tentenMusic .playList li input').click(function() {
		$(this).css('background-image','none');
	});
});

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
					if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 40 || frm.txtcomm.value == '제목을 입력해주세요'){
						alert("제목이 없거나 제한길이를 초과하였습니다.");
						frm.txtcomm.focus();
						return false;
					}

			   		frm.mode.value="add";
					frm.action="/event/etc/doeventsubscript/doEventSubscript64881.asp";
					frm.target="evtFrmProc";
					frm.submit();
					return;

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
		url: "/event/etc/doeventsubscript/doEventSubscript64881.asp",
		data: "mode=appdowncnt",
		dataType: "text",
		async: false
	}).responseText;

	if (str == "OK"){
		var userAgent = navigator.userAgent.toLowerCase();
			parent.top.location.href='https://160656.measurementapi.com/serve?action=click&publisher_id=160656&site_id=83446&site_id_ios=88148&my_campaign=tenxten';
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

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}
}

</script>
	<!-- 하트비트한 친구들 -->
	<div class="mEvt64884">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_project.gif" alt="텐친소 프로젝트 #2 BEAT" /></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/tit_heart_beat.gif" alt="하트비트한 친구들" /></h2>
		<div class="beatStory">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story01.jpg" alt="요즘 들을 노래도 없는데.." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story02.jpg" alt="자꾸 돈은 나가고" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story03.jpg" alt="그렇다고 음악없인 살 수 없고" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story04.jpg" alt="더이상 고민하지 마세요! 당신을 도와줄 APP, 비트를 소개합니다!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story05.jpg" alt="기분따라 선곡할 필요없이 들을 수 있고" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story06.jpg" alt="내가 좋아하는 아티스트의 추천곡까지!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story07.jpg" alt="부담없이 무료로 즐길 수 있는" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_story08.jpg" alt="무료 음악 스트리밍 서비스 BEAT" /></p>
		</div>
		<div class="goBeat">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_beat_app.jpg" alt="BEAT, 함께해요!" /></p>
			<a href="" onclick="fnappdowncnt();return false;">비트 APP으로 가기</a>
		</div>
		<!-- 이벤트 참여 -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_event_v2.jpg" alt="비트에서 노래듣고 아래 플레이리스트를 채워주시면 당신의 음악감상을 도와드릴 선물을 드립니다." /></p>
		<div class="tentenMusic">
		<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="mode">
			<div class="playList">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/tit_10x10_play.png" alt="10X10 PLAY LIST" /></h3>
			<% If nowdate <= "2015-07-20" then %>
				<!-- 20일 -->
				<ul>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song01.png" alt="럭셔리버스" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer01.png" alt="원모어찬스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song02.png" alt="어때" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer02.png" alt="긱스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song03.png" alt="BIKE" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer03.png" alt="페퍼톤스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song04.png" alt="팥빙수" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer04.png" alt="윤종신" /></em></li>
					<li><p><input type="text" name="txtcomm" id="txtcomm" maxLength="40" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>제목을 입력해주세요<% else %>제목을 입력해주세요<% END IF %>" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer05.png" alt="인디고" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song06.png" alt="FLY" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer06.png" alt="에픽하이" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song07.png" alt="맥주와 땅콩" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer07.png" alt="쿨" /></em></li>
				</ul>
			<% elseIf nowdate = "2015-07-21" then %>
				<!-- 21일 -->
				<ul>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song01.png" alt="럭셔리버스" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer01.png" alt="원모어찬스" /></em></li>
					<li><p><input type="text" name="txtcomm" id="txtcomm" maxLength="40" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>제목을 입력해주세요<% else %>제목을 입력해주세요<% END IF %>" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer02.png" alt="긱스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song03.png" alt="BIKE" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer03.png" alt="페퍼톤스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song04.png" alt="팥빙수" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer04.png" alt="윤종신" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song05.png" alt="여름아 부탁해" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer05.png" alt="인디고" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song06.png" alt="FLY" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer06.png" alt="에픽하이" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song07.png" alt="맥주와 땅콩" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer07.png" alt="쿨" /></em></li>
				</ul>
			<% elseIf nowdate = "2015-07-22" then %>
				<!-- 22일 -->
				<ul>
					<li><p><input type="text" name="txtcomm" id="txtcomm" maxLength="40" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>제목을 입력해주세요<% else %>제목을 입력해주세요<% END IF %>" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer01.png" alt="원모어찬스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song02.png" alt="어때" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer02.png" alt="긱스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song03.png" alt="BIKE" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer03.png" alt="페퍼톤스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song04.png" alt="팥빙수" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer04.png" alt="윤종신" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song05.png" alt="여름아 부탁해" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer05.png" alt="인디고" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song06.png" alt="FLY" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer06.png" alt="에픽하이" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song07.png" alt="맥주와 땅콩" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer07.png" alt="쿨" /></em></li>
				</ul>
			<% elseIf nowdate = "2015-07-23" then %>
				<!-- 23일 -->
				<ul>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song01.png" alt="럭셔리버스" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer01.png" alt="원모어찬스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song02.png" alt="어때" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer02.png" alt="긱스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song03.png" alt="BIKE" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer03.png" alt="페퍼톤스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song04.png" alt="팥빙수" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer04.png" alt="윤종신" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song05.png" alt="여름아 부탁해" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer05.png" alt="인디고" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song06.png" alt="FLY" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer06.png" alt="에픽하이" /></em></li>
					<li><p><input type="text" name="txtcomm" id="txtcomm" maxLength="40" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>제목을 입력해주세요<% else %>제목을 입력해주세요<% END IF %>" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer07.png" alt="쿨" /></em></li>
				</ul>
			<% elseIf nowdate = "2015-07-24" then %>
				<!-- 24일 -->
				<ul>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song01.png" alt="럭셔리버스" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer01.png" alt="원모어찬스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song02.png" alt="어때" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer02.png" alt="긱스" /></em></li>
					<li><p><input type="text" name="txtcomm" id="txtcomm" maxLength="40" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>제목을 입력해주세요<% else %>제목을 입력해주세요<% END IF %>" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer03.png" alt="페퍼톤스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song04.png" alt="팥빙수" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer04.png" alt="윤종신" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song05.png" alt="여름아 부탁해" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer05.png" alt="인디고" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song06.png" alt="FLY" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer06.png" alt="에픽하이" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song07.png" alt="맥주와 땅콩" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer07.png" alt="쿨" /></em></li>
				</ul>
			<% elseIf nowdate = "2015-07-25" then %>
				<!-- 25일 -->
				<ul>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song01.png" alt="럭셔리버스" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer01.png" alt="원모어찬스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song02.png" alt="어때" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer02.png" alt="긱스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song03.png" alt="BIKE" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer03.png" alt="페퍼톤스" /></em></li>
					<li><p><input type="text" name="txtcomm" id="txtcomm" maxLength="40" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>제목을 입력해주세요<% else %>제목을 입력해주세요<% END IF %>" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer04.png" alt="윤종신" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song05.png" alt="여름아 부탁해" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer05.png" alt="인디고" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song06.png" alt="FLY" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer06.png" alt="에픽하이" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song07.png" alt="맥주와 땅콩" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer07.png" alt="쿨" /></em></li>
				</ul>
			<% elseIf nowdate >= "2015-07-26" then %>
				<!-- 26일 -->
				<ul>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song01.png" alt="럭셔리버스" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer01.png" alt="원모어찬스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song02.png" alt="어때" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer02.png" alt="긱스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song03.png" alt="BIKE" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer03.png" alt="페퍼톤스" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song04.png" alt="팥빙수" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer04.png" alt="윤종신" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song05.png" alt="여름아 부탁해" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer05.png" alt="인디고" /></em></li>
					<li><p><input type="text" name="txtcomm" id="txtcomm" maxLength="40" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <% IF NOT(IsUserLoginOK) THEN %>readonly<% END IF %> placeholder="<% IF NOT IsUserLoginOK THEN %>제목을 입력해주세요<% else %>제목을 입력해주세요<% END IF %>" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer06.png" alt="에픽하이" /></em></li>
					<li><p><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_song07.png" alt="맥주와 땅콩" /></p><em><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/txt_singer07.png" alt="쿨" /></em></li>
				</ul>
			<% end if %>
				<p class="deco"><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_play.gif" alt="" /></p>
			</div>
			<input type="image" onclick="jsSubmit(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2015/64881/btn_apply.png" alt="응모하기" class="btnSubmit" />
		</form>
		</div>
		<!--// 이벤트 참여 -->
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/64881/img_gift_v2.jpg" alt="GIFT" /></div>
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
	<!--// 하트비트한 친구들 -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
<!-- #include virtual="/lib/db/dbclose.asp" -->
