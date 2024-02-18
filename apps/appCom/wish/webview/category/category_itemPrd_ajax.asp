<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	Description : 상품상세
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/wishCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/item/sp_item_qnacls.asp" -->
<!-- #include virtual="/lib/classes/item/PlusSaleItemCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/item/ticketItemCls.asp" -->
<%
	Dim tabno : tabno = requestCheckVar(getNumeric(request("tabno")),2)
	If tabno = "" Then tabno = 1
	dim itemid	:  itemid = requestCheckVar(request("itemid"),9)
	Dim page, vDisp
	page = RequestCheckVar(request("cpg"),10)
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

	dim PcdL, PcdM, PcdS, lp
	dim cdL, cdM, cdS
	dim flag : flag = request("flag")
	dim prePageNm
	
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

	vDisp = requestCheckVar(Request("disp"),18)
	If vDisp = "" Then
		vDisp = oItem.Prd.FcateCode
	End If
	cdL = requestCheckVar(Request("cdL"),3)
	cdM = requestCheckVar(Request("cdM"),3)
	cdS = requestCheckVar(Request("cdS"),3)
	if cdL="" then cdL = oItem.Prd.FcdL
	if cdM="" then cdM = oItem.Prd.FcdM
	if cdS="" then cdS = oItem.Prd.FcdS

	'// 이전 페이지명
	Select Case flag
		Case "b"
			prePageNm = "BEST"
		Case "s"
			prePageNm = "SALE"
		Case "n"
			prePageNm = "NEW"
		Case "e"
			prePageNm = "이벤트"
		Case Else
			prePageNm = getCategoryNameDB(cdL,cdM,cdS)
	End Select

	'// 추가 이미지
	dim oADD
	set oADD = new CatePrdCls
	oADD.getAddImage itemid
	
	'//상품 후기
	dim oEval,i,j,ix
	set oEval = new CEvaluateSearcher
	oEval.FPageSize = 8
	oEval.FScrollCount = 5
	oEval.FCurrpage = page
	If tabno = "21" then
	oEval.FsortMethod = "ph"
	End If 
	oEval.FRectItemID = itemid
	
		'상품 후기가 있을때만 쿼리.
		if oItem.Prd.FEvalCnt>0  And tabno = 2 then
			oEval.getItemEvalList
		end If

		'포토 후기
		If  oItem.Prd.FEvalCnt_photo>0  And tabno = "21" Then
			oEval.getItemEvalListph
		End If 
	
	'//상품 문의
	Dim oQna
	set oQna = new CItemQna
	
	''스페셜 브랜드일경우 상품 문의 불러오기
	If (oItem.Prd.IsSpecialBrand and oItem.Prd.FQnaCnt>0) And tabno = 3 Then
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

<script type="text/javascript">
	function Reviewtabchange(v){
		var gourl = v ;

		$("div#tabcontents").empty();
		$.ajax(
			{
				type: "get",
				url: gourl,
				cache: false,
				success: function(message) 
				{			            	
					$("div#tabcontents").empty().append(message);
					top.location.href = "#tabcontentslink";
				}
			});			        
	}
	
	function goPage(v){
		$("div#tabcontents").empty();
		$.ajax(
			{
				type: "get",
				url: "category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg="+v+"&tabno=<%=tabno%>",
				cache: false,
				success: function(message) 
				{			            	
					$("div#tabcontents").empty().append(message);
					top.location.href = "#tabcontentslink";
					
					onLoadFunc();
				}
			});			        
	}
	
	//상품문의 답변 보기/닫기
	function Replyshow(t){
		//$(eval("Replyid"+t)).toggle("slow")
		
		if ($(eval("Replyid"+t)).css("display")=='none'){
			$(eval("Replyid"+t)).css("display","block")
		}else{
			$(eval("Replyid"+t)).css("display","none")
		}
	}
	
	//상품 문의하기
	function qnaedit(){
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appcom/wish/webview/category/pop_itemQnA_write.asp",
			data: "itemid=<%= itemid %>",
			dataType: "text",
			async: false
		}).responseText;

		$("#modalCont").empty().append(rstStr);
		$("#modalCont").fadeIn();
		$("#modalCont #content").focus();
		$('body').css({'overflow':'hidden'});
		return false;
	}

</script>

