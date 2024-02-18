<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : (A-old)다이어리스토리2015 이벤트
' History : 2014-10-14 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2015/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2015/lib/classes/diary_class.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/lib/util/pageformlib.asp" -->

<%
dim odibest, i, selOp , scType, CurrPage, PageSize
	selOp		= requestCheckVar(Request("sop"),1) '정렬
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	CurrPage 	= requestCheckVar(request("cpg"),9)
	
	IF CurrPage = "" then CurrPage = 1
	If selOp = "" then selOp = "0"

	PageSize = 10

	set odibest = new cdiary_list
		odibest.FPageSize = PageSize
		odibest.FCurrPage = CurrPage
		odibest.FselOp	 	= selOp			'이벤트정렬
		odibest.FSCType 	= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
		odibest.FEScope = 2
		odibest.FEvttype = "19,26"
		odibest.fnGetdievent
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/webview/css/diary2015.css">
<script type="text/javascript">

function jsGoUrl(sop){
	document.sFrm.sop.value = sop;
	document.sFrm.cpg.value = 1;
	document.sFrm.submit();
}

function jsGoPage(iP){
	document.sFrm.cpg.value = iP;
	document.sFrm.submit();
}

</script>
</head>
<body class="diarystory2015">
	<!-- wrapper -->
	<div class="wrapper">
		<!-- #content -->
		<div id="content">
			<form name="sFrm" method="get" action="/apps/appCom/wish/webview/diarystory2015/event.asp">
			<input type="hidden" name="cpg" value="<%= odibest.FCurrPage %>"/>
			<input type="hidden" name="sop" value="<%= sElop %>"/>
			<!-- content area -->
			<div class="diaryEvt inner5">
				<div class="sorting">
					<p class="<%=chkIIF(sElop="0","selected","")%>"><span class="button"><a href="#" onclick="jsGoUrl('0'); return false;">신규순</a></span></p>
					<p class="<%=chkIIF(sElop="2","selected","")%>"><span class="button"><a href="#" onclick="jsGoUrl('2'); return false;">인기순</a></span></p>
				</div>

				<% If odibest.FResultCount > 0 Then %>
				<ul class="evtList">
					<% FOR i = 0 to odibest.FResultCount -1 %>
					<li>
						<a href="/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%=odibest.FItemList(i).fevt_code %>">
							<div class="pic"><img src="<%=odibest.FItemList(i).fevt_mo_listbanner %>" alt="<%=odibest.FItemList(i).FEvt_name %>" /></div>
							<dl>
								<dt>
									<%=odibest.FItemList(i).FEvt_name %>
									<% if odibest.FItemList(i).fisgift then %>
										<span class="cGr2">GIFT</span>
									<% elseif odibest.FItemList(i).fiscomment then %>
										<span class="cBl2">참여</span>
									<% elseif odibest.FItemList(i).fisoneplusone then %>
										<span class="cGr2">1+1</span>
									<% end if %>
								</dt>
								<dd><%=odibest.FItemList(i).FEvt_subname %></dd>
							</dl>
						</a>
					</li>
					<% next %>
				</ul>
				<% Else %>
				<div class="noData" style="display:none;">
					<p>진행중인 이벤트가 없습니다.</p>
				</div>
				<% end if %>
			<div>
		</div>
		<!-- #content -->
		<div class="paging">
			<%=fnDisplayPaging_New(odibest.FcurrPage, odibest.FtotalCount, odibest.FPageSize, 3,"jsGoPage")%>
		</div>
		<!-- #footer -->
		<footer id="footer">
			<a href="#" class="btn-top">top</a>
		</footer><!-- #footer -->

		</div>
	<!-- //wrapper -->
</body>
</html>
<% set odibest = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->