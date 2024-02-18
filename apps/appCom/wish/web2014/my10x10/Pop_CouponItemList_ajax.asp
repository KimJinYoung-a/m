<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  쿠폰북
' History : 2014.06.25 한용민 www 이전/생성
' History : 2014-09-01 이종화 renewal
' History : 2014-11-12 원승현 renewal
' History : 2017-10-25 유태욱 페이징변경
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
dim itemcouponidx, ocouponitemlist, page, makerid,sailyn, i, lp
dim vDisp : vDisp = getNumeric(requestCheckVar(request("disp"),15))
	itemcouponidx = requestCheckVar(request("itemcouponidx"),32)
	makerid = requestCheckVar(request("makerid"),32)
	page = requestCheckVar(request("page"),32)
	sailyn = requestCheckVar(request("sailyn"),1)

page = Trim(replace(page,",",""))
if itemcouponidx="" then itemcouponidx=0
if page="" then page=1

set ocouponitemlist = new CItemCouponMaster
	ocouponitemlist.FPageSize=20
	ocouponitemlist.FCurrPage=page
	ocouponitemlist.FRectItemCouponIdx = itemcouponidx
	ocouponitemlist.FRectCateCode		= vDisp
	''ocouponitemlist.GetItemCouponItemList
	ocouponitemlist.GetItemCouponItemListCaChe
%>
	<% if ocouponitemlist.FResultCount > 0 then %>
		<% for i=0 to ocouponitemlist.FResultCount - 1 %>	
			<li onclick="fnAPPpopupProduct('<%= ocouponitemlist.FItemList(i).FItemID %>');return false;" class="soldOut">
				<div class="pPhoto"><img src="<%= ocouponitemlist.FitemList(i).FImageIcon1 %>" alt="<%= ocouponitemlist.FitemList(i).FItemName %>" alt="<%= ocouponitemlist.FitemList(i).FItemName %>"></div><%' for dev msg : 상품명 alt값 속성에 넣어주세요 %>
				<div class="pdtCont">
					<p class="pBrand"><%= ocouponitemlist.FitemList(i).FMakerid %></p>
					<p class="pName"><%= ocouponitemlist.FitemList(i).FItemName %></p>
					<p class="pPrice"><%= FormatNumber(ocouponitemlist.FitemList(i).GetCouponSellcash,0) %>원 
						<span class="cGr1">
							<% if ocouponitemlist.FitemList(i).Fitemcoupontype="1" then %>
								[<%=ocouponitemlist.FitemList(i).Fitemcouponvalue%>%]
							<% ElseIf ocouponitemlist.FitemList(i).Fitemcoupontype="3" Then %>
								[무료배송]
							<% else %>
								[<%=ocouponitemlist.FitemList(i).Fitemcouponvalue%>원 할인]
							<% end if %>
						</span>
					</p>
					<p class="pShare">
						<span class="cmtView"><%=formatNumber(ocouponitemlist.FItemList(i).FEvalCnt,0)%></span>
						<span class="wishView"><%=formatNumber(ocouponitemlist.FItemList(i).FfavCount,0)%></span>
					</p>
				</div>
			</li>
		<% Next %>
	<% End If %>
<%
set ocouponitemlist = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->