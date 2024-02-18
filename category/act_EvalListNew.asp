<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/util/pageformlib.asp" -->
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
	dim itemid	:  itemid = requestCheckVar(request("evalitemid"),9)
	Dim page : page = RequestCheckVar(request("evalpage"),10)
	Dim EvalDiv : EvalDiv=RequestCheckVar(request("evaldiv"),1)
    Dim SortMethod : SortMethod=RequestCheckVar(request("evalsortmethod"),2)
    Dim optionCode : optionCode=RequestCheckVar(request("evaloptioncode"),10)
	if page="" then page=1
	If EvalDiv="" Then EvalDiv="a"
    if SortMethod="" Then  SortMethod="ne"

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim oEval,oEvalCount,oEvalNextCheck,i,j,ix, evalNextCheck
	'//상품 후기 
    set oEval = new CEvaluateSearcher
    oEval.FPageSize = 5
    oEval.FCurrpage = page
    oEval.FRectItemID = itemid    
    oEval.FEvalDiv = EvalDiv
    oEval.FsortMethod = SortMethod
    oEval.FRectOption = optionCode
	oEval.getItemEvalListReDesignUI

    '//조건별 전체 상품후기 갯수
    set oEvalCount = new CEvaluateSearcher
    oEvalCount.FRectItemID = itemid
    oEvalCount.FRectOption = optionCode    
    oEvalCount.getItemEvalListReDesignUICount

    '//해당 데이터 다음에도 상품후기가 있는지 체크
    set oEvalNextCheck = new CEvaluateSearcher
    oEvalNextCheck.FPageSize = 5
    oEvalNextCheck.FCurrpage = page+1
    oEvalNextCheck.FRectItemID = itemid    
    oEvalNextCheck.FEvalDiv = EvalDiv
    oEvalNextCheck.FsortMethod = SortMethod
    oEvalNextCheck.FRectOption = optionCode
	oEvalNextCheck.getItemEvalListReDesignUI
    If oEvalNextCheck.FResultCount > 0 Then
        evalNextCheck = "ok"
    End If
    set oEvalNextCheck = Nothing
%>

