<%
'// 디자인 핑거스 코멘트
Class CDesignFingersComment
	public FRectFingerID
	public FCommentList()
	public FTotalCount
	public FResultCount

	public FCurrPage
	public FTotalPage
	public FPageSize
	public FScrollCount
	
	public FRectDelete	
	public FRectTitle
	public FRectSiteName
	public FPCount
	public FRectSort
	public FRectGubun
	
	Private Sub Class_Initialize()		
		redim preserve FCommentList(0)
		FCurrPage =1
		FPageSize = 20
		FResultCount = 0
		FScrollCount = 5
		FTotalCount =0
		FRectSiteName = "10x10"
	End Sub

	Private Sub Class_Terminate()
		dim i
		for i= 0 to FResultCount
			set FCommentList(i) = nothing
		next 	
	End Sub
	
	public sub GetFingerUsingMain()
		dim sqlStr,i

		sqlStr = "exec [db_sitemaster].[dbo].sp_Ten_designfingers_GetCommentCnt '" + Cstr(FRectFingerID) + "','" + FRectSiteName + "'" + vbcrlf

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget, 1

		FTotalCount = rsget("cnt")
		rsget.Close

	end sub
	
	public sub GetFingerUsing()
		dim sqlStr,i


		sqlStr = "exec [db_sitemaster].[dbo].sp_Ten_designfingers_GetCommentCnt '" + Cstr(FRectFingerID) + "','" + FRectSiteName + "'" + vbcrlf

		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.Open sqlStr, dbget, 1

		FTotalCount = rsget("cnt")
		rsget.Close


		sqlStr = "exec [db_sitemaster].[dbo].sp_Ten_designfingers_GetComment '" + Cstr(FPageSize*FCurrPage) + "','" + Cstr(FRectFingerID) + "','" + FRectSiteName + "'" + vbcrlf
		
		rsget.CursorLocation = adUseClient
		rsget.CursorType = adOpenStatic
		rsget.LockType = adLockOptimistic
		rsget.pagesize = FPageSize
		rsget.Open sqlStr, dbget, 1

		FtotalPage =  CInt(FTotalCount\FPageSize)
		if  (FTotalCount\FPageSize)<>(FTotalCount/FPageSize) then
			FtotalPage = FtotalPage +1
		end if
		FPCount = FCurrPage - 1

		FResultCount = rsget.RecordCount-(FPageSize*(FCurrPage-1))

		redim preserve FCommentList(FResultCount)
		i=0
		if  not rsget.EOF  then
			rsget.absolutepage = FCurrPage
			do until rsget.eof
				set FCommentList(i) = new CFingerCommentItem

				FCommentList(i).FID      	= rsget("id")
				FCommentList(i).FFingerID	= FRectFingerID
				FCommentList(i).FUserID  	= rsget("userid")
				FCommentList(i).FIconID  	= rsget("iconid")
				FCommentList(i).FComment 	= db2Html(rsget("comment"))
				FCommentList(i).FRegdate 	= rsget("regdate")
				FCommentList(i).FDevice		= rsget("device")

				i=i+1
				rsget.moveNext
			loop
		end if

		rsget.Close
	end sub
	
	
	
	public Function HasPreScroll()
		HasPreScroll = StarScrollPage > 1
	end Function

	public Function HasNextScroll()
		HasNextScroll = FTotalPage > StarScrollPage + FScrollCount -1
	end Function

	public Function StarScrollPage()
		StarScrollPage = ((FCurrpage-1)\FScrollCount)*FScrollCount +1
	end Function
	
	public Sub sbGetCommentDisplay
		Dim ix,i, arrComm
		FPageSize = 10	
		FRectSiteName = "10x10"	
		IF FCurrPage = "" THEN FCurrPage = 1	
		
		If FRectGubun = "main" Then
			GetFingerUsingMain
		Else
			GetFingerUsing
		End If

		If FRectGubun = "main" Then
			GetFingerUsingMain
