<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	dim itemid	:  itemid = requestCheckVar(request("itemid"),9)
	if itemid="" then
		Call Alert_AppClose("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_AppClose("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(itemid)
	end if

    '// 해당 상품 후기에 등록된 전체 이미지를 가져온다.
    Dim rsMem, arrList, imgI, strSql
    strSql = "EXEC db_board.dbo.usp_WWW_Board_ItemEvaluate_ListImageNew_Get "&ItemId
    set rsMem = getDBCacheSQL(dbget, rsget, "ItemEvalImageListNew2", strSql, 60*5)
    IF Not (rsMem.EOF OR rsMem.BOF) THEN
        arrList = rsMem.GetRows
    END IF
    rsMem.close
%>
<link rel="stylesheet" type="text/css" href="/lib/css/temp_m.css?v=1.16" />
<script type="text/javascript">
$(function(){

});
</script>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1>사진 모아보기</h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
        <!-- 포토후기리스트 -->
        <div class="content pop-photo-album" id="layerScroll">
            <div id="scrollarea">
                <div>
                    <ul>
                    <%
                        '// 참고
                        '0-idx
                        '1-userid
                        '2-itemid
                        '3-gubun
                        '4-contents
                        '5-TotalPoint
                        '6-Point_function
                        '7-Point_Design
                        '8-Point_Price
                        '9-Point_satisfy
                        '10-regdate
                        '11-itemoptionname
                        '12-shopname
                        '13-itemoption
                        '14-userlevel
                        '15-img
                    %>
                        <% for imgI = 0 to ubound(arrList,2) %>        
                            <% If arrList(15,imgI) <> "" Then %>
                                <li><a href="" onclick="window.open('/category/pop_ItemEvalPhotoDetail.asp?itemid=<%=itemid%>&idx=<%=arrList(0,imgI)%>');return false;"><span class="thumbnail"><i style="background-image:url(<%=getStonReSizeImg("http://imgstatic.10x10.co.kr/goodsimage/"&GetImageSubFolderByItemid(itemid)&"/"&arrList(15,imgI),200,"",95)%>);"></i></span></a></li>
                            <% End If %>
                        <% next %>
                    </ul>
                </div>
            </div>
        </div>
        <!-- //포토후기리스트-->
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->