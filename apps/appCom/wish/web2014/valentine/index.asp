<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  발렌타인데이 기획전
' History : 2019-01-17 최종원 생성
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

snpTitle	= "[텐바이텐 ]발렌타인데이 "
snpLink		= "http://m.10x10.co.kr/valentine/index.asp"
snpPre		= "10x10 이벤트"
snpImg		= "http://fiximage.10x10.co.kr/web2019/valentine/m/img_bnr_share.jpg"
appfblink	= "http://m.10x10.co.kr/valentine/index.asp"
kakaourl	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/valentine/index.asp"
snpTag 		= "[텐바이텐 ]발렌타인데이"
snpTag2 = "#10x10"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 발렌타인데이"
Dim kakaodescription : kakaodescription = "우리 사이처럼 달콤한 발렌타인데이 선물"
Dim kakaooldver : kakaooldver = "우리 사이처럼 달콤한 발렌타인데이 선물"
Dim kakaoimage : kakaoimage = "http://fiximage.10x10.co.kr/web2019/valentine/m/img_bnr_share.jpg"
Dim kakaolink_url 

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/valentine/index.asp"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/valentine/index.asp"
End If
%>
<%
    dim gnbflag, vGaparam

    gnbflag = RequestCheckVar(request("gnbflag"),1)
    vGaparam = request("gaparam")

    If gnbflag <> "" Then '//gnb 숨김 여부
        gnbflag = true 
    Else 
        gnbflag = False
        strHeadTitleName = "발렌타인"
    End if

    if vGaparam <> "" then
        gnbflag = false
    end if    
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>			
<script type="text/javascript">
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
    server.Execute("/valentine/valentine_exec.asp")
%>	
	<!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->		
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->