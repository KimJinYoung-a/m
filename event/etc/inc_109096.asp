<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 2000 마일리지 이벤트
' History : 2021-01-18 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/realtimeevent/RealtimeEventCls.asp" -->
<%
dim eCode, LoginUserid, pwdEvent
IF application("Svr_Info") = "Dev" THEN
	eCode = "104299"
Else
	eCode = "109096"
End If

'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink
	snpTitle	= Server.URLEncode("[마일리지 무료 지급 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_kakao.jpg")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [마일리지 무료 지급 이벤트]"
	Dim kakaodescription : kakaodescription = "단 3일간 모두에게 추가 2,000p를 드립니다."
	Dim kakaooldver : kakaooldver = "단 3일간 모두에게 추가 2,000p를 드립니다."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_kakao.jpg"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style>
.mEvt109096 .topic {position:relative;}
.mEvt109096 .txt_name {width:100%; position:absolute; left:50%; top:7%; padding-left:23%; transform: translate(-50%,0); font-size:4.5vw; color:#443e34; font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
.mEvt109096 .section-01 a,
.mEvt109096 .section-02 a {display:inline-block; width:100%; height:100%;}
</style>
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
			<div class="mEvt109096">
				<div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_tit.jpg" alt="마일리지 2000p 를 지원해 드립니다.">
                    <div class="txt_name"><span><% if GetLoginUserName<>"" then%><%=GetLoginUserName%><% else %>고객<% end if %></span>님께 도착한 마일리지레터</div>
                </div>
                <div class="section-01">
                    <a href="http://m.10x10.co.kr/my10x10/mymain.asp" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_sub01.jpg" alt="마일리지 받는 방법"></a>
                    <a href="" onclick="fnAPPpopupBrowserURL('마일리지 내역', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/offshop/point/mileagelist.asp'); return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_sub01.jpg" alt="마일리지 받는 방법"></a>

                    <a href="http://m.10x10.co.kr/event/benefit/" target="_blank" class="mWeb"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_sub02.jpg" alt="더 알차게 사용하는 꿀팁"></a>
                    <a href="" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="mApp"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_sub02.jpg" alt="더 알차게 사용하는 꿀팁"></a>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_sub03.jpg" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다.">
                    <!-- 카카오톡 공유하기 -->
                    <a href="#" onclick="snschk('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_sub04.jpg" alt="카카오톡 공유하기"></a>
                </div>
                <div class="notice">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/109096/m/img_sub05.jpg" alt="이벤트 유의사항">
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->