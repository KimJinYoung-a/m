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
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/categoryList2017.asp
' Discription : 카테고리 리스트 API
' Request : json > categoryid
' Response : response > 결과, categoryid, name, downcatecount, icon
' History : 2017.08.17 강준구 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim sFDesc
Dim sDisp, sOS, snID, sDeviceId, sAppKey, sVerCd
Dim sCateCd, sCateNm
Dim sData : sData = Request.form("json")
Dim oJson


'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sDisp = NullfillWith(requestCheckVar(oResult.categoryid,20),"0")
	
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
	Dim cDisp, vDispArr, i, vSScrnGubun, vSScrnMasking, chkMode, oDisp, oList
	SET cDisp = New CDBSearch
	cDisp.FRectDisp = sDisp
	vDispArr = cDisp.fnDispNameList
	SET cDisp = Nothing
	
	If isArray(vDispArr) Then
		set oList = jsArray()
		
		For i = 0 To UBound(vDispArr,2)
		
			Set oDisp = jsObject()
			
			oDisp("categoryid") = cStr(vDispArr(0,i))
			oDisp("name") = cStr(vDispArr(1,i))
			oDisp("downcatecount") = cStr(vDispArr(2,i))
			oDisp("icon") = b64encode("http://fiximage.10x10.co.kr/m/2017/common/ico_category_"&Left(vDispArr(0,i),3)&".png")
			
			set oList(null) = oDisp
			Set oDisp = Nothing
		
		Next
		chkMode = "procOK"
	Else
		chkMode = "fail1"
	End If

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
			set oJson("categories") = oList

		Case "fail1"
			'// 데이터 없음(오류)
			oJson("response") = "fail1"
			oJson("faildesc") = "카테고리 리스트를 가져오는데 오류가 발생했습니다.[E01]"

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