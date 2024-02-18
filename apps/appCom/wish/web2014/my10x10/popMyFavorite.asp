<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>

<!-- #include virtual="/apps/appCom/wish/web2014/login/checkLogin.asp" -->
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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/apps/appCom/wish/web2014/lib/css/mypage2013.css">
<script language="javascript" src="/apps/appCom/wish/web2014/js/shoppingbag_script.js"></script>
<script language="javascript" src="/apps/appCom/wish/web2014/js/tencommon.js"></script>
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
<body class="shop">
    <div class="box">
        <header class="modal-header">
            <h1 class="modal-title">WISH 폴더 선택</h1>
        </header>
        <div class="modal-body">
        	<div class="iscroll-area">
	        	<form name="frmF" method="post" action="/my10x10/myfavorite_folderProc.asp" style="margin:0px;">
	        	<input type="hidden" name="hidM" value="I">
	        	<input type="hidden" name="ispop" value="<%=vIsPop%>">
	        	<input type="hidden" name="bagarray" value="<%=bagarray%>">
	    		<input type="hidden" name="mode" value="<%=mode%>">
	    		<input type="hidden" name="itemid" value="<%=itemid%>">
	        	<input type="hidden" name="backurl" value="/apps/appCom/wish/web2014/my10x10/popMyFavorite.asp">
	        	<input type="hidden" name="backbackurl" value="<%=backurl%>">
	            <div class="inner" >
	                <p class="well t-c">위시 상품을 담을 폴더를 선택하세요.</p>
	                <div class="input-block">
	                    <label for="unlock" style="margin-right:10px;">
	                        <input type="radio" name="viewisusing" id="viewisusing" value="Y" checked class="form type-c"> 공개
	                    </label>
	                    <label for="lock">
	                        <input type="radio" name="viewisusing" id="viewisusing" value="N" class="form type-c"> 비공개
	                    </label>
	                </div>
	                <div class="input-block no-label">
	                    <label for="folderName" class="input-label">폴더명</label>
	                    <div class="input-controls">
	                        <input type="text" name="sFN" maxlength="10" onKeyPress="if (event.keyCode == 13){ jsSubmitFolder();return false;}" class="form full-size" placeholder="새 폴더 추가">
	                        <input type="button" class="side-btn btn type-a" onClick="jsSubmitFolder();" value="폴더추가">
	                    </div>
	                </div>
	                <em class="em">* 폴더명은 10자 이내로 작성하여 주세요.</em>   
	            </div>
	            </form>
				<form name="frmW" method="post" action="/my10x10/myfavorite_process.asp" style="margin:0px;">
				<input type="hidden" name="backurl" value="">
				<input type="hidden" name="ispop" value="<%=vIsPop%>">
				<input type="hidden" name="bagarray" value="<%=bagarray%>">
				<input type="hidden" name="mode" value="<%=mode%>">
				<input type="hidden" name="itemid" value="<%=itemid%>">
				<input type="hidden" name="fidx" value="">
				<input type="hidden" name="oldfidx" value="<%=fidx%>">
				</form>
	            <ul class="folder-list">
	                <li>
	                    <i class="icon-unlock"></i>
	                    <span class="folder-name">기본폴더</span>
						<% If mode = "add" AND fidx = "" Then %>
						<input type="radio" name="selfidx" class="form type-c" value="0" checked />
						<% Else %>
						<input type="radio" name="selfidx" class="form type-c" value="0" <%if Cstr(fidx) = Cstr(0) THEN %>checked<%end if%> />
						<% End If %>
	                </li>
		          	<%IF isArray(arrList) THEN
		          		For intLoop = 0 To UBound(arrList,2)
		          	%>
		                <li>
		                    <i class="icon-<%=CHKIIF(arrList(2,intLoop)="N","lock","unlock")%>"></i>
		                    <span class="folder-name"><%=arrList(1,intLoop)%></span>
		                    <input type="radio" class="form type-c" name="selfidx" value="<%=arrList(0,intLoop)%>"  <%if Cstr(fidx) = Cstr(arrList(0,intLoop)) THEN %>checked<%end if%> />
		                </li>
		        	<%
		        		Next
		            END IF%>
	            </ul>
	            <div class="inner">
	                <em class="em">* 기본폴더를 포함하여 최대 20개의 폴더를 등록할 수 있습니다.</p>
	            </div>
			</div>
        </div>
        <footer class="modal-footer">
	        <div class="two-btns">
	            <div class="col"><input type="button" class="btn type-b" value="등록" onClick="TnWishList('<%=backurl%>');"></div>
	            <div class="col"><a href="/apps/appCom/wish/web2014/inipay/ShoppingBag.asp" class="btn type-a full-size">취소</a></div>
	        </div>
            
        </footer>
    </div>
    
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->