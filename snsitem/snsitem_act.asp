<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.Buffer = True
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/exhibition/exhibitionCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<script type="text/javascript">
    $(function(){
        $('.btn-wish').click(function(e){
		    e.preventDefault()            
			e.stopPropagation()
		});
		$(".review ul").css("display", "none")
    });
</script>
<script type="text/javascript">
$( ".btn-more" ).click(function(e) {
	e.preventDefault()
	e.stopPropagation()
	$(this).parent().siblings('ul').slideToggle("slow");
	$(this).toggleClass("unfold");	
});
</script>
<%    
	Dim vCurrPage 
	
	vCurrPage = RequestCheckVar(Request("cpg"),5)
	
	If vCurrPage = "" Then vCurrPage = 1


Dim oExhibition, page, sortMet
dim mastercode, detailcode, detailGroupList, pagereload, listType, bestItemList 
dim i, j

dim eventEndDate, currentDate, eventStartDate 

eventStartDate = cdate("2019-01-17")	'이벤트 시작일
eventEndDate = cdate("2019-02-15")		'이벤트 종료일
currentDate = date()

listType = "B"

IF application("Svr_Info") = "Dev" THEN
	mastercode = 7
Else
	mastercode = 3
End If

pagereload	= requestCheckVar(request("pagereload"),2)
page = requestCheckVar(request("page"),5)
sortMet = request("sortMet")
if page = "" then page = 1

SET oExhibition = new ExhibitionCls
	oExhibition.FPageSize = 30
	oExhibition.FCurrPage = vCurrPage
	oExhibition.FrectMasterCode = mastercode	
	oExhibition.FrectListType = listType
	oExhibition.FrectSortMet = sortMet

	oExhibition.getItemsPageListProc			
%>

<% If (oExhibition.FResultCount > 0) Then %>
	<% If vCurrPage > 70 Then %>		
	<% Else %>
			<%
             dim couponPrice, couponPer, tempPrice, salePer
             dim saleStr, couponStr, tmpEvalArr            
             for i = 0 to oExhibition.FResultCount - 1 
				couponPer = oExhibition.GetCouponDiscountStr(oExhibition.FItemList(i).Fitemcoupontype, oExhibition.FItemList(i).Fitemcouponvalue)
				couponPrice = oExhibition.GetCouponDiscountPrice(oExhibition.FItemList(i).Fitemcoupontype, oExhibition.FItemList(i).Fitemcouponvalue, oExhibition.FItemList(i).Fsellcash)                    					
				salePer     = CLng((oExhibition.FItemList(i).Forgprice-oExhibition.FItemList(i).Fsellcash)/oExhibition.FItemList(i).FOrgPrice*100)
				if oExhibition.FItemList(i).Fsailyn = "Y" and oExhibition.FItemList(i).Fitemcouponyn = "Y" then '세일, 쿠폰
					tempPrice = oExhibition.FItemList(i).Fsellcash - couponPrice
					saleStr = "<span class=""discount color-red"">"& salePer &"%</span>"
					couponStr = "<span class=""discount color-green"">"&couponPer&"</span>"  
				elseif oExhibition.FItemList(i).Fitemcouponyn = "Y" then    '쿠폰
					tempPrice = oExhibition.FItemList(i).Fsellcash - couponPrice
					saleStr = ""
					couponStr = "<span class=""discount color-green"">"&couponPer&"</span>"  					
				elseif oExhibition.FItemList(i).Fsailyn = "Y" then  '세일
					tempPrice = oExhibition.FItemList(i).Fsellcash
					saleStr = "<span class=""discount color-red"">"& salePer &"%</span>"
					couponStr = ""    
				else
					tempPrice = oExhibition.FItemList(i).Fsellcash
					saleStr = ""
					couponStr = ""             
				end if		  
				'후기
				tmpEvalArr = getEvaluations(oExhibition.FItemList(i).Fitemid, 3)
			%>			
                        <li class="item-list" itemid="<%=oExhibition.FItemList(i).Fitemid%>">
						<% if isapp = 1 then %>
							<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_items','idx|itemid','<%=i+1%>|<%=oExhibition.FItemList(i).Fitemid%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>');}});return false;">
						<% else %>
							<a href="/category/category_itemprd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_items','idx|itemid','<%=i+1%>|<%=oExhibition.FItemList(i).Fitemid%>');">
						<% end if %>                            
                                <div class="thumbnail"><img src="<%=oExhibition.FItemList(i).FPrdImage%>" alt="<%=oExhibition.FItemList(i).Fitemname%>"></div>
                                <div class="desc">
                                    <p class="name"><%=oExhibition.FItemList(i).Fitemname%></p>
                                    <div class="price">
										<%=saleStr%><%=couponStr%><%=FormatNumber(tempPrice, 0)%>원
									</div>
									<button class="btn-wish" onclick="TnAddFavoritePrd('<%=oExhibition.FItemList(i).Fitemid%>')">
										<i></i>
										<span><%= FormatNumber(oExhibition.FItemList(i).FfavCnt, 0) %></span>
									</button>                                    									
                                </div>	
								<div class="review">
								<% if oExhibition.FItemList(i).FevalCnt > 0 then %>		
									<div>
										<span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(oExhibition.FItemList(i).FtotalPoint,"search")%>%;">별<%=fnEvalTotalPointAVG(oExhibition.FItemList(i).FtotalPoint,"search")%>점</i></span>
										<span class="counting">(<%=oExhibition.FItemList(i).FevalCnt%>)</span>
										<span class="btn-more"></span>
									</div>                 
									<% if isArray(tmpEvalArr) then %>
									<ul>
										<% 
										   for j=0 to uBound(tmpEvalArr,2)
										        if tmpEvalArr(1,j) <> "" then
										%>
										<li>
											<p class="writer"><%=printUserId(tmpEvalArr(0,j),2,"*")%></p>
											<div><%=tmpEvalArr(1,j)%></div>
										</li>
										<%
											    end if
										%>  											
										<% next %>
									</ul>
									<% end if %>																						
								<% else %>
									<% if isapp = 1 then %>
										<a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_items','idx|itemid','<%=i+1%>|<%=oExhibition.FItemList(i).Fitemid%>', function(bool){if(bool) {fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>');}});return false;"><span class="no-data"><span class="icon icon-edit_gray"></span>SNS 인기템, 처음으로 후기 남기고 200Point 받아가세요!</span></a>
									<% else %>
										<a href="/category/category_itemprd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_snsitem_items','idx|itemid','<%=i+1%>|<%=oExhibition.FItemList(i).Fitemid%>');"><span class="no-data"><span class="icon icon-edit_gray"></span>SNS 인기템, 처음으로 후기 남기고 200Point 받아가세요!</span></a>						
									<% end if %>  																																	
								<% end if %>								
								</div>                                
                            </a>
                        </li>		       							
			<% Next %>
	<% End If %>
<%
Else
%>
<%
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->