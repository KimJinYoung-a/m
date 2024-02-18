<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/base64New.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/pushallowChkProc.asp
' Discription : Wish APP Push 수신여부 체크 - 업데이트후 최초 구동시 호출
' Request : json > type, pushid, OS, versioncode, versionname, verserion :: type-reg,rmv
' Response : response > 결과, response, faildesc
' History : 2016.11.24 서동석 : 신규 생성
'###############################################

function IsRequirePushAllowCheck(sAppKey,sDeviceId,sUUID,snid,userid)
    dim sqlStr, ret 
    IsRequirePushAllowCheck = FALSE
    
    sqlStr = " exec db_contents.[dbo].[sp_Ten_App_Push_AllorCheckRequireInApp] '"&sAppKey&"','"&sDeviceId&"','"&sUUID&"','"&snid&"','"&Request.ServerVariables("REMOTE_ADDR")&"','"&userid&"'"
    rsget.CursorLocation = adUseClient
    rsget.Open sqlStr,dbget,adOpenForwardOnly, adLockReadOnly
    if Not rsget.Eof then
        ret = rsget("retVal")
    end if
    rsget.Close
        
    if (ret="Y") then
        IsRequirePushAllowCheck = TRUE
    ELSE
        IsRequirePushAllowCheck = FALSE
    end if

end function


'//헤더 출력
Response.ContentType = "text/html"

Dim sFDesc
Dim sType, sDeviceId
Dim sOS, sVerCd, sVerNm, sJsonVer, sAppKey, sMinUpVer, sCurrVer, sCurrVerNm, sUUID, snID, sPermit, sActTp
Dim sData : sData = Request("json")
Dim oJson, userid, retMsg

userid = GetLoginUserID

'// 전송결과 파징
on Error Resume Next

dim oResult
set oResult = JSON.parse(sData)
    sType = oResult.type
    sDeviceId = requestCheckVar(oResult.pushid,256)

    sOS = requestCheckVar(oResult.OS,10)
    sVerCd = requestCheckVar(oResult.versioncode,20)
    sVerNm = requestCheckVar(oResult.versionname,32)
    sJsonVer = requestCheckVar(oResult.version,10)

    sAppKey = getWishAppKey(sOS)
    
    sUUID = requestCheckVar(oResult.uuid,40)
    snID = requestCheckVar(oResult.nid,40)
    
    
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

dim sqlStr

IF (Err) then
    oJson("response") = getErrMsg("9999",sFDesc)
    oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif (LCASE(sType)<>"pallowchk") then
    '// 잘못된 콜싸인 아님
    oJson("response") = getErrMsg("9999",sFDesc)
    oJson("faildesc") = "잘못된 접근입니다."
'elseif (sDeviceId="") then
'    '// 잘못된 sDeviceId
'    oJson("response") = getErrMsg("9999",sFDesc)
'    oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif sAppKey="" then
    '// 잘못된 접근
    oJson("response") = getErrMsg("9999",sFDesc)
    oJson("faildesc") = "파라메터 정보가 없습니다."

else
    
    '' 수신여부 팝업창 필요시 Y , 불필요시 N, 차후 다른 플래그 생길 개연성.. 
    if (IsRequirePushAllowCheck(sAppKey,sDeviceId,sUUID,snid,userid)) then
        oJson("response") = getErrMsg("1000",sFDesc)
        oJson("resultmsg") = "Y"
    else
        oJson("response") = getErrMsg("1000",sFDesc)
        oJson("resultmsg") = "N"
    end if
    
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->