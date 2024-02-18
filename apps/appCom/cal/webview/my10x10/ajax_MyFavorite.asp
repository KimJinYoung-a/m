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
'	History	:  2014.02.26 한용민 생성
'#######################################################
%>
<!-- #include virtual="/apps/appcom/cal/webview/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/cal/webview/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
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
	vIsPop		= requestCheckvar(request("ispop"),16)

if backurl = "" then backurl = "close"
'//빽패스가 현재페이지 일경우 처리(현재 아작스페이지 내에서, 폴더수정 아작스 호출 저장후, 다시 현재 페이지 아작스 호출후, 상품 저장시 이전 빽패스 못찾음)
if instr(backurl,"/apps/appcom/cal/webview/my10x10/ajax_MyFavorite.asp") > 0 then
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

<!-- #include virtual="/apps/appCom/cal/webview/lib/head.asp" -->

<script type="text/javascript">

	$(document).ready(function(){
		$('.wishFoldList .added ul').hide();
		$('.wishFoldList .added > span').click(function(){
			$(this).hide();
			$('.wishFoldList .added ul').show("slide", { direction: "up" }, 300);
		});
	});

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
			url: "/apps/appcom/cal/webview/my10x10/myfavorite_folderProc.asp",
			data: "sFN="+sFN+"&viewisusing="+tmpviewisusing+"&hidM=I&ispop=<%=vIsPop%>&bagarray=<%=bagarray%>mode=<%=mode%>&itemid=<%=itemid%>&backurl=/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%= itemid %>",
			dataType: "text",
			async: false
		}).responseText;

		if (rstStr > 0){
			jsOpenModal('/apps/appcom/cal/webview/my10x10/ajax_MyFavorite.asp?ispop=ajax&mode=add&itemid=<%=itemid%>&backurl=<%=Replace(CurrURLQ(),"&","^")%>')
			return;
		}else if(rstStr ==-1){
			alert('폴더는 10개까지만 등록가능합니다.');
			return;
		}else{
			//alert(rstStr);
			alert('데이터처리에 문제가 발생했습니다.');
			return;
		}
	}

	function TnWishedit(sUrl){
		var f = $('input:radio[name="selfidx"]:checked').val();
		
		if(f == undefined){
			alert("저장할 위시 폴더를 선택하세요.");
			return;
		}

		var frm = document.frmW;
		frm.backurl.value = sUrl;
		frm.fidx.value = f;
		frm.submit();
	}
	
</script>

<form name="frmW" method="post" action="/apps/appcom/cal/webview/my10x10/myfavorite_process.asp" style="margin:0px;">
	<input type="hidden" name="backurl" value="">
	<input type="hidden" name="ispop" value="<%=vIsPop%>">
	<input type="hidden" name="bagarray" value="<%=bagarray%>">
	<input type="hidden" name="mode" value="<%=mode%>">
	<input type="hidden" name="itemid" value="<%=itemid%>">
	<input type="hidden" name="fidx" value="">
	<input type="hidden" name="oldfidx" value="<%=fidx%>">
</form>

</head>
<body>
<div class="modalLyr">
	<div class="wishSltPop">
		<div class="popHead">
			<h1>WISH폴더선택</h1>
			<a href="">&times;</a>
		</div>

		<div class="popCont">
			<ul class="wishFoldList">
				<% ' for dev msg : 비공개 폴더시 클래스 locked 추가 %>
				<li class="locked">
					<label>
						<% If mode = "add" AND fidx = "" Then %>
							<input type="radio" name="selfidx" value="0" checked /> <p>기본폴더</p>							
						<% Else %>
							<input type="radio" name="selfidx" value="0" <%if Cstr(fidx) = Cstr(0) THEN %>checked<%end if%> /> <p>기본폴더</p>
						<% End If %>					
					</label>
				</li>

	          	<%
	          	IF isArray(arrList) THEN
	          	
	          	For intLoop = 0 To UBound(arrList,2)
	          	%>				
				<li class="<%=CHKIIF(arrList(2,intLoop)="N","locked","")%>">
					<label>
						<input type="radio" name="selfidx" value="<%=arrList(0,intLoop)%>" <%if Cstr(fidx) = Cstr(arrList(0,intLoop)) THEN %>checked<%end if%> /> 
						<p><%=arrList(1,intLoop)%></p> 
					</label>
				</li>
	        	<%
	        	Next
	            
	            END IF
	            %>
				
		    	<form name="frmF" method="post" action="/apps/appcom/cal/webview/my10x10/myfavorite_folderProc.asp" style="margin:0px;" onsubmit="return false;">
		    	<input type="hidden" name="hidM" value="I">
		    	<input type="hidden" name="ispop" value="<%=vIsPop%>">
		    	<input type="hidden" name="bagarray" value="<%=bagarray%>">
				<input type="hidden" name="mode" value="<%=mode%>">
				<input type="hidden" name="itemid" value="<%=itemid%>">
		    	<input type="hidden" name="backurl" value="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%= itemid %>">
		    	<input type="hidden" name="backbackurl" value="<%=backurl%>">				
				<li class="added">
					<span><p>폴더추가</p></span>
					<ul>
						<li class="noti"><p>폴더명은 10자 이내로 작성해주세요.</p></li>
						<li>
							<p class="formArea">
								<label><input type="text" name="sFN" maxlength="10" onKeyPress="if (event.keyCode == 13){ jseditFolder();return false;}" required placeholder="폴더명 입력" /></label>
							</p>
						</li>
						<li class="folderOpt">
							<div class="folderOpt">
								<input type="radio" name="viewisusing" value="Y" checked checked="checked" id="open" /> <label for="open">공개</label>
								<input type="radio" name="viewisusing" value="N" id="notOpen" /> <label for="notOpen">비공개</label>
								<input type="button" value="추가" class="actBtn ftRt" onclick="jseditFolder();" />
							</div>
						</li>
					</ul>
				</li>
				</form>
			</ul>
			<div class="ct tPad30">
				<input type="button" value="확인" class="actBtn2 ct" onclick="TnWishedit('<%=backurl%>');" />
			</div>
		</div>
	</div>
</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->