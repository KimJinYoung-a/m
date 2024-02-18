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
' Description :  언박싱 콘테스트
' History : 2019-01-02 최종원 
'####################################################
dim eCode, alertMsg, sqlstr, cnt, LoginUserid
dim eventEndDate, currentDate, eventStartDate, alarmRegCnt 
dim alarmBtnImg
dim drawEvt, isParticipation
dim numOfParticipantsPerDay
dim i
dim evtItemCode

IF application("Svr_Info") = "Dev" THEN
	eCode = "90204"		
Else
	eCode = "91528"	
End If

eventStartDate  = cdate("2019-01-02")		'이벤트 시작일
eventEndDate 	= cdate("2019-01-31")		'이벤트 종료일
currentDate 	= date()
LoginUserid		= getencLoginUserid()

if LoginUserid <> "" then
	'이벤트 응모
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE evt_code='"& eCode &"' and sub_opt2 <> '1' "
	rsget.Open sqlstr, dbget, 1
		cnt = rsget("cnt")
	rsget.close

	'알람 응모
	sqlstr = "SELECT COUNT(*) as cnt FROM [db_event].[dbo].[tbl_event_subscript]  WHERE userid= '"&LoginUserid&"' and evt_code="& eCode &" and sub_opt2 = '1' "
	rsget.Open sqlstr, dbget, 1
		alarmRegCnt = rsget("cnt")
	rsget.close	
end if
%> 
<%
'트래킹 기능 추가

'마케팅 웹 띠배너 배너 : &gaparam=main_mkt_2
'마케팅 모바일 배너 : &gaparam=today_mkt_2
'이벤트 : &gaparam=enjoyevent_all_17
'페이스북 : &rdsite=mktp

dim trackingType

dim gaparam
dim rdsite

gaparam = request("gaparam")
rdsite  = request("rdsite")

select case rdsite
    case "mktp"
        trackingType = "페이스북"
    case else
        trackingType = ""
end select 

if gaparam <> "" then
    Select Case gaparam
        Case "main_mkt_2"
            trackingType = "웹 띠배너"        
        Case "today_mkt_2"
            trackingType = "모바일 배너"                
        Case "enjoyevent_all_17"
            trackingType = "이벤트"        
        case else
            trackingType = ""    
    end Select
end if
%>
<%
    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink
'// SNS 공유용
    snpTitle    = Server.URLEncode("[텐텐 언박싱 콘테스트]")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid=91528")
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/91528/unboxing_kakao.jpg")
    appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid=91528"

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = " [텐텐 언박싱 콘테스트]"
    Dim kakaodescription : kakaodescription = "택배 뜯을 때의 설렘을 나누자!\n텐바이텐 언박싱 영상 찍고\n총 150만원의 기프트카드 받아가세요!"
    Dim kakaooldver : kakaooldver = "총 150만원의 기프트카드 받아가세요!"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/91528/unboxing_kakao.jpg"
    Dim kakaolink_url 
    If isapp = "1" Then '앱일경우
        kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid=91528"
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid=91528"
    End If	    
