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
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<%
Dim sMode,suserid, ievt_code, arrevt_code
Dim clsMFE
Dim iReturnValue, chkPop
sMode 	= requestCheckvar(request("hidM"),1)
suserid  = getEncLoginUserID
ievt_code= requestCheckvar(request("eventid"),10)
arrevt_code = requestCheckvar(request("chkevt"),200)
chkPop = requestCheckvar(request("pop"),1)

If sMode = "U" Then
	Dim vQuery
	vQuery = "SELECT COUNT(userid) FROM [db_my10x10].[dbo].[tbl_myfavorite_event] WHERE userid = '" & suserid & "' AND evt_code = '" & ievt_code & "'"
	rsget.Open vQuery, dbget, 1
	If rsget(0) > 0 Then
		sMode = "D"
		arrevt_code = ievt_code
	Else
		sMode = "I"
	End If
	rsget.close
End If

If  sMode <> "D" then
	If ievt_code ="" THEN
			%>
		<script type="text/javascript"> 
			alert("데이터 처리에 문제가 발생하였습니다.고객센터에 문의해주세요");
			self.location.href = "about:blank"; 
		</script>
	<%		
	END If
End If 
SELECT CASE sMode
CASE "I"
	set clsMFE = new CProcMyFavoriteEvent
		clsMFE.FUserId	 	= suserid
		clsMFE.Fevtcode	 	= ievt_code
		iReturnValue 			= clsMFE.fnSetMyFavoriteEvent
	set clsMFE = nothing
	
	if chkPop="L" then
		Response.Write iReturnValue
	else
		IF iReturnValue <> 0 THEN 

		ELSE
%>
	<script type="text/javascript"> 
		alert("데이터 처리에 문제가 발생하였습니다.고객센터에 문의해주세요");
		self.location.href = "about:blank"; 
	</script>
<%	 
		response.end
		END IF
	end if
CASE "D"
	set clsMFE = new CProcMyFavoriteEvent
		clsMFE.FUserId	 	= suserid
		clsMFE.Fevtcode	 	= arrevt_code
		iReturnValue 			= clsMFE.fnDelMyFavoriteEvent
	set clsMFE = nothing
	IF iReturnValue = 1 THEN  

	ELSE
		%>
	<script type="text/javascript"> 
		alert("데이터 처리에 문제가 발생하였습니다.고객센터에 문의해주세요");
		self.location.href = "about:blank"; 
	</script>
<%
	END IF	
CASE ELSE
	%>
	<script type="text/javascript"> 
		alert("데이터 처리에 문제가 발생하였습니다.고객센터에 문의해주세요");
		self.location.href = "about:blank"; 
	</script>
<%
END SELECT


%>
<!-- #include virtual="/lib/db/dbclose.asp" -->