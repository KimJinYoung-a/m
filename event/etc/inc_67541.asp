<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 주말 데이트 - 도리화가
' History : 2015-11-19 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
Dim eCode , userid
dim sqlstr, vTotalCount
	
userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65953
Else
	eCode   =  67541
End If

'// 총 카운트
sqlstr = "select count(*) "
sqlstr = sqlstr & " from db_log.[dbo].[tbl_caution_event_log]"
sqlstr = sqlstr & " where evt_code='"& eCode &"'  "
rsget.Open sqlstr, dbget, 1

If Not rsget.Eof Then
	vTotalCount = rsget(0)
End IF
rsget.close
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt66424 .photo figcaption {visibility:hidden; width:0; height:0;}
.mEvt66424 .intro {position:relative;}
.movie {padding:0 4%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/67541/bg_paper.jpg) 0 0 no-repeat; background-size:100% 100%;}
.movie .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.btnApply {width:100%; vertical-align:top;}
.evtNoti {padding:7% 4.3% 6%; text-align:left; background:#fff7ec;}
.evtNoti h3 {display:inline-block; font-size:15px; padding-bottom:2px; border-bottom:2px solid #000; font-weight:bold; color:#000; margin:0 0 12px 8px;}
.evtNoti li {position:relative; font-size:11px; line-height:1.4; padding:0 0 3px 8px; color:#444; }
.evtNoti li:after {content:' '; display:inline-block; position:absolute; left:0; top:4px; width:3px; height:3px; background:#000; border-radius:50%;}
@media all and (min-width:480px){
	.evtNoti h3 {font-size:23px; padding-bottom:3px; margin:0 0 18px 12px;}
	.evtNoti li {font-size:17px; padding:0 0 4px 12px;}
	.evtNoti li:after {top:6px; width:4px; height:4px;}
}
</style>
<script>
function jsevtchk(){
	<% if Date() < "2015-11-20" or Date() > "2015-11-22" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript67541.asp",
			data: "mode=daily",
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="11")
				{
					alert("응모가 완료되었습니다.\n당첨자는 11월 23일에 발표합니다.");
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
					alert("이미 응모 하셨습니다.");
					return;
				}
				else if (result.resultcode=="88")
				{
					alert("이벤트 기간이 아닙니다.");
					return;
				}
			}
		});
	<% end if %>
}

function jsevtbnchk(evt){
	var result;
	$.ajax({
		type:"GET",
		url:"/event/etc/doeventsubscript/doEventSubscript67541.asp",
		data: "mode=evtbanner",
		dataType: "text",
		async:false,
		cache:false,
		success : function(Data){
			result = jQuery.parseJSON(Data);

			if (result.resultcode=="99")
			{
			<% if isApp then %>
				fnAPPpopupEvent(evt);
			<% else %>
				parent.location.href='/event/eventmain.asp?eventid='+evt;
			<% end if %>
			}
		}
	});

}

</script>
	<!-- 주말데이트:도리화가 -->
	<div class="mEvt67349">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67541/tit_weekend_date.jpg" alt ="주말데이트 - 외로운 주말, 집에만 있지 말고 텐바이텐과 함께 문화데이트를 즐기세요!" /></h2>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/67541/img_poster.jpg" alt ="영화:도리화가" /></div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67541/txt_invite.jpg" alt ="추첨을 통해 150분(1인2매)에게 영화 '도리화가' 전용 예매권을 드립니다!" /></p>
		<!-- 응모하기 -->
		<input type="image" class="btnApply" src="http://webimage.10x10.co.kr/eventIMG/2015/67541/btn_apply.jpg" alt ="응모하기" onclick="jsevtchk(); return false;"/>
		<!--// 응모하기 -->
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67541/tit_synopsis.jpg" alt ="시놉시스&amp;예고편" /></h3>
		<div class="movie">
			<div class="youtube"><iframe src='http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=3DF7DC84282049D5B988062E833F97B7DA2E&outKey=V124e4e2c142895a0e147338657ee98c82b526bbd0413058f1e4e338657ee98c82b52&controlBarMovable=true&jsCallable=true&skinName=default' frameborder='no' scrolling='no' marginwidth='0' marginheight='0' allowfullscreen></iframe></div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67541/txt_story.jpg" alt ="여자는 판소리를 할 수 없던 시대소리가 운명인 소녀가 나타나다!" /></p>
		<div class="evtNoti">
			<h3>이벤트 안내</h3>
			<ul>
				<li>텐바이텐 고객님을 위한 이벤트 입니다. 비회원이신 경우 회원가입 후 참여해 주세요.</li>
				<li>본 이벤트는 텐바이텐 모바일에서만 참여 가능합니다.</li>
				<li>본 이벤트는 ID당 1회만 응모가능 합니다.</li>
				<li>당첨자는 11월 23일 공지사항을 통해 확인 할 수 있습니다.</li>
				<li>당첨 시 개인정보에 있는 이메일 주소로 관람권이 발송 됩니다.<br />마이텐바이텐에서 이메일 주소를 확인해 주세요!</li>
			</ul>
		</div>
		<div><a href="" onclick="jsevtbnchk('67531'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67541/bnr_weekend.jpg" alt ="주말특가 보러가기" /></a></div>
		<% if userid = "bjh2546" or userid = "baboytw" then response.write vTotalCount end if %>
	</div>
	<!--// 주말데이트:도리화가 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->