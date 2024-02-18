<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세정보 보기
'	History	:  2014.06.12 허진원 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
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
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, minimum-scale=1.0, maximum-scale=2.0, width=device-width">
<meta name="format-detection" content="telephone=no" />
<title>10X10: <%= oItem.Prd.FItemName %></title>
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/default.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/common.css">
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/content.css">
<% if flgDevice="I" then %><link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/css/ios.css?v=1.1"><% end if %>
<script type="text/javascript" src="/lib/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/lib/js/common.js"></script>
<script type="text/javascript">
$(function(){
	$('#itemContView').find("img").css("width","100%");
	$('#itemContView').find("table").css("width","100%"); //2016/02/11
});
</script>
<style>
.detailViewArea img:nth-child(2) {margin-top:0.5rem;}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<div class="detailViewArea" id="itemContView" style="background-color:#FFFFFF">
			<%
				ItemContent = oItem.Prd.FItemContent

				'링크는 새창으로
				ItemContent = Replace(ItemContent,"<a ","<a target='_blank' ")
				ItemContent = Replace(ItemContent,"<A ","<A target='_blank' ")
				'높이태그 제거
				ItemContent = Replace(ItemContent,"height=","h=")
				ItemContent = Replace(ItemContent,"HEIGHT=","h=")
				'너비태그 제거
				ItemContent = Replace(ItemContent,"width=","w=")
				ItemContent = Replace(ItemContent,"WIDTH=","w=")

				IF oItem.Prd.FUsingHTML="Y" THEN
					Response.write ItemContent
				ELSEIF oItem.Prd.FUsingHTML="H" THEN
					Response.write nl2br(ItemContent)
				ELSE
					Response.write "<div style=""padding:2rem; font-size:1.4rem;"">"
					Response.write nl2br(stripHTML(ItemContent))
					Response.write "</div>"
				END IF
			%>
			<% IF oAdd.FResultCount > 0 THEN %>
				<% FOR i= 0 to oAdd.FResultCount-1  %>
					<%IF oAdd.FADD(i).FAddImageType=1 AND oAdd.FADD(i).FIsExistAddimg THEN %>
					<img src="<%= oAdd.FADD(i).FAddimage %>" border="0" style="width:100%;" />
					<%End IF %>
				<% NEXT %>
			<% END IF %>
			<% if ImageExists(oItem.Prd.FImageMain) then %>
			<img src="<% = oItem.Prd.FImageMain %>" border="0" style="width:100%;" />
			<% end if %>
			<% if ImageExists(oItem.Prd.FImageMain2) then %>
			<img src="<% = oItem.Prd.FImageMain2 %>" border="0" style="width:100%;" />
			<% end if %>
			<% if ImageExists(oItem.Prd.FImageMain3) then %>
			<img src="<% = oItem.Prd.FImageMain3 %>" border="0" style="width:100%;" />
			<% end if %>
			</div>
			<span id="gotop" class="goTop">TOP</span>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<%
	Set oItem = Nothing
	Set oADD = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->