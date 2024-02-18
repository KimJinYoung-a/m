<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.contentType = "text/html; charset=UTF-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #INCLUDE virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
    Dim resBody
    Dim state, code, user, id_token
    Dim lngBytesCount
    
    'body 받기
'    If Request.TotalBytes > 0 Then
'        lngBytesCount = Request.TotalBytes
'        resBody = Request.BinaryRead(lngBytesCount)
'        resBody = BytesToStr(resBody)
'    End If

'    Function BytesToStr(bytes)
'        Dim Stream
'        Set Stream = Server.CreateObject("Adodb.Stream")
'            Stream.Type = 1 'adTypeBinary
'            Stream.Open
'            Stream.Write bytes
'            Stream.Position = 0
'            Stream.Type = 2 'adTypeText
'            Stream.Charset = "iso-8859-1"
'            BytesToStr = Stream.ReadText
'            Stream.Close
'        Set Stream = Nothing
'    End Function

	'// 전송받은 데이터 접수
'	state = request("state")    '안쓰는듯
    code = request("code")
    id_token = request("id_token")
	user = request("user")
    if user="" then user="{""name"":{""firstName"":"""",""lastName"":""""},""email"":""""}"

    '받은 값이 있으면 function 호출
    if code<>"" then
%>
<script type='text/javascript' src='/apps/appCom/wish/web2014/lib/js/customapp.js'></script>
<script>
    callNativeFunction('appleSignInResult', {
        "code": "<%=code%>",
        "id_token": "<%=id_token%>",
        "user": <%=user%>
    });
</script>
<%
    end if
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->