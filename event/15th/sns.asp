<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  [15주년] 전국 영상자랑 ma
' History : 2016.10.07 유태욱
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
Dim evt_code, userid, nowdate
dim subscriptcounttotalcnt, usersubscriptcount

usersubscriptcount=0
subscriptcounttotalcnt=0
userid = GetEncLoginUserID()

nowdate = now()
'	nowdate = #04/18/2016 10:05:00#

IF application("Svr_Info") = "Dev" THEN
	evt_code   =  66218
Else
	evt_code   =  73065
End If

subscriptcounttotalcnt = getevent_subscripttotalcount(evt_code, "Y", "", "")

'//본인 참여 여부
if userid<>"" then
	usersubscriptcount = getevent_subscriptexistscount(evt_code, userid, "Y", "", "")
end if

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[채널 teN 15] 전국 영상자랑!")
snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/15th/sns.asp")
snpPre		= Server.URLEncode("10x10")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐]에서 15주년을\n맞이하여 특별한 기념 영상을\n만들었어요!\n\n전국에 널리 공유해주신 분 중\n추첨을 통해 GIFT CARD를 드리니\n지금 참여해보세요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/img_kakao.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&evt_code
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&evt_code
End If
%>
<style type="text/css">
/* teN15th common */
.teN15th .noti {padding:3.5rem 2.5rem; background-color:#eee;}
.teN15th .noti h3 {position:relative; padding:0 0 1.2rem 2.4rem; font-size:1.4rem; line-height:2rem; font-weight:bold; color:#6752ac;}
.teN15th .noti h3:after {content:'!'; display:inline-block; position:absolute; left:0; top:0; width:1.8rem; height:1.8rem; color:#eee; font-size:1.3rem; line-height:2rem; font-weight:bold; text-align:center; background-color:#6752ac; border-radius:50%;}
.teN15th .noti li {position:relative; padding:0 0 0.3rem 0.65rem; color:#555; font-size:1rem; line-height:1.5;}
.teN15th .noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.7rem; width:0.35rem; height:1px; background-color:#555;}
.teN15th .noti li:last-child {padding-bottom:0;}
.teN15th .shareSns {position:relative;}
.teN15th .shareSns li {position:absolute; right:6.25%; width:31.25%;}
.teN15th .shareSns li.btnKakao {top:21.6%;}
.teN15th .shareSns li.btnFb {top:53.15%;}

/* video */
.videoScreen {position:relative;}
.videoScreen .commingSoon {position:absolute; top:5.2%; left:9.3%; width:81.5%;}
.videoScreen .screenDetails .tenByLogo {position:absolute; top:7.6%; left:12.8%; width:31%;}
.videoScreen .screenDetails .likeNum {position:absolute; bottom:6.2%; left:14.3%;}
.videoScreen .screenDetails .likeNum .btnLike {background:url(http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/btn_like_heart_v2.png) no-repeat 0 0; background-size:4.15rem auto; width:2.07rem; height:1.75rem; text-indent:-999em;}
.videoScreen .screenDetails .likeNum .btnLikeOn {background-position: 100% 0;}
.videoScreen .screenDetails .likeNum .txtLike01 img {width:3.3rem; height:1.3rem; margin:0.17rem 0 0 0.5rem;}
.videoScreen .screenDetails .likeNum .txtLike02 {margin-left:0.3rem; color:#6477ed; font-size:1.2rem; line-height:1rem; border-bottom:2px #6477ed solid; font-weight:bold; letter-spacing:0.03rem; }
.videoScreen .screenDetails .likeNum .txtLike03 img {width:1.15rem; height:1.3rem; margin:0.17rem -0.2rem;}

.videoWrap {position:absolute; top:22.4%; left:0; width:100%;}
.video {width:79.375%; margin-left:10.468%;}
.video .youtube {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.video .youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}
</style>
<script type="text/javascript">
$(function(){
	window.$('html,body').animate({scrollTop:$(".teN15th").offset().top}, 0);
});

function snschk(snsnum) {

	if(snsnum=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
	}else if(snsnum=="ka"){
		parent_kakaolink('<%=kakaotitle%>', '<%=kakaoimage%>' , '<%=kakaoimg_width%>' , '<%=kakaoimg_height%>' , '<%=kakaolink_url%>' );
		return false;
	}
}

function jssubmit(){
	<% If IsUserLoginOK() Then %>
		<% If not( left(nowdate,10)>="2016-10-07" and left(nowdate,10)<"2016-10-28" ) Then %>
			alert("이벤트 기간이 아닙니다.");
			return;
		<% else %>
			var str = $.ajax({
				type: "POST",
				url: "/event/15th/doeventsubscript/doEventSubscriptsns.asp",
				data: "mode=addok",
				dataType: "text",
				async: false
			}).responseText;
			var str1 = str.split("||")

			if (str1[0] == "11"){
				$("#btheart").addClass("btnLikeOn");
				$("#btheartcnt").text(str1[1]);
				$("#btheart").text("솔로티켓 좋아요 선택됨");
			}else if (str1[0] == "12"){
				$("#btheart").removeClass("btnLikeOn");
				$("#btheartcnt").text(str1[1]);
				$("#btheart").text("솔로티켓 좋아요 해제됨");
			}else if (str1[0] == "03"){
				alert('이벤트 응모 기간이 아닙니다.');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인을 해주세요.');
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
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&evt_code&"")%>');
			return false;
		<% end if %>
	<% End IF %>
}
</script>
	<%' 15주년 이벤트 : 전국영상자랑  %>
	<div class="teN15th">
		<div class="videoTitle">
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/tit_video.png" alt="전국영상자랑 텐바이텐편" />
		</div>
		<div class="videoScreen">
			<div class="screen">
				<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/img_video_screen.png" alt="" />
				<div class="screenDetails">
					<div class="tenByLogo"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/txt_tenbt_logo_v03.png" alt="your 10x10" /></div>
					<div class="videoWrap">
						<div class="video">
							<div class="youtube">
								<iframe src="https://www.youtube.com/embed/D3hUNlrHqac?rel=0" title="텐바이텐 15주년 텐바이텐이 쏜다" frameborder="0" allowfullscreen></iframe>
							</div>
						</div>
					</div>
					<div class="likeNum">
						<%' for dev message : 클릭시 btnLikeOn 클래스 추가 해주세요  %>
						<button id="btheart" onclick="jssubmit(); return false;" <% if usersubscriptcount > 0 then %>class="btnLike btnLikeOn"<% else %>class="btnLike"<% end if %>>좋아요</button>
						<span class="txtLike01"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/txt_like_01.png" alt="좋아요" /></span>
						<span class="txtLike02" id="btheartcnt"><%= CurrFormat(subscriptcounttotalcnt) %></span>
						<span class="txtLike03"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/txt_like_02_v2.png" alt="개" /></span>
					</div>
				</div>
			</div>
		</div>

		<div class="eventDetails">
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/txt_evnt_details.png" alt="EVENT 이 영상을 전국에 널리 퍼뜨려주세요! 추첨을 통해 30분께 텐바이텐 기프트카드 5만원권을 드립니다. 텐바이텐 페이스북 페이지으로 이동 영상 게시글을 좋아요 후 공유하기 공유 후 댓글을 통해 감상평 남기기 " />
		</div>
		<div class="goFb">
			<a href="https://www.facebook.com/your10x10/videos/1270345029652673/" onclick="fnAPPpopupExternalBrowser('https://www.facebook.com/your10x10/videos/1270345029652673/'); return false;" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73065/m/btn_go_fb.png" alt="텐바이텐 페이스북 공식계정 전국영상자랑 포스팅으로 이동 새창" /></a>
		</div>

		<%' 이벤트 유의사항  %>
		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>본 이벤트는 텐바이텐 공식 페이스북 (@your10x10)에서 진행되는 이벤트 입니다.</li>
				<li>당첨자발표는 10월 27일 목요일 텐바이텐 공식 페이스북 및 사이트 공지사항을 통해 발표될 예정입니다.</li>
			</ul>
		</div>
		<%' SNS 공유 %>
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/txt_share.png" alt="텐바이텐 15주년 이야기, 친구와 함께라면!" /></p>
			<ul>
			<li class="btnKakao"><a href="" onclick="snschk('ka'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_kakao.png" alt="텐바이텐 15주년 이야기 카카오톡으로 공유" /></a></li>
			<li class="btnFb"><a href="" onclick="snschk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/btn_facebook.png" alt="텐바이텐 15주년 이야기 페이스북으로 공유" /></a></li>
			</ul>
		</div>
		<ul class="tenSubNav">
			<li class="tPad1-5r"><a href="eventmain.asp?eventid=73063"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_walk.png" alt="워킹맨" /></a></li>
			<li class="tPad1r"><a href="eventmain.asp?eventid=73064"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_discount.png" alt="비정상할인" /></a></li>
			<li class="tPad1r"><a href="eventmain.asp?eventid=73053"><img src="http://webimage.10x10.co.kr/eventIMG/2016/15th/73053/m/bnr_main.png" alt="텐바이텐 15주년 이야기" /></a></li>
		</ul>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->