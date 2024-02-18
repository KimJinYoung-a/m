<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim userid, page,  pagesize, SortMethod,ix,EvaluatedYN,i, lp
userid      = GetLoginUserID
page        = requestCheckVar(request("page"),9)
pagesize    = requestCheckVar(request("pagesize"),9)
SortMethod  = requestCheckVar(request("SortMethod"),10)
EvaluatedYN	= requestCheckVar(request("EvaluatedYN"),2)


if page="" then page=1
if pagesize="" then pagesize="50"
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
	EvList.NotEvalutedItemList ''후기 가져오기 
else 
	EvList.NotEvalutedItemList ''후기 안쓰인 상품 가져오기 
end if

strPageTitle = "생활감성채널, 텐바이텐 > 상품후기 쓰기"
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	function goPage(page){
			var frm = document.evaluateFrm;
			frm.page.value=page;
			frm.submit();
		}
</script>
</head>
<body class="mypage">
    <!-- wrapper -->
    <div class="wrapper myinfo">
        <!-- #content -->
        <div id="content">
            <div class="inner">
                <div class="diff"></div>
                <div class="main-title">
                    <h1 class="title"><span class="label">상품 후기</span></h1>
                </div>
            </div>
            <div class="well type-b">
                <ul class="txt-list">
                    <li>상품후기를 작성하시면 100point 가 적립되며 배송정보 [출고완료] 이후부터 작성하실 수 있습니다. </li>
                </ul>
            </div>
			<form name="evaluateFrm" method="get" action="" style="margin:0px;">
			<input type="hidden" name="mode" value="" />
			<input type="hidden" name="page" value="" />
			<input type="hidden" name="EvaluatedYN" value="<%= EvaluatedYN %>" />
			<input type="hidden" name="orderserial" value="" />
			<input type="hidden" name="itemid" value="" />
			<input type="hidden" name="optionCD" value="" />
            <div class="inner">
				<% if EvList.FResultCount = 0 then %>
				<p class="t-c" style="padding:30px 0">남기실 상품 후기가 없습니다.</p>
				<% else %>
				<% for  i = 0 to EvList.FResultCount-1 %>
				<div class="bordered-box" onclick="javascript:AddEval('<%= EvList.FItemList(i).FOrderSerial %>','<%= EvList.FItemList(i).FItemID %>','<%= EvList.FItemList(i).FItemOption %>');">
					<div class="box-meta">
						<span class="date"><%= formatdate(CStr(EvList.FItemList(i).FOrderDate),"0000.00.00") %></span>
						<span class="box-title">주문번호(<%= EvList.FItemList(i).FOrderSerial %>)</span>
					</div>                    
					<div class="product-info gutter">
						<div class="product-img">
							<img src="<%= EvList.FItemList(i).FImageList100 %>" alt="<%= EvList.FItemList(i).FItemname %>">
						</div>
						<div class="product-spec">
							<p class="product-brand">[<%=EvList.FItemList(i).FMakerName%>] </p>
							<p class="product-name"><%= EvList.FItemList(i).FItemname %></p>
							<% If EvList.FItemList(i).FOptionName <> "" Then %>
							<p class="product-option">옵션 : <%= EvList.FItemList(i).FOptionName %></p>
							<% End If %>
						</div>
						<div class="price">
							<strong><%= FormatNumber(EvList.FItemList(i).FItemCost,0) %></strong>원 
						</div>
					</div>
				</div>
				<% next %>
				<%end if%>
            </div>
			</form>			
        </div><!-- #content -->

        <!-- #footer -->
        <footer id="footer">
            
        </footer><!-- #footer -->
        
    </div><!-- wrapper -->
    
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<% Set EvList = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->