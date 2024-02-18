<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
	Dim tabno : tabno = requestCheckVar(request("tabno"),2)
	Dim tabname : tabname = requestCheckVar(request("tnm"),5)

	If tabno = "" Then tabno = 2		'// 1번(상품상세)는 Ajax로 처리 안함

	dim itemid	:  itemid = requestCheckVar(request("itemid"),9)
	Dim page : page = RequestCheckVar(request("cpg"),10)
	if page="" then page=1

	if itemid="" or itemid="0" then
		Call Alert_Return("상품번호가 없습니다.")
		response.End
	elseif Not(isNumeric(itemid)) then
		Call Alert_Return("잘못된 상품번호입니다.")
		response.End
	else
		'정수형태로 변환
		itemid=CLng(getNumeric(itemid))
	end If

	dim LoginUserid
	LoginUserid = getLoginUserid()

	dim oItem, ItemContent
	set oItem = new CatePrdCls
	oItem.GetItemData itemid

	if oItem.FResultCount=0 then
		Call Alert_Return("존재하지 않는 상품입니다.")
		response.End
	end if

	if oItem.Prd.Fisusing="N" then
		Call Alert_Return("판매가 종료되었거나 삭제된 상품입니다.")
		response.End
	end if

	'// 추가 이미지
	dim oADD
	set oADD = new CatePrdCls
	oADD.getAddImage itemid
	
	'//상품 후기 
	dim oEval,i,j,ix
	set oEval = new CEvaluateSearcher
	oEval.FPageSize = 5
	oEval.FScrollCount = 5
	oEval.FCurrpage = page
	If tabno = "31" then
		oEval.FPageSize = 3
		oEval.FsortMethod = "ph"
	End If 
	If tabno = "32" Then
		oEval.FsortMethod = "ne"
	End if
	oEval.FRectItemID = itemid
	
		'상품 후기가 있을때만 쿼리.
		if oItem.Prd.FEvalCnt>0  And tabno = 3 then
			oEval.getItemEvalList
		end If

		'포토 후기
		If  oItem.Prd.FEvalCnt_photo>0  And tabno = "31" Then
			oEval.getItemEvalListph
		End If 
		
		'테스터후기
		If tabno = "32" Then
			oEval.getItemEvalPopup()
		End If
	
	function ImageExists(byval iimg)
		if (IsNull(iimg)) or (trim(iimg)="") or (Right(trim(iimg),1)="\") or (Right(trim(iimg),1)="/") then
			ImageExists = false
		else
			ImageExists = true
		end if
	end function
	
	'//상품설명 추가
	dim addEx
	set addEx = new CatePrdCls
		addEx.getItemAddExplain itemid

	Dim tempsource , tempsize

	tempsource = oItem.Prd.FItemSource
	tempsize = oItem.Prd.FItemSize

	'// 티켓팅
	Dim IsTicketItem, oTicket
	IsTicketItem = (oItem.Prd.FItemDiv = "08")
	If IsTicketItem Then
		set oTicket = new CTicketItem
		oTicket.FRectItemID = itemid
		oTicket.GetOneTicketItem
	End if
%>

<% If tabno = 2 Then %>
<!-- 상품추가정보 -->
<ul class="pdtDetailListV16a">
	<!-- 상품고시정보 -->
	<li>
		<dl class="accordTab">
			<dt><p>상품 필수 정보</p></dt>
			<dd>
				<p>전자상거래 등에서의 상품정보 제공 고시에 따라 작성 되었습니다.</p>
				<ul class="essentialV16a">
				<% If (Not IsTicketItem) Then '// 티켓아닌경우 - 일반상품 %>
					<%
						IF addEx.FResultCount > 0 THEN
							FOR i= 0 to addEx.FResultCount-1
								If addEx.FItem(i).FinfoCode = "35005" Then
									If tempsource <> "" then
									response.write "<li><strong>재질 :</strong> "&tempsource&" </li>"
									End If
									If tempsize <> "" then
									response.write "<li><strong>사이즈 :</strong> "&tempsize&" </li>"
									End If
								End If
					%>
						<li style="display:<%=chkiif(addEx.FItem(i).FInfoContent="" And addEx.FItem(i).FinfoCode ="02004" ,"none","")%>;"><strong><%=addEx.FItem(i).FInfoname%> :</strong> <%=addEx.FItem(i).FInfoContent%></li>
					<%
							Next
						End If
					%>
					<% if oItem.Prd.IsSafetyYN then %>
					<li><strong>안전인증대상 :</strong> <%=oItem.Prd.FsafetyNum%></li>
					<% End If %>
					<% if oItem.Prd.IsAboardBeasong then %>
					<li><strong>해외배송 기준 중량 :</strong> <% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</li>
					<% End If %>
				<% else		'// 티켓상품 %>
					<li><strong>장르 :</strong> <%=oTicket.FOneItem.FtxGenre%></li>
					<li><strong>일시 :</strong> <%= FormatDate(oTicket.FOneItem.FstDt,"0000.00.00") %>~<%= FormatDate(oTicket.FOneItem.FedDt,"0000.00.00") %></li>
					<li><strong>장소 :</strong> <%=oTicket.FOneItem.FticketPlaceName%></li>
					<li><strong>관람등급 :</strong> <%=oTicket.FOneItem.FtxGrade%></li>
					<li><strong>관람시간 :</strong> <%=oTicket.FOneItem.FtxRunTime%></li>
				<% end if %>
				</ul>
				<% if oItem.Prd.IsAboardBeasong and (Not IsTicketItem) then %>
				<p class="abroadDespV16a"><strong>해외배송 기준 중량 :</strong> <% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</p>
				<% End If %>
			</dd>
		</dl>
	</li>
</ul>



<% elseIf tabno = 3 Or tabno = 31 Or tabno = 32 Then %>
<script type="text/javascript">
	function tabchange(v) {
		var gourl = v ;

		$(".itemDetailContV16a .tabCont div[id|='<%=tabname%>']").empty();
		$.ajax({
			type: "get",
			url: gourl,
			cache: false,
			success: function(message) 
			{			            	
				$(".itemDetailContV16a .tabCont div[id|='<%=tabname%>']").empty().append(message);
			}
		});
	}

	function goPageEval(v) {
		$(".itemDetailContV16a .tabCont div[id|='<%=tabname%>']").empty();
		$.ajax({
			type: "get",
			url: "category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg="+v+"&tabno=<%=tabno%>&tnm=<%=tabname%>",
			cache: false,
			success: function(message) 
			{			            	
				$(".itemDetailContV16a .tabCont div[id|='<%=tabname%>']").empty().append(message);
				$('html, body').animate({
                    scrollTop: $(".itemDetailContV16a .cmtTab").offset().top
                }, 100);
			}
		});			        
	}
</script>

<div class="bxWt1V16a">
	<ul class="btnBarV16a">
		<% If oItem.Prd.Ftestercnt > 0 Then %>
			<li <%=CHKIIF(tabno="3","class='current'","")%> name="cmtTab01" style="width:33.3%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=3&tnm=<%=tabname%>');return false;"><%=chkIIF(Not(IsTicketItem),"상품후기","관람평")%><span>(<%=oItem.Prd.FEvalCnt%>)</span></a></div></li>
			<li <%=CHKIIF(tabno="31","class='current'","")%> name="cmtTab02" style="width:33.3%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=31&tnm=<%=tabname%>');return false;">포토<%=chkIIF(Not(IsTicketItem),"후기","관람평")%><span>(<%=oItem.Prd.FEvalCnt_photo%>)</span></a></div></li>
			<% If oItem.Prd.Ftestercnt > 0 Then %>
			<li <%=CHKIIF(tabno="32","class='current'","")%> name="cmtTab03" style="width:33.4%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=32&tnm=<%=tabname%>');return false;">테스터후기<span>(<%=oItem.Prd.Ftestercnt%>)</span></a></div></li>
			<% End If %>
		<% Else %>
			<li <%=CHKIIF(tabno="3","class='current'","")%> name="cmtTab01" style="width:50%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=3&tnm=<%=tabname%>');return false;"><%=chkIIF(Not(IsTicketItem),"상품후기","관람평")%><span>(<%=oItem.Prd.FEvalCnt%>)</span></a></div></li>
			<li <%=CHKIIF(tabno="31","class='current'","")%> name="cmtTab02" style="width:50%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=31&tnm=<%=tabname%>');return false;">포토<%=chkIIF(Not(IsTicketItem),"후기","관람평")%><span>(<%=oItem.Prd.FEvalCnt_photo%>)</span></a></div></li>
		<% End If %>
	</ul>
</div>

<% IF oItem.Prd.FEvalCnt>0 Or oItem.Prd.Ftestercnt>0 then %>

	<div class="postContV16a" id="cmtTab01">
		<% If tabno = 3 Or tabno = 31 then %>
		<ul class="postListV16a">
		<% FOR i =0 to oEval.FResultCount-1 %>
			<li>
				<p class="star"><span class="starView<%=oEval.FItemList(i).FTotalPoint%>"></span></p>
				<% if Not(oEval.FItemList(i).FOptionName="" or isNull(oEval.FItemList(i).FOptionName)) then %>
				<div class="purchaseOption"><em><strong>구매옵션</strong> : <%=oEval.FItemList(i).FOptionName%></em></div>
				<% end if %>
				<div><%= nl2br(oEval.FItemList(i).FUesdContents) %></div>
				<p class="writer"><%= printUserId(oEval.FItemList(i).FUserID,2,"*") %> / <%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %></p>
				<% If oEval.FItemList(i).Flinkimg1<>"" Or oEval.FItemList(i).Flinkimg2<>"" Then %>
					<span class="photo">
						<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage1 %>" alt="포토1" /><% end if %>
						<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage2 %>" alt="포토2" /><% end if %>
					</span>
				<% End If %>
			</li>
		<% Next %>
		</ul>
		<% End If %>
		<% If tabno = 32 Then %>
		<ul class="postListV16a">
			<% FOR i =0 to oEval.FResultCount-1 %>
			<li>
				<p class="star"><span class="starView<%=oEval.FItemList(i).FTotalPoint%>"></span></p>
				<% if Not(oEval.FItemList(i).FOptionName="" or isNull(oEval.FItemList(i).FOptionName)) then %>
				<div class="purchaseOption"><em><strong>구매옵션</strong> : <%=oEval.FItemList(i).FOptionName%></em></div>
				<% end if %>
				<div>
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
				</div>
				<p class="writer"><%= printUserId(oEval.FItemList(i).FUserID,2,"*") %> / <%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %></p>
				<% If oEval.FItemList(i).Flinkimg1<>"" Or oEval.FItemList(i).Flinkimg2<>"" Then %>
					<span class="photo">
						<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=oEval.FItemList(i).Flinkimg1 %>" alt="포토1" /><% end if %>
						<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=oEval.FItemList(i).Flinkimg2 %>" alt="포토2" /><% end if %>
					</span>
				<% End If %>
			</li>
			<% Next %>
		</ul>
		<% End If %>
		<%=fnDisplayPaging_New(page,oEval.FTotalCount,8,4,"goPageEval")%>
	</div>
<% End If %>

<% IF (tabno="3" And oItem.Prd.FEvalCnt = 0) or (tabno="31" And oItem.Prd.FEvalCnt_photo = 0) Or (tabno="32" And oItem.Prd.Ftestercnt = 0) then %>
	<p class="txtNoneV16a">등록된 <%=chkIIF(Not(IsTicketItem),"상품후기가","관람평이")%> 없습니다.</p>
<% end if %>
<%
	ElseIf tabno = 5 Then
		'티켓상품 - 공연장 정보
		If IsTicketItem Then
			Response.Write "<div class=""inner10""><div id='lyrPlaceInfo'>"
					
			If isNull(oTicket.FOneItem.FplaceImgURL) = false AND oTicket.FOneItem.FplaceImgURL <> "" Then
				Response.Write "<img src='" & oTicket.FOneItem.FplaceImgURL & "' alt='공연장 정보' width='100%' />"
			End IF

			Response.Write oTicket.FOneItem.FplaceContents

			Response.Write "</div></div>"
			Response.Write "<script>" &_
						"	$(""#lyrPlaceInfo img[name='imgTT']"").css('width','100%');" &_
						"	$(""#lyrPlaceInfo td"").css('font-size','11px');" &_
						"</script>"
		end if
	End If

	Set addEx = Nothing
	Set oItem = Nothing
	Set oAdd = Nothing
	Set oEval = Nothing

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<script>
	$(function() {

		$('.pdtDetailListV16a li').find('dd').hide();
		$('.pdtDetailListV16a li:first-child').find('dd').show();
		$('.pdtDetailListV16a li:first-child').find('dt').addClass('selected');
		$('.pdtDetailListV16a li .accordTab > dt').click(function(){
			$('.pdtDetailListV16a li .accordTab > dd:visible').hide();
			$('.pdtDetailListV16a li .accordTab > dt').removeClass('selected');
			$(this).parents("dl").parents("li").find('dd').show();
			$(this).addClass('selected');
		});
	});
</script>