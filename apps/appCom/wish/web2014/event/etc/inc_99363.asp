<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2222 마일리지
' History : 2019-12-10 원승현
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
	eCode = "90442"
    moECode = "99362"
Else
	eCode = "99363"
    moECode = "99362"    
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

	snpTitle	= Server.URLEncode("[연말에 쓰기 좋은 마일리지 2,222원을 드립니다]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/99363/m/img_kakao_share.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [연말에 쓰기 좋은 마일리지 2,222원을 드립니다]"
	Dim kakaodescription : kakaodescription = "단 2일간! 목요일 자정에 사라지니 서둘러요!"
	Dim kakaooldver : kakaooldver = "단 2일간! 목요일 자정에 사라지니 서둘러요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/99363/m/img_kakao_share.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style type="text/css">
.mEvt99363 {background:#ffc923;}
.mEvt99363 .topic {position:relative;}
.mEvt99363 .topic .txt-app {position:absolute; top:53%; right:6.1%; z-index:10; width:20%; animation:bounce 1s 30;}
.mEvt99363 .topic .coin {position:absolute; left:0; bottom:0; width:100%; height:40.71%; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/98513/m/img_coin.png); background-size:100% auto; animation:2s coin steps(1) infinite;}
.mEvt99363 .btn-mileage {padding:0 17.3%;}
.mEvt99363 .btn-mileage button {width:100%; background:transparent;}
.mEvt99363 .tip {position:relative;}
.mEvt99363 .tip a {display:inline-block; position:absolute; left:17%; width:66%; height:11%; text-indent:-999em;}
.mEvt99363 .tip .btn-cpn {top:32%;}
.mEvt99363 .tip .bnr1 {bottom:27%;}
.mEvt99363 .tip .bnr2 {bottom:15%;}
.mEvt99363 .sns-share {position:relative;}
.mEvt99363 .sns-share ul {display:flex; position:absolute; right:6%; top:14%; width:40%; height:75%;}
.mEvt99363 .sns-share ul li {flex-basis:50%; height:100%;}
.mEvt99363 .sns-share ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(1rem); animation-timing-function:ease-out;}
}
@keyframes coin {
    0% {background-position:0 0;}
    10% {background-position:0 25%;}
    20% {background-position:0 50%;}
    30% {background-position:0 75%;}
    40% {background-position:0 100%;}
    100% {background-position:0 100%;}
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
<%' 마일리지 2222 %>
<div class="mEvt99363">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/99363/m/tit_mileage.png" alt="단 2일간 사용하는 2222마일리지"></h2>
        <span class="txt-app"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98513/m/img_bubble_app.png" alt="단2일간"></span>
        <div class="coin"></div>
    </div>
    <div class="btn-mileage"><button type="button" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98513/m/btn_mileage.png" alt="마일리지 받기"></button></div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99363/m/txt_special.png" alt="본 마일리지는 미사용시 소멸되는 스페셜 마일리지 입니다"></p>
    <div class="tip">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99363/m/txt_tip.jpg?v=2" alt="마일리지 알차게 사용하는 TIP"></p>
        <a href="#" class="btn-cpn" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;">APP쿠폰 확인하기</a>
        <a href="#" class="bnr1" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=99187');return false;">나의 소원을 이뤄줄 아이템</a>
        <a href="#" class="bnr2" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=98903');return false;">크리스마스 브랜드 TOP5</a>
    </div>
    <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99363/m/img_ex.png?v=2" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다"></p>
    <div class="sns-share">
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/99363/m/txt_share.png" alt="11월 마일리지 이벤트 친구에게 공유하기"></p>
        <ul>
            <li><a href="javascript:snschk('fb');">페이스북 공유</a></li>
            <li><a href="javascript:snschk('kk');">카카오톡 공유</a></li>
        </ul>
    </div>
    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/99363/m/txt_noti_app.png" alt="이벤트 유의사항"></div>
</div>
<%' // 마일리지 2222 %>
<!-- #include virtual="/lib/db/dbclose.asp" -->