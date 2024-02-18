<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 M 메인-이벤트inc
' History : 2017-09-26 유태욱 생성
'####################################################
%>
<%
dim odibest
set odibest = new cdiary_list
	odibest.FPageSize = 3
	odibest.FCurrPage = 1
	odibest.FselOp	 	= 0			'이벤트정렬
	odibest.FSCType 	= ""    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	odibest.FEScope = 2
	odibest.FEvttype = "1"
'	odibest.FEvttype = "19,26"
	odibest.fnGetdievent
%>

<% If odibest.FResultCount > 0 Then %>
	<% FOR i = 0 to odibest.FResultCount -1 %>
		<li>
			<a href="" onclick="goEventLink('<%=odibest.FItemList(i).fevt_code %>'); return false;">
				<div class="thumbnail"><img src="<%=odibest.FItemList(i).fevt_mo_listbanner %>" alt="<%=odibest.FItemList(i).FEvt_name %>"></div>
				<p class="desc">
				<%
				Dim tmpevtname, tmpevtnamesale
				if ubound(Split(odibest.FItemList(i).FEvt_name,"|"))> 0 Then
					tmpevtname = cStr(Split(odibest.FItemList(i).FEvt_name,"|")(0))
					tmpevtnamesale = cStr(Split(odibest.FItemList(i).FEvt_name,"|")(1))
				else
					tmpevtname = odibest.FItemList(i).FEvt_name
					tmpevtnamesale	= ""
				end if
				%>
					<b class="headline"><span class="ellipsis"><%=db2html(tmpevtname) %></span><% if tmpevtnamesale <> "" then %> <b class="discount color-red"><%=db2html(tmpevtnamesale)%></b><% end if %></b>
					<span class="subcopy"><!--<span class="label label-color"><em class="color-blue">기프트</em></span>--> <%=db2html(odibest.FItemList(i).FEvt_subname) %></span>
				</p>
			</a>
		</li>
	<% next %>
<% end if %>
<% set odibest = nothing %>