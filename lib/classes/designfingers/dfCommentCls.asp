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


		sqlStr = "exec [db_sitemaster].[dbo].sp_Ten_designfingers_GetComment_2013 '" + Cstr(FPageSize*FCurrPage) + "','" + Cstr(FRectFingerID) + "','" + FRectSiteName + "',''" + vbcrlf
		
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
			<p class="ct b ftMid tMar25">총 <span class="cC40"><%=FTotalCount%></span>개의 코멘트가 있습니다.</p>
			<div class="ct tMar15">
				<span class="btn btn1 gryB w80B"><a href="/designfingers/fingers_comment.asp?fingerid=<%=iDFSeq%>&sort=<%=FRectSort%>">전체보기</a></span>
				<span class="btn btn1 redB w80B"><a href="/designfingers/fingers_write.asp?fingerid=<%=iDFSeq%>&sort=<%=FRectSort%>&m=m">쓰기</a></span>
			</div>
<%
		Else
			GetFingerUsing
%>	

			<div class="innerW overHidden btmGyBdr bPad05">
				<span class="ftLt tMar10 ftMid b">Total <%=FTotalCount%></span>
				<span class="ftRt btn btn3a redB w70B" style="margin-bottom:-5px;"><a href="/designfingers/fingers_write.asp?fingerid=<%=FRectFingerID%>&sort=<%=FRectSort%>">쓰기</a></span>
			</div>

			<p class="innerH15W10 ftMid c999"><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" alt="모바일 작성" width="9px"/> 아이콘은 모바일에서 작성한 코멘트입니다.</p>

			<ul class="cmtList">
			<% if FResultcount<1 then %>
			<!-- // 게시글이없을경우 // -->
				<li class="innerH15W10">
					<div id="fingers_cmtext">해당 게시물이 없습니다.</div>
				</li>
			<!-- // 게시글이없을경우 끝 // -->
			<%else

				dim nextCnt		'다음페이지 게시물 수
				if (FTotalCount-(FPageSize*FCurrPage)) < FPageSize then
					nextCnt = (FTotalCount-(FPageSize*FCurrPage))
				else
					nextCnt = FPageSize
				end if

				for ix=0 to FResultcount-1 %>

				<li class="innerH15W10">
					<p class="ftMid b"><% = (FTotalCount - (FPageSize * FPCount))- ix %><% If FCommentList(ix).FDevice <> "W" Then %> <img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" width="9px" alt="모바일 작성"/><% End If %></p>
					<p class="tMar10 ftMidSm c999 lh12">
					<%
						if Not(FCommentList(ix).FComment="" or isNull(FCommentList(ix).FComment)) then
							arrComm = split(FCommentList(ix).FComment,"||,||")
							Response.Write arrComm(0)
						end if
					%>
					</p>
					<p class="tMar10 ftMidSm2 c999">
						<span class="b"><% if FCommentList(ix).FUserID<>"10x10" then %><%=printUserId(FCommentList(ix).FUserID,2,"*") %><% End If %> <em class="innerW n">|</em> <% = Left(FCommentList(ix).FRegDate,10) %>&nbsp; </span>
						<% if ((GetLoginUserID = FCommentList(ix).Fuserid) or (GetLoginUserID = "10x10")) and (FCommentList(ix).Fuserid<>"") then %>
						<span class="lMar10 btn btn5 gryB w40B"><a href="/designfingers/fingers_write.asp?fingerid=<%=FRectFingerID%>&sort=<%=FRectSort%>&id=<%=FCommentList(ix).FID%>">수정</a></span>
						<span class="btn btn5 gryB w40B"><a href="javascript:DelComments('<%=FCommentList(ix).FID%>');">삭제</a></span>
						<% end if %>
					</p>
				</li>
			<% next %>
			<% end if %>
			<!-- // 게시글 끝 // -->	            
			<% if (cint(FCurrPage) < cint(FTotalPage)) then %>
				<div>
					<a href="/designfingers/action_comment.asp?fingerid=<%=Cstr(FRectFingerID)%>&sort=<%=FRectSort%>&iCC=<%= CStr(FCurrPage + 1) %>" target="_replace">
						<table style="margin-top:25px;">	
							<tr>
								<td width=150 height=37 align="center" class="mytt_text" style="background:url(http://fiximage.10x10.co.kr/m/common/btn_moreItemBg.png) 50% repeat-y;vertical-align:middle; font-size:11px;"><%=FPageSize%>개 더 보기 (<%=FCurrPage & "/" & FTotalPage%>)</td>
							</tr>
						</table>
					</a>
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