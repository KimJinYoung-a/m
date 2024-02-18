<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<% Server.ScriptTimeOut = 120 %>
<%
'####################################################
' Description : 바꿔방 응모 유저 리스트
' History : 2020-02-07 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
    Dim i, pageSize, currPage, refer, eCode, sqlStr
    Dim TotalCount, TotalPage, ResultCount
    Dim changeRoomUserList

    pageSize    = 8
    currPage    = request("currPage")
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
    eCode       = request("eventcode")

    If Trim(currPage) = "" Then
        currPage = 1
    End If

    sqlStr = " SELECT evt.evt_code, evt.userid, evt.sub_opt2, evt.sub_opt3, ei.itemid, ei.category, ei.sellcash "
    sqlStr = sqlStr & " ,i.itemname, i.basicimage, i.smallimage, i.listimage, i.listimage120, i.icon1image, i.icon2image "
    sqlStr = sqlStr & " FROM ( "
    sqlStr = sqlStr & "         SELECT sub_idx, evt_code, userid, sub_opt2, sub_opt3, regdate, device "
    sqlStr = sqlStr & "             ,( SELECT TOP 1 itemid FROM db_temp.dbo.tbl_EventUserItemSelect WITH(NOLOCK) "    
    sqlStr = sqlStr & "               WHERE userid = e.userid AND evt_code = e.evt_code ORDER BY NEWID() "
    sqlStr = sqlStr & "             ) AS UserItemId "
    sqlStr = sqlStr & "         FROM db_event.dbo.tbl_event_subscript e WITH(NOLOCK) "
    sqlStr = sqlStr & "         WHERE evt_code='"&eCode&"' "
    sqlStr = sqlStr & "     )evt "
    sqlStr = sqlStr & " LEFT JOIN db_temp.dbo.tbl_EventUserItemSelect ei WITH(NOLOCK) ON evt.userid = ei.userid AND evt.UserITemId = ei.itemid "
    sqlStr = sqlStr & "     AND evt.evt_code = ei.evt_code "
    sqlStr = sqlStr & " LEFT JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON ei.itemid = i.itemid "     
    sqlStr = sqlStr & " ORDER BY evt.regdate DESC "
    sqlStr = sqlStr & " OFFSET ("&currPage&"-1)*"&pagesize&" ROWS FETCH NEXT "&pagesize&" ROWS ONLY "    
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

    if  not rsget.EOF  then
        changeRoomUserList = rsget.getRows()
    Else
        changeRoomUserList = ""        
    end if
    rsget.Close

    function getEvent100420CategoryName(category)
        Select Case Trim(category)
            Case "table"
                getEvent100420CategoryName = "테이블"
            Case "light"
                getEvent100420CategoryName = "조명"                
            Case "wardrobe"
                getEvent100420CategoryName = "옷장"        
            Case "bed"
                getEvent100420CategoryName = "침대"        
            Case "bedding"
                getEvent100420CategoryName = "페브릭"        
            Case "chair"
                getEvent100420CategoryName = "의자"
            Case Else
                getEvent100420CategoryName = "테이블"
        End Select
    End Function
%>
    <% If isArray(changeRoomUserList) Then %>
        <%
            '//changeRoomUserList값
            '// 0 - evt_code
            '// 1 - userid
            '// 2 - sub_opt2
            '// 3 - sub_opt3
            '// 4 - itemid
            '// 5 - category
            '// 6 - sellcash
            '// 7 - itemname
            '// 8 - basicimage
            '// 9 - smallimage
            '// 10 - listimage
            '// 11 - listimage120
            '// 12 - icon1image
            '// 13 - icon2image
            '// 14 - regdate
        %>    
        <% For i=0 to uBound(changeRoomUserList,2) %>
            <li>
                <div class="thumbnail"><a href="" onclick="TnGotoProduct('<%=changeRoomUserList(4,i)%>');return false;"><img src="<%= getThumbImgFromURL("//webimage.10x10.co.kr/image/icon1/"&GetImageSubFolderByItemid(changeRoomUserList(4,i))&"/"&changeRoomUserList(12,i),300,300,"true","false") %>"></a></div>
                <p><%=chrbyte(printUserId(changeRoomUserList(1,i),2,"*"), 10, "Y")%>님의 <b><%=getEvent100420CategoryName(changeRoomUserList(5,i))%></b></p>
            </li>
        <% Next %>
        ||1
    <% Else %>
        ||0
    <% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->