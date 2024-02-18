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

<%
	if oGiftLog.FResultCount>0 then
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
%>
<% end if %>

<% set oGiftLog = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->