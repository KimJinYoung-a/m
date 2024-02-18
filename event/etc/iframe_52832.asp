<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description : 텐바이텐 x 왓챠
' History : 2014.06.25 이종화
'###########################################################

	dim eCode, cnt, sqlStr, regdate , totalsum
	Dim totcnt1 , totcnt2  , totcnt3

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  21217
	Else
		eCode   =  52832
	End If

	If IsUserLoginOK Then
		'1회 중복 응모 확인
		sqlStr = " Select count(sub_idx) " &VBCRLF
		sqlStr = sqlStr & " From db_event.dbo.tbl_event_subscript " &VBCRLF
		sqlStr = sqlStr & " WHERE evt_code='" & eCode & "'" &VBCRLF
		sqlStr = sqlStr & " and userid='" & GetLoginUserID() & "'"
		rsget.Open sqlStr,dbget,1
			cnt=rsget(0)
		rsget.Close
	End If
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 텐바이텐x왓챠</title>
<style type="text/css">
.mEvt52832 {position:relative;}
.mEvt52832 img {vertical-align:top; width:100%;}
.mEvt52832 p {max-width:100%;}
.mEvt52832 .summerGift {padding-bottom:27px; background:#a5e8e1;}
.mEvt52832 .summerGift ul {overflow:hidden; padding:22px 11px 30px;}
.mEvt52832 .summerGift li {position:relative; float:left; width:50%; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt52832 .summerGift li input {display:block; position:absolute; left:50%; top:65%; margin-left:-10px; }
.mEvt52832 .summerGift .btnApply {width:88%; margin:0 auto; padding:0px 0 0px;}
.mEvt52832 .summerGift .btnApply input {display:block; width:100%; -webkit-border-radius:0;}
.mEvt52832 .evtNoti {padding:24px 10px; text-align:left; background:#f9f9f9;}
.mEvt52832 .evtNoti dt {padding:0 0 12px 12px}
.mEvt52832 .evtNoti dt img {width:108px;}
.mEvt52832 .evtNoti li {position:relative; padding:0 0 5px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt52832 .evtNoti li:after {content:''; display:block; position:absolute; top:2px; left:0; width:0; height:0; border-color:transparent transparent transparent #5c5c5c; border-style:solid; border-width: 4px 0 4px 6px;}
.mEvt52832 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt52832 .evtNoti dt img {width:75px;}
	.mEvt52832 .evtNoti li {padding:0 0 3px 12px; font-size:11px; line-height:12px; letter-spacing:-0.055em;}
	.mEvt52832 .evtNoti li:after {top:1px;}
}
</style>
<script>
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipad')) { //아이패드
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('ipod')) { //아이팟
		document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011"
	} else if(userAgent.match('android')) { //안드로이드 기기
		document.location="market://details?id=kr.tenbyten.shopping"
	} else { //그 외
		document.location="https://play.google.com/store/apps/details?id=kr.tenbyten.shopping"
	}
};
</script>
<script>
<!--
	function checkform(frm) {
	<% if datediff("d",date(),"2014-07-04")>=0 then %>
		<% If IsUserLoginOK Then %>
			<% If cnt > 0 Then %>
					alert('1회 응모 가능 합니다.');
					return false;
			<% else %>
					if(!(frm.spoint[0].checked||frm.spoint[1].checked))
					{
						alert("상품을 선택 해주세요");
						return false;
					}

					frm.action = "doEventSubscript52832.asp";
					return true;
			<% end if %>
		<% Else %>
   			parent.jsevtlogin();
		<% End If %>
	<% else %>
			alert('이벤트가 종료되었습니다.');
			return;
	<% end if %>
	}	
//-->
</script>
</head>
<body>
<div class="mEvt52832">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/52832/tit_watcha_summer.png" alt="여름맞이 제가 책임질게요 - 디자인쇼핑몰 텐바이텐에서 왓챠 고객님께 드리는 특별한 여름맞이 선물! 응모하신 분들 중 추첨을 통해 여름맞이 선물을 드립니다. 이벤트 기간 : 06.27(금)~07.04(금)/당첨자 발표 : 07.08(화)" /></h3>
	<form name="frm" method="POST" style="margin:0px;" onSubmit="return checkform(this);">
	<div class="summerGift">
		<ul>
			<li>
				<label for="fan"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52832/img_fan.png" alt="스파이더맨 선풍기 - 너무 더워요 도와줘요 스파이더맨!" /></label>
				<input type="radio" id="fan" name="spoint" value="1" />
			</li>
			<li>
				<label for="blanket"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52832/img_blanket.png" alt="썸머블랑켓 - 여름감기는 뭐도 안 걸려요. 한 여름 밤을 책임질게요!" /></label>
				<input type="radio" id="blanket" name="spoint" value="2" />
			</li>
		</ul>
		<p class="btnApply"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/52832/btn_apply.png" alt="응모하기" /></p>
	</div>
	</form>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/52832/tit_noti.png" alt="이벤트 유의사항" /></dt>
		<dd>
			<ul>
				<li>한 ID당 1회 참여 가능합니다.</li>
				<li>추첨을 통해, 총 70분에게 여름맞이 선물을 드립니다.</li>
				<li>당첨자는 7월 3일 텐바이텐에서 발표합니다.</li>
				<li>당첨 발표 당시의 재고수량에 따라 상품이 변경 될 수 있습니다.</li>
				<li>당첨 시 상품수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
			</ul>
		</dd>
	</dl>
	<p><a href="#" onclick="gotoDownload()"><img src="http://webimage.10x10.co.kr/eventIMG/2014/52832/btn_app_download.png" alt="텐바이텐 " /></a></p>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->