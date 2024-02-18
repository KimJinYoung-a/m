<%@  codepage="65001" language="VBScript" %>
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
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
dim i, sqlStr, userid, bagarray, mode, itemid, vIsPop, backurl,fidx,oldfidx, arrList, intLoop
	userid  	= GetLoginUserID
	bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
	mode    	= requestCheckvar(request("mode"),16)
	itemid  	= requestCheckvar(request("itemid"),9)
	fidx		= requestCheckvar(request("fidx"),9)
	backurl =  requestCheckvar(request("backurl"),100)
	oldfidx	= requestCheckvar(request("oldfidx"),9)
	vIsPop		= requestCheckvar(request("ispop"),16)

if backurl ="" then backurl = request.ServerVariables("HTTP_REFERER")
dim myfavorite, vWishEventOX
vWishEventOX = "x"
'####### 위시리스트 이벤트용으로 구분값에 따라 데이터 처리.

set myfavorite = new CMyFavorite
	'---데이터 처리
	myfavorite.FRectUserID = userid
	myfavorite.FFolderIdx = fidx
	arrList = myfavorite.fnGetFolderList
	
	If Now() > #10/04/2013 00:00:00# AND Now() < #10/14/2013 00:00:00# Then
		IF isArray(arrList) THEN
			For intLoop = 0 To UBound(arrList,2)
				If left(arrList(1,intLoop),11) = "[pick show]" AND CStr(arrList(0,intLoop)) = CStr(fidx) Then
					vWishEventOX = "o"
				End If
				If left(arrList(1,intLoop),11) = "[pick show]" AND CStr(arrList(0,intLoop)) = CStr(oldfidx) AND mode="Change" Then
					vWishEventOX = "c"
				End If
			Next
		End If
	End If

	if (mode = "DelFavItems") then
		myfavorite.selectdelete(bagarray)
		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.fnWishListEventSave
		End IF
	elseif (mode= "AddFavItems") then	
		myfavorite.selectedinsert(bagarray)
		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.fnWishListEventSave
		End IF
	elseif (mode= "add") then
		myfavorite.iteminsert(itemid)
		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.fnWishListEventSave
		End IF
	elseif(mode ="Change") then	
		myfavorite.FOldFolderIdx		= oldfidx
		myfavorite.fnChangeFolder(bagarray)
		
		IF vWishEventOX = "c" Then
			vWishEventOX = "o"
			fidx = oldfidx
		End IF
		
		IF vWishEventOX = "o" Then
			myfavorite.FRectUserID	= userid
			myfavorite.FFolderIdx	= fidx
			myfavorite.fnWishListEventSave
		End IF
	end if		

	'// 폴더 정보 업데이트
	myfavorite.fnUpdateFolderInfo
set myfavorite = nothing


Dim vQuery
If mode = "add" Then	'### 1개만 지울때 itemid만 넘어옴.
	bagarray = itemid
End IF
IF Left(bagarray,1) = "," Then		'### 끝에 , 일때 지워줌.
	bagarray = Right(bagarray,Len(bagarray)-1)
End IF
IF Right(bagarray,1) = "," Then		'### 끝에 , 일때 지워줌.
	bagarray = Left(bagarray,Len(bagarray)-1)
End IF

If Trim(bagarray) = "" Then
	dbget.close()
	response.end
End If

vQuery = "UPDATE R SET " & vbCrLf
vQuery = vQuery & " 	favcount = D.cnt " & vbCrLf
vQuery = vQuery & " FROM [db_item].[dbo].[tbl_item_Contents] AS R " & vbCrLf
vQuery = vQuery & " INNER JOIN " & vbCrLf
vQuery = vQuery & " ( " & vbCrLf
vQuery = vQuery & " 	SELECT itemid, count(itemid) AS cnt FROM [db_my10x10].[dbo].[tbl_myfavorite] where itemid in(" & bagarray & ") " & vbCrLf
vQuery = vQuery & " 	GROUP BY itemid " & vbCrLf
vQuery = vQuery & " ) AS D ON R.itemid = D.itemid " & vbCrLf
vQuery = vQuery & " where R.itemid in(" & bagarray & ") " & vbCrLf

'rw vQuery
dbget.Execute vQuery
%>

<% If vIsPop = "ajax" Then %>
	<script language="javascript">
		location.href = "<%=Replace(backurl,"^","&")%>";
	</script>

<% Else %>
	<script language="javascript">
		location.href = "<%=Replace(backurl,"^","&")%>";
	</script>
<% end if %>

<!-- #include virtual="/lib/db/dbclose.asp" -->
