<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->

<%
'###############################################
' PageName : /apps/appCom/wish/protoV3/getLoginSession.asp
' Discription : 로그인 세션정보 처리
' Request : none
' Response : response > 결과
' History : 2020.2.25 박재석 : 앱용 신규 생성(SCM getLoginSession.asp 복사)
'###############################################

'//헤더 출력
Response.ContentType = "text/json"

dim sToken, oJson, clientIp

'// 접근 IP 확인
dim C_ALLOWIPLIST
C_ALLOWIPLIST = Array(  "10.211.55.2" _
						,"192.168.50.4" _
						,"121.78.103.60" _
						,"121.78.103.40","192.168.50.40" _
						,"110.93.128.99","172.16.0.99" _
                        ,"61.252.133.71","192.168.1.71" _
                        ,"61.252.133.84","192.168.1.84" _
                        ,"61.252.133.80","192.168.1.80" _
                        ,"110.93.128.91" _
						,"10.10.10.2","110.93.128.87","110.93.128.88" _
						,"61.252.133.74","192.168.1.74","61.252.133.4", "192.168.1.99", "110.93.128.94" _
                      )
dim IPCheckOK
dim tmp_ip_i, tmp_ip_buf1

clientIp = request.ServerVariables("REMOTE_ADDR")

IPCheckOK = false
for tmp_ip_i=0 to UBound(C_ALLOWIPLIST)
    tmp_ip_buf1 = C_ALLOWIPLIST(tmp_ip_i)
    if (clientIp=tmp_ip_buf1) then
        IPCheckOK = true
        Exit For
    end if
next

if Not(IPCheckOK) then
  response.Status="403 Forbidden"
  response.Write(response.Status)
  response.End
end if


'// HEADER 데이터 접수
sToken = request.ServerVariables("HTTP_Authorization")
if instr(lcase(sToken),"bearer ")>0 then
	sToken = right(sToken,len(sToken)-instr(sToken," "))
else
	response.Status="401 Unauthorized"
	response.Write(response.Status)
	response.End
end if
' 키값 확인
if sToken<>"1L6O9L>N8CAM@CEFH:D<G:N?O:L6NO6e8O>[7F?^?FGO>=FHF=NTN4K9M4U\7R6P6I>N>IFT" then
	response.Status="401 Unauthorized"
	response.Write(response.Status)
	response.End
end if

'// 로그인 데이터 확인
if session("ssnuserid")="" then
	response.Status="403.2 Forbidden"
	response.Write(response.Status)
	response.End
end if

'// 전송결과 파징
on Error Resume Next

'// json객체 선언
Set oJson = jsObject()

oJson("ssnuserid") = session("ssnuserid")
oJson("ssnusername") = session("ssnusername")
oJson("ssnuseremail") = session("ssnuseremail")
oJson("ssnuserlevel") = session("ssnuserlevel")
oJson("ssnuserdiv") = session("ssnuserdiv")
oJson("ssnrealnamecheck") = session("ssnrealnamecheck")
oJson("ssnlogindt") = session("ssnlogindt")
oJson("ssnlastcheckdt") = session("ssnlastcheckdt")
oJson("isAdult") = session("isAdult")

if ERR then Call OnErrNoti()
On Error Goto 0
'Json 출력(JSON)
oJson.flush

Set oJson = Nothing
%>