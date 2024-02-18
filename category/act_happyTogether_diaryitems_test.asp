<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
'#######################################################
' Discription : diarystoryitems_test // 72서버
' History : 2018-09-20 원승현 생성
'#######################################################

Dim icnt
Dim sqlStr , rsMem
Dim arrList
Dim cTime : cTime = 60*5
dim dummyName : dummyName = "DHITEM"
dim itemid , itemname , icon1image , basicimage , brandname , makerid
dim sellcash , orgprice , saleyn , sellyn , itemcouponyn , itemcoupontype , itemcouponvalue
dim totalprice , totalsaleper

sqlStr = "EXEC db_diary2010.dbo.usp_WWW_diary_happytogether_get"
set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
    arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
%>
<% if isarray(arrList) Then %>
    <div class="itemAddWrapV16a ctgyBestV16a dairy-prd">
        <div class="bxLGy2V16a">
            <h3><span>다꾸력을 높이는 데코 아이템</span>
            하루의 기록을 특별하게! 함께 구매하면 좋을 환상의 짝꿍들
            </h3>
        </div>
        <div class="bxWt1V16a">
            <ul class="simpleListV16a simpleListV16b">
                <% for icnt = 0 to ubound(arrList,2) %>
                <% if icnt>9 then Exit For %>
                <%
                    itemid          = arrList(0,icnt)
                    itemname        = arrList(1,icnt)
                    icon1image      = webImgUrl & "/image/icon1/" & GetImageSubFolderByItemid(itemid) + "/" & arrList(2,icnt)
                    basicimage      = webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(itemid) + "/" & arrList(3,icnt) 
                    brandname       = arrList(4,icnt) 
                    makerid         = arrList(6,icnt)
                    sellcash        = arrList(5,icnt)
                    orgprice        = arrList(8,icnt)
                    saleyn          = arrList(7,icnt)
                    sellyn          = arrList(9,icnt)
                    itemcouponyn    = arrList(10,icnt)
                    itemcoupontype  = arrList(11,icnt)
                    itemcouponvalue = arrList(12,icnt)

                    If saleyn = "N" and itemcouponyn = "N" Then
                        totalprice = formatNumber(orgPrice,0)
                    End If
                    If saleyn = "Y" and itemcouponyn = "N" Then
                        totalprice = formatNumber(sellCash,0)
                    End If

                    if itemcouponyn = "Y" And itemcouponvalue>0 Then
                        If itemcoupontype = "1" Then
                            totalprice =  formatNumber(sellCash - CLng(itemcouponvalue*sellCash/100),0)
                        ElseIf itemcoupontype = "2" Then
                            totalprice =  formatNumber(sellCash - itemcouponvalue,0)
                        ElseIf itemcoupontype = "3" Then
                            totalprice =  formatNumber(sellCash,0)
                        Else
                            totalprice =  formatNumber(sellCash,0)
                        End If
                    End If

                    If saleyn = "Y" and itemcouponyn = "N" Then
                        If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
                            totalsaleper = CLng((orgPrice-sellCash)/orgPrice*100) &"%"
                        End If
                    ElseIf itemcouponyn = "Y" And itemcouponvalue>0 Then
                        If itemcoupontype = "1" Then
                            totalsaleper = CStr(itemcouponvalue) &"%"
                        End If
                    Else
                            totalsaleper = ""
                    End If
                %>
                    <li>
                        <% if isapp="1" then %>
                            <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diarystory_items','number|itemid','<%=icnt%>|<%=itemid%>',function(bool){if(bool){fnAPPpopupAutoUrl('/category/category_itemprd.asp?itemid=<%=itemid%>&gaparam=diarystory_related_<%=icnt+1%>');}});return false;">
                        <% else %>
                            <a href="/category/category_itemprd.asp?itemid=<%= itemid %>&gaparam=diarystory_related_<%=icnt+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_diarystory_items','number|itemid','<%=icnt%>|<%=itemid%>');">
                        <% end if %>
                            <p><img src="<%=basicimage %>" alt="<%=itemname%>" /></p>
                            <span class="name"><%=itemname%></span>
                            <span class="price">
                                <% = totalprice %>원
                                <% If saleyn="Y" Then %>
                                <em class="cRd1">[<% = totalsaleper %>]</em>
                                <% end if %>
                            </span>
                        </a>
                    </li>
                <% Next %>
            </ul>
        </div>
    </div>
<% end if %>
<%
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->