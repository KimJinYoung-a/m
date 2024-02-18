<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  크리스마스 기획전
' History : 2018-11-12 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'// SNS 공유용
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink, snpTag2, kakaourl

snpTitle	= "[텐바이텐 ]\nCHRISTMAS RECORD"
snpLink		= "http://m.10x10.co.kr/christmas/index.asp?gaparam=sharedPage"
snpPre		= "10x10 이벤트"
snpImg		= "http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_share.jpg"
appfblink	= "http://m.10x10.co.kr/christmas/index.asp?gaparam=sharedPage"
kakaourl	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/christmas/index.asp?gaparam=sharedPage"
snpTag 		= "[텐바이텐 ]\nCHRISTMAS RECORD"
snpTag2 = "#10x10"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐 ]\nCHRISTMAS RECORD!"
Dim kakaodescription : kakaodescription = "당신의 크리스마스는 어떤 모습인가요? 찰칵, 한 컷에 담아 보세요."
Dim kakaooldver : kakaooldver = "당신의 크리스마스는 어떤 모습인가요? 찰칵, 한 컷에 담아 보세요."
Dim kakaoimage : kakaoimage = "http://fiximage.10x10.co.kr/web2018/xmas2018/m/img_share.jpg"
Dim kakaolink_url 

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/christmas/index.asp?gaparam=sharedPage"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/christmas/index.asp?gaparam=sharedPage"
End If
%>
<%
    dim link_option, gnbflag, vGaparam

    dim updateDate, testDate, currentDate, updatePage, originPage

    currentDate = date()
    'feed 페이지 설정부분
    updateDate = cdate("2018-12-14")
    updatePage = "xmas_main_exec_1214.asp"
    originPage = "xmas_main_exec_1213.asp"

    testDate = request("testdate")

    if testDate <> "" then
        currentDate = cdate(testDate)
    end if

    link_option = request("link")
    if link_option = "" then link_option = 1

    gnbflag = RequestCheckVar(request("gnbflag"),1)
    vGaparam = request("gaparam")

    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true 
    Else 
        gnbflag = False
        strHeadTitleName = "크리스마스"
    End if

    if vGaparam <> "" then
        gnbflag = false
    end if    
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/xmas2018.css?v=1.0" />
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>			
<script type="text/javascript">
$(function() {
    fnAmplitudeEventMultiPropertiesAction('view_2018christmas_main','','');
	/* tag */
	var tagSwiper = new Swiper (".xmas-insta .tag .swiper-container", {
		slidesPerView:"auto",
		freeMode:true,
		freeModeMomentumRatio:0.5
	});
});
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
</script>
</head>
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">    
<%
    if link_option = 1 then
        if currentDate >= updateDate   then
            server.Execute("/christmas/2018/"&updatePage)
        else
            server.Execute("/christmas/2018/"&originPage)
        end if            
    else 
        server.Execute("/christmas/2018/xmas_pick_exec.asp")
    end if
%>	
	<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->		
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->