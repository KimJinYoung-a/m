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
<!-- #include virtual="/apps/appcom/wish/web2014/lib/head.asp" -->
<%
Dim vItemID, vErrLocationValue, vErrBackLocationUrl, vWUserId, vAction, bagarray, fidx
vItemID = getNumeric(request("itemid"))
vErrLocationValue = getNumeric(request("ErBValue"))
vWUserId = requestCheckvar(request("vWUserId"), 32) '// 위시 프로필에서 넘어올땐 해당 유저 아이디 값이 필요함
vAction = requestCheckvar(request("folderAction"), 32)
bagarray = requestCheckvar(request("bagarray"), 1024)
fidx		= requestCheckvar(request("mffIdx"),9)

If fidx="" Then
	fidx="0"
End If


'// 특정상품 Wish불가
if vItemID="1212183" or vItemID="1404138" or vItemID="1404911" then
	Response.Write "<script>alert('Wish에 담을 수 없는 상품입니다.');" & vbCrLf &_
				"setTimeout(""fnAPPclosePopup()"",500);</script>"
	dbget.Close :response.end
end if
if inStr(bagarray,"1212183")>0 or inStr(bagarray,"1404138")>0 or inStr(bagarray,"1404911")>0 then
	Response.Write "<script>alert('Wish에 담을 수 없는 상품이 포함되어 있습니다.');" & vbCrLf &_
				"setTimeout(""fnAPPclosePopup()"",500);</script>"
	dbget.Close :response.end
end if

'// history.back()값이 없을 시 원복할 url 주소 셋팅
Select Case vErrLocationValue

	Case "1" '// 카테고리 리스트
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/category/category_list.asp?disp=101"

	Case "2" '// 위시리스트
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/wish/index.asp"

	Case "3" '// 상품상세
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/category/category_itemprd.asp?itemid="&vItemID
		
	Case "4" '// BEST AWARD
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/award/awardItem.asp"
    
    Case "5" '// 장바구니
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/inipay/ShoppingBag.asp"
		
	Case "6" '// SALE
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/sale/saleitem.asp"
		
    Case "9" '// 앱에서 호출
        vErrBackLocationUrl = ""

	Case "10" '// 마이위시프로필(폴더수정)
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/my10x10/mywish/mywish.asp"

	Case "11" '// 마이위시프로필(상품이동)
		vErrBackLocationUrl = wwwUrl&"/apps/appcom/wish/web2014/my10x10/mywish/mywish.asp?fIdx="&fidx&"&vlg=wlist"
		
	Case "12" '// 우수회원샵
		vErrBackLocationUrl = wwwUrl&"/apps/appCom/wish/web2014/my10x10/special_shop.asp"

    Case ELSE 
        vErrBackLocationUrl = request.ServerVariables("HTTP_REFERER")
End Select


If Trim(vAction)="" Then
	vAction = "add"
End If

If vErrLocationValue="5" Or vErrLocationValue="10" Or vErrLocationValue="11" Then
Else
	If vItemID = "" Then
		Response.Write "<script>잘못된 경로입니다.</script>"
		dbget.close()
		Response.End
	End If
End If
%>
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script>
$(function(){
	<% if vErrLocationValue="10" then %>
		goWishFolderListPop();
	<% else %>
		goWishListPop();
	<% end if %>
});

function goWishListPop(){
	$.ajax({
			url: "popWishFolder_listajax.asp?itemid=<%=vItemID%>&mode=<%=vAction%>&bagarray=<%=bagarray%>&fidx=<%=fidx%>",
			cache: false,
			success: function(message)
			{
				$("#wishfolderdiv").empty().append(message);
			}
	});
}

function goWishFolderListPop(){
	$.ajax({
			url: "popWishFolder_folderlistajax.asp?itemid=<%=vItemID%>&ErBValue=<%=vErrLocationValue%>",
			cache: false,
			success: function(message)
			{
				$("#wishfolderdiv").empty().append(message);
			}
	});
}

//sorting
function goWishFolderSortingPop(){
	$.ajax({
			url: "popWishFolder_sortingajax.asp?itemid=<%=vItemID%>&ErBValue=<%=vErrLocationValue%>",
			cache: false,
			success: function(message)
			{
				$("#wishfolderdiv").empty().append(message);
			}
	});
}

