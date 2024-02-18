<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.Buffer = True
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/foryou/foryouCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%    
	Dim vCurrPage, page 
	
	vCurrPage = RequestCheckVar(Request("cpg"),5)
	
	If vCurrPage = "" Then vCurrPage = 1

dim foryouObj, userCouponType, userCouponValue
dim bannerText, userid
dim gaParam

userid = GetLoginUserID()

set foryouObj = new ForYouCls
	foryouObj.FPageSize = 30
	foryouObj.FCurrPage = vCurrPage
    foryouObj.FrectUserId = userid

	foryouObj.getForyouItemPageList		

dim i, j

if vCurrPage = 1 and foryouObj.FResultCount < 5 Then
    if isapp = 1 then             
        dim strTemp
        strTemp = 	"<script>" & vbCrLf &_
                "alert('정상적인 경로로 접근해주세요.');" & vbCrLf &_
                "calllogin();" & vbCrLf &_
                "</script>"
        Response.Write strTemp                        
    else
        Call Alert_Return("정상적인 경로로 접근해주세요.")
        response.End
    end if
end if

If (foryouObj.FResultCount > 0) Then

    dim firstItemDisp : firstItemDisp = "class=""bigger"""
    dim couponPrice, couponPer, tempPrice, salePer, orgPrice, secretCouponTxt
    dim saleStr, couponStr, tmpEvalArr     

    for i = 0 to foryouObj.FResultCount - 1     

    orgPrice = foryouObj.FItemList(i).Forgprice
    couponPer = foryouObj.GetCouponDiscountStr(foryouObj.FItemList(i).Fitemcoupontype, foryouObj.FItemList(i).Fitemcouponvalue)
    couponPrice = foryouObj.GetCouponDiscountPrice(foryouObj.FItemList(i).Fitemcoupontype, foryouObj.FItemList(i).Fitemcouponvalue, foryouObj.FItemList(i).Fsellcash)                    					
    IF NOT(foryouObj.FItemList(i).Fsellcash = 0 OR foryouObj.FItemList(i).Forgprice = 0) THEN    
        salePer     = CLng( (foryouObj.FItemList(i).Forgprice-foryouObj.FItemList(i).Fsellcash ) / foryouObj.FItemList(i).FOrgPrice*100 )    
    else
        salePer = ""        
    END IF
    gaParam		= "&gaparam=foryou_" & foryouObj.FItemList(i).FForyouType & "_" & foryouObj.FPageSize * (vCurrPage -1) + i + 1 

    if foryouObj.FItemList(i).Fsailyn = "Y" and foryouObj.FItemList(i).Fitemcouponyn = "Y" then '세일, 쿠폰
        tempPrice = foryouObj.FItemList(i).Fsellcash - couponPrice
        saleStr = "<b class=""discount color-red"">"& salePer &"%</b>"
        couponStr = "<b class=""discount"">"&couponPer&"</b>"  						
        orgPrice = "<s>" & FormatNumber(orgPrice, 0) & "</s>"
    elseif foryouObj.FItemList(i).Fitemcouponyn = "Y" then    '쿠폰					
        tempPrice = foryouObj.FItemList(i).Fsellcash - couponPrice
        saleStr = ""
        couponStr = "<b class=""discount"">"&couponPer&"</b>"  
        orgPrice = "<s>" & FormatNumber(orgPrice, 0) & "</s>"
    elseif foryouObj.FItemList(i).Fsailyn = "Y" then  '세일
        tempPrice = foryouObj.FItemList(i).Fsellcash
        saleStr = "<b class=""discount color-red"">"& salePer &"%</b>"
        couponStr = ""    
        orgPrice = "<s>" & FormatNumber(orgPrice, 0) & "</s>"
    else										
        tempPrice = orgPrice
        saleStr = ""
        couponStr = ""             					
        orgPrice = ""
    end if			

    if foryouObj.FItemList(i).FSecretCouponyn = "Y" then	'시크릿쿠폰
        couponStr = "시크릿쿠폰 <b class=""discount"">"&couponPer&"</b>"  						        
    end if 

    if foryouObj.FItemList(i).Fitemcouponvalue = "0" then
        couponStr = ""
    end if					    
%>

    <li <%=chkIIF(i = 0 and vCurrPage = 1, firstItemDisp, "")%>>
    <% if isapp = 1 then %>
        <a href="javascript:fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<%=foryouObj.FItemList(i).Fitemid & gaParam%>');" >
    <% else %>
        <a href="/category/category_itemprd.asp?itemid=<%=foryouObj.FItemList(i).Fitemid & gaParam%>">
    <% end if %> 
            <div class="thumbnail"><img src="<%=foryouObj.FItemList(i).FBasicimage%>" alt="" /></div>
            <div class="desc">
                <p class="name"><%=foryouObj.FItemList(i).Fitemname%></p>									
                <% if saleStr <> "" or couponStr <> "" then %>
                <div class="scr-coupon">										
                    <%=saleStr%>
                    <%=couponStr%>										                    
                </div>
                <% end if %>
                <div class="price">
                    <b class="sum"><%=FormatNumber(tempPrice, 0)%><span class="won">원</span></b>                    
                    <%=orgPrice%>
                </div>
            </div>
        </a>
    </li>			
  
<%
    next
end if
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->