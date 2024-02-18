<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'###########################################################
' Description :  SBS dramazone (share)
' History : 2018-05-03 이종화 생성 - 모바일
'###########################################################
Dim sqlStr , arrList , jcnt , dramaidx , listidx

	dramaidx = requestCheckVar(Request("dramaidx"),10)
	listidx = requestCheckVar(Request("listidx"),10)

	'// sbs 드라마존 서비스 종료
	If date() > "2019-03-31" and GetLoginUserLevel <> "7"  Then
		response.write "<script>alert('종료된 서비스 입니다.'); location.href='/'</script>"
		dbget.close()	:	response.End
	End If

	If dramaidx = "" Or listidx = "" Then
		Call Alert_Return("올바른 접근이 아닙니다.")
		dbget.close()	:	response.End
	End If

	'// query
	sqlStr = "[db_sitemaster].[dbo].[usp_WWW_SBSvShop_DramaList_Get] @idx=" & dramaidx & ", @listidx=" & listidx
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr,dbget,1
	IF Not (rsget.EOF OR rsget.BOF) THEN
		arrList = rsget.GetRows
	END If
	rsget.close

	Dim contentsText : contentsText = db2html(arrList(3,0))
	Dim dramaTitle : dramaTitle = db2html(arrList(2,0))
	Dim thumbImage	: thumbImage = staticImgUrl & "/mobile/drama" & arrList(4,0)
	Dim posterImage	: posterImage = staticImgUrl & "/mobile/drama" & arrList(11,0)
	Dim contentsRegdate : contentsRegdate = formatDate(arrList(12,0),"0000.00.00")
	Dim kakaoshareimage : kakaoshareimage = staticImgUrl & "/mobile/drama" & arrList(13,0)


	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐] 드라마존 - "& dramaTitle &""">" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/dramazone/share.asp?dramaidx="& dramaidx &"&listidx="& listidx &" "" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content="""& thumbImage &""">" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:description"" content="""& contentsText &""">" & vbCrLf

	Dim vTitle, vLink, vImg
	vTitle = dramaTitle
	vLink = "http://m.10x10.co.kr/dramazone/share.asp?dramaidx="& dramaidx &"&listidx="& listidx
	vImg = thumbImage

	vTitle = nl2br(vTitle)
	vTitle = Replace(vTitle,"<br />"," ")

	dim snpTitle, snpLink
	snpTitle = Server.URLEncode(vTitle)
	snpLink = Server.URLEncode(vLink)

%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
$(function() {
	fnAmplitudeEventMultiPropertiesAction("view_dramazoneshare","idx|dramaidx","<%=listidx%>|<%=dramaidx%>");
});
</script>
<style>
[v-cloak] { display: none; }
</style>
</head>
<body class="default-font body-popup sbsDrama" style="margin-top:-4.78rem;">
	<header class="tenten-header header-popup header-popup-transparent">
		<div class="title-wrap bg-blue">
			<h1 class="hidden">공유하기</h1>
			<button type="button" class="btn-close">닫기</button>
		</div>
	</header>

	<div id="content" class="content sbs-share">
		<%'!-- share --%>
		<div class="share bg-blue">
			<h2><span class="multi-ellipsis"><%=dramaTitle%></span></h2>
			<ul class="sns-list">
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); fnAmplitudeEventAction('click_dramazoneshare','action','facebook'); return false;"><span class="icon icon-facebook">페이스북 공유</span></a></li>
				<li><a href="" onclick="fnAmplitudeEventAction('click_dramazoneshare','action','kakao');return false;" id="kakaoa"><span class="icon icon-kakao">카카오 공유</span></a></li>
				<li id="clipboards" data-clipboard-text="<%=vLink%>" onclick="fnAmplitudeEventAction('click_dramazoneshare','action','urlcopy');"><span class="icon icon-url">링크 공유</span></li>
			</ul>

			<div class="chn-wrap">
				<span class="thumb-chn"><img src="<%=posterImage%>" alt="<%=dramaTitle%>"></span>
				<em class="date"><%=contentsRegdate%></em>
			</div>
		</div>
		<%'!-- //contents --%>
		<div id="dramalist" v-if="show" v-cloak>
			<div class="section" v-for="(item,index) in sliced" :item="item" :key="item.id" v-if="sliced" >
				<%'스와이퍼 영역%>
				<div class="rolling" v-if="item.videoYN ==0">
					<div class="drama-rolling">
						<div class="swiper-container">
							<div class="swiper-wrapper">
								<image-list v-for="sub in item.dramaimages" :sub="sub"></image-list>
							</div>
						</div>
						<div class="pagination"></div>
						<button type="button" class="slide-nav btn-prev icon">이전</button>
						<button type="button" class="slide-nav btn-next icon">다음</button>
					</div>
				</div>
				<%'비디오 영역%>
				<div class="vod" v-if="item.videoYN == 1"><iframe class="vod-player" :src="item.videourl" frameborder="0" allowfullscreen></iframe></div>

				<div class="desc" v-html="item.contents"></div>
				<ul>
					<item-list v-for="(sub, index) in item.dramaitem" :sub="sub" :idx="index" :isapp="0" :limit="item.dramaitem.length"></item-list>										
				</ul>
			</div>
		</div>
	</div>
<script>
// json - apiurl
var dataurl = "/dramazone/";
var json_data2 = dataurl+"json_data2.asp?dramaidx=<%=dramaidx%>&listidx=<%=listidx%>";
</script>
<script src="/vue/vue.min.js"></script>
<script src="/vue/dramazone.js?v=1.1"></script>
<script>
	$(function(){
		//카카오 SNS 공유
		Kakao.init('c967f6e67b0492478080bcf386390fdd');

		// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
		Kakao.Link.createDefaultButton({
			container: '#kakaoa',
			objectType: 'feed',
			content: {
			title: '[드라마존] - <%=vTitle%>',
			imageUrl: '<%=kakaoshareimage%>',
				link: {
				  mobileWebUrl: '<%=vLink%>',
				  webUrl: '<%=vLink%>'
				}
			},
			buttons: [
				{
				  title: '10x10 바로가기',
				  link: {
					mobileWebUrl: '<%=vLink%>',
					webUrl: '<%=vLink%>'
				  }
				}
			]
		});

		$('.btn-close').click(function(){
			location.href = '/dramazone/';
		});
	});

	var btn = document.getElementById('clipboards');
	var clipboard = new Clipboard(btn);//로드 시 한번 선언

	clipboard.on('success', function(e) {
		alert('URL 주소가 복사되었습니다');
	});
	clipboard.on('error', function(e) {
		alert('fail');
	});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->