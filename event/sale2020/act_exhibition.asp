<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/sale2020/sale2020Cls.asp" -->
<%
'####################################################
' Description : 정기세일 기획전
' History : 2020-03-20 이종화
'####################################################
dim oExhibition , i
dim arrExhibitionLists
dim pageSize : pageSize = 20
dim eventId , eventMobileImage , eventTitle , eventSubTitle , eventSalePercent , eventCouponPercent
dim isSale , isCoupon
dim eName , eNameredsale

set oExhibition = new sale2020Cls
    arrExhibitionLists = oExhibition.getMainExhibitionListsForMobile()
set oExhibition = nothing 

IF isArray(arrExhibitionLists) THEN
%>
<ul class="item-card">
<%
    FOR i = 0 TO Ubound(arrExhibitionLists,2)
        eventId             = arrExhibitionLists(0,i)
        eventMobileImage    = arrExhibitionLists(1,i)
        eventTitle          = arrExhibitionLists(2,i)
        eventSubTitle       = arrExhibitionLists(3,i)
        eventSalePercent    = arrExhibitionLists(4,i)
        eventCouponPercent  = arrExhibitionLists(5,i)
        isSale              = arrExhibitionLists(6,i)
        isCoupon            = arrExhibitionLists(7,i)

        If isSale Or isCoupon Then
            if ubound(Split(eventTitle,"|"))> 0 Then
                If isSale Or (isSale And isCoupon) then
                    eName	= cStr(Split(eventTitle,"|")(0))
                    eNameredsale	= "<em class=""discount sale"">"& cStr(Split(eventTitle,"|")(1)) &"</em>"
                ElseIf isCoupon Then
                    eName	= cStr(Split(eventTitle,"|")(0))
                    eNameredsale	= "<em class=""discount coupon""> + "& cStr(Split(eventTitle,"|")(1)) &"</em>"
                End If
            Else
                eName = eventTitle
                eNameredsale	= ""
            end If
        Else
            eName = eventTitle
            eNameredsale	= ""
        End If
%> 
    <li>
        <a href=<%=chkiif(isapp = "1" ,"javascript:fnAPPpopupEvent('" & eventId & "'); return false;" ,"javascript:TnGotoEventMain('" & eventId & "'); return false;")%>>
            <div class="thumbnail">
                <img src="<%=eventMobileImage%>" alt="">
            </div>
            <div class="desc">
                <div class="tit ellipsis"><%=eName%></div>
                <div class="subcopy">
                    <span><%=eventSubTitle%></span>
                    <%=eNameredsale%>
                </div>
            </div>
        </a>
    </li>
<% 
    NEXT 
%>
</ul>
<%
END IF
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->