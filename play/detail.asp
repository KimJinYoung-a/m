<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim sqlStr1 , sqlStr2 , sqlStr3
	Dim contents_pidx : contents_pidx = requestCheckVar(request("pidx"),10)
	dim userid : userid = getEncLoginUserID()

	Dim vPidx , vCidx , vExcutepath , vHtmlcode , vMyrecord , oCnt
	Dim cTitlename
	Dim arrList

	If contents_pidx = "" Then
		Call Alert_Return("PIDX가 없습니다..")
		response.End
	End If 

    strHeadTitleName = "PLAY"

	'// contents data
	sqlStr1 = "SELECT  l.pidx , l.cidx , l.excutepath , l.htmlcode , my.myrecord "
	sqlStr1 = sqlStr1 & "	FROM db_sitemaster.dbo.tbl_playlist AS l "
	sqlStr1 = sqlStr1 & " CROSS APPLY ( SELECT (case when count(pidx) > 0 then 1 else 0 end) as myrecord FROM db_sitemaster.dbo.tbl_playlist_mylist WHERE userid = '"& userid &"' and pidx = "& contents_pidx &" ) as my"
	sqlStr1 = sqlStr1 & "	WHERE pidx = '"& contents_pidx &"'"
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr1,dbget,adOpenForwardOnly, adLockReadOnly
    if Not(rsget.EOF or rsget.BOF) Then
		vPidx		= rsget("pidx")
		vCidx		= rsget("cidx")
		vExcutepath = rsget("excutepath")
		vHtmlcode	= rsget("htmlcode")
		vMyrecord	= rsget("myrecord")
	end if
    rsget.Close

	'// contents titlename
	sqlStr2 = "SELECT titlename FROM db_sitemaster.dbo.tbl_playcontents WHERE cidx = "& vCidx  &""
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr2,dbget,adOpenForwardOnly, adLockReadOnly
    if Not(rsget.EOF or rsget.BOF) Then
		cTitlename		= rsget("titlename")
	end if
    rsget.Close

	'// 더 살펴 보기 DATA
	sqlStr3 = "SELECT top 3 l.pidx , l.cidx , l.titlename , l.contents , l.listimage , my.myrecord "
	sqlStr3 = sqlStr3 & "	FROM db_sitemaster.dbo.tbl_playlist AS l "
	sqlStr3 = sqlStr3 & " CROSS APPLY ( SELECT (case when count(pidx) > 0 then 1 else 0 end) as myrecord FROM db_sitemaster.dbo.tbl_playlist_mylist WHERE userid = '"& userid &"' and pidx = l.pidx ) as my "
	sqlStr3 = sqlStr3 & "	WHERE pidx <> '"& contents_pidx &"' and cidx = "& vCidx &" and listimage is not null "
	sqlStr3 = sqlStr3 & "	ORDER BY NEWID() "
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr3,dbget,adOpenForwardOnly, adLockReadOnly
	IF Not (rsget.EOF OR rsget.BOF) THEN
		arrList = rsget.GetRows
	END If
	rsget.close
%>
<!-- #include virtual="/lib/inc/head.asp" -->
</head>
<body class="default-font body-sub playV18 detail-play">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="detail-cont">
			<div>
				<%
					If vHtmlcode <> "" Then
						Response.write vHtmlcode
					End If 

					If vExcutepath <> "" Then
						If checkFilePath(server.mappath(vExcutepath)) Then
							server.execute(vExcutepath)
						End If
					End If
				%>
			</div>
		</div>

		<%
			If isArray(arrList) Then
				If ubound(arrList,2) >= 2 Then 
		%>
		<div class="research-more">
			<h3>'<%=cTitlename%>’ 더 살펴보기</h3>
			<ul>
				<%
					For oCnt = 0 To ubound(arrList,2)
				%>
					<li onclick="location.replace('<%=wwwUrl%>/play/detail.asp?pidx=<%=arrList(0,oCnt)%>');">
						<div class="thumbnail"><img src="<%=Replace(arrList(4,oCnt),"//play","/play")%>" alt="" /></div>
						<div class="desc">
							<span><%=cTitlename%></span>
							<p><%=arrList(2,oCnt)%></p>
						</div>
					</li>
				<%
					Next 
				%>
			</ul>
		</div>
		<%
				End If 
			End If 
		%>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->