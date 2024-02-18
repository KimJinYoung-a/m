<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
'####################################################
' Description :  피스 SHARE
' History : 2017-09-21 이종화
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/piece/piececls.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/head.asp" -->
<%
	Dim cPs
	Dim idx : idx = getNumeric(requestCheckVar(request("idx"),5))

	If idx <> "" And isNumeric(idx) Then
		Call fnShareCountUpdate(idx) '//공유카운트 업데이트
	End If 

	SET cPs = New Cgetpiece
	cPs.FRectIdx = idx
	cPs.getPieceview()

	If cPs.FResultCount = 0 Then
		Response.write "<script>alert('삭제된 조각 입니다.');fnAPPclosePopup();</script>"
	End If 
	
'	Dim strOGMeta
'	
'	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""[텐바이텐] Piece - "& cPs.FOnePiece.Fshorttext &""">" & vbCrLf
'	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
'	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/piece/share_result.asp?idx="& cPs.FOnePiece.Fidx &" "" />" & vbCrLf
'	strOGMeta = strOGMeta & "<meta property=""og:image"" content="""& cPs.FOnePiece.Flistimg &""">" & vbCrLf
'	strOGMeta = strOGMeta & "<meta property=""og:description"" content=""[텐바이텐] Piece - "& cPs.FOnePiece.Flisttext  &""">" & vbCrLf

	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg , vAppLink
	vTitle = cPs.FOnePiece.Fshorttext
	vLink = "http://m.10x10.co.kr/piece/share_result.asp?idx="& cPs.FOnePiece.Fidx &""
	vPre = "[텐바이텐] 조각 - "& cPs.FOnePiece.Fshorttext &""
	vImg = cPs.FOnePiece.Flistimg

	vTitle = nl2br(vTitle)
	vTitle = Replace(vTitle,"<br />"," ")

	if inStr(lcase(vLink),"appcom")>0 then
		vAppLink = vLink
	else
		vAppLink = replace(vLink,"www.10x10.co.kr/","m.10x10.co.kr/")
		vAppLink = replace(vAppLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/") '나중에
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

	'APP 버전 접수
	vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	if Not(isNumeric(vAdrVer)) then vAdrVer=1.0

%>
<script src="https://cdn.jsdelivr.net/clipboard.js/1.5.3/clipboard.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script type="text/javascript">
function sharePt(url,imgurl,label){
	PinUtils.pinOne({
		'url' : url,
		'media' : imgurl,
		'description' : label
	});
}

$(function(){
	/* add message */
	$(".btn-add").on("click", function(e){
		$(this).remove();
		$(".piece-share-form .textfield").delay(0).animate({"margin-bottom":"0", "opacity":"1"},500);
		$(".piece-share").addClass("piece-share-msg");
		$(".piece-share .desc").addClass("slideUp");
	});

	var clipboard = new Clipboard('#clipboard');//로드 시 한번 선언 
	clipboard.on('success', function(e) {
        alert('URL 주소가 복사되었습니다');
	});
});
</script>
</head>
<body class="default-font body-popup bg-black piece">

	<%'!-- contents --%>
	<div id="content" class="content">
		<div class="piece-share">
			<section class="a-piece">
				<div class="topic">
					<div class="thumbnail"><span class="inner"><img src="<%=cPs.FOnePiece.Flistimg%>" alt="<%=cPs.FOnePiece.Fshorttext%>" /></span></div>
					<div class="desc">
						<h2 class="headline"><%=nl2br(cPs.FOnePiece.Fshorttext)%></h2>
						<div class="writer"><span class="iam"><%=cPs.FOnePiece.Foccupation%>.</span> <span class="nickname"><%=cPs.FOnePiece.Fnickname%>의 조각</span></div>
					</div>
				</div>
			</section>
			
			<div class="piece-share-form">
				<!-- for dev msg : 2017.10.10 오픈 Lite 버전에서는 개발 제외. 
				스크립트 /* add message */ 부분은 Full 버전에서 추가해주세요 -->
<!-- 				<div class="write-piece"> -->
<!-- 					<button type="button" class="btn-add"><span class="icon icon-plus icon-plus-white"></span>메시지 추가하기</button> -->

<!-- 					<form action=""> -->
<!-- 						<%'!-- for dev msg : 한글기준 최대 400글자까지 입력 --%> -->
<!-- 						<div class="textfield"> -->
<!-- 							<textarea cols="60" rows="5" title="메시지 입력" placeholder="메세지를 입력해주세요."></textarea> -->
<!-- 						</div> -->
<!-- 					</form> -->
<!-- 				</div> -->

				<div class="sns-list">
					<p>보내실 방법을 선택해주세요</p>
					<ul>
						<% if (flgDevice="I" and vAdrVer>="2.17") or (flgDevice="A" and vAdrVer>="2.17") then %>
						<li><a href="" onclick="fnAPPShareSNS('fb','<%=vLink%>');return false;"><span class="icon icon-facebook"></span>페이스북으로 공유하기</a></li>
						<% Else %>
						<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><span class="icon icon-facebook"></span>페이스북으로 공유하기</a></li>
						<% End if%>
						<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"><span class="icon icon-twitter"></span>트위터으로 공유하기</a></li>
						<% if (flgDevice="I" and vAdrVer>="2.19") or (flgDevice="A" and vAdrVer>="2.19") then %>
							<li><a href="" onclick="fnAPPshareKakao('feed','<%="[PIECE] 조각 - "&vTitle%>','<%=vLink%>','<%=vLink%>','<%="url="&vAppLink%>','<%=vImg%>','','','',''); return false;"><span class="icon icon-kakao"></span>카카오톡으로 공유하기</a></li>
						<% Else %>
							<li><a href="" onclick="return false;" id="kakaoa"><span class="icon icon-kakao"></span>카카오톡으로 공유하기</a></li>
						<% End if%>
						<script>
							//카카오 SNS 공유
						<%
							'// 아이폰 1.998, 안드로이드 1.92 이상부터는 카카오링크 APPID 변경 (2017.07.12; 허진원)
							if (flgDevice="I" and vAdrVer>="1.998") or (flgDevice="A" and vAdrVer>="1.92") then
						%>
								Kakao.init('b4e7e01a2ade8ecedc5c6944941ffbd4');
						<%	else %>
								Kakao.init('c967f6e67b0492478080bcf386390fdd');
						<%	end if %>
						
							// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
							Kakao.Link.createTalkLinkButton({
							  //1000자 이상일경우 , 1000자까지만 전송 
							  //메시지에 표시할 라벨
							  container: '#kakaoa',
							  label: '[PIECE] 조각 - <%=vTitle%>',
							  <% if vImg <>"" then %>
							  image: {
								//500kb 이하 이미지만 표시됨
								src: '<%=vImg%>',
								width: '242',
								height: '306.5'
							  },
							  <% end if %>
							  appButton: {
								text: '10x10 바로가기',
								webUrl : '<%=vLink%>',
								execParams :{
									android : {"url":"<%=Server.URLEncode(vAppLink)%>"},
									iphone : {"url":"<%=vAppLink%>"}
								}
							  }
							});
						</script>
						<li><a href="" onclick="sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>'); return false;"><span class="icon icon-pinterest"></span>핀터레스트으로 공유하기</a></li>
						<%
							'// 아이폰 1.981, 안드로이드 1.76 이상부터는 URL Link 복사 기능 추가(2015.11.19; 허진원)
							if (flgDevice="I" and vAdrVer>="1.981") or (flgDevice="A" and vAdrVer>="1.76") then
						%>
						<li><a href="" class="icon icon-url" onclick="callNativeFunction('copyurltoclipboard', {'url':'<%=vLink%>','message':'링크가 복사되었습니다. 원하시는 곳에 붙여넣기 하세요.'}); return false;">URL로 공유하기</a></li>
						<%
							end if
						%>
					</ul>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
<%
	Set cPs = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->