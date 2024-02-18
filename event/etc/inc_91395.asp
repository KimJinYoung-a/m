<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/drawevent/DrawEventCls.asp" -->
<%
'####################################################
' Description :  호로요이 이벤트 2차 91395
' History : 2018-11-23 최종원 
'####################################################
dim eCode, alertMsg, sqlstr, cnt, LoginUserid
dim eventEndDate, currentDate, eventStartDate 
dim alarmBtnImg
dim drawEvt, isParticipation
dim numOfParticipantsPerDay
dim i
dim evtItemCode

IF application("Svr_Info") = "Dev" THEN
	eCode = "90201"	
	evtItemCode = "1198132"
Else
	eCode = "91395"
	evtItemCode = "2191082"
End If

eventStartDate  = cdate("2018-12-21")		'이벤트 시작일
eventEndDate 	= cdate("2019-01-16")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

'테스트 날짜 
'eventStartDate = cdate("2018-12-10")
'eventEndDate = cdate("2018-12-05")

set drawEvt = new DrawEventCls
drawEvt.evtCode = eCode
drawEvt.userid = LoginUserid

'isParticipation = drawEvt.isParticipationDayBase()
numOfParticipantsPerDay = drawEvt.getParticipantsPerDay()
%> 
<style type="text/css">
/* 공통 */
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%; justify-content:flex-end; align-items:center; margin-right:2.21rem;}
.sns-share li {width:4.05rem; margin-left:.77rem;}

