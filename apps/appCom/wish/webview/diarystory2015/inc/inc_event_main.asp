<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리
' History : 2014-10-13 한용민 생성
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
	odibest.FEvttype = "19,25"
	odibest.fnGetdievent
%>

<% If odibest.FResultCount > 0 Then %>
	<h2>DIARY EVENT</h2>
	<ul class="evtList">
		<% FOR i = 0 to odibest.FResultCount -1 %>
		<li>
			<a href="/apps/appcom/wish/webview/event/eventmain.asp?eventid=<%=odibest.FItemList(i).fevt_code %>">
				<div class="pic"><img src="<%=odibest.FItemList(i).fevt_mo_listbanner %>" alt="<%=odibest.FItemList(i).FEvt_name %>" /></div>
				<dl>
					<dt>
						<%=odibest.FItemList(i).FEvt_name %>

						<% ' for dev msg : 이벤트 타입은 세일/할인/GIFT/참여/한정/1+1 의 우선순위로 한개씩만 노출됩니다. %>
						<% if odibest.FItemList(i).fisgift then %>
							<span class="cGr2">GIFT</span>
						<% elseif odibest.FItemList(i).fiscomment then %>
							<span class="cBl2">참여</span>
						<% elseif odibest.FItemList(i).fisoneplusone then %>
							<span class="cGr2">1+1</span>
						<% end if %>

						<!--<span class="cGr1">30%~</span>-->
						<!--<span class="cRd1">30%~</span>-->
						<!--<span class="cBl3">한정</span>-->
					</dt>
					<dd><%=odibest.FItemList(i).FEvt_subname %></dd>
				</dl>
			</a>
		</li>
		<% next %>
	</ul>
	<div class="more"><a href="/apps/appCom/wish/webview/diarystory2015/event.asp" title="다이어리 이벤트 더보기">more</a></div>
<% end if %>

<%
set odibest = nothing
%>