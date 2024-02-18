<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	'해더 타이틀
	strHeadTitleName = "기프트카드"
	
	dim pgLog, lp, jumpScroll, vIsOnOff, pagesize
	dim userid: userid = getEncLoginUserID ''GetLoginUserID

	pgLog = requestCheckVar(getNumeric(request("pgLog")),4)
	vIsOnOff = requestCheckVar(request("isonoff"),1)
	if pgLog="" then pgLog=1
	if pagesize="" then pagesize="15"

	'// 기프트카드 잔액 확인
	dim oGiftcard, currentCash
	set oGiftcard = new myGiftCard
		oGiftcard.FRectUserid = userid
		currentCash = oGiftcard.myGiftCardCurrentCash
	set oGiftcard = Nothing

	dim oGiftLog
	set oGiftLog = new myGiftCard
		oGiftLog.FRectUserid = userid
		oGiftLog.FPageSize = pagesize
		oGiftLog.FCurrPage = pgLog
		oGiftLog.FRectSiteDiv = vIsOnOff
		oGiftLog.myGiftCardLogList
%>
<script type="text/javascript">
function jsGoPgLog(iP){
	self.location.href="?pgLog="+iP+"&isonoff=<%=vIsOnOff%>";
}
function jsUseListSort(s){
	self.location.href="?isonoff="+s;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<div class="content myGiftcardV15a" id="contentArea">
				<div class="giftcardUsageListV15a inner10">
					<!-- tab -->
					<div class="tab02">
						<ul class="tabNavV15a tNum4">
							<li><a href="/my10x10/giftcard/giftcardOrderlist.asp">주문내역</a></li>
							<li class="current"><a href="/my10x10/giftcard/giftcardUselist.asp">사용내역</a></li>
							<li><a href="/my10x10/giftcard/giftcardRegistlist.asp">등록내역</a></li>
							<li><a href="/my10x10/giftcard/giftcardRegist.asp">카드등록</a></li>
						</ul>
					</div>
					<p class="orderSummary box5">카드 총 잔액 : <span class="cRd1"><%=FormatNumber(currentCash,0)%></span>원</p>
					<select name="isonoff" title="기프트카드 사용내역 정렬 옵션" class="w100p" onChange="jsUseListSort(this.value);">
						<option value="" <%=CHKIIF(vIsOnOff="","selected","")%>>전체 사용내역</option>
						<option value="T" <%=CHKIIF(vIsOnOff="T","selected","")%>>온라인 사용내역</option>
						<option value="S" <%=CHKIIF(vIsOnOff="S","selected","")%>>오프라인 사용내역</option>
					</select>
					<%
						if oGiftLog.FResultCount>0 then
							Response.Write "<ul class='usageList'>"
							For lp=0 to (oGiftLog.FResultCount-1)
					%>
							<li>
								<div>
									<span><%=replace(replace(oGiftLog.FItemList(lp).Fregdate,"-","."),"오","- 오")%></span>
									<span>
									<%
										If oGiftLog.FItemList(lp).FsiteDiv = "T" OR oGiftLog.FItemList(lp).FsiteDiv = "F" Then
											Response.Write "온라인 "
										ElseIf oGiftLog.FItemList(lp).FsiteDiv = "S" Then
											Response.Write "오프라인 "
										End IF
									%>(<%=oGiftLog.FItemList(lp).Forderserial%>)</span>
								</div>
								<div>
									<span><%=oGiftLog.FItemList(lp).Fjukyo%></span>
									<span class="<%=chkIIF(oGiftLog.FItemList(lp).FuseCash>0,"cBl1","cRd1")%>"><%=CHKIIF(oGiftLog.FItemList(lp).FuseCash>0,"+","")%><%=formatNumber(oGiftLog.FItemList(lp).FuseCash,0)%>원</span>
								</div>
							</li>
					<%
							Next
							Response.Write "</ul>"
						else
					%>
						<div class="noDataBox">
							<p class="noDataMark"><span>!</span></p>
							<p class="tPad05">사용내역이 없습니다.</p>
						</div>
					<% end if %>

					<% if oGiftLog.FResultCount>0 then %>
					<%=fnDisplayPaging_New(pgLog,oGiftLog.FTotalCount,pagesize,4,"jsGoPgLog")%>
					<% end if %>
				</div>

			</div>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% set oGiftLog = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->