<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim eCode, eCodeM
	IF application("Svr_Info") = "Dev" THEN
		eCodeM	= 21033
		eCode   = 21032
	Else
		eCodeM	= 47641
		eCode   = 47640
	End If

'응모 확인
Dim sqlStr
Dim chkSub: chkSub=false
dim loginid: loginid = GetLoginUserID()
if IsUserLoginOK then
	sqlStr = "Select count(sub_idx) " &_
			" From db_event.dbo.tbl_event_subscript " &_
			" WHERE evt_code=" & eCode &_
			" and userid='" & loginid & "'" &_
			" and sub_opt1='OO' "
	rsget.Open sqlStr,dbget,1
	if rsget(0)>0 then
		chkSub=true
	end if
	rsget.Close
end if
%>
<!doctype html>
<html lang="ko">
<head>
	<title>생활감성채널, 텐바이텐 > 이벤트 > 크리스마스 소원</title>
	<style type="text/css">
	.mEvt47641 {}
	.mEvt47641 img {vertical-align:top;}
	.mEvt47641 p {max-width:100%;}
	.mEvt47641 .mysticVideo {padding:20px 15px 15px; background:#cfe7ee;}
	.mEvt47641 .frame {position:relative; z-index:50; border:6px solid #fff; box-shadow:3px 3px 3px #a6c6d0; background:#000;}
	.mEvt47641 .frame .play {position:absolute; left:0; top:0; z-index:100; width:100%; height:120px; padding-top:50px; text-align:center; background:rgba(0,0,0,.6); cursor:pointer;}
	</style>
<script type="text/javascript">
$(function(){
	$("#btnVideoSub1").one("click",function(){
		if(islogin()=="False") {
			alert("이벤트에 참여하시려면 로그인이 필요합니다.");
			top.location.href="https://m.10x10.co.kr/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCodeM%>";
		} else {
			var frm = document.subForm;
			frm.evt_option.value="OX";
			frm.submit();
			$(this).hide();
			var vid1 = document.getElementById("vid503");
			var vid2 = document.getElementById("vid504");
			vid2.pause();
			vid1.play();
		}
	});

	$("#btnVideoSub2").one("click",function(){
		if(islogin()=="False") {
			alert("이벤트에 참여하시려면 로그인이 필요합니다.");
			top.location.href="https://m.10x10.co.kr/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=eCodeM%>";
		} else {
			var frm = document.subForm;
			frm.evt_option.value="XO";
			frm.submit();
			$(this).hide();
			var vid1 = document.getElementById("vid503");
			var vid2 = document.getElementById("vid504");
			vid1.pause();
			vid2.play();
		}
	});
});
</script>
</head>
<body>
<!-- content area -->
<div class="content" id="contentArea">
	<div class="mEvt47641">
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47641/47641_head.png" alt="크리스마스 소원" style="width:100%;" /></div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47641/47641_img01.png" alt="2013년 미스틱89의 특별한 크리스마스 앨범! 크리스마스 소원! 미스틱89 가수들의 크리스마스 인사 영상과 크리스마스의 소원 뮤직비디오를 감상하세요~ 두 영상을 모두 보신 분들 중 10명을 추첨해, 미스틱89의 뮤지션들의 사인을 담은 음반을 드립니다." style="width:100%;" /></div>
		<!-- 크리스마스 인사영상 -->
		<div class="mysticVideo">
			<div class="frame">
				<% if not(chkSub) then %><p id="btnVideoSub1" class="play"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47640/47640_btn_play.png" alt="PLAY" style="width:54px;" /></p><% end if %>
				<div><video id="vid503" poster="http://webimage.10x10.co.kr/video/vid503.gif" src="http://webimage.10x10.co.kr/video/vid503s.mp4" controls="true" width="100%" height="170px"></video></div>
			</div>
		</div>
		<!--// 크리스마스 인사영상 -->
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47641/47641_img02.png" alt="오직 텐바이텐 고객님들을 위한 미스틱89 뮤지션들의 크리스마스 인사!" style="width:100%;" /></div>
		<!-- 뮤직비디오 -->
		<div class="mysticVideo">
			<div class="frame">
				<% if not(chkSub) then %><p id="btnVideoSub2" class="play"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47640/47640_btn_play.png" alt="PLAY" style="width:54px;" /></p><% end if %>
				<div><video id="vid504" poster="http://webimage.10x10.co.kr/video/vid504.gif" src="http://webimage.10x10.co.kr/video/vid504s.mp4" controls="true" width="100%" height="170px"></video></div>
			</div>
		</div>
		<!--// 뮤직비디오 -->
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47641/47641_img03.png" alt="텐바이텐이 함께 한 미스틱89의 크리스마스 소원 뮤직비디오" style="width:100%;" /></div>
		<!-- 이벤트 응모 안내 -->
		<div class="applyEvt">
		<% if chkSub then %>
			<img id="evtInfoImg" src="http://webimage.10x10.co.kr/eventIMG/2013/47641/47641_txt_apply_finish.png" alt="감사합니다. 응모가 완료되었습니다." style="width:100%;" />
		<% else %>
			<img id="evtInfoImg" src="http://webimage.10x10.co.kr/eventIMG/2013/47641/47641_txt_apply.png" alt="영상을 모두 보시면 이벤트에 자동 응모됩니다. 아이디당 1회만 응모 가능합니다." style="width:100%;" />
		<% end if %>
		</div>
		<!-- 이벤트 응모 안내 -->
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47641/47641_img04.png" alt="뮤직비디오 속 텐바이텐 상품" style="width:100%;" /></div>
	</div>
	<form name="subForm" method="POST" action="/event/etc/doEventSubscript47641.asp" target="ifrSmt" style="margin:0;">
	<input type="hidden" name="evt_code" value="<%=eCode%>">
	<input type="hidden" name="returl" value="/event/eventmain.asp?eventid=<%=eCodeM%>">
	<input type="hidden" name="evt_option" value="XX">
	</form>
	<iframe align="center" name="ifrSmt" id="ifrSmt" src="" frameborder="0" height="0" width="0" ></iframe>
</div>
<!-- //content area -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
