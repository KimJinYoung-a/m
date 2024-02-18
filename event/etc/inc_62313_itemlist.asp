<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : LET’S GO OUT! / MD기획전 - 상품목록
' History : 2015.05.08 허진원 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include Virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
	dim eCode
	dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
	dim egCode, itemlimitcnt,iTotCnt
	dim eitemsort, itemid, eItemListType

	'// 하단 상품 목록 탭 구성
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "61780"
	Else
		eCode   =  "62313"
	End If

	egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
	IF egCode = "" THEN egCode = 0

	itemlimitcnt = 105	'상품최대갯수
	eitemsort = 1		'정렬방법
	eItemListType = "1"	'격자형

	'// 상품 목록 출력
	if isApp then
		call sbEvtItemView_app
	else
		call sbEvtItemView
	end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->