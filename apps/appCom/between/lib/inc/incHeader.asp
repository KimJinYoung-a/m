<header class="header">
	<ul class="navi boxMdl">
		<li class="navi01 <% If Request.ServerVariables("PATH_INFO") = "/apps/appCom/between/index.asp" Then response.write "current" End If %>">
			<p onclick="self.location='/apps/appCom/between/index.asp';">비트윈추천</p>
		</li>
		<li class="navi02 <% If Request.ServerVariables("PATH_INFO") = "/apps/appCom/between/category/category_list.asp" Then response.write "current" End If %>">
			<p onclick="self.location='/apps/appCom/between/category/category_list.asp';">카테고리</p>
		</li>
		<li class="navi03 <% If (Instr(Request.ServerVariables("PATH_INFO"),"/apps/appCom/between/my10x10/") > 0) OR (Instr(Request.ServerVariables("PATH_INFO"),"/apps/appCom/between/inipay/") > 0) Then response.write "current" End If %>">
			<p onclick="self.location='/apps/appCom/between/my10x10/index.asp';">마이페이지
			<% If session("WeekNotiCnt")>0 Then %>
				<span class='newIco saleRed'>N<span>
			<% End If %>
			</p>
		</li>
	</ul>
</header>