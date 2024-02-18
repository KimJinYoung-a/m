<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	dim snpTitle, snpLink, snpPre, snpImg , snpTag , snpTag2 , kakaourl
	snpTitle	= Server.URLEncode("[텐바이텐] 16주년 텐쇼")
	snpLink		= Server.URLEncode("http://www.10x10.co.kr/event/16th/index.asp")
	snpPre		= Server.URLEncode("10x10 이벤트")
	snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2017/16th/m/kakao_tenshow_main.jpg")

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 16주년 텐쑈")
	snpTag2 = Server.URLEncode("#10x10")
	kakaourl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/16th/"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	'APP 버전 접수
	vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	if Not(isNumeric(vAdrVer)) then vAdrVer=1.0
%>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
$(function(){
	fnAPPchangPopCaption('이벤트');
});

// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}

function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	<%
		'// 아이폰 1.998, 안드로이드 1.92 이상부터는 카카오링크 APPID 변경 (2017.07.12; 허진원)
		if (flgDevice="I" and vAdrVer>="1.998") or (flgDevice="A" and vAdrVer>="1.92") then
	%>
			Kakao.init('b4e7e01a2ade8ecedc5c6944941ffbd4');
	<%	else %>
			Kakao.init('c967f6e67b0492478080bcf386390fdd');
	<%	end if %>

	Kakao.Link.sendTalkLink({
		label: label,
		image: {
			src: imageurl,
			width: width,
			height: height
			},
		appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
				android: { url: linkurl},
				iphone: { url: linkurl}
			}
		}
  });
}
</script>
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script>
function sharePt(url,imgurl,label){
	PinUtils.pinOne({
		'url' : url,
		'media' : imgurl,
		'description' : label
	});
}
</script>
</head>
<body class="default-font body-sub bg-grey">
	<!-- contents -->
	<div id="content" class="content">
	<%'!--  16주년 내용 실행(web/app 공통 파일)--%>
	<% server.Execute("/event/16th/exc_main.asp") %>
	</div>
	<% '수집 스크립트들 %>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incLogScript.asp" -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->