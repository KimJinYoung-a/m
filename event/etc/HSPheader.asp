<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/HSProject/HSPCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
'#######################################################
'	History	:  2015.10.23 원승현 생성
'	Description : 헤이썸띵 Ajax 페이지
'#######################################################

 Dim clsEvtHSP
 Dim eCode, page, lp
 
 	eCode		= getNumeric(requestCheckVar(request("eventid"),10))
 	page 	  	= getNumeric(requestCheckVar(request("page"),8))



	if eCode 	= "" then eCode = 0
	if page		= "" then page 	= 1

 	Dim idaTotCnt, idaTotPg, arrDA, intDA
		set clsEvtHSP = new ClsHSP
		clsEvtHSP.FCurrPage = page
		clsEvtHSP.FPageSize = 3
		clsEvtHSP.FScrollCount = 3
		arrDA = clsEvtHSP.fnGetHSPList
		idaTotCnt = clsEvtHSP.FTotCnt
		idaTotPg = clsEvtHSP.FTotalPage
		set clsEvtHSP = nothing
 

	if isArray(arrDA) then


%>

<div id="navHey" class="navHey">
	<div class="navName"><b>CONTENTS LIST</b></div>
	<ul>
		<%' for dev msg : 한 페이지당 3개씩 보여주세요 %>
		<% for intDA=0 to ubound(arrDA,2) %>
		<li>
			<% If isApp="1" Then %>
				<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=arrDa(0,intDa)%>&page=<%=page%>" <% If Trim(eCode)=Trim(arrDa(0,intDa)) Then %>class="on"<% End If %>>
			<% Else %>
				<a href="/event/eventmain.asp?eventid=<%=arrDa(0,intDa)%>&page=<%=page%>" <% If Trim(eCode)=Trim(arrDa(0,intDa)) Then %>class="on"<% End If %>>
			<% End If %>

				<div class="thumb"><img src="<%=arrDa(3,intDa)%>" alt="<%=replace(arrDa(1,intDa),"""","")%>" /></div>
				<strong>
					<%
						If Len((idaTotCnt-CInt(arrDa(6,intDa))+1))="1" Then
							Response.write "0"&(idaTotCnt-CInt(arrDa(6,intDa))+1)&". "
						Else
							Response.write (idaTotCnt-CInt(arrDa(6,intDa))+1)&". "					
						End If
					%>
					<%=replace(arrDa(1,intDa),"""","")%>
				</strong>
				<span><%=replace(arrDa(5,intDa),"""","")%></span>
			</a>
		</li>
		<% Next %>
	</ul>

	<%= fnDisplayPaging_New(page,idaTotCnt,3,3,"goHSPPageH") %>
</div>

<% End If %>