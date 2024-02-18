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
<%
Dim itemid	: itemid = requestCheckVar(request("itemid"),9)
Dim itemname : itemname = requestCheckVar(request("itemname"),200)
Dim sendImg : sendImg = requestCheckVar(request("sendImg"),500)
Dim button_text	: button_text = "자세히 보기"
%>
<script>
function sendMessage(){
	if ($("#sendcontent").val().trim().length < 1) {
		document.getElementById("sendcontent").value = "이거 어때?";
	}
	var sUrl = "/apps/appcom/between/common/act_shareItem.asp";
	$.ajax({
		type:"POST",
		url: sUrl,
		cache: false,
		dataType: "text",
		data: $("#sendFrm").serialize(),
		success: function(message) {
			$("#shareItem").empty();
			$("#shareItem").attr("class", "lyrPop shareFinish")
			$("#shareItem").empty().html(message);
		}
		,error: function(err) {
			alert(err.responseText);
		}
	});
}
$(function(){
	$('.enterMsg').focus(function() {
		$(this).parents('.lyrPop').css('top','20%');
	});
});
</script>
<div class="lyrPop shareSns" id="shareItem"> 
	<form name="sendFrm" id="sendFrm" method="POST">
	<input type="hidden" name="itemid" value="<%= itemid %>">
	<input type="hidden" name="itemname" value="<%= itemname %>">
	<input type="hidden" name="buttonTxt" value="<%= button_text %>">
	<input type="hidden" name="sendImg" value="<%= sendImg %>">
	<div class="lyrPopCont">
		<h1>공유하기</h1>
		<div>
			<p>소중한 분에게 메세지와 함께 공유해보세요.<br />확인을 누르면 채팅창으로 전송됩니다.</p>
			<textarea cols="10" name="sendcontent" id="sendcontent" rows="5" class="enterMsg" placeholder="이거 어때?"></textarea>
		</div>
	</div>
	<div class="btnWrap">
		<p class="btn01 btnCancel"><a href="" onclick="jsClosePopup();return false;" class="cnclGry">취소</a></p>
		<p class="btn01 btnOk"><a href="" class="btw" onclick="sendMessage();return false;">확인</a></p>
	</div>
	</form>
	<span class="lyrClose">&times;</span>
</div>
</div>
<div class="dimmed"></div>