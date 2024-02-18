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
<!-- #include virtual="/lib/classes/giftcard/giftcard_MyCardInfoCls.asp" -->
<%
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

<%
	if oGiftcard.FResultCount>0 then
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
%>
<% end if %>
<% set oGiftcard = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->