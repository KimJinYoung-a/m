<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/inc_const.asp"-->
<!-- #include virtual="/lib/util/BarcodeFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/searchBarcode.asp
' Discription : 텐바이텐 바코드 및 QR코드 검색
' Request : json > type, code
' Response : response > 결과, title, url
' History : 2017.05.11 허진원 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sCode, sLnkTitle, sLnkUrl, sLnkType, sBarcode, sTencode
Dim sData : sData = Request("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = requestCheckVar(oResult.type,8)
	sCode = requestCheckVar(oResult.code,256)
set oResult = Nothing


'// json객체 선언
Set oJson = jsObject()

If Not(sType="barcode" or sType="qrcode")  then
	'// 잘못된 콜싸인 아님
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "잘못된 접근입니다."

elseif sCode="" then
	'// 코드 파라메터 없음
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "파라메터 정보가 잘못됐습니다."

else
	dim sqlStr, addSql, sUserLevel
	dim itemgubun, itemid, itemoption, isTenCode
	dim chkOk: chkOk=true

	Select Case sType
		Case "barcode"
			sCode = trim(replace(sCode,"-",""))
			if sCode<>"" then
				isTenCode = BF_IsMaybeTenBarcode(sCode)
				if isTenCode then
					itemid 		= BF_GetItemId(sCode)
					itemoption 	= BF_GetItemOption(sCode)
					itemgubun	= BF_GetItemGubun(sCode)

					if itemgubun="10" then
						'텐바이텐 상품 코드 확인
						sqlStr = "select top 1 itemgubun, barcode from db_item.dbo.tbl_item_option_stock where itemid='" & itemid & "'"
						''sqlStr = sqlStr & " and itemoption='" & itemoption & "'"
						rsget.CursorLocation = adUseClient
						rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
						if Not(rsget.EOF or rsget.BOF) then
							itemgubun = rsget("itemgubun")
							sLnkType = "prd"
							sLnkUrl = fnGetItemLinkUrl(itemid,itemgubun)
							sBarcode = rsget("barcode")
							sTencode = BF_MakeTenBarcode(itemgubun, itemid, itemoption)
						else
							oJson("response") = getErrMsg("9999",sFDesc)
							oJson("faildesc") = "텐바이텐에서 판매하지 않는 상품입니다."
							chkOk = false
						End if
						rsget.close
					else
						oJson("response") = getErrMsg("9999",sFDesc)
						oJson("faildesc") = "텐바이텐 온라인에서 판매하지 않는 상품입니다."
						chkOk = false
					end if
				else
					'공용바코드 확인
					sqlStr = "select top 1 itemgubun, itemid, itemoption from db_item.dbo.tbl_item_option_stock where barcode='" & sCode & "'"
					rsget.CursorLocation = adUseClient
					rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
					if Not(rsget.EOF or rsget.BOF) then
						itemgubun = rsget("itemgubun")
						itemid = rsget("itemid")
						itemoption = rsget("itemoption")
						sLnkType = "prd"
						sBarcode = sCode
						sTencode = BF_MakeTenBarcode(itemgubun, itemid, itemoption)

						if itemgubun="10" then
							sLnkUrl = fnGetItemLinkUrl(itemid,itemgubun)
						else
							oJson("response") = getErrMsg("9999",sFDesc)
							oJson("faildesc") = "텐바이텐 온라인에서 판매하지 않는 상품입니다."
							chkOk = false
						end if
					else
						oJson("response") = getErrMsg("9999",sFDesc)
						oJson("faildesc") = "상품정보를 찾을 수 없습니다."
						chkOk = false
					End if
					rsget.close
				end if
			else
				'// 잘못된 코드
				oJson("response") = getErrMsg("9999",sFDesc)
				oJson("faildesc") = "잘못된 접근입니다. 확인 후 다시 시도해주세요."
				chkOk = false
			end if
		Case "qrcode"
			if inStr(sCode,"10x10.co.kr")<=0 then
				'// 텐바이텐 Link가 아님
				oJson("response") = getErrMsg("9999",sFDesc)
				oJson("faildesc") = "텐바이텐의 QR코드가 아닙니다."
				chkOk = false
			else
				sLnkType = "QR"
				sLnkUrl = sCode
			end if
	End Select

	if chkOk then
		'// 결과데이터 생성
		
		sLnkTitle = fnGetPopLinkTitle(sLnkType)
		
		oJson("response") = getErrMsg("1000",sFDesc)
		oJson("title") = cStr(sLnkTitle)
		oJson("url") = b64encode(sLnkUrl & chkIIF(instr(sLnkUrl,"?")>0,"&","?") &"rc=barcode")
		oJson("barcode") = cStr(sBarcode)
		oJson("tencode") = cStr(sTencode)
	end if

end if

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

''if ERR then Call OnErrNoti()		'// 오류 이메일로 발송

On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing

''// 팝업 타이틀 선택 함수
function fnGetPopLinkTitle(sType)
	Select Case sType
		Case "prd"
			fnGetPopLinkTitle = "상품정보"
		Case "QR"
			fnGetPopLinkTitle = "QR코드 결과"
		Case else
			fnGetPopLinkTitle = "바코드 결과"
	end Select
end function

'// 상품링크 선택 함수
function fnGetItemLinkUrl(itemid,itemgubun)
	Select Case itemgubun
		Case "10"
			'온라인 상품
			''fnGetItemLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/category/category_itemPrd.asp?itemid=" & itemid
			fnGetItemLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/offshop/view/iteminfo_app.asp?itemid=" & itemid
		Case "90"
			'오프라인 상품
			fnGetItemLinkUrl = "http://m.10x10.co.kr/apps/appcom/wish/web2014/offshop/view/iteminfo_app.asp?itemid=" & itemid
	end Select
end function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->