<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim userid, page,  pagesize, SortMethod,ix,EvaluatedYN,i, lp
userid      = getEncLoginUserID
page        = requestCheckVar(request("page"),9)
pagesize    = requestCheckVar(request("pagesize"),9)
SortMethod  = requestCheckVar(request("SortMethod"),10)
EvaluatedYN	= requestCheckVar(request("EvaluatedYN"),2)


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
dim EvList
set EvList = new CEvaluateSearcher
EvList.FRectUserID = Userid 
EvList.FPageSize = pagesize 
EvList.FCurrPage	= page
EvList.FScrollCount = 3
EvList.FRectEvaluatedYN=EvaluatedYN
EvList.FSortMethod = SortMethod 


if EvaluatedYN="Y" then
	EvList.EvalutedItemListNew ''후기 가져오기
else
	EvList.NotEvalutedItemListNew ''후기 안쓰인 상품 가져오기
end if

'//상품 후기 마일리지
Dim cMil , vMileArr
Dim vMileValue : vMileValue = 100
If isdoubleMileage Then
	vMileValue = 200
End If 

Set cMil = New CEvaluateSearcher
	cMil.FRectUserID = Userid
	cMil.FRectMileage = vMileValue
	vMileArr = cMil.getEvaluatedTotalMileCnt
Set cMil = Nothing
%>

<title>10x10: 상품 후기</title>
<script type="text/javascript">
function DelEval(OrdSr,ItID,Opt){
	if (confirm('상품평을 삭제 하시겠습니까? \n\n삭제후 재작성이 불가능합니다.')){
		var frm = document.dFrm;
		frm.orderserial.value = OrdSr;
		frm.itemid.value = ItID;
		frm.optionCD.value = Opt;
		
		frm.action="/apps/appCom/wish/web2014/my10x10/goodsUsing_delProc.asp";
		frm.submit();
		
	}
}


