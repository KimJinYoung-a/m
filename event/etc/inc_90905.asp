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
' Description :  호로요이 이벤트 90905
' History : 2018-11-23 최종원 
'####################################################
dim eCode, refer, resultParam, alertMsg, sqlstr, cnt, alarmRegCnt, LoginUserid, chasu
dim chasu1BtnType, chasu2BtnType
dim chasu2StartDate, eventEndDate, currentDate, eventStartDate 
dim chasu1Participants, chasu2Participants
dim alarmBtnImg

eventStartDate = cdate("2018-12-10")	'이벤트 시작일
chasu2StartDate = cdate("2018-12-25")	'2차 이벤트 시작일
eventEndDate = cdate("2018-12-19")		'이벤트 종료일
currentDate = date()
LoginUserid		= getencLoginUserid()

'1차, 2차 이벤트 구분''
if currentDate < chasu2StartDate then
	chasu = 1
Else
	chasu = 2	
end if		

'테스트 날짜 
'eventStartDate = cdate("2018-12-10")
'eventEndDate = cdate("2018-12-05")
'chasu = 2

IF application("Svr_Info") = "Dev" THEN
	eCode = "90200"	
Else
	eCode = "90905"	
End If

sqlstr = " SELECT isnull(sum(case when sub_opt3 = '1' then 1 else 0 end),0) as chasu1 "
sqlstr = sqlstr & " , isnull(sum(case when sub_opt3 = '2' then 2 else 0 end),0) as chasu2 "  
sqlstr = sqlstr & " FROM [db_event].[dbo].[tbl_event_subscript]  WHERE evt_code="& eCode  

rsget.Open sqlstr, dbget, 1
	chasu1Participants = rsget("chasu1")
	chasu2Participants = rsget("chasu2")
rsget.close	

if LoginUserid <> "" then
	'이벤트 응모
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt3 = '"& chasu &"'"
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	'알람 응모
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt2 = '1' "
	rsget.Open sqlstr, dbget, 1
		alarmRegCnt = rsget("cnt")
	rsget.close	
end if

resultParam = request("resultParam")
refer = request.ServerVariables("HTTP_REFERER")			

'1차수 버튼 이미지
if chasu = 2 then	
	chasu1BtnType = "btn_sel_winner_check.png"
Else
	if cnt > 0 then
		chasu1BtnType = "btn_sel_winner_off.png"
	Else
		chasu1BtnType = "btn_sel_winner_on.png"
	end if	
end if

'2차수 버튼 이미지
if currentDate > eventEndDate then
	chasu2BtnType = "btn_sel_winner_check.png"
Else
	if cnt > 0 then
		chasu2BtnType = "btn_sel_winner_off.png"
	Else
		chasu2BtnType = "btn_sel_winner_on.png"
	end if	
end if

'알람버튼 이미지
if alarmRegCnt > 0 then
	alarmBtnImg = "btn_sel_1st_alarm_off.png" 
else
	alarmBtnImg = "btn_sel_1st_alarm_on.png" 
