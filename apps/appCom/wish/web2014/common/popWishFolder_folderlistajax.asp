<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkLogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim i, sqlStr
dim userid, bagarray, mode, itemid
dim backurl,fidx
dim arrList, intLoop, vErrLocationValue

userid  	= GetLoginUserID
fidx		= requestCheckvar(request("fidx"),9)
vErrLocationValue = requestCheckvar(request("ErBValue"),9)

if (InStr(LCase(backurl),"10x10.co.kr") < 0) then
	 Alert_return("유입경로에 문제가 있습니다.")
	dbget.Close :response.end
end if

dim myfavorite
set myfavorite = new CMyFavorite	
	myfavorite.FRectUserID      	= userid	
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
<script language="javascript" src="/apps/appcom/wish/web2014/lib/js/shoppingbag_script.js"></script>
<script>
$(function(){
	$(".static").unbind();
});

function jsIsOpen(){
	if ($("#viewisusing").val() == 'Y')
	{
		$("#viewisusing").val("N");
	}else{
		$("#viewisusing").val("Y");
	}
}

function jsIsOpenfrm(v){
	if ($("#viewisusing"+v).val() == 'Y')
	{
		$("#viewisusing"+v).val("N");
	}else{
		$("#viewisusing"+v).val("Y");
	}
}

function jsDelFolder(fidx){	
	if(confirm("폴더 삭제시 폴더에 포함된  위시리스트가 모두 삭제됩니다.\n\n폴더를 삭제하시겠습니까? ")){
		document.frmD.fidx.value = fidx;
		document.frmD.submit();
	}
}

function jsModFolder(formname){
	var f = formname;
	if(!jsChkNull("text",f.sFN,"폴더명을 입력해주세요")){
		f.sFN.focus();
		return;
	}
	f.submit();
}

$(function(){
	/* layer popup */
	$.fn.layerOpen = function(options) {
		return this.each(function() {
			var $this = $(this);
			var $layer = $($this.attr("href") || null);
			$this.click(function() {
				$layer.attr("tabindex",0).show().focus();
				$("#dimmed").show();
				$layer.find(".close").one("click",function () {
					$layer.hide();
					$this.focus();
					$("#dimmed").hide();
				});
			});
		});
	}
	$(".layer").layerOpen();

	/* toggle button */
	$(".toggle" ).on("click", function() {
		if ( $(this).is(":checked") ){ 
			$(this).next().find("span").text("공개");
		} else {
			$(this).next().find("span").text("비공개");
		}
	});

	/* text counting */
//	$(".lyWishFloder .frmInputV16").each(function() {
//		var defaultVal = this.value;
//		$(this).focus(function() {
//			if(this.value == defaultVal){
//				this.value = '';
//			}
//		});
//		$(this).blur(function(){
//			if(this.value == ''){
//				this.value = defaultVal;
//			}
//		});
//	});
});

