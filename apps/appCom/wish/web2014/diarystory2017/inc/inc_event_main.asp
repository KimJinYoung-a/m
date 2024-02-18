<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리스토리 M 메인-이벤트inc
' History : 2016-09-20 유태욱 생성
'####################################################
%>
<%
dim odibest
set odibest = new cdiary_list
	odibest.FPageSize = 5
	odibest.FCurrPage = 1
	odibest.FselOp	 	= 0			'이벤트정렬
	odibest.FSCType 	= ""    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	odibest.FEScope = 2
	odibest.FEvttype = "1"
'	odibest.FEvttype = "19,26"
	odibest.fnGetdievent
%>

<% If odibest.FResultCount > 0 Then %>
	<h2><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/tit_diary_event.png" alt="diary event" /></h2>
	<a href="" onclick="fnAPPpopupBrowserURL('다이어리 이벤트','<%=wwwUrl%>/apps/appCom/wish/web2014/diarystory2017/event.asp'); return false;" class="btnMore"><span>More</span></a>
	<div class="listCardV16">
		<ul>
		<% FOR i = 0 to odibest.FResultCount -1 %>
			<li>
				<a href="" onclick="goEventLink('<%=odibest.FItemList(i).fevt_code %>'); return false;">
					<div class="thumbnail"><img src="<%=odibest.FItemList(i).fevt_mo_listbanner %>" alt="<%=odibest.FItemList(i).FEvt_name %>" /></div>
					<div class="desc">
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
						<p>
							<strong><%=db2html(tmpevtname) %></strong>
							<span><%=db2html(odibest.FItemList(i).FEvt_subname) %></span>
						</p>
						<% if tmpevtnamesale <> "" then %>
							<div class="label">
								<%' for dev msg : 할인율 표기 %>
								<b class="red"><span><i><%=db2html(tmpevtnamesale)%></i></span></b>
							</div>
						<% end if %>
					</div>
				</a>
			</li>
		<% next %>
		</ul>
	</div>
<% end if %>
<% set odibest = nothing %>