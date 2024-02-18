<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/offshop/lib/classes/offshopCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_mileage_logcls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
'##################################################
' PageName : /offshop/point/popbarcode.asp
' Description : 바코드 새로고침
' History : 2015-04-23 이종화 생성
'##################################################
'//온라인 total-mileage
dim myMileage
set myMileage = new TenPoint
myMileage.FRectUserID = getloginuserid
if (getloginuserid<>"") then
	myMileage.getTotalMileage

	Call SetLoginCurrentMileage(myMileage.FTotalmileage)
end If

'//오프라인 total-mileage
dim myOffMileage
set myOffMileage = new TenPoint
myOffMileage.FGubun = "my10x10"
myOffMileage.FRectUserID = getloginuserid
if (getloginuserid<>"") then
	myOffMileage.getOffShopMileagePop
end If

'// 맴버쉽카드 
Dim ClsOSPoint , cardno 
set ClsOSPoint = new COffshopPoint1010
	ClsOSPoint.fnGetMyMemberCard
	cardno = ClsOSPoint.Fcardno
set ClsOSPoint = Nothing

%>
<div id="onpoint"><%=FormatNumber(myMileage.FTotalMileage,0)%>p</div>
<div id="offpoint"><%=FormatNumber(myOffMileage.FOffShopMileage,0)%>p</div>
<%
	Set myMileage = Nothing
	Set myOffMileage = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->