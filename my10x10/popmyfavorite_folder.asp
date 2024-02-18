<%@  codepage="65001" language="VBScript" %>
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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim i, sqlStr
dim userid, bagarray, mode, itemid
dim backurl,fidx
dim arrList, intLoop

userid  	= getEncLoginUserID
fidx		= requestCheckvar(request("fidx"),9)

if (InStr(LCase(backurl),"10x10.co.kr") < 0) then
	 Alert_return("유입경로에 문제가 있습니다.")
	dbget.Close :response.end
end if

dim myfavorite
set myfavorite = new CMyFavorite	
	myfavorite.FRectUserID      	= userid	
	arrList = myfavorite.fnGetFolderList	
set myfavorite = nothing
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 위시 폴더관리</title>
<script type="text/javascript">
<!--
$(function() {
	$('.folderSub').hide();
	$('.folder .editBtn').click(function(e){
		e.preventDefault();
		if($(this).parent().parent().parent().children('.folderSub').is(":hidden")){
			$('.folderSub').hide();
			$(this).parent().parent().parent().children('.folderSub').show();
		}else{
			$(this).parent().parent().parent().children('.folderSub').hide();
		};
	});
});

function jsSubmitFolder(){	
	if(!jsChkNull("text",document.frmF.sFN,"폴더명을 입력해주세요")){
		document.frmF.sFN.focus();
		return;
	}

	if(!jsChkNull("radio",document.frmF.viewisusing,"공개 여부를 선택해 주세요")){		
		return;
	}	

	document.frmF.submit();
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

//-->
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="prevPage">
					<a href="/my10x10/mywishlist.asp"><em class="elmBg">이전으로</em></a>
				</div>
				<h2 class="innerW tPad15 bPad15">위시 폴더관리</h2>
				<form name="frmD" method="post" action="myfavorite_folderProc.asp" style="margin:0px;">
				<input type="hidden" name="hidM" value="D">
				<input type="hidden" name="backurl" value="popmyfavorite_folder.asp">
				<input type="hidden" name="fidx" value="">
				</form>
				<!-- 폴더 추가 -->
				<form name="frmF" method="post" action="myfavorite_folderProc.asp" style="margin:0px;">	
				<input type="hidden" name="hidM" value="I">
				<input type="hidden" name="backurl" value="popmyfavorite_folder.asp">
				<div class="overHidden inner bPad05 bgf7f7f7 topGyBdr btmGyBdr ftMidSm2">
					<p class="rMar02"><input type="text" class="text lh1 wFull" name="sFN" maxlength="10"  onKeyPress="if (event.keyCode == 13){ jsSubmitFolder();return false;}" /></p>
					<p class="ftLt tMar10">
						<label class="radio"><input type="radio" name="viewisusing" value="Y" id="viewisusing" /> 공개</label>
						<label class="lMar10 radio"><input type="radio" name="viewisusing" value="N" id="viewisusing" /> 비공개</label>
					</p>
					<span class="ftRt btn btn3 gryB2 w70B tMar05"><a href="javascript:jsSubmitFolder();">폴더추가</a></span>
				</div>
				</form>
				<!--// 폴더 추가 -->

				<!-- 폴더 관리 -->
				<div class="innerH15W10 ftMidSm2">
					<ul class="folderManage overHidden">
						<li>
							<div class="overHidden innerW">
								<p class="ftLt"><em class="elmBg3">기본폴더</em></p>
							</div>
						</li>
						<%
							IF isArray(arrList) THEN
								For intLoop = 0 To UBound(arrList,2)
						%>
								<li <% if arrList(2,intLoop)="N" then %>class="lock"<% end if %>>
									<div class="folder overHidden innerW">
										<p class="ftLt"><em class="elmBg3"><%=CHKIIF(Left(arrList(1,intLoop),11)="마이 웨딩 위시" AND Now() < #04/21/2015 00:00:00#,"<font COLOR=red>"&arrList(1,intLoop)&"</font>(이벤트중)",arrList(1,intLoop))%></em></p>
										<p class="ftRt tMar05">
											<span class="btn btn4 whtB2 w40B editBtn"><a href="">수정</a></span>
											<span class="btn btn4 gryB w40B"><a href="javascript:jsDelFolder(<%=arrList(0,intLoop)%>);">삭제</a></span>
										</p>
									</div>
									<div class="folderSub overHidden inner bPad05 bgf7f7f7 topDotBdr2">
									<form name="frmU<%=intLoop%>" method="post" action="myfavorite_folderProc.asp" style="margin:0px;">
									<input type="hidden" name="hidM" value="U">
									<input type="hidden" name="backurl" value="popmyfavorite_folder.asp">
									<input type="hidden" name="fidx" value="<%=arrList(0,intLoop)%>">
										<p class="rMar02"><input type="text" class="text lh1 wFull" name="sFN" value="<%=arrList(1,intLoop)%>" maxlength="10"  onKeyPress="if (event.keyCode == 13){ jsModFolder();return false;}" /></p>
										<p class="ftLt tMar10">
											<label><input type="radio" name="viewisusing" value="Y" id="viewisusing" <%=CHKIIF(arrList(2,intLoop)="Y","checked","")%> /> 공개</label>
											<label class="lMar10"><input type="radio" name="viewisusing" value="N" id="viewisusing" <%=CHKIIF(arrList(2,intLoop)="N","checked","")%> /> 비공개</label>
										</p>
										<span class="ftRt btn btn3 gryB2 w70B tMar05"><a href="javascript:jsModFolder(document.frmU<%=intLoop%>);">수 정</a></span>
									</form>
									</div>
								</li>
						<%
								Next
							End If
						%>
					</ul>
				</div>
				<!--// 폴더 관리 -->

			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
</div>
</body>
</html>