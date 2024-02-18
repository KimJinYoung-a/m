<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/apps/appCom/wish/inc_constVar.asp"-->
<!-- #include virtual="/apps/appCom/wish/wishCls.asp"-->
<!-- #include virtual="/apps/appCom/wish/searchItemCls.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<%
	dim makerid, strRst
	makerid = requestCheckVar(request("makerid"),32)

	dim oItemList
	Set oItemList = new CWish

	oItemList.FRectUserID=GetLoginUserID
	oItemList.FRectMakerid=makerid
	if makerid<>"" then oItemList.getBrandDetailInfo()

	if oItemList.FResultCount>0 then
		strRst = "brandid=" & server.URLEncode(oItemList.FItemList(0).Fmakerid)
		strRst = strRst & "&englishname=" & server.URLEncode(oItemList.FItemList(0).FbrandnameEng)
		strRst = strRst & "&hangulname=" & server.URLEncode(oItemList.FItemList(0).Fbrandname)
		strRst = strRst & "&numofzzim=" & server.URLEncode(oItemList.FItemList(0).FbrandZzimCnt)
		strRst = strRst & "&zzim=" & server.URLEncode(oItemList.FItemList(0).FisMyZzim)
		strRst = strRst & "&icon=" & server.URLEncode(oItemList.FItemList(0).FiconName)
		strRst = strRst & "&numofproduct=" & server.URLEncode(oItemList.FItemList(0).FitemCnt)
		strRst = strRst & "&numofmatch=" & server.URLEncode(oItemList.FItemList(0).FwishCnt)
		strRst = strRst & "&numofnew=" & server.URLEncode(oItemList.FItemList(0).FnewItemCnt)
		strRst = strRst & "&brandimageurl=" & server.URLEncode(oItemList.FItemList(0).FimageUrl)
	end if

	Set oItemList = Nothing

	'//결과 출력
	response.write strRst
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->