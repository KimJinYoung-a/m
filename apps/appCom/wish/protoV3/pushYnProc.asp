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
' PageName : /apps/appCom/wish/pushYNProc.asp
' Discription : Wish APP Pushid 수신여부 설정
' Request : json > type, pushid, OS, versioncode, versionname, verserion :: type-reg,rmv
' Response : response > 결과, response, faildesc
' History : 2015.10.30 서동석 : 신규 생성
'           2015.11.04 김동현 : ios에서는 type의 값을 가지고 hook해서 처리하므로 불변의 값이 와야 하여 type을 adpush로 고정하고 permit변수(1->true, 0->false)를 통해서 처리하도록 변경
'           2015.11.12 김동현 : 리턴메시지의 마지막라인에 crlf제거
'###############################################

function pushYProc(sAppKey,sDeviceId,sUUID,snid,sActTp,userid)
    dim sqlStr, ret 
    sqlStr = " exec db_contents.[dbo].[sp_Ten_App_Push_Y_Proc] '"&sAppKey&"','"&sDeviceId&"','"&sUUID&"','"&snid&"','"&Request.ServerVariables("REMOTE_ADDR")&"',"&sActTp&",'"&userid&"'"
    dbget.Execute sqlStr
    
    if (ERR) then
        pushYProc = false
    ELSE
        pushYProc = true
    end if

end function

function pushNProc(sAppKey,sDeviceId,sUUID,snid,sActTp,userid)
    dim sqlStr, ret 
    sqlStr = " exec db_contents.[dbo].[sp_Ten_App_Push_N_Proc] '"&sAppKey&"','"&sDeviceId&"','"&sUUID&"','"&snid&"','"&Request.ServerVariables("REMOTE_ADDR")&"',"&sActTp&",'"&userid&"'"
    dbget.Execute sqlStr
    
    if (ERR) then
        pushNProc = false
    ELSE
        pushNProc = true
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
    sPermit = requestCheckVar(oResult.permit,1)
    
    if (sAppKey="5") then  ''2015/11/05 추가 우선 ios만
        if (NOT ERR) then
        sActTp  = requestCheckVar(oResult.acttp,1)   '' 0고객액션, 1최초설치시(silent), 2업그레이드사용자(silent)
        if ERR then Err.Clear  ''해당 프로토콜 없음.
        end if
    end if
    
    if (sActTp="") then sActTp="0" ''기본값
    
set oResult = Nothing

'// json객체 선언
Set oJson = jsObject()

dim sqlStr

IF (Err) then
    oJson("response") = getErrMsg("9999",sFDesc)
    oJson("faildesc") = "처리중 오류가 발생했습니다."

elseif (LCASE(sType)<>"adpush") and (LCASE(sType)<>"adpush") then
    '// 잘못된 콜싸인 아님
    oJson("response") = getErrMsg("9999",sFDesc)
    oJson("faildesc") = "잘못된 접근입니다."
elseif (sPermit="") then
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
    
    if (sPermit="1") then 
        if (pushYProc(sAppKey,sDeviceId,sUUID,snid,sActTp,userid)) then
            oJson("response") = getErrMsg("1000",sFDesc)
            retMsg = "텐바이텐에서 보내는 광고성 PUSH(알림)"&VBCRLF
            retMsg = retMsg &"수신여부가 "&LEFT(NOW(),4)&"년 "&MID(NOW(),6,2)&"월 "&MID(NOW(),9,2)&"일 이후로"&VBCRLF
            retMsg = retMsg &" '수신' 으로 변경되었습니다."
            
            
            oJson("resultmsg") = retMsg
        else
            oJson("response") = getErrMsg("9999",sFDesc)
            oJson("faildesc") = "처리중 오류가 발생했습니다."
        end if
    elseif (sPermit="0") then 
        if (pushNProc(sAppKey,sDeviceId,sUUID,snid,sActTp,userid)) then
            oJson("response") = getErrMsg("1000",sFDesc)
            retMsg = "텐바이텐에서 보내는 광고성 PUSH(알림)"&VBCRLF
            retMsg = retMsg &"수신여부가 "&LEFT(NOW(),4)&"년 "&MID(NOW(),6,2)&"월 "&MID(NOW(),9,2)&"일 이후로"&VBCRLF
            retMsg = retMsg &" '수신거부' 로 변경되었습니다."
            
            oJson("resultmsg") = retMsg
        else
            oJson("response") = getErrMsg("9999",sFDesc)
            oJson("faildesc") = "처리중 오류가 발생했습니다."
        end if
    end if
    
end if

if ERR then Call OnErrNoti()
On Error Goto 0

'Json 출력(JSON)
oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->