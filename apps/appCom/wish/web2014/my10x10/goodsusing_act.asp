<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim userid, page,  pagesize, SortMethod,ix,EvaluatedYN,i, lp, iy
Dim LoopCount
LoopCount=0
userid      = getEncLoginUserID
page        = requestCheckVar(request("page"),9)
pagesize    = requestCheckVar(request("pagesize"),9)
SortMethod  = requestCheckVar(request("SortMethod"),10)
EvaluatedYN	= requestCheckVar(request("EvaluatedYN"),2)


if page="" then page=1
if pagesize="" then pagesize="10"
if EvaluatedYN="" then EvaluatedYN="N"
if SortMethod ="" then
	'고객작성후기라면 정렬기본값은 작성일자순(2008.04.28;허진원)
	if EvaluatedYN="Y" then
		SortMethod ="Reg"
	else
		SortMethod ="Buy"
	end if
end if
dim EvList, OrderList
set EvList = new CEvaluateSearcher
EvList.FRectUserID = Userid 
EvList.FPageSize = pagesize 
EvList.FCurrPage	= page
EvList.FScrollCount = 3
EvList.FRectEvaluatedYN=EvaluatedYN
EvList.FSortMethod = SortMethod 


if EvaluatedYN="Y" then
	EvList.EvalutedItemListNew ''후기 가져오기
else
	EvList.NotEvalutedItemListNew ''후기 안쓰인 상품 가져오기

	set OrderList = new CEvaluateSearcher
	OrderList.FRectUserID = Userid
	OrderList.FPageSize = pagesize 
	OrderList.FCurrPage	= page
	OrderList.FScrollCount = 3
	OrderList.FRectEvaluatedYN=EvaluatedYN
	OrderList.FSortMethod = SortMethod
	OrderList.NotEvalutedItemOrderList
end if

'//상품 후기 마일리지
Dim cMil , vMileArr
Dim vMileValue : vMileValue = 100
If isdoubleMileage Then
	vMileValue = 200
End If 

Set cMil = New CEvaluateSearcher
	cMil.FRectUserID = Userid
	cMil.FRectMileage = vMileValue
	vMileArr = cMil.getEvaluatedTotalMileCnt
Set cMil = Nothing
%>

						<% If EvaluatedYN="Y" Then '' 상품후기 조회/수정 %>
								<% if EvList.FResultCount = 0 then %>
								<% Else %>
								<% For i=0 To EvList.FResultCount-1 %>
								<div class="review">
									<div class="inner">
										<div class="odrInfo">
											<div class="write-date"><%= FormatDate(EvList.FItemList(i).FRegDate, "0000.00.00") %> 작성</div>
											<span class="order-num">주문번호 <%=EvList.FItemList(i).FOrderSerial%></span>
											<% If EvList.FItemList(i).FShopName<>"" Then %>
											<span class="offshop">| <em class="color-blue"><% = EvList.FItemList(i).FShopName %></em></span>
											<% End If %>
										</div>
										<div class="pdtWrap">
											<a href="" onclick="fnAPPpopupProduct('<%=EvList.FItemList(i).FItemid%>');return false;">											
												<p class="pic"><img src="<%=EvList.FItemList(i).FBasicImage%>" alt="<%= EvList.FItemList(i).FItemname %>"></p>
												<div class="pdtInfo items">
													<p class="pBrand">[<%=EvList.FItemList(i).FMakerName%>]</p>
													<p class="pName"><%= EvList.FItemList(i).FItemname %></p>
													<% if (EvList.FItemList(i).FOptionName <> "") then %>
													<p class="option">옵션 : <%= EvList.FItemList(i).FOptionName %></p>
													<% end if %>
													<% If EvList.FItemList(i).FTotalPoint=1 Then %>
													<span class="icon icon-rating"><i style="width:20%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=2 Then %>
													<span class="icon icon-rating"><i style="width:40%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=3 Then %>
													<span class="icon icon-rating"><i style="width:60%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=4 Then %>
													<span class="icon icon-rating"><i style="width:80%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=5 Then %>
													<span class="icon icon-rating"><i style="width:100%;"></i></span>
													<% Else %>
													<span class="icon icon-rating"><i style="width:0%;"></i></span>
													<% End If %>
												</div>
											</a>
											<div class="edit">
												<button class="btn-modify" onClick="AddEval1('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>','<%= EvList.FItemList(i).FDetailIDX %>'); return false;"><span class="icon icon-edit_gray"></span>수정</button>
												<button class="btn-delete" onClick="DelEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;"><span class="icon icon-edit_trash"></span>삭제</button>
											</div>
										</div>
									</div>
								</div>
								<% Next %>
								<% End If %>
						<% Else'' 상품후기 작성 %>
							<% if EvList.FResultCount = 0 then %>
							<% Else %>
								<% For ix=0 To OrderList.FResultCount-1 %>
								<% For iy=0 To EvList.FResultCount-1 %>
									<% If OrderList.FItemList(ix).FOrderSerial=EvList.FItemList(iy).FOrderSerial Then %>
								<% If LoopCount=0 Then %>
								<div class="review">
									<div class="inner">
										<div class="odrInfo">
											<div class="order-num">주문번호 <%=EvList.FItemList(iy).FOrderSerial%></div>
											<span class="date"><%= FormatDate(EvList.FItemList(i).FOrderDate, "0000.00.00") %></span>
											<% If EvList.FItemList(iy).FShopName<>"" Then %>
											<span class="offshop">| <em class="color-blue"><% = EvList.FItemList(iy).FShopName %></em></span>
											<% End If %>
										</div>
								<% End If %>
										<div class="pdtWrap">
											<a href="" onclick="fnAPPpopupProduct('<%=EvList.FItemList(iy).FItemid%>');return false;">
												<p class="pic"><img src="<%=EvList.FItemList(iy).FBasicImage%>" alt="<%= EvList.FItemList(iy).FItemname %>"></p>
												<div class="pdtInfo">
													<p class="pBrand">[<%=EvList.FItemList(iy).FMakerName%>]</p>
													<p class="pName"><%= EvList.FItemList(iy).FItemname %></p>
													<!-- <% if (EvList.FItemList(iy).FOptionName <> "") then %>
													<p class="option">옵션 : <%= EvList.FItemList(iy).FOptionName %></p>
													<% end if %> -->
													<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(iy).FItemCost,0) %></strong>원</p>
												</div>
											</a>
											<div class="edit">
												<% if EvList.FItemList(iy).FEvalCnt=0 then %>
												<em class="color-blue">첫 후기 200p</em>
												<% end if %>
												<button onClick="AddEval1('<%= EvList.FItemList(iy).FOrderSerial %>','<%= EvList.FItemList(iy).FItemID %>','<%= EvList.FItemList(iy).FItemOption %>','<%= EvList.FItemList(i).FDetailIDX %>'); return false;"><span class="icon icon-edit_red"></span>쓰기</button>
											</div>
										</div>
										<% LoopCount=LoopCount+1 %>
								<% Else %>
									<% LoopCount=0 %>
								<% End If %>
								<% Next %>
								<% If LoopCount=0 Then %>
									</div>
								</div>
								<% End If %>
								<% Next %>
							<% End If %>
						<% End If %>

<%
set EvList= Nothing
set OrderList= Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->