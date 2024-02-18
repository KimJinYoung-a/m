<ul>
<%
SET clistmore = New CPlay
clistmore.FRectTop		= "3"
clistmore.FRectStartdate	= "getdate()"
clistmore.FRectState		= "7"
clistmore.FRectCate		= fnPlayingCateVer2("topcode",vCate)
clistmore.FRectDIdx		= vDIdx
vListMoreArr = clistmore.fnPlayCornerMoreList
SET clistmore = Nothing

'd.didx, d.title, imgurl
IF isArray(vListMoreArr) THEN
	For limo=0 To UBound(vListMoreArr,2)
%>
	<li>
		<a href="view.asp?didx=<%=vListMoreArr(0,limo)%>">
			<div class="desc"><span><i><%=db2html(vListMoreArr(1,limo))%></i></span></div>
			<img src="<%=vListMoreArr(2,limo)%>" alt="" />
		</a>
	</li>
<%
	Next
End If
%>
</ul>