<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  기프트Talk 입력
' History : 2015.02.10 유태욱 리뉴얼 - 모바일
'###########################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/gift/giftCls.asp" -->
<!-- #include virtual="/gift/Underconstruction_gift.asp" -->
<%
	'### 글쓰기 방식이 비교 추천 두가지이므로 조회후 각각 페이지로 이동.
	'dim vItemID1
	Dim  vTalkIdx, vKey1, vKey2, vContents, vItem, vItemID
	Dim  i , vSort , vItemCount , vArrKey  , vUserID, j, splitKey1

	If vItemCount = "" Then vItemCount="0"
	If vItemID = "" Then vItemID=","

	vUserID = GetLoginUserID()
	vTalkIdx = requestCheckVar(request("talkidx"),10)
	If vTalkIdx <> "" Then
		If isNumeric(vTalkIdx) = False Then
			dbget.close()
			Response.End
		End If
	End If

	If vTalkIdx = "" then
%>
<!-- #include virtual="/gift/gifttalk/doChkTalkProc.asp" -->
<%	end if

dim refer
	refer = request.ServerVariables("HTTP_REFERER")
%>
<script type="text/javascript">
	function closeTalkDiv() {
		$.ajax({
			url: "/gift/gifttalk/doShoppingTalkProc.asp?gubun=d",
			cache: false,
			success: function(message) {
				<% if InStr(refer,"/gift/gifttalk/mytalk.asp")>0 then %>
					top.location.href='/gift/gifttalk/mytalk.asp';
				<% else %>
					top.location.href='/gift/gifttalk/';
				<% end if %>
			}
			,error: function(err) {
				alert(err.responseText);
				goBack('/category/category_itemprd.asp?itemid=<%=vItemID%>');
			}
		});
	}

	function closeTalkDivx() {
		<% if InStr(refer,"/gift/gifttalk/mytalk.asp")>0 then %>
			top.location.href='/gift/gifttalk/mytalk.asp';
		<% else %>
			top.location.href='/gift/gifttalk/';
		<% end if %>
	}
	
	function deleteitem(itemidx) {
		$.ajax({
			url: "/gift/gifttalk/doShoppingTalkProc.asp?gubun=d1&itemidx="+itemidx,
			cache: false,
			success: function(message) {
				location.replace("/gift/gifttalk/talk_write.asp");
			}
			,error: function(err) {
				alert(err.responseText);
				goBack('/gift/gifttalk/');
			}
		});
	}
</script>

<%
	If vTalkIdx <> "" Then
		strSql = "SELECT count(itemid) FROM [db_board].[dbo].[tbl_shopping_talk_item] WHERE talk_idx = '" & vTalkIdx & "' AND talk_idx IN(select talk_idx from [db_board].[dbo].[tbl_shopping_talk] where userid = '" & vUserID & "')"
	Else
		strSql = "SELECT count(idx) FROM [db_board].[dbo].[tbl_shopping_talk_myitemlist] WHERE userid = '" & vUserID & "'"
	End If
'	Response.end
	rsget.Open strSql,dbget,1
	vMyItemCount = rsget(0)
	rsget.close()

	If vMyItemCount < 0 Then
		Response.Write "<script>alert('비교할 상품이 없습니다.');goBack('/gift/gifttalk/');</script>"
		dbget.close()
		Response.End
	End If
%>
<% If vMyItemCount > 1 Then	'### 상품2개 비교하기(A,B) %>
	<!-- #include file="./include_write2.asp" -->
<%	ElseIf vMyItemCount = 1 Then		'### 상품1개 추천받기(O,X) %>
	<!-- #include file="./include_write1.asp" -->
<%	ElseIf vMyItemCount < 1 Then		'### 톡 신규등록 %>
	<!-- #include file="./include_write0.asp" -->
<%	End If %>
<script type="text/javascript">
$(function(){
	/* 글자수 카운팅 */
	function frmCount(val) {
		var len = val.value.length;
		if (len >= 101) {
			val.value = val.value.substring(0, 100);
		} else {
			$("#field .limited span").text(len);
		}
	}
	$("#field textarea").keyup(function() {
		frmCount(this);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->