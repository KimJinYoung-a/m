<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/designfingers/dfCommentCls.asp" -->
<%
dim clsProcDF
dim userid, masterid, gubuncd, txtcomm, sitename, id, iComCurrentPage, commentGubun, returnurl
dim iconid
dim sMode,iResult

sMode		= requestCheckVar(request.Form("sM"),1)
userid 		= requestCheckVar(request.Form("userid"),16)
returnurl = requestCheckVar(request.Form("returnurl"),100)


SELECT Case sMode
	Case "I"
		masterid 	= requestCheckVar(request.Form("masterid"),10)
		gubuncd 	= requestCheckVar(request.Form("gubuncd"),1)
		txtcomm 	= request.Form("tx_comment")
		
		if checkNotValidTxt(txtcomm) then
			Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
			dbget.close()	:	response.End
		end if
		
		txtcomm = Html2Db(txtcomm)
		sitename = requestCheckVar(request.Form("sitename"),50)
		iconid =  requestCheckVar(request.Form("iconid"),2)
	
		set clsProcDF = new CProcDesignFingers
			iResult = clsProcDF.fnSaveComment(userid,masterid,gubuncd,txtcomm,sitename,iconid,flgDevice)			
		set clsProcDF = nothing
			if iResult = 2 THEN
				Alert_move "한번에 5회 이상 연속 등록 불가능합니다.","about:blank"
				dbget.close()	:	response.End
			elseif iResult = 0 then
				Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
				dbget.close()	:	response.End
			end if
			
			If returnurl <> "" Then
				response.write "<script language=javascript>top.location.href = '" & returnurl & "';</script>"
			Else
				response.write "<script language=javascript>parent.goPage('1');</script>"
			End IF
					
				dbget.close()	:	response.End
	Case "D"
		masterid =requestCheckVar(request.Form("masterid"),10)
		id	= requestCheckVar(request.Form("id"),10)
		iComCurrentPage	= requestCheckVar(request("iCC"),10)
		set clsProcDF = new CProcDesignFingers
			iResult = clsProcDF.fnDelComment(userid,id)			
		set clsProcDF = nothing
		
			if iResult <> 1 then
				Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank" 
				dbget.close()	:	response.End
			end if
			
			If returnurl <> "" Then
				response.write "<script language=javascript>top.location.href = '" & returnurl & "';</script>"
			Else
				response.write "<script language=javascript>parent.goPage('1');</script>"
			End IF
								
				dbget.close()	:	response.End
	Case "U"
		commentGubun = NullFillWith(requestCheckVar(request("commentGubun"),10),"U")
		id	= requestCheckVar(request.Form("id"),10)
		masterid 	= requestCheckVar(request.Form("masterid"),10)
		gubuncd 	= requestCheckVar(request.Form("gubuncd"),1)
		txtcomm 	= Html2Db(request.Form("tx_comment"))
		
		if checkNotValidTxt(txtcomm) then
			Alert_move "내용에 유효하지 않은 글자가 포함되어 있습니다. 다시 작성 해주세요.","about:blank"
			dbget.close()	:	response.End
		end if
		
		txtcomm = Html2Db(txtcomm)
		sitename = requestCheckVar(request.Form("sitename"),50)
		iconid =  requestCheckVar(request.Form("iconid"),2)
	
		set clsProcDF = new CProcDesignFingers
			iResult = clsProcDF.fnUpdateComment(commentGubun,id,userid,txtcomm)			
		set clsProcDF = nothing
			if iResult = 2 THEN
				Alert_move "한번에 5회 이상 연속 등록 불가능합니다.","about:blank"
				dbget.close()	:	response.End
			elseif iResult = 0 then
				Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
				dbget.close()	:	response.End
			end if
			
			If returnurl <> "" Then
				response.write "<script language=javascript>top.location.href = '" & returnurl & "';</script>"
			Else
				response.write "<script language=javascript>parent.goPage('1');</script>"
			End IF	
				
				dbget.close()	:	response.End
	Case Else
			Alert_move "데이터처리에 문제가 발생했습니다. 관리자에게 문의해주세요","about:blank"
			dbget.close()	:	response.End
END SELECT		



%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
