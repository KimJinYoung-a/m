<%
Dim vAppLink, vmLink, vmTitle, vPre, vImg
snpTag2 = Server.URLEncode("#10x10")
vmLink=snpLink
vmTitle=snpTitle
vPre=snpPre
vImg=snpImg

if inStr(lcase(vmLink),"appcom")>0 then
	vAppLink = vmLink
else
	vAppLink = replace(vmLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")
end if

'APP 버전 접수
vAdrVer = mid(uAgent,instr(uAgent,"tenapp")+8,5)
if Not(isNumeric(vAdrVer)) then vAdrVer=1.0

snpTitle = Server.URLEncode(vmTitle)
snpLink = Server.URLEncode(vmLink)
snpPre = Server.URLEncode(vPre)
snpImg = Server.URLEncode(vImg)

'//핀터레스트-api 버전
Dim ptTitle , ptLink , ptImg
ptTitle = vmTitle
ptLink	= vmLink
ptImg	= vImg

'--------------------------------------------------------------------------------------------
'카카오 링크 v2 관련 - 시작
'--------------------------------------------------------------------------------------------
Dim typechk : typechk = False
Dim sharetype : sharetype = "etc"
If InStr(Request.ServerVariables("url"),"/category/") > 0 Then
	typechk = True
	sharetype = "commerce"
End If

'// 카카오 공유용 Ver2
Dim kakaoOrgPrice , kakaoSalePrice , kakaoSalePer
'// 텐바이텐가
If typechk Then '// 카테고리 있을경우만
	IF ((oItem.Prd.FSaleYn="Y") and (oItem.Prd.FOrgPrice-oItem.Prd.FSellCash>0)) or (oItem.Prd.IsSaleItem and oItem.Prd.IsSpecialUserItem) or (oitem.Prd.isCouponItem) Then
		kakaoOrgPrice	= oItem.Prd.getOrgPrice
		kakaoSalePrice	= oItem.Prd.GetCouponAssignPrice
		kakaoSalePer	= ""

		If oItem.Prd.Fitemcoupontype = "1" Then
			'//할인 + %쿠폰
			kakaoSalePer	= CLng((oItem.Prd.FOrgPrice-(oItem.Prd.FSellCash - CLng(oItem.Prd.Fitemcouponvalue*oItem.Prd.FSellCash/100)))/oItem.Prd.FOrgPrice*100)
		ElseIf oItem.Prd.Fitemcoupontype = "2" Then
			'//할인 + 원쿠폰
			kakaoSalePer	= CLng((oItem.Prd.FOrgPrice-(oItem.Prd.FSellCash - oItem.Prd.Fitemcouponvalue))/oItem.Prd.FOrgPrice*100)
		Else
			'//할인 + 무배쿠폰
			kakaoSalePer	= CLng((oItem.Prd.FOrgPrice-oItem.Prd.FSellCash)/oItem.Prd.FOrgPrice*100)
		End If
	Else
		kakaoOrgPrice	= oItem.Prd.getOrgPrice
		kakaoSalePrice	= ""
		kakaoSalePer	= ""
	End If
End If
'--------------------------------------------------------------------------------------------
'카카오 링크 v2 관련 - 끝
'--------------------------------------------------------------------------------------------
%>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" async defer src="https://assets.pinterest.com/js/pinit.js"></script>
<script>
    // datadive 공유용
    const kindInput = document.getElementById('layerKind');
    const itemIdInput = document.getElementById('layerItemId');
    const itemNameInput = document.getElementById('layerItemName');

    const kind = kindInput ? kindInput.value : null;
    const snsShareItemId = itemIdInput ? itemIdInput.value : null;
    const itemName = itemNameInput ? itemNameInput.value : null;

    function close_lySns(){
        $("#lySns .inner").removeClass("lySlideUp").addClass("lySlideDown");
        $("#lySns").show(0).delay(300).hide(0);
    }

    function sharePt(url, imgurl, label){
        // Datadive 전송을 위한 callnative
        fnAPPSharePinterest(snsShareItemId, itemName, kind);

        PinUtils.pinOne({
            'url' : url,
            'media' : imgurl,
            'description' : label
        });
    }

    // URL 복사
    function fnCopyUrlToClipBoard() {
        callNativeFunction('copyurltoclipboard', {
            'url':'<%=vmLink%>',
            'message':'링크가 복사되었습니다. 원하시는 곳에 붙여넣기 하세요.',
            'itemid':snsShareItemId,
            'itemname':itemName,
            'kind':kind
        });
    }
</script>
<%'공유하기 레이어 팝업%>
<div id="lySns" class="ly-sns">
	<div class="inner fixed-bottom">
		<div class="tenten-header header-popup header-white">
			<div class="title-wrap">
				<h2>공유하기</h2>
				<button type="button" class="btn-close" onclick="close_lySns()">닫기</button>
			</div>
		</div>
		<div class="sns-list">
			<ul>
			<% if (TRUE) then %>
				<%'// 2.19 버전부터 native로 전환 - 카카오%>
				<% if (flgDevice="I" and vAdrVer>="2.19") or (flgDevice="A" and vAdrVer>="2.19") then %>
					<li><a href="" onclick="fnAPPshareKakao('<%=sharetype%>','<%=vmTitle%>','<%=vmLink%>','<%=vmLink%>','<%="url="&vAppLink%>','<%=vImg%>','<%=kakaoOrgPrice%>','<%=kakaoSalePrice%>','<%=kakaoSalePer%>','', snsShareItemId, itemName, kind); return false;"><span class="icon icon-kakao">카카오톡으로 공유</span></a></li>
				<% Else %>
					<li><a href="" onclick="return false;" id="kakaoa"><span class="icon icon-kakao">카카오톡으로 공유</span></a></li>
				<% End if%>
				<li><a href="" onclick="fnAPPShareLine('<%=vmTitle%>','<%=vmLink%>', snsShareItemId, itemName, kind); return false;"><span class="icon icon-line">라인으로 공유</span></a></li>
				<%'// iOS : v2.518 / Android : v2.517 부터 가능 - 인스타그램%>
				<% if (flgDevice="I" and vAdrVer>="2.518") or (flgDevice="A" and vAdrVer>="2.517") then %>
					<li><a href="" onclick="fnAPPShareInstagram('<%=vImg%>', snsShareItemId, itemName, kind); return false;"><span class="icon icon-insta">인스타로 공유</span></a></li>
				<% End if%>
				<% if (flgDevice="I" and vAdrVer>="2.17") or (flgDevice="A" and vAdrVer>="2.17") then %>
				<li><a href="" onclick="fnAPPShareSNS('fb','<%=vmLink%>', snsShareItemId, itemName, kind);return false;"><span class="icon icon-facebook">페이스북으로 공유</span></a></li>
				<% Else %>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><span class="icon icon-facebook">페이스북으로 공유</span></a></li>
				<% End If %>
				<li><a href="" onclick="sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>'); return false;"><span class="icon icon-pinterest">핀터레스트로 공유</span></a></li>
				<li><a href="" onclick="fnAPPShareTwitter('<%=vmTitle%>','<%=vmLink%>', snsShareItemId, itemName, kind); return false;"><span class="icon icon-twitter">트위터로 공유</span></a></li>
			<% Else %>
				<li><a href="" onclick="return false;" id="kakaoa"><span class="icon icon-kakao">카카오톡으로 공유</span></a></li>
				<li><a href="" onclick="fnAPPShareLine('<%=vmTitle%>','<%=vmLink%>', snsShareItemId, itemName); return false;"><span class="icon icon-line">라인으로 공유</span></a></li>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><span class="icon icon-facebook">페이스북으로 공유</span></a></li>
				<li><a href="" onclick="sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>'); return false;"><span class="icon icon-pinterest">핀터레스트로 공유</span></a></li>
				<li><a href="" onclick="popSNSPost('tw','<%=vmTitle%>','<%=vmLink%>','<%=vPre%>','<%=snpTag2%>'); return false;"><span class="icon icon-twitter">트위터로 공유</span></a></li>
			<% End If %>

			<% if Not((flgDevice="I" and vAdrVer>="2.19") or (flgDevice="A" and vAdrVer>="2.19")) then %>
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
					  label: '<%=vmTitle%>',
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
						webUrl : '<%=vmLink%>',
						execParams :{
							android : {"url":"<%=Server.URLEncode(vAppLink)%>"},
							iphone : {"url":"<%=vAppLink%>"}
						}
					  }
					  //,
					  //installTalk : true
					});
				</script>
				<% End If %>
				<%
					'// 아이폰 1.981, 안드로이드 1.76 이상부터는 URL Link 복사 기능 추가(2015.11.19; 허진원)
					if (flgDevice="I" and vAdrVer>="1.981") or (flgDevice="A" and vAdrVer>="1.76") then
				%>
				<li class="share-url"><div class="ellipsis"><%=vmLink%></div><button class="btn-url" onclick="fnCopyUrlToClipBoard();">URL 복사</button></li>
				<%
					end if
				%>

			</ul>
		</div>
	</div>
	<div id="mask" onclick="close_lySns()" style="overflow:hidden; display:block; position:fixed; top:0; left:0; z-index:10020; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
</div>