%>
<style type="text/css">
.mEvt91528 button {background: none;}
.mEvt91528 .topic {position:relative;}
.mEvt91528 .topic dt,
.mEvt91528 .topic dd {width:100%;}
.mEvt91528 .topic dt {position:absolute; left: 0; bottom: 35%; margin-left: -1.5%;}
.mEvt91528 .topic dt img{animation: ev2_05 cubic-bezier(0.175, 0.885, 0.32, 1.275) 5s 1.0s both 20;}
.mEvt91528 .topic dd {position:absolute; left: 0; bottom: 17.5%; margin-left: -1.5%;}
.mEvt91528 .topic p {position:absolute; top:45%;}
.mEvt91528 .unbox-guide {background-color:#ff7399;}
.mEvt91528 .unbox-guide ol li {float:left;}
.mEvt91528 .unbox-guide ol li:nth-child(1) {width:35.87%;}
.mEvt91528 .unbox-guide ol li:nth-child(2) {width:27.73%;}
.mEvt91528 .unbox-guide ol li:nth-child(3) {width:36.4%;}
.mEvt91528 .unbox-guide ol li a,
.mEvt91528 .unbox-guide ol li.on p{display:block;}
.mEvt91528 .unbox-guide ol li p,
.mEvt91528 .unbox-guide ol li.on a{display:none;}
.mEvt91528 .unbox-guide ul li {display:none;}
.mEvt91528 .unbox-guide ul li.on {display:block;}
.mEvt91528 .unbox-url {position:relative;}
.mEvt91528 .unbox-url div {overflow: hidden;position:absolute; bottom:24%; height: 4.5rem; width:90%; margin-left:5%;}
.mEvt91528 .unbox-url div input {height:100%; width:100%; padding-right: 10rem; vertical-align: middle; color:#252525; border:.4rem solid #fff; border-right:0; border-radius: .6rem; background-color:#dbb0ff;}
.mEvt91528 .unbox-url div input::-webkit-input-placeholder {color:#252525;}
.mEvt91528 .unbox-url div button {position:absolute; right:0; top: 0; bottom: 0; height:100%;}
.mEvt91528 .unbox-url div button img {width:auto; height: 100%;}
.mEvt91528 .unbox-step {background-color:#66d2fa}
.mEvt91528 .notice {padding:2.8rem 3.2rem; background-color:#3b4658;}
.mEvt91528 .notice p {color: #fff963; margin-bottom: 2.3rem; font-weight: bold; font-size: 1.5rem; text-align: center}
.mEvt91528 .notice li {color: #bfc9d9; line-height: 1.5rem; margin-bottom: 0.5rem; }
.mEvt91528 .notice li.bold {color: #fff; font-weight: bold;}
.mEvt91528 .notice li:before {content:'·';display:inline-block; width:0.7rem; margin-left:-0.7rem; font-weight: bold;}
.mEvt91528 .layer-popup {display:none; position:absolute; left:0; top:0; z-index:9997; width:100%; height:100%;} 
.mEvt91528 .layer-popup .layer {position:absolute; left:6%; width:88%; overflow:hidden; z-index:99999;} 
.mEvt91528 .layer-popup .layer > div {position: relative;}
.mEvt91528 .layer-popup .layer .btn-close{position: absolute; top:0; right: 0; width: 17%;} 
.mEvt91528 .layer-popup .mask {display:block; position:absolute; left:0; top:0; z-index:9998; width:100%; height:100%; background:rgba(0,0,0,.5);}
@keyframes ev2_05 {
0% {transform:translateY(4.27rem);}
13% {transform:translateY(0);}
30% {transform:translateY(0);}
34% {transform:translateY(1.2rem);}
38% {transform:translateY(0);}
42% {transform:translateY(1.2rem);}
46% {transform:translateY(0);}
100% {transform:translateY(0);}
}
</style>
<script type="text/javascript">
$(function(){	
    //시상,일정,대상심사 탭
    $('.unbox-guide ol li').click(function(e){
		t=$(this).index()
		var select = $('.unbox-guide ol li').eq(t)
		$(select).addClass('on').siblings().removeClass('on')
		$('.unbox-guide ul li').eq(t).addClass('on').siblings().removeClass('on')
		e.preventDefault()
	})    
	//텐텐배송상품이란 레이어팝업
	var scrollY2 = $('.unbox-guide').offset().top 
	$('.layer-popup#lyrSch2 .layer').css({'top':scrollY2-50})
	$('#layer2').click(function(){
		$('#lyrSch2').fadeIn();		
		<% if isapp then %>
			$('html,body').animate({scrollTop:scrollY2-50}, 800);			
		<% else %>
			$('html,body').animate({scrollTop:scrollY2}, 800);			
		<% end if %>				
	})
	//레이어팝업 닫기
	$('.layer-popup .btn-close').click(function(e){ 
		$('.layer-popup').fadeOut();
		e.preventDefault()
	})
	$('.layer-popup .mask').click(function(){ 
		$('.layer-popup').fadeOut(); 
	});	
}); 
</script>
<script type="text/javascript">
function doAction(mode) {
	var videoLink = document.getElementById('videoLink').value;
	if(mode=='entryEvt'){
		if(videoLink == ""){
			alert('입력한 내용이 없습니다.');
			document.getElementById('videoLink').focus()
			return false;
		}
		if(!isUrl(videoLink)){
			alert('올바른 URL주소를 넣어주세요.');
			return false;
		}        	
	}
	<% if (eventStartDate > currentDate or eventEndDate < currentDate) and GetLoginUserLevel <> "7" then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>				
	<% If LoginUserid <> "" Then %>
		var str = $.ajax({
			type: "post",
			url:"/event/etc/doeventsubscript/doEventSubscript91528.asp",
			data: {
				mode: mode,
                videoLink: videoLink, 
                trackingType: '<%=trackingType%>'
			},
			dataType: "text",
			async: false
		}).responseText;	

		if(!str){alert("시스템 오류입니다."); return false;}

		var reStr = str.split("|");

		if(reStr[0]=="OK"){
			if(reStr[1] == "entry"){	//응모
				var scrollY = $('.unbox-url').offset().top 
				$('.layer-popup#lyrSch .layer').css({'top':scrollY-50})			
				$('#lyrSch').fadeIn();
				<% if isapp then %>
					$('html,body').animate({scrollTop:scrollY-50}, 800);
				<% else %>
					$('html,body').animate({scrollTop:scrollY}, 800);				
				<% end if %>				
			}else if(reStr[1] == "alram"){	//알람신청
				alert("PUSH 알림이 신청되었습니다.\n(푸시 수신은 텐바이텐'앱'이 있는 경우에만 수신 가능)");
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
	<% else %>
		if ("<%=IsUserLoginOK%>"=="False") {
			jsEventLogin();
		}
	<% End If %>
}
function jsEventLogin(){
	<% if isApp="1" then %>
		calllogin();
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode)%>');
	<% end if %>
	return;
}
function chkLogin(){
	if ("<%=IsUserLoginOK%>"=="False") {
		jsEventLogin();
	}
}
function isUrl(url){    
    if((new RegExp(/(\w*\W*)?\w*(\.(\w)+)+(\W\d+)?(\/\w*(\W*\w)*)*/)).test(url)){
        return true;
    }
    return false;
}
</script>
<script>
	function snschk() {		
		<% if isapp then %>
		fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
		return false;
		<% else %>
		event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );	
		<% end if %>
	}
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		//카카오 SNS 공유
		Kakao.init('c967f6e67b0492478080bcf386390fdd');

		Kakao.Link.sendTalkLink({
			label: label,
			image: {
			src: imageurl,
			width: width,
			height: height
			},
			webButton: {
				text: '10x10 바로가기',
				url: linkurl
			}
		});
	}

	//카카오 SNS 공유 v2.0
	function event_sendkakao(label , description , imageurl , linkurl){	
		Kakao.Link.sendDefault({
			objectType: 'feed',
			content: {
				title: label,
				description : description,
				imageUrl: imageurl,
				link: {
				mobileWebUrl: linkurl
				}
			},
			buttons: [
				{
				title: '웹으로 보기',
				link: {
					mobileWebUrl: linkurl
				}
				}
			]
		});
	}
</script>
			<% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>            
			<div>응모 수: <a href="/event/etc/doeventsubscript/doEventSubscript91528.asp?mode=viewEntryList"><%=cnt%></a></div>			
			<% end if %>
            <!-- 91528 텐텐 언박싱 콘테스트 -->
            <div class="mEvt91528">
                <div class="topic">
                    <h2><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tit_top.png" alt="텐텐 언박싱 콘테스트" /></h2>
                    <dl>
                        <dt><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/img_top_ani.png" alt=""></dt>
                        <dd><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/img_top_box.png" alt=""></dd>
                    </dl>
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/txt_bubble.png" alt="gift card 총 150만원!"></p>
                </div>
                <div class="unbox-guide">
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/img_guide_01.png" alt="참여방법 텐바이텐 배송상품을 받은 후, 언박싱 영상 촬영"/></p>
                    <button id="layer2"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/btn_ship.png" alt="텐바이텐 배송상품이란?" /></button>
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/img_guide_02.png" alt="참가대상 ‘텐바이텐 배송상품’을 주문한 고객 누구나!"></p>
                    <div>
                        <ol>
                            <li class="on">
                                <a href=""><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_btn_01.png" alt="시상" /></a>
                                <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_btn_01_on.png" alt="시상" /></p>
                            </li>
                            <li>
                                <a href=""><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_btn_02.png" alt="일정" /></a>
                                <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_btn_02_on.png" alt="일정" /></p>
                            </li>
                            <li>
                                <a href=""><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_btn_03.png" alt="대상심사" /></a>
                                <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_btn_03_on.png" alt="대상심사" /></p>
                            </li>
                        </ol>
                        <ul>
                            <li class="on"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_img_01.png" alt="시상" /></li>
                            <li><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_img_02.png" alt="일정" /></li>
                            <li><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tab_img_03.png" alt="대상심사" /></li>
                        </ul>
                    </div>
                </div>
                <div class="unbox-url">
                    <h3><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/tit_url.png" alt="업로드한 영상 URL을 올려주세요! "></h3>
                    <div>
                        <input type="text" id="videoLink" placeholder="영상 URL " onclick="chkLogin();" />
                        <button id="layer1" onclick="doAction('entryEvt')"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/btn_go.png" alt="지원하기"></button>
                    </div>
                </div>
                <div class="unbox-step mApp">
                    <button onclick="doAction('regAlram')"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/btn_alarm.png" alt="수상자 발표 알림 받기"></button>
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/img_alarm_01.png" alt="푸시 수신 확인 방법 APP 화면 하단바에 있는 마이텐바이텐 클릭" /></p>
                    <p><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/img_alarm_02.png" alt="마이텐바이텐 오른쪽에 있는 설정 아이콘 클릭 광고성 알림 설정에 빨갛게 표시되면 수신 동의" /></p>
                </div>
                <div class="notice">
                    <p>유의사항</p>
                    <ul>
                        <li class="bold">개인 SNS는 유튜브, 인스타그램, 페이스북, 블로그입니다.</li>
                        <li>한 ID로 여러 영상 지원 가능합니다. (중복 영상은 불가)</li>
                        <li>모든 수상작의 저작권을 포함한 일체 권리는 ㈜텐바이텐에 귀속됩니다.</li>
                        <li>지원기간은 2019년 1월 7일 월요일부터 2019년 1월 31일 목요일 자정까지입니다.</li>
                        <li>수상자 발표는 2019년 2월 15일 금요일 예정이며, 수상자는 텐바이텐 공지사항에 게재 및 개별 연락드릴 예정입니다. </li>
                        <li>해시태그를 하지 않았을 경우 혹은 링크 주소가 존재하지 않는 경우 심사가 불가능합니다.</li>
                        <li>수상자에게는 세무 신고에 필요한 개인 정보를 요청할 수 있으며, 제세공과금은 텐바이텐 부담입니다.</li>
                        <li>비슷한 응모작이 있을 경우, 최초 응모작만 인정됩니다.</li>
                    </ul>
                </div>
                <div class="unbox-sns">
                    <button onclick="snschk();"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/btn_sns.png" alt="텐텐 언박싱 콘테스트 이벤트를 친구에게 공유해주세요!"></button>
                    <a href="https://www.youtube.com/channel/UCm_O8oKOLZSWPFH0V4BRSaw"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/btn_youtube.png" alt="텐바이텐 공식 유튜브 구독하러 가기"></a>
                </div>
                <div class="layer-popup" id="lyrSch"> 
                    <div class="layer"> 
                        <img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/layer_ok.png" alt="알림 신청하고  수상자 발표도 놓치지 마세요! 발표예정일 2019년 2월 15일  ">
                        <a href="" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/layer_close.png" alt="닫기"></a>
                        <button onclick="doAction('regAlram')"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/layer_btn.png" alt="발표 알림 받기"></button>
                    </div> 
                    <div class="mask"></div> 
                </div>
                <div class="layer-popup" id="lyrSch2"> 
                    <div class="layer"> 
                        <img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/layer_ship.png" alt="텐바이텐 배송상품이란? 텐바이텐 물류센터에서 직접 운영하는 배송 서비스입니다. 최적의 상품 상태를 유지하기 위해 체계적으로 꼼꼼하게 관리">
                        <a href="" class="btn-close"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91528/m/layer_close.png" alt="닫기"></a>
                    </div> 
                    <div class="mask"></div> 
                </div> 
            </div>
            <!-- 91528 텐텐 언박싱 콘테스트 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->