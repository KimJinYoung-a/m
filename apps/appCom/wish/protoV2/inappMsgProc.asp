<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/classes/appmanage/appFunction.asp"-->
<!-- #include virtual="/lib/classes/membercls/userloginclass.asp" -->
<!-- #include virtual="/lib/classes/membercls/clsMyAnniversary.asp" -->
<!-- #include virtual="/lib/classes/appmanage/JSON_2.0.4.asp"-->
<!-- #include virtual="/apps/appCom/wish/protoV2/inAppComm_function.asp"-->

<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' PageName : /apps/appCom/wish/inappMsgProc.asp
' Discription : Wish APP 인앱 메세지 쿠폰발급
' Request : json > type, OS, versioncode, versionname, verserion, nid
' Response : response > 결과 
' History : 2015.08.12 서동석 생성
'###############################################

'//헤더 출력
Response.ContentType = "text/html"

Dim sType, sKind, i, sOS, sVerCd, sVerNm, sJsonVer, sAppKey, snID, ntoken, sFDesc ''sDeviceId, 
Dim sData : sData = Request("json")
Dim oJson, userid

userid = GetLoginUserID


''로그남김.
function aDDNgCPNLog(iuserid,iAppKey,intoken,isnID,isVerCd)
    dim sqlStr
    dim refIP : refIP=Request.ServerVariables("REMOTE_ADDR")
    
    sqlStr = " exec db_contents.dbo.sp_Ten_Save_Ng_inApp_Log '"&iuserid&"','"&iAppKey&"','"&intoken&"','"&isnID&"','"&isVerCd&"','"&refIP&"'"
    
    dbget.Execute sqlStr
end function

function chkValidNgCpn(intoken,iuserid, byref retMsg)
    dim AssignedRow, icpnSuccMsg, itokenIdx
    chkValidNgCpn = false
    if (iuserid="") then 
        retMsg = "로그인이 필요한 서비스 입니다."
        Exit function
    end if
    
    ''위시 쿠폰.
    if (isNgCpnToken(intoken, itokenIdx)) then
        if (itokenIdx>-1) then
            if (NOT fnChkNudgeNormalCouponEvalValid(iuserid, itokenIdx)) then
                retMsg = "이미 발행 받으셨습니다."
                Exit function
            end if
            
            AssignedRow = fnNgEvalNormalCoupon(iuserid, itokenIdx)
            if (AssignedRow<1) then
                retMsg = "처리중 오류가 발생했습니다."
                Exit function
            end if
            
            icpnSuccMsg = getNgNormalCpnSuccMsg(itokenIdx)
            chkValidNgCpn = true
            retMsg = icpnSuccMsg
        else
            retMsg = "죄송합니다. 처리중 오류가 발생했습니다."
            Exit function
        end if
    else
        retMsg = "죄송합니다. 이미 종료된 이벤트 이거나, 올바른 이벤트가 아닙니다."
        Exit function
    end if
    
end function

dim oResult
set oResult = JSON.parse(sData)
    sType = oResult.type
	'sDeviceId = requestCheckVar(oResult.pushid,256)

	sOS = requestCheckVar(oResult.OS,10)
	sVerCd = requestCheckVar(oResult.versioncode,20)
	sVerNm = requestCheckVar(oResult.versionname,32)
	sJsonVer = requestCheckVar(oResult.version,10)
    snID = requestCheckVar(oResult.nid,40)
    ntoken = requestCheckVar(oResult.ntoken,40)
    
	sAppKey = getWishAppKey(sOS)
	
'// json객체 선언
Set oJson = jsObject()

'' 로그 쌓음.
call aDDNgCPNLog(userid,sAppKey,ntoken,snID,sVerCd)

dim iretMsg, iretChk

IF (Err) then
	oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "처리중 오류가 발생했습니다."
elseif (userid="") then 
    oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "로그인이 필요한 서비스 입니다."
elseif sType="evalcpn" then
    iretChk = chkValidNgCpn(ntoken,userid,iretMsg)
    
    if (NOT iretChk) then 
        oJson("response") = getErrMsg("9999",sFDesc)
        oJson("faildesc") = iretMsg
    else
        oJson("response") = getErrMsg("1000",sFDesc)
	    oJson("resultmsg") = iretMsg
    end if
elseif sType="evalmile" then
    if (ntoken<>"XXX_MMMMMMMMMM") then ''임시.
        oJson("response") = getErrMsg("9999",sFDesc)
        oJson("faildesc") = "죄송합니다. 이미 종료된 이벤트 이거나, 올바른 이벤트가 아닙니다."
    else
        oJson("response") = getErrMsg("1000",sFDesc)
	    oJson("resultmsg") = "발행 되었습니다. 마일 ("&sType&":"&ntoken&")"
    end if
else
    oJson("response") = getErrMsg("9999",sFDesc)
	oJson("faildesc") = "지정되지 않은 오류가 발생하였습니다."
end if


if ERR then Call OnErrNoti()

oJson.flush
Set oJson = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->