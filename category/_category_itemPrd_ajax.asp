<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/_CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/gift/gifttalkCls.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<!-- #include Virtual="/lib/util/functions.asp" -->
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
	
	Dim Safety
	'//제품 안전 인증 정보
	set Safety = new CatePrdCls
	Safety.getItemSafetyCert itemid

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
					<li><strong>등급 :</strong> <%=oTicket.FOneItem.FtxGrade%></li>
					<li><strong>시간 :</strong> <%=oTicket.FOneItem.FtxRunTime%></li>
				<% end if %>
				</ul>
				<% if oItem.Prd.IsAboardBeasong and (Not IsTicketItem) then %>
				<p class="abroadDespV16a"><strong>해외배송 기준 중량 :</strong> <% = formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</p>
				<% End If %>
				<% If Safety.FResultCount > 0  Then %>
				<% If Safety.FItem(0).FSafetyYN <> "N" Then %>
				<% If Safety.FItem(0).FSafetyYN="Y" Then %>
				<div class="safety-mark">
					<strong>제품 안전 인증 정보</strong>
					<% For i= 0 To Safety.FResultCount-1 %>
					<% If Safety.FItem(i).FcertDiv <> "" And  Not IsNull(Safety.FItem(i).FcertDiv) Then %>
					<div>
						<span class="ico"></span>
						<span><em><%=fnSafetyDivCodeName(Safety.FItem(i).FsafetyDiv)%></em><br /><%=Safety.FItem(i).FcertNum%></span>
					</div>
					<% Else %>
					<div>
						<span class="ico"></span>
						<span><em>전기용품 – 공급자 적합성 확인</em><br />공급자 적합성 확인 대상 품목으로 인증번호 없음</span>
					</div>
					<% End If %>
					<% Next %>
				</div>
				<% Else %>
				<div class="safety-mark">
					<strong>제품 안전 인증 정보</strong>
					<div>
						<span>해당 상품 인증 정보는 판매자가 등록한 상품 상세 설명을 참조하시기 바랍니다.</span>
					</div>
				</div>
				<% End If %>
				<% End If %>
				<% End If %>
			</dd>
		</dl>
	</li>
	<!-- 배송/교환/환불 -------------------------->
	<!-- #include file="./inc_DeliveryDescription.asp" -->
</ul>



<% elseIf tabno = 3 Or tabno = 31 Or tabno = 32 Then %>
<div class="btnAreaV16a">
	<a href="" onclick="chk_myeval('<%=itemid%>');return false;" class="btnV16a btnRed1V16a">후기 작성하기</a>
</div>

