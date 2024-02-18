<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
strHeadTitleName = "이벤트"

'head.asp에서 출력
strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐] 16주년 텐쇼 - 뽑아주쑈!"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/16th/pickshow.asp"" />" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:image"" content=""http://webimage.10x10.co.kr/eventIMG/2017/80412/banMoList20170929160648.JPEG"">" & vbCrLf
strOGMeta = strOGMeta & "<meta property=""og:description"" content=""[텐바이텐] 이벤트 - 매일매일 마음에 드는 아이템을 최대 3개까지 골라주세요!"">" & vbCrLf
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<title>10x10: 16주년 텐쑈 - 뽑아주쑈!</title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
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
	<!-- #include virtual="/lib/inc/incHeader.asp" -->
	<!-- contents -->
	<div id="content" class="content">
		<div class="evtContV15">
		<%'!--  16주년 내용 실행(web/app 공통 파일)--%>
		<% server.Execute("/event/16th/exc_pickshow.asp") %>
		</div>
	</div>
	<!-- //contents -->
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->