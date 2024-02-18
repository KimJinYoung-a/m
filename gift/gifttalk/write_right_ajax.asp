<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  기프트
' History : 2015.02.23 유태욱 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/classes/shopping/todayshoppingcls.asp" -->

<%
	Dim vTab, vFolderID, vTalkIdx, vKeyword, vSort, vIsSearch, vCount, vIsMine, vStoryItem, vListName, vItemID, userid
	Dim vSearchText, vDisp
	Dim vPage, vOrderType, ix, vPrice, vSale
	vTab 		= requestCheckVar(Request("tab"),1)	'빠른 상품추가 탭 구분(1-상품검색,2-나의위시,3-최근본상품)
	vFolderID 	= requestCheckvar(request("fidx"),9)'나의위시 폴더
	vPage		= requestCheckVar(request("page"),3)
	vOrderType	= requestCheckVar(request("OrderType"),10)
	vSearchText	= requestCheckVar(request("searchtxt"),100) '현재 입력된 검색어
	userid = getEncLoginUserID
	vDisp		= getNumeric(requestCheckVar(request("dispCate"),18))
	If vFolderID = "" Then vFolderID = "0" End If
	If vTab = "" Then vTab = "2" End IF
	If vPage = "" Then vPage = "1" End IF
	If vOrderType = "" Then vOrderType = "fav" End If

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
		cTalkItem.getSearchList
	End If

	'최근 본 상품
	dim myTodayShopping
	set myTodayShopping = new CTodayShopping
	myTodayShopping.FPageSize        = 15
	myTodayShopping.FCurrpage        = vPage 'page
	myTodayShopping.FScrollCount     = 4
	myTodayShopping.FRectOrderType   = vOrderType
	'myTodayShopping.FRectCDL         = cdl
	myTodayShopping.FRectUserID      = getEncLoginUserID

	if userid<>"" then
	    myTodayShopping.getMyTodayViewList
	end if

	dim i, iLp
%>
<script type="text/javascript">

