<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : biz 회원가입
' History : 2021.06.30 정태훈 생성
'####################################################
%>
<% const midx = 0 %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'==============================================================================
'외부 URL 체크
dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	response.write "-ERR.01"	'--유효하지 못한 접근
	dbget.close(): response.End
end if

'// 사업자 번호 검증 Function
Function checkSocnum(socnum)
    Dim keyArr, key, number, socnoChk, i, j
    Dim numberArr(10)
    keyArr = Array(1, 3, 7, 1, 3, 7, 1, 3, 5)
    number = Replace(socnum, "-", "")
    socnoChk = 0

    If( Len(number) <> 10 ) Then
        checkSocnum = "N"
        Exit Function
    End If

    For i = 1 To Len(number)
        numberArr(i-1) = CInt(Mid(number, i, 1))
    Next
    For j = 0 To UBound(keyArr)
        socnoChk = socnoChk + ( keyArr(j) * numberArr(j) )
    Next
    socnoChk = socnoChk + Fix((keyArr(8) * numberArr(8))/10)

    checkSocnum = ChkIIF(numberArr(9) = ((10 - (socnoChk mod 10)) mod 10), "Y", "N")
End Function
'==============================================================================
'파라미터 세팅

dim socno
'biz 사업자번호, 사업자명 폼 추가
socno = requestCheckVar(request.form("socno"),12)
If checkSocnum(socno) <> "Y" Then
    Response.Write "fail"
    dbget.close(): response.End
End If

    Response.Write "ok"
    dbget.close(): response.End

%>

<!-- #include virtual="/lib/db/dbclose.asp" -->