<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appCom/wish/web2014/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
    Dim storeReviewYN
    storeReviewYN	= requestCheckVar(request("sr"),2)
%>
<script type="text/javascript">
<% If Trim(storeReviewYN) = "Y" Then %>
    setTimeout("fnShowStoreReview()",500);
<% End If %>
setTimeout("parent.location.replace('http://m.10x10.co.kr/apps/appCom/wish/web2014/my10x10/goodsUsing.asp?EvaluatedYN=Y')",700); 
//fnAPPclosePopup();
setTimeout("fnAPPclosePopup()",1000);
</script>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->