<% If tabno = 1 Then %>
	<div class="tab-content inner" id="productDetail">
	    <h4>상품코드 : <%=itemid%></h4>
	    <div class="detail-box">
	        <div class="inner extend">
	    		<% If (Not IsTicketItem) Then '// 티켓아닌경우 - 일반상품 %>
					<%
					IF addEx.FResultCount > 0 THEN
						FOR i= 0 to addEx.FResultCount-1
							If addEx.FItem(i).FinfoCode = "35005" Then
								If tempsource <> "" then
					%>
									<dl><dt>재질</dt><dd><%= tempsource %></dd></dl>
					<%					
								End If
								If tempsize <> "" then
					%>
									<dl><dt>사이즈</dt><dd><%= tempsize %></dd></dl>
					<%
								End If
							End If
					%>
						<dl style="display:<%=chkiif(addEx.FItem(i).FInfoContent="" And addEx.FItem(i).FinfoCode ="02004" ,"none","")%>;"><dt><%=addEx.FItem(i).FInfoname%></dt><dd><%=addEx.FItem(i).FInfoContent%></dd></dl>
					<%
						Next
					End If
					%>									                 
					<%
					if oItem.Prd.IsSafetyYN then
					%>
						<dl><dt>안전인증대상</dt><dd><%=oItem.Prd.FsafetyNum%></dd></dl>
					<%
					End If
					%>
					<%
					if oItem.Prd.IsAboardBeasong then
					%>
						<dl><dt>해외배송 기준 중량</dt><dd><%= formatNumber(oItem.Prd.FitemWeight,0) %> g (1차 포장을 포함한 중량)</dd></dl>
					<%
					End If
					%>
				<% else		'// 티켓상품 %>
					<dl><dt>장르</dt><dd><%=oTicket.FOneItem.FtxGenre%></dd></dl>
					<dl><dt>일시</dt><dd><%= FormatDate(oTicket.FOneItem.FstDt,"0000.00.00") %>~<%= FormatDate(oTicket.FOneItem.FedDt,"0000.00.00") %></dd></dl>
					<dl><dt>장소</dt><dd><%=oTicket.FOneItem.FticketPlaceName%></dd></dl>
					<dl><dt>관람등급</dt><dd><%=oTicket.FOneItem.FtxGrade%></dd></dl>
				<% end if %>	                        
	        </div>
	        <!--<button class="btn type-c btn-more full-size">상품고시정보 더보기</button>//-->
	    </div>
	    
	    <% IF Not(oItem.Prd.FOrderComment="" or isNull(oItem.Prd.FOrderComment)) or Not(oItem.Prd.getDeliverNoticsStr="" or isNull(oItem.Prd.getDeliverNoticsStr)) THEN %>
	        <h4>주문시 유의사항</h4>
	        <div class="well type-c" id="ordAttend">
				<%= oItem.Prd.getDeliverNoticsStr %> <%= nl2br(oItem.Prd.FOrderComment) %>
	        </div>
			<script type="text/javascript">
				$(function(){
					$('#ordAttend').find("img").css("width","100%");
				});
			</script>
		<% end if %>
	
	    <h4>상품상세정보</h4>
	    <div class="detail-box product-spec-info">
	        <div class="inner" style="display:none;">
	            <div id="lyLoading" style="position:absolute;text-align:center;width:100%"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="height:16px;" /></div>
	            <iframe src="about:blank" id="detail_list" title="detail_list" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" class="autoheight" style="height: 13110px;"></iframe>
	        </div>
	        <button class="btn type-c btn-more full-size" onclick="fnMoreItemDesc(this)">상품상세정보 더보기</button>
	    </div>
	
		<% If (Not IsTicketItem) Then '티켓아닌경우 - 일반상품 %>
			<!-- #include virtual="/apps/appcom/wish/webview/category/inc_wishCollection.asp" -->
			<!-- #include virtual="/apps/appcom/wish/webview/category/inc_happyTogether.asp" -->
		<% end if %>
		
	    <div class="clear"></div>
	</div>

