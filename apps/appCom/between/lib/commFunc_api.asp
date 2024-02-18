<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<!-- #include virtual="/lib/util/aspJSON1.17.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' Discription : BETWEEN api 공통 함수
' History : 2015.05.13 한용민 생성
'###############################################

Const CaccessKey = "KPLXP4DS46H77W8LSYD1"
Const CsecretKey = "HFAXZZ5DMYKJ7PQBR9O6"
Dim CGLBAppName: CGLBAppName="betweenshop"

'####################### API로 변하면서 session에 저장하는 것들 #######################
dim userid, userSn, guestSessionID, i, j
If request("usersn") <> "" Then session("tenUserSn") = requestcheckvar(request("usersn"),10)
If request("report_url") <> "" Then session("report_url") = request("report_url")
If request("return_url") <> "" Then session("return_url") = request("return_url")
If request("fail_url") <> "" Then session("fail_url") = request("fail_url")
If request("token") <> "" Then session("token") = request("token")
If request("signdata") <> "" Then session("signdata") = request("signdata")
If request("betID") <> "" Then session("betID") = requestcheckvar(request("betID"),64)

userid = fnGetUserInfo("TENID")
userSn = fnGetUserInfo("TENSN")
'######################################################################################
'guestSessionID = GetGuestSessionKey

'/통신후 에러코드 설명서		'//2015.05.07 한용민 생성
function getresult_Status_str(ref_Status)
	dim tmpstr
	if ref_Status="" then
		getresult_Status_str="결과코드가 없습니다."
		exit function
	end if
	
	if ref_Status="200" then
		tmpstr=""		'/정상통신
	elseif ref_Status="400" then
		tmpstr="잘못된 형태의 토큰값이거나, 유효기간이 만료된 토큰값 입니다."
	elseif ref_Status="401" then
		tmpstr="잘못된 형태의 헤더 인증키 값입니다."
	elseif ref_Status="405" then
		tmpstr="잘못된 형태의 메소드값 입니다."
	elseif ref_Status="500" then
		tmpstr="서버측 버그가 발생 되었습니다."
	else
		tmpstr="알수없는 오류가 발생 되었습니다."
	end if
	
	getresult_Status_str = tmpstr
end function

'/비트윈에 결과 전송		'//2015.05.01 김진영 생성	'/2015.05.07 한용민 수정(상태값 파라메타 반환)
Function fnBetweenPostReport(sign, byref ref_Status, byref ref_result_str, v10x10_status, v10x10_msg)
	Dim betweenAPIURL, objXML, iRbody, jsResult, strParam, i
	IF application("Svr_Info")="Dev" THEN
		betweenAPIURL = "http://between-gift-gateway-dev.vcnc.co.kr/10x10/report/"
	else
		betweenAPIURL = "http://between-gift-gateway-dev.vcnc.co.kr/10x10/report/"
	end if
	on Error Resume Next

	strParam = "sign="&sign&"&result="&v10x10_status&"&msg="&v10x10_msg
	Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
	    objXML.Open "POST", betweenAPIURL , False
		objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		objXML.SetRequestHeader "Authorization","TenByTen "& CaccessKey &":"& CsecretKey &""
		objXML.Send(strParam)
		iRbody = BinaryToText(objXML.ResponseBody,"euc-kr")
		ref_Status = objXML.Status
		ref_result_str = getresult_Status_str(objXML.Status)
		If objXML.Status = "200" Then
			SET jsResult = JSON.parse(iRbody)
				If jsResult.value <> "" Then
					fnBetweenPostReport = jsResult.value
				ElseIf jsResult.error <> "" Then
					fnBetweenPostReport = jsResult.error
				End If
			SET jsResult = nothing
		End If
	Set objXML = Nothing
	On Error Goto 0
End Function

'// Response.Write + br
Function rw(ByVal str)
	response.write str & "<br>"
End Function 

'// 텐바이텐 로그인 여부
Function getIsTenLogin()
	getIsTenLogin = session("tenUserid")<>""
End Function

'// 송장 링크(app 외부 브라우저 호출)
function GetSongjangURL(currST,dlvURL,songNo)
	if (currST<>"7") then
		GetSongjangURL = ""
		exit function
	end if

	if (dlvURL="" or isnull(dlvURL)) or (songNo="" or isnull(songNo)) then
		GetSongjangURL = "<span onclick=""alert('▷▷▷▷▷ 화물추적 불능안내 ◁◁◁◁◁\n\n고객님께서 주문하신 상품의 배송조회는\n배송업체 사정상 조회가 불가능 합니다.\n이 점 널리 양해해주시기 바라며,\n보다 빠른 배송처리가 이뤄질수 있도록 최선의 노력을 다하겠습니다.');"" style=""cursor:pointer;"">" & songNo & "</span>"
	else
		GetSongjangURL = "<span onclick=""openbrowser'" & db2html(dlvURL) & songNo & "');"">" & songNo & "</span>"
	end if
end function

'회원 정보 접수
Function fnGetUserInfo(vItem)
	Select Case uCase(vItem)
		Case "ID"
			fnGetUserInfo = session("MyUserid")
		Case "NAME"
			fnGetUserInfo = session("MyName")
		Case "SEX"
			fnGetUserInfo = session("MyGender")
		Case "BIRTH"
			fnGetUserInfo = session("MyBirthday")
		Case "TENID"
			fnGetUserInfo = session("tenUserid")		'텐바이텐 회원ID
		Case "TENSN"
			fnGetUserInfo = session("tenUserSn")		'비트윈 매칭 회원일련번호(주문서 작성용)
		Case "TENLV"
			fnGetUserInfo = session("tenUserLv")		'텐바이텐 회원 등급 (주문서 작성용)
		Case "REPORTURL"
			fnGetUserInfo = session("report_url")
		Case "RETURNURL"
			fnGetUserInfo = session("return_url")
		Case "FAILURL"
			fnGetUserInfo = session("fail_url")
		Case "TOKEN"
			fnGetUserInfo = session("token")
		Case "SIGNDATA"
			fnGetUserInfo = session("signdata")
		Case "BETID"
			fnGetUserInfo = session("betID")
	End SElect
End Function

'// 텐바이텐 로그인 여부
Function getIsTenLogin()
	getIsTenLogin = session("tenUserid")<>""
End Function
%>