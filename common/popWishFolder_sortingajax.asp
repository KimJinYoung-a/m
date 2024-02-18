<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim i, sqlStr
dim userid, bagarray, mode, itemid  
dim backurl,fidx
dim arrList, intLoop, vErrLocationValue

userid  	= GetLoginUserID
fidx		= requestCheckvar(request("fidx"),9)
vErrLocationValue		= requestCheckvar(request("ErBValue"),9)


if (InStr(LCase(backurl),"10x10.co.kr") < 0) then
	 Alert_return("유입경로에 문제가 있습니다.")
	dbget.Close :response.end
end if

dim myfavorite
set myfavorite = new CMyFavorite	
	myfavorite.FRectUserID		= userid	
	arrList = myfavorite.fnGetFolderList	
set myfavorite = Nothing

'// 기본폴더 itemcnt
Dim defaultcnt
sqlstr = "select count(*) from [db_my10x10].[dbo].[tbl_myfavorite] where userid = '"& userid &"' and fidx = 0 "
rsget.CursorLocation = adUseClient
rsget.Open sqlStr,dbget,adOpenForwardOnly,adLockReadOnly
If Not rsget.Eof Then
	defaultcnt = rsget(0)
End If
rsget.Close

%>
<script src="/lib/js/shoppingbag_script.js"></script>
<script>
$(function(){
	/* List with handle */
	Sortable.create(sortable, {
		handle: '.drag-handle',
		animation: 150
	});
});

function chgsort(){
	$("#sortable li").each(function(index){
		$("#sort"+$(this).attr("fidx")).val($(this).index());
	});
	document.frmS.submit();
}
</script>
<div class="content" id="contentArea">
	<div class="wishFolderV16">
		<% If vErrLocationValue<>"8" Then %>
		<ul class="tabs commonTabV16a tNum2">
			<li><a href="#" onClick="goWishListPop(); return false;">위시 담기</a></li>
			<li><a href="#" onClick="goWishFolderListPop(); return false;" class="on">폴더 관리</a></li>
		</ul>
		<% End If %>
		<%' 라이브러리 url : http://rubaxa.github.io/Sortable/, https://github.com/RubaXa/Sortable %>
		<div class="edit">
			<div class="tip">
				<p><span class="drag-handle">순서 이동 버튼</span> 를 길게 눌러 위,아래로 이동하세요.</p>
			</div>
			<div class="list listA">
				<div class="fix"><div><span class="label closed">비공개</span> <span class="name">기본폴더 (<%=defaultcnt%>)</span></div></div>
				<form name="frmS" method="post" action="/my10x10/myfavorite_folderProc.asp" target="wishproc" style="margin:0px;">
				<input type="hidden" name="hidM" value="S">
				<input type="hidden" name="itemid" value="<%=itemid%>">
				<input type="hidden" name="backurl" value="popWishFolder_folderlistajax.asp">
				<input type="hidden" name="backbackurl" value="<%=backurl%>">
				<input type="hidden" name="ErBValue" id="ErBValue" value="<%=vErrLocationValue%>" />
				<ul id="sortable" class="sortable">
					<%
						IF isArray(arrList) THEN
							For intLoop = 0 To UBound(arrList,2)
					%>
					<li fidx="<%=arrList(0,intLoop)%>"><input type="hidden" name="chkidx" value="<%=arrList(0,intLoop)%>"/><input type="hidden" name="sort<%=arrList(0,intLoop)%>" id="sort<%=arrList(0,intLoop)%>" value=""/><div><span class="label <%=CHKIIF(arrList(2,intLoop)="Y","open","closed")%>"><%=CHKIIF(arrList(2,intLoop)="Y","공개","비공개")%></span> <span class="name"><%=arrList(1,intLoop)%> (<%=arrList(3,intLoop)%>)</span></div> <button type="button" class="drag-handle">순서 이동</button>
					</li>
					<%
							Next
						End If
					%>
				</ul>
				</form>
				<script src="/lib/js/sortable.js"></script>
			</div>
			<div class="btnSave">
				<button type="button" class="btnV16a btnRed2V16a" onclick="chgsort();return false;">저장</button>
			</div>
		</div>
	</div>
</div>
<iframe name="wishproc" id="wishproc" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0">
<!-- #include virtual="/lib/db/dbclose.asp" -->