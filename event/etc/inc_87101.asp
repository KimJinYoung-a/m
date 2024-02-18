<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  훈남정음 캐릭터 중 정음이와 어울리는 토이는? wa
' History : 2018-06-07 최종원
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
	eCode = "87101"
End If

vUserID = getEncLoginUserID

sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&vUserID&"' and evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 "
rsget.Open sqlstr, dbget, 1
	cnt = rsget("cnt")
rsget.close

%>
<style type="text/css">
.mEvt87101 h2 {background-color:#cbe8bb;}
.hoon-cont {background-color:#ffd9d8;}
.hoon-cont .vote ul {overflow:hidden; background-color:#ffdcd7;}
.hoon-cont .vote ul li {float:left; position:relative; width:50%;}
.hoon-cont .vote ul li button {position:absolute; bottom:0; z-index:10; width:81.33%;}
.hoon-cont .vote ul li button span {position:absolute; top:0; left:0; width:100%; height:100%;}
.hoon-cont .vote ul li:nth-child(2n-1) button {left:10.66%;}
.hoon-cont .vote ul li:nth-child(2n) button {right:10.66%;}
.hoon-cont .vote ul li:last-child {width:100%;}
.hoon-cont .vote ul li:last-child button {width:40.66%; left:30%;}
.hoon-cont .vote .ly-vod {position:absolute; top:0; left:0; z-index:10; width:100%; height:100%; background-color:rgba(0,0,0,.9);}
.hoon-cont .vote .ly-vod iframe {position:fixed; top:50%; z-index:15; width:100%; height:21.03rem; margin-top:-12rem; background-color:#000;}
.noti {padding:3.41rem 0; background-color:#f2f2f2;}
.noti h4 {width:18%; margin:0 auto 1.28rem;}
.noti ul {padding:0 10.67%;}
.noti ul li {font-size:1.05rem; line-height:1.79; font-weight:bold; text-indent:-.8rem;}
</style>

<script>
function fnPopupLayer(idx) {
	var imgSrcNum = '';
	switch(idx){
		case 1 : imgSrcNum = 'https://player.vimeo.com/video/273810085?autoplay=1';
			 break;
		case 2 : imgSrcNum = 'https://player.vimeo.com/video/273809385?autoplay=1';
			 break;
		case 3 : imgSrcNum = 'https://player.vimeo.com/video/273808464?autoplay=1';
			 break;
		case 4 : imgSrcNum = 'https://player.vimeo.com/video/273809236?autoplay=1';
			 break;
		case 5 : imgSrcNum = 'https://player.vimeo.com/video/274004278?autoplay=1';
			 break;
		case 6 : imgSrcNum = 'https://player.vimeo.com/video/273810260?autoplay=1';
			 break;
		case 7 : imgSrcNum = 'https://player.vimeo.com/video/273809660?autoplay=1';
			 break;
		case 8 : imgSrcNum = 'https://player.vimeo.com/video/273810009?autoplay=1';
			 break;
		case 9 : imgSrcNum = 'https://player.vimeo.com/video/274004463?autoplay=1';
			 break;
	}
	$('.ly-vod iframe').attr('src', imgSrcNum);
}

function fnVote(idx) {
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isapp="1" Then %>
				parent.calllogin();
				return;
			<% else %>
				parent.jsevtlogin();
				return;
			<% End If %>
		}
	<% End If %>
	<% If vUserID <> "" Then %>
	var reStr;
	var voteval = idx;
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/doeventsubscript/doEventSubscript87101.asp",
		data: "mode=vote&voteval="+voteval,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "vt") {
				<% if date() = "2018-07-13" then %>
					alert('이벤트에 응모하셨습니다.\n당첨일을 기대해 주세요!');
					document.location.reload();
				<% else %>
					alert('투표해 주셔서 감사합니다.\n내일 또 투표해 주세요 :)');
					document.location.reload();
				<% end if %>
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		}else{
			errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
//			document.location.reload();
			return false;
		}
	<% End If %>
}
$(function(){
	/*itemSlide1 = new Swiper('.rolling1 .swiper-container',{
		loop:true,
		autoplay:1800,
		autoplayDisableOnInteraction:false,
		speed:600,
		pagination:false,
		paginationClickable:true,
		effect:'fade'
	});*/

	// pop-layer
	$('.ly-vod').hide();
	$(".vote .thumb").click(function(){
		$('.ly-vod').show();
		$('.ly-vod iframe').show();
	});
	$(".ly-vod").click(function(){
		$('.ly-vod').hide();
	});

});
</script>
<script>

</script>
		<!-- 이벤트 배너 등록 영역 -->
		<div class="evtContV15">

			<div class="mEvt87101">
				<h2><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/tit_hoonnam.jpg" alt="훈남정음" /></h2>
				<div class="hoon-cont">
<!-- 					<div class="rolling1">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_slide_1.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_slide_2.jpg" alt="" /></div>
								<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_slide_3.jpg" alt="" /></div>
							</div>
						</div>
					</div>
					 -->
					<div class="hoon-slide">
						<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_slide_1.jpg?=v1.00" alt="" />
					</div>
					 <!-- 투표 -->
					<div class="vote">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/tit_vote.png" alt="정음이와 가장 잘 어울리는 토이는? 가장 많이 투표해주신 분 중 추첨을 통해, 20분께 훈남 공작소 토이를 드립니다!" /></h3>
						<ul>
							<li>
								<!-- for dev msg 각 thumb 클릭시 해당 동영상 재생 되도록 해주세요-->
								<div class="thumb" onClick=fnPopupLayer(1)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_1.jpg" alt="[마시멜로 맨] 달콤함을 좋아하는 그녀" /></div>
								<button onClick=fnVote(1);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" /> <!-- for dev msg 투표전 -->
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(2)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_2.jpg" alt="[곰돌이 푸] 푸처럼 항상 귀여운 그녀" /></div>
								<button onClick=fnVote(2);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(3)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_3.jpg" alt="[호두까기 인형] 빈티지를 좋아하는 그녀" /></div>
								<button onClick=fnVote(3);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(4)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_4.jpg" alt="[모빌] 조형미를 사랑하는 그녀" /></div>
								<button onClick=fnVote(4);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(5)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_5.jpg?v=1.00" alt="베어브릭_장미" /></div>
								<button onClick=fnVote(5);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(6)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_6.jpg" alt="[블랙팬서] 영웅처럼 듬직한 그녀" /></div>
								<button onClick=fnVote(6);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(7)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_7.jpg" alt="[코뿔소] 기발한 것을 좋아하는 그녀" /></div>
								<button onClick=fnVote(7);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(8)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_8.jpg" alt="[스누피 스쿨버스] 항상 교훈을 주는 그녀" /></div>
								<button onClick=fnVote(8);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
							<li>
								<div class="thumb" onClick=fnPopupLayer(9)><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_thumb_9.jpg" alt="[왕실 공주] 매일이 사랑스러운 그녀" /></div>
								<button onClick=fnVote(9);>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_vote.png" alt="투표하기" />
									<span>
									<%If cnt > 0 then%>
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_comp.png" alt="투표완료" /> <!-- for dev msg 투표후 -->
									<%End if%>
									</span>
								</button>
							</li>
						</ul>
						<!-- 동영상 레이어 팝업 -->
						<div class="ly-vod">
							<div class="vod"><iframe src="" frameborder="0"></iframe></div>
						</div>
						<!--// 동영상 레이어 팝업 -->

						<div class="gift"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_gift.jpg" alt="" /></div>
						<% If isapp="1" Then %>
							<a href="" class="submit" onclick="fnAmplitudeEventMultiPropertiesAction('click_event87101_vote','','',function(bool){if(bool) {fnAPPpopupExternalBrowser('http://programs.sbs.co.kr/drama/theundatables/vote/54999/10000000171?company=10');}});return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_submit.png?=v1.00" alt="훈남에게 어울리는 토이 투표하러 가기!" /></a>
						<% Else %>
							<a href="" class="submit" onclick="window.open('http://programs.sbs.co.kr/drama/theundatables/vote/54999/10000000171?company=10');fnAmplitudeEventMultiPropertiesAction('click_event87101_vote','','');"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/btn_submit.png?=v1.00" alt="훈남에게 어울리는 토이 투표하러 가기!" /></a>
						<% End If %>

					</div>
					<!--// 투표 -->

					<a href="/dramazone/" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/bnr_dramazone.png?v=1.00" alt="드라마존 바로가기" /></a>
					<a href="javascript:fnAPPselectGNBMenu('dramazone','http://m.10x10.co.kr/apps/appcom/wish/web2014/dramazone/index.asp');" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/bnr_dramazone.png?v=1.00" alt="드라마존 바로가기" /></a>

					<!-- 기획전 -->
					<div class="more">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/tit_more.png?v=1.00" alt="드라마 속 다양한 상품 구경하기" /></p>
						<ul>
							<li>
								<a href="/event/eventmain.asp?eventid=86960" onclick="jsEventlinkURL(86960);return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_more_1.jpg?v=1.00" alt="타쎈" />
								</a>
							</li>
							<li>
								<a href="/event/eventmain.asp?eventid=87115" onclick="jsEventlinkURL(87115);return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_more_2.jpg?v=1.02" alt="킨키로봇" />
								</a>
							</li>
							<li>
								<a href="/event/eventmain.asp?eventid=87070" onclick="jsEventlinkURL(87070);return false;">
									<img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/img_more_3.jpg?v=1.03" alt="플레이모빌" />
								</a>
							</li>
						</ul>
					</div>
					<!--// 기획전 -->

					<div class="noti">
						<h4><img src="http://webimage.10x10.co.kr/eventIMG/2018/87101/m/tit_noti.png" alt="유의사항" /></h4>
						<ul>
							<li>&middot; 본 이벤트는 하루에 한 번씩만 참여할 수 있습니다.</li>
							<li>&middot; 당첨자 발표는 7월 18일 텐바이텐 공지사항에 기재됩니다.</li>
							<li>&middot; 이벤트 상품은 랜덤으로 발송됩니다.</li>
							<li>&middot; 당첨자에게는 세무신고에 필요한 개인정보를 요청할 수 있으며, 제세공과금은 텐바이텐 부담입니다.</li>
						</ul>
					</div>
				</div>
			</div>

		</div>
		<!--// 이벤트 배너 등록 영역 -->
	<!-- //contents -->
<!-- #include virtual="/lib/db/dbclose.asp" -->