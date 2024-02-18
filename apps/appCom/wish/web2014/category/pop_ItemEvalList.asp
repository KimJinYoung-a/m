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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="text/javascript">
var vMtd = "<%=EvalDiv%>";
//function fnGoEvalPage(page) {
//	//	self.location.href="pop_ItemEvalList.asp?itemid=<%=itemid%>&sortMtd="+vMtd+"&cpg="+page;
//	$.ajax({
//		type: "get",
//		url: "/apps/appcom/wish/web2014/category/pop_ItemEvalList_ajax.asp?itemid=<%=itemid%>&sortMtd="+vMtd+"&cpg="+page,
//		cache: false,
//		success: function(message) 
//		{			            	
//			$("#evallist").empty().append(message);
//			$('html, body').animate({
//				scrollTop: 0 
//			}, 100);
//		}
//	});
//}

var vPg=1, vScrl=true;
$(function(){

	$(".itemDeatilV16a .itemDetailContV16a > div:first").show();
	$('.itemDeatilV16a .commonTabV16a li').click(function(){
		$(".itemDeatilV16a .itemDetailContV16a > div").hide();
		$('.itemDeatilV16a .commonTabV16a li').removeClass('current');
		$(this).addClass('current');
		var tabView = $(this).attr('name');
		$(".itemDeatilV16a .itemDetailContV16a div[id|='"+ tabView +"']").show();
		$('html, body').animate({scrollTop: $(".itemDeatilV16a").offset().top}, 500);
	});

	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "/apps/appcom/wish/web2014/category/pop_ItemEvalList_ajax.asp?itemid=<%=itemid%>&sortMtd=<%=sortMtd%>&EvalDiv="+vMtd+"&cpg="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#itemEvalListAll").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						//alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});
});

function fnGoEvalTab(mtd) {
	location.href="pop_ItemEvalList.asp?itemid=<%=itemid%>&sortMtd=<%=sortMtd%>&EvalDiv="+mtd;
}
</script>
</head>
<body class="default-font body-popup">

	<!-- contents -->
	<div id="content" class="content item-evalist">
		<div class="itemPrdV16a itemPrdV17 itemPrdV18">
			<!-- tab -->
			<div class="itemDeatilV16a itemDetailV18a">
				<!-- 탭추가 -->
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
				<!--// 탭추가 -->
				<div class="itemDetailContV16a">
					<% if oEval.FResultCount>0 then %>
					<div id="tab01" class="allReviewV17">
						<div class="postContV16a">
							<ul class="postListV16a" id="itemEvalListAll">
								<% For i =0 To oEval.FResultCount-1 %>
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
								<% Next %>
							</ul>
						</div>
					</div>
					<% end if %>
				</div>
			</div>
		</div>
	</div>
	<!-- //contents -->
<%
	set oItem =	Nothing
	set oEval =	Nothing
%>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->