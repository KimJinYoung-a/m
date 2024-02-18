<%
Dim cCa43down, fc43, vCa43DownArr
SET cCa43down = New CPlay
cCa43down.FRectDIdx = vDIdx
cCa43down.FRectDevice = "mo"
vCa43DownArr = cCa43down.fnPlayDownloadList
SET cCa43down = Nothing
%>
<article class="playDetailV16 wallpaper">
	<div class="bg" style="background-color:#<%=vBGColor%>;"></div>
	<div class="hgroup">
		<div>
			<a href="list.asp?cate=thing" class="corner">THING.</a>
			<h2><%=vTitle%></h2>
		</div>
	</div>

	<!-- contents -->
	<div class="cont">
		<div class="detail">
			<div class="figure"><img src="<%=fnPlayImageSelect(vImageList,vCate,"9","i")%>" alt="" /></div>
			<ul class="download">
				<%
				IF isArray(vCa43DownArr) THEN
					For fc43=0 To UBound(vCa43DownArr,2)
				%>
					<li><a href="<%=vCa43DownArr(1,fc43)%>"><%=vCa43DownArr(0,fc43)%></a></li>
				<%
					Next
				End IF
				%>
			</ul>
		</div>
		<!-- #include file="./inc_sns.asp" -->
	</div>
</article>