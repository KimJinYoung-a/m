<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/md5.asp" -->
<%
	Dim vItemID, vQuery, vUserID, vIsExistItem, vFolderIdx
	Dim vNewfolderflag : vNewfolderflag = false
	vItemID = requestCheckVar(request("itemid"),20)
	vUserID = getEncLoginUserID()
	
	If Not IsUserLoginOK Then
		dbget.close()
		Response.End
	End IF
	
	If Not isNumeric(vItemID) Then
		dbget.close()
		Response.End
	End IF	

	vQuery = "select count(f.itemid) from db_my10x10.dbo.tbl_myfavorite_folder as ff "
	vQuery = vQuery & "left join db_my10x10.dbo.tbl_myfavorite as f on ff.fidx = f.fidx and ff.userid = f.userid "
	vQuery = vQuery & "where f.userid = '" & vUserID & "' and f.itemid = '" & vItemID & "' and ff.foldername = 'Piece' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
	if rsget(0) > 0 then
		vIsExistItem = True
	else
		vIsExistItem = false
	end if
	rsget.close
	
	If vIsExistItem Then	'### 상품 있으면.
		vQuery = " delete [db_my10x10].[dbo].[tbl_myfavorite] from "
		vQuery = vQuery & " [db_my10x10].[dbo].[tbl_myfavorite] as f "
		vQuery = vQuery & " inner join db_my10x10.dbo.tbl_myfavorite_folder as ff "
		vQuery = vQuery & " on ff.fidx = f.fidx and ff.userid = f.userid and f.userid = '"& vUserID &"' and ff.foldername = 'Piece'"
		vQuery = vQuery & " and f.itemid = '"& vItemID &"' "
		dbget.execute vQuery
		
		Response.Write "off"
	Else					'### 상품 없으면.
		
		'### 폴더 존재여부
		vQuery = "select top 1 ff.fidx from db_my10x10.dbo.tbl_myfavorite_folder as ff where ff.userid = '" & vUserID & "' and ff.foldername = 'Piece'"
		rsget.CursorLocation = adUseClient
		rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
		if not rsget.eof then
			vFolderIdx = rsget(0)
		else
			vFolderIdx = ""
		end if
		rsget.close
		
		if vFolderIdx = "" then	'### 폴더 없을경우

			vQuery = "insert into [db_my10x10].[dbo].[tbl_myfavorite_folder](userid, foldername, viewisusing, sortno) values"
			vQuery = vQuery & "('" & vUserID & "', 'Piece', 'Y', 0)"
			dbget.execute vQuery
			
			vQuery = "select IDENT_CURRENT('db_my10x10.dbo.tbl_myfavorite_folder') as fidx"
			rsget.CursorLocation = adUseClient
			rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
			If Not Rsget.Eof then
				vFolderIdx = rsget("fidx")
				vNewfolderflag = True '// 폴더 생성됨
			end if
			rsget.close
		end if
		
		'### 위시 저장
		vQuery = "insert into db_my10x10.dbo.tbl_myfavorite(userid, itemid, regdate, fidx, viewIsUsing) values"
		vQuery = vQuery & "('" & vUserID & "', '" & vItemID & "', getdate(), '" & vFolderIdx & "', 'N')"
		dbget.execute vQuery
		
		If vNewfolderflag Then
			Response.Write "new"
		Else 
			Response.Write "on"
		End If 
	End If
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->