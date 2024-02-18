<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 마이텐바이텐 - 상품후기 목록 _ajax (페이징용)
' History : 2015-02-12 허진원
'			2016-01-04 이종화 - 상품후기 (테스터후기 추가)
'####################################################

	dim itemid	:  itemid = requestCheckVar(request("itemid"),9)
	Dim page : page = RequestCheckVar(request("cpg"),10)
	dim sortMtd : sortMtd = RequestCheckVar(request("sortMtd"),2)
	Dim EvalDiv : EvalDiv=RequestCheckVar(request("evaldiv"),1)
	if page="" then page=1
	If EvalDiv="" Then EvalDiv="a"

	if itemid="" or itemid="0" then
		Call Alert_msg("상품번호가 없습니다.")
		dbget.Close(): response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_msg("잘못된 상품번호입니다.")
		dbget.Close(): response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end If

	dim LoginUserid
	LoginUserid = getLoginUserid()

	'// 상품 기본 정보 접수
	dim oItem
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
		Call Alert_msg("존재하지 않는 상품입니다.")
		dbget.Close(): response.End
	end if

	if oItem.Prd.Fisusing="N" then
		Call Alert_msg("판매가 종료되었거나 삭제된 상품입니다.")
		dbget.Close(): response.End
	end if

	'// 티켓상품 여부
	Dim IsTicketItem:  IsTicketItem = (oItem.Prd.FItemDiv = "08")

	'//상품 후기
	dim oEval,i,j,ix
	set oEval = new CEvaluateSearcher
	oEval.FPageSize = chkIIF(sortMtd<>"ph",10,5)
	oEval.FScrollCount = 4
	oEval.FCurrpage = page
	oEval.FsortMethod = sortMtd
	oEval.FEvalDiv = EvalDiv
	oEval.FRectItemID = itemid

	if sortMtd="p" then
		oEval.getItemEvalListph
	ElseIf sortMtd="t" Then '// 테스터 후기
		oEval.getItemEvalPopup()
	Else 
		oEval.getItemEvalList
	end if

	'// 고객 뱃지 접수
	dim arrUserid, bdgUid, bdgBno
	if oEval.FResultCount > 0 then
		'사용자 아이디 모음 생성(for Badge)
		for i = 0 to oEval.FResultCount - 1
			arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(oEval.FItemList(i).FUserID) & "''"
		next
		
		'뱃지 목록 접수(순서 랜덤)
		Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
	end if
%>
	<% if oEval.FResultCount>0 then %>
		<% FOR i =0 to oEval.FResultCount-1 %>
			<li>
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
				<% If oEval.FItemList(i).FShopName<>"" Then %><p class="color-blue offline"><% = oEval.FItemList(i).FShopName %></p><% End If %>
				<% If sortMtd="ne" Then %>
				<dl>
					<dt>총평</dt>
					<dd><% = nl2br(oEval.FItemList(i).FUesdContents) %></dd>
				</dl>
				<dl>
					<dt>좋았던 점</dt>
					<dd><% = nl2br(oEval.FItemList(i).FUseGood) %></dd>
				</dl>
				<dl>
					<dt>특이한 점 및 이용 TIP</dt>
					<dd><% = nl2br(oEval.FItemList(i).FUseETC) %></dd>
				</dl>
				<% Else %>
				<div><%= nl2br(oEval.FItemList(i).FUesdContents) %></div>
				<% End If %>
				<p class="writer"><%= printUserId(oEval.FItemList(i).FUserID,2,"*") %> / <%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %></p>
				<% if oEval.FItemList(i).Flinkimg1<>"" Or oEval.FItemList(i).Flinkimg2<>"" then %>
				<p class="photo">
					<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage1 %>" alt="포토1" /><% end if %>
					<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage2 %>" alt="포토2" /><% end if %>
				</p>
				<% end if %>
			</li>
		<% NEXT %>
	<% End If %>
<%
	set oItem =	Nothing
	set oEval =	Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->