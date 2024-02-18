<%
	'# 현재 페이지명 접수
	dim nowPage
	nowPage = request.ServerVariables("SCRIPT_NAME")

	Dim cReCo, vParentIdx, vParentType, vArrRC, iRC
	vParentIdx = requestCheckVar(Request("idx"),10)
	vParentType = requestCheckVar(Request("type"),10)
	
	If vParentIdx <> "" Then
		If IsNumeric(vParentIdx) Then
			'0 ~ 7 : p.idx, p.viewno, p.viewnotxt, p.title, p.type, c.typename, p.contents_idx, p.listimg
			SET cReCo = New CPlay
			cReCo.FPageSize = "3"
			cReCo.FRectIdx = vParentIdx
			cReCo.FRectType = vParentType
			vArrRC = cReCo.fnPlayRecentContents
			SET cReCo = Nothing
			
			If isArray(vArrRC) THEN
%>
				<% if nowPage="/apps/appCom/wish/web2014/play/playPicDiary.asp" then %>
					<div class="inner5">
				<% elseif nowPage="/apps/appCom/wish/web2014/play/playStylePlus.asp" then %>
					<div class="inner5 tMar10">
				<% else %>
					<div class="inner5 tMar15">
				<% end if %>

					<div class="rctContent box1">
						<h3 class="tit03">RECENT CONTENT</h3>
						<ul>
						<% For iRC = 0 To UBound(vArrRC,2) %>
							<li>
								<a href="/apps/appCom/wish/web2014<%=fnPlayLinkMoWeb(vArrRC(4,iRC))%>?idx=<%=vArrRC(0,iRC)%>&contentsidx=<%=vArrRC(6,iRC)%>&type=<%=vArrRC(4,iRC)%>">
									<div class="thumb"><img src="<% = getThumbImgFromURL(vArrRC(7,iRC),176,0,"true","false") %>" alt="<%=Replace(db2html(vArrRC(3,iRC)),chr(34),"")%>" /></div>
									<div class="contTxt">
										<p class="num"><%=vArrRC(1,iRC)%><% If vArrRC(4,iRC) = "1" Then %> <%=vArrRC(2,iRC)%><% End If %></p>
										<p><%=chrbyte(db2html(vArrRC(3,iRC)),"18","Y")%></p>
									</div>
								</a>
							</li>
						<% Next %>
						</ul>
					</div>
				</div>
<%
			End IF
		End IF
	End IF
%>