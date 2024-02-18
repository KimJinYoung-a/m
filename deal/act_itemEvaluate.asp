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
	Dim tcnt : tcnt = requestCheckVar(request("tcnt"),10)

	If tabno = "" Then tabno = 3		'// 1번(상품상세)는 Ajax로 처리 안함

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
	
%>
<script type="text/javascript">
<!--
	function tabchange(v) {
		var gourl = v ;

		$("#itemeval").empty();
		$.ajax({
			type: "get",
			url: gourl,
			cache: false,
			success: function(message) 
			{			            	
				$("#itemeval").empty().append(message);
			}
		});
	}
	const _reportArr=[];
	function fnEvaluateReport(evaluate_type,report_cnt,idx){
		var sameReport = false;
	<% If not(IsUserLoginOK) Then %>
		top.location.href = "<%=M_SSLUrl%>/login/login.asp?backpath=<%=Server.URLencode(request.serverVariables("SCRIPT_NAME")&"?"&Request.ServerVariables("QUERY_STRING")) %>";
		return false;
	<% end if %>
		var i=0;
		while(i < _reportArr.length){
			if(_reportArr[i]==idx){
				sameReport = true;
				i = _reportArr.length;
			}
			i=i+1;
		}
		if(sameReport){
			alert("이미 신고된 후기입니다. 신고 10회 누적 시 내용이 가려집니다.");
			$("#reportalert"+idx).show();
			setTimeout(function() {
				$("#reportalert"+idx).hide();
			}, 5000);
			_reportArr.push(idx);
			return false;
		}
		else{
			if(confirm("후기를 신고하시겠어요?")){
				$.ajax({
					type: "POST",
					url:"/apps/appcom/wish/web2014/category/act_evalreport.asp?mode=add&evaluate_type="+evaluate_type+"&evalidx="+idx,
					dataType: "text",
					async: false,
					success: function (str) {
						reStr = str.split("|");
						if(reStr[0]=="OK"){
							_reportArr.push(idx);
							alert(reStr[1]);
							if(report_cnt==9){
								$("#reportblind"+idx).show();
							}
							return false;
						}else if (reStr[0]=="Err"){
							_reportArr.push(idx);
							alert(reStr[1]);
							return false;
						}else{
							alert("잘못된 오류입니다.");
							return false;
						}
					}
				});
			}
		}
	}
//-->
</script>
						<div class="btnAreaV16a">
							<a href="" onclick="chk_myeval('<%=itemid%>');return false;" class="btnV16a btnRed1V16a">후기 작성하기</a>
						</div>
						<div class="bxWt1V16a">
							<ul class="btnBarV16a">
								<li <%=CHKIIF(tabno="3","class='current'","")%> name="cmtTab01" style="width:50%;"><div><a href="" onclick="tabchange('/deal/act_itemEvaluate.asp?itemid=<%=itemid%>&tcnt=<%=tcnt%>&cpg=1&tabno=3&tnm=<%=tabname%>');return false;">상품후기<span>(<%=oItem.Prd.FEvalCnt%>/<%=tcnt%>)</span></a></div></li>
								<li <%=CHKIIF(tabno="31","class='current'","")%> name="cmtTab02" style="width:50%;"><div><a href="" onclick="tabchange('/deal/act_itemEvaluate.asp?itemid=<%=itemid%>&tcnt=<%=tcnt%>&cpg=1&tabno=31&tnm=<%=tabname%>');return false;">포토후기<span>(<%=oItem.Prd.FEvalCnt_photo%>)</span></a></div></li>
							</ul>
						</div>
						<% If oEval.FResultCount < 1 Then %>
						<p class="txtNoneV16a">등록된 상품후기가 없습니다.</p>
						<% Else %>
						<div class="postContV16a" id="post01">
							<ul class="postListV16a">
								<% FOR i =0 to oEval.FResultCount-1 %>
								<li>
									<div class="items review">
										<span class="icon icon-rating">
											<% If oEval.FItemList(i).FTotalPoint <> "" Then %>
												<i style="width:<%=oEval.FItemList(i).FTotalPoint*20%>%">리뷰 종합 별점 <%=oEval.FItemList(i).FTotalPoint*20%>점</i>
											<% End If %>
										</span>
										<p class="writer"><%= printUserId(oEval.FItemList(i).FUserID,2,"*") %> / <%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %></p>
									</div>
									<% if Not(oEval.FItemList(i).FOptionName="" or isNull(oEval.FItemList(i).FOptionName)) then %>
									<div class="purchaseOption"><em><strong>구매옵션</strong> : <%=oEval.FItemList(i).FOptionName%></em></div>
									<% end if %>
									<div><%= nl2br(oEval.FItemList(i).FUesdContents) %></div>
									
									<button type="button" class="btn-Declaration" onclick="fnEvaluateReport('<%=oEval.FItemList(i).Fevaluate_type%>',<%=oEval.FItemList(i).Freport_cnt%>,<%=oEval.FItemList(i).Fidx%>);return false;">신고</button>
                                    <div class="alert" id="reportalert<%=oEval.FItemList(i).Fidx%>" style="display:none;"><span>신고 10회 누적 시 내용이 가려집니다</span></div>

									<div class="bg-blind" id="reportblind<%=oEval.FItemList(i).Fidx%>" style="display:<% if oEval.FItemList(i).Freport_cnt>9 then %><% else %>none<% end if %>;">여러 명의 신고로 가려진 후기입니다</div>

									<% If oEval.FItemList(i).Flinkimg1<>"" Or oEval.FItemList(i).Flinkimg2<>"" Or oEval.FItemList(i).Flinkimg3<>"" Then %>
										<p class="photo">
											<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage1 %>" alt="포토1" /><% end if %>
											<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage2 %>" alt="포토2" /><% end if %>
											<% if oEval.FItemList(i).Flinkimg3<>"" then %><img src="<%=oEval.FItemList(i).getLinkImage3 %>" alt="포토3" /><% end if %>
										</p>
									<% End If %>
								</li>
								<% Next %>
							</ul>
							<% if (tabno="3" and oItem.Prd.FEvalCnt>5) or (tabno="31" and oItem.Prd.FEvalCnt_photo>3) or (tabno = "32" And oItem.Prd.Ftestercnt > 3) then %>
							<div class="btnAreaV16a">
								<p><button type="button" class="btnV16a btnRed1V16a" onclick="fnOpenModal('/deal/pop_ItemEvalList.asp?itemid=<%=itemid%>&sortMtd=<% If tabno="31" Then Response.write "ph" End If %><% If tabno="32" Then Response.write "ne" End If %>'); return false;">전체보기</button></p>
							</div>
							<% End If %>
						</div>
						<% End If %>
<%
	Set oItem = Nothing
	Set oEval = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->