<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<%
'####################################################
' Description : 9월 쇼핑지원 상품 목록
' History : 2020-09-03 허진원
'####################################################
dim eCode, egCode , cEventItem, i
dim page : page = requestCheckVar(request("cpg"),10)
dim gubun : gubun = requestCheckVar(request("gb"),4)
dim pageSize : pageSize = 200
dim iTotCnt
Dim cTime , dummyName

IF application("Svr_Info") = "Dev" THEN
	eCode   = 102219
	Select Case gubun
	Case "sale" : egCode = 258610
	Case "gift" : egCode = 258611
	end Select
Else
	eCode   =  105710	'105514 이벤트의 상품용 코드
	Select Case gubun
	Case "sale" : egCode = 339669
	Case "gift" : egCode = 339670
	end Select
End If

IF page = "" THEN page = 1

'DB Cash TTL (1 minute)
cTime = 60*1
dummyName = "EVTITEMLIST_" & egCode & "_"&Cint(timer/60)


Set cEventItem = new ClsEvtItem
	cEventItem.FECode 	= eCode
	cEventItem.FEGCode 	= egCode
	cEventItem.FEItemCnt= 200
	cEventItem.FItemsort= 5			'0:지정안함(신상), 3:지정번호순, 4:베스트순, 5:고가격순
	cEventItem.fnGetEventItem_v2
	iTotCnt = cEventItem.FTotCnt

IF iTotCnt>0 THEN
    FOR i = 0 TO iTotCnt
%> 
<li <%=chkIIF(cEventItem.FCategoryPrdList(i).IsSoldOut Or cEventItem.FCategoryPrdList(i).isTempSoldOut,"class=""soldout""","")%> style="display:none;">
    <% If isapp="1" Then %>
    <a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=cEventItem.FCategoryPrdList(i).Fitemid%>');return false;">
    <% Else %>
    <a href="/category/category_itemprd.asp?itemid=<%=cEventItem.FCategoryPrdList(i).Fitemid%>">
    <% End If %>
		<div class="thumbnail"><img src="<%=cEventItem.FCategoryPrdList(i).FImageBasic%>" alt="" /></div>
		<div class="desc">
			<div class="price">
				<%=FormatNumber(cEventItem.FCategoryPrdList(i).GetCouponAssignPrice,0)%>
				<% if cEventItem.FCategoryPrdList(i).IsSaleItem AND cEventItem.FCategoryPrdList(i).isCouponItem then %>
				<span>더블할인</span>
				<% elseif cEventItem.FCategoryPrdList(i).IsSaleItem then %>
				<span><%=cEventItem.FCategoryPrdList(i).getSalePro%></span>
				<% elseif cEventItem.FCategoryPrdList(i).isCouponItem then %>
				<span><%=cEventItem.FCategoryPrdList(i).GetCouponDiscountStr%></span>
				<% end if %>
			</div>
			<div class="name"><%=cEventItem.FCategoryPrdList(i).FItemName%></div>
			<div class="brand"><%=cEventItem.FCategoryPrdList(i).FBrandName%></div>
			<% if cEventItem.FCategoryPrdList(i).FEvalcnt > 0 then %>
			<div class="review">
				<span class="rating"><i style="width:<%=fnEvalTotalPointAVG(cEventItem.FCategoryPrdList(i).FPoints,"search")%>%;"></i></span>
			</div>
			<% end if %>
		</div>
    </a>
</li>
<% 
    NEXT 
END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->