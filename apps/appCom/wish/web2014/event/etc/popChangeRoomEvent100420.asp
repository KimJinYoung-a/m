<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 바꿔방 이벤트 상품 리스트 팝업 페이지
' History : 2020-02-05 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    '// 특정 이벤트 코드에 들어 있는 이벤트 그룹 상품을 가져와 사용자에게 뿌려준다.

	Dim vTypeCode, chgRoomItemList, sqlStr, evtItemCode, i, vTypeNumber, vTypeNameKor
	Dim vType : vType = ReplaceRequestSpecialChar(request("vType"))

    '// 이번 이벤트에 사용되는 코드
    IF application("Svr_Info") = "Dev" THEN
        evtItemCode = "90447"
    Else
        evtItemCode = "100385"
    End If

    Select Case Trim(vType)
        Case "table"
            IF application("Svr_Info") = "Dev" THEN
                vTypeCode = "258571"
            Else
                vTypeCode = "314517"
            End If
            vTypeNumber = "type1"
            vTypeNameKor = "테이블"                
        Case "light"
            IF application("Svr_Info") = "Dev" THEN            
                vTypeCode = "258572"
            Else
                vTypeCode = "314519"
            End If
            vTypeNumber = "type2"    
            vTypeNameKor = "조명"                                        
        Case "wardrobe"
            IF application("Svr_Info") = "Dev" THEN
                vTypeCode = "258578"
            Else
                vTypeCode = "314516"
            End If
            vTypeNumber = "type3"
            vTypeNameKor = "옷장"
        Case "bed"
            IF application("Svr_Info") = "Dev" THEN            
                vTypeCode = "258579"
            Else
                vTypeCode = "314515"
            End If
            vTypeNumber = "type4"            
            vTypeNameKor = "침대"                
        Case "bedding"
            IF application("Svr_Info") = "Dev" THEN                        
                vTypeCode = "258580"                
            Else
                vTypeCode = "314518"
            End If
            vTypeNumber = "type5"
            vTypeNameKor = "패브릭"                
        Case "chair"
            IF application("Svr_Info") = "Dev" THEN
                vTypeCode = "258581"
            Else
                vTypeCode = "314882"
            End If
            vTypeNumber = "type6"            
            vTypeNameKor = "의자"                
        Case Else
            vTypeCode = ""
            vTypeNumber = ""
            vTypeNameKor = ""
    End Select

    If vTypeCode = "" Then
        Response.write "<script>alert('정상적인 경로로 접근해 주세요.');fnAPPclosePopup();"
        Response.End
    End If

    If vType = "" Then
        Response.write "<script>alert('정상적인 경로로 접근해 주세요.');fnAPPclosePopup();"
        Response.End
    End If

    sqlStr = ""
    sqlStr = sqlStr & " SELECT TOP 100 "
    sqlStr = sqlStr & "	 ei.evt_code	"
    sqlStr = sqlStr & "	 , ei.itemid	"
    sqlStr = sqlStr & "  , ei.evtgroup_code	"
    sqlStr = sqlStr & "  , i.itemid AS itemTableItemID "
    sqlStr = sqlStr & "  , i.itemname "
    sqlStr = sqlStr & "  , i.dispcate1 "
    sqlStr = sqlStr & "  , i.sellcash "
    sqlStr = sqlStr & "  , i.buycash "
    sqlStr = sqlStr & "  , i.orgprice "
    sqlStr = sqlStr & "  , i.orgsuplycash "
    sqlStr = sqlStr & "  , i.smallimage "
    sqlStr = sqlStr & "  , i.listimage "
    sqlStr = sqlStr & "  , i.listimage120 "
    sqlStr = sqlStr & "  , i.basicimage "
    sqlStr = sqlStr & "  , i.icon1image "
    sqlStr = sqlStr & "  , i.icon2image "
    sqlStr = sqlStr & "  FROM db_event.dbo.tbl_eventitem ei WITH(NOLOCK) "
    sqlStr = sqlStr & "  LEFT JOIN db_item.dbo.tbl_item i WITH(NOLOCK) ON ei.itemid = i.itemid "
    sqlStr = sqlStr & "  WHERE evt_code='"&evtItemCode&"' AND evtgroup_code='"&vTypeCode&"' AND evtitem_isUsing=1 And evtitem_isDisp_mo=1"
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
    if not rsget.EOF then
        chgRoomItemList = rsget.getRows()	
    end if
    rsget.close
