<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'####################################################
' Description : 마이텐바이텐 - 테스터후기 리스트
' History : 2016-01-06 원승현 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_tester_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventprizeCls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "테스터후기"

dim userid, page,  pagesize, SortMethod,cdL,vDisp,ix,EvaluatedYN,i, lp
userid      = getEncLoginUserID
page        = requestCheckVar(request("page"),9)
pagesize    = requestCheckVar(request("pagesize"),9)
SortMethod  = requestCheckVar(request("SortMethod"),10)
vDisp		= requestCheckVar(request("disp"),3)
EvaluatedYN	= requestCheckVar(request("EvaluatedYN"),2)



'####### Tester 당첨 여부. #######
Dim clsEvtPrize	: set clsEvtPrize  = new CEventPrize
clsEvtPrize.FUserid = userid
	clsEvtPrize.fnGetTesterEventCheck
	if clsEvtPrize.FTotCnt>0 then
		response.Cookies("tinfo")("isTester") = true
	else
		response.Cookies("tinfo")("isTester") = false
	end if
set clsEvtPrize = Nothing
'####### Tester 당첨 여부. #######



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
EvList.FScrollCount =10
EvList.FRectDisp= vDisp
EvList.FRectEvaluatedYN=EvaluatedYN
EvList.FSortMethod = SortMethod 

if EvaluatedYN="Y" then
	EvList.EvalutedItemList ''후기 가져오기 
else 
	EvList.NotEvalutedItemList ''후기 안쓰인 상품 가져오기 
end if
%>

<script type="text/javascript">
function SwapCate(comp){
    var disp = comp.value;
    var frm = comp.form;
	frm.disp.value = disp;
	frm.submit();
}

function DelEval(idx,pcode,ecode){
	if (confirm('상품평을 삭제 하시겠습니까? \n\n삭제후 재작성이 불가능합니다.')){
	    var frm = document.dFrm;
	    frm.idx.value = idx;
	    frm.evtprize_code.value = pcode;
	    frm.evt_code.value = ecode;
		
		frm.action="/my10x10/mytester/goodsUsing_delProc.asp";
		frm.submit();
		
	}
}

function writeCompleteAction()
{
	location.replace('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/mytester/?EvaluatedYN=Y');
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
						url: "index_act.asp?EvaluatedYN=<%=EvaluatedYN%>&page="+vPg,
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
	
});

