<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.Buffer = True
%>
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<%
    '' 2차서버로 변경 2014/09/30 dbopen.asp => dbCTopen.asp, dbclose.asp =>dbCTclose.asp, fnPopularList => fnPopularList_CT
	Dim cPopular, vDisp, vSort, vCurrPage, i, j, vArrEval, oExhibition
	vDisp = RequestCheckVar(Request("disp"),18)
	vSort = NullFillWith(RequestCheckVar(Request("sort"),1),"1")
	vCurrPage = RequestCheckVar(Request("cpg"),5)
	
	If vCurrPage = "" Then vCurrPage = 1
	
    SET oExhibition = new ExhibitionCls
	SET cPopular = New CMyFavorite
	cPopular.FPageSize = 15
	cPopular.FCurrpage = vCurrPage
	cPopular.FRectDisp = vDisp
	cPopular.FRectSortMethod = vSort
	cPopular.FRectUserID = GetLoginUserID()
	cPopular.fnPopularList_CT
%>			
<% If (cPopular.FResultCount > 0) Then %>	
<script type="text/javascript">
    $(function(){
        $('.btn-wish').click(function(e){
		    e.preventDefault()            
			e.stopPropagation()
		});	
    });
</script>
    <%
     dim couponPrice, couponPer, tempPrice, salePer
     dim saleStr, couponStr, tmpEvalArr                
     For i = 0 To cPopular.FResultCount-1 
        couponPer = oExhibition.GetCouponDiscountStr(cPopular.FItemList(i).Fitemcoupontype, cPopular.FItemList(i).Fitemcouponvalue)
        couponPrice = oExhibition.GetCouponDiscountPrice(cPopular.FItemList(i).Fitemcoupontype, cPopular.FItemList(i).Fitemcouponvalue, cPopular.FItemList(i).Fsellcash)                    					
        salePer     = CLng((cPopular.FItemList(i).Forgprice-cPopular.FItemList(i).Fsellcash)/cPopular.FItemList(i).FOrgPrice*100)
        if cPopular.FItemList(i).FSaleyn = "Y" and cPopular.FItemList(i).Fitemcouponyn = "Y" then '세일, 쿠폰
            tempPrice = cPopular.FItemList(i).Fsellcash - couponPrice
            saleStr = "<span class=""discount color-red"">"& salePer &"%</span>"
            couponStr = "<span class=""discount color-green"">"&couponPer&"</span>"  
        elseif cPopular.FItemList(i).Fitemcouponyn = "Y" then    '쿠폰
            tempPrice = cPopular.FItemList(i).Fsellcash - couponPrice
            saleStr = ""
            couponStr = "<span class=""discount color-green"">"&couponPer&"</span>"  					
        elseif cPopular.FItemList(i).FSaleyn = "Y" then  '세일
            tempPrice = cPopular.FItemList(i).Fsellcash
            saleStr = "<span class=""discount color-red"">"& salePer &"%</span>"
            couponStr = ""    
        else
            tempPrice = cPopular.FItemList(i).Fsellcash
            saleStr = ""
            couponStr = ""             
        end if		
        if cPopular.FItemList(i).FAdultType = "1" then            
        else                    
     %>
    <li class="item-list" itemid="<%=cPopular.FItemList(i).FItemID%>">
        <% if isapp = 1 then %>
            <a href="javascript:void(0)" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=cPopular.FItemList(i).FItemID%>')">
        <% else %>
            <a href="/category/category_itemprd.asp?itemid=<%=cPopular.FItemList(i).FItemID%>">
        <% end if %>                   							
            <div class="thumbnail"><img src="<%= cPopular.FItemList(i).FImageBasic %>" alt=""></div>
            <div class="desc">
                <p class="name ellipsis"><%= cPopular.FItemList(i).FItemName %></p>
                    <div class="price">
                        <%=saleStr%><%=couponStr%><%=FormatNumber(tempPrice, 0)%>원
                    </div>                    
                <button class="btn-wish" onclick="TnAddFavoritePrd('<%=cPopular.FItemList(i).FItemID%>')">
                    <i></i>
                    <span><%=FormatNumber(cPopular.FItemList(i).FFavCount,0)%></span>
                </button>                                                  
            </div>
        </a>
    </li>									
    <% 
        end if
    Next 
    %>	
<%
Else
%>
<%
End If
SET cPopular = Nothing
%>

<!-- #include virtual="/lib/db/dbCTclose.asp" -->