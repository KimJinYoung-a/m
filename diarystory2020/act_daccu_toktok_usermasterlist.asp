<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2020 다꾸톡톡 유저 마스터 리스트
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
    dim i, pageSize, currPage, refer, MasterIdx, oDaccuTalkUserList

    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러

    pageSize = request("pagesize")
    currpage = request("userCurrPage")

    pagesize = 6
    If currpage = "" Then
        currpage = 1
    end if

    set oDaccuTalkUserList = new CDaccuTokTok
    oDaccuTalkUserList.FPageSize = pageSize
    oDaccuTalkUserList.FCurrPage = currpage
    oDaccuTalkUserList.GetDaccuTokTokUserMasterList
%>
    <% If oDaccuTalkUserList.FResultCount > 0 Then  %>
        <% FOR i = 0 to oDaccuTalkUserList.FResultCount-1 %>
            <li>
                <a href="" onclick="daccutoktokView('<%=oDaccuTalkUserList.FItemList(i).FUserMasterIdx%>');return false;">
                    <div class="thumbnail">
                        <img src="<%=oDaccuTalkUserList.FItemList(i).FUserMasterImage%>" alt="">
                        <span class="view"><%=formatnumber(oDaccuTalkUserList.FItemList(i).FUserMasterViewCount, 0)%></span>
                    </div>
                    <div class="desc">
                        <div class="tit"><%=oDaccuTalkUserList.FItemList(i).FUserMasterTitle%></div>
                        <div class="user-id"><%=printUserId(oDaccuTalkUserList.FItemList(i).FUserMasterUserId,2,"*")%></div>
                        <div class="day"><%=FormatDate(oDaccuTalkUserList.FItemList(i).FUserMasterRegDate,"00.00.00")%></div>
                    </div>
                </a>
                <% If ((GetEncLoginUserID = oDaccuTalkUserList.FItemList(i).FUserMasterUserId) or (GetEncLoginUserID = "10x10")) and ( oDaccuTalkUserList.FItemList(i).FUserMasterUserId<>"") Then %>
                    <button class="btn-delete" onclick="fnDeleteDaccu('<%=oDaccuTalkUserList.FItemList(i).FUserMasterIdx%>');">삭제</button>
                <% End If %>
            </li>
        <% Next %>
    <% End If %>
<%
    set oDaccuTalkUserList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->