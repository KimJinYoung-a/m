<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  텐텐백서
' History : 2018-07-23 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, vUserID, sqlstr, cnt

IF application("Svr_Info") = "Dev" THEN
	eCode = "68520"
Else
	eCode = "87941"
End If

vUserID = getEncLoginUserID

Dim logStore : logStore = requestCheckVar(Request("store"),16)

If logStore <> "" And Len(logstore) = 1 Then '// log입력
	sqlStr = " insert into db_temp.dbo.tbl_log_appdown_store (store) values ('"&logStore&"')"
	dbget.Execute sqlStr
End If

dim vAdrVer
vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)

%>
<style type="text/css">
.mEvt87941 {background-color:#f6f6f6;}
.rolling {position:relative;}
.rolling .pagination {position:absolute; bottom:7.68rem; left:0; width:100%; height:.8rem; z-index:50; padding-top:0; text-align:center;}
.rolling .pagination span {width:0.8rem; height:0.8rem; margin:0 .4rem; background:url(http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_pagination.png) 0 0 no-repeat; background-size:2.64rem;}
.rolling .pagination .swiper-active-switch {background-position:100% 0;}
.rolling .slideNav {position:absolute; top:49.13%; z-index:10; width:6.2%; background-color:transparent;}
.rolling .slideNav.btnPrev {left:7.5%;}
.rolling .slideNav.btnNext {right:7.5%;}
.noti {padding:3.84rem 0 2.98rem; color:#fff; background:#333333;}
.noti h3 {padding-bottom:1.45mrem; text-align:center;}
.noti h3 strong {display:inline-block; padding-bottom:0.2rem; font-size:1.45rem; border-bottom:0.17rem solid #fff;}
.noti ul {padding:2.34rem 12.26% 0;}
.noti li {position:relative; padding-left:1.2rem; padding-bottom:1.49rem; font-size:1.11rem; line-height:1.72;}
.noti li:before {display:inline-block; position:absolute; top:.8rem; left:0; width:.51rem; height:1px; background-color:#fff; content:' ';}
<% if isapp<>"1" then%>
.replyList {display:none;}
<% end if %>
</style>

<script type="text/javascript">
$(function(){
	rolling1 = new Swiper(".rolling .swiper-container",{
		loop:true,
		autoplay:1800,
		speed:600,
		pagination:".rolling .pagination",
		paginationClickable:true,
		nextButton:'.rolling .btnNext',
		prevButton:'.rolling .btnPrev',
		effect:'fade'
	});
});
var userAgent = navigator.userAgent.toLowerCase();
function gotoDownload(){
	// 모바일 홈페이지 바로가기 링크 생성
	if(userAgent.match('iphone')) { //아이폰
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipad')) { //아이패드
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('ipod')) { //아이팟
		window.parent.top.document.location="https://itunes.apple.com/kr/app/tenbaiten/id864817011";
	} else if(userAgent.match('android')) { //안드로이드 기기
		window.parent.top.document.location= 'market://details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	} else { //그 외
		window.parent.top.document.location= 'https://play.google.com/store/apps/details?id=kr.tenbyten.shopping&referrer=utm_source%3Dm10x10%26utm_medium%3Devent50401<%=request("ref")%>%5F<%=logStore%>';
	}
};



</script>
			<!-- 텐텐백서 vol.02 -->
			<div class="mEvt87941">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/tit_play.jpg" alt="텐텐백서 vol.02" /></h2>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/txt_play.jpg" alt="텐바이텐의 상품 추천 서비스 조각과 감성 컨텐츠 플레잉이 만나 쇼핑 플레이리스트 PLAY로 다시 태어났습니다! PLAY 기능에 대해 알아볼까요?" /></div>
				<div class="rolling">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/img_slide_1.jpg" alt="새로운 컨텐츠 보기!" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/img_slide_2.jpg" alt="연관 상품 소개!" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/img_slide_3.jpg" alt="영상으로 상품 보기!" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/img_slide_4.jpg" alt="보고 싶은 것만 쏙쏙!" /></div>
							<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/img_slide_5.jpg" alt="기록하기!" /></div>
						</div>
					</div>
					<div class="pagination"></div>
					<button type="button" class="slideNav btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_prev.png" alt="이전" /></button>
					<button type="button" class="slideNav btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_next.png" alt="다음" /></button>
				</div>
				<% If isapp="1" Then %>
					<% If flgDevice="I" Then %>
						<% If vAdrVer < "2.35" Then'구버전일 때 %>
							<a href="javascript:void(0);" onclick="gotoDownload();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_go_play.jpg" alt="play구경하러 가기 ※ PLAY는 APP 최신버전에서만 확인할 수 있습니다." /></a>
						<% else '최신버전일 때%>
							<a href="javascript:void(0);" onclick="fnAPPopenerJsCallClose('fnAPPselectGNBMenu(\'PLAY\',\'\')');"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_go_play.jpg" alt="play구경하러 가기 ※ PLAY는 APP 최신버전에서만 확인할 수 있습니다." /></a>
						<% end if %>
					<% else %>
						<a href="javascript:void(0);" onclick="alert('PLAY는 현재 IOS 앱에서만\n지원되는 기능입니다.\nAndroid 올 하반기 중 오픈 예정');"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_go_play.jpg" alt="play구경하러 가기 ※ PLAY는 APP 최신버전에서만 확인할 수 있습니다." /></a>
					<% end if %>
				<% else %>
					<% If flgDevice="I" Then %>
						<a href="javascript:void(0);" onclick="gotoDownload();"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_go_app.jpg" alt="APP 설치하고 PLAY 구경하기 ※ 현재 IOS만 지원됩니다.(Android 올 하반기 오픈 예정) ※ PLAY는 APP 최신버전에서만 확인할 수 있습니다. APP 실행 후, PLAY 코멘트 이벤트에 참여해보세요!" /></a>
					<% else %>
						<a href="javascript:void(0);" onclick="alert('PLAY는 현재 IOS 앱에서만\n지원되는 기능입니다.\nAndroid 올 하반기 중 오픈 예정');"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/btn_go_app.jpg" alt="APP 설치하고 PLAY 구경하기 ※ 현재 IOS만 지원됩니다.(Android 올 하반기 오픈 예정) ※ PLAY는 APP 최신버전에서만 확인할 수 있습니다. APP 실행 후, PLAY 코멘트 이벤트에 참여해보세요!" /></a>
					<% end if %>
				<% end if %>


				<% If isapp="1" Then %>
					<a href="#replyList"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87941/m/txt_cmt_evt.jpg" alt="play에 대한  기대평을 남겨주세요! 정성껏 댓글을 남겨주신 50분을 추첨하여 기프트 카드 1만원권을 선물합니다!" /></a>
				<% end if %>

				<% If isapp="1" Then %>
				<div class="noti">
					<h3><strong>이벤트 유의사항</strong></h3>
					<ul>
						<li>본 이벤트는 기간 동안 ID 당 1회만 응모하실 수 있습니다.</li>
						<li>통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</li>
						<li>당첨자 발표는 2018년 8월 3일 사이트 내 공지사항에 게시될 예정입니다.</li>
						<li>PLAY는 현재 iOS 최신버전 앱에서만 지원되는 기능입니다.</li>
					</ul>
				</div>
				<% end if %>
			</div>
			<!--// 텐텐백서 vol.02 -->



<!-- #include virtual="/lib/db/dbclose.asp" -->