<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'#######################################################
'	Description : wish풀더 상품추가
'	History	:  2014.01.08 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/wish/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim i, sqlStr, userid, bagarray, mode, itemid, vIsPop, backurl,fidx, arrList, intLoop
	userid  	= GetLoginUserID
	bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
	mode    	= requestCheckvar(request("mode"),16)
	itemid  	= requestCheckvar(request("itemid"),9)
	fidx		= requestCheckvar(request("fidx"),9)
	backurl 	= requestCheckvar(request("backurl"),100)
	vIsPop		= requestCheckvar(request("ispop"),10)

if backurl = "" then backurl = "close"
'//빽패스가 현재페이지 일경우 처리(현재 아작스페이지 내에서, 폴더수정 아작스 호출 저장후, 다시 현재 페이지 아작스 호출후, 상품 저장시 이전 빽패스 못찾음)
if instr(backurl,"/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp") > 0 then
	backurl=""
end if	
if bagarray = "" then bagarray = itemid

dim myfavorite
set myfavorite = new CMyFavorite
	'---데이터 처리
	myfavorite.FRectUserID      	= userid
	myfavorite.FFolderIdx		= fidx
	
	arrList = myfavorite.fnGetFolderList	
set myfavorite = nothing
%>

<script type="text/javascript">

	function foldernewdiv(sw){
		if(sw=="on") {
			$("#foldernew").show().find("#iptFn").focus();
			$("#btnFldClose").show();
		}else{
			$("#foldernew").hide();
			$("#btnFldClose").hide();
		}
		return false;
	}

	function jseditFolder(){	
		if(!jsChkNull("text",document.frmF.sFN,"폴더명을 입력해주세요")){
			document.frmF.sFN.focus();
			return false;
		}
		var sFN=document.frmF.sFN.value;
		
		var tmpviewisusing="";
		viewisusing = document.getElementsByName("viewisusing")
		for (var i=0; i<viewisusing.length; i++){
			if (viewisusing[i].checked){
				tmpviewisusing = viewisusing[i].value
			}
		}
		if (tmpviewisusing==""){
			alert("공개여부를 선택해 주세요");
			viewisusing[0].focus();
			return;
		}
		
		var rstStr = $.ajax({
			type: "POST",
			url: "/apps/appcom/wish/webview/my10x10/myfavorite_folderProc.asp",
			data: "sFN="+sFN+"&viewisusing="+tmpviewisusing+"&hidM=I&ispop=<%=vIsPop%>&bagarray=<%=bagarray%>mode=<%=mode%>&itemid=<%=itemid%>&backurl=/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%= itemid %>",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr > 0){
			jsOpenModal('/apps/appcom/wish/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=<%=itemid%>&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
			return;
		}else if(rstStr ==-1){
			alert('폴더는 20개까지만 등록가능합니다.');
			return;
		}else{
			//alert(rstStr);
			alert('데이터처리에 문제가 발생했습니다.');
			return;
		}
	}

	function TnWishedit(sUrl){
		var f = $('input:radio[name="selfidx"]:checked').val();
		
		if(f == undefined)
		{
			alert("저장할 위시 폴더를 선택하세요.");
			return;
		}

		var frm = document.frmW;
		frm.backurl.value = sUrl;
		frm.fidx.value = f;
		frm.submit();
	}

	function fnSelFolder(elm) {
		$(elm).find('input[name="selfidx"]').attr('checked',true);
	}

</script>

<form name="frmW" method="post" action="/apps/appcom/wish/webview/my10x10/myfavorite_process.asp" style="margin:0px;">
	<input type="hidden" name="backurl" value="">
	<input type="hidden" name="ispop" value="<%=vIsPop%>">
	<input type="hidden" name="bagarray" value="<%=bagarray%>">
	<input type="hidden" name="mode" value="<%=mode%>">
	<input type="hidden" name="itemid" value="<%=itemid%>">
	<input type="hidden" name="fidx" value="">
	<input type="hidden" name="oldfidx" value="<%=fidx%>">
</form>
				
<!-- modal#modalSelectWishFolder -->
<div class="modal" id="modalSelectWishFolder">
    <div style="position:relative; height:100%;">
    <div class="box">
        <header class="modal-header">
            <h1 class="modal-title">WISH 폴더 선택</h1>
            <a href="#modalSelectWishFolder" class="btn-close">&times;</a>
        </header>
        <div class="modal-body">
        	<div class="iscroll-area">
	            <div class="inner">
	            	<a href="#" onclick="foldernewdiv('on');return false;" class="side-btn btn type-a">폴더추가</a>
	            	<a href="#" id="btnFldClose" onclick="foldernewdiv('off');return false;" class="side-btn btn type-e" style="display:none; position:absolute; top:10px; right:10px;">취소</a>
	            </div>
	        	<form name="frmF" method="post" action="/apps/appcom/wish/webview/my10x10/myfavorite_folderProc.asp" style="margin:0px;" onsubmit="return false;">
	        	<input type="hidden" name="hidM" value="I">
	        	<input type="hidden" name="ispop" value="<%=vIsPop%>">
	        	<input type="hidden" name="bagarray" value="<%=bagarray%>">
	    		<input type="hidden" name="mode" value="<%=mode%>">
	    		<input type="hidden" name="itemid" value="<%=itemid%>">
	        	<input type="hidden" name="backurl" value="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%= itemid %>">
	        	<input type="hidden" name="backbackurl" value="<%=backurl%>">
	            <div class="inner" style="display:none;" id="foldernew">
	                <p class="well t-c">위시 상품을 담을 폴더를 선택하세요.</p>
	                <div class="input-block">
	                    <label for="unlock" style="margin-right:10px;">
	                        <input type="radio" name="viewisusing" value="Y" checked id="unlock" class="form type-c"> 공개
	                    </label>
	                    <label for="lock">
	                        <input type="radio" name="viewisusing" value="N" id="lock" class="form type-c"> 비공개
	                    </label>
	                </div>
	                <div class="input-block no-label">
	                    <label for="folderName" class="input-label">폴더명</label>
	                    <div class="input-controls">
	                        <input type="text" id="iptFn" name="sFN" maxlength="10" onKeyPress="if (event.keyCode == 13){ jseditFolder();return false;}" class="form full-size" placeholder="새 폴더 추가">
	                        <a href="#" onclick="jseditFolder();return false;" class="side-btn btn type-a">저 장</a>
	                    </div>
	                </div>
	                <em class="em">* 폴더명은 10자 이내로 작성하여 주세요.</em>   
	            </div>
				</form>
				
	            <ul class="folder-list">
	                <li onclick="fnSelFolder(this);">
	                    <i class="icon-lock"></i>
	                    <span class="folder-name">기본폴더</span>
	                    
						<% If mode = "add" AND fidx = "" Then %>
							<input type="radio" name="selfidx" value="0" checked class="form type-c">
						<% Else %>
							<input type="radio" name="selfidx" value="0" <%if Cstr(fidx) = Cstr(0) THEN %>checked<%end if%> class="form type-c">
						<% End If %>                    
	                </li>
	                
		          	<%
		          	IF isArray(arrList) THEN
		          	
		          	For intLoop = 0 To UBound(arrList,2)
		          	%>
		                <li onclick="fnSelFolder(this);">
		                    <i class="<%=CHKIIF(arrList(2,intLoop)="N","icon-lock","icon-unlock")%>"></i>
		                    <span class="folder-name"><%=arrList(1,intLoop)%></span>
		                    <input type="radio" name="selfidx" value="<%=arrList(0,intLoop)%>" <%if Cstr(fidx) = Cstr(arrList(0,intLoop)) THEN %>checked<%end if%> class="form type-c">
		                </li>
		        	<%
		        	Next
		            
		            END IF
		            %>
	            </ul>
	            <div class="inner">
	                <em class="em">* 기본폴더를 포함하여 최대 20개의 폴더를 등록할 수 있습니다.</em>
	            </div>
           </div>
        </div>
        <footer class="modal-footer">
            <a href="#" onclick="TnWishedit('<%=backurl%>');return false;" class="btn type-b full-size">확인</a>
        </footer>
    </div>
    </div>
</div><!-- modal#modalSelectWishFolder -->

<!-- #include virtual="/lib/db/dbclose.asp" -->