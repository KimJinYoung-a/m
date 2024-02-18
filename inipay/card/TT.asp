<%
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
DIM vIdx : vIdx=0
DIM iURi : iURi = "/inipay/card/mx_rnoti_RET.asp"
SESSION("vIdx")=vIdx
SERVER.EXECUTE(iURi)
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->