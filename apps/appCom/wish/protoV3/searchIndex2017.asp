<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV3/inc_constVar.asp"-->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls_useDB.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/searchIndex2017.asp
' Discription : 검색 index API
' Request : json > 
' Response : response > 결과, screengubun, screenmasking, tags[keyword,type,url,code]
' History : 2017.08.21 강준구 : 신규 생성
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
	Dim cSScrn, vSScrnIDX, vSScrnBGgubun, vSScrnBGcolor, vSScrnBGimg, vSScrnMasking, vSScrnTxtUse, vSScrnTxt1, vSScrnTxt1URL, vSScrnTxt2, vSScrnTxt2URL
	Dim oList, oTag, chkMode, vLinkGubun, vTitle, vCode

	SET cSScrn = New CDBSearch
	cSScrn.FRectDevice = "m"
	cSScrn.FRectIsMasking = "x"
	cSScrn.FRectUseYN = "y"
	cSScrn.FRectDevice = "m"
	cSScrn.FRectNowDate = date() & " 10:00:00"
	cSScrn.fnSearchScreen
	vSScrnBGgubun	= cSScrn.FOneItem.Fbggubun
	vSScrnBGcolor	= cSScrn.FOneItem.Fbgcolor
	vSScrnBGimg	= cSScrn.FOneItem.Fbgimg
	vSScrnMasking	= cSScrn.FOneItem.Fmaskingimg
	vSScrnTxtUse	= cSScrn.FOneItem.Ftextinfouse
	vSScrnTxt1		= cSScrn.FOneItem.Ftextinfo1
	vSScrnTxt1URL	= cSScrn.FOneItem.Ftextinfo1url
	vSScrnTxt2		= cSScrn.FOneItem.Ftextinfo2
	vSScrnTxt2URL	= cSScrn.FOneItem.Ftextinfo2url

	If cSScrn.FResultCount < 1 Then
		vSScrnBGgubun = "c"
		vSScrnBGcolor = "BAD3E0"
	End If
	SET cSScrn = Nothing
	
	set oList = jsArray()

	If vSScrnTxtUse > 0 Then
		Set oTag = jsObject()
		
		vLinkGubun = fnURLTypeGB(vSScrnTxt1URL)
		
		oTag("keyword") = CStr(vSScrnTxt1)
		If vLinkGubun = "etc" or vLinkGubun = "prd" Then
			oTag("type") = ""
			oTag("url") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & vSScrnTxt1URL &"&pNtr=" & Server.URLEncode("qt_"&vSScrnTxt1))
			oTag("code") = ""
			If vLinkGubun = "prd" Then
				oTag("title") = CStr("상품정보")
			Else
				oTag("title") = CStr(vSScrnTxt1)
			End If
		Else
			'### category, street, search, event
			vCode = CStr(Replace(Split(vSScrnTxt1URL,"=")(1)," ",""))
			oTag("type") = CStr(vLinkGubun)
			
			If vLinkGubun = "category" Then
				vTitle = fnGetDispName(vCode)
				oTag("url") = ""
				oTag("code") = CStr(vCode)
				oTag("title") = CStr(vTitle)
			ElseIf vLinkGubun = "brand" Then
				oTag("url") = ""
				oTag("code") = CStr(vCode)
				oTag("title") = CStr("브랜드")
			ElseIf vLinkGubun = "search" Then
				oTag("url") = ""
				oTag("code") = CStr(vCode)
				oTag("title") = ""
			ElseIf vLinkGubun = "event" Then
				oTag("url") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & vSScrnTxt1URL &"&pNtr=" & Server.URLEncode("qt_"&vSScrnTxt2))
				oTag("code") = ""
				oTag("title") = CStr("기획전")
			End If
		End If
		
		set oList(null) = oTag
		Set oTag = Nothing
		
		If vSScrnTxtUse > 1 Then
			Set oTag = jsObject()

			vLinkGubun = fnURLTypeGB(vSScrnTxt2URL)
			
			oTag("keyword") = CStr(vSScrnTxt2)
			If vLinkGubun = "etc" or vLinkGubun = "prd" Then
				oTag("type") = ""
				oTag("url") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & vSScrnTxt2URL)
				oTag("code") = ""
				If vLinkGubun = "prd" Then
					oTag("title") = CStr("상품정보")
				Else
					oTag("title") = CStr(vSScrnTxt2)
				End If
			Else
				'### category, street, search, event
				vCode = CStr(Replace(Split(vSScrnTxt2URL,"=")(1)," ",""))
				oTag("type") = CStr(vLinkGubun)
				
				If vLinkGubun = "category" Then
					vTitle = fnGetDispName(vCode)
					oTag("url") = ""
					oTag("code") = CStr(vCode)
					oTag("title") = CStr(vTitle)
				ElseIf vLinkGubun = "brand" Then
					oTag("url") = ""
					oTag("code") = CStr(vCode)
					oTag("title") = CStr("브랜드")
				ElseIf vLinkGubun = "search" Then
					oTag("url") = ""
					oTag("code") = CStr(vCode)
					oTag("title") = ""
				ElseIf vLinkGubun = "event" Then
					oTag("url") = b64encode(mDomain & "/apps/appCom/wish/web2014/" & vSScrnTxt2URL)
					oTag("code") = ""
					oTag("title") = CStr("기획전")
				End If
			End If

			set oList(null) = oTag
			Set oTag = Nothing
		End If
	End If
	
	chkMode = "procOK"

	'###############################################################################################

	'// 결과데이터 생성
	Select Case chkMode
		Case "procOK"
			'// 이미 연동 되어있는 경우 성공시 (요청 type: login)
			oJson("response") = getErrMsg("1000",sFDesc)
			oJson("screengubun") = CStr(vSScrnBGgubun)
			If vSScrnBGgubun = "i" Then
				oJson("screenbackground") = b64encode(vSScrnBGimg)
			ElseIf vSScrnBGgubun = "c" Then
				oJson("screenbackground") = CStr(vSScrnBGcolor)
			End If
			set oJson("tags") = oList

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