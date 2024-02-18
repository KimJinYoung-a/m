<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  세라밸
' History : 2019-03-28 최종원 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
'// SNS 공유용
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink, snpTag2, kakaourl, gnbflag

snpTitle	= "[텐바이텐] 세.라.밸 페스티벌"
snpLink		= "http://m.10x10.co.kr/event/salelife/index.asp"
snpPre		= "10x10 이벤트"
snpImg		= "http://webimage.10x10.co.kr/fixevent/event/2019/salabal/index/bnr_salabal_share.jpg"
appfblink	= "http://m.10x10.co.kr/event/salelife/index.asp"
kakaourl	= "http://m.10x10.co.kr/event/salelife/index.asp"
snpTag 		= "[텐바이텐] 세.라.밸 페스티벌"
snpTag2 = "#10x10"

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 세.라.밸 페스티벌!"
Dim kakaodescription : kakaodescription = "최대 20% 쿠폰으로 당신의 삶의 질을 높여드릴 상품들이 당신을 기다립니다!"
Dim kakaooldver : kakaooldver = "최대 20% 쿠폰으로 당신의 삶의 질을 높여드릴 상품들이 당신을 기다립니다!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/salabal/index/bnr_salabal_share.jpg"
Dim kakaolink_url 

If isapp = "1" Then '앱일경우
	kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/salelife/index.asp"
Else '앱이 아닐경우
	kakaolink_url = "http://m.10x10.co.kr/event/salelife/"
End If

gnbflag = RequestCheckVar(request("gnbflag"),1)

If gnbflag <> "" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "세라벨"
End if
%>
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>		
<script>
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
	fnAmplitudeEventMultiPropertiesAction('click_2019salelife_share','type',snsnum);
	if(snsnum=="fb"){	
		<% if isapp then %>
		fnAmplitudeEventMultiPropertiesAction('click_2019salelife_share','type','fb', function(bool){if(bool) {fnAPPShareSNS('fb','<%=replace(appfblink,"m.10x10.co.kr/","m.10x10.co.kr/")%>')}});        
        <% else %>
        popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
        <% end if %>        	
		return false;			
	}else if(snsnum=="pt"){
		popSNSPost('pt','<%=snpTitle%>','<%=snpLink%>','','<%=snpImg%>');
	}else if(snsnum=="ka"){				
		fnAmplitudeEventMultiPropertiesAction('click_2019salelife_share','type','ka', function(bool){if(bool) {fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%="http://m.10x10.co.kr/event/salelife/"%>','<%="http://m.10x10.co.kr/event/salelife/"%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');}});
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
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">    
<%
    server.Execute("/event/salelife/salelife_exec.asp")
%>			
    <!-- #include virtual="/apps/appCom/wish/web2014/common/LayerShare.asp" -->		
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->