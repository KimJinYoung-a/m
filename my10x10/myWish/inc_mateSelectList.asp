<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
response.charset = "utf-8"
%>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/wish/WishCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->

<%
Dim PageSize	: PageSize = getNumeric(requestCheckVar(request("psz"),9))
Dim CurrPage 	: CurrPage = getNumeric(requestCheckVar(request("cpg"),9))
Dim vUserid		: vUserid = getEncLoginUserID()
Dim vTargetUserid		: vTargetUserid = requestCheckVar(request("utid"),32)


If CurrPage="" Then CurrPage=0
If PageSize="" Then PageSize = 10



Dim oDoc,iLp, TotalCnt, i
Set oDoc = new CAutoWish
	oDoc.FPageSize 			= PageSize
	oDoc.FCurrPage 			= CurrPage
	oDoc.FuserID				= vUserid
	oDoc.FTargetUserID = vTargetUserid
	oDoc.GetWishMateSelectList
	
TotalCnt = oDoc.FResultCount

%>




<% IF oDoc.FResultCount >0 then %>
	<%
	For i=0 To TotalCnt-1

	IF (i <= TotalCnt-1) Then

	%>
		<li><a href="/category/category_itemprd.asp?itemid=<%=oDoc.FWishPrdList(i).FItemID%>" id="Hlink"><img src="<% = oDoc.FWishPrdList(i).FImageList %>" alt="<% = oDoc.FWishPrdList(i).FItemName %>" /></a></li>
	<% End IF %>
	<% Next %>
<% end if %>
<%
SET oDoc = Nothing
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->