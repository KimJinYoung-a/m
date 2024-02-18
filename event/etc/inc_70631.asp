<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'###########################################################
' Description : 앵그리버드 행운을 날리새오!
' History : 2016.05.04 김진영
'###########################################################
Dim eCode, cnt, sqlStr, i, totalsum, irdsite20, vUserID
If application("Svr_Info") = "Dev" Then
	eCode 		= "66119"
Else
	eCode 		= "70631"
End If

irdsite20	= requestCheckVar(request("rdsite"), 32)
vUserID		= GetEncLoginUserID

'If IsUserLoginOK Then
'	'// 총 응모횟수, 개인별 응모횟수값 가져온다.
'	sqlstr = ""
'	sqlstr = sqlstr & " SELECT COUNT(sub_idx) as totcnt " 
'	sqlstr = sqlstr & " ,COUNT(CASE WHEN convert(varchar(10), regdate, 120) = '" & Left(now(),10) & "' THEN sub_idx END) as daycnt " 
'	sqlstr = sqlstr & " FROM db_event.dbo.tbl_event_subscript " 
'	sqlstr = sqlstr & " WHERE evt_code='" & eCode & "' and userid='" & vUserID & "' " 
'	rsget.Open sqlStr, dbget, 1
'		totalsum	= rsget(0)
'		cnt			= rsget(1)
'	rsget.Close
'End If

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 앵그리버드 행운을 날리새오!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
'Dim kakaotitle : kakaotitle = "[텐바이텐] 돌아온 크리스박스\n\n12월, 놀라운 선물을 갖고\n텐바이텐이 돌아왔습니다.\n\n배송비만 내면 엄청난 선물이\n랜덤으로 찾아갑니다.\n\n주인공은 바로 당신\n지금 도전하세요!\n\n오직 텐바이텐 모바일에서!"
Dim kakaotitle : kakaotitle = "[텐바이텐] TEST"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/67929/01/img_bnr_kakao.png"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url 
If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
End If
%>
<style type="text/css">
html {font-size:11.71px;}
@media (max-width:320px) and (orientation:portrait) {html{font-size:10px;}}
@media (min-width:414px) and (orientation:portrait) {html{font-size:12.93px;}}
@media (min-width:480px) and (orientation:portrait) {html{font-size:15px;}}
@media (min-width:640px) and (orientation:portrait) {html{font-size:20px;}}
@media (min-width:736px) and (orientation:portrait) {html{font-size:23px;}}