end if
%> 
<style type="text/css">
/* 공통 */
.sns-share {position:relative; background-color:#4753c9;}
.sns-share ul {display:flex; position:absolute; top:0; right:0; height:100%; justify-content:flex-end; align-items:center; margin-right:2.21rem;}
.sns-share li {width:4.05rem; margin-left:.77rem;}

.mEvt90905 .top-area {position: relative;}
.mEvt90905 dl dt,
.mEvt90905 dl dd {display: inline-block; position: absolute; left: 50%; margin-left: -5rem; top: 14.5%; width: 4.8rem; animation:slowDown 2.5s  ease both; opacity: 1 }
.mEvt90905 dl dd {top: 24.5%; margin-left: 1rem; animation-delay: .5s;}
.mEvt90905 .slide-area {position: relative; background-color: #c69380}
.mEvt90905 .slide-area > p {position: absolute; width: 7.3rem; top: 1rem; right: 1rem; z-index: 97;}
.mEvt90905 .slide-area .pagination {position: absolute; bottom: 20px; width: 100%; z-index: 999; text-align: center;}
.mEvt90905 .slide-area .swiper-pagination-switch {background-color: #c9bebe; margin: 0 .5rem;}
.mEvt90905 .slide-area .swiper-active-switch {background-color: #241f35;}
.mEvt90905 .sel-area > p {background-color: #c6937e;}
.mEvt90905 .sel-area > div { background-color: #6a3035;}
.mEvt90905 .sel-area > div ol {*zoom:1; }
.mEvt90905 .sel-area > div ol:after {clear:both;display:block;content:'';}
.mEvt90905 .sel-area > div ol li {width: 50%; float: left;}
.mEvt90905 .sel-area > div ol li a {display: block;}
.mEvt90905 .sel-area > div ol li a {display: block; width: 100%;;}
.mEvt90905 .sel-area > div ol li a p {display: none;}
.mEvt90905 .sel-area > div ol li a b {display: block;}
.mEvt90905 .sel-area > div ol li.on a {background-position: 0 0;}
.mEvt90905 .sel-area > div ol li.on a p {display: block;}
.mEvt90905 .sel-area > div ol li.on a b {display: none;}
.mEvt90905 .sel-area > div ul li {display: none;}
.mEvt90905 .sel-area > div ul li.on {display: block;}
.mEvt90905 .vod-wrap {margin-top: -68%; padding-bottom: 10%;}
.mEvt90905 .layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;}
.mEvt90905 .layer-popup .layer {overflow:hidden; position:absolute; left:6%; width:88%; z-index:99999; }
.mEvt90905 .layer-popup .layer > div {}
.mEvt90905 .layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.7);}
@keyframes slowDown{from{opacity: 0;} }
</style>
<script type="text/javascript">
$(function(){				
	<% if resultParam = "0" then %>
		<% if chasu = 1 then %>
			chasu1Popup();
		<% else %>
			chasu2Popup();
		<% end if %>		
	<% else %>		
		$('#lyrSch3').show();
	<% end if %>
	
	titSwiper = new Swiper("#slide",{
		loop:true,
		autoplay:1600,
		speed:1000,
		effect:'fade',
		pagination:".slide-area .pagination",
		paginationClickable:true,
	});
    
    // 1차응모 2차응모 선택
    $('.sel-area ol li a').click(function(e){
		var i = $(this).parent().index();
		<% if chasu = 1 then %>		
		if(i == 1){
			alert("2차 응모기간이 아닙니다.");
		}else{
			$('.sel-area ol li').eq(i).addClass('on').siblings().removeClass('on')
			$('.sel-area ul li').eq(i).addClass('on').siblings().removeClass('on')		
		}		
		<% else %>
			$('.sel-area ol li').eq(i).addClass('on').siblings().removeClass('on')
			$('.sel-area ul li').eq(i).addClass('on').siblings().removeClass('on')				
		<% end if %>
	})	
	$('.layer-popup .layer').css({'top':'9rem'})
	$('.layer-popup .mask').click(function(){
		$('.layer-popup').fadeOut();
	});		
});
</script>
<script type="text/javascript">
function jsEventLogin(){
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}
function pagedown(){
	window.$('html,body').animate({scrollTop:$("#selArea").offset().top}, 0);
}
function adultCert(){
	<% if isapp = 1 then %>	
	var cPath = "/event/etc/doeventsubscript/doEventSubscript90905.asp?vIsapp=1"
	<% else %>
	var cPath = "/event/etc/doeventsubscript/doEventSubscript90905.asp"
	<% end if %>

	<% if (eventStartDate > currentDate or eventEndDate < currentDate)then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>			

	<% If LoginUserid = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			jsEventLogin();
		}
	<% else %>
		<% if cnt > 0 then %>
			alert("이미 응모 하셨습니다.");
		<% else %>		
			<% if session("isAdult") = true then %>							
				doAction('entryEvt');
			<% else %>
				if(confirm('성인인증이 필요한 콘텐츠입니다. 성인인증을 하시겠습니까?')){
						var url = '/login/login_adult.asp?backpath='+ cPath;
						location.href = url;
				}						
			<% end if %>
		<% end if %>			
	<% End If %>
}
function chasu1Popup(){	
    var scrollY = $('.sel-area ol').offset().top
	$('.layer-popup .layer').css({'top':scrollY})		
	$('#lyrSch').fadeIn();	
	window.parent.$('html,body').animate({scrollTop:scrollY}, 800);;	
}
function chasu2Popup(){ 
    var scrollY = $('.sel-area ol').offset().top
	$('.layer-popup .layer').css({'top':scrollY})	   
	$('#lyrSch2').fadeIn();
	window.parent.$('html,body').animate({scrollTop:scrollY}, 800);	
}
function closePopup(e){
	$('.layer-popup').fadeOut();     
}
function closePopup2(){
	$('.layer-popup').fadeOut();     
}
function doAction(mode) {
	<% if (eventStartDate > currentDate or eventEndDate < currentDate) and GetLoginUserLevel <> "7" then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>			
	<% If LoginUserid = "" Then %>
		if ("<%=IsUserLoginOK%>"=="False") {
			jsEventLogin();
		}
	<% End If %>
	<% If LoginUserid <> "" Then %>
		var str = $.ajax({
			type: "GET",
			url:"/event/etc/doeventsubscript/doEventSubscript90905.asp",
			data: "mode="+mode,
			dataType: "text",
			async: false
		}).responseText;	
		if(!str){alert("시스템 오류입니다."); return false;}
		var reStr = str.split("|");
		if(reStr[0]=="OK"){
			if(reStr[1] == "entry"){	//응모
				<% if chasu = 1 then %>
					$("#layerPopupBtn").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_winner_off.png")
					chasu1Popup();
				<% else %>
					$("#layerPopupBtn2").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_winner_off.png")				
					chasu2Popup();
				<% end if %>				
				return false;
			}else if(reStr[1] == "alram"){	//알람신청
				$("#chasu2AlertbtnImg").attr("src", "http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_1st_alarm_off.png")								
				alert('2차 응모 알림이 신청되었습니다.');				
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}
		}else{
			var errorMsg = reStr[1].replace(">?n", "\n");
			alert(errorMsg);
//			document.location.reload();
			return false;
		}
	<% End If %>
}
function linkToNotice(){
	<% if isApp = 1 then %>
		fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appcom/wish/web2014/common/news_view.asp?type=E&idx=18129');
	<% else %>
		location.href="/common/news_view.asp?type=E&idx=18129";
	<% end if %>
	
}
</script>
			<% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>
			<div>1차 응모자 수: <%=chasu1Participants%></div>
			<div>2차 응모자 수: <%=chasu2Participants%></div>
			<% end if %>
            <!-- 90905 호로요이 혼술을 부탁해  -->
            <div class="mEvt90905 ">
                <div class="top-area">
                    <img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/bg_top.png" alt="텐바이텐x호로요이">
                    <dl>
                        <dt><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/txt_tit_01.png" alt="혼쉼을"></dt>
                        <dd><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/txt_tit_02.png" alt="부탁해"></dd>
                    </dl>
                </div>
                <div class="slide-area">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/ico_winner.png" alt="총 당첨자 500명"></p>
                    <div id="slide" class="swiper-container">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_01.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_02.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_03.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_04.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_05.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_06.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_07.png" alt="슬라이드 이미지" /></div>
                                <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_slide_08.png" alt="슬라이드 이미지" /></div>
                            </div>
                        </div>
                    <div class="pagination"></div>
                </div>
                <div class="sel-area">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/txt_sel.png" alt="호로요이 메리해피 혼쉼 패키지"></p>
                    <div>
                        <ol>
                            <li class="sel-1st <%=chkIIF(chasu=1, " on", "")%>">
                                <a href="javascript:void(0)">
                                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_1st_on.png" alt="1차 응모"></p>
                                    <b><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_1st_off.png" alt="1차 응모 off"></b>
                                </a>
                            </li>
                            <li class="sel-2nd <%=chkIIF(chasu=2, " on", "")%>">
                                <a href="javascript:void(0)">
                                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_2nd_on.png" alt="2차 응모"></p>
                                    <b><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_2nd_off.png" alt="2차 응모 off"></b>
                                </a>
                            </li>
                        </ol>
                        <ul>
                            <li class="<%=chkIIF(chasu=1, "on", "")%>">
                                <button id="layerPopupBtn" onclick="<%=chkIIF(chasu=2, "linkToNotice()", "adultCert()")%>"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/<%=chasu1BtnType%>?v=1.01" alt="응모하기"></button>                                
								<% if chasu = 1 then %>
                                <button onclick="doAction('regAlram');"><img id="chasu2AlertbtnImg" src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/<%=alarmBtnImg%>" alt="2차 응모 알림 신청하기"></button>                                
								<% end if %>
                                <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_1st_txt.png" alt="1차 당첨자는 2018년 12월 25일 텐바이텐 공지사항에 발표 예정"></p>
                            </li>
                            <li class="<%=chkIIF(chasu=2, "on", "")%>">
                                <button id="layerPopupBtn2" onclick="adultCert()"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/<%=chasu2BtnType%>?v=1.01" alt="응모하기"></button>                                
                                <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_sel_2nd_txt.png" alt="1차 당첨자는 2018년 12월 25일 텐바이텐 공지사항에 발표 예정"></p>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="vod-area">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/txt_vod.png" alt="오늘 하루는 나를 위한 순간을 만들어보세요 호로요이 메리해피 혼쉼 패키지와 함께 오늘은 쉽니다"></p>
                    <div class="vod-wrap shape-rtgl">
                        <div class="vod">
                            <iframe src="https://www.youtube.com/embed/AJnwxGE55bo?list=PLnzLQZtG-AkhO-XRdiuxTwIwsOLXHARU6" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen></iframe>
                        </div>
                    </div>
                </div>
                <div class="notice">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/img_noti.png" alt="이벤트 유의사항" />
                </div>
                <!-- 1차 응모완료 레이어팝업-->
                <div class="layer-popup" id="lyrSch"> 
                    <div class="layer"> 
                        <div>
                            <a href="javascript:void(0)" onclick="closePopup()" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_layer_close.png" alt="닫기"></a>
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/txt_layer_1st.png" alt="1차 응모완료!" /></p> 
                            <button onclick="doAction('regAlram');"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_layer_1st.png" alt="2차 응모 알림 신청하기" /></button>
                            <a href="/event/eventmain.asp?eventid=90907" onclick="jsEventlinkURL(90907);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/bnr_layer_evt.png" alt="1일 1술 프로혼술러"></a>
                        </div>
                    </div> 
                    <div class="mask"></div> 
                </div>
                    <!-- 2차 응모완료 레이어팝업 -->
                    <div class="layer-popup" id="lyrSch2"> 
                    <div class="layer"> 
                        <div>
                            <a href="javascript:void(0)" onclick="closePopup()" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_layer_close.png" alt="닫기"></a>
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/txt_layer_2nd.png" alt="2차 응모완료!" /></p> 
                            <a href="/event/eventmain.asp?eventid=90907" onclick="jsEventlinkURL(90907);return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/bnr_layer_evt.png" alt="1일 1술 프로혼술러"></a>
                        </div>
                    </div> 
                    <div class="mask"></div> 
                </div> 
                <!-- 181218 종료 -->
                <div class="layer-popup" id="lyrSch3"> 
                    <div class="layer"> 
                        <div>
                            <a href="javascript:void(0)" onclick="closePopup()" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_layer_close.png" alt="닫기"></a>
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/tit_layer_closing.png?v=1.01" alt="이벤트 안내"/></p>
                            <p><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/txt_layer_closing.png?v=1.03" alt=" 안녕하세요. 텐바이텐입니다. 한국건강증진개발원에서 해당 이벤트에 대한 시정요청으로 2018년 12월 19일 이벤" /></p> 
                            <button onclick="linkToNotice();"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/90905/m/btn_layer_closing.png?v=1.01" alt="텐바이텐 공지사항" /></button>
                        </div>
                    </div> 
                    <div class="mask"></div> 
                </div> 				
            </div>
            <!-- // 90905 호로요이 혼술을 부탁해  -->
<!-- #include virtual="/lib/db/dbclose.asp" -->