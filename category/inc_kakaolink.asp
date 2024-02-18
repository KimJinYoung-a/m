<% response.Charset = "UTF-8" %>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	// 카카오톡 링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
	Kakao.Link.createTalkLinkButton({
	  //1000자 이상일경우 , 1000자까지만 전송 
	  //메시지에 표시할 라벨
	  container: '#kakaoa',
	  label: '[<%=oItem.Prd.FBrandName%>]\n<%= oItem.Prd.FItemName %>\n<% if oItem.Prd.IsSaleItem then %><%= FormatNumber(oItem.Prd.getRealPrice,0) %>원 [<% = oItem.Prd.getSalePro %>]<% elseif oitem.Prd.isCouponItem then %><%= FormatNumber(oItem.Prd.GetCouponAssignPrice,0) %>원 [<%= oItem.Prd.GetCouponDiscountStr %>]<% else %><%= FormatNumber(oItem.Prd.getOrgPrice,0) %><% if oItem.Prd.IsMileShopitem then %>Point<% else %>원<% end if %><% end if %>',
	  image: {
		//500kb 이하 이미지만 표시됨
		src: '<%=oItem.Prd.FImageBasic%>',
		width: '200',
		height: '200'
	  },
	  webButton: {
		text: '10x10 바로가기',
		webUrl : 'http://10x10.co.kr/<%=itemid%>',
		url: 'http://m.10x10.co.kr/category/category_itemprd.asp?itemid=<%=itemid%>'
	  }
	});
</script>