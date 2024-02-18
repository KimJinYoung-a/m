<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
'####################################################
' Description : 헬로우 텐바이텐
' History : 2018-02-14 정태훈
'####################################################
Dim eCode, userid

IF application("Svr_Info") = "Dev" THEN
	eCode   =  67508
Else
	eCode   =  84539
End If

userid = GetEncLoginUserID()

Dim sqlStr, CheckCode, CheckCnt
sqlStr = "SELECT hellokey FROM [db_temp].[dbo].[tbl_event_84539] WHERE userid='" & userid & "'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	CheckCode = rsget(0)
Else
	CheckCode=""
End IF
rsget.close

sqlStr = "SELECT count(hellokey) FROM [db_temp].[dbo].[tbl_event_84539] WHERE left(usedate,10)=left(getdate(),10) and isusing='N'"
rsget.CursorLocation = adUseClient
rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
IF Not rsget.Eof Then
	CheckCnt = rsget(0)
End IF
rsget.close
%>
<style>
.mEvt84539 h2 {position:relative;}
.mEvt84539 h2:after {content:''; display:inline-block; position:absolute; left:64.13%; top:27.79%; z-index:10; width:20.4%; height:24.02%; background:url(http://webimage.10x10.co.kr/eventIMG/2018/84539/m/img_character.gif) 0 0 no-repeat; background-size:100% auto;}
.story {position:relative;}
.story .pagination{position:absolute; bottom:4.02rem; z-index:20; left:0; width:100%;}
.story .swiper-pagination-switch {width:1.02rem; height:1.02rem; margin:0 0.5rem;  border:0.25rem solid #000; background-color:#ffd824;}
.story .swiper-active-switch {background-color:#000;}
.story button {position:absolute; top:34%; z-index:10; width:7.73%; background-color:transparent;}
.story .btn-prev {left:0;}
.story .btn-next {right:0;}
.process {position:relative;}
.process a {display:block; position:absolute; left:52%; top:17%; width:40.5%; height:38%; text-indent:-999em;}
.get-number {position:relative;}
.get-number .soldout {position:absolute; left:0; top:0; z-index:20; width:100%;}
.get-number .inner {position:absolute; left:0; top:34%; width:100%;}
.get-number .inner input {display:block; width:85%; height:5.5rem; margin:0 auto; font-size:2.1rem; text-align:center; color:#000; font-weight:600; border:0.25rem solid #000; border-radius:0.7rem;}
.get-number .inner button {display:block; width:100%; animation:bounce 1s 20;}
.noti {background:url(http://webimage.10x10.co.kr/eventIMG/2018/84539/m/bg_noti.png) 0 0 repeat; background-size:100% auto;}
.noti ul {padding:0 0 3rem 10%; color:#333; font-size:1.15rem; line-height:1.7;text-align:left;}
.noti li {text-indent:-.6rem; padding-left:.6rem;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(8px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript" src="/lib/js/clipboard.min.js"></script>
<script type="text/javascript">
$(function(){
	var swiper = new Swiper('.story .swiper-container', {
		loop:true,
		autoplay:2800,
		speed:600,
		pagination:".story .pagination",
		paginationClickable:true,
		prevButton:'.story .btn-prev',
		nextButton:'.story .btn-next',
		effect:'fade'
	});
});



function fnGoEnter(){
<% If userid<>"" Then %>
<% If now() > #02/13/2018 00:00:00# and now() < #02/19/2018 23:59:59# then %>
	var str = $.ajax({
		type: "POST",
		url: "/event/etc/doEventSubscript84539.asp",
		data: "mode=add",
		dataType: "text",
		async: false
	}).responseText;
	var str1 = str.split("|")
	if (str1[0] == "11"){
		//location.reload();
		$("#get-number").empty().html("<div class='inner'><input type='text' id='hellokey' value='" + str1[1] + "' readonly /><button type='button'  id='clipbtn' data-clipboard-target='#hellokey'><img src='http://webimage.10x10.co.kr/eventIMG/2018/84539/m/btn_copy.png' alt='비밀번호 복사하기' /></button></div>");
		return false;
	}else if (str1[0] == "12"){
		alert('이벤트 기간이 아닙니다.');
		return false;
	}else if (str1[0] == "13"){
		alert('오류가 발생했습니다. 다시 한번 시도해 주세요.');
		
		return false;
	}else if (str1[0] == "02"){
		alert('로그인 후 참여 가능합니다.');
		return false;
	}else if (str1[0] == "01"){
		alert('잘못된 접속입니다.');
		return false;
	}else if (str1[0] == "00"){
		alert('정상적인 경로가 아닙니다.');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
<% Else %>
	alert("이벤트 기간이 아닙니다.");
	return;
<% End If %>
<% Else %>
<% if isApp=1 then %>
	parent.calllogin();
	return false;
<% else %>
	parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
	return false;
<% end if %>	
<% End If %>
}
</script>
<script>
$(function(){
	var clipboard = new Clipboard('#clipbtn');

	clipboard.on('success', function(e) {
		alert("복사가 완료되었습니다.");
		console.log(e);
	});

	clipboard.on('error', function(e) {
		console.log(e);
	});
});
</script>
			<!-- 헬로우 텐바이텐 -->
			<div class="mEvt84539">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/tit_hello.png" alt="헬로우 텐바이텐" /></h2>
				<div class="story">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/img_slide_1.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/img_slide_2.png" alt="" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/img_slide_3.png" alt="" /></div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/btn_next.png" alt="다음" /></button>
				</div>
				<div class="process">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/img_process.png" alt="텐바이텐에서 비밀번호 받기!→헬로우봇 앱에 접속한다→라마마에게 '헬로우 텐바이텐'이라고 말을 건다→비밀번호 입력해서 하트 받기!" /></div>
					<a href="https://chat.hellobot.kr:4443/download?utm_source=tenbyten&utm_medium=banner" target="_blank">앱으로 이동하기</a>
				</div>
				<!-- 비밀번호 받기 -->
				<div class="get-number">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/tit_password.png" alt="비밀번호" /></h3>
					<div id="get-number">
				<% If CheckCode<>"" Then %>
					<div class="inner">
						<input type="text" id="hellokey" value="<%=CheckCode%>" readonly />
						<button type="button" id="clipbtn" data-clipboard-target="#hellokey"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/btn_copy.png" alt="비밀번호 복사하기" /></button>
					</div>
				<% Else %>
					<% If CheckCnt>0 Then %>
					<div class="inner">
						<input type="text" value="?" readonly />
						<button type="button" onClick="fnGoEnter()"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/btn_get.png" alt="비밀번호 받기" /></button>
					</div>
					<% Else %>
					<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/txt_soldout.png" alt="오늘 비밀번호를 모두 소진 되었습니다. 내일 다시 참여해주세요!" /></p>
					<div class="inner">
						<input type="text" value="?" readonly />
						<button type="button"><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/btn_get.png" alt="비밀번호 받기" /></button>
					</div>
					<% End If %>
				<% End If %>
					</div>
				</div>
				<!--// 비밀번호 받기 -->
				<div class="noti">
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/84539/m/tit_noti.png" alt="이벤트 유의사항" /></h3>
					<ul>
						<li>- 본 이벤트는 로그인 후 참여할 수 있습니다.</li>
						<li>- 이벤트는 ID 당 1회만 참여할 수 있습니다.</li>
						<li>- 헬로우봇 내에서 비밀번호는 1회 입력할 수 있습니다.</li>
						<li>- 매일 선착순 1,000명에게만 비밀번호가 지급됩니다.</li>
						<li>- iOS 10.0 이상, 안드로이드 4.4 킷캣 이상만 지원됩니다.</li>
						<li>- 2월 15~18일 이내에 이벤트 오류가 있을시, 1:1 게시판을 이용해주세요.</li>
					</ul>
				</div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->