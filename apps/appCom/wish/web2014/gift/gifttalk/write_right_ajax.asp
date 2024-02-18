<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'###########################################################
' Description :  기프트
' History : 2015.02.10 유태욱 리뉴얼 - 모바일
'			2015.03.04 한용민 오늘본상품 아작스 호출 처리
'###########################################################
%>
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/gift/Underconstruction_gift.asp" -->
<%
Dim vTab, vFolderID, vTalkIdx, vKeyword, vSort, vIsSearch, vCount, vIsMine, vStoryItem, vListName, vItemID, userid
Dim vSearchText, vDisp, vPage, vOrderType, ix, vPrice, vSale, i, iLp
	userid		= getEncLoginUserID
	vTab 		= requestCheckVar(Request("tab"),1)
	vFolderID 	= requestCheckvar(request("fidx"),9)
	vPage		= requestCheckVar(request("page"),3)
	vOrderType	= requestCheckVar(request("OrderType"),10)
	vSearchText	= requestCheckVar(request("searchtxt"),100) '현재 입력된 검색어
	vDisp		= getNumeric(requestCheckVar(request("dispCate"),18))

If vFolderID = "" Then vFolderID = "0" End If
If vTab = "" Then vTab = "1" End IF
If vPage = "" Then vPage = "1" End IF

vSearchText = RepWord(vSearchText,"[^가-힣a-zA-Z0-9.&%\-\s]","")

Dim arrList, intLoop, cTalkItem
If vTab = "2" Then '나의위시
	set cTalkItem = new CMyFavorite
	cTalkItem.FRectUserID = getEncLoginUserID
	arrList = cTalkItem.fnGetFolderList

	cTalkItem.FPageSize        = 15
	cTalkItem.FCurrpage        = vPage
	cTalkItem.FScrollCount     = 4
	cTalkItem.FRectOrderType   = vOrderType
	cTalkItem.FRectSortMethod  = ""
	cTalkItem.FRectDisp		= ""
	'cTalkItem.FRectSellScope	= ""
	cTalkItem.FFolderIdx		= vFolderID
	cTalkItem.FExB2BItemYn 		= "Y"
	cTalkItem.getMyWishList
ElseIf vTab = "1" Then '상품검색
	set cTalkItem = new SearchItemCls
	cTalkItem.FRectSearchTxt = vSearchText
	cTalkItem.FRectSortMethod	= fnSortMatching(vOrderType)
	cTalkItem.FRectSearchItemDiv = "y"	'### 카테고리 값있을때 y 없을때 n
	cTalkItem.FRectSearchCateDep = "T"
	cTalkItem.FRectCateCode	= vDisp
	cTalkItem.FCurrPage = vPage
	cTalkItem.FPageSize = 15
	cTalkItem.FScrollCount = 4
	cTalkItem.FListDiv = "search"
	cTalkItem.FLogsAccept = false
	cTalkItem.FAddLogRemove = true			'추가로그 기록안함
	cTalkItem.FSellScope = "Y"		'품절제외 여부 (Y:판매상품만, N:일시품절 이상)
	if (vSearchText<>"") then
	cTalkItem.getSearchList
    end if
End If

%>
<script type="text/javascript">
<!-- #include file="./inc_Javascript.asp" -->

$(function(){
	<%
	'//상품검색일경우
	if vTab = "1" then
	%>
		<%
		'//상품검색전이거나 상품이 없을경우
		if cTalkItem.FResultCount < 1 then
		%>
			setTimeout("fnAPPgetRecentlyViewedProducts();",500);
		<% end if %>
	<% end if %>
});

