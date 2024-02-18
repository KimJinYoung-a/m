<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->

<%
	Dim sDir, disp, sDisp, sType
	Dim cpg, srm, arrds, ListDiv, arrcont, arrkey, iccd, vparameter, tempvParameter, etcparameter
	
	sDir = request("sDir")

	cpg = request("cpg")
	srm = request("srm")
	vparameter = request("vparameter")
	tempvParameter = split(vparameter, "&")
	etcparameter = "&"&tempvParameter(2)&"&"&tempvParameter(3)&"&"&tempvParameter(4)&"&"&tempvParameter(5)

%>
<div class="layerPopup schFilterCtgy">
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
						<li <% If Trim(tempvParameter(1))="arrds=" Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&srm=<%=srm%>&<%="arrds="&etcparameter%>">전체</a></li>
						<li <% If Trim(tempvParameter(1))="arrds=10," Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&srm=<%=srm%>&<%="arrds=10,"&etcparameter%>">Simple</a></li>
						<li <% If Trim(tempvParameter(1))="arrds=20," Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&srm=<%=srm%>&<%="arrds=20,"&etcparameter%>">illust</a></li>
						<li <% If Trim(tempvParameter(1))="arrds=30," Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&srm=<%=srm%>&<%="arrds=30,"&etcparameter%>">Pattern</a></li>
						<li <% If Trim(tempvParameter(1))="arrds=40," Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&srm=<%=srm%>&<%="arrds=40,"&etcparameter%>">Photo</a></li>
						<!--<li <% If Trim(tempvParameter(1))="arrds=50," Then %>class="current"<% End If %>><a href="<%=sDir%>?cpg=1&srm=<%=srm%>&<%="arrds=50,"&etcparameter%>">Limited</a></li>-->
					</ul>																																	
				</div>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>