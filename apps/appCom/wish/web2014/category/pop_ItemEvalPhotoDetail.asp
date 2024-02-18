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
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include Virtual="/lib/util/functions.asp" -->
<%
	dim itemid	:  itemid = requestCheckVar(request("itemid"),9)
	Dim idx : idx = RequestCheckVar(request("idx"),20)

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

    if idx="" then
		Call Alert_AppClose("정상적인 경로로 접근해주시기 바랍니다.")
		response.End
    end if    

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim oEval,i
	'//상품 후기 한개만
    set oEval = new CEvaluateSearcher
    oEval.FRectItemID = itemid    
    oEval.FIdx = idx
	oEval.getItemEvalOneNew()

    Dim photoCount

    photoCount = 0

    If oEval.FEvalItem.Flinkimg1<>"" Then
        photoCount = photoCount + 1
    End If

    If oEval.FEvalItem.Flinkimg2<>"" Then
        photoCount = photoCount + 1
    End If

    If oEval.FEvalItem.Flinkimg3<>"" Then
        photoCount = photoCount + 1
    End If    
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/temp_a.css?v=1.16" />
<script type="text/javascript">
$(function(){
    <% If photoCount > 1 Then %>
        reviewSwiper = new Swiper('.pop-photo-review .swiper-container',{
            loop:true,
            autoplayDisableOnInteraction:false,
            speed:800,
            pagination:".pop-photo-review .pagination",
            paginationClickable:true
        });
    <% Else %>
        reviewSwiper = new Swiper('.pop-photo-review .swiper-container',{
            loop:false,
            autoplayDisableOnInteraction:false
        });    
    <% End If %>
});
</script>
</head>
<body class="default-font body-popup">
    <!-- 포토후기상세 -->
    <div class="content pop-photo-review">
        <div class="swiper">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <% if oEval.FEvalItem.Flinkimg1<>"" then %><div class="swiper-slide"><span class="thumb"><img src="<%=oEval.FEvalItem.getLinkImage1 %>" alt=""></span></div><% end if %>
                    <% if oEval.FEvalItem.Flinkimg2<>"" then %><div class="swiper-slide"><span class="thumb"><img src="<%=oEval.FEvalItem.getLinkImage2 %>" alt=""></span></div><% end if %>
                    <% if oEval.FEvalItem.Flinkimg3<>"" then %><div class="swiper-slide"><span class="thumb"><img src="<%=oEval.FEvalItem.getLinkImage3 %>" alt=""></span></div><% end if %>
                </div>
                <div class="pagination"></div>
            </div>
        </div>
        <div class="review-info">
            <div class="writer">
				<span class="thumb <%=GetUserStr(oEval.FEvalItem.FUserLevel)%>"><%=ucase(GetUserStr(oEval.FEvalItem.FUserLevel))%>등급</span>
                <span>
                    <%
                        If Len(oEval.FEvalItem.FUserID) > 7 Then
                            Response.write Left(oEval.FEvalItem.FUserID, 5)&"**"
                        Else
                            Response.write printUserId(oEval.FEvalItem.FUserID,2,"*") 
                        End If                    
                    %>
                </span>
            </div>
            <div class="review-conts">
                <% If oEval.FEvalItem.FTotalPoint=1 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:20%;"></i></span></div>
                <% ElseIf oEval.FEvalItem.FTotalPoint=2 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:40%;"></i></span></div>
                <% ElseIf oEval.FEvalItem.FTotalPoint=3 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:60%;"></i></span></div>
                <% ElseIf oEval.FEvalItem.FTotalPoint=4 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:80%;"></i></span></div>
                <% ElseIf oEval.FEvalItem.FTotalPoint=5 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:100%;"></i></span></div>
                <% Else %>
                <div class="items review"><span class="icon icon-rating"><i style="width:0%;"></i></span></div>
                <% End If %>
                <% if Not(oEval.FEvalItem.FOptionName="" or isNull(oEval.FEvalItem.FOptionName)) then %>
                <div class="purchaseOption"><%=oEval.FEvalItem.FOptionName%></div>
                <% end if %>
                <div><%=nl2br(oEval.FEvalItem.FUesdContents)%></div>
                <p class="date"><%= FormatDate(oEval.FEvalItem.FRegdate, "0000.00.00") %></p>
            </div>
        </div>
    </div>
    <!-- //포토후기상세-->
</body>
</html>
<%
    Set oEval = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->