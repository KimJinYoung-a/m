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

	Dim contentsText : contentsText = db2html(arrList(3,jcnt))
	Dim dramaTitle : dramaTitle = db2html(arrList(2,0))
	Dim thumbImage	: thumbImage = staticImgUrl & "/mobile/drama" & arrList(4,0)
	Dim posterImage	: posterImage = staticImgUrl & "/mobile/drama" & arrList(11,jcnt)
	Dim contentsRegdate : contentsRegdate = formatDate(arrList(12,jcnt),"0000.00.00")
	Dim kakaoshareimage : kakaoshareimage = staticImgUrl & "/mobile/drama" & arrList(13,jcnt)

	Dim vTitle, vLink, vImg
	vTitle = "[드라마존] " &dramaTitle
	vLink = "http://m.10x10.co.kr/dramazone/share.asp?dramaidx="& dramaidx &"&listidx="& listidx
	vImg = thumbImage

	vTitle = nl2br(vTitle)
	vTitle = Replace(vTitle,"<br />"," ")

	dim snpTitle, snpLink
	snpTitle = Server.URLEncode(vTitle)
	snpLink = Server.URLEncode(vLink)

	Dim vAppLink
	if inStr(lcase(vLink),"appcom")>0 then
		vAppLink = vLink
	else
		vAppLink = replace(vLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")
	end if

'--------------------------------------------------------------------------------------------
'카카오 링크 v2 관련 - 시작
'--------------------------------------------------------------------------------------------
Dim typechk : typechk = False
Dim sharetype : sharetype = "etc"
If InStr(Request.ServerVariables("url"),"/category/") > 0 Then
	typechk = True
	sharetype = "commerce"
End If
'--------------------------------------------------------------------------------------------
'카카오 링크 v2 관련 - 끝
'--------------------------------------------------------------------------------------------

%>
<!-- #include virtual="/apps/appcom/wish/web2014/lib/head.asp" -->
<style>
[v-cloak] { display: none; }
</style>
<script type="text/javascript">
$(function() {
	setTimeout(function(){fnAmplitudeEventMultiPropertiesAction("view_dramazoneshare","idx|dramaidx","<%=listidx%>|<%=dramaidx%>","");}, 100);
});
</script>
</head>
<body class="default-font body-popup sbsDrama">
	<div id="content" class="content sbs-share">
		<%'!-- share --%>
		<div class="share bg-blue">
			<h2><span class="multi-ellipsis"><%=dramaTitle%></span></h2>
			<ul class="sns-list">
				<li><a href="" onclick="fnAmplitudeEventAction('click_dramazoneshare','action','facebook',function(bool){if(bool) {popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');}}); return false;"><span class="icon icon-facebook">페이스북 공유</span></a></li>
				<li><a href="" onclick="fnAmplitudeEventAction('click_dramazoneshare','action','kakao',function(bool){if(bool) { fnAPPshareKakao('<%=sharetype%>','<%=vTitle%>','<%=vLink%>','<%=vLink%>','<%="url="&Server.URLEncode(vAppLink)%>','<%=kakaoshareimage%>','','','',''); }});return false;"><span class="icon icon-kakao"></span></a></li>
				<li><a href="" onclick="fnAmplitudeEventAction('click_dramazoneshare','action','kakao',function(bool){if(bool) { callNativeFunction('copyurltoclipboard', {'url':'<%=vLink%>','message':'링크가 복사되었습니다. 원하시는 곳에 붙여넣기 하세요.'}); }}); return false;"><span class="icon icon-url">링크 공유</span></a></li>
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
								<image-list v-for="sub in item.dramaimages" :sub="sub" :isapp="1"></image-list>
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
					<item-list v-for="(sub, index) in item.dramaitem" :sub="sub" :idx="index" :isapp="1" :limit="item.dramaitem.length"></item-list>										
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
<script src="/vue/dramazone.js?v=1.2"></script>
<script>
$(function(){
	fnAPPchangPopCaption('드라마존');
});
</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->