<% ElseIf tabno = 2 Or tabno = "21" Then %>
	<div class="tab-content" id="productReview">
	    <p class="t-c">
	        <button onclick="location.href='/apps/appcom/wish/webview/my10x10/goodsusing.asp';" class="btn type-e small margined" style="width:300px;"><%=chkIIF(Not(IsTicketItem),"상품 후기","관람평")%> 쓰기</button><br>
	        <strong>첫 <%=chkIIF(Not(IsTicketItem),"상품후기","관람평")%></strong>를 작성시에는 <strong>200P</strong>가 적립됩니다.<br>
	        모바일 카메라를 이용해 <strong>포토 <%=chkIIF(Not(IsTicketItem),"후기를","관람평을")%></strong>를 작성하실 수 있습니다.
	    </p>
	    <div class="diff"></div>
	    <div class="review">
	        <ul class="tabs type-b">
	            <li class="<%=CHKIIF(tabno="2","active","")%>">
	            	<a href="javascript:Reviewtabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=2');"><i class="icon-pen"></i><%=chkIIF(Not(IsTicketItem),"상품후기","관람평")%> (<%=oItem.Prd.FEvalCnt%>)</a>
	            </li>
	            <li class="<%=CHKIIF(tabno="21","active","")%>">
	            	<a href="javascript:Reviewtabchange('category_itemprd_ajax.asp?itemid=<%=itemid%>&cpg=1&tabno=21');"><i class="icon-camera"></i>포토<%=chkIIF(Not(IsTicketItem),"상품후기","관람평")%> (<%=oItem.Prd.FEvalCnt_photo%>)</a>
	            </li>
	        </ul>
	        
			<% IF oEval.FResultCount = 0 then %>
		        <div class="no-data">
		            등록된 <%=chkIIF(Not(IsTicketItem),"상품 후기가","관람평이")%> 없습니다.
		        </div>			
			<% Else %>	        
		        <ul class="review-list">
		        	<% FOR i =0 to oEval.FResultCount-1 %>
		            <li>
		                <div class="rating">
		                	<% if oEval.FItemList(i).FTotalPoint=1 then %>
		                		<span class="selected">★</span>★★★
		                	<% elseif oEval.FItemList(i).FTotalPoint=2 then %>
		                		<span class="selected">★★</span>★★
		                	<% elseif oEval.FItemList(i).FTotalPoint=3 then %>
		                		<span class="selected">★★★</span>★
		                	<% elseif oEval.FItemList(i).FTotalPoint=4 then %>
		                		<span class="selected">★★★★</span>
		                	<% end if %>
		                </div>
		                <p class="review-content">
		                    <%= nl2br(oEval.FItemList(i).FUesdContents) %>
		                    
							<% if oEval.FItemList(i).Flinkimg1<>"" then %>
								<img name="image_fix_1" src="<%= oEval.FItemList(i).getLinkImage1 %>" alt="" style="width:100%;" />
							<% End if %>
							<% if oEval.FItemList(i).Flinkimg2<>"" then %>
								<img name="image_fix_2" src="<%= oEval.FItemList(i).getLinkImage2 %>" alt="" style="width:100%;" />
							<% End if %>		                    
		                </p>
		                <div class="review-meta">
		                    <span class="userid"><%= printUserId(oEval.FItemList(i).FUserID,2,"*") %></span> / <span class="date"><%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %></span>
		                </div>
		            </li>
					<% Next %>
		        </ul>
                <div class="pagination">
                	<%=fnPaging_Apps("page", oEval.FtotalCount, oEval.FcurrPage, oEval.FPageSize, 4)%>
                </div>
			<% End If %>		        
	    </div>
	</div>

<% ElseIf tabno = 3 Then %>
    <div class="tab-content" id="productQNA">
        <p class="t-c">
            <button onclick="qnaedit()" class="btn type-e small margined" style="width:300px;">상품 문의하기</button><br>
            이 상품에 대한 궁금한 점을 문의해주세요. 
        </p>
        <div class="diff"></div>
        
        <% if oQna.FResultCount = 0 then %>
	        <div class="no-data">
	            등록된 상품 Q&amp;A가 없습니다.
	        </div>
		<% End If %>

		<% if oItem.Prd.IsSpecialBrand then %>
			<% if oQna.FResultCount >0 then %>
		        <ul class="qna-list">
		        	<% for i = 0 to oQna.FResultCount - 1 %>
		            <li class="qna-box">
		                <div class="q" <% IF oQna.FItemList(i).IsReplyOk THEN %> onclick="Replyshow(<%=i%>);"<% end if %>>
							<% IF oQna.FItemList(i).IsReplyOk THEN %>
								<div class="qna-type complete"><span class="label">답변완료</span></div>
							<% Else %>
								<div class="qna-type ing"><span class="label">답변대기</span></div>
							<% end if %>
		                    
		                    <p class="qna-content">
		                        <% = nl2br(oQna.FItemList(i).FContents) %>
		                    </p>
		                    <div class="qna-meta">
		                        <span class="userid"><%= printUserId(oQna.FItemList(i).FUserID,2,"*") %></span> / <span class="date"><%= FormatDate(oQna.FItemList(i).FRegdate, "0000.00.00") %></span>
		                    </div>
		                </div>
						
						<% IF oQna.FItemList(i).IsReplyOk THEN %>
			                <div class="a" id="Replyid<%=i%>" style="display:none">
			                    <div class="qna-type"></div>
			                    <p class="qna-content">
			                        <%= nl2br(oQna.FItemList(i).FReplycontents) %>
			                    </p>
			                </div>
						<% end if %>
		            </li>
		            <% Next %>
		        </ul>
		        <div class="pagination">
		        	<%=fnPaging_Apps("page", oQna.FtotalCount, oQna.FcurrPage, oQna.FPageSize, 4)%>
		        </div>
			<% End If %>
		<% End If %>
    </div>

