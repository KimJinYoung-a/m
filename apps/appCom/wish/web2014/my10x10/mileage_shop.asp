<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<% Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 마일리지 샵
' History : 2014-09-01 이종화 
' History : 2015-04-28 유태욱
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_mileageshopitemcls.asp" -->
<%
'// 마일리지 샾 상품
dim oMileageShop
dim userid
 userid      = getEncLoginUserID

set oMileageShop = new CMileageShop
oMileageShop.FPageSize=30

 oMileageShop.GetMileageShopItemList
 
dim i,j, lp,ix
dim iCols, iRows
iCols=1
iRows = CLng(oMileageShop.FResultCount \ iCols)

if (oMileageShop.FResultCount mod iCols)>0 then
	iRows = iRows + 1
end if

dim availtotalMile,oMileage
availtotalMile = 0

'// 마일리지 정보
set oMileage = new TenPoint
oMileage.FRectUserID = userid
if (userid<>"") then
    oMileage.getTotalMileage
    availtotalMile = oMileage.FTotalMileage
end if

if availtotalMile<1 then availtotalMile=0
	
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript" src="/lib/js/shoppingbag_script.js"></script>
<script type="text/javascript">
function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin bgGry">
		<!-- content area -->
		<div class="content mileageShop bgGry" id="contentArea">

			<div class="myTenNoti">
				<ul>
					<li>마일리지샵 상품은 텐바이텐 배송 상품과 함께 구매하셔야 하며, 한 상품당 하나씩만 구매하실 수 있습니다.</li>
				</ul>
			</div>
			<div class="inner10 tPad0">
				<div class="pdtListWrap">
					<ul class="pdtList">
					<% 
						if (oMileageShop.FResultCount>0) Then 
							for i=0 to iRows-1
					%>
						<li onclick="jsViewItem('<% = omileageshop.FItemList(i).FItemID %>');" <% if omileageshop.FItemList(i).FLimitSold then response.write "class='soldOut'" %>>
							<div class="pPhoto">
								<% if omileageshop.FItemList(i).FLimitSold then %>
									<p><span><em>품절</em></span></p>
								<% end if %>
								<img src="<%= omileageshop.FItemList(i).FIcon1Image %>" alt="<%= Replace(Replace(oMileageShop.FItemList(i).FItemName,"[마일리지샵]",""),"[마일리지샵]","") %>" />
							</div>
							<div class="pdtCont">
								<p class="pBrand"><% = omileageshop.FItemList(i).Fmakerid %></p>
								<p class="pName"><%= Replace(Replace(oMileageShop.FItemList(i).FItemName,"[마일리지샵]",""),"[마일리지샵]","") %></p>
								<p class="pPrice"><%= FormatNumber(oMileageShop.FItemList(i).getMileageCash,0) %>Point <span class="cRd1"></span></p>
								<p class="pShare">
									<span class="cmtView"><%= (omileageshop.FItemList(i).Fevalcnt) %></span>
									<span class="wishView" onclick=""><%= (omileageshop.FItemList(i).FFavcnt) %></span>
								</p>
							</div>
						</li>
					<%
							Next
						else
					%>
						<li class="noData">판매중인 마일리지 상품이 없습니다.</li>
					<%
						End If 
					%>
					</ul>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<%
set oMileage = Nothing
set oMileageShop = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->