<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2222 마일리지
' History : 2019-09-24 최종원
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
	eCode = "90392"
Else
	eCode = "97493"
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
eventStartDate = Cdate("2019-09-24")

mileage = 2222
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

	snpTitle	= Server.URLEncode("[마일리지 2,222원 사용 가능]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/97493/m/img_kakao_share.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode

	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [마일리지 2,222원 사용 가능]"
	Dim kakaodescription : kakaodescription = "단 2일간! 목요일 자정에 사라지니 서둘러요!"
	Dim kakaooldver : kakaooldver = "단 2일간! 목요일 자정에 사라지니 서둘러요!"
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/97493/m/img_kakao_share.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt97493 .topic {position:relative;}
.mEvt97493 .txt-only {position:absolute; top:36.5%; right:6.1%; width:17.6%; animation:bounce 1s 30;}
.mEvt97493 .btn-mileage {padding:0 11.67%; background-color:#ffc956;}
.mEvt97493 .btn-mileage img {animation:shake .7s 40;}
@keyframes bounce {
	from, to {transform:translateY(0); animation-timing-function:ease-in;}
	50% {transform:translateY(1rem); animation-timing-function:ease-out;}
}
@keyframes shake {
	from, to {transform:translateX(0.3rem);}
	50% {transform:translateX(-0.3rem);}
}
.sns-share {position:relative;}
.sns-share ul {display:flex; position:absolute; top:0; right:8.9%; width:36.67%; height:100%;}
.sns-share ul li {flex-basis:50%; height:100%;}
.sns-share ul li a {display:inline-block; width:100%; height:100%; text-indent:-999em;}
.noti {padding-bottom:3.84rem; background-color:#c05c34;}
.noti ul {padding:0 6.4%;}
.noti ul li {padding:.4rem 0 .4rem .6rem; color:#fff; font-size:1rem; line-height:1.64; text-indent:-.6rem; word-break:keep-all;}
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
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
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
			<% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>
			<div>받은 고객 수 : <%=totalsubscriptcount%></div>
			<% end if %>
			<!-- 마일리지 2222 -->
			<div class="mEvt97493">
				<div class="topic">
					<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/img_top.jpg" alt="2222 마일리지"></p>
					<span class="txt-only"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/txt_only.png" alt="단 2일간"></span>
					<button type="button" class="btn-mileage" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/btn_get.png" alt="마일리지 받기"></button>
				</div>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/img_usage.jpg" alt="현금처럼 사용할 수 있습니다"></p>
				<div class="sns-share">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/img_share.jpg" alt="9월 마일리지 이벤트 친구에게 공유하기">
					<ul>
						<li><a href="javascript:snschk('fb');">페이스북 공유</a></li>
						<li><a href="javascript:snschk('kk');">카카오톡 공유</a></li>
					</ul>
				</div>
				<div class="noti">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/tit_noti.jpg" alt="이벤트 유의사항">
					<ul>
						<li>· 본 이벤트는 <strong>로그인 후, ID당 1회만 참여 가능</strong>합니다.</li>
						<li>· 주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
						<li>· 지급된 마일리지는 <strong>3만원 이상 구매 시 현금처럼 사용 가능</strong>합니다.</li>
						<li>· 주문결제 시 마일리지 란에서 사용 가능합니다.</li>
						<li>· 기간 내에 사용하지 않은 마일리지는 <strong>9월 27일 금요일 00:00:00에 자동 소멸</strong>됩니다. </li>
						<li>· 이벤트 기간 이후에 주문 취소 시, 마일리지는 다시 회수될 예정입니다.</li>
					</ul>
				</div>
				<a href="/event/eventmain.asp?eventid=97295" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97295');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/bnr_evt1.jpg" alt="컬러별 작은집 인테리어 싱글룸 사용 설명서"></a>
				<a href="/event/eventmain.asp?eventid=97423" onclick="fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97423');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97493/m/bnr_evt2.jpg" alt="초록창에서 사랑받는 아이템, 최최최저가로 사기"></a>
			</div>
			<!-- // 마일리지 2222 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->