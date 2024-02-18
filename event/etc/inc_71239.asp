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
' Description : 지구를 멈춰라 MA
' History : 2016.06.16 유태욱
'###########################################################
Dim eCode, cnt, sqlStr, i, totalsum, irdsite20, vUserID, currenttime, contemp, worldname

currenttime = date()
'															currenttime = "2016-06-20"

If application("Svr_Info") = "Dev" Then
	eCode 		= "66153"
Else
	eCode 		= "71239"
End If

irdsite20	= requestCheckVar(request("rdsite"), 32)
vUserID		= GetEncLoginUserID

'// 실시간 당첨자 id
sqlstr = "SELECT top 10 userid, sub_opt2, regdate"
sqlstr = sqlstr & " From [db_event].[dbo].[tbl_event_subscript]"
sqlstr = sqlstr & " where evt_code="& eCode &" and datediff(day,regdate,getdate()) = 0 And sub_opt2<>0 "
sqlstr = sqlstr & " order by regdate desc"
'response.write sqlstr & "<Br>"
rsget.Open sqlstr,dbget
IF not rsget.EOF THEN
	contemp = rsget.getrows()
END IF
rsget.close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle	= Server.URLEncode("[텐바이텐] 지구를 멈춰라!")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre		= Server.URLEncode("10x10 이벤트")
'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 지구를 멈춰라!\n\n당신의 여름휴가를 도와드릴\n시원한 선물을 갖고 텐바이텐이\n돌아왔습니다.\n\n뜨겁게 돌아가는 지구를\n멈춰보세요!\n시원한 선물이 당신을\n찾아갑니다!\n\n지금 도전하세요!\n오직 텐바이텐에서!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2016/71239/m/71239kakao.jpg"
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
img {vertical-align:top;}
.mEvt71239 {position:relative;}
.stopEarth {position:relative;}
.stopEarth .btnClick {display:block; position:absolute; left:50%; top:30%; width:40.625%; margin-left:-20%; background:transparent;}
.resultLayer {position:absolute; left:0; top:0; z-index:100; width:100%; height:100%; padding:15% 6% 0; background:rgba(0,0,0,.6);}
.resultLayer .layerCont {position:relative;}
.resultLayer .layerCont .btnClose {display:block; position:absolute; right:0; top:0; width:14%; background:transparent;}
.resultLayer .layerCont .btnGo {display:block; position:absolute; left:0; bottom:0; width:100%; height:15%; background:transparent; text-indent:-999em;}
.resultLayer .worldTravel .item {display:block; position:absolute; left:0; top:23.375%; z-index:30; width:100%;}
.resultLayer .worldTravel .code {position:absolute; left:0; bottom:15.5%; width:100%; z-index:110; font-size:1.1rem; text-align:center; color:#999;}
.vacationGift {overflow:hidden; position:relative;}
.vacationGift .btnMore {display:block; position:absolute; right:0; bottom:0; width:25%; background:transparent;}
.winList {position:relative; padding:1.2rem 3.5rem 1.2rem 9rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/71239/m/bg_win.png) repeat-y 0 0; background-size:100% auto;}
.winList h3 {position:absolute; left:1.6rem; top:1.2rem; width:6rem;}
.winList .winSwipe {height:3.8rem;}
.winList .winSwipe .swiper-container {height:3.8rem;}
.winList .winSwipe .swiper-container-vertical > .swiper-wrapper {-webkit-box-orient:vertical; -moz-box-orient:vertical; -ms-flex-direction:column; -webkit-flex-direction:column; flex-direction:column;}
.winList .winSwipe .swiper-slide {display:table; width:100%; overflow:hidden; height:3.8rem; font-size:1.1rem; letter-spacing:-0.025em; line-height:1.2; color:#fff;}
.winList .winSwipe .swiper-slide > div {display:table-cell; width:100%; padding-top:0.3rem; font-weight:600; vertical-align:middle;}
.winList .winSwipe .swiper-slide em {display:inline-block; line-height:1; color:#fcff00; border-bottom:0.1rem solid #fcff00;}
.winList .winSwipe .swiper-slide span {font-size:1rem; font-weight:normal;}
.winList .winSwipe button {display:inline-block; position:absolute; right:0; width:2.6rem;}
.winList .winSwipe .prev {top:0;}
.winList .winSwipe .next {bottom:0;}
.shareSns {position:relative;}
.shareSns ul {position:absolute; right:8%; top:22%; width:36%; height:57%;}
.shareSns li {float:left; width:50%; height:100%;}
.shareSns li a {display:block; width:100%; height:100%; background:transparent; text-indent:-999em;}
.evtNoti {padding:2.4rem 4.68%; margin-bottom:-2.4rem;}
.evtNoti h3 {padding-bottom:1.5rem; font-size:1.3rem;}
.evtNoti h3 strong {display:inline-block; height:1.5rem; color:#38b8c3; border-bottom:0.15rem solid #38b8c3;}
.evtNoti li {position:relative; color:#666; font-size:1rem; line-height:1.3; padding:0 0 0.2rem 0.7rem;}
.evtNoti li:after {content:''; position:absolute; left:0; top:0.4rem; z-index:10; width:0.2rem; height:0.2rem; background:#38b8c3; border-radius:50%;}
.giftLayer {position:absolute; left:0; top:0; z-index:100; width:100%; height:100%; padding:15% 5% 0; background:rgba(0,0,0,.6);}
.giftLayer .layerCont {position:relative;}
.giftLayer .layerCont .giftClose {display:block; position:absolute; right:0; top:0; width:14%; background:transparent;}
.giftLayer .scrollArea {position:absolute; left:0; top:18%; width:100%; height:82%;}
.giftLayer .swiper-container {height:100%;}
.giftLayer .swiper-slide {width:100%;}
.zoom {animation-name:zoom; animation-duration:1.5s; animation-iteration-count:20; animation-fill-mode:both;}
@keyframes zoom {
	from, to{transform: scale(1); animation-timing-function:ease-out;}
	50% {transform: scale(1.2); animation-timing-function:ease-in;}
}
.bounce {animation:bounce 0.7s ease-in-out 30 alternate;}
@keyframes bounce {
	from {transform:translate(0,-4px);} 
	to{transform:translate(0,0);}
}
</style>
<script type="text/javascript">
var scroll01;
$(function(){
	window.$('html,body').animate({scrollTop:$(".mEvt71239").offset().top}, 0);
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
		<% If currenttime >= "2016-06-20" And currenttime < "2016-06-25" Then %>
			$.ajax({
				type:"GET",
				url:"/event/etc/doeventsubscript/doEventSubscript71239.asp",
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
//alert(res[1]);
//return;
								if (res[0]=="OK"){
									$("#resultLayer").empty().html(res[1]);
									$('.resultLayer').fadeIn();
									window.parent.$('html,body').animate({scrollTop:$(".resultLayer").offset().top}, 300);
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
		url:"/event/etc/doeventsubscript/doEventSubscript71239.asp",
		data: "mode=snschk&snsnum="+snsnum,
		dataType: "text",
		async: false
	}).responseText;
		reStr = str.split("|");
		if(reStr[1] == "tw") {
			popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
		}else if(reStr[1]=="fb"){
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
		}else if(reStr[1]=="ka"){
			<% If isApp = "1" Then %>
				parent_kakaolink('[텐바이텐] 지구를 멈춰라!\n\n당신의 여름휴가를 도와드릴\n시원한 선물을 갖고 텐바이텐이\n돌아왔습니다.\n\n뜨겁게 돌아가는 지구를\n멈춰보세요!\n시원한 선물이 당신을\n찾아갑니다!\n\n지금 도전하세요!\n오직 텐바이텐에서!', 'http://webimage.10x10.co.kr/eventIMG/2016/71239/m/71239kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=71239' );
			<% Else %>
				parent_kakaolink('[텐바이텐] 지구를 멈춰라!\n\n당신의 여름휴가를 도와드릴\n시원한 선물을 갖고 텐바이텐이\n돌아왔습니다.\n\n뜨겁게 돌아가는 지구를\n멈춰보세요!\n시원한 선물이 당신을\n찾아갑니다!\n\n지금 도전하세요!\n오직 텐바이텐에서!' , 'http://webimage.10x10.co.kr/eventIMG/2016/71239/m/71239kakao.jpg' , '200' , '200' , 'http://m.10x10.co.kr/event/eventmain.asp?eventid=71239' );
			<% End If %>
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

//쿠폰Process
function get_coupon(){
<% If IsUserLoginOK Then %>
	<% if not( currenttime>="2016-06-20" and currenttime<"2016-06-25" ) then %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% else %>
		var rstStr = $.ajax({
			type: "POST",
			url: "/event/etc/doeventsubscript/doEventSubscript71239.asp",
			data: "mode=coupon",
			dataType: "text",
			async: false
		}).responseText;
		if (rstStr == "SUCCESS"){
			alert('쿠폰이 발급되었습니다.');
			location.reload();
			return false;
		}else if (rstStr == "MAXCOUPON"){
			alert('오늘의 응모는 모두 완료! 내일 또 도전해 주세요!');
			return false;
		}else if (rstStr == "NOT1"){
			alert('응모후 다운로드가 가능합니다.');
			return false;
		}else if (rstStr == "DATENOT"){
			alert('이벤트 응모 기간이 아닙니다.');
			return false;
		}else if (rstStr == "USERNOT"){
			alert('로그인을 해주세요.');
			return false;
		}else{
			alert('관리자에게 문의');
			return false;
		}
	<% end if %>
<% Else %>
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
		return false;
	<% end if %>
<% end if %>
}


function jsmyten(){
	<% if isApp=1 then %>
//		fnAPPpopupMy10x10();
		fnAPPpopupBrowserURL('개인정보수정','<%= wwwurl %>/apps/appCom/wish/web2014/my10x10/userinfo/membermodify.asp');
		return false;
	<% else %>
		top.location.href = "/my10x10/userinfo/confirmuser.asp";
		return false;
	<% end if %>
}



$(function(){
	// 실시간 당첨 소식
	mySwiper = new Swiper(".winSwipe .swiper-container",{
		loop:false,
		autoplay:1900,
		speed:900,
		direction: 'vertical',
		pagination:false,
		prevButton:'.winSwipe .prev',
		nextButton:'.winSwipe .next'
	});
	
	// 선물 레이어
	$('.btnMore').click(function(){
		$('.giftLayer').fadeIn();
		window.parent.$('html,body').animate({scrollTop:$(".giftLayer").offset().top}, 300);
		scroll01.update();
	});
	$('.giftClose').click(function(){
		$('.giftLayer').fadeOut();
	});
	// 당첨선물 리스트
	scroll01 = new Swiper(".giftLayer .scrollArea .swiper-container", {
		scrollbar:'.giftLayer .scrollArea .swiper-scrollbar',
		direction:'vertical',
		slidesPerView:'auto',
		mousewheelControl: true,
		freeMode:true
	});
});

function fnClosemask()
{
	$('.resultLayer').fadeOut();
	document.location.reload();
}
</script>
	<!-- 지구를 멈춰라 -->
	<div class="mEvt71239">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/tit_stop_earth.png" alt="지구를 멈춰라" /></h2>

		<!-- 지구 클릭 -->
		<div class="stopEarth">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_earth.gif" alt="" /></div>
			<button type="button" onclick="checkform();return false;" class="btnClick zoom"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_click.png" alt="CLICK" /></button>
		</div>

		<!-- 응모 결과 -->
		<div id="resultLayer" class="resultLayer" style="display:none;">

		</div>

		<!-- 선물 리스트 -->
		<div class="vacationGift">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_gift_v1.jpg" alt="선물 리스트" /></div>
			<button type="button" class="btnMore bounce"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_more.png" alt="선물 더보기" /></button>
		</div>

		<!-- 선물 레이어 -->
		<div id="giftLayer" class="giftLayer" style="display:none;">
			<div class="layerCont">
				<button type="button" class="giftClose"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_close.png" alt="닫기" /></button>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/tit_gift_list.png" alt="사은품 리스트" /></p>
				<div class="scrollArea">
					<div class="swiper-container">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/img_gift_list.png" alt="사은품 리스트" /></div>
							</div>
						</div>
						<div class="swiper-scrollbar"></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 당첨자 내역 -->
		<div class="winList">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/tit_win.png" alt="당첨자 소식" /></h3>
			<div class="winSwipe">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<% if isarray(contemp) then %>
							<% for i = 0 to ubound(contemp,2) %>
							<%
								Select Case contemp(1,i)
									Case "1","2","3","4","41","42","44"
										worldname = "한국"
									Case "5","6","7","8"
										worldname = "파리"
									Case "9"
										worldname = "덴마크"
									Case "10","11","12"
										worldname = "미국"
									Case "13","20","27","30"
										worldname = "오사카"
									Case "14","15","22","29"
										worldname = "다낭"
									Case "16","23","35","38"
										worldname = "세부"
									Case "17","24","36","39"
										worldname = "괌"
									Case "18","25","31","33"
										worldname = "홍콩"
									Case "19","26","37","40"
										worldname = "호놀룰루"
									Case "21","28","32","34"
										worldname = "타이베이"
									Case "43"
										worldname = "여행상품권"
									Case Else
										worldname = ""
								End Select
							%>
								<div class="swiper-slide">
									<div>
										<p>
											<em><%= printUserId(Left(contemp(0,i),5),2,"*")%>님</em>
											이 <%= worldname %>에 당첨 되셨습니다.
										</p>
										<span><%= Left(contemp(2,i),22) %></span>
									</div>
								</div>
							<% next %>
						<% else %>
							<div class="swiper-slide">
								<div>
									<p>당첨자가 없습니다.</p>
								</div>
							</div>
						<% end if %>
					</div>
				</div>
				<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_prev.png" alt="이전" /></button>
				<button type="button" class="next"><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/btn_next.png" alt="다음" /></button>
			</div>
		</div>

		<!-- 공유하기 -->
		<div class="shareSns">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/71239/m/txt_share.png" alt="친구들에게 공유하기" /></p>
			<ul>
				<li><a href="" onclick="snschk('fb'); return false;">페이스북으로 공유</a></li>
				<li><a href="" onclick="snschk('ka'); return false;">카카오톡으로 공유</a></li>
			</ul>
		</div>

		<div class="evtNoti">
			<h3><strong>이벤트 유의사항</strong></h3>
			<ul>
				<li>본 이벤트는 텐바이텐에서만 참여 가능합니다.</li>
				<li>5만원 이상의 상품을 받으신 분께는 세무신고를 위해 개인정보를 요청할 수 있습니다. 제세공과금은 텐바이텐 부담입니다.</li>
				<li>당첨된 고객께는 익일 당첨안내 문자가 전송될 예정입니다.</li>
				<li>당첨된 상품은 당첨안내 확인 후에 발송됩니다!(차주 월요일부터 순차적으로 배송)</li>
				<li>이벤트 내 모든 상품의 컬러는 랜덤으로 발송되며, 선택이 불가능합니다.</li>
			</ul>
		</div>
	</div>
	<!--// 지구를 멈춰라 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->