<script type="text/javascript">
	function chk_myeval(v){
		$.ajax({
			type: "POST",
			url:"/category/act_myEval.asp?itemid="+v,
			dataType: "text",
			async: false,
	        success: function (str) {
	        	reStr = str.split("|");
				if(reStr[0]=="01"){
					alert(reStr[1]);
					return false;
				}else if (reStr[0]=="02"){
					alert(reStr[1]);
					return false;
				}else if (reStr[0]=="03"){
					alert(reStr[1]);
					return false;
				}else if (reStr[0]=="04"){
					alert(reStr[1]);
					AddEval(reStr[2],reStr[3],reStr[4]);
					return false;
				}else if (reStr[0]=="05"){
					AddEval(reStr[2],reStr[3],reStr[4]);
					return false;
				}else{
					alert("잘못된 오류입니다.");
					return false;
				}
	        }
		});
	}

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
			<li <%=CHKIIF(tabno="3","class='current'","")%> name="cmtTab01" style="width:33.3%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=3&tnm=<%=tabname%>');return false;"><%=chkIIF(Not(IsTicketItem),"상품후기","후기")%><span>(<%=oItem.Prd.FEvalCnt%>)</span></a></div></li>
			<li <%=CHKIIF(tabno="31","class='current'","")%> name="cmtTab02" style="width:33.3%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=31&tnm=<%=tabname%>');return false;">포토후기<span>(<%=oItem.Prd.FEvalCnt_photo%>)</span></a></div></li>
			<% If oItem.Prd.Ftestercnt > 0 Then %>
			<li <%=CHKIIF(tabno="32","class='current'","")%> name="cmtTab03" style="width:33.4%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=32&tnm=<%=tabname%>');return false;">테스터후기<span>(<%=oItem.Prd.Ftestercnt%>)</span></a></div></li>
			<% End If %>
		<% Else %>
			<li <%=CHKIIF(tabno="3","class='current'","")%> name="cmtTab01" style="width:50%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=3&tnm=<%=tabname%>');return false;"><%=chkIIF(Not(IsTicketItem),"상품후기","후기")%><span>(<%=oItem.Prd.FEvalCnt%>)</span></a></div></li>
			<li <%=CHKIIF(tabno="31","class='current'","")%> name="cmtTab02" style="width:50%;"><div><a href="" onclick="tabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=31&tnm=<%=tabname%>');return false;">포토후기<span>(<%=oItem.Prd.FEvalCnt_photo%>)</span></a></div></li>
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
				<% If oEval.FItemList(i).Flinkimg1<>"" Or oEval.FItemList(i).Flinkimg2<>"" Or oEval.FItemList(i).Flinkimg3<>"" Then %>
					<span class="photo">
						<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage1 %>" alt="포토1" /><% end if %>
						<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage2 %>" alt="포토2" /><% end if %>
						<% if oEval.FItemList(i).Flinkimg3<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage3 %>" alt="포토3" /><% end if %>
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
				<% If oEval.FItemList(i).Flinkimg1<>"" Or oEval.FItemList(i).Flinkimg2<>"" Or oEval.FItemList(i).Flinkimg3<>"" Then %>
					<span class="photo">
						<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=oEval.FItemList(i).Flinkimg1 %>" alt="포토1" /><% end if %>
						<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=oEval.FItemList(i).Flinkimg2 %>" alt="포토2" /><% end if %>
						<% if oEval.FItemList(i).Flinkimg3<>"" then %><img src="<%=oEval.FItemList(i).Flinkimg3 %>" alt="포토3" /><% end if %>
					</span>
				<% End If %>
			</li>
			<% Next %>
		</ul>
		<% End If %>
		<%''=fnDisplayPaging_New(page,oEval.FTotalCount,8,4,"goPageEval")%>
	</div>

	<% if (tabno="3" and oItem.Prd.FEvalCnt>5) or (tabno="31" and oItem.Prd.FEvalCnt_photo>3) or (tabno = "32" And oItem.Prd.Ftestercnt > 3) then %>
	<div class="btnAreaV16a">
		<p><button type="button" onclick="fnOpenModal('pop_ItemEvalList.asp?itemid=<%=itemid%>&sortMtd=<% If tabno="31" Then Response.write "ph" End If %><% If tabno="32" Then Response.write "ne" End If %>'); return false;" class="btnV16a btnRed1V16a">전체보기</button></p>
	</div>
	<% end if %>
<% End If %>

<% IF (tabno="3" And oItem.Prd.FEvalCnt = 0) or (tabno="31" And oItem.Prd.FEvalCnt_photo = 0) Or (tabno="32" And oItem.Prd.Ftestercnt = 0) then %>
	<p class="txtNoneV16a">등록된 <%=chkIIF(Not(IsTicketItem),"상품후기가","후기가")%> 없습니다.</p>
<% end if %>

