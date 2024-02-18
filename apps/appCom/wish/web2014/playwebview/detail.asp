<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
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
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
</head>
<body class="default-font body-sub playV18 detail-play">
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
			<div class="btn-group">
				<button type="button" rel="<%=vPidx%>" class="play-bookmark <%=chkiif(vMyrecord, "on" ,"") %>"><i><%=chkiif(vMyrecord ,"책갈피 완료","책갈피")%></i></button>
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
					<li onclick="location.replace('<%=wwwUrl%>/apps/appCom/wish/web2014/playwebview/detail.asp?pidx=<%=arrList(0,oCnt)%>');">
						<div class="thumbnail"><img src="<%=Replace(arrList(4,oCnt),"//play","/play")%>" alt="" /></div>
						<div class="desc">
							<span><%=cTitlename%></span>
							<p><%=arrList(2,oCnt)%></p>
							<div class="btn-group">
							<!--<button type="button" class="play-share"><i>공유</i></button> -->
								<button type="button" rel="<%=arrList(0,oCnt)%>" class="play-bookmark <%=chkiif(arrList(5,oCnt),"on","")%>"><i>책갈피</i></button>
							</div>
						</div>
					</li>
				<%
					Next 
				%>
			</ul>
			<a href="" class="btn-all" onclick="fnPopupPlayContentsHome('<%=cTitlename%>','<%=vCidx%>');return false;">전체보기 &gt;</a>
		</div>
		<%
				End If 
			End If 
		%>
	</div>
	<script>
	$(function(){
		$(".play-bookmark").click(function(){
		<% if IsUserLoginOK() then %>
			var _this = $(this);
			var _thisval = $(this).attr("rel");
			var Data = {
				"contents_pidx" : _thisval ,
				"user_id" : ""
			}
			$.ajax({
				url: "/apps/appcom/wish/webapi/play/setrecord_wproc.asp",
				type: "POST",
				dataType : 'json',
				timeout : 3000,
				data : JSON.stringify(Data) ,
				contentType : "application/json; charset=utf-8",
				success: function(data) {
					if (data.record){
						_this.addClass("on");
						_this.find('i').text("책갈피 완료");
					}else{
						_this.removeClass("on");
						_this.find('i').text("책갈피");
					}
					
					// callnative
					fnSetPlayRecord(data.contents_pidx , data.record);
				}
			});
		<% else %>
			calllogin();
			return false;
		<% end if %>
		});
	});
	</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->