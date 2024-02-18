<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
    Dim i
    Dim itemid	: itemid = requestCheckVar(request("itemid"),9) '// 상품 ID

    Dim oItem : Set oItem = new CatePrdCls '// 상품 Class
    oItem.GetItemData itemid '// 상품정보 가져옴
    Dim vMakerid : vMakerid = oItem.Prd.Fmakerid '// 브랜드 ID

    '// 추가 이미지
	Dim oADD : Set oADD = new CatePrdCls
	oADD.getAddImage itemid

    '// 상품상세설명 동영상 추가
    Set itemVideos = New catePrdCls
    itemVideos.fnGetItemVideos itemid, "video1"
%>
<%
    Function ImageExists(byval iimg)
		If (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		Else
			ImageExists = true
		End if
	End Function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<div class="detailViewArea" id="itemContView">
    <%
        Dim itemVideos
        Dim ItemContent : ItemContent = oItem.Prd.FItemContent

        '링크는 새창으로
        ItemContent = Replace(ItemContent,"<a ","<a target='_blank' ")
        ItemContent = Replace(ItemContent,"<A ","<A target='_blank' ")
        '높이태그 제거
        ItemContent = Replace(ItemContent,"height=","h=")
        ItemContent = Replace(ItemContent,"HEIGHT=","h=")
        '너비태그 제거
        ItemContent = Replace(ItemContent,"width=","w=")
        ItemContent = Replace(ItemContent,"WIDTH=","w=")

        '// 태그 중복 제거
        ItemContent = Replace(ItemContent,">>",">")
        ItemContent = Replace(ItemContent,"<<","<")

        Response.Write "<table style=""width:100%;""><tr><td>"		'' 설명에 tag를 안닫아 깨짐 방지
        IF oItem.Prd.FUsingHTML="Y" THEN
            Response.write ItemContent
        ELSEIF oItem.Prd.FUsingHTML="H" THEN
            Response.write nl2br(ItemContent)
        ELSE
            Response.write nl2br(stripHTML(ItemContent))
        END IF
        Response.Write "</td></tr></table>"
    %>
    <% '// 강제 width값 100% table%>
    <script>
        (function(){
            var $contents = $("#itemContView");
            $contents.find("table").css("width","100%");
            $contents.find("div").css("width","100%");
            $contents.find("img").css("width","100%");
        })(jQuery);
    </script>
    <% IF oAdd.FResultCount > 0 THEN %>
        <% FOR i= 0 to oAdd.FResultCount-1  %>
            <%IF oAdd.FADD(i).FAddImageType=1 AND oAdd.FADD(i).FIsExistAddimg THEN %>
            <img src="<%= oAdd.FADD(i).FAddimage %>" border="0" style="width:100%; height:auto;" />
            <%End IF %>
        <% NEXT %>
    <% END IF %>
    <% if ImageExists(oItem.Prd.FImageMain) then %>
    <img src="<% = oItem.Prd.FImageMain %>" border="0" style="width:100%; height:auto;" />
    <% end if %>
    <% if ImageExists(oItem.Prd.FImageMain2) then %>
    <img src="<% = oItem.Prd.FImageMain2 %>" border="0" style="width:100%; height:auto;" />
    <% end if %>
    <% if ImageExists(oItem.Prd.FImageMain3) then %>
    <img src="<% = oItem.Prd.FImageMain3 %>" border="0" style="width:100%; height:auto;" />
    <% end if %>

    <%'// 상품상세설명 동영상 추가 %>
    <% If Not(itemVideos.Prd.FvideoFullUrl="") Then %>
        <div class="detailMoviewrap">
            <div class="detailMovie">
                <div class="movieBox">
                    <iframe class="youtube-player" type="text/html" src="<%=itemVideos.Prd.FvideoUrl%>" frameborder="0"></iframe>
                </div>
            </div>
        </div>
    <% End If %>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->