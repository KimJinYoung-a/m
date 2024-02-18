<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
dim appkey : appkey =request("appkey")
dim deviceid : deviceid =request("deviceid")
dim message : message =request("message")

dim objItem
dim addCount : addCount = Request.Form("params").Count

dim addParamMsg : addParamMsg=""  ''"param1":"value1","param2":"value2"

dim kk, iparam, iparamvalue
For kk = 1 To addCount
    iparam = Request.Form("params")(kk)
    iparamvalue = request.Form("paramvalue")(kk)

    if (iparam<>"" and iparamvalue<>"") then
        addParamMsg = addParamMsg & CHR(34)&iparam&CHR(34)&":"&CHR(34)&iparamvalue&CHR(34)
        addParamMsg = addParamMsg & ","
    end if

Next

if (addParamMsg<>"") then
    addParamMsg = Left(addParamMsg,Len(addParamMsg)-1)
end if

''''addParamMsg = addParamMsg&CHR(34)&"did"&CHR(34)&":"&CHR(34)&deviceid&CHR(34) '' 프로시져 안에 추가

response.write "appkey:"&appkey&"<br>"
response.write "deviceid:"&deviceid&"<br>"
response.write "message:"&message&"<br>"
response.write "addparams:"&addParamMsg&"<br>"

if (appkey="") or (deviceid="") or (message="")then
    response.write "필수 값 체크 오류"
    dbget.close():response.end
end if

dim sqlStr
if (addParamMsg<>"") then
    sqlStr = "exec [db_contents].[dbo].[sp_Ten_sendPushMsgWithParam] "&appkey&",'"&deviceid&"','"&message&"','"&addParamMsg&"',''"

    dbget.Execute sqlStr
else
    sqlStr = "exec [db_contents].[dbo].[sp_Ten_sendPushMsgSimple] "&appkey&",'"&deviceid&"','"&message&"'"

    dbget.Execute sqlStr
end if

response.write "==================================<br>"
response.write "발송요청 되었습니다.<br>"

dim sendedMsg
sqlStr = "select top 1 *"&VBCRLF
sqlStr = sqlStr & " from [DBAPPPUSH].db_AppNoti.dbo.tbl_AppPushMsg" &VBCRLF
sqlStr = sqlStr & " where appkey='"&appkey&"'"&VBCRLF
sqlStr = sqlStr & " and deviceid='"&deviceid&"'"&VBCRLF
sqlStr = sqlStr & " order by psKey desc"&VBCRLF

rsget.open sqlStr, dbget, 1
If not rsget.EOF Then
    sendedMsg = rsget("sendMsg")
end if
rsget.close

response.write "sendedMsg:"&sendedMsg
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->
