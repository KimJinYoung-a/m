<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 3000 마일리지
' History : 2020-11-02 정태훈
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
	eCode = "103249"
Else
	eCode = "107158"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

currenttime = now()
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
if (GetLoginUserLevel="7") then
	IF currentDate < eventStartDate THEN
		eventStartDate = currentDate
	END IF
end if
'// 요건 이벤트 오픈때는 주석처리 할 것
'eventStartDate = Cdate("2019-11-11")

mileage = 3000
subscriptcount=0
totalsubscriptcount=0
limitcnt = 99999
eventType = ""
soldOutMsg = "오늘의 마일리지가 모두 소진 되었습니다!"
timeLimitMsg = "마일리지는 오전 10시부터 받으실수 있습니다."

if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" or userid="thensi7" or userid = "motions" or userid = "jj999a" or userid = "phsman1" or userid = "jjia94" or userid = "seojb1983" or userid = "kny9480" or userid = "bestksy0527" or userid = "mame234" or userid = "corpse2" or userid = "starsun726" or userid = "bora2116" then
	currentDate = cdate("2020-11-04")
end if

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
	snpTitle	= Server.URLEncode("[마일리지 지급 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/107158/m/img_kakao.png")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [마일리지 지급 이벤트]"
	Dim kakaodescription : kakaodescription = "단 2일간 모두에게 마일리지 3,000p를 드립니다."
	Dim kakaooldver : kakaooldver = "단 2일간 모두에게 마일리지 3,000p를 드립니다."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/107158/m/img_kakao.png"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt107158 .sns-share {position:relative;}
.mEvt107158 .sns-share .btn-sns {display:inline-block; position:absolute; top:0; right:8%; width:17%; height:100%; background-color:transparent; text-indent:-999em;}
.mEvt107158 .sns-share .btn-fb {right:27.5%}
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
		fnAmplitudeEventMultiPropertiesAction('click_event_share','evtcode|sns','<%=eCode%>|'+snsnum);
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
			<div class="mEvt107158">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/107158/m/img_conts.jpg" alt="3000P"></h2>
				<button class="btn_mileage" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107158/m/btn_mileage.jpg" alt="마일리지받기"></button>
				<div class="benefit">
					<a href="#" class="mApp" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107158/m/img_coupon.jpg" alt=""></a>
					<a href="/event/benefit/" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107158/m/img_coupon.jpg" alt=""></a>
				</div>
				<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107158/m/txt_guide.jpg" alt=""></div>
				<!-- sns공유 버튼 -->
				<div class="sns-share">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/107158/m/img_sns.jpg" alt="">
					<button class="btn-sns btn-fb" onclick="snschk('fb');">페이스북 공유</button>
					<button class="btn-sns btn-kakao" onclick="snschk('kt');">카카오톡 공유</button>
				</div>
				<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/107158/m/imh_07.jpg" alt=""></div>
			</div>