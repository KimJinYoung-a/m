<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 위시폴더</title>
<%
Dim vItemID, vErrLocationValue, vErrBackLocationUrl, vWUserId, vAction, bagarray, fidx, vGubun, vEcode
vItemID = getNumeric(request("itemid"))
vErrLocationValue = getNumeric(request("ErBValue"))
vWUserId = requestCheckvar(request("vWUserId"), 32) '// 위시 프로필에서 넘어올땐 해당 유저 아이디 값이 필요함
vAction = requestCheckvar(request("folderAction"), 32)
bagarray = requestCheckvar(request("bagarray"), 1024)
fidx		= requestCheckvar(request("mffIdx"),9)
vGubun	= requestCheckvar(request("gb"),15)
vEcode = requestCheckvar(request("ecode"),15)

If fidx="" Then
	fidx="0"
End If

'// 특정상품 Wish불가
if vItemID="1212183" or vItemID="1404138" or vItemID="1404911" then
	Alert_return("Wish에 담을 수 없는 상품입니다.")
	dbget.Close :response.end
end if
if inStr(bagarray,"1212183")>0 or inStr(bagarray,"1404138")>0 or inStr(bagarray,"1404911")>0 then
	Alert_return("Wish에 담을 수 없는 상품이 포함되어 있습니다.")
	dbget.Close :response.end
end if

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
		
	Case "6" '// 세일
		vErrBackLocationUrl = "/shoppingtoday/shoppingchance_saleitem.asp"
		
	Case "7" '// ENJOY 이벤트
		vErrBackLocationUrl = "/shoppingtoday/shoppingchance_allevent.asp"

	Case "8" '// 위시 프로필
		vErrBackLocationUrl = "/my10x10/myWish/myWish.asp?ucid="&Server.UrlEncode(tenEnc(vWUserId))
		
	Case "9" '// 우수회원샵
		vErrBackLocationUrl = "/my10x10/special_shop.asp"

	Case "10" '// 이벤트 상세
		vErrBackLocationUrl = "/event/eventmain.asp?eventid="&vEcode

	Case "11" '// MDpick
		vErrBackLocationUrl = "/mdpicklist/"

	Case "12" '// gnbevent
		vErrBackLocationUrl = "/subgnb/gnbeventmain.asp?eventid="&vEcode

	Case "13" '// NEW
		vErrBackLocationUrl = "/shoppingtoday/shoppingchance_newitem.asp"

	Case "14" '// clearancesale
		vErrBackLocationUrl = "/clearancesale/"

End Select


If Trim(vAction)="" Then
	vAction = "add"
End If


'If vItemID = "" Then
'	Response.Write "<script>잘못된 경로입니다.</script>"
'	dbget.close()
'	Response.End
'End If
%>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script>
$(function(){
	<% if vErrLocationValue="8" then %>
		goWishFolderListPop()
	<% else %>
		goWishListPop();
	<% end if %>

});

function goWishListPop(){
	$.ajax({
			url: "popWishFolder_listajax.asp?itemid=<%=vItemID%>&mode=<%=vAction%>&bagarray=<%=Server.Urlencode(bagarray)%>&fidx=<%=fidx%>",
			cache: false,
			success: function(message)
			{
				$("#wishfolderdiv").empty().append(message);
				$("#tit").text("위시담기");
			}
	});
}

function goWishFolderListPop(){
	$.ajax({
			url: "popWishFolder_folderlistajax.asp?itemid=<%=vItemID%>&ErBValue=<%=vErrLocationValue%>",
			cache: false,
			success: function(message)
			{
				$("#wishfolderdiv").empty().append(message);
				$("#tit").text("위시폴더관리");
			}
	});
}

//sorting
function goWishFolderSortingPop(){
	$.ajax({
			url: "popWishFolder_sortingajax.asp?itemid=<%=vItemID%>&ErBValue=<%=vErrLocationValue%>",
			cache: false,
			success: function(message)
			{
				$("#wishfolderdiv").empty().append(message);
				$("#tit").text("위시폴더관리");
			}
	});
}

function jsCloseThis(){
	<% If vGubun = "search2017" Then %>
	opener.jsAfterWishBtn('<%=vItemID%>');
	window.close();
	<% Else %>
		var sRef
		sRef = document.referrer;
		location.replace(sRef);
		//goBack('<%=wwwUrl%>/category/category_list.asp?disp=101');
		return false;
	<% End If %>
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="header">
			<h1 id="tit"><%=chkiif(vErrBackLocationUrl = "8","위시폴더관리","위시담기")%></h1>
			<% If vErrBackLocationUrl = "8" Then %>
				<p class="btnPopClose"><button class="pButton" onclick="top.location.href'<%=wwwUrl&vErrBackLocationUrl%>'; return false;">닫기</button></p>
			<% Else %>
				<% If vGubun = "search2017" Then %>
				<p class="btnPopClose"><button class="pButton" onclick="window.close(); return false;">닫기</button></p>
				<% Else %>
				<p class="btnPopClose"><button class="pButton" onclick="goBack('<%=wwwUrl&vErrBackLocationUrl%>'); return false;">닫기</button></p>
				<% End If %>
			<% End If %>
		</div>
		<!-- content area -->

		<div id="wishfolderdiv"></div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->