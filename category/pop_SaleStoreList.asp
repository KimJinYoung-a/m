<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/offshopcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<%
	'판매 매장 정보
	dim oItem, arrOffShopList, itemid, lp, ix
	itemid = getNumeric(requestCheckVar(request("itemid"),9))
	set oItem = new CatePrdCls
	arrOffShopList = oItem.GetSellOffShopList(itemid,2)

	'매장 정보 가져오기
	Dim offshoplist
	Set  offshoplist = New COffShop
	offshoplist.GetOffShopList

	Dim dicStore
	set dicStore = Server.CreateObject("Scripting.Dictionary")
	For ix=0 To offshoplist.FResultCount-1
		dicStore.Add offshoplist.FItemList(ix).FShopID, Array(offshoplist.FItemList(ix).FShopName,offshoplist.FItemList(ix).FShopAddr1 + " " + offshoplist.FItemList(ix).FShopAddr2,offshoplist.FItemList(ix).FMobileWorkHour,offshoplist.FItemList(ix).FShopPhone)
	Next
	Set offshoplist = Nothing
%>
<div class="layerPopup">
	<div class="popWin">
		<header class="tenten-header header-popup">
			<div class="title-wrap">
				<h1>매장안내</h1>
				<button type="button" class="btn-close" onclick="fnCloseModal();">닫기</button>
			</div>
		</header>
		<!-- contents -->
		<div class="content" id="layerScroll">
			<div id="scrollarea">
				<div>
				<% if isArray(arrOffShopList) then %>
					<p class="noti-offline">구매 가능한 재고와 판매가격은 매장별로 다를 수 있으니,<br /> 매장에 확인 후 방문해주세요.</p>

					<div class="tenten-offline">
					<%
						for lp=0 to ubound(arrOffShopList,2)
							if dicStore.Exists(arrOffShopList(0,lp)) then
					%>
						<div class="desc">
							<h2 class="headline"><%=dicStore(arrOffShopList(0,lp))(0)%></h2>
							<address><%=dicStore(arrOffShopList(0,lp))(1)%></address>
							<ul class="info">
								<li><span class="icon icon-hours"></span><b class="highlight">영업시간</b> <%=dicStore(arrOffShopList(0,lp))(2)%> <span class="etc">(휴무시 별도 공지)</span></li>
								<li><span class="icon icon-tel"></span><b class="highlight">매장문의</b> <a href="tel:<%=dicStore(arrOffShopList(0,lp))(3)%>" class="tel"><%=dicStore(arrOffShopList(0,lp))(3)%></a></li>
							</ul>
							<!--<a href="" class="btn btn-block">매장 상품 보러가기</a>-->
						</div>
					<%
							End if
						next
					%>
				<% Else %>
					<p class="noti-offline">죄송합니다. 판매 매장이 없습니다.</p>
				<% End if %>
					</div>
				</div>
			</div>
		</div>
		<!-- //contents -->
	</div>
</div>
<%
	set dicStore = nothing
	set oItem = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->