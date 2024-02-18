<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 마이텐바이텐 - 상품후기 목록
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
	    if (itemid="1749918") then  ''2018/02/19 테돈요청 TEST
            oEval.FsortMethod = "be"
        end if
        
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
<script type="text/javascript">
var vMtd = "<%=sortMtd%>";
function fnGoEvalPage(page) {
	//if (vMtd=="p") {
	//	pageUrlSelect = "pop_ItemEvalList.asp?itemid=<%=itemid%>&evaldiv=p&cpg="+page;
	//}
	//else {
	//	pageUrlSelect = "pop_ItemEvalList.asp?itemid=<%=itemid%>&evaldiv=<%=EvalDiv%>&cpg="+page;
	//}
	$.ajax({
		url: "pop_ItemEvalList.asp?itemid=<%=itemid%>&sortMtd=<%=sortMtd%>&evaldiv="+vMtd+"&cpg="+page,
		cache: false,
		async: false,
		success: function(message) {
			$(".itemPrdV18").empty().html($(message).find(".itemPrdV18").html());
			var $items = $(message);
			$items.imagesLoaded().then(function(){
		        myScroll.refresh();
		        myScroll.scrollTo(0,0,50);
			});
		}
	});
}

function fnGoEvalTab(mtd) {
	$.ajax({
		url: "pop_ItemEvalList.asp?itemid=<%=itemid%>&sortMtd=<%=sortMtd%>&EvalDiv="+mtd,
		cache: false,
		async: false,
		success: function(message) {
			$(".itemPrdV18").empty().html($(message).find(".itemPrdV18").html());
			var $items = $(message);
			$items.imagesLoaded().then(function(){
		        myScroll.refresh();
		        myScroll.scrollTo(0,0,50);
			});
		    vMtd = mtd;
		}
	});
}
</script>
<div class="layerPopup">
	<div class="popWin">
		<div class="header">
			<h1><%=chkIIF(Not(IsTicketItem),"상품후기","관람평")%></h1>
			<p class="btnPopClose"><button type="button" class="pButton" onclick="fnCloseModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content item-evalist" id="layerScroll">
			<div id="scrollarea">
				<div class="itemPrdV16a itemPrdV17 itemPrdV18">
					<!-- 목록 -->
					<div class="itemDeatilV16a itemDetailV18a">
						<ul class="commonTabV16a">
							<% If oItem.Prd.Ftestercnt > 0 Then %>
							<li <%=CHKIIF(EvalDiv="a","class=""current""","")%> name="tab01" style="width:25%;"><a href="" onclick="fnGoEvalTab('a'); return false;">전체<span>(<%=oItem.Prd.FEvalCnt%>)</span></a></li>
							<li <%=CHKIIF(EvalDiv="p","class=""current""","")%> name="tab02" style="width:25%;"><a href="" onclick="fnGoEvalTab('p'); return false;">포토<span>(<%=oItem.Prd.FEvalCnt_photo%>)</span></a></li>
							<li <%=CHKIIF(EvalDiv="o","class=""current""","")%> name="tab03" style="width:25%;"><a href="" onclick="fnGoEvalTab('o'); return false;">매장<span>(<%=oItem.Prd.FEvalOffCnt%>)</span></a></li>
							<li <%=CHKIIF(EvalDiv="t","class=""current""","")%> name="tab04" style="width:25%;"><a href="" onclick="fnGoEvalTab('t'); return false;">테스터후기<span>(<%=oItem.Prd.Ftestercnt%>)</span></a></li>
							<% Else %>
							<li <%=CHKIIF(EvalDiv="a","class=""current""","")%> name="tab01" style="width:33%;"><a href="" onclick="fnGoEvalTab('a'); return false;">전체<span>(<%=oItem.Prd.FEvalCnt%>)</span></a></li>
							<li <%=CHKIIF(EvalDiv="p","class=""current""","")%> name="tab02" style="width:33%;"><a href="" onclick="fnGoEvalTab('p'); return false;">포토<span>(<%=oItem.Prd.FEvalCnt_photo%>)</span></a></li>
							<li <%=CHKIIF(EvalDiv="o","class=""current""","")%> name="tab03" style="width:34%;"><a href="" onclick="fnGoEvalTab('o'); return false;">매장<span>(<%=oItem.Prd.FEvalOffCnt%>)</span></a></li>
							<% End If %>
						</ul>
						<div class="tabContainer box1 tPad05">
							<div class="tabContent">
							<% if oEval.FResultCount>0 then %>
								<div class="postscript">
									<ul class="postListV16a" id="cmtCont">
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
											<% If oEval.FItemList(i).FShopName<>"" Then %><p class="color-blue offline"><% = oEval.FItemList(i).FShopName %></p><% end if %>
											<div>
												<% If EvalDiv="t" Then %>
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
												<%= nl2br(oEval.FItemList(i).FUesdContents) %>
												<% End If %>
											</div>

											<p class="writer"><%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %> <span class="bar">/</span> <%= printUserId(oEval.FItemList(i).FUserID,2,"*") %></p>

											<p class="photo">
												<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage1 %>" alt="포토1" /><% end if %>
												<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage2 %>" alt="포토2" /><% end if %>
											</p>
										</li>
									<% NEXT %>
									</ul>
									<div class="tPad20">
									<%=fnDisplayPaging_New(page,oEval.FTotalCount,chkIIF(sortMtd="be",4,10),4,"fnGoEvalPage")%>
									</div>
								</div>
							<% else %>
								<div class="noDataBox">
									<p class="noDataMark"><span>!</span></p>
									<p class="tPad05">등록된 <%=chkIIF(Not(IsTicketItem),"상품후기가","관람평이")%> 없습니다.</p>
								</div>
							<% end if %>
							</div>
						</div>
					</div>
					<!--// 목록 -->
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
<%
	set oItem =	Nothing
	set oEval =	Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->