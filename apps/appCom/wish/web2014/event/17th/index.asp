<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'// SNS 공유용
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink, snpTag2, kakaourl

snpTitle	= "[텐바이텐 17주년]\n슬기로운 텐텐생활"
snpLink		= "http://m.10x10.co.kr/event/17th/index.asp"
snpPre		= "10x10 이벤트"
snpImg		= "http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/img_shared.jpg"
appfblink	= "http://m.10x10.co.kr/event/17th/index.asp"
kakaourl	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/17th/index.asp"
snpTag 		= "[텐바이텐 17주년]\n슬기로운 텐텐생활"
snpTag2 = "#10x10"

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
		fnAmplitudeEventMultiPropertiesAction('click_17th_main_sns','snstype','fb', function(bool){if(bool) {popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');}});
		return false;			
	}else if(snsnum=="pt"){
		popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
	}else if(snsnum=="ka"){		
		fnAmplitudeEventMultiPropertiesAction('click_17th_main_sns','snstype','ka', function(bool){if(bool) {fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');}});		
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
	<div id="content" class="content">
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
	<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->		
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
	</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->