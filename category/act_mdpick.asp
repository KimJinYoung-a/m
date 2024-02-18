<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%

Dim gubun, sqlStr, arrMdpick, i, itemname, itemid, sellCash, orgPrice, sailYN, couponYn, couponvalue, LimitYn, coupontype, newyn, limitno, limitdispyn
Dim makerid, brandname, itemdiv, saleper, tagname, tempgubun, tempnum, image, tentenimg400, reqItemId

reqItemId = getNumeric(requestCheckVar(request("itemid"),9))

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MDPICK_"&Cint(timer/60)
Else
'	cTime = 60*5
	cTime = 1*1
	dummyName = "MDPICK"
End If

''//fngaparam 
function fngaParam(gubun)
	if gubun = "" then exit Function
	If gubun = 1 Then
		fngaParam = "&gaparam=in_product_mdpick_" ''//MDPICK
	End If 
end Function

'// 세일 상품 여부 '! 
public Function IsSaleItem() 
	IsSaleItem = ((FSaleYn="Y") and (FOrgPrice-FSellCash>0)) 
end Function

'// 신상품 여부 '! 
public Function IsNewItem() 
	IsNewItem =	(datediff("d",FRegdate,now())<= 14)
end Function

sqlStr = "db_sitemaster.dbo.usp_Ten_Mdpick_ItemListGet "
dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
If Not rsMem.EOF Then
    arrMdpick 	= rsMem.GetRows
End if
rsMem.close

on Error Resume Next

If isArray(arrMdpick) and not(isnull(arrMdpick)) Then
%>
    <div class="itemAddWrapV16a ctgyBestV16a">
        <div class="bxLGy2V16a">
            <h3><strong>MD가 주목한 바로 그 상품!</strong></h3>
        </div>
        <div class="bxWt1V16a">
            <ul class="simpleListV16a simpleListV16b">
<%
                FOR i=0 to ubound(arrMdpick,2)
                    If tempnum > 14 Then
                        exit For
                    End If
                    itemname	= db2Html(arrMdpick(5,i))
                    itemid		= trim(arrMdpick(2,i))
                    sellCash	= arrMdpick(11,i)
                    orgPrice	= arrMdpick(12,i)
                    sailYN		= arrMdpick(13,i)
                    couponYn	= arrMdpick(14,i)
                    couponvalue = arrMdpick(15,i)
                    LimitYn		= arrMdpick(16,i)
                    coupontype	= arrMdpick(17,i)
                    newyn		= arrMdpick(10,i)
                    limitno		= arrMdpick(18,i)
                    limitdispyn = arrMdpick(19,i)
                    makerid		= arrMdpick(20,i)
                    brandname	= arrMdpick(21,i)
                    gubun		= arrMdpick(22,i) '//gubun mdpick , rookie , chance , best
                    itemdiv		= arrMdpick(24,i)
                    saleper		= arrMdpick(25,i)

                    If itemdiv = "21" Then
                        if instr(arrMdpick(6,i),"/") > 0 then
                            tentenimg400= webImgUrl & "/image/tenten400/" + db2Html(arrMdpick(23,i))
                            image		= webImgUrl & "/image/basic/" + db2Html(arrMdpick(6,i))
                        Else
                            tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
                            image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
                        End If
                    Else
                        tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
                        image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
                    End If 

                    If tempgubun <> gubun Then tempnum = 1

                    tagname = ""
                    If newyn = "Y" Then tagname = "NEW"

                    If gubun = 1 Then
                        If trim(CStr(reqItemId)) <> trim(CStr(itemid)) Then
                            If db2Html(arrMdpick(23,i)) = "" Or isnull(db2Html(arrMdpick(23,i))) Then '//tentenimg
                                tentenimg400 = ""
                            End If
%>
                            <li>
                                <a href="/category/category_itemPrd.asp?itemid=<%=itemid & fngaParam(gubun) & (tempnum)%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_mdpick_in_product','todaymdpicknumber|itemid|categoryname|brand_id','<%=tempnum%>|<%=itemid%>|<%=fnItemIdToCategory1DepthName(itemid)%>|<%=Replace(Replace(brandname," ",""),"'","")%>');">
                                    <% If application("Svr_Info") = "Dev" Then %>
                                        <p><img src="<%=chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,image)%>" alt="<%=CStr(itemname)%>" /></p>
                                    <% Else %>
                                        <p><img src="<%=chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,getThumbImgFromURL(image,200,200,"true","false")) %>" alt="<%=CStr(itemname)%>" /></p>
                                    <% End If%>
                                    <span><%=CStr(itemname)%></span>
                                    <span class="price">
                                        <% If itemdiv = "21" Then %>
                                            <% = formatNumber(sellCash,0) %>원 
                                            <% If saleper > 0 Then %>
                                                <em class="cRd1">[<% = saleper &"%" %>]</em>
                                            <% end if %>
                                        <% Else %>
                                            <%
                                                If sailYN = "N" and couponYn = "N" Then
                                                    Response.Write formatNumber(orgPrice,0)&"원 "
                                                End If
                                                If sailYN = "Y" and couponYn = "N" Then
                                                    Response.Write formatNumber(sellCash,0) &"원 "
                                                End If
                                                if couponYn = "Y" And couponvalue>0 Then
                                                    If coupontype = "1" Then
                                                        Response.Write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &"원 "
                                                    ElseIf coupontype = "2" Then
                                                        Response.Write formatNumber(sellCash - couponvalue,0) &"원 "
                                                    ElseIf coupontype = "3" Then
                                                        Response.Write formatNumber(sellCash,0) &"원 "
                                                    Else
                                                        Response.Write formatNumber(sellCash,0) &"원 "
                                                    End If
                                                End If
                                                If sailYN = "Y" And couponYn = "Y" Then
                                                    If coupontype = "1" Then
                                                        '//할인 + %쿠폰
                                                        Response.Write "<em class='cRd1'>["& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%]</em>"
                                                    ElseIf coupontype = "2" Then
                                                        '//할인 + 원쿠폰
                                                        Response.Write "<em class='cRd1'>["& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%]</em>"
                                                    Else
                                                        '//할인 + 무배쿠폰
                                                        Response.Write "<em class='cRd1'>["& CLng((orgPrice-sellCash)/orgPrice*100)&"%]</em>"
                                                    End If 
                                                ElseIf sailYN = "Y" and couponYn = "N" Then
                                                    If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
                                                        Response.Write "<em class='cRd1'>["& CLng((orgPrice-sellCash)/orgPrice*100)&"%]</em>"
                                                    End If 
                                                elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
                                                    If coupontype = "1" Then
                                                        Response.Write "<em class='cGr1'>["& CStr(couponvalue) & "%]</em>"
                                                    ElseIf coupontype = "2" Then
                                                        Response.Write "<em class='cGr1'>[쿠폰]</em>"
                                                    ElseIf coupontype = "3" Then
                                                        Response.Write "<em class='cGr1'>[쿠폰]</em>"
                                                    Else
                                                        Response.Write "<em class='cGr1'>["& couponvalue &"%]</em>"
                                                    End If 
                                                End If
                                            %>
                                        <% End If %>
                                    </span>
                                </a>
                            </li>
<%
                            tempnum = tempnum + 1
                            tempgubun = gubun '// 구분값
                        End If
                    End If
                Next
%>
            </ul>
        </div>
    </div>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->