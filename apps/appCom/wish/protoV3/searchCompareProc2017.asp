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
' PageName : /apps/appCom/wish/protoV3/searchCompareProc2017.asp
' Discription : 검색리스트 내 상품 비교 API
' Request : json > type(get,set), itemid
' Response : response > 결과, itemid, img
' History : 2017.08.23 강준구 : 신규 생성
'###############################################

'//헤더 출력
Response.ContentType = "application/json"

Dim sFDesc
Dim sType, sItemID, sOS, snID, sDeviceId, sAppKey, sVerCd
Dim sCateCd, sCateNm
Dim sData
If Left(Request.ServerVariables("REMOTE_ADDR"),9) = "192.168.1" Then
	sData = Request("json")
Else
	sData = Request.form("json")
End If
Dim userid : userid = GetLoginUserid()
Dim oJson
dim adultChkFlag, isAdultProduct  

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
	sType = requestCheckVar(oResult.type,20)
	sItemID = requestCheckVar(oResult.itemid,50)
	
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

If userid = "" Then
	oJson("response") = "fail1"
	oJson("faildesc") = "로그인이 되지 않았습니다.[E01]"
Else
	If sType = "" Then
		'// 필수 파라메터 없음
		oJson("response") = "fail2"
		oJson("faildesc") = "Type 값이 없습니다.[E02]"
	Else
		'###############################################################################################
		Dim i, arr, chkMode, oCompare, oList, sqlStr

		sItemID = Replace(sItemID, "i", "")
		sItemID = Replace(sItemID, " ", "")
		
		If sItemID <> "" Then
			If Left(sItemID,1) = "," Then
				sItemID = Right(sItemID,Len(sItemID)-1)
			End If
			If Right(sItemID,1) = "," Then
				sItemID = Left(sItemID,Len(sItemID)-1)
			End If
		End If

		If sType = "set" Then	'### 기존꺼 지우고 새로운상품저장.
			If sItemID <> "" Then
				sqlStr = "delete db_my10x10.dbo.tbl_my_itemCompare where userid = '"&userid&"';"
				For i = LBound(Split(sItemID,",")) To UBound(Split(sItemID,","))
					If Split(sItemID,",")(i) <> "" Then
						sqlStr = sqlStr & "insert into db_my10x10.dbo.tbl_my_itemCompare(userid, itemid) values('"&userid&"', '" & Split(sItemID,",")(i) & "');"
					End If
				Next
				dbget.Execute sqlStr
			Else
				sqlStr = "delete db_my10x10.dbo.tbl_my_itemCompare where userid = '"&userid&"';"
				dbget.Execute sqlStr
			End If
		End If
		
		set oList = jsArray()
		
		arr = fnGetCompareItem("list",userid)
		
		If IsArray(arr) Then

			set oList = jsArray()

			For i = 0 To UBound(arr,2)
				adultChkFlag = session("isAdult") <> true and arr(2,i) = 1
				Set oCompare = jsObject()
				
				oCompare("itemid") = cStr(arr(0,i))
				if adultChkFlag then
					oCompare("img") = b64encode("http://fiximage.10x10.co.kr/m/2019/common/img_adult_172.png")
				Else
					oCompare("img") = b64encode("http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(arr(0,i)) & "/" & arr(1,i))
				end if				

				set oList(null) = oCompare
				Set oCompare = Nothing
			Next

		Else
			set oList = jsArray()
		End If
		
		chkMode = "procOK"

		'###############################################################################################

		'// 결과데이터 생성
		Select Case chkMode
			Case "procOK"
				oJson("response") = getErrMsg("1000",sFDesc)
				set oJson("items") = oList

		End Select
	End If
End If

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