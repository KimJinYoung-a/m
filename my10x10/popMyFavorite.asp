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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim i, sqlStr
dim userid, bagarray, mode, itemid, vIsPop
dim backurl,fidx
dim arrList, intLoop

userid  	= getEncLoginUserID
bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
mode    	= requestCheckvar(request("mode"),16)
itemid  	= requestCheckvar(request("itemid"),9)
fidx		= requestCheckvar(request("fidx"),9)
backurl 	= requestCheckvar(request("backurl"),100)
vIsPop		= requestCheckvar(request("ispop"),3)

if backurl = "" then backurl = "close"
if bagarray = "" then bagarray = itemid

dim myfavorite
set myfavorite = new CMyFavorite
	'---데이터 처리
	myfavorite.FRectUserID      	= userid
	myfavorite.FFolderIdx		= fidx
	
	arrList = myfavorite.fnGetFolderList	
set myfavorite = nothing
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 위시 폴더</title>
<script type="text/javascript" src="/lib/js/shoppingbag_script.js"></script>
<script>
function foldernewdiv()
{
	if($("#foldernew").is(":hidden"))
	{
		$("#foldernew").show();
	}else{
		$("#foldernew").hide();
	}
}
</script>
</head>
<body>
<% If vIsPop = "pop" Then %>
<div class="popup">
	<div class="popTit nav">
		<h1>위시 폴더</h1>
		<p class="close"><a href="javascript:window.close();">닫기</a></p>
	</div>

	<div class="overHidden innerW tMar20">
		<p class="ftLt c888 lh12 ftMidSm2 tPad03">* 폴더 수정과 삭제는 MY WISH에서 사용하실 수 있습니다.<br />* 위시폴더는 기본폴더를 포함 최대20개까지 등록 가능합니다.</p>
		<span class="ftRt btn btn3 gryB2 w70B addBtn"><a href="javascript:foldernewdiv();">폴더추가</a></span>
	</div>
<% Else %>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="prevPage">
					<a href="javascript:history.back();"><em class="elmBg">이전으로</em></a>
				</div>
				<h2 class="innerW tPad15 bPad15">위시 폴더
				<span class="ftRt btn btn3 gryB2 w70B"><a href="javascript:foldernewdiv();">폴더추가</a></span>
				</h2>
<% End If %>
				<form name="frmW" method="post" action="/my10x10/myfavorite_process.asp" style="margin:0px;">
				<input type="hidden" name="backurl" value="">
				<input type="hidden" name="ispop" value="<%=vIsPop%>">
				<input type="hidden" name="bagarray" value="<%=bagarray%>">
				<input type="hidden" name="mode" value="<%=mode%>">
				<input type="hidden" name="itemid" value="<%=itemid%>">
				<input type="hidden" name="fidx" value="">
				<input type="hidden" name="oldfidx" value="<%=fidx%>">
				</form>
				<!-- 폴더 추가 -->
	        	<form name="frmF" method="post" action="/my10x10/myfavorite_folderProc.asp" style="margin:0px;">
	        	<input type="hidden" name="hidM" value="I">
	        	<input type="hidden" name="ispop" value="<%=vIsPop%>">
	        	<input type="hidden" name="bagarray" value="<%=bagarray%>">
	    		<input type="hidden" name="mode" value="<%=mode%>">
	    		<input type="hidden" name="itemid" value="<%=itemid%>">
	        	<input type="hidden" name="backurl" value="popMyFavorite.asp">
	        	<input type="hidden" name="backbackurl" value="<%=backurl%>">
				<div class="overHidden inner bPad05 bgf7f7f7 topGyBdr btmGyBdr ftMidSm2" style="display:none;" id="foldernew">
					<p class="rMar02"><input type="text" class="text lh1 wFull" name="sFN" maxlength="10" onKeyPress="if (event.keyCode == 13){ jsSubmitFolder();return false;}" /></p>
					<p class="ftLt tMar10">
						<label class="radio"><input type="radio" name="viewisusing" id="viewisusing" value="Y" checked/> 공개</label>
						<label class="lMar10 radio"><input type="radio" name="viewisusing" id="viewisusing" value="N" /> 비공개</label>
					</p>
					<span class="ftRt btn btn3 gryB2 w70B tMar05"><a href="javascript:jsSubmitFolder();">저 장</a></span>
				</div>
				</form>
				<!--// 폴더 추가 -->

				<!-- 폴더 목록 -->
				<div class="innerH15W10 ftMidSm2">
					<ul class="folderManage overHidden">
						<li>
							<label for="myfavorite0"><div class="overHidden innerW">
								<p class="ftLt"><em class="elmBg3">기본폴더</em></p>
								<p class="ftRt tMar10">
									<% If mode = "add" AND fidx = "" Then %>
									<input type="radio" name="selfidx" value="0" checked  id="myfavorite0" />
									<% Else %>
									<input type="radio" name="selfidx" value="0" <%if Cstr(fidx) = Cstr(0) THEN %>checked<%end if%> id="myfavorite0"/>
									<% End If %>
								</p>
							</div></label>
						</li>
			          	<%IF isArray(arrList) THEN
			          		For intLoop = 0 To UBound(arrList,2)
			          	%>
						<li <%=CHKIIF(arrList(2,intLoop)="N","class='lock'","")%>>
							<label for="myfavorite<%=intLoop+1%>"><div class="overHidden innerW">
								<p class="ftLt"><em class="elmBg3"><%=arrList(1,intLoop)%></em><% IF Left(Trim(arrList(1,intLoop)),11) = "마이 웨딩 위시" AND Now() < #04/21/2015 00:00:00# then %><em class="crMint fs11">| 이벤트 진행 중 |</em><% end if %></p>
								<p class="ftRt tMar10">
									<input type="radio" id="myfavorite<%=intLoop+1%>" name="selfidx" value="<%=arrList(0,intLoop)%>"  <%if Cstr(fidx) = Cstr(arrList(0,intLoop)) THEN %>checked<%end if%> />
								</p>
							</div></label>
						</li>
			        	<%
			        		Next
			            END IF%>
					</ul>
				</div>
				<!--// 폴더 목록 -->

				<div class="ct">
					<span class="btn btn1 gryB w90B"><a href="javascript:<% If vIsPop = "pop" Then %>window.close();<% Else %>history.back();<% End If %>">취소</a></span>
					<span class="btn btn1 redB w90B"><a href="javascript:TnWishList('<%=backurl%>');">등록</a></span>
				</div>
<% If vIsPop = "pop" Then %>
<% Else %>
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
<% End If %>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->