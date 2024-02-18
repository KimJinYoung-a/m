<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/MyCategoryCls.asp" -->
<%
Dim oGrCat, vDisp, vDepth, lp, vErrLocationValue, vErrBackLocationUrl
vDisp =  getNumeric(request("disp"))
vErrLocationValue = getNumeric(request("ErBValue"))

If vDisp <> "" Then vDisp = "" End If

vDepth = (Len(vDisp)/3)


'// history.back()값이 없을 시 원복할 url 주소 셋팅
Select Case vErrLocationValue

	Case "1" '// 카테고리 리스트
		vErrBackLocationUrl = "/category/category_list.asp?disp=101"

	Case "2" '// 위시리스트
		vErrBackLocationUrl = "/wish/wishmainlist.asp"

	Case "3" '// 상품상세
		vErrBackLocationUrl = "/category/category_itemprd.asp?itemid="&vItemID

	Case "4" '// BEST AWARD
		vErrBackLocationUrl = "/award/awardItem.asp"

	Case "5" '// 장바구니
		vErrBackLocationUrl = "/inipay/ShoppingBag.asp"
		
	Case "6" '// SALE
		vErrBackLocationUrl = "/shoppingtoday/shoppingchance_saleitem.asp"
		
	Case "7" '// ENJOY 이벤트
		vErrBackLocationUrl = "/shoppingtoday/shoppingchance_allevent.asp"

	Case "8" '// 브랜드 상세
		vErrBackLocationUrl = "/street/"

	Case "9" '// 위시리스트
		vErrBackLocationUrl = "/wish/index.asp"

End Select


Set oGrCat = new MyCategoryCls
	oGrCat.FDepth = vDepth+1
	oGrCat.FDisp = vDisp
	oGrCat.fnDisplayCategoryList
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 카테고리 선택</title>
<script type="text/javascript">
function jsGoCateSearch(d){
<%
	SELECT Case vErrLocationValue
		Case "4"
%>
		document.frm.cpg.value = "1";
		document.frm.disp.value = d;
		document.frm.action = "/award/awarditem.asp";
		document.frm.submit();
<%
		Case "6"
%>
		document.sFrm.cpg.value = "1";
		document.sFrm.disp.value = d;
		document.sFrm.action = "/shoppingtoday/shoppingchance_saleitem.asp";
		document.sFrm.submit();
<%
		Case "7"
%>
		document.frmSC.iC.value = 1;
		document.frmSC.disp.value = d;
		document.frmSC.action = "/shoppingtoday/shoppingchance_allevent.asp";
		document.frmSC.submit();
<%
		Case "8"
%>
		document.sFrm.cpg.value = 1;
		document.sFrm.disp.value = d;
		document.sFrm.action = "/street/street_brand.asp";
		document.sFrm.submit();
<%
		Case "9"
%>
//		$("#cpg").val("0");
//		$("#catecode").val(d);
//		$("#LstGun").val("CateList");
//		alert($("#LstGun").val());
//		getWishList();
//		fnCloseModal();
		top.location.href='index.asp?LstGun=CateList&catecode='+d;
<%
	End Select
%>
}
</script>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>카테고리</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div class="categoryListup">
					<ul>
					<% If oGrCat.FResultCount>0 Then %>
						<% FOR lp = 0 to oGrCat.FResultCount-1 %>
						<li><a href="" onClick="jsGoCateSearch('<%= oGrCat.FItemList(lp).Fcatecode %>'); return false;"><%= oGrCat.FItemList(lp).Fcatename %> <% if oGrCat.FItemList(lp).fisnew ="o" then %><span class="icoHot">HOT</span><% End If %></a></li>
						<% Next %>
					<% end if %>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<% set oGrCat = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->