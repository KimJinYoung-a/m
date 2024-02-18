<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 테스터후기 리스트
' History : 2016-01-06 원승현 생성
'####################################################
%>

<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_tester_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventprizeCls.asp" -->
<%


dim userid, page,  pagesize, SortMethod,cdL,vDisp,ix,EvaluatedYN,i, lp
userid      = getEncLoginUserID
page        = requestCheckVar(request("page"),9)
pagesize    = requestCheckVar(request("pagesize"),9)
SortMethod  = requestCheckVar(request("SortMethod"),10)
vDisp		= requestCheckVar(request("disp"),3)
EvaluatedYN	= requestCheckVar(request("EvaluatedYN"),2)



'####### Tester 당첨 여부. #######
Dim clsEvtPrize	: set clsEvtPrize  = new CEventPrize
clsEvtPrize.FUserid = userid
	clsEvtPrize.fnGetTesterEventCheck
	if clsEvtPrize.FTotCnt>0 then
		response.Cookies("tinfo")("isTester") = true
	else
		response.Cookies("tinfo")("isTester") = false
	end if
set clsEvtPrize = Nothing
'####### Tester 당첨 여부. #######



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
EvList.FScrollCount =10
EvList.FRectDisp= vDisp
EvList.FRectEvaluatedYN=EvaluatedYN
EvList.FSortMethod = SortMethod 

if EvaluatedYN="Y" then
	EvList.EvalutedItemList ''후기 가져오기 
else 
	EvList.NotEvalutedItemList ''후기 안쓰인 상품 가져오기 
end if
%>

<% if EvaluatedYN="Y" then %>
	<%'// 테스터 후기 수정 %>
	<% if EvList.FResultCount = 0 then %>
	<% else %>
		<% for  i = 0 to EvList.FResultCount-1 %>
		<li>
			<div class="odrInfo">
				<span>작성기간 : <%=EvList.FItemList(i).FstartDate%> ~ <%=EvList.FItemList(i).FendDate%></span>
			</div>
			<div class="pdtWrap">
				<p class="pic"><img src="<%=getThumbImgFromURL(EvList.FItemList(i).FImageIcon2,"150","150","true","false")%>" alt="<%= EvList.FItemList(i).FItemName %>" /></p>
				<div class="pdtInfo">
					<p class="pBrand"><%= EvList.FItemList(ix).FMakerName %></p>
					<p class="pName"><%= EvList.FItemList(i).FItemName %></p>
					<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
				</div>
			</div>
			<div class="goReview">
				<p class="ftRt">
					<span class="button btM2 btWht cBk1"><a href="" onclick="javascript:TesterAddEval('<%= EvList.FItemList(i).FIdx %>','<%= EvList.FItemList(i).FEvtprize_Code %>','<%= EvList.FItemList(i).FEvt_Code %>','<%= EvList.FItemList(i).FItemID %>');return false;">수정</a></span>
					<span class="button btM2 btWht cBk1"><a href="" onclick="javascript:DelEval('<%= EvList.FItemList(i).FIdx %>','<%= EvList.FItemList(i).FEvtprize_Code %>','<%= EvList.FItemList(i).FEvt_Code %>');return false">삭제</a></span>
				</p>
			</div>
		</li>
	<%
			Next
		End If
	%>
<% Else %>
	<%'// 테스터 후기 작성 %>
	<% if EvList.FResultCount = 0 then %>
		<p class="noData ct"><strong>작성하실 테스터 후기가 없습니다.</strong></p>
	<% Else %>
		<% for i=0 to EvList.FResultCount-1 %>
		<li>
			<div class="odrInfo">
				<span>작성기간 : <%=EvList.FItemList(i).FstartDate%> ~ <%=EvList.FItemList(i).FendDate%></span>
			</div>
			<div class="pdtWrap">
				<p class="pic"><img src="<%=getThumbImgFromURL(EvList.FItemList(i).FImageIcon2,"150","150","true","false")%>" alt="<%= EvList.FItemList(i).FItemName %>" /></p>
				<div class="pdtInfo">
					<p class="pBrand"><%= EvList.FItemList(ix).FMakerName %></p>
					<p class="pName"><%= EvList.FItemList(i).FItemName %></p>
					<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
				</div>
			</div>
			<div class="goReview">
				<% If EvList.FItemList(ix).FstartDate > now() Then %>
					<p class="ftRt"><span class="button btM2 btRed cWh1"><%=Month(EvList.FItemList(i).FstartDate)%>월 <%=Day(EvList.FItemList(i).FstartDate)%>일부터 작성</span></p>
				<% Else %>
					<p class="ftRt"><span class="button btM2 btRed cWh1"><a href="" onclick="javascript:TesterAddEval('','<%= EvList.FItemList(i).FEvtprize_Code %>','<%= EvList.FItemList(i).FEvt_Code %>','<%= EvList.FItemList(i).FItemID %>');return false;">테스터 후기 쓰기</a></span></p>
				<% End If %>
			</div>
		</li>
	<%
			Next
		End If
	%>
<% End If %>

<% set EvList= nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->