%>
			<li id="fingers_ment">총 <span><%=FTotalCount%></span>개의 코멘트가 있습니다.</li>
			<li>
				<a href="/designfingers/fingers_comment.asp?fingerid=<%=iDFSeq%>&sort=<%=FRectSort%>" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/common/btn_viewall.png"></a>
				<a href="/designfingers/fingers_write.asp?fingerid=<%=iDFSeq%>&sort=<%=FRectSort%>&m=m" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/common/btn_write.png"></a>
			</li>
<%
		Else
			GetFingerUsing
%>	
			<li>
				<p id="fingers_cmbdp">
				<span>Total <%=FTotalCount%></span><a href="/designfingers/fingers_write.asp?fingerid=<%=FRectFingerID%>&sort=<%=FRectSort%>" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/common/btn_write.png" width="52" height="30" class="btn"/></a></p>
				<p id="fingers_cmbdp"><img src="http://fiximage.10x10.co.kr/m/fingers/txt_comment.png"></p>
			</li>

			<% if FResultcount<1 then %>
			<!-- // 게시글이없을경우 // -->
				<li>
					<div id="fingers_cmtext">해당 게시물이 없습니다.</div>
				</li>
			<!-- // 게시글이없을경우 끝 // -->
			<%else%> 
			<% for ix=0 to FResultcount-1 %>
				<li>
					<div id="fingers_cmnum"><% = (FTotalCount - (FPageSize * FPCount))- ix %><% If FCommentList(ix).FDevice <> "W" Then %> <img src="http://fiximage.10x10.co.kr/m/fingers/icon_comment.png"><% End If %></div>
					<div id="fingers_cmtext">
					<%
						if Not(FCommentList(ix).FComment="" or isNull(FCommentList(ix).FComment)) then
							arrComm = split(FCommentList(ix).FComment,"||,||")
							Response.Write arrComm(0)
						end if
					%>
						<p><% if FCommentList(ix).FUserID<>"10x10" then %><%=printUserId(FCommentList(ix).FUserID,2,"*") %><% End If %> l <% = Left(FCommentList(ix).FRegDate,10) %>&nbsp;
						<% if ((GetLoginUserID = FCommentList(ix).Fuserid) or (GetLoginUserID = "10x10")) and (FCommentList(ix).Fuserid<>"") then %>
						<a href="/designfingers/fingers_write.asp?fingerid=<%=FRectFingerID%>&sort=<%=FRectSort%>&id=<%=FCommentList(ix).FID%>" title="_webapp"><img src="http://fiximage.10x10.co.kr/m/common/btn_modify.png"></a>
						<img src="http://fiximage.10x10.co.kr/m/common/btn_del.png" onClick="DelComments('<%=FCommentList(ix).FID%>')" style="cursor:pointer"><% end if %></p>
					</div>
				</li>
			<% next %>
			<% end if %>
			<!-- // 게시글 끝 // -->	            
	
			<!-- // 코멘트넘버 시작 숫자 5페이지까지표시// -->
				<% if FResultcount > 0 then %>
				<div id="paging">
					<% if HasPreScroll then %>
						<a href="/designfingers/fingers_comment.asp?fingerid=<%=Cstr(FRectFingerID)%>&sort=<%=FRectSort%>&iCC=<%= CStr(StarScrollPage - 1) %>" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_prev.png"></a>
					<%else%>
						<a href="/designfingers/fingers_comment.asp?fingerid=<%=Cstr(FRectFingerID)%>&sort=<%=FRectSort%>&iCC=1" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_prev.png"></a>
					<%end if%>
					<% for i = StarScrollPage to (StarScrollPage + 5 - 1) %>
						<% if (i > FTotalPage) then Exit For %>
						<a href="/designfingers/fingers_comment.asp?fingerid=<%=Cstr(FRectFingerID)%>&sort=<%=FRectSort%>&iCC=<%=i%>" class="num<% if CStr(i) = CStr(FCurrPage) then %>On<% end if %>Box" title="_webapp"><%=i%></a> 
	
					<% next %>
					<% if HasNextScroll then %>
						<a href="/designfingers/fingers_comment.asp?fingerid=<%=Cstr(FRectFingerID)%>&sort=<%=FRectSort%>&iCC=<%= CStr(StarScrollPage + FScrollCount) %>" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_next.png" /></a>
					<%else%>
						<a href="/designfingers/fingers_comment.asp?fingerid=<%=Cstr(FRectFingerID)%>&sort=<%=FRectSort%>&iCC=<%=FTotalPage%>" title="_webapp" class="numArrow"><img src="http://fiximage.10x10.co.kr/m/common/paging_next.png" /></a>
					<% end if %>
				</div>
				<% end if %>
