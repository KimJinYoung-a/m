<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 스토리 2020 다꾸톡톡 태그한 상품 리스트
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
    dim LoginUserid, i, vPrevRegDate, pageSize, currPage, refer, MasterIdx

    LoginUserid = getEncLoginUserID()
    refer 		= request.ServerVariables("HTTP_REFERER") '// 레퍼러
    MasterIdx   = request("MasterIdx")

    dim oDaccuTokTokDetailItemList
    set oDaccuTokTokDetailItemList = new CDaccuTokTok
    oDaccuTokTokDetailItemList.FRectUserID = LoginUserid
    oDaccuTokTokDetailItemList.FRectMasterIdx = MasterIdx
    oDaccuTokTokDetailItemList.GetDaccuTokTokDetailItemList
%>
    <% If oDaccuTokTokDetailItemList.FResultCount > 0 Then  %>
        <% FOR i = 0 to oDaccuTokTokDetailItemList.FResultCount-1 %>
            <li>
                <div class="item-wrap">
                    <span class="thumbnail"><img src="<%=oDaccuTokTokDetailItemList.FItemList(i).FDetailListImage120%>?cmd=thumbnail&w=400&h=400&fit=true&ws=false" alt=""></span>
                    <div class="desc">
                        <div class="name multi-ellipsis"><%=oDaccuTokTokDetailItemList.FItemList(i).FDetailItemName%></div>
                        <% If Trim(oDaccuTokTokDetailItemList.FItemList(i).FDetailItemOptionName) <> "" Then %>
                            <div class="item-option ellipsis"><%=oDaccuTokTokDetailItemList.FItemList(i).FDetailItemOptionName%></div>
                        <% End If %>
                        <div class="brand"><%=oDaccuTokTokDetailItemList.FItemList(i).FDetailBrandName%></div>
                    </div>
                </div>
            </li>
        <% Next %>
    <% Else %>
        <li>
            상단 이미지를 태그하여 상품을 선택해주세요.
        </li>
    <% End If %>
<%
    set oDaccuTokTokDetailItemList = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->