<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 이벤트 당첨 안내
' History : 2014.09.29 한용민 생성
'####################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/cscenter/eventprizeCls.asp" -->
<%
Dim clsEvtPrize, arrList, intLoop, vGubun, vWinnerOX, strGoUrl, vPageGubun
Dim iTotCnt
Dim iPageSize, iCurrpage ,iDelCnt
Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt
Dim arreventkind, arrevtprizetype
	arreventkind = fnSetCommonCodeArr("eventkind", False)
	arrevtprizetype = fnSetCommonCodeArr("evtprizetype", False)

	iCurrpage 	= NullFillWith(requestCheckVar(Request("iC"),10),1)	'현재 페이지 번호
	vGubun		= NullFillWith(RequestCheckVar(request("gubun"),1),"e")
	vWinnerOX	= NullFillWith(RequestCheckVar(request("winnerox"),1),"")

	vPageGubun	= NullFillWith(RequestCheckVar(request("pagegubun"),1),"p")

	iPageSize = 10		'한 페이지의 보여지는 열의 수
	iPerCnt = 10		'보여지는 페이지 간격

	If vPageGubun = "p" Then
		set clsEvtPrize  = new CEventPrize
			clsEvtPrize.FUserid = getEncLoginUserID
			clsEvtPrize.FCPage 	= iCurrpage		'현재페이지
			clsEvtPrize.FPSize 	= iPageSize		'페이지 사이즈
			arrList = clsEvtPrize.fnGetEventPrizeList
			iTotCnt = clsEvtPrize.FTotCnt

		iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수

	ElseIf vPageGubun = "j" Then
		set clsEvtPrize  = new CEventPrize
			clsEvtPrize.FGubun		= vGubun
			clsEvtPrize.FCPage 		= iCurrpage	'현재페이지
			clsEvtPrize.FPSize 		= iPageSize		'페이지 사이즈
			clsEvtPrize.FUserid 	= getEncLoginUserID
			clsEvtPrize.FWinnerOX	= vWinnerOX
			arrList = clsEvtPrize.fnGetEventJoinList
			iTotCnt = clsEvtPrize.FTotCnt

		iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수

	End If

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css?v=1.2">
<title>10x10: 이벤트당첨 안내</title>
<script type="text/javascript">