img {vertical-align:top;}
.angryBird {position:relative; background:#b9eefe;}
.angryBird .btnFly {display:block; position:absolute; left:0; bottom:0; width:100%; background:transparent;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; left:15%; top:34%; width:70%; height:45%;}
.shareSns li {float:left; width:33.33333%; height:100%; padding:0 2%;}
.shareSns li a {display:block; height:100%; text-indent:-999em; background:transparent;}
.rolling {padding:0 6.2%; background:#65d7f1;}
.rolling .swiper {position:relative; border:0.5rem solid #fff; background:#fff;}
.rolling .swiper .swiper-container {width:100%; background:#fff;}
.rolling .swiper-slide {position:relative;}
.rolling .swiper button {position:absolute; top:43%; z-index:20; width:9.6%; background:transparent;}
.rolling .swiper .btnPrev {left:0;}
.rolling .swiper .btnNext {right:0;}
.rolling .swiper .pagination {overflow:hidden; position:absolute; bottom:-2.2rem; left:0; width:100%; height:0.6rem; z-index:50; padding-top:0; text-align:center;}
.rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; position:relative; z-index:50; width:0.6rem; height:0.6rem; border:2px solid #fff; margin:0 0.3rem; background-color:transparent; cursor:pointer;}
.rolling .swiper .pagination .swiper-active-switch {border-color:#fff182;}
.rolling .swiper .video {width:100%; height:100%; background:#000;}
.rolling .swiper .video .naver {overflow:hidden; position:relative; height:0; padding-bottom:60.95%; background:#000;}
.rolling .swiper .video .naver iframe {position:absolute; top:0; left:0; width:100%; height:100%; vertical-align:top;}
.rolling .swiper .mask {position:absolute; left:0; z-index:50; width:100%; height:33%; background:transparent;}
.rolling .swiper .mask.top {top:0;}
.rolling .swiper .mask.bottom {bottom:0;}
.evtNoti {padding:2.2rem 7.2%; background:#f5f6f8;}
.evtNoti h3 {padding-bottom:0.3rem;}
.evtNoti h3 strong {display:inline-block; font-size:1.2rem; padding-bottom:0.2rem; color:#f05c54; border-bottom:2px solid #f05c54;}
.evtNoti li {position:relative; font-size:0.9rem; color:#717171; line-height:1.1; padding-left:0.9rem; margin-top:0.6rem;}
.evtNoti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.2rem; width:2px; height:2px; border:1.5px solid #f1716b; border-radius:50%;}
</style>
<script type="text/javascript">

$(function(){
	window.$('html,body').animate({scrollTop:$(".angryBefore").offset().top}, 0);
});

function checkform(){
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
		// 오픈시 바꿔야됨
		<% If Now() >= #05/04/2016 10:00:00# And now() < #05/18/2016 23:59:59# Then %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doEventSubscript70631.asp",
				data: "mode=add",
				dataType: "text",
				async:false,
				cache:true,
				success : function(Data, textStatus, jqXHR){
					if (jqXHR.readyState == 4) {
						if (jqXHR.status == 200) {
							if(Data!="") {
								var str;
								for(var i in Data){
									 if(Data.hasOwnProperty(i)){
										str += Data[i];
									}
								}
								str = str.replace("undefined","");
								res = str.split("|");
								if (res[0]=="OK"){
									$('#slotImg').removeClass().addClass('angryResult');
									$("#slotImg").empty().html(res[1]);
									$("#slotImg").show();
									window.parent.$('html,body').animate({scrollTop:$(".angryBird").offset().top},300);
								} else {
									errorMsg = res[1].replace(">?n", "\n");
									alert(errorMsg);
									document.location.reload();
									return false;
								}
							} else {
								alert("잘못된 접근 입니다.");
								document.location.reload();
								return false;
							}
						}
					}
				},
				error:function(jqXHR, textStatus, errorThrown){
					alert("잘못된 접근 입니다.");
					//var str;
					//for(var i in jqXHR)
					//{
					//	 if(jqXHR.hasOwnProperty(i))
					//	{
					//		str += jqXHR[i];
					//	}
					//}
					//alert(str);
					document.location.reload();
					return false;
				}
			});
		<% Else %>
			alert("이벤트 응모 기간이 아닙니다.");
			return;				
		<% End If %>
	<% End If %>
}

function snschk(snsnum) {
	<% If vUserID = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			<% If isApp = 1 Then %>
				parent.calllogin();
				return false;
			<% Else %>
				parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=" & eCode)%>');
				return false;
			<% End If %>
			return false;
		}
	<% End If %>
	<% If vUserID <> "" Then %>
	var reStr;
	var str = $.ajax({
		type: "GET",
		url:"/event/etc/doEventSubscript70631.asp",
		data: "mode=snschk&snsnum="+snsnum,
		dataType: "text",
		async: false
	}).responseText;
	reStr = str.split("|");
	if(reStr[1] == "tw") {
		popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
		$('#slotImg').removeClass().addClass('angryBefore');
		$("#slotImg").empty().html(reStr[2]);
		$("#slotImg").show();
	}else if(reStr[1]=="fb"){
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
		$('#slotImg').removeClass().addClass('angryBefore');
		$("#slotImg").empty().html(reStr[2]);
		$("#slotImg").show();
	}else if(reStr[1]=="ka"){
		<% If isApp = "1" Then %>
			parent_kakaolink('텐바이텐에 앵그리버드가 떴다!\n\n영화 예매권, 레고, 피규어 등이 잔뜩 준비된 텐바이텐 이벤트로 지금 놀러 오세요. 선물이 팡팡 터집니다!\n\n텐바이텐 X 앵그리버드 더 무비\nhttp://bit.ly/hello10x10' , 'http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=70631' );
		<% Else %>
			parent_kakaolink('텐바이텐에 앵그리버드가 떴다!\n\n영화 예매권, 레고, 피규어 등이 잔뜩 준비된 텐바이텐 이벤트로 지금 놀러 오세요. 선물이 팡팡 터집니다!\n\n텐바이텐 X 앵그리버드 더 무비\nhttp://bit.ly/hello10x10' , 'http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=70631' );
		<% End If %>
		$('#slotImg').removeClass().addClass('angryBefore');
		$("#slotImg").empty().html(reStr[2]);
		$("#slotImg").show();
	}else if(reStr[1] == "none"){
		alert('참여 이력이 없습니다.\n응모후 이용 하세요');
		return false;
	}else if(reStr[1] == "end"){
		alert('오늘 응모를 모두 하셨습니다.');
		return false;
	}else{
		alert('오류가 발생했습니다.');
		return false;
	}
	<% End If %>
}
</script>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper1',{
		loop:true,
		autoplay:false,
		speed:600,
		pagination:".pagination",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:".btnNext",
		prevButton:".btnPrev"
	});
	//화면 회전시 리드로잉(지연 실행)
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
			mySwiper.reInit();
				clearInterval(oTm);
		}, 500);
	});
});
</script>
<div class="evtCont">
	<div class="mEvt70631">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/tit_fly_lucky.png" alt="행운을 날리새오" /></h2>
		<div class="angryBird">
			<div class="angryBefore" id="slotImg">
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_roulette.gif" alt="룰렛이미지" /></div>
				<button type="button" class="btnFly" onclick="checkform();return false;" ><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/btn_fly.png" alt="날리기 GO!" /></button>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/bg_blank.png" alt="" /></div>
			</div>
		</div>
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/txt_share.png" alt="하루 한 번 참여 가능! 친구 초대시 한번 더 기회가!" /></p>
			<ul>
				<li><a href="" onclick="snschk('ka'); return false;"><span></span>카카오톡</a></li>
				<li><a href="" onclick="snschk('fb'); return false;"><span></span>페이스북</a></li>
				<li><a href="" onclick="snschk('tw'); return false;"><span></span>트위터</a></li>
			</ul>
		</div>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_gift.jpg" alt="앵그리버드가 쏘는 룰렛 경품보기" /></div>
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/tit_preview.png" alt="영화 미리보기" /></h3>
		<div class="rolling">
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_slide_05.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/img_slide_04.jpg" alt="" /></div>
						<div class="swiper-slide">
							<div class="mask top"></div>
							<div class="mask bottom"></div>
							<div class="video"><div class="naver"><iframe src="http://serviceapi.rmcnmv.naver.com/flash/outKeyPlayer.nhn?vid=90151787156BBEC09CF84A2ABC703854D2D4&outKey=V1262d7a526dfa3f8b623528e2fcba8005b179581a9f68ac1a7db528e2fcba8005b17&controlBarMovable=true&jsCallable=true&skinName=tvcast_white" frameborder="0" allowfullscreen></iframe></div></div>
						</div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/btn_next.png" alt="다음" /></button>
			</div>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/txt_story.jpg" alt="영화 미리보기" /></p>
		<div class="evtNoti">
			<h3><strong>유의사항</strong></h3>
			<ul>
				<li>텐바이텐 고객 대상 이벤트 입니다.</li>
				<li>한 ID당 하루 한 번 참여하실 수 있습니다.</li>
				<li>친구초대 시 한 번 더 가능합니다. (일 최대 2번)</li>
				<li>당첨자 안내사항은 2016년 5월 19일에 공지됩니다.</li>
				<li>당첨 경품은 내부 사정에 의해 변경될 수 있습니다.</li>
			</ul>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/70631/m/txt_get.png" alt="앵그리버드를 얼른 가지새오!" /></p>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->