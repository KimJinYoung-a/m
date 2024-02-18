<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
	Dim userid, eCode, vQuery, vECodeLink
	userid = GetLoginUserID()
	
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21169"
		vECodeLink = "21170"
	Else
		eCode = "51568"
		vECodeLink = "51569"
	End If
	
	
	dim vCount, sqlstr, vTmpChk, vOrderCount
	sqlstr = "select count(*) from [db_event].[dbo].[tbl_event_subscript] where evt_code = '"& eCode &"' and userid = '" & userid & "' and sub_opt1 = 'evententer'"
	rsget.Open sqlstr,dbget,1
	vCount = rsget(0)
	rsget.close
	
	vOrderCount = 0
	If userid <> "" AND vCount < 1 Then
		sqlstr = "select count(*) from [db_temp].[dbo].[tbl_temp_Send_UserMail] where yyyymmdd = '20140513' and userid = '" & userid & "'"
		rsget.Open sqlstr,dbget,1
		vTmpChk = rsget(0)
		rsget.close
		
		If vTmpChk > 0 Then
			sqlstr = "select count(*) from [db_order].[dbo].[tbl_order_master] where userid = '" & userid & "' " & _
					 " and cancelyn = 'N' AND ipkumdiv > 3 and jumundiv<>9 and rdsite = 'app_wish' and regdate > '2014-05-13 00:00:00'"
			rsget.Open sqlstr,dbget,1
			vOrderCount = rsget(0)
			rsget.close
		End IF
	End IF
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 시크릿 MISSION</title>
<style type="text/css">
.mEvt51569 img {vertical-align:top;}
.mEvt51569 p {max-width:100%;}
.secretMission img {width:100%;}
.secretMission .saveMileage .btnEnter span {cursor:pointer;}
.secretMission .wishAppDownload .btnDownload span {cursor:pointer;}
.secretMission .eventNote {background-color:#f45600;}
.secretMission .eventNote ul {padding:0 3.75% 15px;}
.secretMission .saveMileage .btnEnter input {vertical-align:top;}
.secretMission .eventNote ul li {margin-bottom:10px; padding-left:3.2%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51569/blt_square_yellow.gif) left 5px no-repeat; background-size:5px 5px; color:#fff; font-size:15px; line-height:1.25em;}
@media all and (max-width:480px){
	.secretMission .eventNote ul li {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51569/blt_square_yellow.gif) left 3px no-repeat; background-size:3px 3px; font-size:11px;}
}
</style>
<script type="text/javascript">
	var userAgent = navigator.userAgent.toLowerCase();
	function gotoDownload(){
		// 모바일 홈페이지 바로가기 링크 생성
		if(userAgent.match('iphone')) { //아이폰
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('ipad')) { //아이패드
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('ipod')) { //아이팟
			parent.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
		} else if(userAgent.match('android')) { //안드로이드 기기
			parent.document.location="market://details?id=kr.tenbyten.shopping"
		} else { //그 외
			parent.document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
		}
	};
	
	function jsSubmitsms(frm){

	}	

	function jsEventEnter(){
		<% If IsUserLoginOK() Then %>
			<% If vCount > 0 Then %>
				alert("이미 응모를 하셨습니다!");
				return;
			<% Else %>
				<% If vOrderCount < 1 Then %>
					alert("구매 내역이 없습니다.\nAPP에서 첫 구매 후\n응모하기를 눌러주세요!\n\n※ 이메일로 이벤트안내를 받으신\n고객님만을 위한 이벤트입니다.");
					return;
				<% Else %>
					frmGubun2.submit();
					return;
				<% End If %>
			<% End If %>
		<% Else %>
			alert('로그인을 하셔야 이벤트\n응모가 가능합니다.');
			top.location.href = "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=vECodeLink%>"
			return;
		<% End IF %>
	}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt51569">
		<div class="secretMission">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/tit_secret_mission.jpg" alt="텐바이텐 WISH APP 출시 기념 우수고객 이벤트 SECRET MISSION" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/txt_secret_mission.jpg" alt="벤트 기간 중, APP에서 첫 구매 하시면 추첨을 통해 구매금액의 반!을 돌려드립니다! 이벤트 기간 : 05.13 (화) - 05.19 (월) / 당첨자 발표 : 05.30 (금)" /></p>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/tit_event_take_part.jpg" alt="이벤트 참여 방법" /></h3>
			<p>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/txt_event_take_part_01.jpg" alt="01. APP을 다운받고 실행하세요 &rarr; 02. 상단 메뉴에서 로그인해주세요 &rarr;" />
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/txt_event_take_part_02.jpg" alt="03. 평소에 꼭 사고싶었던 상품! APP에서 첫구매 해주세요 :)" />
			</p>

			<!-- 응모 -->
			<div class="saveMileage">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/tit_save_mileage.gif" alt="구매금액의 반을 돌려드립니다!" /></h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/txt_save_mileage.gif" alt="APP에서 첫구매 하셨나요? 자 이제, 응모하기 버튼을 눌러주세요~ 추첨을 통해 구매금액의 반을 마일리지로 돌려드립니다!" /></p>
				<div class="btnEnter"><span><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51569/btn_enter.png" style="width:100%;" onclick="jsEventEnter(); return false;" alt="응모하기" /></span></div>
			</div>
			<!-- //응모 -->

			<div class="wishAppDownload">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/tit_wish_app_download.jpg" alt="10X10 WISH APP 다운로드 방법! 지금 다운받고, MISSION 참여하세요!" /></h3>
				<div class="btnDownload"><span onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/btn_wish_app_download.jpg" alt="10X10 WISH APP DOWNLOAD" /></span></div>
			</div>

			<div class="eventNote">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51569/tit_note.gif" alt="이벤트 유의사항" /></h3>
				<ul>
					<li>이메일로 이벤트안내를 받으신 고객님만을 위한 이벤트 입니다.</li>
					<li>이벤트 기간 중, 한 아이디 당 1회만 응모가 가능합니다.</li>
					<li>당첨자 발표 후, 환불이나 교환이 발생할 시, 마일리지는 자동 소멸됩니다.</li>
				</ul>
			</div>
		</div>
	</div>
	<form name="frmGubun2" method="post" onsubmit="return false;" action="doEventSubscript51568.asp" style="margin:0px;" target="evtFrmProc">
	<input type="hidden" name="mode" value="addenter">
	</form>
	<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->