function jsTalkRightListPaging(a){
	$.ajax({
			<% If vTab = "2" Then %>
				url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab=2&fidx=<%=vFolderID%>&OrderType=<%=vOrderType%>&page="+a+"",
			<% ElseIf vTab = "1" Then %>
				url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType=<%=vOrderType%>&searchtxt="+$("#searchtxt").val()+"&page="+a+"&dispCate=<%=vDisp%>",
			<% End If %>
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
}

function jsTalkRightListWish(a){
	$.ajax({
			url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab=<%=vTab%>&fidx="+a+"&OrderType=<%=vOrderType%>",
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
}

function jsTalkRightListSorting(a){
	$.ajax({
			<% If vTab = "2" Then %>
			url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab=2&fidx=<%=vFolderID%>&OrderType="+a+"",
			<% ElseIf vTab = "1" Then %>
			url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType="+a+"&searchtxt="+$("#searchtxt").val()+"&dispCate=<%=vDisp%>",
			<% End If %>
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
}

function jsTalkRightSearch(){
	var sTxt = $("#searchtxt");
	if(sTxt.val() == "상품코드 또는 검색어 입력" || sTxt.val() == ""){
		sTxt.val("");
		alert("상품코드 또는 검색어를 입력해주세요.");
		sTxt.focus();
		return;
	}else{
		$.ajax({
				url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType=<%=vOrderType%>&searchtxt="+sTxt.val()+"",
				cache: false,
				success: function(message)
				{
					$("#contentArea2").empty().append(message);
				}
		});
	}
}

function jsTalkRightCateSearch(c){
	var sTxt = $("#searchtxt");
	if(sTxt.val() == "상품코드 또는 검색어 입력" || sTxt.val() == ""){
		sTxt.val("");
		alert("상품코드 또는 검색어를 입력해주세요.");
		sTxt.focus();
		return;
	}else{
		$.ajax({
				url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType=<%=vOrderType%>&searchtxt="+sTxt.val()+"&dispCate="+c+"",
				cache: false,
				success: function(message)
				{
					$("#contentArea2").empty().append(message);
				}
		});
	}
}

//기프트톡 빠른 상품찾기 팝업(최근본상품 가져오기)
function getRecentlyViewedProductsApp(products){
	var str = $.ajax({
			type: "POST",
	        url: "/apps/appCom/wish/web2014/gift/gifttalk/write_right_todayitem_ajax.asp",
	        data: "itemarr="+products.join(','),
	        dataType: "text",
	        async: false
	}).responseText;

	if(str!="") {
		$('#todayitem').empty().html(str);
    }
}

</script>

<div class="layerPopup" id="contentArea2" style="overflow-y:auto;">
	<div class="popWin">
	<form name="itemSearch" method="get" style="margin:0px;" onSubmit="return false;">
	<input type="hidden" name="tab" value="<%=vTab%>">
	<input type="hidden" name="fidx" value="<%=vFolderID%>">
	<input type="hidden" name="dispCate" value="<%=vDisp%>">
	<input type="hidden" name="page" value="">
		<div class="content default-font" id="contentArea">
			<div id="contview" class="giftAdd">
				<div class="tab02">
					<ul class="tabNav tNum2 noMove">
						<li <%=CHKIIF(vTab="1","class=current","")%>><a href="" onClick="jsTalkRightListTabChange('1'); return false;">상품 검색</a></li>
						<li <%=CHKIIF(vTab="2","class=current","")%>><a href="" onClick="jsTalkRightListTabChange('2'); return false;">나의 위시</a></li>
					</ul>
				</div>
				<div class="tabcontainer">
				<% if vTab = "1" then %>
					<!-- 상품 검색 -->
					<div id="searchProduct" class="findItem tabcont" style="display:<%=CHKIIF(vTab="1","block","none")%>;">
						<h2 class="hidden">상품 검색</h2>
						<div id="finder" class="finder">
								<fieldset>
								<legend>상품 검색</legend>
									<div class="itext">
										<input type="search" name="searchtxt" id="searchtxt" onKeyPress="if(window.event.keyCode==13){ jsTalkRightSearch(); return false;}" onFocus="jsTalkRightSearchInput(); return false;" class="hdschInput" value="<% If vSearchText = "" Then %>상품코드 또는 검색어 입력<% Else Response.Write vSearchText End If %>" title="상품코드 또는 검색어를 입력해주세요." />
										<button type="button" class="reset">검색어 초기화</button>
									</div>
									<input type="submit" onClick="jsTalkRightSearch(); return false;" value="검색" />
								</fieldset>
						</div>
						<% If (cTalkItem.FResultCount < 1) Then %>
							<% ' <!-- for dev msg : 검색 전 최근 본 상품--> %>
							<div class="pdtListWrap" id="todayitem"></div>
						<% else %>
							<!-- for dev msg : 검색 후 -->
							<div class="pdtListWrap">
								<div class="sorting">
								<p class="all">
									<select name="selisusing" onchange="jsTalkRightCateSearch(this.value)" class="selectBox" title="카테고리 선택">
										<option >카테고리</option>
									<%
										Dim oGrCat, vTmpCode, Lp
										set oGrCat = new SearchItemCls
											oGrCat.FRectSearchTxt = vSearchText
											oGrCat.FRectSortMethod = fnSortMatching(vOrderType)
											oGrCat.FRectSearchItemDiv = "y"
											oGrCat.FRectSearchCateDep = vDisp
											oGrCat.FCurrPage = 1
											oGrCat.FPageSize = 200
											oGrCat.FScrollCount =4
											oGrCat.FListDiv = "search"
											oGrCat.FGroupScope = "1"	'카테고리 그룹 범위(depth)
											oGrCat.FLogsAccept = False '그룹형은 절대 !!! False 
											oGrCat.getGroupbyCategoryList		'//카테고리 접수

											for Lp=0 to oGrCat.FResultCount-1
												If oGrCat.FItemList(Lp).FCateCd1 <> vTmpCode Then
													Response.Write "<option " & CHKIIF(oGrCat.FItemList(Lp).FCateCd1=vDisp,"selected","") & " value=" & oGrCat.FItemList(Lp).FCateCd1 & ">"& Split(oGrCat.FItemList(Lp).FCateName,"^^")(0) &"</option>" & vbCrLf
													If vDisp = oGrCat.FItemList(Lp).FCateCd1 Then
														vListName = Split(oGrCat.FItemList(Lp).FCateName,"^^")(0)
													End If
												End IF
												vTmpCode = oGrCat.FItemList(Lp).FCateCd1
											next
										set oGrCat = nothing
									%>
									</select>
								</p>
								<style>
								.giftAdd .pdtListWrap .sorting {position:relative;display:flex; align-items:center; margin-bottom:1rem;}
								.sortingV2 {display:flex; align-items:center; margin-left:auto;}
								.sortingV2 p {margin:0 .2rem; padding:.5rem; background-color:#fff; border:1px solid #cfcfcf; border-radius:4px;}
								</style>
								<div class="sortingV2">
									<p <% if vOrderType="new" then response.write "class=""selected" %>><span class="button"><a href="" onclick="jsTalkRightListSorting('new'); return false;">신상순</a></span></p><!-- for dev msg : 클릭시 selected 클래스 붙여주세요(작업시 퍼블리셔 문의) -->
									<p <% if vOrderType="fav" then response.write "class=""selected" %>><span class="button"><a href="" onclick="jsTalkRightListSorting('fav'); return false;">인기순</a></span></p>
									<% If vOrderType = "lowprice" OR vOrderType = "highprice" Then %>
										<% If vOrderType = "highprice" Then %>
											<p class="selected upSort"><span class="button priceBtn"><a href="" onClick="jsTalkRightListSorting('lowprice'); return false;">가격순</a></span></p>
										<% Else %>
											<p class="selected downSort"><span class="button priceBtn"><a href="" onClick="jsTalkRightListSorting('highprice'); return false;">가격순</a></span></p>
										<% End If %>
									<% Else %>
										<p><span class="button priceBtn"><a href="" onClick="jsTalkRightListSorting('lowprice'); return false;">가격순</a></span></p>
									<% End If %>
								</div>
								</div>
								<ul class="pdtList">
								<% 
								for ix = 0 to cTalkItem.FResultCount-1
								
									vPrice = cTalkItem.FItemList(ix).fnRealAllPrice
									if vPrice<>"" and vPrice<>0 and cTalkItem.FItemList(ix).FOrgPrice<>"" and cTalkItem.FItemList(ix).FOrgPrice<>0 then
										vSale = Round(100-(100*(vPrice/cTalkItem.FItemList(ix).FOrgPrice)))
									else
										vSale=0
									end if
								%>
									<li onclick="fnAPPopenerJsCallClose('TalkItemSelect(<%=cTalkItem.FItemList(ix).FItemID%>)');">
										<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%= cTalkItem.FItemList(ix).FImageIcon2 %>" alt="<%= Replace(cTalkItem.FItemList(ix).FItemName,"""","") %>" /></div>
										<div class="pdtCont">
											<p class="pBrand"><%= cTalkItem.FItemList(ix).FBrandName %></p>
											<p class="pName"><%= cTalkItem.FItemList(ix).FItemName %></p>
											<p class="pPrice"><%= FormatNumber(vPrice,0) %>원 <% If vSale > 0 Then %><span class="cGr1">[<%=vSale%>%]</span><% End If %></p>
											<span class="button btS1 btRed cWh1"><button type="button">추가</button></span>
										</div>
									</li>
								<% next %>
								</ul>
								<%= fnDisplayPaging_New(cTalkItem.FcurrPage, cTalkItem.FtotalCount, cTalkItem.FPageSize, 4, "jsTalkRightListPaging") %>
							</div>
						<% End If
							If vTab = "2" AND vListName = "" Then
								vListName = "All"
							End If
						%>
					</div>
				<% elseif vTab = "2" then %>
					<!-- 나의 위시 -->
					<div id="searchMyWish" class="findWish tabcont" style="display:<%=CHKIIF(vTab="2","block","none")%>;">
						<h2 class="hidden">나의 위시</h2>
						<div id="finder" class="finder">
							<select onchange="jsTalkRightListWish(this.value)" title="나의 위시 폴더 선택 옵션">
								<option value="0" <%=CHKIIF(Cstr(vFolderID)="0","selected","")%>>기본폴더</option>
							<%
								IF isArray(arrList) THEN
									For intLoop = 0 To UBound(arrList,2)
										If CStr(arrList(0,intLoop))=CStr(vFolderID) Then
											vListName = chkIIF(arrList(0,intLoop)="0","기본폴더",arrList(1,intLoop))
										End If
										Response.Write "<option " & CHKIIF(CStr(arrList(0,intLoop))=CStr(vFolderID),"selected","") & " value=" &arrList(0,intLoop)& ">" & chkIIF(arrList(0,intLoop)="0","기본폴더",arrList(1,intLoop)) &"</option>" & vbCrLf
									Next
								Else
									Response.Write "<option >기본폴더</option>"
								End If
							%>
							</select>
						</div>
						<div class="pdtListWrap">
							<% If (cTalkItem.FResultCount < 1) Then %>
								<!-- for dev msg : 폴더에 담긴 상품이 없을 경우 -->
								<p class="noData">폴더에 담긴 상품이 없습니다.</p>
							<% else %>
								<ul class="pdtList">
								<% 
								for ix = 0 to cTalkItem.FResultCount-1
									vPrice = cTalkItem.FItemList(ix).fnRealAllPrice
									if vPrice<>"" and vPrice<>0 and cTalkItem.FItemList(ix).FOrgPrice<>"" and cTalkItem.FItemList(ix).FOrgPrice<>0 then
										vSale = Round(100-(100*(vPrice/cTalkItem.FItemList(ix).FOrgPrice)))
									else
										vSale=0
									end if
								%>
									<li onclick="fnAPPopenerJsCallClose('TalkItemSelect(<%=cTalkItem.FItemList(ix).FItemID%>)');">
										<div class="pPhoto"><p><span><em>품절</em></span></p>
											<img src="<%= cTalkItem.FItemList(ix).FImageList120 %>" alt="<%= Replace(cTalkItem.FItemList(ix).FItemName,"""","") %>" />
										</div>
										<div class="pdtCont">
											<p class="pBrand"><%= cTalkItem.FItemList(ix).FBrandName %></p>
											<p class="pName"><%= cTalkItem.FItemList(ix).FItemName %></p>
											<p class="pPrice"><%= FormatNumber(vPrice,0) %>원 <% If vSale > 0 Then %><span class="cGr1">[<%=vSale%>%]</span><% End If %></p>
											<span class="button btS1 btRed cWh1"><button type="button">추가</button></span>
										</div>
									</li>
								<% next %>
								</ul>
							<%= fnDisplayPaging_New(cTalkItem.FcurrPage, cTalkItem.FtotalCount, cTalkItem.FPageSize, 4, "jsTalkRightListPaging") %>
						<% end if %>
						</div>
					</div>
				<% end if %>
				</div>
			</div>
		</div>
	</div>
	</form>
</div>
<% If Request("gb") = "first" Then	'### 처음 들어올때 & back버튼 클릭하면 초기값으로 셋팅. %>
	<script>$('input[name="itemid"]').val(',');$('input[name="itemcount"]').val('0');</script>
<% End If %>

<% set cTalkItem = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->