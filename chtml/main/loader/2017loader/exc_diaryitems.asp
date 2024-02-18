<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : today_main_diarystory2019_items // cache DB경유
' History : 2018-09-04 이종화 생성
'#######################################################
Dim intI
Dim sqlStr , rsMem , arrList
Dim gaParam : gaParam = "&gaparam=diarystory_today_" '//GA 체크 변수
dim topcount : topcount = 9 '// 노출 상품 갯수

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "MdiaryITEM_"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "MdiaryITEM"
End If

sqlStr = "EXEC db_diary2010.dbo.usp_www_shuffleDiaryItems_Get @topcount= "&topcount
'Response.write sqlStr

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
If IsArray(arrList) and date() > "2018-09-16" Then
%>
<div class="category-item-content bg-grey">
    <section class="category-item-list">
        <h2 class="headline"><span class="icon-diary2019"></span>2019년 다이어리 준비하셨나요?</h2>
        <div class="items">
            <ul>
                <%
                    '2,3,4,5,6,10,14,15,16
                    Dim itemid , basicimage , itemname , sellcash , orgprice , saleyn , itemcouponyn , itemcouponvalue , itemcoupontype
                    dim alink ,link , totalprice , totalsale

                    For intI = 0 To ubound(arrlist,2)

                        itemid          = arrList(2,intI)
                        basicimage      = webImgUrl & "/image/basic/" & GetImageSubFolderByItemid(itemid) &"/"& arrList(3,intI)
                        itemname        = arrList(4,intI)
                        sellcash        = arrList(5,intI)
                        orgprice        = arrList(6,intI)
                        saleyn          = arrList(10,intI)
                        itemcouponyn    = arrList(14,intI)
                        itemcouponvalue = arrList(15,intI)
                        itemcoupontype  = arrList(16,intI)

                        link = "/category/category_itemPrd.asp?itemid="&itemid
                        
                        if isapp then 
                            alink = "fnAmplitudeEventAction('click_diaryitems','diaryitems','"&intI+1&"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& link & gaparam & (intI+1) &"');}});return false;"
                        else
                            alink = link & gaparam & intI+1
                        end if 

                        If saleyn = "N" and itemcouponyn = "N" Then
                            totalprice = formatNumber(orgPrice,0)
                        End If
                        If saleyn = "Y" and itemcouponyn = "N" Then
                            totalprice = formatNumber(sellCash,0)
                        End If
                        if itemcouponyn = "Y" And itemcouponvalue>0 Then
                            If itemcoupontype = "1" Then
                                totalprice = formatNumber(sellCash - CLng(itemcouponvalue*sellCash/100),0)
                            ElseIf itemcoupontype = "2" Then
                                totalprice = formatNumber(sellCash - itemcouponvalue,0)
                            ElseIf itemcoupontype = "3" Then
                                totalprice = formatNumber(sellCash,0)
                            Else
                                totalprice = formatNumber(sellCash,0)
                            End If
                        End If
                        If saleyn = "Y" And itemcouponyn = "Y" And itemcouponvalue>0 Then
                            If itemcoupontype = "1" Then
                                '//할인 + %쿠폰
                                totalsale = "<span class='discount color-red'>"& CLng((orgPrice-(sellCash - CLng(itemcouponvalue*sellCash/100)))/orgPrice*100) &"%</span>"
                            ElseIf itemcoupontype = "2" Then
                                '//할인 + 원쿠폰
                                totalsale = "<span class='discount color-red'>"& CLng((orgPrice-(sellCash - itemcouponvalue))/orgPrice*100)&"%</span>"
                            Else
                                totalsale = "<span class='discount color-red'>"& CLng((orgPrice-sellCash)/orgPrice*100)&"%</span>"
                            End If 
                        ElseIf saleyn = "Y" and itemcouponyn = "N" Then
                            If CLng((orgPrice-sellCash)/orgPrice*100)> 0 Then
                                totalsale = "<span class='discount color-red'>"& CLng((orgPrice-sellCash)/orgPrice*100)&"%</span>"
                            End If
                        elseif saleyn = "N" And itemcouponyn = "Y" And itemcouponvalue>0 Then
                            If itemcoupontype = "1" Then
                                totalsale = "<span class='discount color-green'>"& CStr(itemcouponvalue) & "%</span>"
                            End If
                        Else 
                            totalsale = ""
                        End If
                %>
                    <li>
                        <% if isapp then %>
                        <a href="" onclick="<%=alink%>">
                        <% else %>
                        <a href="<%=alink%>">
                        <% end if %>
                            <div class="thumbnail"><img src="<%=basicimage%>" alt="<%=itemname%>" /></div>
                            <div class="desc">
                                <p class="name"><%=itemname%></p>
                                <div class="price">
                                    <%=totalsale%>
                                    <span class="sum"><%=totalprice%></span>
                                </div>
                            </div>
                        </a>
                    </li>
                <%
                    next
                %>
            </ul>
        </div>
        <div class="btn-group"><% if isapp then %><a href="" onclick="fnAPPpopupBrowserURL('다이어리 스토리','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2019/?gaparam=main_diaryitem_0','right','','sc');return false;" class="btn-plus color-blue"><% else %><a href="/diarystory2019/?gaparam=main_diaryitem_0" class="btn-plus color-blue"><% end if %><span class="icon icon-plus icon-plus-blue"></span> 다이어리 더보기</a></div>
    </section>
</div>
<%
end if 
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->