//빠른상품추가(상품검색,나의위시 페이징)
function jsTalkRightListPaging(a){
	$.ajax({
			<% If vTab = "2" Then %>
			url: "/gift/gifttalk/write_right_ajax.asp?tab=2&fidx=<%=vFolderID%>&OrderType=<%=vOrderType%>&page="+a+"",
			<% ElseIf vTab = "1" Then %>
			url: "/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType=<%=vOrderType%>&searchtxt="+$("#searchtxt").val()+"&page="+a+"&dispCate=<%=vDisp%>",
			<% End If %>
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
}

//나의위시 폴더선택
function jsTalkRightListWish(a){
	$.ajax({
			url: "/gift/gifttalk/write_right_ajax.asp?tab=<%=vTab%>&fidx="+a+"&OrderType=<%=vOrderType%>",
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
}

//검색결과내 정렬
function jsTalkRightListSorting(a){
	$.ajax({
			<% If vTab = "2" Then %>
			url: "/gift/gifttalk/write_right_ajax.asp?tab=2&fidx=<%=vFolderID%>&OrderType="+a+"",
			<% ElseIf vTab = "1" Then %>
			url: "/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType="+a+"&searchtxt="+$("#searchtxt").val()+"&dispCate=<%=vDisp%>",
			<% End If %>
			cache: false,
			success: function(message)
			{
				$("#contentArea2").empty().append(message);
			}
	});
}

//상품검색 실행
function jsTalkRightSearch(){
	var sTxt = $("#searchtxt");
	if(sTxt.val() == "상품코드 또는 검색어 입력" || sTxt.val() == ""){
		sTxt.val("");
		alert("상품코드 또는 검색어를 입력해주세요.");
		sTxt.focus();
		return;
	}else{
		$.ajax({
				url: "/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType=<%=vOrderType%>&searchtxt="+sTxt.val()+"",
				cache: false,
				success: function(message)
				{
					$("#contentArea2").empty().append(message);
				}
		});
	}
}

//검색되 상품들의 카테고리 선택
function jsTalkRightCateSearch(c){
	var sTxt = $("#searchtxt");
	if(sTxt.val() == "상품코드 또는 검색어 입력" || sTxt.val() == ""){
		sTxt.val("");
		alert("상품코드 또는 검색어를 입력해주세요.");
		sTxt.focus();
		return;
	}else{
		$.ajax({
				url: "/gift/gifttalk/write_right_ajax.asp?tab=1&OrderType=<%=vOrderType%>&searchtxt="+sTxt.val()+"&dispCate="+c+"",
				cache: false,
				success: function(message)
				{
					$("#contentArea2").empty().append(message);
				}
		});
	}
}

//톡에 작성할 상품 추가
function TalkItemSelect(v){
	location.replace("/gift/gifttalk/talk_write.asp?itemid="+v);
}
<!-- #include file="./inc_Javascript.asp" -->
</script>

<div class="layerPopup" id="contentArea2" style="overflow-y:auto; background-color:#f4f7f7;">
	<div class="popWin">
	<form name="itemSearch" method="get" style="margin:0px;" onSubmit="return false;">
	<input type="hidden" name="tab" value="<%=vTab%>">
	<input type="hidden" name="fidx" value="<%=vFolderID%>">
	<input type="hidden" name="dispCate" value="<%=vDisp%>">
	<input type="hidden" name="page" value="">
		<div class="header">
			<h1>빠른 상품추가</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<div class="content" id="contentArea" style="padding:4.86rem 0;">
			<div id="contview" class="giftAdd">
				<div class="tab02">
					<ul class="tabNav tNum2 noMove">
						<li <%=CHKIIF(vTab="2","class=current","")%>><a href="javascript:" onClick="jsTalkRightListTabChange('2');">나의 위시</a></li>
						<li <%=CHKIIF(vTab="1","class=current","")%>><a href="javascript:" onClick="jsTalkRightListTabChange('1');">상품 검색</a></li>
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
							<!-- for dev msg : 검색 전 최근 본 상품-->
							<div class="pdtListWrap">
								<% If myTodayShopping.FResultCount>0 Then %>
								<h3>최근 본 상품</h3>
									<ul class="pdtList">
										<% For lp=0 To myTodayShopping.FResultCount-1 %>
											<li onclick="TalkItemSelect('<%=myTodayShopping.FItemList(lp).FItemID%>');return false;">
												<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%= myTodayShopping.FItemList(lp).FImageicon1 %>" alt="<% = myTodayShopping.FItemList(lp).FItemName %>" /></div>
												<div class="pdtCont">
													<p class="pBrand"><%= myTodayShopping.FItemList(lp).FBrandName %></p>
													<p class="pName"><%= myTodayShopping.FItemList(lp).FItemName %></p>
													<% IF myTodayShopping.FItemList(lp).IsSaleItem or myTodayShopping.FItemList(lp).isCouponItem Then %>
														<% IF myTodayShopping.FItemList(lp).IsSaleItem then %>
															<p class="ftSmall2 c999"><del><%= FormatNumber(myTodayShopping.FItemList(lp).getOrgPrice,0) %>원</del></p>
															<p class="pPrice"><%= FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %>원 <span class="cGr1">[<%= myTodayShopping.FItemList(lp).getSalePro %>%]</span></p>
														<% End IF %>
														<% IF myTodayShopping.FItemList(lp).IsCouponItem Then %>
															<% IF Not(myTodayShopping.FItemList(lp).IsFreeBeasongCoupon() or myTodayShopping.FItemList(lp).IsSaleItem) then %>
																<p class="ftSmall2 c999"><del><% = FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %>원</del></p>
															<% End IF %>
															<p class="pPrice"><% = FormatNumber(myTodayShopping.FItemList(lp).GetCouponAssignPrice,0) %>원 [<% = myTodayShopping.FItemList(lp).GetCouponDiscountStr %>]<% IF myTodayShopping.FItemList(lp).IsFreeBeasong Then Response.Write "[무료배송]" %></p>
														<% end if %>
													<% Else %>
														<p class="pPrice"><%= FormatNumber(myTodayShopping.FItemList(lp).getRealPrice,0) %><% if myTodayShopping.FItemList(lp).IsMileShopitem then %> Point<% else %> 원<% end if %></p>
													<% End if %>
													<span class="button btS1 btRed cWh1"><button type="button" >추가</button></span>
												</div>
											</li>
										<% next %>
									</ul>
								<% else %>
									<div class="topGyBdr btmGyBdr ct innerH25 tMar10">
										<p class="ftMid c999 innerH25">최근 본 상품이 없습니다.</p>
									</div>
								<% end if %>
							</div>
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
									<p <% if vOrderType="new" then response.write "class=selected" %>><span class="button"><a href="" onclick="jsTalkRightListSorting('new'); return false;">신상순</a></span></p><!-- for dev msg : 클릭시 selected 클래스 붙여주세요(작업시 퍼블리셔 문의) -->
									<p <% if vOrderType="fav" then response.write "class=selected" %>><span class="button"><a href="" onclick="jsTalkRightListSorting('fav'); return false;">인기순</a></span></p>
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
									<li onclick="TalkItemSelect('<%=cTalkItem.FItemList(ix).FItemID%>');return false;">
										<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%= cTalkItem.FItemList(ix).FImageIcon2 %>" alt="<%= Replace(cTalkItem.FItemList(ix).FItemName,"""","") %>" /></div>
										<div class="pdtCont">
											<p class="pBrand"><%= cTalkItem.FItemList(ix).FBrandName %></p>
											<p class="pName"><%= cTalkItem.FItemList(ix).FItemName %></p>
											<p class="pPrice"><%= FormatNumber(vPrice,0) %>원 <% If vSale > 0 Then %><span class="cGr1">[<%=vSale%>%]</span><% End If %></p>
											<span class="button btS1 btRed cWh1"><button type="button" >추가</button></span>
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
									<li onClick="TalkItemSelect('<%=cTalkItem.FItemList(ix).FItemID%>'); return false;">
										<div class="pPhoto"><p><span><em>품절</em></span></p>
											<img src="<%= cTalkItem.FItemList(ix).FImageList120 %>" alt="<%= Replace(cTalkItem.FItemList(ix).FItemName,"""","") %>" />
										</div>
										<div class="pdtCont">
											<p class="pBrand"><%= cTalkItem.FItemList(ix).FBrandName %></p>
											<p class="pName"><%= cTalkItem.FItemList(ix).FItemName %></p>
											<p class="pPrice"><%= FormatNumber(vPrice,0) %>원 <% If vSale > 0 Then %><span class="cGr1">[<%=vSale%>%]</span><% End If %></p>
											<span class="button btS1 btRed cWh1"><button type="button" >추가</button></span>
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