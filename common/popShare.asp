<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<%
	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg
	vTitle = requestCheckVar(request("snstitle"),200)
	vLink = requestCheckVar(request("snslink"),200)
	vPre = requestCheckVar(request("snspre"),200)
	vImg = requestCheckVar(request("snsimg"),200)

	'// 단축 URL로 전환(2016.05.12; 허진원)
	if inStr(vLink,"category_itemprd.asp")>0 then		'상품
		if(isNumeric(split(vLink,"itemid=")(ubound(split(vLink,"itemid="))))) then
			vLink = "http://10x10.co.kr/" & split(vLink,"itemid=")(ubound(split(vLink,"itemid=")))
		end if
	end if
	
	dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
	snpTitle = Server.URLEncode(vTitle)
	snpLink = Server.URLEncode(vLink)
	snpPre = Server.URLEncode(vPre)
	snpImg = Server.URLEncode(vImg)

	'기본 태그
	snpTag = Server.URLEncode("텐바이텐 " & Replace(vTitle," ",""))
	snpTag2 = Server.URLEncode("#10x10")

	'//핀터레스트-api 버전
	Dim ptTitle , ptLink , ptImg
	ptTitle = vTitle
	ptLink	= vLink
	ptImg	= vImg
%>
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
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>공유</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div class="shareListup">
					<ul>
						<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;">트위터</a></li>
						<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;">페이스북</a></li>
						<li class="pinterest"><a href="" onclick="sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>'); return false;">핀터레스트</a></li>
						<li class="kakaotalk"><a href="" onClick="return false;" id="kakaoa">카카오톡</a></li>
						<script>
						$(function(){
							//카카오 SNS 공유
							Kakao.init('c967f6e67b0492478080bcf386390fdd');
						
							// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
							Kakao.Link.createTalkLinkButton({
							  //1000자 이상일경우 , 1000자까지만 전송 
							  //메시지에 표시할 라벨
							  container: '#kakaoa',
							  label: '<%=vTitle%>',
							  <% if vImg <>"" then %>
							  image: {
								//500kb 이하 이미지만 표시됨
								src: '<%=vImg%>',
								width: '200',
								height: '200'
							  },
							  <% end if %>
							  webButton: {
								text: '10x10 바로가기',
								url: '<%=vLink%>'
							  }
							});
						});
						</script>
						<li class="line"><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;">라인</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
