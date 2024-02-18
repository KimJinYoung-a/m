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
'	Description : wish풀더 폴더추가
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
dim i, sqlStr, userid, bagarray, mode, itemid, viewisusing, vIsPop
dim foldername,fidx,backurl, backbackurl, arrList, intLoop,stype, myfavorite, intResult
	userid  		= GetLoginUserID
	stype    		= requestCheckvar(request("hidM"),1)
	viewisusing    	= requestCheckvar(request("viewisusing"),1)
	foldername  	= requestCheckvar(request("sFN"),20)
	fidx			= requestCheckvar(request("fidx"),9)
	backurl		= requestCheckvar(request("backurl"),100)
	backbackurl = requestCheckvar(request("backbackurl"),100)
	bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
	mode    	= requestCheckvar(request("mode"),16)
	itemid  	= requestCheckvar(request("itemid"),9)
	vIsPop		= requestCheckvar(request("ispop"),16)
%>

<!-- #include virtual="/my10x10/event/include_samename_folder_check.asp" -->

<%
SELECT CASE stype
	CASE "I"	'폴더추가		
		set myfavorite = new CMyFavorite	
			myfavorite.FRectUserID      	= userid
			myfavorite.FFolderName		= foldername
			myfavorite.fviewisusing = viewisusing
			intResult = myfavorite.fnSetFolder
		set myfavorite = nothing		
		
		If vIsPop = "ajax" then
			response.write intResult
			dbget.Close		:	response.end
		else
%>
			<script language="javascript">
				<%if Cstr(backurl) ="Popmyfavorite_folder.asp" then%>
					location.href="mywishlist.asp";
				<%end if%>
				
				location.href ="<%=backurl%>?fidx=<%=intResult%>&bagarray=<%=bagarray%>&mode=<%=mode%>&itemid=<%=itemid%>&ispop=<%=vIsPop%><%=CHKIIF(backbackurl="/my10x10/popularwish.asp","&backurl=/my10x10/popularwish.asp","")%>";
			</script>
<%
		end if

		dbget.Close		:	response.end
	
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

			location.href="mywishlist.asp";
			location.href ="<%=backurl%>";

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

			location.href="mywishlist.asp";
			location.href ="<%=backurl%>";

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