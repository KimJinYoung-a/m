<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->

<%
	Dim sDir, query1, depth, disp, tmp_str, sDisp, sType
	sDir = request("sDir")
	sDisp = request("sDisp")
	sType = request("sType")
	depth="1"
%>

<div class="layerPopup schFilterCtgy" >
	<div class="popWin">
		<div class="header">
			<h1>카테고리</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseHalfModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScrollBtm">
			<div id="scrollarea2">
				<div class="categoryListup">
					<ul>
						<li><a href='<%=sDir%>?cpg=1&atype=<%=sType%>'>전체 카테고리</a></li>
						<%
							query1 = " select catecode, catename from [db_item].[dbo].tbl_display_cate "
							query1 = query1 & " where depth = '" & depth & "' and useyn = 'Y' "
							If depth <> "1" Then
								query1 = query1 & " and Left(catecode,"&(depth-1)*3&") = '" & Left(disp,(depth-1)*3) & "' "
							End If
							query1 = query1 & " order by sortno Asc"
							rsget.Open query1,dbget,1
							'response.write query1 & "!!" & disp
							if  not rsget.EOF  then
								do until rsget.EOF
									if Left(Cstr(sDisp),3*depth) = Cstr(rsget("catecode")) then
										tmp_str = "class='current'"
									end if
									response.write "<li "&tmp_str&"><a href='"&sDir&"?cpg=1&disp="&rsget("catecode")&"&atype="&sType&"'>"& db2html(rsget("catename")) &"</a></li>"
									tmp_str = ""
								rsget.MoveNext
								loop
							end if
							rsget.close
						%>
					</ul>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>