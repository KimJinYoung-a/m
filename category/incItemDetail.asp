<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	dim itemid	: itemid = requestCheckVar(request("itemid"),9)

	if itemid="" then
		Call Alert_Return("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_Return("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(itemid)
	end if

	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	'// 추가 이미지
	dim oADD, i
	set oADD = new CatePrdCls
	oADD.getAddImage itemid
	
	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="/lib/js/swiper-1.8.min.js"></script>
<script src="/lib/js/swiper.scrollbar-1.0.js"></script>
<title>10x10: <%= oItem.Prd.FItemName %></title>
<script type="text/javascript">
	$(function(){
		$('#itemContView').find("img").css("width","100%");
		$('#itemContView').find("img").css("height","auto");
	});
</script>
</head>
<body>
<div id="itemContView">
<%
	if inStr(oItem.Prd.FItemContent,"thelivingshop.co.kr")<=0 then		'20130603 크롬 악성코드 크롤러 검색된 URL이 들어가있으면 출력안함
		ItemContent = oItem.Prd.FItemContent
	end if

	'링크는 새창으로
	ItemContent = Replace(ItemContent,"<a ","<a target='_blank' ")
	ItemContent = Replace(ItemContent,"<A ","<A target='_blank' ")
	'높이태그 제거
	ItemContent = Replace(ItemContent,"height","h")
	ItemContent = Replace(ItemContent,"HEIGHT","h")
	'너비태그 제거
	ItemContent = Replace(ItemContent,"width","w")
	ItemContent = Replace(ItemContent,"WIDTH","w")

	IF oItem.Prd.FUsingHTML="Y" THEN
		Response.write ItemContent
	ELSEIF oItem.Prd.FUsingHTML="H" THEN
		Response.write  nl2br(ItemContent)
	ELSE
		Response.write nl2br(stripHTML(ItemContent))
	END IF
%>
<% IF oAdd.FResultCount > 0 THEN %>
	<% FOR i= 0 to oAdd.FResultCount-1  %>
		<%IF oAdd.FADD(i).FAddImageType=1 THEN %>
		<img src="<%= oAdd.FADD(i).FAddimage %>" border="0" style="width:100%; height:auto;" />
		<%End IF %>
	<% NEXT %>
<% END IF %>
<% if ImageExists(oItem.Prd.FImageMain) then %>
<img src="<% = oItem.Prd.FImageMain %>" border="0" style="width:100%; height:auto;" />
<% end if %>
<% if ImageExists(oItem.Prd.FImageMain2) then %>
<img src="<% = oItem.Prd.FImageMain2 %>" border="0" style="width:100%; height:auto;" />
<% end if %>
<% if ImageExists(oItem.Prd.FImageMain3) then %>
<img src="<% = oItem.Prd.FImageMain3 %>" border="0" style="width:100%; height:auto;" />
<% end if %>
</div>
</body>
</html>
<%
	Set oItem = Nothing
	Set oADD = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->