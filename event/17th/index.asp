<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'head.asp에서 출력
strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐 17주년] 슬기로운 텐텐생활!"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/17th/"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/eventIMG/2018/88938/banMoList20181004170646.JPEG"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:description"" content=""[텐바이텐] 이벤트 - 최대 25% 쿠폰과 다양한 혜택이 당신을 기다립니다!:)"">" & vbCrLf

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[텐바이텐 17주년]\n슬기로운 텐텐생활")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/17th/index.asp")
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_shared.jpg")
appfblink	= "http://m.10x10.co.kr/event/17th/index.asp"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐 17주년]\n슬기로운 텐텐생활!"
Dim kakaodescription : kakaodescription = "최대 25% 쿠폰과 다양한 혜택이\n당신을 기다립니다!:)"
Dim kakaooldver : kakaooldver = "최대 25% 쿠폰과 다양한 혜택이\n당신을 기다립니다!:)"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_shared.jpg"
Dim kakaolink_url 

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/17th/index.asp"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/17th/"
End If
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<title>슬기로운 텐텐생활 - 10월, 텐바이텐을 더 즐겁게 이용하는 방법!</title>
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>			
<script>
$(function() {
	<% if isapp="1" then %>
	fnAPPchangPopCaption('슬기로운 텐텐생활');
	<% end if %>
});
function sharePt(url,imgurl,label){
	PinUtils.pinOne({
		'url' : url,
		'media' : imgurl,
		'description' : label
	});
}
function fnAPPRCVpopSNS(){
	//fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	$("#lySns").show();
	$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	return false;
}
function snschk(snsnum) {
	if(snsnum=="fb"){
		// fnAPPShareSNS('fb','<%=replace(appfblink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")%>');
		popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');		
		fnAmplitudeEventMultiPropertiesAction('click_17th_main_sns','snstype','fb');
	}else if(snsnum=="pt"){
		popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
	}else if(snsnum=="ka"){
		event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );
		fnAmplitudeEventMultiPropertiesAction('click_17th_main_sns','snstype','ka');		
		return false;	
	}
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
<body class="default-font body-sub bg-grey">
	<!-- #include virtual="/lib/inc/incHeader.asp" -->	
	<div id="content" class="content">
		<div class="evtContV15">
		<%
			dim currentDate, testDate
			testDate = request("testdate") 
			currentDate = date()
			if testdate <> "" then
				currentDate = testDate
			end if						
		%>
		<% if currentDate < "2018-10-29" then %>
			<%'!--  17주년 1차(web/app 공통 파일)--%>
			<% server.Execute("/event/17th/exc_main.asp") %>		
		<% else %>
			<%'!--  17주년 2차(web/app 공통 파일)--%>
			<% server.Execute("/event/17th/exc_main2.asp") %>				
		<% end if %>
		</div>
	</div>	
	<!-- #include virtual="/common/LayerShare.asp" -->	
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->