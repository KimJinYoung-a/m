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
dim userid, page,  pagesize, SortMethod,ix,EvaluatedYN,i, lp
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
dim EvList
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
end if

%>

<% if EvaluatedYN="Y" then '' 상품후기 조회/수정 %>
	<% if EvList.FResultCount > 0 then %>
		<% for  i = 0 to EvList.FResultCount-1 %>
		<li>
			<div class="odrInfo">
				<span><%= formatdate(CStr(EvList.FItemList(i).FOrderDate),"0000.00.00") %></span>
				<span>주문번호(<%= EvList.FItemList(i).FOrderSerial %>)</span>
			</div>
			<div class="pdtWrap">
				<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=EvList.FItemList(i).FItemid%>'); return false;">
				<p class="pic"><img src="<%=EvList.FItemList(i).FBasicImage%>" alt="<%= EvList.FItemList(i).FItemname %>" /></p>
				<div class="pdtInfo">
					<p class="pBrand">[<%=EvList.FItemList(i).FMakerName%>]</p>
					<p class="pName"><%= EvList.FItemList(i).FItemname %></p>
					<% If EvList.FItemList(i).FOptionName <> "" Then %>
					<p class="option">옵션 : <%= EvList.FItemList(i).FOptionName %></p>
					<% End If %>
					<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
				</div>
				</a>
			</div>
			<div class="goReview">
				<p class="ftRt">
					<span class="button btM2 btWht cBk1"><a href="" onClick="AddEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;">수정</a></span>
					<span class="button btM2 btWht cBk1"><a href="" onClick="DelEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;">삭제</a></span>
				</p>
			</div>
		</li>
		<% next %>
	<% end if %>
<% else '' 상품후기 작성 %>
	<% if EvList.FResultCount = 0 then %>
	<% else %>
	<% for  i = 0 to EvList.FResultCount-1 %>
	<li>
		<div class="odrInfo">
			<span><%= formatdate(CStr(EvList.FItemList(i).FOrderDate),"0000.00.00") %></span>
			<span>주문번호(<%= EvList.FItemList(i).FOrderSerial %>)</span>
		</div>
		<div class="pdtWrap">
			<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=EvList.FItemList(i).FItemid%>'); return false;">
			<p class="pic"><img src="<%=EvList.FItemList(i).FBasicImage%>" alt="<%= EvList.FItemList(i).FItemname %>" /></p>
			<div class="pdtInfo">
				<p class="pBrand">[<%=EvList.FItemList(i).FMakerName%>]</p>
				<p class="pName"><%= EvList.FItemList(i).FItemname %></p>
				<% If EvList.FItemList(i).FOptionName <> "" Then %>
				<p class="option">옵션 : <%= EvList.FItemList(i).FOptionName %></p>
				<% End If %>
				<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
			</div>
			</a>
		</div>
		<div class="goReview">
			<% if EvList.FItemList(i).FEvalCnt=0 then %>
			<p class="firstReview">★ 첫후기 200Point</p>
			<% end if %>
			<p class="ftRt"><span class="button btM2 btRed cWh1"><a href="" onclick="AddEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;">후기작성하기</a></span></p>
		</div>
	</li>
	<% next %>
	<%end if%>
<% end if %>

<% Set EvList = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->