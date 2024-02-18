<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% 
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<script>
function goChat(){
	location.href='between://chat/';
}
</script>
<%
Dim itemid, itemname, sendcontent, buttonTxt, urlLink, sendImg
itemid		= request("itemid")
itemname	= request("itemname")
sendcontent = request("sendcontent") & " (기프트샵 '"&itemname&"')"
buttonTxt	= request("buttonTxt")
sendImg		= request("sendImg")
urlLink		= "/category/category_itemPrd.asp?itemid="&itemid

Call sendBetweenItem(btwToken, btwUserid, urlLink, sendcontent, buttonTxt, sendImg)
%>
<div class="lyrPopCont">
	<h1>공유완료</h1>
	<div>
		<p>이 상품을 공유했습니다.<br />내용은 채팅창에서 확인할 수 있습니다.</p>
	</div>
</div>
<div class="btnWrap">
	<p class="btn01 btnCancel"><a href="" onclick="jsClosePopup();return false;" class="cnclGry">닫기</a></p>
	<p class="btn01 btnOk"><a href="" onclick="jsClosePopup();goChat();return false;" class="btw">채팅창 가기</a></p>
</div>
<span class="lyrClose" onclick="jsClosePopup();">&times;</span>