function inputLengthCheck(eventInput){
	var inputText = $(eventInput).val();
	var inputMaxLength = $(eventInput).prop("maxlength");
	var j = 0;
	var count = 0;
	for(var i = 0;i < inputText.length;i++) { 
//		val = escape(inputText.charAt(i)).length; 
//		if(val == 6){
//			j++;
//		}
		j++;
		if(j <= inputMaxLength){
		count++;
		}
	}
	if(j > inputMaxLength){
		$(eventInput).val(inputText.substr(0, count));
	}
}
</script>
<div class="content" id="contentArea">
	<div class="wishFolderV16">
		<% If vErrLocationValue<>"10" Then %>
		<ul class="tabs commonTabV16a tNum2">
			<li><a href="#" onClick="goWishListPop(); return false;">위시 담기</a></li>
			<li><a href="#" onClick="goWishFolderListPop(); return false;" class="on">폴더 관리</a></li>
		</ul>
		<% End If %>
		<div id="add" class="add">
			<a href="#lyMakeFloder" class="layer"><i></i>새 위시폴더 만들기</a>
			<a href="#" onclick="goWishFolderSortingPop();return false;" class="btnV16a btnLGryV16a">순서편집</a>
		</div>

		<%' for dev msg : 클릭 시 새 위시폴더 만들기 레이어팝업 %>
		<div class="list listA">
			<ul>
				<li><div><span class="label closed">비공개</span> <span class="name">기본폴더 (<%=defaultcnt%>)</span></div></li>
				<%
					IF isArray(arrList) THEN
						For intLoop = 0 To UBound(arrList,2)
				%>
				<li>
					<div>
						<span class="label <%=CHKIIF(arrList(2,intLoop)="Y","open","closed")%>"><%=CHKIIF(arrList(2,intLoop)="Y","공개","비공개")%></span> <span class="name"><%=arrList(1,intLoop)%> (<%=arrList(3,intLoop)%>)</span>
						<div class="btnAreaV16a">
							<a href="#lyEditWishFloder<%=intLoop%>" class="btnV16a btnLGryV16a layer">수정</a>
							<button type="button" class="btnV16a btnLGryV16a" onClick="jsDelFolder('<%=arrList(0,intLoop)%>'); return false;">삭제</button>
						</div>
					</div>
				</li>
				<%
						Next
					End If
				%>
			</ul>
		</div>

		<div id="lyMakeFloder" class="lyWishFloder">
			<form name="frmD" method="post" action="/apps/appcom/wish/web2014/my10x10/myfavorite_folderProc.asp" target="wishproc" style="margin:0px;">
			<input type="hidden" name="hidM" value="D">
			<input type="hidden" name="backurl" value="popWishFolder_folderlistajax.asp">
			<input type="hidden" name="fidx" value="">
			<input type="hidden" name="ErBValue" id="ErBValue" value="<%=vErrLocationValue%>" />
			</form>
			<form name="frmF" method="post" action="/apps/appcom/wish/web2014/my10x10/myfavorite_folderProc.asp" target="wishproc" style="margin:0px;">
			<input type="hidden" name="hidM" value="I">
			<input type="hidden" name="bagarray" value="<%=bagarray%>">
			<input type="hidden" name="mode" value="<%=mode%>">
			<input type="hidden" name="itemid" value="<%=itemid%>">
			<input type="hidden" name="backurl" value="popWishFolder_folderlistajax.asp">
			<input type="hidden" name="backbackurl" value="<%=backurl%>">
			<input type="hidden" name="ErBValue" id="ErBValue" value="<%=vErrLocationValue%>" />
			<input type="hidden" name="viewisusing" id="viewisusing" value="Y" />
			<fieldset>
				<legend class="hidden">새 위시폴더 만들기</legend>
				<p class="add"><i></i>새 위시폴더 만들기 <span class="limited">(10자 이내)</span></p>
				<input type="text" title="폴더명 입력" class="frmInputV16" placeholder="폴더 만들기(10자 이내)" name="sFN" maxlength="10" onblur="inputLengthCheck(this);"/>
				<div class="btnAreaV16a">
					<div class="switch">
						<input type="checkbox" id="openclosed" checked="checked" class="toggle" onClick="jsIsOpen();"/>
						<label for="openclosed"><span>공개</span></label>
					</div>
					<input type="submit" class="btnV16a btnRed2V16a" value="확인" onClick="jsSubmitFolder();return false;"/>
				</div>
				<button type="button" class="btnClose close">닫기</button>
			</fieldset>
			</form>
		</div>
		<%' for dev msg : 위시폴더 수정 %>
		<%
			IF isArray(arrList) THEN
				For intLoop = 0 To UBound(arrList,2)
		%>
		<div id="lyEditWishFloder<%=intLoop%>" class="lyWishFloder">
			<form name="frmU<%=intLoop%>" method="post" action="/apps/appcom/wish/web2014/my10x10/myfavorite_folderProc.asp" target="wishproc" style="margin:0px;">
			<input type="hidden" name="hidM" value="U">
			<input type="hidden" name="backurl" value="popWishFolder_folderlistajax.asp">
			<input type="hidden" name="fidx" value="<%=arrList(0,intLoop)%>">
			<input type="hidden" name="viewisusing" id="viewisusing<%=intLoop%>" value="<%=arrList(2,intLoop)%>" />
			<input type="hidden" name="ErBValue" id="ErBValue" value="<%=vErrLocationValue%>" />
			<fieldset>
				<legend class="hidden">위시폴더 수정하기</legend>
				<p><i></i>위시폴더 수정<span class="limited">(10자 이내)</span></p>
				<input type="text" title="폴더명 입력" class="frmInputV16" name="sFN" value="<%=arrList(1,intLoop)%>" maxlength="10" onkeyup="inputLengthCheck(this);"/>
				<div class="btnAreaV16a">
					<div class="switch">
						<input type="checkbox" id="openclosed2_<%=intLoop%>" <%=CHKIIF(arrList(2,intLoop)="Y"," checked='checked'","")%> class="toggle" onClick="jsIsOpenfrm(<%=intLoop%>);"/>
						<label for="openclosed2_<%=intLoop%>"><span><%=CHKIIF(arrList(2,intLoop)="Y","공개","비공개")%></span></label>
					</div>
					<input type="submit" class="btnV16a btnRed2V16a" value="확인" onClick="jsModFolder(document.frmU<%=intLoop%>); return false;"/>
				</div>

				<button type="button" class="btnClose close">닫기</button>
			</fieldset>
			</form>
		</div>
		<%
				Next
			End If
		%>
	</div>
	<div id="dimmed" style="display:none; position:fixed; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0,.5);"></div>
</div>
<iframe name="wishproc" id="wishproc" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0">
<!-- #include virtual="/lib/db/dbclose.asp" -->