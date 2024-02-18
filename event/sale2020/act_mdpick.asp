<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/sale2020/sale2020Cls.asp" -->
<%
'####################################################
' Description : 정기세일 기획전 MDPICK
' History : 2020-03-20 이종화
'####################################################
Dim lprevDate , sqlStr , arrMdpick , i 
Dim image , itemname , itemid , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn , tentenimg400
Dim coupontype , newyn , limitno , limitdispyn , makerid , brandname , gubun , linkurl, frontimg
Dim rt_mdpick , rt_new , rt_best , rt_sale , htmlstr'// 2016년 1 2 4 3
Dim rt_mdpick_c , rt_new_c , rt_best_c , rt_sale_c '// 컨텐츠
Dim CtrlTime : CtrlTime = hour(time)
Dim tempnum : tempnum = 1
Dim tempgubun
Dim itemdiv , saleper 'deal 상품용
'미리보기용 변수
dim currentDate, testdate


testdate = request("testdate")
if testdate <> "" Then
	currentDate = cdate(testdate) 
end if

dim mainImage

Dim mdpick, newarrival , bestseller , onsale , tagname , bestyn, isLowestPrice
Dim evalCnt , favcount , totalpoint

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
            fngaParam = "&gaparam=today_mdpick_" ''//MDPICK
        ElseIf gubun = 2 Then
            fngaParam = "&gaparam=today_new_" ''//NEW
        ElseIf gubun = 3 Then
            fngaParam = "&gaparam=today_best_" ''//BEST
        ElseIf gubun = 4 Then
            fngaParam = "&gaparam=today_sale_" ''//SALE
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

    Dim mdpickAB : mdpickAB = Session.SessionID Mod 2
    '// app 만 실험

    sqlStr = "db_sitemaster.dbo.usp_Ten_Mdpick_ItemListGet "
    
    dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,dummyName,sqlStr,cTime)
    If Not rsMem.EOF Then
        arrMdpick 	= rsMem.GetRows
    End if
    rsMem.close

If isArray(arrMdpick) and not(isnull(arrMdpick)) Then
%>
<div class="item-head">
    <p class="headline">MD Pick</p>
    <p class="sub">MD가 주목하는 상품을 추천합니다!</p>
</div>
<ul class="items type-list">
<%
    FOR i=0 to ubound(arrMdpick,2)
        IF arrMdpick(22,i) = 1 THEN '// mdpick 만

            itemname		= db2Html(arrMdpick(5,i))
            itemid			= trim(arrMdpick(2,i))
            sellCash		= arrMdpick(11,i)
            orgPrice		= arrMdpick(12,i)
            sailYN			= arrMdpick(13,i)
            couponYn		= arrMdpick(14,i)
            couponvalue 	= arrMdpick(15,i)
            LimitYn			= arrMdpick(16,i)
            coupontype		= arrMdpick(17,i)
            newyn			= arrMdpick(10,i)
            limitno			= arrMdpick(18,i)
            limitdispyn 	= arrMdpick(19,i)
            makerid			= arrMdpick(20,i)
            brandname		= arrMdpick(21,i)
            gubun			= arrMdpick(22,i) '//gubun mdpick , rookie , chance , best
            itemdiv			= arrMdpick(24,i)
            saleper			= arrMdpick(25,i)
            frontimg		= arrMdpick(26,i)
            isLowestPrice	= arrMdpick(27,i)
            evalCnt     	= arrMdpick(28,i)
            favcount    	= arrMdpick(29,i)
            totalpoint  	= arrMdpick(30,i)
            If Trim(isLowestPrice) = "" or ISNULL(isLowestPrice) or Trim(isLowestPrice)="N" Then
                isLowestPrice = 0
            Else
                isLowestPrice = 1
            End If

			If itemdiv = "21" Then
				if instr(db2Html(arrMdpick(6,i)),"/") > 0 then
					tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
					image		= webImgUrl & "/image/basic/" + db2Html(arrMdpick(6,i))
				Else
					tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
					image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
				End If
			Else
				tentenimg400= webImgUrl & "/image/tenten400/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(23,i))
				image		= webImgUrl & "/image/basic/" + GetImageSubFolderByItemid(db2Html(arrMdpick(2,i))) + "/" + db2Html(arrMdpick(6,i))
			End If 

            If frontimg <> "" Then
                mainImage = frontimg
            Else
                If application("Svr_Info") = "Dev" Then
                    mainImage = chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,image)
                Else
                    mainImage = chkiif(Not(isnull(tentenimg400) Or tentenimg400 = ""),tentenimg400,getThumbImgFromURL(image,200,200,"true","false"))
                End If 
            End if