var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				
				if(vPg <= <%=EvList.FTotalPage%>){
					$.ajax({
						url: "goodsusing_act.asp?EvaluatedYN=<%=EvaluatedYN%>&page="+vPg,
						cache: false,
						success: function(message) {
							if(message!="") {
								$("#lyrDFList").append(message);
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
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
	fnAPPchangPopCaption('상품후기');
});
function AddEval1(OrdSr,itID,OptCd){
	//location.href = '/apps/appCom/wish/web2014/my10x10/goodsUsingWrite.asp?orderserial=' + OrdSr + '&itemid=' + itID + '&optionCD=' + OptCd + '';
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '상품후기', [BtnType.SEARCH, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsUsingWrite.asp?orderserial=' + OrdSr + '&itemid=' + itID + '&optionCD=' + OptCd + '&referVal=M');
}
function fnEventGo(eventid){
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '이벤트', [BtnType.SEARCH, BtnType.CART], '<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=' + eventid);
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="content myReview" id="contentArea">
			<div class="myTenNoti">
				<ul>
					<li>상품 후기를 작성하시면 100point가 적립되며 배송정보 [출고완료]이후부터 작성하실 수 있습니다.</li>

					<% If EvaluatedYN = "N" Then %>
					<div class="estimated-mileage">
						<p>적립 예상 마일리지<span class="counting">(<%=vMileArr(0,0)%>건)</span>
						<b class="point color-red"><%=FormatNumber(vMileArr(1,0),0)%>point</b></p>
						<% If isdoubleMileage Then %>
						<div class="dubble-mileage"><a href="javascript:fnEventGo(85975);">마일리지 2배 적립 이벤트 (~<%=isdoubledate%>)</a></div>
						<% End If %>
					</div>
					<% End If %>
				</ul>
			</div>
			<div class="inner10">
				<div class="tab02 tMar10">
					<ul class="tabNav tNum2">
						<li <%= ChkIIF(EvaluatedYN="N"," class='current'","") %>><a href="?EvaluatedYN=N">상품후기 작성</a></li>
						<li <%= ChkIIF(EvaluatedYN="Y"," class='current'","") %>><a href="?EvaluatedYN=Y">상품후기 수정</a></li>
					</ul>
				</div>
				<form name="evaluateFrm" method="get" action="" style="margin:0px;">
				<input type="hidden" name="mode" value="" />
				<input type="hidden" name="page" value="" />
				<input type="hidden" name="EvaluatedYN" value="<%= EvaluatedYN %>" />
				<input type="hidden" name="orderserial" value="" />
				<input type="hidden" name="itemid" value="" />
				<input type="hidden" name="optionCD" value="" />
				<ul class="reviewList" id="lyrDFList">
				<% if EvaluatedYN="Y" then '' 상품후기 조회/수정 %>
					<% if EvList.FResultCount > 0 then %>
						<% for  i = 0 to EvList.FResultCount-1 %>
						<li>
							<div class="odrInfo">
								<span><%= formatdate(CStr(EvList.FItemList(i).FOrderDate),"0000.00.00") %></span>
								<span>주문번호(<%= EvList.FItemList(i).FOrderSerial %>)</span>
							</div>
							<div class="pdtWrap">
								<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=EvList.FItemList(i).FItemid%>'); return false;">
									<p class="pic"><img src="<%=EvList.FItemList(i).FBasicImage%>" alt="<%= EvList.FItemList(i).FItemname %>" /></p>
									<div class="pdtInfo">
										<p class="pBrand">[<%=EvList.FItemList(i).FMakerName%>]</p>
										<p class="pName"><%= EvList.FItemList(i).FItemname %></p>
										<% If EvList.FItemList(i).FOptionName <> "" Then %>
										<p class="option">옵션 : <%= EvList.FItemList(i).FOptionName %></p>
										<% End If %>
										<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
									</div>
								</a>
							</div>
							<div class="goReview">
								<p class="ftRt">
									<span class="button btM2 btWht cBk1"><a href="" onClick="AddEval1('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;">수정</a></span>
									<span class="button btM2 btWht cBk1"><a href="" onClick="DelEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;">삭제</a></span>
								</p>
							</div>
						</li>
						<% next %>
					<% else %>
						<p class="noData ct"><strong>등록하신 상품후기가 없습니다.</strong></p>
					<% end if %>
				<% else '' 상품후기 작성 %>
					<% if EvList.FResultCount = 0 then %>
					<p class="noData ct"><strong>남기실 상품 후기가 없습니다.</strong></p>
					<% else %>
					<% for  i = 0 to EvList.FResultCount-1 %>
					<li>
						<div class="odrInfo">
							<span><%= formatdate(CStr(EvList.FItemList(i).FOrderDate),"0000.00.00") %></span>
							<span>주문번호(<%= EvList.FItemList(i).FOrderSerial %>)</span>
						</div>
						<div class="pdtWrap">
							<a href="" onclick="fnAPPpopupBrowserURL('상품정보','<%= wwwUrl %>/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=EvList.FItemList(i).FItemid%>'); return false;">
								<p class="pic"><img src="<%=EvList.FItemList(i).FBasicImage%>" alt="<%= EvList.FItemList(i).FItemname %>" /></p>
								<div class="pdtInfo">
									<p class="pBrand">[<%=EvList.FItemList(i).FMakerName%>]</p>
									<p class="pName"><%= EvList.FItemList(i).FItemname %></p>
									<% If EvList.FItemList(i).FOptionName <> "" Then %>
									<p class="option">옵션 : <%= EvList.FItemList(i).FOptionName %></p>
									<% End If %>
									<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
								</div>
							</a>
						</div>
						<div class="goReview">
							<% if EvList.FItemList(i).FEvalCnt=0 then %>
							<p class="firstReview">★ 첫후기 200Point</p>
							<% end if %>
							<p class="ftRt"><span class="button btM2 btRed cWh1"><a href="" onclick="AddEval1('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>'); return false;">후기작성하기</a></span></p>
						</div>
					</li>
					<% next %>
					<%end if%>
				<% end if %>
				</ul>
				</form>
			</div>
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
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
<% Set EvList = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->