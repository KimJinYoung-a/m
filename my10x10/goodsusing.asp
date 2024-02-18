<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 상품후기 리스트
' History : 2014-09-01 이종화 생성
'####################################################
%>

<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "상품후기"

dim userid, page, pagesize, SortMethod,ix,EvaluatedYN,i, lp, iy
Dim pushType, vAmplitudeFirstReview, vAmplitudeMileage, regcomp 
Dim LoopCount, myevalcnt
LoopCount=0

vAmplitudeFirstReview = "N"
vAmplitudeMileage = 100

Userid		= getEncLoginUserID
page		= requestCheckVar(request("page"),9)
pagesize	= requestCheckVar(request("pagesize"),9)
SortMethod	= requestCheckVar(request("SortMethod"),10)
EvaluatedYN	= requestCheckVar(request("EvaluatedYN"),2)
pushType 	= requestCheckVar(request("pushtype"),10)
regcomp		= requestCheckVar(request("regcomp"),2)

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
dim EvList, OrderList
set EvList = new CEvaluateSearcher
EvList.FRectUserID = Userid
EvList.FPageSize = pagesize 
EvList.FCurrPage	= page
EvList.FScrollCount = 3
EvList.FRectEvaluatedYN=EvaluatedYN
EvList.FSortMethod = SortMethod 


if EvaluatedYN="Y" then
	EvList.EvalutedItemListNew ''후기 가져오기
	myevalcnt = request("ecnt")
	If myevalcnt="" Then
		myevalcnt = EvList.FTotalCount
	End If
Else
	EvList.NotEvalutedItemListNew ''후기 안쓰인 상품 가져오기
	
	set OrderList = new CEvaluateSearcher
	OrderList.FRectUserID = Userid
	OrderList.FPageSize = pagesize 
	OrderList.FCurrPage	= page
	OrderList.FScrollCount = 3
	OrderList.FRectEvaluatedYN=EvaluatedYN
	OrderList.FSortMethod = SortMethod
	OrderList.NotEvalutedItemOrderList
end If

'//상품 후기 마일리지
Dim cMil , vMileArr
Dim vMileValue : vMileValue = 100
If isdoubleMileage Then
	vAmplitudeMileage = 200
	vMileValue = 200
End If 

Set cMil = New CEvaluateSearcher
	cMil.FRectUserID = Userid
	cMil.FRectMileage = vMileValue
	vMileArr = cMil.getEvaluatedTotalMileCnt
Set cMil = Nothing
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script>
fnAmplitudeEventMultiPropertiesAction("view_my_review_list","pushtype","<%=pushType%>");
<%if regcomp = "Y" then%>
fnAmplitudeEventMultiPropertiesAction("complete_my_review_regist","","");
<%end if%>

$(function() {
	// product detail tab control
	$(".myReviewV18 .my-review-conts > div:first").show();
	$('.myReviewV18 .commonTabV16a li').click(function(){
		$(".myReviewV18 .my-review-conts > div").hide();
		$('.myReviewV18 .commonTabV16a li').removeClass('current');
		$(this).addClass('current');
		var tabView = $(this).attr('name');
		$(".myReviewV18 .my-review-conts div[id|='"+ tabView +"']").show();
		$('html, body').animate({scrollTop: $(".my-review-conts").offset().top}, 500);
	});
});
function DelEval(OrdSr,ItID,Opt){
	if (confirm('상품평을 삭제 하시겠습니까? \n\n삭제후 재작성이 불가능합니다.')){
		var frm = document.dFrm;
		frm.orderserial.value = OrdSr;
		frm.itemid.value = ItID;
		frm.optionCD.value = Opt;
		
		frm.action="/my10x10/goodsUsing_delProc.asp";
		frm.submit();
		
	}
}