%>
    <li>
        <% If isapp="1" Then %>
            <a href="" onclick="fnAPPpopupAutoUrl('/category/category_itemPrd.asp?itemid=<%=itemid%>');return false;">
        <% Else %>
            <a href="/category/category_itemprd.asp?itemid=<%=itemid%>">
        <% End If %>
            <div class="thumbnail">
                <img src="<%=mainImage%>" alt="" />
                <div class="badge"><%=i+1%></div>
            </div>
            <div class="desc">
                <div class="price-area">
                    <%
                    If itemdiv = "21" Then 
						response.write "<span class=""price"">"&formatNumber(sellCash,0) &"</span>"
						If saleper > 0 Then
						response.write "<b class=""discount sale"">"& saleper &"%</b>"
						End If
					else
						If sailYN = "N" and couponYn = "N" Then
							response.write "<span class=""price"">"&formatNumber(orgPrice,0) &"</span>"
						End If
						If sailYN = "Y" and couponYn = "N" Then
							response.write "<span class=""price"">"&formatNumber(sellCash,0) &"</span>"
						End If
						if couponYn = "Y" And couponvalue>0 Then
							If coupontype = "1" Then
							response.write "<span class=""price"">"&formatNumber(sellCash - CLng(couponvalue*sellCash/100),0) &"</span>"
							ElseIf coupontype = "2" Then
							response.write "<span class=""price"">"&formatNumber(sellCash - couponvalue,0) &"</span>"
							ElseIf coupontype = "3" Then
							response.write "<span class=""price"">"&formatNumber(sellCash,0) &"</span>"
							Else
							response.write "<span class=""price"">"&formatNumber(sellCash,0) &"</span>"
							End If
						End If
						If sailYN = "Y" And couponYn = "Y" Then
							If coupontype = "1" Then
								'//할인 + %쿠폰
								response.write "<b class=""discount sale"">"& CLng((orgPrice-(sellCash - CLng(couponvalue*sellCash/100)))/orgPrice*100)&"%</b>"
							ElseIf coupontype = "2" Then
								'//할인 + 원쿠폰
								response.write "<b class=""discount sale"">"& CLng((orgPrice-(sellCash - couponvalue))/orgPrice*100)&"%</b>"
							Else
								'//할인 + 무배쿠폰
								response.write "<b class=""discount sale"">"& CLng((orgPrice-sellCash)/orgPrice*100)&"%</b>"
							End If 
						ElseIf sailYN = "Y" and couponYn = "N" Then
							If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
								response.write "<b class=""discount sale"">"& CLng((orgPrice-sellCash)/orgPrice*100)&"%</b>"
							End If
						elseif sailYN = "N" And couponYn = "Y" And couponvalue>0 Then
							If coupontype = "1" Then
								response.write "<b class=""discount coupon"">"& CStr(couponvalue) & "%</b>"
							Else
								response.write "<b class=""discount coupon"">"& couponvalue &"%</b>"
							End If
						End If
					End If 
                    %>
                </div>
                <p class="name"><%=itemname%></p>
                <span class="brand"><%=brandname%></span>
            </div>
            <div class="etc">
            <% if evalcnt > 0 then %>
                <div class="tag review"><span class="icon icon-rating"><i style="width:<%=fnEvalTotalPointAVG(totalpoint,"")%>%;">리뷰 종합 별점</i></span><span class="counting" title="리뷰 갯수"><%=chkIIF(evalcnt>999,"999+",evalcnt)%></span></div>
            <% end if %>
                <button class="tag wish btn-wish">
                    <%
                    If favcount > 0 Then
                        Response.Write "<span class=""icon icon-wish"" id=""wish"&itemid&"""><i class=""hidden""> wish</i></span><span class=""counting"">"& CHKIIF(favcount>999,"999+",formatnumber(favcount,0)) & "</span>"
                    Else
                        Response.Write "<span class=""icon icon-wish"" id=""wish"&itemid&"""><i> wish</i></span><span class=""counting""></span>"
                    End If
                    %>
                </button>
            </div>
        </a>
    </li>
<%
        END IF
	Next
%>
</ul>
<%
End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->