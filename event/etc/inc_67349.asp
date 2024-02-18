<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 나를 미치게 하는 여자 (주말용)
' History : 2015-11-11 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid
	
userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65947
Else
	eCode   =  67349
End If
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66424 .photo figcaption {visibility:hidden; width:0; height:0;}
.mEvt66424 .intro {position:relative;}
.movie {padding:0 4%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67349/bg_noise.gif) 0 0 repeat-y; background-size:100% auto;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.btnApply {width:100%; vertical-align:top;}
.evtNoti {padding:7% 4.3% 6%; text-align:left; background:#fff7ec;}
.evtNoti h3 {display:inline-block; font-size:15px; padding-bottom:2px; border-bottom:2px solid #000; font-weight:bold; color:#000; margin:0 0 12px 8px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 8px; color:#444; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#000; border-radius:50%;}
</style>
<script>
function jsevtchk(){
	<% if Date() < "2015-11-13" or Date() > "2015-11-15" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript67349.asp",
			data: "mode=daily",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="11")
				{
					alert("응모가 완료되었습니다.\n당첨자는 11월 16일에 발표합니다.");
					return;
				}
				else if (result.resultcode=="44")
				{
					<% If isapp="1" Then %>
						calllogin();
						return;
					<% else %>
						jsevtlogin();
						return;
					<% End If %>
				}
				else if (result.resultcode=="33")
				{
					alert("오늘은 이미 응모 하셨습니다.");
					return;
				}
				else if (result.stcode=="88")
				{
					alert("이벤트 기간이 아닙니다.");
					return;
				}
			}
		});
	<% end if %>
}
</script>
<div class="mEvt67349">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67349/tit_weekend_date.jpg" alt ="주말데이트:나를 미치게 하는 여자" /></h2>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67349/img_poster.jpg" alt ="영화 포스터" /></div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67349/txt_invite.jpg" alt ="추첨을 통해 150분(1인2매)에게 영화 '나를 미치게 하는 여자'시사회 초대권을 드립니다!" /></p>
	<input type="image" class="btnApply" src="http://webimage.10x10.co.kr/eventIMG/2015/67349/btn_apply.jpg" alt ="응모하기" onclick="jsevtchk();"/>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67349/txt_caution.jpg" alt ="본 영화는 미성년자 관람 불가 영화입니다. 미성년자 회원분께서는 당첨이 되어도 관림이 불가하니 응모 전 참고 부탁 드립니다." /></p>
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67349/tit_synopsis.jpg" alt ="시놉시스&amp;예고편" /></h3>
	<div class="movie">
		<div class="youtube"><iframe src='http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=6FED0BBA3C73C09AFDF49047AD1D0F5E707B&outKey=V12535072eada13f231785c6592adb2af2303de41bc759e57a56f5c6592adb2af2303&controlBarMovable=true&jsCallable=true&skinName=default' frameborder='no' scrolling='no' marginwidth='0' marginheight='0' allowfullscreen></iframe></div>
	</div>
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67349/txt_story.jpg" alt ="가벼운 연애는 ‘꿀잼’ 진지한 사랑은 ‘노잼’한 사람과의 연애, 가능할까요? - 깊은 관계를 원하지 않는 뉴욕의 매거진 에디터 ‘에이미’는 성인이 된 후에도 한 사람에게 올인하는 것보다는 여러 남자와 자유로운 연애를 즐기며 화려한 싱글 라이프를 이어간다. 우연히 매력적인 스포츠 의사 ‘애론’을 취재하기 전까지는! 뻔뻔 당당한 워너비 싱글 ‘에이미’ VS 진실한 관계를 믿는 사랑꾼 ‘애론’ 달라도 너~무 다른 두 남녀의 극한 로맨스! 감당할 수 있겠는가…?" /></p>
	<div class="evtNoti">
		<h3>이벤트 안내</h3>
		<ul>
			<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
			<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
			<li>본 이벤트는 ID당 1회만 응모가능 합니다.</li>
			<li>당첨자는 11월 16일 공지사항을 통해 확인 할 수 있습니다.</li>
			<li>당첨 시 개인정보에 있는 이메일 주소로 관람권이 발송 됩니다.<br />마이텐바이텐에서 이메일 주소를 확인해 주세요!</li>
		</ul>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->