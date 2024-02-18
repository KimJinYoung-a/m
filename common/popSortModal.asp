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
%>
<div class="layerPopup schFilterCtgy">
	<div class="popWin">
		<div class="header">
			<h1>정렬</h1>
			<p class="btnPopClose"><button class="pButton" onclick="fnCloseHalfModal();">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content" id="layerScrollBtm">
			<div id="scrollarea">
				<div class="categoryListup">
					<ul>
						<li <% If sType="b" Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&atype=b&disp=<%=sDisp%>">인기순</a></li>
						<li <% If sType="n" Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&atype=n&disp=<%=sDisp%>">신상순</a></li>
						<li <% If sType="f" Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&atype=f&disp=<%=sDisp%>">위시순</a></li>
						<li <% If sType="s" Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&atype=s&disp=<%=sDisp%>">할인순</a></li>
					</ul>
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>