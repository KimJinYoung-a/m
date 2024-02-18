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
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
	Dim tabno : tabno = requestCheckVar(request("tabno"),2)
	Dim tabname : tabname = requestCheckVar(request("tnm"),5)
	Dim tcnt : tcnt = requestCheckVar(request("tcnt"),10)
	Dim dealitemid : dealitemid = requestCheckVar(request("dealitemid"),10)
	Dim i
	If tabno = "" Then tabno = 4		'// 1번(상품상세)는 Ajax로 처리 안함

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

	'//상품 문의
	Dim oQna
	set oQna = new CItemQna
	
	''스페셜 브랜드일경우 상품 문의 불러오기
	If (oItem.Prd.IsSpecialBrand and oItem.Prd.FQnaCnt>0) And tabno = 4 Then
		oQna.FRectItemID = itemid
		oQna.FPageSize = 5
		oQna.FCurrpage = page
		oQna.ItemQnaList
	End If
	
%>
<script type="text/javascript">
<!--
	function goPageQna(v) {
		$.ajax({
			type: "get",
			url: "/apps/appcom/wish/web2014/deal/act_itemQna.asp?itemid=<%=itemid%>&cpg="+v+"&tabno=<%=tabno%>&tnm=<%=tabname%>",
			cache: false,
			success: function(message) 
			{			            	
				$("#itemqna").empty().append(message);
				$('html, body').animate({
                    scrollTop: $(".itemDetailContV16a .cmtTab").offset().top
                }, 100);
			}
		});			        
	}
	function tabchange(v) {
		var gourl = v ;
		$.ajax({
			type: "get",
			url: gourl,
			cache: false,
			success: function(message) 
			{			            	
				$("#itemqna").empty().append(message);
			}
		});
	}
	function modiItemQna(idx) {
		fnAPPpopupBrowserURL("상품문의 하기","<%=wwwUrl%>/apps/appcom/wish/web2014/deal/pop_ItemQnaList.asp?id="+idx+"&mode=wr&itemid=<%=itemid%>");
	}
	// 상품 문의 삭제
	function delItemQna(idx){
		if(confirm("상품문의를 삭제 하시겠습니까?")){
			$.ajax({
				type: "get",
				url: "/apps/appcom/wish/web2014/deal/doitemqna.asp?id="+idx+"&itemid=<%=itemid%>&mode=del",
				cache: false,
				success: function(message) {
					goPageQna(1);
				}
			});
		}
	}
//-->
</script>
						<div class="btnAreaV16a">
							<p><button type="button" class="btnV16a btnRed2V16a" onclick="fnAPPpopupBrowserURL('상품문의 하기','<%=wwwUrl%>/apps/appcom/wish/web2014/deal/pop_ItemQnaList.asp?itemid=<%=itemid%>&mode=wr'); return false;">상품문의 하기</button></p>
						</div>
						<% if oQna.FResultCount > 0 then %>
						<% if oItem.Prd.IsSpecialBrand then %>
						<ul class="qnaListV16a">
							<% For i = 0 To oQna.FResultCount - 1 %>
							<li>
								<div class="q">
									<% if oQna.FItemList(i).Fsecretyn="Y" and LoginUserid <> oQna.FItemList(i).FUserid then %>
									<div><i class="icon lock"></i> 비밀글입니다.</div>
									<% Else %>
									<div><% If oQna.FItemList(i).Fsecretyn="Y" Then %><i class="icon lock"></i> <% End If %><% = nl2br(oQna.FItemList(i).FContents) %></div>
									<% End If %>
									<p class="writer"><%= printUserId(oQna.FItemList(i).FUserID,2,"*") %> / <%= FormatDate(oQna.FItemList(i).FRegdate, "0000.00.00") %></p>
									<% if (LoginUserid<>"") and (LoginUserid=oQna.FItemList(i).FUserid) then %>
									<p class="btnAreaV16a" style="">
										<% IF Not(oQna.FItemList(i).IsReplyOk) THEN %><button type="button" class="btnV16a btnWht2V16a" onClick="modiItemQna('<%= oQna.FItemList(i).Fid %>');return false;">수정</button><% end if %>
										<button type="button" class="btnV16a btnWht2V16a" onclick="delItemQna('<%= oQna.FItemList(i).Fid %>');return false">삭제</button>
									</p>
									<% end if %>
								</div>
								<% IF oQna.FItemList(i).IsReplyOk THEN %>
								<div class="a">
									<% if oQna.FItemList(i).Fsecretyn="Y" and LoginUserid <> oQna.FItemList(i).FUserid then %>
									<div><i class="icon lock"></i> 비밀글입니다.</div>
									<% Else %>
									<div><% If oQna.FItemList(i).Fsecretyn="Y" Then %><i class="icon lock"></i> <% End If %><%= nl2br(oQna.FItemList(i).FReplycontents) %></div>
									<% End If %>
								</div>
								<% end if %>
							</li>
							<% Next %>
						</ul>
						<% End If %>
						<% Else %>
						<p class="txtNoneV16a">등록된 상품문의가 없습니다.</p>
						<% End If %>
						<% if oQna.FTotalCount>5 then %>
						<div class="btnAreaV16a">
							<p><button type="button" class="btnV16a btnRed1V16a" onclick="fnAPPpopupBrowserURL('전체보기','<%=wwwUrl%>/apps/appcom/wish/web2014/deal/pop_ItemQnaList.asp?itemid=<%=itemid%>'); return false;">전체보기</button></p>
						</div>
						<% end if %>
<%
	Set oItem = Nothing
	Set oQna = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->