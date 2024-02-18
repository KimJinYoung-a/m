<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	:  2017-05-23 이종화
'	Description : 상품후기 검증 Proc
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
	Dim itemid , userid , refer , EvList , i
	Dim orderserial , itemoption , evalidx, evalisusing, orderidx
	itemid = requestCheckVar(request("itemid"),9)
	userid = getLoginUserid()
	refer  = request.ServerVariables("HTTP_REFERER")

'	'// 바로 접속시엔 오류 표시
'	If InStr(refer, "10x10.co.kr") < 1 Then
'		Response.Write "01|유입경로에 문제가 발생하였습니다. 관리자에게 문의해주십시오"
'		dbget.close() : Response.End
'	End If

	'// 로그인 여부 체크
	If Not(IsUserLoginOK) Then
		Response.Write "02|상품후기는 로그인하신 뒤 작성할 수 있습니다."
		dbget.close() : Response.End
	End If

	''상품후기
	set EvList = new CEvaluateSearcher
		EvList.FRectUserID = Userid
		EvList.FRectItemID = itemid
		EvList.MyNotEvalutedItem_Top1 

		orderserial = EvList.FEvalItem.FOrderSerial
		itemid		= EvList.FEvalItem.FItemID
		itemoption	= EvList.FEvalItem.FItemOption
		evalidx		= EvList.FEvalItem.Fidx
		evalisusing = EvList.FEvalItem.FEval_isusing
		orderidx	= EvList.FEvalItem.FOrderIDX

		If evalidx <> "" Or Not isnull(evalidx) Then evalidx = "Y" Else evalidx = "N" End If
	set EvList = Nothing


	If orderserial = "" Then
		Response.Write "03|구매하지 않은 상품 이거나 구매후 6개월이 지난 상품입니다. 상품을 구매하신 뒤 다시 상품평을 작성해주세요."
		dbget.close() : Response.End
	End If 

	If evalidx = "Y" Then
		if evalisusing = "N" Then
			Response.Write "06|삭제한 후기는 다시 작성할 수 없습니다."
			dbget.close() : Response.End
		else
			Response.Write "04|이미 후기가 등록된 상품 입니다.수정 페이지로 이동합니다.|"&orderserial&"|"&itemid&"|"&itemoption&"|"&orderidx&""
			dbget.close() : Response.End
		end if
	End If 

	If orderserial <> "" And itemid <> "" And itemoption <> "" And evalidx = "N" Then
		Response.Write "05|후기작성가능|"&orderserial&"|"&itemid&"|"&itemoption&"|"&orderidx&""
		dbget.close() : Response.End
	End If 
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->