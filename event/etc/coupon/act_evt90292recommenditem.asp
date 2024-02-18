<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON2.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/search/searchCls.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
    Dim rsMem, userId, sqlStr, i, pItemArr, FResultCount, lp

    userId = getEncLoginUserId()

    sqlStr = "exec db_temp.dbo.usp_TEN_AppCoupon181122_RecommendItem  '" & userId & "' "

    set rsMem = getDBCacheSQL(dbget,rsget,"AppCoupon181122",sqlStr,60*60)
    'set rsMem = getDBCacheSQL(dbget,rsget,"AppCoupon181122",sqlStr,1*1)    

    if (rsMem is Nothing) then 
        response.write ""
        response.end
    end if

    FResultCount = rsMem.RecordCount
    redim preserve FItemList(FResultCount)

    i=0
    pItemArr =""

    if  not rsMem.EOF  then
        do until rsMem.eof
            set FItemList(i) = new CCategoryPrdItem

            FItemList(i).FItemID		= rsMem("itemid")
            FItemList(i).FItemName		= db2html(rsMem("itemname"))
            FItemList(i).FImageList		= "http://webimage.10x10.co.kr/image/list/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listimage")
            FItemList(i).FImageList120	= "http://webimage.10x10.co.kr/image/list120/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("listimage120")
            FItemList(i).FIcon1Image  = "http://webimage.10x10.co.kr/image/icon1/" + GetImageSubFolderByItemid(rsMem("itemid")) + "/" + rsMem("icon1image")
            FItemList(i).FBrandName		= db2html(rsMem("brandname"))
            FItemList(i).FMakerID		= db2html(rsMem("makerid"))
            FItemList(i).Fitemdiv		= rsMem("itemdiv")

            FItemList(i).FSellCash 		= rsMem("sellcash")
            FItemList(i).FOrgPrice 		= rsMem("orgprice")
            FItemList(i).FSellyn 		= rsMem("sellyn")
            FItemList(i).FSaleyn 		= rsMem("sailyn")
            FItemList(i).FLimityn 		= rsMem("limityn")
            FItemList(i).FLimitNo      = rsMem("limitno")
            FItemList(i).FLimitSold    = rsMem("limitsold")
            FItemList(i).FItemcouponyn 	= rsMem("itemcouponyn")
            FItemList(i).FItemCouponValue 	= rsMem("itemCouponValue")
            FItemList(i).FItemCouponType 	= rsMem("itemCouponType")
            FItemList(i).FEvalCnt 	= rsMem("evalcnt")
            FItemList(i).FfavCount 	= rsMem("favcount")
            FItemList(i).FOptionCnt = rsMem("optioncnt")

            pItemArr = pItemArr + CStr(FItemList(i).FItemID) + ","
            i=i+1
            rsMem.moveNext
        loop
    end if
    rsMem.Close

	if FResultCount>3 then

%>
<div class="itemAddWrapV16a ctgyBestV16a">
	<div class="bxLGy2V16a">
		<h3><strong>쿠폰으로 구매하면 좋을 상품</strong></h3>
	</div>
	<div class="bxWt1V16a">
		<ul class="simpleListV16a simpleListV16b">
			<%	For lp = 0 To FResultCount - 1 %>
			<% if lp>12 then Exit For %>
				<li>
                    <a href="" onclick="fnAPPpopupBrowserURL('사용가능한 쿠폰','<%=wwwUrl%>/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%= FItemList(lp).FItemId %>&rc=event_90292_<%=lp+1%>','right','','sc');return false;">
                        <p><img src="<%=FItemList(lp).FIcon1Image %>" alt="<%=FItemList(lp).FItemName%>" /></p>
						<span><%=FItemList(lp).FItemName%></span>
						<span class="price">
							<% = FormatNumber(FItemList(lp).getRealPrice,0) %><%=chkIIF(FItemList(lp).IsMileShopitem,"Point","원")%>
							<% If FItemList(lp).IsSaleItem Then %>
							<em class="cRd1">[<% = FItemList(lp).getSalePro %>]</em>
							<% end if %>
						</span>
					</a>
				</li>
			<% Next %>
		</ul>
	</div>
</div>

<%
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->