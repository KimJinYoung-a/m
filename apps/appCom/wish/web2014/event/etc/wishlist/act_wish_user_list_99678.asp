<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'##############################################################
' Description : 소원을 담아봐 이벤트 사용자 리스트 불러오기
' History : 2019-12-26 원승현 생성
'##############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
    dim i, vPrevRegDate, pageSize, currPage, refer, eCode

	eCode		= request("eventCode")
    pageSize    = 8
    currPage    = request("currPage")
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

    If Trim(currPage) = "" Then
        currPage = 1
    End If

    dim oEventWishUserList
    set oEventWishUserList = new Cevent_etc_common_list
    oEventWishUserList.FPageSize       = pageSize
    oEventWishUserList.FCurrPage       = currPage
    oEventWishUserList.Frectevt_code   = eCode
    oEventWishUserList.GetWishFolderEventList
%>
    <% If oEventWishUserList.FResultCount > 0 Then  %>
        <% FOR i = 0 to oEventWishUserList.FResultCount-1 %>
            <li>
                <a href="" onclick="fnAPPpopupProduct('<%=oEventWishUserList.FItemList(i).fItemId%>');return false;">
                    <div class="thumbnail"><img src="<%=oEventWishUserList.FItemList(i).FImageBasic%>?cmd=thumb&w=300&h=300&fit=true&ws=false" alt=""></div>
                </a>
            </li>
        <% Next %>||<%=formatnumber(oEventWishUserList.FTotalCount, 0)%>
    <% Else %>
        ||0
    <% End If %>
<%
    set oEventWishUserList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->