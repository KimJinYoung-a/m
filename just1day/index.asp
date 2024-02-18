<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/enjoy/Just1DayCls.asp" -->
<!-- #include virtual="/lib/classes/item/ItemOptionCls.asp" -->
<%
'#######################################################
'	History	: 2015.03.19 허진원 생성
'	Description : Just One Day > 상품 이동
'#######################################################

	dim oJustItem, sRetUrl

	'// 오늘의 상품 접수
	set oJustItem = New CJustOneDay
	oJustItem.FRectDate = date
	oJustItem.GetJustOneDayItemInfo

	if oJustItem.FResultCount>0 then
		sRetUrl = "/category/category_itemPrd.asp?itemid=" & oJustItem.FItemList(0).FItemID
	else
		sRetUrl = "/"
	end if

	set oJustItem = nothing
%>
<script type="text/javascript">
window.location.replace('<%=sRetUrl%>');
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->