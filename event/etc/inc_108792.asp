<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 마일리지 2021
' History : 2021-01-04 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "104287"
Else
	eCode = "108792"
End If

'// SNS 공유용
	Dim vTitle, vLink, vPre, vImg
	Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink
	snpTitle	= Server.URLEncode("[새해 마일리지 이벤트]")
	snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/108792/m/img_kakao_share.png")
	appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	'// 카카오링크 변수
	Dim kakaotitle : kakaotitle = " [새해 마일리지 이벤트]"
	Dim kakaodescription : kakaodescription = "단 3일간 모두에게 마일리지 2,021p를 드립니다."
	Dim kakaooldver : kakaooldver = "단 3일간 모두에게 마일리지 2,021p를 드립니다."
	Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/108792/m/img_kakao_share.png"
	Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
	kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
	kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
	kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& eCode
%>
<style type="text/css">
.mEvt108792 .topic {position:relative;}
.mEvt108792 .topic .btn-share {display:inline-block; width:100%; height:6rem; position:absolute; left:0; bottom:5%;}
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
            <div class="mEvt108792">
                <div class="topic">
                    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/108792/m/img_tit.jpg" alt="올해 의 첫번째 쇼핑 혜택 2021 마일리지"></h2>
                    <!-- App쿠폰 받으로 가기 -->
                    <a href="http://m.10x10.co.kr/event/benefit/" target="_blank" class="mWeb btn-share"></a>
                    <a href=""  onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;" class="mApp btn-share"></a>
                </div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108792/m/img_sub.jpg" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다.">
                    <!-- 카카오톡 공유하기 -->
                    <a href="#" onclick="snschk('kt');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108792/m/img_kakao.jpg" alt="친구에게도 이벤트 소식을 알려주세요."></a>
                    <img src="//webimage.10x10.co.kr/fixevent/event/2020/108792/m/img_noti.jpg" alt="이벤트 유의사항">
                </div>
            </div>
<!-- #include virtual="/lib/db/dbclose.asp" -->