%>
<style>
.select-item {padding:2.4rem 3.2rem 1rem; background:#fffefa}
.select-item h2 {margin-bottom:2.56rem; padding:.2rem 0 0 .8rem; font-size:1.34rem; font-weight:900; line-height:1.34rem;  border-left:.34rem solid #ff601a;}
.select-item h2 b {color:#ff601a;}
.select-item .item-list {overflow:hidden;}
.select-item .item-list li {float:left; width:50%; text-align:center;}
.select-item .item-list li:nth-child(even) {padding-left:3%;}
.select-item .item-list li:nth-child(odd) {padding-right:3%;}
.select-item .item-list li .thumbnail {overflow:hidden; border-radius:.43rem;}
.select-item .item-list .btn-select {position:relative; top:-.2rem; display:inline-block; height:1.9rem; margin-left:.85rem; padding:0 .7rem; font-size:1rem; line-height:2rem; font-weight:600; color:#fff; background:#c6c6c6; border-radius:.42rem;}
.select-item .item-list li .btn-select {background:#ff601a;}
.select-item .item-list li p {padding:1.02rem 0 2.13rem; font-size:1rem; font-weight:bold;}
.select-item .item-list li p b {letter-spacing:-.1rem; padding-right:.2rem;  vertical-align:middle; font-size:1.3rem;  font-family:'CoreSansCMedium';}
.select-item .type2 h2 {border-color:#8830ff;}
.select-item .type2 h2 b {color:#8830ff;}
.select-item .type2 .item-list li .btn-select {background:#8830ff;}
.select-item .type3 h2 {border-color:#02ac54;}
.select-item .type3 h2 b {color:#02ac54;}
.select-item .type3 .item-list li .btn-select {background:#02ac54;}
.select-item .type4 h2 {border-color:#ff75d0;}
.select-item .type4 h2 b {color:#ff75d0;}
.select-item .type4 .item-list li .btn-select {background:#ff75d0;}
.select-item .type5 h2 {border-color:#2da9ff;}
.select-item .type5 h2 b {color:#2da9ff;}
.select-item .type5 .item-list li .btn-select {background:#2da9ff;}
.select-item .type6 h2 {border-color:#ffbf25;}
.select-item .type6 h2 b {color:#ffbf25;}
.select-item .type6 .item-list li .btn-select {background:#ffbf25;}
</style>
<script type="text/javascript">
    $(function () {
        $(".item-list li").click(function(){
            $(".item-list li").removeClass("on");
            $(this).addClass("on");
        });
    });

    function fnCallParentfnSetChangeRoomArea(iurl, itemid, sellprice) {
        <% IF application("Svr_Info") = "Dev" THEN %>
            opener.parent.fnSetChangeRoomArea(""+iurl+"",""+itemid+"",""+sellprice+"","<%=vtype%>");
            window.close();
        <% Else %>
            fnAPPopenerJsCallClose("fnSetChangeRoomArea('"+iurl+"','"+itemid+"','"+sellprice+"','<%=vtype%>')");
        <% End If %>
    }
</script>
</head>
<body class="default-font body-popup select-item">
    <%' contents %>
    <div id="content" class="content <%=vTypeNumber%>">
        <h2>아래 <b><%=vTypeNameKor%></b> 중 원하는 상품을 골라주세요</h2>
        <% If isArray(chgRoomItemList) Then %>
            <ul class="item-list">
                <%
                    '//chgRoomItemList값
                    '// 0 - evt_code
                    '// 1 - itemid
                    '// 2 - evtgroup_code
                    '// 3 - itemTableItemID
                    '// 4 - itemname
                    '// 5 - dispcate1
                    '// 6 - sellcash
                    '// 7 - buycash
                    '// 8 - orgprice
                    '// 9 - orgsuplycash
                    '// 10 - smallimage
                    '// 11 - listimage
                    '// 12 - listimage120
                    '// 13 - basicimage
                    '// 14 - icon1image
                    '// 15 - icon2image
                %>
                <% For i=0 to uBound(chgRoomItemList,2) %>
                <li>
                    <div class="thumbnail"><img src="<%= getThumbImgFromURL("//webimage.10x10.co.kr/image/basic/"&GetImageSubFolderByItemid(chgRoomItemList(1,i))&"/"&chgRoomItemList(13,i),300,300,"true","false") %>" onclick="fnAPPpopupProduct('<%=chgRoomItemList(1,i)%>');return false;"></div>
                    <p><b><%=Formatnumber(chgRoomItemList(6,i), 0)%></b>원<button type="button" class="btn-select" onclick="fnCallParentfnSetChangeRoomArea('//webimage.10x10.co.kr/image/basic/<%=GetImageSubFolderByItemid(chgRoomItemList(1,i))%>/<%=chgRoomItemList(13,i)%>','<%=chgRoomItemList(1,i)%>','<%=chgRoomItemList(6,i)%>');">선택하기</button></p>
                </li>
                <% Next %>
            </ul>
        <% Else %>
            <script>alert('등록된 상품이 없습니다.');fnAPPclosePopup();</script>
        <% End If %>
    </div>
    <%' //contents %>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->
