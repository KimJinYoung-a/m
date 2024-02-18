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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
dim i, sqlStr
dim userid, bagarray, mode, itemid, vIsPop
dim backurl,fidx
dim arrList, intLoop

userid  	= GetLoginUserID
bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
mode    	= requestCheckvar(request("mode"),16)
itemid  	= requestCheckvar(request("itemid"),9)
fidx		= requestCheckvar(request("fidx"),9)
backurl 	= requestCheckvar(request("backurl"),100)
vIsPop		= requestCheckvar(request("ispop"),3)

if backurl = "" then backurl = "close"
if bagarray = "" then bagarray = itemid
If itemid="" Then itemid=bagarray


If itemid = "" Then
	Response.Write "<script>잘못된 경로입니다.</script>"
	dbget.close()
	Response.End
End If

dim myfavorite
set myfavorite = new CMyFavorite
	'---데이터 처리
	myfavorite.FRectUserID      = userid
	myfavorite.FFolderIdx		= fidx
	
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
function jsIsOpen(){
	if ($("#viewisusing").val() == 'Y')
	{
		$("#viewisusing").val("N");
	}else{
		$("#viewisusing").val("Y");
	}
}

function jsSelectFIdx(i){
	$("form[name=frmW] > input[name=fidx]").val(i);
	frmW.submit();
}


//리뉴얼 추가 

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
		<ul class="tabs commonTabV16a tNum2">
			<li><a href="#" onClick="goWishListPop(); return false;" class="on">위시 담기</a></li>
			<li><a href="#" onClick="goWishFolderListPop(); return false;">폴더 관리</a></li>
		</ul>

		<div class="guide">
			<p>상품을 담을 위시폴더를 선택해 주세요.</p>
		</div>

		<%' 클릭 시 새 위시폴더 만들기 레이어팝업 %>
		<div id="add" class="add"><a href="#lyMakeFloder" class="layer"><i></i>새 위시폴더 만들기</a></div>

		<div id="lyMakeFloder" class="lyWishFloder">
			<form name="frmW" method="post" action="/apps/appcom/wish/web2014/my10x10/myfavorite_process.asp" target="wishproc" _target="blank" style="margin:0px;">
			<input type="hidden" name="backurl" value="popWishFolder_listajax.asp">
			<input type="hidden" name="ispop" value="<%=vIsPop%>">
			<input type="hidden" name="bagarray" value="<%=bagarray%>">
			<input type="hidden" name="mode" value="<%=mode%>">
			<input type="hidden" name="itemid" value="<%=itemid%>">
			<input type="hidden" name="fidx" value="">
			<input type="hidden" name="oldfidx" value="<%=fidx%>">
			</form>
			<form name="frmF" method="post" action="/apps/appcom/wish/web2014/my10x10/myfavorite_folderProc.asp" target="wishproc" style="margin:0px;">
			<input type="hidden" name="hidM" value="I">
			<input type="hidden" name="ispop" value="<%=vIsPop%>">
			<input type="hidden" name="bagarray" value="<%=bagarray%>">
			<input type="hidden" name="mode" value="<%=mode%>">
			<input type="hidden" name="itemid" value="<%=itemid%>">
			<input type="hidden" name="backurl" value="popWishFolder_listajax.asp">
			<input type="hidden" name="backbackurl" value="<%=backurl%>">
			<input type="hidden" name="viewisusing" id="viewisusing" value="Y" />
			<fieldset>
				<legend class="hidden">새 위시폴더 만들기</legend>
				<p class="add"><i></i>새 위시폴더 만들기 <span class="limited">(10자 이내)</span></p>
				<input type="text" title="폴더명 입력" class="frmInputV16" placeholder="폴더 만들기(10자 이내)" name="sFN" maxlength="10" onkeyup="inputLengthCheck(this);"/>
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
		<div class="list">
			<ul>
				<%' for dev msg : 공개폴더일 경우 클래스명 open / 비공개 폴더일 경우 클래스명 closed %>
				<li><div><button type="button" onclick="jsSelectFIdx(0);"><span class="label closed">비공개</span> <span class="name">기본폴더 (<%=defaultcnt%>)</span></button></div></li>
				<%IF isArray(arrList) THEN
					For intLoop = 0 To UBound(arrList,2)
				%>
				<li><div><button type="button" onclick="jsSelectFIdx(<%=arrList(0,intLoop)%>);"><span class="label <%=CHKIIF(arrList(2,intLoop)="Y","open","closed")%>"><%=CHKIIF(arrList(2,intLoop)="Y","공개","비공개")%></span> <span class="name"><%=arrList(1,intLoop)%> (<%=arrList(3,intLoop)%>)</span></button></div></li>
				<%
					Next
				END If
				%>
			</ul>
		</div>
	</div>
	<div id="dimmed" style="display:none; position:fixed; top:0; left:0; z-index:20; width:100%; height:100%; background:rgba(0,0,0,.5);"></div>
</div>
<iframe name="wishproc" id="wishproc" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0">

<!-- #include virtual="/lib/db/dbclose.asp" -->