function TesterAddEval(idx,pzCode,eCode,itID){	
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '테스터후기', [], '<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/mytester/goodsUsingWrite.asp?idx=' + idx + '&pcode=' + pzCode + '&ecode=' + eCode + '&itemid=' + itID + '');
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="container popWin">
		<div class="content myReview" id="contentArea">
			<div class="myTenNoti">
				<ul>
					<li>테스터 후기 작성 시 마일리지 1,000 point가 적립됩니다.</li>
					<li>테스터 후기 내용 삭제 시 적립된 마일리지는 자동 삭제됩니다.</li>
					<li>테스터 후기 작성 기간이 지나면 후기 내용을 수정/삭제할 수 없습니다.</li>
					<li>우수 테스터 후기는 테스터 진행 담당자가 별도 연락을 드립니다.</li>
				</ul>
			</div>
			<div class="inner10">
				<div class="tab02 tMar10 noMove">
					<ul class="tabNav tNum2">
						<% if EvaluatedYN="N" then %>
							<li class="current"><a href="?EvaluatedYN=N">테스터 후기 작성</a></li>
							<li><a href="?EvaluatedYN=Y">테스터 후기 수정</a></li>
						<% Else %>
							<li><a href="?EvaluatedYN=N">테스터 후기 작성</a></li>
							<li class="current"><a href="?EvaluatedYN=Y">테스터 후기 수정</a></li>
						<% End If %>
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
					<% if EvaluatedYN="Y" then %>
						<%'// 테스터 후기 수정 %>
						<% if EvList.FResultCount = 0 then %>
							<p class="noData ct"><strong>등록하신 테스터 후기가 없습니다.</strong></p>
						<% else %>
							<% for  i = 0 to EvList.FResultCount-1 %>
								<li>
									<div class="odrInfo">
										<span>작성기간 : <%=EvList.FItemList(i).FstartDate%> ~ <%=EvList.FItemList(i).FendDate%></span>
									</div>
									<div class="pdtWrap">
										<p class="pic"><img src="<%=getThumbImgFromURL(EvList.FItemList(i).FImageIcon2,"150","150","true","false")%>" alt="<%= EvList.FItemList(i).FItemName %>" /></p>
										<div class="pdtInfo">
											<p class="pBrand"><%= EvList.FItemList(ix).FMakerName %></p>
											<p class="pName"><%= EvList.FItemList(i).FItemName %></p>
											<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
										</div>
									</div>
									<div class="goReview">
										<p class="ftRt">
											<span class="button btM2 btWht cBk1"><a href="" onclick="javascript:TesterAddEval('<%= EvList.FItemList(i).FIdx %>','<%= EvList.FItemList(i).FEvtprize_Code %>','<%= EvList.FItemList(i).FEvt_Code %>','<%= EvList.FItemList(i).FItemID %>');return false;">수정</a></span>
											<span class="button btM2 btWht cBk1"><a href="" onclick="javascript:DelEval('<%= EvList.FItemList(i).FIdx %>','<%= EvList.FItemList(i).FEvtprize_Code %>','<%= EvList.FItemList(i).FEvt_Code %>');return false">삭제</a></span>
										</p>
									</div>
								</li>
						<%
							Next
						End If
						%>
					<% Else %>
						<%'// 테스터 후기 작성 %>
						<% if EvList.FResultCount = 0 then %>
							<p class="noData ct"><strong>작성하실 테스터 후기가 없습니다.</strong></p>
						<%
							else
								for i=0 to EvList.FResultCount-1
						%>
									<li>
										<div class="odrInfo">
											<span>작성기간 : <%=EvList.FItemList(i).FstartDate%> ~ <%=EvList.FItemList(i).FendDate%></span>
										</div>
										<div class="pdtWrap">
											<p class="pic"><img src="<%=getThumbImgFromURL(EvList.FItemList(i).FImageIcon2,"150","150","true","false")%>" alt="<%= EvList.FItemList(i).FItemName %>" /></p>
											<div class="pdtInfo">
												<p class="pBrand"><%= EvList.FItemList(ix).FMakerName %></p>
												<p class="pName"><%= EvList.FItemList(i).FItemName %></p>
												<p class="pPrice"><strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원</p>
											</div>
										</div>
										<div class="goReview">
											<% If EvList.FItemList(ix).FstartDate > now() Then %>
												<p class="ftRt"><span class="button btM2 btRed cWh1"><%=Month(EvList.FItemList(i).FstartDate)%>월 <%=Day(EvList.FItemList(i).FstartDate)%>일부터 작성</span></p>
											<% Else %>
												<p class="ftRt"><span class="button btM2 btRed cWh1"><a href="" onclick="javascript:TesterAddEval('','<%= EvList.FItemList(i).FEvtprize_Code %>','<%= EvList.FItemList(i).FEvt_Code %>','<%= EvList.FItemList(i).FItemID %>');return false;">테스터 후기 쓰기</a></span></p>
											<% End If %>
										</div>
									</li>
						<%
								Next
							End If
						%>
					<% End If %>
				</ul>
				</form>
			</div>
			<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
		</div>
		<!-- //content area -->
		</div>
	</div>
	<form name="dFrm" method="post" action="">
	<input type="hidden" name="idx" value="">
	<input type="hidden" name="evtprize_code" value="">
	<input type="hidden" name="evt_code" value="">
	</form>
</div>
</body>
</html>
<% set EvList= nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->