<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 3333 마일리지
' History : 2019-08-27 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime
IF application("Svr_Info") = "Dev" THEN
	eCode = "90377"
Else
	eCode = "96941"
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
'eventStartDate = Cdate("2019-08-27")

mileage = 3333
subscriptcount=0
totalsubscriptcount=0
limitcnt = 9999
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

	snpTitle	= Server.URLEncode("[현금처럼 사용하는 3,333 마일리지]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/96941/share.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [현금처럼 사용하는 3,333 마일리지]"
	Dim kakaodescription : kakaodescription = "단 2일간! 마일리지로 알차게 쇼핑해보세요!"
	Dim kakaooldver : kakaooldver = "단 2일간! 마일리지로 알차게 쇼핑해보세요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/96941/share.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt96941 ,.mEvt96941 > div {position: relative;}
.mEvt96941 .pos {position: absolute;}
.mEvt96941 .topic {position:relative;}
.mEvt96941 .txt-only {position:absolute; top:24.54%; right:4.2%; width:18.8%; animation:bounce 1s 30;}
.mEvt96941 .btn-mileage {position:absolute; left:12%; bottom:39%; width: 76%; background:none; animation:shake .7s 40;}
.mEvt96941 .bnr-sns {position: absolute; display: flex; justify-content: flex-end; top: 0;  width: 100%; height: 100%; }
.mEvt96941 .bnr-sns a {display: block; width: 27%; text-indent: -999rem; }
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
					url:"/event/etc/doeventsubscript/specialMileageEventSubscript.asp",
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
					alert('마일리지가 발급되었습니다.');
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
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>
}
// function showPopup(){
// 	$('#lyrSch1').fadeIn();
// 	$('body').css({'overflow':'hidden'})
// }
</script>
<script>
// 공유용 스크립트
	function snschk(snsnum) {		
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
			<% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>
			<div>받은 고객 수 : <%=totalsubscriptcount%></div>
			<% end if %>
			<div class="mEvt96941">
				<div class="topic">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/96941/m/img_evt.jpg" alt="3333 마일리지"></p>
					<span class="txt-only"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96941/m/ico.png" alt="단 3일간"></span>
					<button type="button" class="btn-mileage" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96941/m/btn.png" alt="마일리지 받기"></button>
				</div>
				<div>
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/96941/m/bnr_sns.jpg" alt="공유하기">
					<div class="bnr-sns">
						<a href="javascript:snschk('fb');" class="btn-fb">페이스북</a>
						<a href="javascript:snschk('kk');" class="btn-kakao">카카오</a>
					</div>
				</div>
				<div><img src="//webimage.10x10.co.kr/fixevent/event/2019/96941/m/img_notice.jpg" alt="유의사항"></div>
				<a href="/event/eventmain.asp?eventid=96459" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96459');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96941/m/bnr_1.jpg" alt="추석 선물로 딱 좋은 아이템"></a>
				<a href="/event/eventmain.asp?eventid=96790" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=96790');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/96941/m/bnr_2.jpg" alt="식학기 패션"></a>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->