<%
		End If
%>
		<!-- // 코멘트넘버 끝// -->
<%		END Sub	
End Class

Class CFingerCommentItem
	public FID
	public FFingerID
	public FUserID
	public FIconID
	public FComment
	public FRegdate
	public FDevice
	
	Private Sub Class_Initialize()

	End Sub

	Private Sub Class_Terminate()

	End Sub
end Class

Class CProcDesignFingers

	public Function fnSaveComment(byval userid,byval masterid,byval gubuncd,byval tx_comment, byval sitename, byval iconid, byval flgDevice)
		dim strSql		
		dim refip
		Dim objCmd
		Dim intResult
		
		refip = request.ServerVariables("REMOTE_ADDR")
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection =  dbget
			.CommandType = adCmdText
			.CommandText = "{?=call [db_sitemaster].[dbo].sp_Ten_designfingers_SetComment("&gubuncd&","&masterid&",'"&userid&"','"&sitename&"','"&iconid&"','"&tx_comment&"','"&refip&"','"&flgDevice&"') }"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
		End With
		intResult = objCmd(0).Value
		Set objCmd = nothing
		
		fnSaveComment = intResult
	end Function

	public Function fnDelComment (byval userid,Byval id)
		dim strSql		
		dim refip
		Dim objCmd
		Dim intResult
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection =  dbget
			.CommandType = adCmdText
			.CommandText = "{?=call [db_sitemaster].[dbo].sp_Ten_designfingers_SetDelComment("&id&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
		End With
		intResult = objCmd(0).Value
		Set objCmd = nothing
		
		fnDelComment = intResult
	End Function
	
	public Function fnUpdateComment (byval gubun,Byval id,byval userid,byval tx_comment)
		dim strSql		
		dim refip
		Dim objCmd
		Dim intResult
		Set objCmd = Server.CreateObject("ADODB.Command")
		If gubun = "V" Then
			rsget.Open "[db_sitemaster].[dbo].sp_Ten_designfingers_SetUpdateComment ('"&gubun&"',"&id&",'"&userid&"','"&tx_comment&"')", dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
			IF Not (rsget.EOF OR rsget.BOF) THEN
				intResult	= rsget(0)
			END IF
			rsget.close
		Else
			With objCmd
				.ActiveConnection =  dbget
				.CommandType = adCmdText
				.CommandText = "{?=call [db_sitemaster].[dbo].sp_Ten_designfingers_SetUpdateComment('"&gubun&"',"&id&",'"&userid&"','"&tx_comment&"')}"
				.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
				.Execute, , adExecuteNoRecords
			End With
			intResult = objCmd(0).Value
		End If
		Set objCmd = nothing
		
		fnUpdateComment = intResult
	End Function
	
	public Function fnSetWinner(byval userid,Byval id)
		dim strSql		
		dim refip
		Dim objCmd
		Dim intResult
		
		Set objCmd = Server.CreateObject("ADODB.Command")
		With objCmd
			.ActiveConnection =  dbget
			.CommandType = adCmdText
			.CommandText = "{?=call [db_sitemaster].[dbo].sp_Ten_designfingers_SetWinner("&id&",'"&userid&"')}"
			.Parameters.Append .CreateParameter("RETURN_VALUE", adInteger, adParamReturnValue)
			.Execute, , adExecuteNoRecords
		End With
		intResult = objCmd(0).Value
		Set objCmd = nothing
		
		fnDelComment = intResult
	End Function
	
End Class
%>