function jsGoPage(iP){
	document.frmPrize.iC.value = iP;
	document.frmPrize.submit();
}
//배송지 입력
function PopOpenEventSongjangEdit(id){
	if(id==""){return;}
	location.href = '/apps/appCom/wish/web2014/my10x10/myeventmasteredit.asp?id=' + id + '';
}
//티켓승인 //어드민에서 사용안하는듯.. 차후 사용시를 위해서 링크 경로는 그대로둠
function PopOpenEventTicket(id){
	//location.href = '/apps/appCom/wish/web2014/my10x10/myevent_ticket.asp?ePC=' + id + '';
	return;
}
//배송지 입력
function PopOpenEventSongjangView(id){
	if(id==""){return}
	location.href = '/apps/appCom/wish/web2014/my10x10/myeventmasteredit.asp?id=' + id + '';
}
//티켓승인 //어드민에서 사용안하는듯.. 차후 사용시를 위해서 링크 경로는 그대로둠
function PopOpenEventTicketView(id){
	//location.href = '/apps/appCom/wish/web2014/my10x10/myevent_ticketView.asp?ePC=' + id + '';
	return;
}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
			<!--마이텐바이텐-->
			<div id="my2">
				<div id="my2Tit">
					<!--h2 class="ftBig c000"><strong>이벤트당첨 안내</strong></h2-->
					<p class="tMar10 pDesc">최근 6개월간 참여하신 이벤트는 리스트로 확인 가능합니다.</p>
				</div>
				<!--탭-->
				<ul class="tabItem tMar20">
					<li class="w50 <%=chkiif(vPageGubun="p","on","")%>"><a href="/apps/appCom/wish/web2014/my10x10/myeventmaster.asp?pagegubun=p">당첨 이벤트<span class="elmBg"></span></a></li>
					<li class="w50 <%=chkiif(vPageGubun="j","on","")%>"><a href="/apps/appCom/wish/web2014/my10x10/myeventmaster.asp?pagegubun=j">참여 이벤트<span class="elmBg"></span></a></li>
				</ul>
			</div>
			<div id="myevent">
				<!--당첨된 이벤트 리스트-->
				<% If vPageGubun = "p" Then %>
				<form name="frmPrize" method="post" action="/apps/appCom/wish/web2014/my10x10/myeventmaster.asp">
				<input type="hidden" name="iC" value="<%=iCurrpage%>">
				<div id="mywonList">
				<% IF isArray(arrList) THEN%>
					<%For intLoop =0 To UBound(arrList,2)
						clsEvtPrize.FPrizeType	= arrList(2,intLoop)
						clsEvtPrize.FStatus     = arrList(4,intLoop)
						clsEvtPrize.FSongjangid = arrList(5,intLoop)
						clsEvtPrize.FSongjangno = arrList(6,intLoop)
						clsEvtPrize.FPCode		= arrList(0,intLoop)
						clsEvtPrize.FreqDeliverDate = arrList(10,intLoop)
						clsEvtPrize.fnSetStatus
					%>
					<div class="eventWrap">
						<table>
							<colgroup>
								<col style="width:60px;" />
								<col />
							</colgroup>
							<tr>
								<th>구분</th>
								<td><%=fnGetCommCodeArrDesc(arreventkind,arrList(1,intLoop))%></td>
							</tr>
							<tr>
								<th>이벤트명</th>
								<td><span class="wonTit"><%=arrList(7,intLoop)%></span></td>
							</tr>
							<tr>
								<th>당첨일</th>
								<td><%=Replace(formatdate(arrList(3,intLoop),"0000-00-00"),"1900-01-01","&nbsp;")%></td>
							</tr>
							<tr>
								<th>확인하기</th>
								<td><%=clsEvtPrize.FConfirm%></td>
							</tr>
							<tr>
								<th>상태</th>
								<td><%=clsEvtPrize.FStatusDesc%></td>
							</tr>
							<tr>
								<th>비고</th>
								<td><%IF arrList(6,intLoop) <> "" THEN%>송장번호<%=arrList(6,intLoop)%><%END IF%>&nbsp;</td>
							</tr>
						</table>
					</div>
					<div id="evLine"></div>
					<%Next%>
				<% Else %>
					<p class="noData">당첨된 이벤트 내역이 없습니다.</p>
				<% End If %>
				</div>
				</form>

				<% ElseIf vPageGubun = "j" Then %>
				<form name="frmPrize" method="post" action="/apps/appCom/wish/web2014/my10x10/myeventmaster.asp">
				<input type="hidden" name="iC" value="<%=iCurrpage%>">
				<input type="hidden" name="pagegubun" value="j">
				<!--참여한 이벤트 리스트-->
				<div id="myeventList">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr height="20">
							<td align="center">
								<input type="radio" name="gubun" value="e" onClick="frmPrize.iC.value='';frmPrize.submit();" <% If vGubun = "e" Then %>checked<% End If %>> 쇼핑찬스&nbsp;&nbsp;&nbsp;&nbsp;
								<!--<input type="radio" name="gubun" value="f" onClick="frmPrize.iC.value='';frmPrize.submit();" <% If vGubun = "f" Then %>checked<% End If %>> 디자인핑거스&nbsp;&nbsp;&nbsp;&nbsp;-->
								<input type="radio" name="gubun" value="c" onClick="frmPrize.iC.value='';frmPrize.submit();" <% If vGubun = "c" Then %>checked<% End If %>> Culture Station
							</td>
						</tr>
					</table>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr bgcolor="#f5f5f5">
							<th>이벤트명</th>
							<th width="45">상태</th>
							<th width="75">당첨자발표</th>
							<th width="65">당첨발표</th>
						</tr>
						<%
						IF isArray(arrList) THEN
							Dim vImg, vType
							For intLoop =0 To UBound(arrList,2)
						%>
						<tr>
							<td><%=arrList(2,intLoop)%></td>
							<td><%=arrList(3,intLoop)%></td>
							<td><%=Replace(formatdate(arrList(4,intLoop),"0000-00-00"),"1900-01-01","&nbsp;")%></td>
							<td><span class="<%=chkiif(arrList(5,intLoop) = "Y","issue","noissue")%>"><% If arrList(5,intLoop) = "Y" Then %>발표완료<% Else %>발표이전<% End If %></span></td>
						</tr>
							<%Next%>
						<%ELSE%>
						<tr>
							<td colspan="4" class="noData">참여하신 이벤트 내역이 없습니다.</td>
						</tr>
						<%END IF%>
					</table>
				</div>
				<!--페이지표시-->
				<div class="paging tMar25">
					<%=fnDisplayPaging_New(iCurrpage,iTotCnt,iPageSize,4,"jsGoPage")%>
				</div>
				</form>
				<% End IF %>
			</div>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
</body>
</html>

<%
	set clsEvtPrize = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->