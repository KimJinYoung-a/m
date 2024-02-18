<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 18주년 이벤트 타인의 취향 리스트
' History : 2019-09-27 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/event/18th/lib/classes/tasteCls.asp" -->
<%
    dim i, vPrevRegDate, pageSize, currPage, refer, chasu, masteridx, shapesNum, rndImageNumber

    pageSize    = 8
    shapesNum   = 1
    currPage    = request("currPage")
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
    chasu       = request("otherchasu")
    masteridx   = request("otherMasterIdx")

    If Trim(currPage) = "" Then
        currPage = 1
    End If

    Dim oTasteUserImportFidx    
    If IsUserLoginOK() Then

        '// 로그인 한 유저의 타인의취향 폴더 fidx값을 가져옴.
        Set oTasteUserImportFidx = new CTaste
        oTasteUserImportFidx.FRectFolderName = "타인의취향"
        oTasteUserImportFidx.FRectUserID = getLoginUserid
        oTasteUserImportFidx.GetUserWishFolderFidxImport
    End If

    dim oTasteOtherUserList
    set oTasteOtherUserList = new CTaste
    oTasteOtherUserList.FPageSize       = pageSize
    oTasteOtherUserList.FCurrPage       = currPage
    oTasteOtherUserList.FRectChasu      = chasu
    oTasteOtherUserList.FRectMasterIdx  = masteridx
    If IsUserLoginOK() Then
        oTasteOtherUserList.FRectUserID     = getLoginUserid
        oTasteOtherUserList.FRectFolderIdx  = oTasteUserImportFidx.FOneItem.FFolderIdx
    End If
    oTasteOtherUserList.GetTasteUserList
%>
    <% If oTasteOtherUserList.FResultCount > 0 Then  %>
        <% FOR i = 0 to oTasteOtherUserList.FResultCount-1 %>
            <%' for dev msg 8개의 li가 한세트 입니다. %>
            <%' 3번째 8번째 도형 추가 %>
            <% If shapesNum = 3 Or shapesNum = 8 Then %>
                <%
                    randomize()
                    rndImageNumber = Int((10*Rnd)+1)
                %>
                <li class="othr-item figure" style="background-image: url('//webimage.10x10.co.kr/fixevent/event/2019/18th/m/img_fg<%=rndImageNumber%>.png');">
                    <div class="thumbnail"></div>
                </li>
                <li class="othr-item">
                    <a href="" onclick="fnAPPpopupProduct('<%=oTasteOtherUserList.FItemList(i).FDetailItemId%>');return false;"><div class="thumbnail"><img src="<%=oTasteOtherUserList.FItemList(i).FBasicImage%>?cmd=thumb&w=300&h=300&fit=true&ws=false" alt=""></div></a>
                    <button class="btn-wish<% If oTasteOtherUserList.FItemList(i).FFolderIdx="" Or ISNULL(oTasteOtherUserList.FItemList(i).FFolderIdx) Then%>" onclick="fnOtherTasteWishAct('<%=oTasteOtherUserList.FItemList(i).FDetailItemId%>',this);return false;"<% Else %> on" onclick="fnOtherTasteWishAct('<%=oTasteOtherUserList.FItemList(i).FDetailItemId%>',this);return false;"<% End If %>></button>
                </li>                   
            <% Else %>
                <li class="othr-item">
                    <a href="" onclick="fnAPPpopupProduct('<%=oTasteOtherUserList.FItemList(i).FDetailItemId%>');return false;"><div class="thumbnail"><img src="<%=oTasteOtherUserList.FItemList(i).FBasicImage%>?cmd=thumb&w=300&h=300&fit=true&ws=false" alt=""></div></a>
                    <% If IsUserLoginOK() Then %>
                        <button class="btn-wish<% If oTasteOtherUserList.FItemList(i).FFolderIdx="" Or ISNULL(oTasteOtherUserList.FItemList(i).FFolderIdx) Then%>" onclick="fnOtherTasteWishAct('<%=oTasteOtherUserList.FItemList(i).FDetailItemId%>',this);return false;"<% Else %> on" onclick="fnOtherTasteWishAct('<%=oTasteOtherUserList.FItemList(i).FDetailItemId%>',this);return false;"<% End If %>></button>
                    <% Else %>
                        <% if isApp=1 then %>
                            <button class="btn-wish" onclick="calllogin();return false;"></button>
                        <% else %>
                            <button class='btn-wish' onclick='jsChklogin_mobile("","<%=Server.URLencode("/event/18th/")%>");return false;'></button>
                        <% end if %>
                    <% End If %>
                </li>            
            <% End If %>
            <% shapesNum = shapesNum + 1 %>
        <% Next %>||<%=formatnumber(oTasteOtherUserList.FTotalCount, 0)%>
    <% Else %>
        ||0
    <% End If %>
<%
    set oTasteOtherUserList = Nothing
    Set oTasteUserImportFidx = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->