function jsCloseThis(){
<%
	Select Case vErrLocationValue
		Case "9"	'// APP호출
			Response.Write "fnAPPaddWishCnt('"&vItemID&"',1);" & vbCrLf &_
						"setTimeout(""fnAPPclosePopup()"",500);"
		Case "3"	'// 상품상세
			Response.Write "fnAPPopenerJsCallClose(""window.location.reload()"");"
		Case "4","6", "2"	'// Best, Sale, Wish
			Response.Write "fnAPPopenerJsCallClose(""FnPlusWishCnt("&vItemID&")"");"
		Case "13"	'// 이벤트상세
			Response.Write "fnAPPopenerJsCallClose(""jsAfterWishBtn('"&vItemID&"');"");"
		Case Else	'// 기타
			Response.Write "fnAPPopenerJsCallClose(""goBack('"&vErrBackLocationUrl&"')"");"
	End Select
%>
	return false;
}

// settimeOut 내부가 복잡하여 뺏음.
function jstOfn(){
    fnAPPopenerJsCallClose("goBack('<%=vErrBackLocationUrl%>')");

}

function jsNudgeAddNCloseThis(){
<%
    '' 수정중 2015/07/22
    dim retJs : retJs =""
''    if (flgDevice="I") then
''        ''retJs = "fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);"& vbCrLf  ''ios 는 이방식2015/08/18 추가  
''        retJs = "fnAPPopenerJsCall(""fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);"");"& vbCrLf  '' 안드로이드 방식 (iso도 가능)
''    else
''	    retJs = "fnAPPopenerJsCall(""fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);"");"& vbCrLf  '' 안드로이드 방식
''	end if
	
	Select Case vErrLocationValue
		Case "9"	'// APP호출  없음// 기존동일.
		    Response.Write "fnAPPaddWishCnt('"&vItemID&"',1);" & vbCrLf &_
						"setTimeout(""fnAPPclosePopup()"",500);"
		    retJs = ""
		Case "3"	'// 상품상세
		    retJs = "fnAPPopenerJsCall(""fnAPPsetNudgeTrack('incrCustParam',2,'wish_count',1);"");"& vbCrLf
		    retJs = retJs & "setTimeout(""fnAPPopenerJsCallClose('window.location.reload()')"",300);"
		Case "4","6", "2"	'// Best, Sale, Wish
			''retJs = retJs & "setTimeout(""fnAPPopenerJsCallClose('FnPlusWishCnt("&vItemID&")')"",500);"
			''retJs = retJs & "setTimeout(""fnAPPopenerJsCall('FnPlusWishCnt("&vItemID&")')"",300);"  ''GNB 일경우 동작 방식이 다름?
			retJs = "setTimeout(""fnAPPopenerJsCallClose('FnPlusWishCntNg("&vItemID&")')"",300);" ''GNB 일경우 동작 방식이 다름? incrCustParam 을 Gnb안에 삽입.
		Case "5"    ''장바구니 기존방식
		    Response.Write "fnAPPopenerJsCallClose(""goBack('"&vErrBackLocationUrl&"')"");"
		    retJs = ""
		Case Else	'// 기타 기존방식
		    Response.Write "fnAPPopenerJsCallClose(""goBack('"&vErrBackLocationUrl&"')"");"
		    retJs = ""
	End Select
	
	response.write retJs
%>
	return false;
}
</script>
<style type="text/css">
.wishAction {padding:21px 10px 0;}
.wishAction .box1 {padding:15px 0; color:#555; font-size:15px; line-height:1.375em; text-align:center;}
.wishAction .box1 em {display:block; color:#000;}
.wishAction .box1 strong {color:#d60000; font-weight:normal;}
.wishAction .btnwrap {margin-top:25px; text-align:center;}
.wishAction ul {margin-top:23px;}
.wishAction ul li {color:#888; font-size:12px; line-height:1.375em;}
@media all and (min-width:480px){
	.wishAction .box1 {padding:22px 0; font-size:22px;}
	.wishAction .btnwrap {margin-top:37px;}
	.wishAction ul li {font-size:18px;}
	.wishAction ul {margin-top:34px;}
}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="container">
		<!-- content area -->
		<div id="wishfolderdiv"></div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->