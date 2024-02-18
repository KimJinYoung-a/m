<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%

'###########################################################
' Description : 텐바이텐 X 알람몬 10시에 만나요!
' History : 2014.07.16 원승현
'###########################################################

dim eCode, cnt, sqlStr, couponkey, regdate, gubun, arrList, i, totalsum, linkeCode, imgLoop, imgLoopVal
	IF application("Svr_Info") = "Dev" THEN
		eCode 		= "21242"
		linkeCode = "21242"
	Else
		eCode 		= "53581"
		linkeCode = "53581"
	End If

If IsUserLoginOK Then
	'// 총 응모횟수, 개인별 응모횟수값 가져온다.
	sqlstr = "Select count(sub_idx) as totcnt" &_
			"  ,count(case when convert(varchar(10),regdate,120) = '" & Left(now(),10) & "' then sub_idx end) as daycnt" &_
			" From db_event.dbo.tbl_event_subscript" &_
			" WHERE evt_code='" & eCode & "' and userid='" & GetLoginUserID() & "'"
			'response.write sqlstr
	rsget.Open sqlStr,dbget,1
		totalsum = rsget(0)
		cnt = rsget(1)
	rsget.Close
End If


'// 꽝 이미지 랜덤
	randomize
	imgLoop=int(Rnd*4)+1
	Select Case Trim(imgLoop)
		Case "1"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_lose01.gif"
		Case "2"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_lose02.gif"			
		Case "3"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_lose03.gif"
		Case "4"
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_lose01.gif"
		Case Else
			imgLoopVal = "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_lose02.gif"
	End Select



%>
<html lang="ko">
<head>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 10시에 만나요!</title>
<style type="text/css">
.mEvt53581 {position:relative;}
.mEvt53581 img {vertical-align:top; width:100%;}
.mEvt53581 p {max-width:100%;}
.mEvt53581 .evtApply {padding-bottom:28px; background:#88d658;}
.mEvt53581 .evtApply .presentB {display:block; width:68%; margin:17px auto 0; }
.mEvt53581 .evtResult {padding-bottom:28px; background:#88d658;}
.mEvt53581 .alarmApp {position:relative; margin:0;}
.mEvt53581 .alarmApp dd {position:absolute; left:16%; bottom:8%; width:68%; margin:0;}
.mEvt53581 .evtNoti {padding-top:24px; text-align:left;}
.mEvt53581 .evtNoti dt {padding:0 0 15px 22px}
.mEvt53581 .evtNoti dt img {width:113px;}
.mEvt53581 .evtNoti dd {margin:0;}
.mEvt53581 .evtNoti ul {padding:0 10px;}
.mEvt53581 .evtNoti li {position:relative; padding:0 0 8px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt53581 .evtNoti li:after {content:''; display:block; position:absolute; top:3px; left:0; width:0; height:0; border-color:transparent transparent transparent #5c5c5c; border-style:solid; border-width:4px 0 4px 6px;}
.mEvt53581 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt53581 .evtNoti dt img {width:75px;}
	.mEvt53581 .evtNoti li {padding:0 0 5px 12px; font-size:11px; line-height:12px; background-position:left 4px;}
	.mEvt53581 .evtNoti li:after {top:2px;}
}
</style>
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript" src="/apps/appCom/wish/webview/js/tencommon.js?v=1.1"></script>
<script type="text/javascript" src="/lib/js/base64.js"></script>

<script type="text/javascript">

function checkform() {
<% if datediff("d",date(),"2014-07-27")>=0 then %>
	<% If IsUserLoginOK Then %>
		<% if cnt >= 1 then %>
		alert('하루 1회만 응모 가능합니다.\n내일 다시 응모해주세요. :)');
		<% else %>
			var $str;
			$.ajax({
				type:"GET",
				url:"doEventSubscript53581.asp",
				data: $("#frm").serialize(),
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
						$str = $(Data);
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									if (Data=="99")
									{
										alert("존재하지 않는 이벤트 입니다.");
										return;
									}
									else if (Data=="88")
									{
										alert("죄송합니다. 이벤트 기간이 아닙니다.");
										return;
									}
									else if (Data=="77")
									{
										alert("이벤트에 응모를 하려면 로그인이 필요합니다.");
										return;
									}
									else if (Data=="66")
									{
										alert("하루 1회만 응모 가능합니다.\n\n내일 다시 응모해주세요.");
										return;
									}
									else
									{
										$("#chgImageSection").attr("src", "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_rotate.gif");
										setTimeout("chgImgSlot("+Data+")", 2000);
									}
								} else {
									alert("오류가 발생하였습니다. 다시 참여해주세요.");
									return;
								}
							}
						}

				}
			});
		<% end if %>
	<% Else %>
		alert('로그인 후에 응모하실 수 있습니다.');
		calllogin();
		return;
	<% End If %>
