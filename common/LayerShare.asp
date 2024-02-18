<%
Dim snpTag2 , vAppLink
snpTag2 = Server.URLEncode("#10x10")

'//핀터레스트-api 버전
Dim ptTitle , ptLink , ptImg, kkolink
ptTitle = snpTitle
ptLink	= snpLink
ptImg	= snpImg

snpTitle	= Server.URLEncode(snpTitle)
snpLink		= Server.URLEncode(snpLink)
snpPre		= Server.URLEncode(snpPre)
snpTag2 	= Server.URLEncode(snpTag2)

'--------------------------------------------------------------------------------------------
'카카오 링크 v2 관련 - 시작
'--------------------------------------------------------------------------------------------
vAppLink = replace(ptLink,"m.10x10.co.kr/","m.10x10.co.kr/apps/appcom/wish/web2014/")

Dim typechk : typechk = false
If InStr(Request.ServerVariables("url"),"/category/") > 0 Then
	typechk = True
End If

If typechk then
	'// 카카오 공유 상품 상세 일경우만 필요함
	Dim kakaoOrgPrice , kakaoSalePrice , kakaoSalePer
	'// 텐바이텐가
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
		kakaoSalePrice	= 0
		kakaoSalePer	= 0
	End If
End If
'--------------------------------------------------------------------------------------------
'카카오 링크 v2 관련 - 끝
'--------------------------------------------------------------------------------------------
%>
<script type="text/javascript" async defer src="//assets.pinterest.com/js/pinit.js"></script>
<script>
$(function(){
	$("#lySns .btn-close, #mask").on("click", function(e){
		$("#lySns .inner").removeClass("lySlideUp");
		$("#lySns").show(0).delay(300).hide(0);
		$("body").removeClass("not-scroll");
	});
});
function sharePt(url,imgurl,label){
	PinUtils.pinOne({
		'url' : url,
		'media' : imgurl,
		'description' : label
	});
}
// 쇼셜네트워크로 글보내기 모달팝업
function popSNSShareNew() {
	$("#lySns").show();
	$("#lySns .inner").removeClass("lySlideDown").addClass("lySlideUp");
	$("body").addClass("not-scroll");
	$(document).scrollTop($(document).height());
	return false;
	//fnOpenModal('/common/popShare.asp?snstitle='+encodeURIComponent(tit)+'&snslink='+encodeURIComponent(link)+'&snspre='+encodeURIComponent(pre)+'&snsimg='+encodeURIComponent(img));
}
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.7.1/clipboard.min.js"></script>
<script>
$(function(){   
    // 복사하기
    var clipboard = new Clipboard('#urlcopy');
    clipboard.on('success', function(e) {
		alert('URL이 복사 되었습니다.');
        console.log(e);
    });
    clipboard.on('error', function(e) {
        console.log(e);
    });
})
</script>
<%'공유하기 레이어 팝업%>
<div id="lySns" class="ly-sns">
	<div class="inner fixed-bottom">
		<div class="tenten-header header-popup header-white">
			<div class="title-wrap">
				<h2>공유하기</h2>
				<button type="button" class="btn-close">닫기</button>
			</div>
		</div>
		<div class="sns-list">
			<ul>
				<li><a href="" onClick="return false;" id="urlcopy" data-clipboard-text="<%=ptLink%>"><span class="icon icon-url">url복사</span></a></li>
				<li><a href="" onClick="return false;" id="kakaoa"><span class="icon icon-kakao">카카오톡으로 공유</span></a></li>
				<script>
				//<![CDATA[
					// // 사용할 앱의 JavaScript 키를 설정해 주세요.
					Kakao.init('c967f6e67b0492478080bcf386390fdd');
					// // 카카오링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다. - v2
					Kakao.Link.createDefaultButton({
					  container: '#kakaoa',
					  <% if typechk then %>
					  objectType: 'commerce',
					  <% else %>
					  objectType: 'feed',
					  <% end if %>
					  content: {
						title: '<%=ptTitle%>',
						imageUrl: '<%=ptImg%>',
						link: {
						  mobileWebUrl: '<%=replace(ptLink,"http://10x10.co.kr","http://10x10.co.kr")%>',
						  webUrl: '<%=replace(ptLink,"http://10x10.co.kr","http://www.10x10.co.kr")%>'
						}
					  },
					  <% if typechk then %>
					  commerce: {
						  <% if kakaoSalePrice > 0 then %>
						  regularPrice : <%=kakaoOrgPrice%>,
						  discountPrice : <%=kakaoSalePrice%>,
						  discountRate : <%=kakaoSalePer%>
						  <% else %>
						  regularPrice : <%=kakaoOrgPrice%>
						  <% end if %>
					  },
					  buttons: [
						{
						  title: '구매하기',
						  link: {
							webUrl: '<%=replace(ptLink,"http://10x10.co.kr","http://www.10x10.co.kr")%>',
							mobileWebUrl: '<%=replace(ptLink,"http://10x10.co.kr","http://10x10.co.kr")%>'
						  }
						}
					  ]
					  <% else %>
					  buttons: [
						{
						  title: '10x10 바로가기',
						  link: {
							webUrl: '<%=replace(ptLink,"http://10x10.co.kr","http://www.10x10.co.kr")%>',
							mobileWebUrl: '<%=replace(ptLink,"http://10x10.co.kr","http://10x10.co.kr")%>'
						  }
						}
					  ]
					  <% end if %>
					});
				//]]>
				</script>
				<li><a href="" onclick="popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><span class="icon icon-line">라인으로 공유</span></a></li>
				<li><a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','',''); return false;"><span class="icon icon-facebook">페이스북으로 공유</span></a></li>
				<li><a href="" onclick="sharePt('<%=ptLink%>','<%=ptImg%>','<%=ptTitle%>'); return false;"><span class="icon icon-pinterest">핀터레스트로 공유</span></a></li>
				<li><a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>'); return false;"><span class="icon icon-twitter">트위터로 공유</span></a></li>				
			</ul>
		</div>
	</div>
	<div id="mask" style="overflow:hidden; display:block; position:fixed; top:0; left:0; z-index:10020; width:100%; height:100%; background:rgba(0, 0, 0, 0.5);"></div>
</div>