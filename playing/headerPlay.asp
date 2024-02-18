<%
	Dim vCa1HeaderOn, vCa2HeaderOn, vCa3HeaderOn
	SELECT CASE vCate
		Case "thing" : vCa1HeaderOn = "on"
		Case "talk"  : vCa2HeaderOn = "on"
		Case "inspi" : vCa3HeaderOn = "on"
	END SELECT
%>
<div class="sortingBarV16">
	<ul>
		<li class="sortingAll"><a href="list.asp" <%=CHKIIF(vCate="","class=""on""","")%>><span>ALL</span></a></li>
		<li class="sortingThing"><a href="list.asp?cate=thing" class="<%=vCa1HeaderOn%>"><i></i><span>THING.</span></a></li>
		<li class="sortingTalk"><a href="list.asp?cate=talk" class="<%=vCa2HeaderOn%>"><i></i><span>TALK</span></a></li>
		<li class="sortingInspiration"><a href="list.asp?cate=inspi" class="<%=vCa3HeaderOn%>"><i></i><span>!NSPIRATION</span></a></li>
	</ul>
</div>