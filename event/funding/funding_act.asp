<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  펀딩템 기획전
' History : 2019-04-15 최종원 생성
'####################################################
%>
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
dim imgSz	: imgSz = 600

listType = "B"

IF application("Svr_Info") = "Dev" THEN
	mastercode = 7
Else
	mastercode = 7
End If

pagereload	= requestCheckVar(request("pagereload"),2)
page = requestCheckVar(request("page"),5)
sortMet = request("sortMet")
if page = "" then page = 1

SET oExhibition = new ExhibitionCls
	oExhibition.FPageSize = 10
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
             dim saleStr, couponStr
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
			%>			
			<li class="item-list" itemid="<%=oExhibition.FItemList(i).Fitemid%>">
			<% if isapp = 1 then %>
				<a href="javascript:void(0)" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>');">
			<% else %>
				<a href="/category/category_itemprd.asp?itemid=<%=oExhibition.FItemList(i).Fitemid%>">
			<% end if %>   
					<div class="pic">
						<div class="thumbnail">							
							<img src="<%=getThumbImgFromURL(oExhibition.FItemList(i).FPrdImage,imgSz,imgSz,"true","false")%>" alt="<%=oExhibition.FItemList(i).Fitemname%>">
						</div>						
						<div class="desc">
							<div class="name"><span class="ellipsis"><%=oExhibition.FItemList(i).Fitemname%></span></div>
							<button class="btn-wish" onclick="TnAddFavoritePrd('<%=oExhibition.FItemList(i).Fitemid%>')">
								<span><%= FormatNumber(oExhibition.FItemList(i).FfavCnt, 0) %></span>
							</button>
						</div>
					</div>
					<div class="txt"> 
						<p><%=oExhibition.FItemList(i).FAddtext1%></p>
						<span><%=oExhibition.FItemList(i).FAddtext2%></span>
					</div>
				</a>
				<p class="brand">
					<a>
						<%= oExhibition.FItemList(i).FBrandName %>
					</a>
				</p>  <!-- for dev msg : 브랜드로 이동 -->
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