<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
	Dim vTitle, vLink, vPre, vImg, vAppLink
	vTitle = requestCheckVar(request("sTit"),200)
	vLink = requestCheckVar(request("sLnk"),200)
	vPre = requestCheckVar(request("sPre"),200)
	vImg = requestCheckVar(request("sImg"),200)

	if inStr(lcase(vLink),"appcom")>0 then
		vAppLink = vLink
	else
		vAppLink = replace(vLink,"www.10x10.co.kr/","m.10x10.co.kr/")
		vAppLink = replace(vAppLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")
	end if

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

	'APP 버전 접수
	vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
	if Not(isNumeric(vAdrVer)) then vAdrVer=1.0

	'//핀터레스트-api 버전
	Dim ptTitle , ptLink , ptImg
	ptTitle = vTitle
	ptLink	= vLink
	ptImg	= vImg
%>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" async defer src="https://assets.pinterest.com/js/pinit.js"></script>
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
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="shareListup">
				<ul>
				    <% if (TRUE) then %>
    					<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;">트위터</a></li>
						<% if (flgDevice="I" and vAdrVer>="2.17") or (flgDevice="A" and vAdrVer>="2.17") then %>
						<li class="facebook"><a href="" onclick="fnAPPShareSNS('fb','<%=vLink%>');return false;">페이스북</a></li>
						<% Else %>
						<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;">페이스북</a></li>
						<% End If %>
    					<li class="pinterest"><a href="" onclick="sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>'); return false;">핀터레스트</a></li>
    					<li class="kakaotalk"><a href="" onClick="return false;" id="kakaoa">카카오톡</a></li>
				    <% else %>
					<li class="twitter"><a href="" onclick="popSNSPost('tw','<%=vTitle%>','<%=vLink%>','<%=vPre%>','<%=snpTag2%>'); return false;">트위터</a></li>
					<li class="facebook"><a href="" onclick="popSNSPost('fb','<%=vTitle%>','<%=vLink%>','',''); return false;">페이스북</a></li>
					<li class="pinterest"><a href="" onclick="sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>'); return false;">핀터레스트</a></li>
					<li class="kakaotalk"><a href="" onClick="return false;" id="kakaoa">카카오톡</a></li>
				    <% end if %>
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
						  label: '<%=vTitle%>',
						  <% if vImg <>"" then %>
						  image: {
							//500kb 이하 이미지만 표시됨
							src: '<%=vImg%>',
							width: '200',
							height: '200'
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
						  //,
						  //installTalk : true
						});
					</script>
					<li class="line"><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;">라인</a></li>
				<%
					'// 아이폰 1.981, 안드로이드 1.76 이상부터는 URL Link 복사 기능 추가(2015.11.19; 허진원)
					if (flgDevice="I" and vAdrVer>="1.981") or (flgDevice="A" and vAdrVer>="1.76") then
				%>
					<li class="url"><a href="" onclick="callNativeFunction('copyurltoclipboard', {'url':'<%=vLink%>','message':'링크가 복사되었습니다. 원하시는 곳에 붙여넣기 하세요.'}); return false;">URL복사</a></li>
				<%
					end if
				%>
				</ul>
			</div>
		</div>
		<iframe src="" name="lnshare" id="lnshare" frameborder="0" width="0" height="0"></iframe>
		<!-- // content area -->
	</div>
</div>
</body>
</html>