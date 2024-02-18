<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2020 다꾸톡톡 주문리스트
' History : 2019-09-09 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2020/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2020/lib/classes/daccutoktokCls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    dim LoginUserid, i, vPrevRegDate, pageSize, currPage, refer, oldRegDate

    LoginUserid = getEncLoginUserID()
    pageSize = request("pageSize")
    currPage = request("currPage")
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
    oldRegDate = request("oldRegDate")

    dim oDaccuTokTokMyOrder
    set oDaccuTokTokMyOrder = new CDaccuTokTok
    oDaccuTokTokMyOrder.FPageSize = pageSize
    oDaccuTokTokMyOrder.FCurrPage = currPage
    oDaccuTokTokMyOrder.FRectUserID = LoginUserid
    oDaccuTokTokMyOrder.GetDaccuTokTokMyOrderList
%>
    <% If oDaccuTokTokMyOrder.FResultCount > 0 Then  %>
        <% FOR i = 0 to oDaccuTokTokMyOrder.FResultCount-1 %>
            <% If i = 0 Then %>
                <li>
                    <div class="date"><%=Left(oDaccuTokTokMyOrder.FItemList(i).FOrderRegDate, 4)&"."&Mid(oDaccuTokTokMyorder.FItemList(i).ForderRegDate, 6, 2)&"."&mid(oDaccuTokTokMyOrder.FItemList(i).FOrderRegDate, 9, 2)%> 구매</div>
                    <ul class="dctem-list">
            <% ElseIf vPrevRegDate <> Left(oDaccuTokTokMyOrder.FItemList(i).FOrderRegDate, 10) And i > 0 Then %>
                    </ul>
                </li>
                <li>
                    <div class="date"><%=Left(oDaccuTokTokMyOrder.FItemList(i).FOrderRegDate, 4)&"."&Mid(oDaccuTokTokMyorder.FItemList(i).ForderRegDate, 6, 2)&"."&mid(oDaccuTokTokMyOrder.FItemList(i).FOrderRegDate, 9, 2)%> 구매</div>
                    <ul class="dctem-list">
            <% End If %>
                    <li>
                        <input type="radio" id="item1-<%=i+1%>" name="chk-item">
                        <label for="item1-<%=i+1%>" class="item-wrap" onclick="clickOrderList('<%=oDaccuTokTokMyOrder.FItemList(i).ForderItemId%>','<%=oDaccuTokTokMyOrder.FItemList(i).FOrderItemOption%>');">
                            <%' 정방형 이미지 %> <span class="thumbnail"> <img src="<%=oDaccuTokTokMyOrder.FItemList(i).FOrderListImage120%>?cmd=thumbnail&w=400&h=400&fit=true&ws=false" alt=""></span>
                            <div class="desc">
                                <div class="name"><%=oDaccuTokTokMyOrder.FItemList(i).FOrderItemName%></div>
                                <% If Trim(oDaccuTokTokMyOrder.FItemList(i).FOrderItemOptionName) <> "" Then %>
                                    <div class="item-option ellipsis"><%=oDaccuTokTokMyOrder.FItemList(i).FOrderItemOptionName%></div>
                                <% End If %>
                                <div class="brand"><%=oDaccuTokTokMyOrder.FItemList(i).FOrderBrandName%></div>
                            </div>
                        </label>
                    </li>

            <% vPrevRegDate = Left(oDaccuTokTokMyOrder.FItemList(i).FOrderRegDate, 10) %>
        <% Next %>
    <% Else %>
        <li>
            구매한 내역이 없습니다.
        </li>
    <% End If %>
<%
    set oDaccuTokTokMyOrder = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->