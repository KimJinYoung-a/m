<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2222 마일리지
' History : 2019-11-26 원승현
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
	eCode = "90434"
    moECode = "99033"
Else
	eCode = "99034"
    moECode = "99033"    
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

mileage = 2222
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

	snpTitle	= Server.URLEncode("[마일리지 2,222원 사용 가능]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/99033/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [마일리지 2,222원 사용 가능]"
	Dim kakaodescription : kakaodescription = "단 2일간! 목요일 자정에 사라지니 서둘러요!"
	Dim kakaooldver : kakaooldver = "단 2일간! 목요일 자정에 사라지니 서둘러요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/99033/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
.mEvt99033 .topic {position: relative;}
.mEvt99033 .topic .ani {position:absolute; top:34%; right:0; z-index:10; width:28%; animation:bounce 1s 30;}
.mEvt99033 .btn-mileage {position: absolute; bottom: 7%; left: 0; width: 100%; animation:shake .7s 40;}
.mEvt99033 .btn-mileage img {width: 100%;}
.mEvt99033 .mileage-tip {position: relative;}
.mEvt99033 .mileage-tip .pos {position: absolute; top: 35%; left: 0; width: 100%;}
.mEvt99033 .mileage-tip .pos a {display: block; width: 100%; padding-bottom: 17%; text-indent: -999rem;}
.mEvt99033 .mileage-tip .pos a.chk-cpn {margin-bottom: 28%;}
.mEvt99033 .share {position: relative;}
.mEvt99033 .share ul {display:flex; position:absolute; top:0; right:8.9%; width:36.67%; height:100%;}
.mEvt99033 .share ul li {flex-basis:50%; height:100%;}
.mEvt99033 .share ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(1rem); animation-timing-function:ease-out;}
}
@keyframes shake {
	from, to {transform:translateX(0.3rem);}
	50% {transform:translateX(-0.3rem);}
}
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
<%' 99033 2222마일리지 %>
<div class="mEvt99033">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99033/m/tit_mileage_a.jpg" alt="단 2일간 사용하는 스페셜 마일리지!"></h2>
        <span class="ani"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99033/m/img_2days.png" alt="단 2일간"></span>
        <%' for dev msg 마일리지받기 버튼 %>
        <a href="" onclick="doAction();" class="btn-mileage"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99033/m/btn_mileage.png?v=1.01" alt="마일리지 받기"></a>
    </div>
    <div class="mileage-tip">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99033/m/img_tip.jpg" alt="마일리지 알차게 사용하는 TIP">
        <div class="pos">
            <a href="" class="chk-cpn" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" >APP쿠폰 확인하기</a>
            <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/christmas');return false;" >크리스마스 꾸미기 소품</a>
            <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '기획전', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98620');return false;" >10x10 best 20</a>
        </div>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99033/m/txt_guide.jpg" alt="마일리지는 결제 시, 현금처럼 사용할 수 있습니다. "></p>
    <div class="share">
        <img src="//webimage.10x10.co.kr/fixevent/event/2019/99033/m/btn_share.jpg" alt="btn_share">
        <!-- for dev msg sns 공유하기 버튼-->
        <ul>
            <li><a href="javascript:snschk('fb');">페이스북 공유</a></li>
            <li><a href="javascript:snschk('kk');">카카오톡 공유</a></li>
            <%' for dev msg 카카오 공유 이미지 : http://webimage.10x10.co.kr/fixevent/event/2019/99033/img_kakao.jpg %>
        </ul>
    </div>
    <div class="noti"><img src="//webimage.10x10.co.kr/fixevent/event/2019/99033/m/txt_noti_a.jpg" alt="유의사항"></div>
</div>
<%' // 99033 2222마일리지 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->