<% ElseIf tabno = 4 Then %>
<script type="text/javascript">
	function goPageQna(v) {
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
<script type="text/javascript">
	// 상품 문의 수정
	function modiItemQna(idx) {
		location.href="/category/pop_itemQnAList.asp?itemid=<%=itemid%>&mode=wr&id="+idx;
	}
	// 상품 문의 삭제
	function delItemQna(idx){
		if(confirm("상품문의를 삭제 하시겠습니까?")){
			location.href="/my10x10/doitemqna.asp?id="+idx+"&itemid=<%=itemid%>&mode=del";
		}
	}

	$(function(){
		$(".qnaListV16a li .a").hide();
		$(".qnaListV16a li").each(function(){
			if ($(this).children(".a").length > 0) {
				$(this).children('.q').addClass("hasA");
			}
		});
	
		$(".qnaListV16a li .q").click(function(){
			$(".qnaListV16a li .a").hide();
			if($(this).next().is(":hidden")){
				$(this).parent().children('.a').show();
			}else{
				$(this).parent().children('.a').hide();
			};
		});
	});
</script>
<div class="btnAreaV16a">
	<p><button type="button" class="btnV16a btnRed2V16a" onclick="location.href='pop_ItemQnaList.asp?itemid=<%=itemid%>&mode=wr';">상품문의 하기</button></p>
</div>
<% if oQna.FResultCount = 0 then %>
<p class="txtNoneV16a">등록된 상품문의가 없습니다.</p>
<% End If %>
<% if oItem.Prd.IsSpecialBrand then %>
<% if oQna.FResultCount >0 then %>
<ul class="qnaListV16a">
	<% for i = 0 to oQna.FResultCount - 1 %>
	<li>
		<div class="q">
			<% if oQna.FItemList(i).Fsecretyn="Y" and LoginUserid <> oQna.FItemList(i).FUserid then %>
			<div><i class="icon lock"></i> 비밀글입니다.</div>
			<% Else %>
			<div><% If oQna.FItemList(i).Fsecretyn="Y" Then %><i class="icon lock"></i> <% End If %><% = nl2br(oQna.FItemList(i).FContents) %></div>
			<% End If %>
			<p class="writer"><%= printUserId(oQna.FItemList(i).FUserID,2,"*") %> / <%= FormatDate(oQna.FItemList(i).FRegdate, "0000.00.00") %></p>
			<% if (LoginUserid<>"") and (LoginUserid=oQna.FItemList(i).FUserid) then %>
			<p class="btnAreaV16a">
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
<% if oQna.FTotalCount>5 then %>
<div class="btnAreaV16a">
	<p><button type="button" class="btnV16a btnRed1V16a" onclick="location.href='pop_ItemQnaList.asp?itemid=<%=itemid%>';">전체보기</button></p>
</div>
<% end if %>
<%''=fnDisplayPaging_New(page,oQna.FTotalCount,5,4,"goPageQna")%>
<% End If %>
<% End if %>
<%
	ElseIf tabno = 5 Then
		'티켓상품 - 위치 정보
		If IsTicketItem Then
			Response.Write "<div class=""inner10""><div id='lyrPlaceInfo'>"
					
			If isNull(oTicket.FOneItem.FplaceImgURL) = false AND oTicket.FOneItem.FplaceImgURL <> "" Then
				Response.Write "<img src='" & oTicket.FOneItem.FplaceImgURL & "' alt='위치 정보' width='100%' />"
			End IF

			Response.Write oTicket.FOneItem.FplaceContents

			Response.Write "</div></div>"
			Response.Write "<script>" &_
						"	$(""#lyrPlaceInfo img[name='imgTT']"").css('width','100%');" &_
						"	$(""#lyrPlaceInfo td"").css('font-size','11px');" &_
						"</script>"
		end if

	ElseIf tabno = 6 Then
		'티켓상품 - 취소환불/수령 안내
		If IsTicketItem Then
%>
<div>
	<table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding-bottom:30px;font-size:11px;">
	<tr>
		<td><img src="http://fiximage.10x10.co.kr/web2011/category/tkt_cancel_tit_01.gif" style="width:83px;" /></td>
	</tr>
	<tr>
		<td class="tPad10"><span class="cC40"><strong>티켓 현장수령</strong> (예매번호 입장)</span></td>
	</tr>
	<tr>
		<td class="tPad05">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="center" style="padding-top:7px;" valign="top" width="15"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
				<td style="padding:2px 0;">공연 당일 현장 교부처에서 예매번호 및 본인 확인 후 티켓을 수령하실 수 있습니다.</td>
			</tr>
			<tr>
				<td align="center" style="padding-top:8px;" valign="top"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
				<td style="padding:2px 0;">마이텐바이텐>주문배송조회 메뉴에서 예매확인서를 프린트하여 가시면 편리합니다.</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="tPad20"><img src="http://fiximage.10x10.co.kr/web2011/category/tkt_cancel_tit_02.gif" style="width:122px;"/></td>
	</tr>
	<tr>
		<td style="padding:10px;">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="tPad10"><span class="c333"><strong>예매 취소 마감일</strong></span></td>
			</tr>
			<tr>
				<td class="tPad05">
					<table bgcolor="#eaeaea" border="0" cellpadding="1" cellspacing="1" width="100%">
					<tr align="center" bgcolor="#f7f7f7">
						<td height="24" style="padding-top:3px;" width="50%"><strong>관람일이 평일 및 주말일 경우</strong></td>
						<td style="padding-top:3px;" width="50%"><strong>관람일이 공휴일 및 공휴일 익일일 경우</strong></td>
					</tr>
					<tr align="center" bgcolor="#ffffff">
						<td height="24" style="padding-top:3px;">관람일 전 평일 오후 6시까지 취소 가능</td>
						<td style="padding-top:3px;">공휴일 전 평일 오후 6시까지 취소 가능</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="tPad15"><span class="c333"><strong>취소 수수료 안내</strong></span></td>
			</tr>
			<tr>
				<td class="tPad05">
					<table bgcolor="#eaeaea" border="0" cellpadding="1" cellspacing="1" width="100%">
					<tr align="center" bgcolor="#f7f7f7">
						<td height="24" style="padding-top:3px;" width="33%"><strong>관람일 9일전~관람일 7일전</strong></td>
						<td style="padding-top:3px;" width="34%"><strong>관람일 6일전~관람일 3일전</strong></td>
						<td style="padding-top:3px;" width="33%"><strong>관람일 2일전~관람일 1일전</strong></td>
					</tr>
					<tr align="center" bgcolor="#ffffff">
						<td height="24" style="padding-top:3px;">티켓금액의 <span class="cC40">10%</span></td>
						<td style="padding-top:3px;">티켓금액의 <span class="cC40">20%</span></td>
						<td style="padding-top:3px;">티켓금액의 <span class="cC40">30%</span></td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="tPad10">- 위 조건이지만, 예매 당일 밤 12시 이전 취소 시에는 취소수수료가 없습니다.</td>
			</tr>
			<tr>
				<td class="tPad15"><span class="c333"><strong>시간 흐름으로 보는 취소수수료</strong></span></td>
			</tr>
			<tr>
				<td class="tPad05"><img src="http://fiximage.10x10.co.kr/web2011/category/tkt_cancel_img.gif" width="100%"></td>
			</tr>
			<tr>
				<td class="tPad10">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td align="center" style="padding-top:7px;" valign="top" width="15"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">상품의 특성에 따라서, 취소수수료 정책이 달라질 수 있습니다. (각 상품 예매시 취소수수료 확인)</td>
					</tr>
					<tr>
						<td align="center" style="padding-top:7px;" valign="top"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">날짜 지정이 없는 스키/행사/테마 등 상시 상품은 예매당일만 취소 가능합니다. 각 상품의 상세정보페이지에서 취소 및 변경에 대한<br> 부분을 확인해 보시기 바랍니다.</td>
					</tr>
					<tr>
						<td align="center" style="padding-top:7px;" valign="top"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">취소는 부분취소를 하실 수 없으며 전체 취소만 가능합니다. 부분취소를 원하실 경우 결제방법과 상관없이 부분취소 된 금액만큼 
							<br> 무통장 입금으로 환불해 드립니다.</td>
					</tr>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="tPad05"></td>
	</tr>
	<tr>
		<td class="tPad20"><img src="http://fiximage.10x10.co.kr/web2011/category/tkt_cancel_tit_03.gif" style="width:137px;" /></td>
	</tr>
	<tr>
		<td class="tPad05">동일 상품에 대해서 날짜, 시간, 좌석, 가격 등급, 결제 등의 일부 변경을 원하시는 경우, 기존 예매 건을 취소하시고 재예매 하셔야 합니다.<br> 단, 할인은 재예매 시점을 기준으로 적용됩니다.</td>
	</tr>
	<tr>
		<td class="tPad20"><img src="http://fiximage.10x10.co.kr/web2011/category/tkt_cancel_tit_04.gif" style="width:50px;" /></td>
	</tr>
	<tr>
		<td class="tPad05">취소 수수료가 있는 환불의 경우 결제방법에 상관없이 취소수수료를 제외한 금액을 무통장 입금 또는 예치금으로 환불해 드립니다.</td>
	</tr>
	<tr>
		<td style="padding:10px;">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td><span class="c333"><strong>신용카드 결제의 경우</strong></span></td>
			</tr>
			<tr>
				<td class="tPad05">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td align="center" style="padding-top:7px;" valign="top" width="15"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">티켓금액의 100% 환불 받는 취소의 경우 일반적으로 당사의 취소 처리가 완료되고 4~5일 후 카드사의 취소가 확인됩니다.<br> (체크카드도 동일함.)</td>
					</tr>
					<tr>
						<td align="center" style="padding-top:7px;" valign="top"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">티켓금액의 100% 환불 받지 않는 취소의 경우 취소수수료를 제외한 금액을 무통장 입금 또는 예치금으로 환불해 드립니다.</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="tPad10"><span class="c333"><strong>무통장 입금 또는 실시간 계좌이체의 경우</strong></span></td>
			</tr>
			<tr>
				<td class="tPad05">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td align="center" style="padding-top:7px;" valign="top" width="15"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">티켓금액의 100% 환불 받는 취소의 경우 취소 신청 후 바로 취소 처리가 됩니다.</td>
					</tr>
					<tr>
						<td align="center" style="padding-top:7px;" valign="top" width="15"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">취소수수료를 제외한 금액을 무통장 입금 또는 예치금으로 환불해 드립니다.</td>
					</tr>
					<tr>
						<td align="center" style="padding-top:7px;" valign="top"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">환불은 반드시 예매자 본인 명의의 계좌로만 받으실 수 있습니다.</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="tPad10"><span class="c333"><strong>휴대폰 결제의 경우</strong></span></td>
			</tr>
			<tr>
				<td class="tPad05">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td align="center" style="padding-top:7px;" valign="top" width="15"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">티켓금액의 100% 환불 받는 취소의 경우 취소 신청 후 바로 취소 처리가 됩니다.</td>
					</tr>
					<tr>
						<td align="center" style="padding-top:7px;" valign="top"><img src="http://fiximage.10x10.co.kr/web2011/category/bullet_red.gif" style="width:4px;" /></td>
						<td style="padding:2px 0;">티켓금액의 100% 환불 받지 않는 취소의 경우 취소수수료를 제외한 금액을 무통장입금 또는 예치금으로 환불 받습니다.</td>
					</tr>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="tPad20"><img src="http://fiximage.10x10.co.kr/web2011/category/tkt_cancel_tit_05.gif" style="width:50px;" /></td>
	</tr>
	<tr>
		<td class="tPad05">문의사항은 <strong class="cC40">1:1게시판</strong> 또는 <strong>고객행복센터(<span class="cC40">1644-6030</span>)</strong>를 이용해 주시기 바랍니다.</td>
	</tr>
	</table>
</div>
<%
		end if

	End If

	Set addEx = Nothing
	Set oItem = Nothing
	Set oAdd = Nothing
	Set oEval = Nothing
	Set oQna = Nothing
	Set Safety = Nothing

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