.mEvt91395 .top-area {position: relative;}
.mEvt91395 dl dt,
.mEvt91395 dl dd {display: inline-block; position: absolute; left: 50%; margin-left: -5rem; top: 14.5%; width: 4.8rem; animation:slowDown 2.5s  ease both; opacity: 1 }
.mEvt91395 dl dd {top: 24.5%; margin-left: 1rem; animation-delay: .5s;}
.mEvt91395 .slide-area {position: relative; background-color: #c69380}
.mEvt91395 .slide-area > p {position: absolute; width: 7.3rem; top: 1rem; right: 1rem; z-index: 97;}
.mEvt91395 .slide-area .pagination {position: absolute; bottom: 20px; width: 100%; z-index: 999; text-align: center;}
.mEvt91395 .slide-area .swiper-pagination-switch {background-color: #c9bebe; margin: 0 .5rem;}
.mEvt91395 .slide-area .swiper-active-switch {background-color: #241f35;}
.mEvt91395 .vod-wrap {margin-top: -68%; padding-bottom: 10%;}
.mEvt91395 .layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;}
.mEvt91395 .layer-popup .layer {overflow:hidden; position:absolute; left:6%; width:88%; z-index:99999; }
.mEvt91395 .layer-popup .layer > div {}
.mEvt91395 .layer-popup .layer > div a.btn-close {position: absolute; right: 0; top: 0; width: 13.33%; height: auto;}
.mEvt91395 .layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.7);}
@keyframes slowDown{from{opacity: 0;} }
</style>
<script type="text/javascript">
$(function(){
	fnAmplitudeEventMultiPropertiesAction('view_event_91395','','');
	titSwiper = new Swiper("#slide",{
		loop:true,
		autoplay:1600,
		speed:1000,
		effect:'fade',
		pagination:".slide-area .pagination",
		paginationClickable:true,
	});
});
$(function(){
	var scrollY = $('.sel-area>div').offset().top							
	<% if session("evt91395") <> "" and session("evt91395") <> "0" and isParticipation then %>	
	$('#lyrSch').fadeIn();
	window.parent.$('html,body').animate({scrollTop:scrollY}, 800);
	<% end if %>	
    $('.layer-popup .layer').css({'top':scrollY})

	$('.layer-popup .btn-close').click(function(e){
		$('.layer-popup').fadeOut();
        e.preventDefault()
	});
	$('.layer-popup .mask').click(function(){
		$('.layer-popup').fadeOut();
	});
});
</script>
<script>
function adultCert(){
	<% if isapp = 1 then %>	
	var cPath = "/event/etc/doeventsubscript/doEventSubscript91395.asp?vIsapp=1"
	<% else %>
	var cPath = "/event/etc/doeventsubscript/doEventSubscript91395.asp"
	<% end if %>

	<% if (eventStartDate > currentDate or eventEndDate < currentDate) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>			

	<% If LoginUserid = "" Then %>
		if ("<%= IsUserLoginOK %>"=="False") {
			jsEventLogin();
		}
	<% else %>
		<% if isParticipation then %>
			alert("이미 응모 하셨습니다.");
		<% else %>
			<% if session("isAdult") = true then %>
				var url = '/login/login_adult.asp?backpath='+ cPath;
				location.href = url;				
			<% else %>
				if(confirm('성인인증이 필요한 콘텐츠입니다. 성인인증을 하시겠습니까?')){
					var url = '/login/login_adult.asp?backpath='+ cPath;
					location.href = url;
				}			
			<% end if %>
		<% end if %>			
	<% End If %> 
}
function goDirOrdItem(){
<% If IsUserLoginOK() Then %>	
	<% If Now() > #12/19/2018 23:59:59# And Now() < #01/16/2019 23:59:59# Then %>	
		document.directOrd.submit();
	<% else %>
		alert("이벤트 응모 기간이 아닙니다.");
		return;
	<% end if %>
<% Else %>
	if(confirm("로그인을 하셔야 응모할 수 있습니다.")){
		top.location.href="/login/loginpage.asp?vType=G";
		return false;
	}
<% End IF %>
}
function jsEventLogin(){
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}
</script>
			<% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>						
				<% 
					if isArray(numOfParticipantsPerDay) then 
						for i=0 to uBound(numOfParticipantsPerDay,2) 
						response.write "<div>"& numOfParticipantsPerDay(0,i) &" : " & numOfParticipantsPerDay(2,i) &" / "& numOfParticipantsPerDay(1,i) &"</div>"																		
						next 
					end if 
				%>							
			<% end if %>
            <!-- 91395 호로요이 2차 혼쉼을 부탁해  -->
            <div class="mEvt91395 ">
                <div class="top-area">
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/bg_top.png" alt="텐바이텐x호로요이">
                    <dl>
                        <dt><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/txt_tit_01.png" alt="혼쉼을"></dt>
                        <dd><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/txt_tit_02.png" alt="부탁해"></dd>
                    </dl>
                </div>
                <div class="slide-area">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/ico_winner.png" alt="총 당첨자 250명"></p>
                    <div id="slide" class="swiper-container">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_01.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_02.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_03.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_04.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_05.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_06.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_07.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_slide_08.png" alt="슬라이드 이미지" /></div>
                            </div>
                        </div>
                    <div class="pagination"></div>
                </div>
                <div class="sel-area">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/txt_sel.png" alt="호로요이 메리해피 혼쉼 패키지"></p>
                    <div>
                        <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/txt_apply.png" alt="이벤트 참여방법"></p>
						<% if isParticipation then %>												
						<button id="layerPopupBtn" onclick="alert('이미 응모하셨습니다. 내일 또 응모해주세요!');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/btn_apply_end.png" alt="응모완료"></button>
						<% else %>
						<button id="layerPopupBtn" onclick="adultCert()"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/btn_apply.png" alt="응모하기"></button>
						<% end if %>
                    </div>
                </div>
                <div class="vod-area">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/txt_vod.png?v=1.01" alt="오늘 하루는 나를 위한 순간을 만들어보세요 호로요이 메리해피 혼쉼 패키지와 함께 오늘은 쉽니다"></p>
                    <div class="vod-wrap shape-rtgl">
                        <div class="vod">
                            <iframe src="https://www.youtube.com/embed/AJnwxGE55bo?list=PLnzLQZtG-AkhO-XRdiuxTwIwsOLXHARU6" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen></iframe>
                        </div>
                    </div>
                </div>
                <div class="notice">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/img_noti.png" alt="이벤트 유의사항" />
                </div>
                <!-- 레이어 팝업 -->
                <div class="layer-popup" id="lyrSch"> 
                    <!-- 2차 이벤트 당첨자 팝업 -->
				<% if session("evt91395") = "1" and isParticipation then %>						
                    <div class="layer"> 
                        <div>
                            <a href="" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/layer_btn_close.png" alt="닫기"></a>
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/layer_txt_win.png" alt="축하합니다 이벤트에 당첨되셨습니다! 지금 바로 1,000원으로 호로요이 메리해피 혼쉼 패키지를 만나보세요!" /></p> 
                            <button onclick="goDirOrdItem()"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/layer_btn_buy.png" alt="바로 구매하기" /></button>
                            <a href="/event/eventmain.asp?eventid=90907" onclick="jsEventlinkURL(90907);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/bnr_layer_evt.png" alt="1일 1술 프로혼술러"></a>
                        </div>
                    </div>
					<% if isapp then %>
						<form method="post" name="directOrd" action="/apps/appcom/wish/web2014/inipay/shoppingbag_process.asp">
							<input type="hidden" name="itemid" id="itemid" value="<%=evtItemCode%>">
							<input type="hidden" name="itemoption" value="0000">
							<input type="hidden" name="itemea" readonly value="1">
							<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
							<input type="hidden" name="isPresentItem" value="" />
							<input type="hidden" name="mode" value="DO3">
						</form>
					<% else %>
						<form method="post" name="directOrd" action="/inipay/shoppingbag_process.asp">
							<input type="hidden" name="itemid" id="itemid" value="<%=evtItemCode%>">
							<input type="hidden" name="itemoption" value="0000">
							<input type="hidden" name="itemea" readonly value="1">
							<input type="hidden" name="sitename" value="<%= session("rd_sitename") %>" />
							<input type="hidden" name="isPresentItem" value="" />
							<input type="hidden" name="mode" value="DO1">
						</form>
					<% end if %>								
				<% elseif session("evt91395") = "2" and isParticipation then %>					                    
                    <div class="layer"> 
                        <div>
                            <a href="" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/layer_btn_close.png" alt="닫기"></a>
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/layer_txt_fail.png" alt="아쉽게도 당첨되지 않았습니다" /></p> 
                            <a href="/event/eventmain.asp?eventid=90907" onclick="jsEventlinkURL(90907);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/91395/m/bnr_layer_evt.png" alt="1일 1술 프로혼술러"></a>
                        </div>
                    </div>
				<% end if %>
                    <div class="mask"></div> 
                </div>
            </div>
<%
	session("evt91395") = "0"
%>									
            <!-- // 91395 호로요이 2차 혼쉼을 부탁해  -->
<!-- #include virtual="/lib/db/dbclose.asp" -->