<% If oEval.FResultCount > 0 Then %>
    <% FOR i = 0 to oEval.FResultCount-1 %>                
        <li class="review-info">
            <div class="writer">
				<span class="thumb <%=GetUserStr(oEval.FItemList(i).FUserLevel)%>"><%=ucase(GetUserStr(oEval.FItemList(i).FUserLevel))%>등급</span>
                <span>
                    <%
                        If Len(oEval.FItemList(i).FUserID) > 7 Then
                            Response.write Left(oEval.FItemList(i).FUserID, 5)&"**"
                        Else
                            Response.write printUserId(oEval.FItemList(i).FUserID,2,"*") 
                        End If
                    %>
                </span>
            </div>
            <div class="review-conts">
                <% If oEval.FItemList(i).FShopName<>"" Then %><p class="offline"><% = oEval.FItemList(i).FShopName %></p><% End If %>
                <% If oEval.FItemList(i).FTotalPoint=1 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:20%;"></i></span></div>
                <% ElseIf oEval.FItemList(i).FTotalPoint=2 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:40%;"></i></span></div>
                <% ElseIf oEval.FItemList(i).FTotalPoint=3 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:60%;"></i></span></div>
                <% ElseIf oEval.FItemList(i).FTotalPoint=4 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:80%;"></i></span></div>
                <% ElseIf oEval.FItemList(i).FTotalPoint=5 Then %>
                <div class="items review"><span class="icon icon-rating"><i style="width:100%;"></i></span></div>
                <% Else %>
                <div class="items review"><span class="icon icon-rating"><i style="width:0%;"></i></span></div>
                <% End If %>
                <% if Not(oEval.FItemList(i).FOptionName="" or isNull(oEval.FItemList(i).FOptionName)) then %>
                <div class="purchaseOption"><em><strong>구매옵션</strong> : <%=oEval.FItemList(i).FOptionName%></em></div>
                <% end if %>
                <div><%= nl2br(oEval.FItemList(i).FUesdContents) %></div>
                <% If oEval.FItemList(i).Flinkimg1<>"" And oEval.FItemList(i).Flinkimg2<>"" And oEval.FItemList(i).Flinkimg3<>"" Then %>
                    <%' for dev msg 사진3장 일 경우 %>
                    <div class="photo photo-3">
                        <a href="" onclick="window.open('/category/pop_ItemEvalPhotoDetail.asp?itemid=<%=itemid%>&idx=<%=oEval.FItemList(i).Fidx%>'); return false;">
                            <span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage1,200,"",95) %>)"></i></span>
                            <span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage2,200,"",95) %>)"></i></span>
                            <span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage3,200,"",95) %>)"></i></span>
                        </a>
                    </div>
                <% ElseIf (oEval.FItemList(i).Flinkimg1<>"" And oEval.FItemList(i).Flinkimg2<>"") or (oEval.FItemList(i).Flinkimg1<>"" And oEval.FItemList(i).Flinkimg3<>"") or (oEval.FItemList(i).Flinkimg2<>"" And oEval.FItemList(i).Flinkimg3<>"") Then %>
                    <div class="photo photo-2">
                        <a href="" onclick="window.open('/category/pop_ItemEvalPhotoDetail.asp?itemid=<%=itemid%>&idx=<%=oEval.FItemList(i).Fidx%>'); return false;"> 
                            <% if oEval.FItemList(i).Flinkimg1<>"" then %><span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage1,300,"",95) %>)"></i></span><% end if %>
                            <% if oEval.FItemList(i).Flinkimg2<>"" then %><span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage2,300,"",95) %>)"></i></span><% end if %>
                            <% if oEval.FItemList(i).Flinkimg3<>"" then %><span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage3,300,"",95) %>)"></i></span><% end if %>
                        </a>
                    </div>											
                <% Else %>
                    <% If oEval.FItemList(i).Flinkimg1<>"" Or oEval.FItemList(i).Flinkimg2<>"" Or oEval.FItemList(i).Flinkimg3<>"" Then %>
                        <div class="photo">
                            <a href="" onclick="window.open('/category/pop_ItemEvalPhotoDetail.asp?itemid=<%=itemid%>&idx=<%=oEval.FItemList(i).Fidx%>'); return false;">                        
                                <% if oEval.FItemList(i).Flinkimg1<>"" then %><span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage1,400,"",95) %>)"></i></span><% end if %>
                                <% if oEval.FItemList(i).Flinkimg2<>"" then %><span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage2,400,"",95) %>)"></i></span><% end if %>
                                <% if oEval.FItemList(i).Flinkimg3<>"" then %><span><i style="background-image:url(<%=getStonReSizeImg(oEval.FItemList(i).getLinkImage3,400,"",95) %>)"></i></span><% end if %>
                            </a>
                        </div>
                    <% End If %>
                <% End If %>
                <p class="date"><%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %></p>
            </div>
        </li>
    <% Next %>
    |||||<%=oEvalCount.FItemList(0).FEvalTotalCount%>|||||<%=oEvalCount.FItemList(0).FEvalPhotoCount%>|||||<%=oEvalCount.FItemList(0).FEvalOfflineCount%>|||||<%=evalNextCheck%>
<% Else %>
    <% IF page = 1 Then %><p class='txtNoneV16a'>등록된 상품후기가 없습니다.</p><% End If %>|||||<%=oEvalCount.FItemList(0).FEvalTotalCount%>|||||<%=oEvalCount.FItemList(0).FEvalPhotoCount%>|||||<%=oEvalCount.FItemList(0).FEvalOfflineCount%>|||||
<% End If %>
<%
    Set oEval = Nothing
    Set oEvalCount = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->