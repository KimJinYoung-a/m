<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
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
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%

dim i, sqlStr
dim userid, bagarray, mode, itemid, viewisusing, vIsPop
dim foldername,fidx,backurl, backbackurl
dim arrList, intLoop,stype
dim myfavorite, intResult, vErrLocationValue
userid  		= getEncLoginUserID
stype    		= requestCheckvar(request("hidM"),1)
viewisusing    	= requestCheckvar(request("viewisusing"),1)
foldername  	= requestCheckvar(request("sFN"),20)
fidx			= requestCheckvar(request("fidx"),9)
backurl		= requestCheckvar(request("backurl"),100)
backbackurl = requestCheckvar(request("backbackurl"),100)

bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
mode    	= requestCheckvar(request("mode"),16)
itemid  	= requestCheckvar(request("itemid"),9)
vIsPop		= requestCheckvar(request("ispop"),3)
vErrLocationValue		= requestCheckvar(request("ErBValue"),9)


SELECT CASE stype
	CASE "I"	'폴더추가		
		set myfavorite = new CMyFavorite	
			myfavorite.FRectUserID      	= userid
			myfavorite.FFolderName		= foldername
			myfavorite.fviewisusing = viewisusing
			intResult = myfavorite.fnSetFolder
		set myfavorite = nothing		
		
		IF intResult > 0  THEN
	%>
		<script language="javascript">
		<!--		
			<%if Cstr(backurl) ="Popmyfavorite_folder.asp" then%>
				location.href="mywishlist.asp";
			<%elseif Cstr(backurl) ="popWishFolder_listajax.asp" then%>
				parent.location.reload();
			<%elseif Cstr(backurl) ="popWishFolder_folderlistajax.asp" then%>
				parent.goWishFolderListPop();
			<%else%>
				location.href ="<%=backurl%>?fidx=<%=intResult%>&bagarray=<%=bagarray%>&mode=<%=mode%>&itemid=<%=itemid%>&ispop=<%=vIsPop%><%=CHKIIF(backbackurl="/my10x10/popularwish.asp","&backurl=/my10x10/popularwish.asp","")%>&ErBValue=<%=vErrLocationValue%>";
			<%end if%>
		//-->
		</script>
<%	
		dbget.Close :response.end
		ELSEIF 	intResult =-1 THEN
			Alert_return("폴더는 20개까지만 등록가능합니다.")	
		dbget.Close :response.end
		ELSE
			Alert_return("데이터처리에 문제가 발생했습니다.")	
		dbget.Close :response.end
		END IF	
	
	CASE "U" 	'폴더수정	
		set myfavorite = new CMyFavorite	
			myfavorite.FFolderIdx      	= fidx
			myfavorite.FFolderName		= foldername
			myfavorite.fviewisusing = viewisusing
			intResult = myfavorite.fnSetFolderUpdate
		set myfavorite = nothing			
		
		IF intResult = 1 THEN
%>
		<script language="javascript">
		<!--
			<%if Cstr(backurl) ="popWishFolder_folderlistajax.asp" then%>
				parent.goWishFolderListPop();
			<%else%>
				location.href="mywishlist.asp";
				location.href ="<%=backurl%>";
			<%end if%>
		//-->
		</script>
<%		
		dbget.Close :response.end		
		ELSE
			Alert_return("데이터처리에 문제가 발생했습니다.")	
		dbget.Close :response.end
		END IF	
	
	CASE "D"		'폴더삭제		
		set myfavorite = new CMyFavorite	
			myfavorite.FFolderIdx      	= fidx
			myfavorite.FRectUserID      	= userid			
			intResult = myfavorite.fnSetFolderDelete
		set myfavorite = nothing			
		
		IF intResult = 1 THEN
%>
		<script language="javascript">
		<!--
			<%if Cstr(backurl) ="popWishFolder_folderlistajax.asp" then%>
				parent.goWishFolderListPop();
			<%else%>
				location.href="mywishlist.asp";
				location.href ="<%=backurl%>";
			<%end if%>
		//-->
		</script>
<%		
		dbget.Close :response.end		
		ELSE
			Alert_return("데이터처리에 문제가 발생했습니다.")	
		dbget.Close :response.end
		END If
	
	CASE "S"	'Sorting 저장 2016-06-17 이종화
		Dim sIdx ,sSortno 
		for i=1 to request.form("chkidx").count
			sIdx = request.form("chkidx")(i)
			sSortNo = request.form("sort"&sIdx)
			if sSortNo="" then sSortNo="0"

			sqlStr = sqlStr & "Update db_my10x10.[dbo].[tbl_myfavorite_folder] Set "
			sqlStr = sqlStr & " sortno='" & sSortNo & "'"
			sqlStr = sqlStr & " Where fidx='" & sIdx & "' and userid= '"& userid &"';" & vbCrLf
		Next
	
		IF sqlStr<>"" Then
			dbget.Execute sqlStr
%>
		<script>
		<!--
			<%if Cstr(backurl) ="popWishFolder_folderlistajax.asp" then%>
				alert('순서가 저장 되었습니다.');
				parent.goWishFolderListPop();
			<%else%>
				location.href="mywishlist.asp";
				location.href ="<%=backurl%>";
			<%end if%>
		//-->
		</script>
<%		
			dbget.Close :response.end		
		ELSE
			Alert_return("데이터처리에 문제가 발생했습니다.")	
			dbget.Close :response.end
		END IF
		
	CASE ELSE
		Alert_return("데이터처리에 문제가 발생했습니다.")	
	dbget.Close :response.end
END SELECT
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->