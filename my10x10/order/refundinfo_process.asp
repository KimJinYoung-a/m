<%@  codepage="65001" language="VBScript" %>
<% option explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"

response.Charset = "utf-8"
%>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp" -->
<!-- #include virtual="/lib/util/base64.asp" -->
<%
Dim sqlStr, userid, backurl
dim rebankname, rebankaccount, rebankownername

backurl     = request.ServerVariables("HTTP_REFERER")
userid          = getEncLoginUserID()

if (userid<>"") then
    sqlStr = "exec [db_cs].[dbo].[usp_WWW_AutoCancel_RefundInfo_Set] '" & userid & "','" & request.form("rebankname") & "','" & replace(request.form("encaccount"),"-","") & "','" & request.form("rebankownername") &"'"
    dbget.Execute sqlStr
end if
%>
<script>
    opener.location.href = opener.document.URL;
    opener.parent.viewOrderDetailDiv('4');
    self.opener = self;
    self.close();
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
