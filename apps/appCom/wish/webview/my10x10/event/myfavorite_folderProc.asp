<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#######################################################
'	History	:  2010.04.09 한용민 수정
'	Description : 위시리스트 관리
'#######################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<script type="text/javascript" src="/apps/appcom/wish/webview/js/tencommon.js?v=1.0"></script>
<%

dim i, sqlStr , viewisusing , userid, bagarray, mode, itemid, wishEvent, wishEventOX, vECode
dim foldername,fidx,backurl , arrList, intLoop,stype , myfavorite, intResult, vOpenerChk
	userid  		= getEncLoginUserID
	stype    		= requestCheckvar(request("hidM"),1)
	viewisusing    	= "Y"
	foldername  	= "담고받고즐기고!"
	fidx			= requestCheckvar(request("fidx"),9)
	backurl		= requestCheckvar(request("backurl"),100)
	bagarray	= Trim(requestCheckvar(request("bagarray"),1024))
	mode    	= requestCheckvar(request("mode"),16)
	itemid  	= requestCheckvar(request("itemid"),9)
	vOpenerChk	= requestCheckvar(request("op"),1)

	IF application("Svr_Info") = "Dev" THEN
		vECode = "21307"
	Else
		vECode = "55009"
	End If
%>
<!-- #include virtual="/my10x10/event/include_samename_folder_check.asp" -->
<%
SELECT CASE stype
	CASE "I"	'폴더추가

		set myfavorite = new CMyFavorite
			myfavorite.FRectUserID = userid
			myfavorite.FFolderName = foldername
			myfavorite.fviewisusing = viewisusing
			intResult = myfavorite.fnSetFolder
		set myfavorite = nothing

		IF intResult > 0  THEN
			Set wishEvent = new CMyFavorite
				wishEvent.FRectUserID	= userid
				wishEvent.FFolderIdx	= intResult
				wishEvent.fnWishListEventSave

				wishEventOX = wishEvent.FResultCount
			Set wishEvent = Nothing

			If wishEventOX = "x" Then
				Response.Write "<script>alert('데이터 처리에 문제가 생겼습니다.');</script>"
				dbget.close()
				Response.End
			ElseIf wishEventOX = "o" Then
				Call JoinEvent(vECode)
				Response.Write "<script>alert('담고받고즐기고! 폴더가 생성되었습니다.\n3개 미만의 상품을 담으실 경우 이벤트 리스트에 노출되지 않습니다.\n당첨자발표는 10월 3일 입니다.');callmain();</script>"
				dbget.close()
				Response.End
			End IF

		ELSEIF 	intResult =-1 THEN
			Alert_return("폴더는 10개까지만 등록가능합니다.")
			dbget.Close
			response.end
		ELSE
			Alert_return("데이터처리에 문제가 발생했습니다.")
			dbget.Close
			response.end
		END IF

END SELECT


Function JoinEvent(evt_code)
Dim vQuery
	vQuery = "IF NOT EXISTS(SELECT userid FROM [db_event].[dbo].[tbl_event_comment] WHERE evt_code = '" & evt_code & "' AND userid = '" & getEncLoginUserID & "') " & vbCrLf
	vQuery = vQuery & "BEGIN " & vbCrLf
	vQuery = vQuery & "		INSERT INTO [db_event].[dbo].[tbl_event_comment](evt_code,userid,evtcom_txt,evtcom_point,evtcom_regdate,evtcom_using,evtbbs_idx,evtgroup_code,refip,blogurl,device) " & vbCrLf
	vQuery = vQuery & "		SELECT '" & evt_code & "','" & getEncLoginUserID & "','','0',getdate(),'Y','0','0','" & Request.ServerVariables("REMOTE_ADDR") & "',null,'W'" & vbCrLf
	vQuery = vQuery & "END "
	dbget.execute(vQuery)
End Function
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->