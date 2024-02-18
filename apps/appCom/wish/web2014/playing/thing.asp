<article class="playDetailV16 thing">
	<div class="hgroup">
		<div>
			<a href="list.asp?cate=thing" class="corner">THING.</a>
			<h2><%=vTitle%></h2>
		</div>
	</div>
	<div class="cont">
		<div class="detail">
			<%
			If vIsExec Then
				If vExecFile <> "" Then
					If checkFilePath(server.mappath(vExecFile)) Then
						server.execute(vExecFile)
					End If
				End If
			ElseIf Not vIsExec Then
				Response.Write vContents
			End If
			%>
		</div>
		<!-- #include file="./inc_sns.asp" -->
		<div class="listMore">
			<div class="more">
				<h2>다른 THING. 보기</h2>
				<a href="list.asp?cate=thing">more</a>
			</div>
			<!-- #include file="./inc_listmore.asp" -->
		</div>
	</div>
</article>