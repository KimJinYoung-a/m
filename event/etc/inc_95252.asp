<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 스페셜마일리지
' History : 2019-03-07 최종원
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
	eCode = "90317"
Else
	eCode = "95252"
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
eventStartDate = Cdate("2019-06-11")

mileage = 3000
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

    snpTitle    = Server.URLEncode("[마일리지 3,000원 받자!]")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("")
    appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = " [마일리지 3,000원 받자!]"
    Dim kakaodescription : kakaodescription = "단 오늘 사용 가능한 스페셜 마일리지를 받아보세요!"
    Dim kakaooldver : kakaooldver = "단 오늘 사용 가능한 스페셜 마일리지를 받아보세요!"
    Dim kakaoimage : kakaoimage = ""
    Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt95252 .btn-area {position:relative;}
.mEvt95252 .btn-submit {position:absolute; left:0; bottom:0; width:100%; height:26%; background:none; font-size:0; color:transparent;}
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
//공유용 스크립트
	function snschk() {		
		<% if isapp then %>		
			fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
			return false;
		<% else %>
			event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
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
</head>
<body>
			<% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>
			<div>받은 고객 수 : <%=totalsubscriptcount%></div>			
			<% end if %>

			<!-- 급마일리지 -->
			<div class="mEvt95252">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/95252/m/tit.jpg" alt=""></h2>
				<div class="btn-area">
					<img src="//webimage.10x10.co.kr/fixevent/event/2019/95252/m/txt_01_v1.jpg" alt="3000마일리지">
					<button class="btn-submit" onclick="doAction();">마일리지 받기</button>
				</div>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95252/m/txt_02.jpg" alt=""></p>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2019/95252/m/txt_03.jpg" alt=""></p>
			</div>
			<!-- // 급마일리지 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->