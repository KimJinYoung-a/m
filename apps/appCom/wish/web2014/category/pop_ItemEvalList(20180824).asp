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
	if page="" then page=1

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
	oEval.FRectItemID = itemid

	if sortMtd="ph" then
		oEval.getItemEvalListph
	ElseIf sortMtd="ne" Then '// 테스터 후기
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
<title>10x10: 상품 후기</title>
<script type="text/javascript">
var vMtd = "<%=sortMtd%>";
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
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "/apps/appcom/wish/web2014/category/pop_ItemEvalList_ajax.asp?itemid=<%=itemid%>&sortMtd="+vMtd+"&cpg="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#itemEvalListAll").append($(message).find(".postListV16a").html());
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});
});

function fnGoEvalTab(mtd) {
	self.location.href="pop_ItemEvalList.asp?itemid=<%=itemid%>&sortMtd="+mtd;
}
</script>
</head>
<body>
<div class="heightGrid bg-grey">
	<div class="container popWin">
		<!-- content area -->
		<div class="content bg-grey" id="contentArea" style="padding-bottom:0;">
			<div class="cmtCont">
				<!-- 목록 -->
				<div class="tab01 noMove">
					<ul class="tabNav <%=chkiif(oItem.Prd.Ftestercnt > 0," tNum3"," tNum2")%>">
						<li <%=CHKIIF(sortMtd="","class=""current""","")%>><a href="" onclick="fnGoEvalTab(''); return false;">전체보기<span></span></a></li>
						<li <%=CHKIIF(sortMtd="ph","class=""current""","")%>><a href="" onclick="fnGoEvalTab('ph'); return false;">포토후기<span></span></a></li>
						<% If oItem.Prd.Ftestercnt > 0 Then %>
						<li <%=CHKIIF(sortMtd="ne","class=""current""","")%>><a href="" onclick="fnGoEvalTab('ne'); return false;">테스터후기<span></span></a></li>
						<% End If %>
					</ul>
					<div class="tabContainer tPad05" style="background-color:#fff;">
						<div class="tabContent" id="evallist">
						<% if oEval.FResultCount>0 then %>
							<div class="postscript">
								<ul class="postListV16a" id="itemEvalListAll">
								<% FOR i =0 to oEval.FResultCount-1 %>
									<li>
										<p class="star"><span class="starView<%=oEval.FItemList(i).FTotalPoint%>"></span></p>
										<% if Not(oEval.FItemList(i).FOptionName="" or isNull(oEval.FItemList(i).FOptionName)) then %>
										<div class="purchaseOption"><em><strong>구매옵션</strong> : <%=oEval.FItemList(i).FOptionName%></em></div>
										<% end if %>
										<div>
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
											<%= nl2br(oEval.FItemList(i).FUesdContents) %>
											<% End If %>
										</div>

										<p class="writer"><%= FormatDate(oEval.FItemList(i).FRegdate, "0000.00.00") %> <span class="bar">/</span> <%= printUserId(oEval.FItemList(i).FUserID,2,"*") %></p>

										<span class="photo">
											<% if oEval.FItemList(i).Flinkimg1<>"" then %><img src="<%=chkiif(sortMtd="ne",oEval.FItemList(i).Flinkimg1,oEval.FItemList(i).getLinkImage1) %>" alt="포토1" /><% end if %>
											<% if oEval.FItemList(i).Flinkimg2<>"" then %><img src="<%=chkiif(sortMtd="ne",oEval.FItemList(i).Flinkimg2,oEval.FItemList(i).getLinkImage2) %>" alt="포토2" /><% end if %>
										</span>
									</li>
								<% NEXT %>
								</ul>
								<%'=fnDisplayPaging_New(page,oEval.FTotalCount,chkIIF(sortMtd="ph",5,10),5,"fnGoEvalPage")%>
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
		<!-- //content area -->
	</div>
</div>
<%
	set oItem =	Nothing
	set oEval =	Nothing
%>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->