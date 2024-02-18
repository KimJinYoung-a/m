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
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/brandList2017.asp
' Discription : 브랜드 리스트 API
' Request : json > type(alphabet,search), keyword(가나다,검색어)
' Response : response > 결과, totalcount, brandid, brandname, isbest
' History : 2017.08.18 강준구 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim sFDesc
Dim sType, sKeyword, sOS, snID, sDeviceId, sAppKey, sVerCd
Dim sCateCd, sCateNm
Dim sData : sData = Request.form("json")
Dim oJson

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = NullfillWith(requestCheckVar(oResult.type,20),"alphabet")
	sKeyword = requestCheckVar(oResult.keyword,300)
	
	If sType = "alphabet" AND sKeyword = "" Then
		sKeyword = "가"
	End If
	
    if Not ERR THEN
    	'Optional Parameter
		sDeviceId = requestCheckVar(oResult.pushid,256)
		sVerCd = requestCheckVar(oResult.versioncode,20)
		sOS = requestCheckVar(oResult.OS,10)

		'DeviceID 정보 업데이트
		sAppKey = getWishAppKey(sOS)
	    if ERR THEN Err.Clear ''회원id 프로토콜 없음
    END IF
set oResult = Nothing


'// json객체 선언
Set oJson = jsObject()

	'###############################################################################################
	Dim cBrand, i, vSScrnGubun, vSScrnMasking, chkMode, oBrand, oList, vTotalCount
	set cBrand = new SearchBrandCls
	If sType = "alphabet" Then
		cBrand.FRectSearchTxt = ""
		cBrand.FRectWord = sKeyword
	Else
		cBrand.FRectSearchTxt = sKeyword
		cBrand.FRectWord = ""
	End IF
	cBrand.FCurrPage = 1
	cBrand.FPageSize = "600"
	cBrand.FScrollCount = 10
	cBrand.getBrandList
	
	If cBrand.FResultCount>0 then
		vTotalCount = cBrand.FResultCount
		
		set oList = jsArray()
		
		For i = 0 To cBrand.FResultCount-1
		
			Set oBrand = jsObject()
			
			oBrand("brandid") = cStr(cBrand.FItemList(i).Fuserid)
			oBrand("brandname") = cStr(cBrand.FItemList(i).Fsocname_kor)
			If cBrand.FItemList(i).Fhitflg = "Y" Then
				oBrand("isbest") = cStr("true")
			Else
				oBrand("isbest") = cStr("false")
			End If
			
			set oList(null) = oBrand
			Set oBrand = Nothing
		
		Next
		
	Else
		vTotalCount = "0"
		set oList = jsArray()
	End If
	
	chkMode = "procOK"
	
	Set cBrand = nothing

	vSScrnMasking = fnMaskingImage()
	vSScrnGubun = Split(vSScrnMasking,"$$")(0)
	vSScrnMasking = Split(vSScrnMasking,"$$")(1)

	'###############################################################################################

	'// 결과데이터 생성
	Select Case chkMode
		Case "procOK"
			'// 이미 연동 되어있는 경우 성공시 (요청 type: login)
			oJson("response") = getErrMsg("1000",sFDesc)
			oJson("screengubun") = CStr(vSScrnGubun)
			If vSScrnGubun = "i" Then
				oJson("screenmasking") = b64encode(vSScrnMasking)
			ElseIf vSScrnGubun = "c" Then
				oJson("screenmasking") = CStr(vSScrnMasking)
			End If
			oJson("totalcount") = CStr(vTotalCount)
			set oJson("brands") = oList

	End Select

IF (Err) then
	Set oJson = jsObject()
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
End if

if ERR then Call OnErrNoti()		'// 오류 이메일로 발송
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->