function goPage(page){
	var frm = document.evaluateFrm;
	frm.page.value=page;
	frm.submit();
}
</script>
<title>10x10: 상품후기 쓰기</title>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div id="content" class="content myReview myReviewV18">
				<div class="">
					<!-- tab -->
					<div>
						<ul class="commonTabV16a">
							<li <%= ChkIIF(EvaluatedYN="N"," class='current'","") %> name="tab01" style="width:50%;" onclick="location.href='?EvaluatedYN=N'">후기 작성 <span>(<%=vMileArr(0,0)%>)</li>
							<li <%= ChkIIF(EvaluatedYN="Y"," class='current'","") %> name="tab02" style="width:50%;" onclick="location.href='?EvaluatedYN=Y&ecnt=<%=myevalcnt%>'">후기 관리</li>
						</ul>
						<form name="evaluateFrm" method="get" action="" style="margin:0px;">
						<input type="hidden" name="mode" value="" />
						<input type="hidden" name="page" value="" />
						<input type="hidden" name="EvaluatedYN" value="<%= EvaluatedYN %>" />
						<input type="hidden" name="orderserial" value="" />
						<input type="hidden" name="itemid" value="" />
						<input type="hidden" name="optionCD" value="" />
						</form>
						<div class="my-review-conts">
						<% If EvaluatedYN="Y" Then '' 상품후기 조회/수정 %>
							<div id="tab02" class="RveiwListV18 manageRviwV18" >
								<% if EvList.FResultCount = 0 then %>
								<p class="noData ct"><strong>작성된 상품 후기가 없습니다.</strong></p>
								<% Else %>
								<% For i=0 To EvList.FResultCount-1 %>
								<div class="review">
									<div class="inner">
										<div class="odrInfo">
											<div class="write-date"><%= FormatDate(EvList.FItemList(i).FRegDate, "0000.00.00") %> 작성</div>
											<span class="order-num">주문번호 <%=EvList.FItemList(i).FOrderSerial%></span>
											<% If EvList.FItemList(i).FShopName<>"" Then %>
											<span class="offshop">| <em class="color-blue"><% = EvList.FItemList(i).FShopName %></em></span>
											<% End If %>
										</div>
										<div class="pdtWrap">
											<a href="/category/category_itemprd.asp?itemid=<%=EvList.FItemList(i).FItemid%>" target="_blank">
												<p class="pic"><img src="<%=EvList.FItemList(i).FBasicImage%>" alt="<%= EvList.FItemList(i).FItemname %>"></p>
												<div class="pdtInfo items">
													<p class="pBrand">[<%=EvList.FItemList(i).FMakerName%>]</p>
													<p class="pName"><%= EvList.FItemList(i).FItemname %></p>
													<% if (EvList.FItemList(i).FOptionName <> "") then %>
													<p class="option">옵션 : <%= EvList.FItemList(i).FOptionName %></p>
													<% end if %>
													<% If EvList.FItemList(i).FTotalPoint=1 Then %>
													<span class="icon icon-rating"><i style="width:20%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=2 Then %>
													<span class="icon icon-rating"><i style="width:40%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=3 Then %>
													<span class="icon icon-rating"><i style="width:60%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=4 Then %>
													<span class="icon icon-rating"><i style="width:80%;"></i></span>
													<% ElseIf EvList.FItemList(i).FTotalPoint=5 Then %>
													<span class="icon icon-rating"><i style="width:100%;"></i></span>												
													<% Else %>
													<span class="icon icon-rating"><i style="width:0%;"></i></span>
													<% End If %>
													<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong></strong>원</p>
												</div>
											</a>
											<div class="edit">
												<button class="btn-modify" onClick="AddEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>','<%= EvList.FItemList(i).FDetailIDX %>'); return false;"><span class="icon icon-edit_gray"></span>수정</button>
												<button class="btn-delete" onClick="DelEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;"><span class="icon icon-edit_trash"></span>삭제</button>
											</div>
										</div>
									</div>
								</div>
								<% Next %>
								<% End If %>
							</div>
						<% Else'' 상품후기 작성 %>
							<div id="tab01" class="RveiwListV18 wirteRviwV18">
							<% If EvaluatedYN = "N" Then %>
								<style>
								.wirteRviwV18 .evt-photo2 {padding:1.95rem 0 .85rem .5rem; margin:0 1rem; color:#6e6e6e; font-size:1rem; line-height:1.5rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; word-break:keep-all; text-align:left;}
								.wirteRviwV18 .evt-photo2 .label {position:relative; top:.2rem; margin-right:.8rem; padding:.3rem .6rem .2rem; font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; color:#fff; background:#ff3131; border-radius:1rem;}
								.wirteRviwV18 .evt-photo2 .color-red {display:flex; align-items:center; margin-bottom:.5rem;}
								.wirteRviwV18 .evt-photo2 .color-red > div {align-self:flex-start;}
								.wirteRviwV18 .evt-photo2 b {font-size:1.11rem; font-family:'CoreSansCBold', 'AppleSDGothicNeo-Bold', 'NotoSansKRBold';}
								.wirteRviwV18 .evt-photo2 em {font-family:'CoreSansCMedium', 'AppleSDGothicNeo-SemiBold', 'NotoSansKRMedium';}
								</style>
								<% If Date() >= "2020-10-19" And Date() <= "2020-10-23" Then %>
								<div class="evt-photo2">
									<div class="color-red">
										<div><span class="label">event</span></div>
										<div><b>지금 포토후기를 작성하면 400p를 추가로 드려요.</b><br/><em>(기본지급 100p + 추가지급 400p)</em></div>
									</div>
									이벤트 기간 : 10월 19일 – 10월 23일 <br>추가 지급일 : 10월 27일 <br>*추가 지급된 마일리지는 미사용 시 11월 17일 00:00에 소멸됩니다.
								</div>
								<% Else %>
								<p><em><%=vMileArr(0,0)%></em>건의 후기를 작성하시면 <br>약 <em><%=FormatNumber(vMileArr(1,0),0)%>p</em>의 마일리지를 적립받으실 수 있습니다.</p>
								<% End If %>
							<% End If %>
							<% If isdoubleMileage Then %>
								<div class="dubble-mileage"><a href="/event/eventmain.asp?eventid=100241">마일리지 2배 적립 이벤트 (~<%=isdoubledate%>)</a></div>
							<% End If %>
							<% if EvList.FResultCount = 0 then %>
								<p class="noData ct"><strong>남기실 상품 후기가 없습니다.</strong></p>
							<% Else %>
								<% For ix=0 To OrderList.FResultCount-1 %>
								<% For iy=0 To EvList.FResultCount-1 %>
									<% If OrderList.FItemList(ix).FOrderSerial=EvList.FItemList(iy).FOrderSerial Then %>
								<% If LoopCount=0 Then %>
								<div class="review">
									<div class="inner">
										<div class="odrInfo">
											<div class="order-num">주문번호 <%=EvList.FItemList(iy).FOrderSerial%></div>
											<span class="date"><%= FormatDate(EvList.FItemList(iy).FOrderDate, "0000.00.00") %></span>
											<% If EvList.FItemList(iy).FShopName<>"" Then %>
											<span class="offshop">| <em class="color-blue"><% = EvList.FItemList(iy).FShopName %></em></span>
											<% End If %>
										</div>
								<% End If %>
										<div class="pdtWrap">
											<a href="/category/category_itemprd.asp?itemid=<%=EvList.FItemList(iy).FItemid%>" target="_blank">
												<p class="pic"><img src="<%=EvList.FItemList(iy).FBasicImage%>" alt="<%= EvList.FItemList(iy).FItemname %>"></p>
												<div class="pdtInfo">
													<p class="pBrand">[<%=EvList.FItemList(iy).FMakerName%>]</p>
													<p class="pName"><%= EvList.FItemList(iy).FItemname %></p>
													<!-- <% if (EvList.FItemList(iy).FOptionName <> "") then %>
													<p class="option">옵션 : <%= EvList.FItemList(iy).FOptionName %></p>
													<% end if %> -->
													<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(iy).FItemCost,0) %></strong>원</p>
												</div>
											</a>
											<div class="edit">
												<% if EvList.FItemList(iy).FEvalCnt=0 then %>
												<em class="color-blue">첫 후기 200p</em>
												<% end if %>
												<button onClick="window.event.cancelBubble=true; fnAmplitudeEventMultiPropertiesAction('click_my_review_write','firstreview|productname|brandname|mileage','<%=vAmplitudeFirstReview%>|<%=replace(replace(EvList.FItemList(i).FItemname,"'","")," ","")%>|<%=replace(replace(EvList.FItemList(i).FMakerName,"'","")," ","")%>|<%=vAmplitudeMileage%>');AddEval('<%= EvList.FItemList(iy).FOrderSerial %>','<%= EvList.FItemList(iy).FItemID %>','<%= EvList.FItemList(iy).FItemOption %>','<%= EvList.FItemList(iy).FDetailIDX %>'); return false;"><span class="icon icon-edit_red"></span>쓰기</button>
											</div>
										</div>
										<% LoopCount=LoopCount+1 %>
								<% Else %>
									<% LoopCount=0 %>
								<% End If %>
								<% Next %>
								<% If LoopCount=0 Then %>
									</div>
								</div>
								<% End If %>
								<% Next %>
							<% End If %>
							</div>
						</div>
						<% End If %>
						</div>
						<% if EvList.FResultCount > 0 then %>
						<%=fnDisplayPaging_New(page,EvList.FTotalCount,pagesize,4,"goPage")%>
						<% end if %>												
						</div>
					</div>
				</div>
			</div>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
	<form name="dFrm" method="post" action="">
	<input type="hidden" name="orderserial" value="">
	<input type="hidden" name="itemid" value="">
	<input type="hidden" name="optionCD" value="">
	</form>
</div>
</body>
</html>
<%
set EvList= Nothing
set OrderList= Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->