<% else %>
		alert('이벤트가 종료되었습니다.');
		return;
<% end if %>
}



function chgImgSlot(rtnval)
{
	if (rtnval=="1")
	{
		$("#chgImageSection").attr("src", "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_win01.gif");
		$("#PreBtnChg").html("<img src='http://webimage.10x10.co.kr/eventIMG/2014/53581/img_pop_win01.png' alt='메티몬스터 팝업텐트 당첨!' />");
	}
	else if (rtnval=="2")
	{
		$("#chgImageSection").attr("src", "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_win02.gif");	
		$("#PreBtnChg").html("<img src='http://webimage.10x10.co.kr/eventIMG/2014/53581/img_pop_win02.png' alt='메티몬스터 팝업텐트 당첨!' />");
	}
	else if (rtnval=="3")
	{
		$("#chgImageSection").attr("src", "http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_win03.gif");	
		$("#PreBtnChg").html("<img src='http://webimage.10x10.co.kr/eventIMG/2014/53581/img_pop_win03.png' alt='메티몬스터 팝업텐트 당첨!' />");
	}
	else
	{
		$("#chgImageSection").attr("src", "<%=imgLoopVal%>");	
		$("#PreBtnChg").html("<img src='http://webimage.10x10.co.kr/eventIMG/2014/53581/img_pop_lose.png' alt='메티몬스터 팝업텐트 당첨!' />");
	}
}


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
</head>
<body>
	<!-- 10시에 만나요!(M) -->
	<div class="mEvt53581">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/tit_alarmmon.png" alt="텐바이텐과 알람몬의 몬스터급 만남 - 10시에 만나요!" /></h3>
		<!-- 이벤트 응모 -->
		<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/tit_evenet.png" alt="같은 이미지가 3개 나오면 당첨! '선물주세요'버튼을 눌러 당첨을 확인하세요!" /></h4>
		<div class="evtApply">
			<p>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/img_game_default.gif" id="chgImageSection" />
			</p>
			<p>
				<div id="PreBtnChg">
					<input type="image" onclick="checkform();"src="http://webimage.10x10.co.kr/eventIMG/2014/53581/btn_present.png" alt="선물주세요!" class="presentB" />
				</div>
			</p>
		</div>
		<!--// 이벤트 응모 -->
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/img_gift_new.png" alt="EVENT GIFT" /></p>
		<dl class="alarmApp">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/txt_info_alarmmon.png" alt="텐바이텐의 친구, 알람계의 몬스터 알람몬!" /></dt>
			<dd><a href="#" onclick="openbrowser('http://bit.ly/1tYb6Ho');"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/btn_download_alarmmon.png" alt="알람몬에서 알람 설정하기" /></a></dd>
		</dl>
		<dl class="evtNoti">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53581/tit_notice.png" alt="이벤트 유의사항" /></dt>
			<dd>
				<ul>
					<li>텐바이텐에서 로그인 후 이벤트 참여가 가능합니다.</li>
					<li>이벤트 참여는 텐바이텐 APP을 통해 1일 1회 가능합니다.</li>
					<li>당첨자 공지는 7월 29일 (화) 예정입니다.</li>
					<li>사은품 발송을 위해 개인정보를 요청할 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
	<!-- //10시에 만나요!(M) -->


<form name="frm" id="frm" method="get" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="linkeventid" value="<%=linkeCode%>">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
</form>
</body>
</html>