<%
	ElseIf tabno = 5 Then
		'티켓상품 - 공연장 정보
		If IsTicketItem Then
%>
    <div class="tab-content" id="locationInfo">
        <div class="inner" style="padding-top:30px;">
        	<% If isNull(oTicket.FOneItem.FplaceImgURL) = false AND oTicket.FOneItem.FplaceImgURL <> "" Then %>
            	<img src="<%= oTicket.FOneItem.FplaceImgURL %>" alt="공연장 정보" width='100%'>
            <% end if %>
        </div>
    </div>
		<% end if %>
<%
	ElseIf tabno = 6 Then
		'티켓상품 - 취소환불/수령 안내
		If IsTicketItem Then
%>
    <div class="tab-content" id="ticketCancel">
        <div class="inner" style="padding-top:30px;">
            <h4>티켓 수령 안내</h4>
            <div class="well type-c">
                <h5 class="red">티켓 현장수령 (예매번호 입장)</h5>
                <ul class="txt-list">
                    <li>공연 당일 현장 교부처에서 예매번호 및 본인 확인 후 티켓을 수령하실 수 있습니다.</li>
                    <li>마이텐바이텐 &gt; 주문배송조회 메뉴에서 예매확인서를 프린트하여 가시면 편리합니다.</li>
                </ul>
            </div>
            <h4>예매 취소시 유의사항</h4>
            <h5 class="red">예매 취소 마감일</h5>
            <table class="rounded">
                <thead>
                <tr>
                    <th>관람일이 평일 및<br>주말일 경우</th>
                    <th>관람일이 공휴일 및<br>공휴일 익일일 경우</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>관람일 전 평일 오후<br>6시까지 취소 가능</td>
                    <td>공휴일 전 평일 오후<br>6시까지 취소 가능</td>
                </tr>
                </tbody>
            </table>
            <h5 class="red">취소 수수료 안내</h5>
            <table class="rounded">
                <thead>
                <tr>
                    <th>관람일 9일전<br>~관람일 7일전</th>
                    <th>관람일 6일전<br>~관람일 3일전</th>
                    <th>관람일 2일전<br>~관람일 1일전</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>티켓금액의 <span class="red">10%</span></td>
                    <td>티켓금액의 <span class="red">20%</span></td>
                    <td>티켓금액의 <span class="red">30%</span></td>
                </tr>
                </tbody>
            </table>
            <h5 class="red">시간 흐름으로 보는 취소수수료</h5>
            <table class="rounded">
                <thead>
                    <tr>
                        <th>예매당일~10일전</th>
                        <th>9일전~7일전</th>
                        <th>6일전~3일전</th>
                        <th>2일전~1일전</th>
                        <th>관람당일</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>취소수수료 없음<br><span class="red">(100%환불)</span></td>
                        <td>취소수수료<br>티켓금액의<br><span class="red">10%</span></td>
                        <td>취소수수료<br>티켓금액의<br><span class="red">10%</span></td>
                        <td>취소수수료<br>티켓금액의<br><span class="red">10%</span></td>
                        <td>취소<br>불가</td>
                    </tr>
                    <tr>
                        <td>웹 상으로는<br>취소 가능<br>(MY텐바이텐)<br>주문취소 페이지</td>
                        <td colspan="3">고객센터문의<br>월 ~ 금 9:00 ~ 18:00<br>(토,일요일 및 공휴일 휴무)</td>
                        <td>취소<br>불가</td>
                    </tr>
                </tbody>
            </table>
            <ul class="red small">
                <li>*상품의 특성에 따라서, 취소수수료 정책이 달라질 수 있습니다.(각 상품 예매시 취소수수료 확인)</li>
                <li>*날짜 지정이 없는 스키/행사/테마 등 상시 상품은 예매당일만 취소 가능합니다. 각 상품의 상세정보페이지에서 취소 및 변경에 대한 부분을 확인해 보시기 바랍니다.</li>
                <li>*취소는 부분취소를 하실 수 없으며 전체 취소만 가능합니다. 부분취소를 원하실 경우 결제방법과 상관없이 부분취소 된 금액만큼 무통장 입금으로 환불해 드립니다.</li>
            </ul>
        </div>
    </div>
<%
		end if

	End If

	Set addEx = Nothing
	Set oItem = Nothing
	Set oAdd = Nothing
	Set oEval = Nothing
	Set oQna = Nothing
	Set oQna = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->