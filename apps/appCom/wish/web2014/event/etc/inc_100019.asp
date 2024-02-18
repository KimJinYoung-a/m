<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2020 마일리지
' History : 2020-01-13 원승현
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, moECode
IF application("Svr_Info") = "Dev" THEN
	eCode = "90455"
    moECode = "100018"
Else
	eCode = "100019"
    moECode = "100018"    
End If

currenttime = now()
'currenttime = #02/04/2019 09:00:00#

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount, mileage
dim limitcnt, currentcnt, eventType, soldOutMsg, timeLimitMsg
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
'currentDate = Cdate("2019-03-11")
'// 요건 이벤트 오픈때는 주석처리 할 것
'eventStartDate = Cdate("2019-11-11")

mileage = 2020
subscriptcount=0
totalsubscriptcount=0
limitcnt = 99999
eventType = ""
soldOutMsg = "오늘의 마일리지가 모두 소진 되었습니다!"
timeLimitMsg = "마일리지는 오전 10시부터 받으실수 있습니다."

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", mileage, "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, "", mileage, "")

currentcnt = limitcnt - totalsubscriptcount
'//본인 참여 여부
if currentcnt < 1 then currentcnt = 0
%>
<%
'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

	snpTitle	= Server.URLEncode("[2020년에만 받을 수 있는 마일리지 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/100019/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [2020년에만 받을 수 있는 마일리지 이벤트]"
	Dim kakaodescription : kakaodescription = "단 2일간! 마일리지 2,020원 받고 쇼핑하세요!"
	Dim kakaooldver : kakaooldver = "단 2일간! 마일리지 2,020원 받고 쇼핑하세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/100019/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
.mEvt100019 {position:relative;}
.mEvt100019 .topic {position:relative; background:#50c5da;}
.mEvt100019 .coin i {position:absolute; background:url(//webimage.10x10.co.kr/fixevent/event/2020/100019/m/img_coin.png) no-repeat 50% / contain; animation:rotateAni 1.5s forwards cubic-bezier(0.24, 0.68, 0.58, 1); transform-origin:50% 100%;}
.mEvt100019 .coin i:nth-child(1) {top:5.9vw; right:5.3vw; width:11.5vw; height:11.5vw; animation-delay:0.5s;}
.mEvt100019 .coin i:nth-child(2) {top:55.6vw; left:-2.5vw; width:21.3vw; height:21.3vw; animation-delay:1s;}
.mEvt100019 .coin i:nth-child(3) {top:83vw; right:-18vw; width:30vw; height:30vw; animation-delay:1.5s;}
@keyframes rotateAni {
	0%,100% {transform:rotate(0deg);}
	50% {transform:rotate(-20deg);}
}
.mEvt100019 .tip {position:relative;}
.mEvt100019 .tip a {position:absolute; left:17%; width:66%; height:11%; text-indent:-999em;}
.mEvt100019 .tip .btn-cpn {top:31%;}
.mEvt100019 .tip .bnr1 {bottom:27%;}
.mEvt100019 .tip .bnr2 {bottom:15%;}
.mEvt100019 .share {position:relative;}
.mEvt100019 .share button {position:absolute; top:0; width:20%; height:100%; font-size:0; color:transparent; background:none;}
.mEvt100019 .share button:nth-of-type(1) {right:26%;}
.mEvt100019 .share button:nth-of-type(2) {right:6%;}
</style>
<script type="text/javascript">
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>			
	<% If IsUserLoginOK() Then %>			
		<% if subscriptcount > 0 then %>
			alert("ID당 1회만 참여 가능합니다.");
			return;
		<% else %>	
		// 선착순 이벤트일때
			<% if eventType = "limitedEvent" then %>
				<% if currentcnt < 1 then %>
					alert("<%=soldOutMsg%>");
					return false;
				<% end if %>
				<% if Hour(currenttime) < 10 then %>
					alert("<%=timeLimitMsg%>");
					return false;
				<% end if %>	
			<% end if %>
				var str = $.ajax({
					type: "post",
					url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/specialMileageEventSubscript.asp",
					data: {
						eventType: '<%=eventType%>',
						eventCode: '<%=eCode%>'
					},
					dataType: "text",
					async: false
				}).responseText;	

				if(!str){alert("시스템 오류입니다."); return false;}

				var resultData = JSON.parse(str);

				var reStr = resultData.data[0].result.split("|");
				var currentcnt = resultData.data[0].currentcnt;
				var userMileage = resultData.data[0].mileage;		

				if(reStr[0]=="OK"){		
					alert('마일리지 발급이 완료되었습니다.\n사용하지 않은 마일리지는 이벤트 기간 이후 자동 소멸됩니다.');
					fnAmplitudeEventMultiPropertiesAction('click_mileage_button','evtcode','<%=eCode%>')
					// console.log(resultData.data)
					// showPopup();
				}else{
					var errorMsg = reStr[1].replace(">?n", "\n");
					alert(errorMsg);
				}			
				// console.log(resultData);
				<% if eventType = "limitedEvent" then %>
				$("#dispCnt").html(currentcnt)
				$("#dispMileage").html(setComma(userMileage))
				<% end if %>
			return false;
		<% end if %>
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&moECode&"")%>');
			return false;
		<% end if %>
	<% End If %>
}
</script>
<script>
// 공유용 스크립트
	function snschk(snsnum) {	
		fnAmplitudeEventMultiPropertiesAction('click_event_share','evtcode|sns','<%=eCode%>|'+snsnum)	
		if(snsnum=="fb"){
			<% if isapp then %>
			fnAPPShareSNS('fb','<%=appfblink%>');
			return false;
			<% else %>
			popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
			<% end if %>
		}else{
			<% if isapp then %>		
				fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
				return false;
			<% else %>
				event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
			<% end if %>
		}		
	}
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		// 카카오 SNS 공유
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

	// 카카오 SNS 공유 v2.0
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
</head>

<%' 100019 MKT 2020 마일리지 (A) %>
<div class="mEvt100019">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/100019/m/tit_mileage.jpg" alt="마일리지 이벤트"></h2>
        <%' for dev msg : 마일리지 받기 버튼 %>
        <button type="button" class="btn-get" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/100019/m/btn_get.jpg" alt="마일리지 받기"></button>
        <div class="coin"><i></i><i></i><i></i></div>
    </div>
    <div class="tip">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100019/m/txt_tip.jpg" alt="마일리지 사용 TIP"></p>
        <a href="#" class="btn-cpn" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;">APP쿠폰 확인하기</a>
        <a href="#" class="bnr1" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99851');return false;">나의 소원을 이뤄줄 아이템</a>
        <a href="#" class="bnr2" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99864');return false;">크리스마스 브랜드 TOP5</a>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100019/m/txt_guide.jpg" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다"></p>
    <div class="share">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100019/m/bnr_share.jpg" alt="공유하기"></p>
        <button type="button" onclick="javascript:snschk('fb');">페이스북 공유하기</button>
        <button type="button" onclick="javascript:snschk('kk');">카카오톡 공유하기</button>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2020/100019/m/txt_noti.jpg" alt="이벤트 유의사항"></p>
</div>
<%'// 100019 MKT 2020 마일리지 (A) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->