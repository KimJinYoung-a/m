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
	
	dim pgReg, lp, jumpScroll, pagesize
	dim userid: userid = getEncLoginUserID ''GetLoginUserID

	pgReg = requestCheckVar(getNumeric(request("pgReg")),4)
	jumpScroll = requestCheckVar(request("jmp"),1)
	if pgReg="" then pgReg=1
	if pagesize="" then pagesize="15"
		
	dim oGiftcard
	set oGiftcard = new myGiftCard
		oGiftcard.FRectUserid = userid
		oGiftcard.FPageSize = pagesize
		oGiftcard.FCurrPage = pgReg
		oGiftcard.myGiftCardRegList
%>
<script type="text/javascript">
function jsGoPgReg(iP){
	self.location.href="?pgReg=" + iP;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<div class="content myGiftcardV15a" id="contentArea">
				<div class="giftcardRegiListV15a inner10">
					<div class="tab02">
						<ul class="tabNavV15a tNum4">
							<li><a href="/my10x10/giftcard/giftcardOrderlist.asp">주문내역</a></li>
							<li><a href="/my10x10/giftcard/giftcardUselist.asp">사용내역</a></li>
							<li class="current"><a href="/my10x10/giftcard/giftcardRegistlist.asp">등록내역</a></li>
							<li><a href="/my10x10/giftcard/giftcardRegist.asp">카드등록</a></li>
						</ul>
					</div>
					<%
						if oGiftcard.FResultCount>0 then
							Response.Write "<ul class='myOdrList'>"
							For lp=0 to (oGiftcard.FResultCount-1)
					%>
							<li>
								<div class="odrInfo">
									<p><%=formatDate(oGiftcard.FItemList(lp).FregDate,"0000.00.00")%></p>
									<p>인증번호(<%=oGiftcard.FItemList(lp).FmasterCardCode%>)</p>
								</div>
								<div class="odrCont">
									<p class="item"><%=oGiftcard.FItemList(lp).FCarditemname%>&nbsp;<%=oGiftcard.FItemList(lp).FcardOptionName%></p>
									<p class="date purchase"><span>구매일자</span><span  class="cBk1"><%=formatDate(oGiftcard.FItemList(lp).FbuyDate,"0000.00.00")%></span></p>
									<p class="date expiration"><span>사용 만료일자</span><span class="cRd1"><%=formatDate(oGiftcard.FItemList(lp).FcardExpire,"0000.00.00")%></span></p>
								</div>
							</li>
					<%
							Next
							Response.Write "</ul>"
						Else
					%>
					<div class="noDataBox">
						<p class="noDataMark"><span>!</span></p>
						<p class="tPad05">등록된 카드가 없습니다.</p>
					</div>
					<% end if %>
					
					<% if oGiftcard.FResultCount>0 then %>
					<%=fnDisplayPaging_New(pgReg,oGiftcard.FTotalCount,pagesize,4,"jsGoPgReg")%>
					<% end if %>
				</div>
			</div>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% set oGiftcard = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->