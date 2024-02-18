<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : hey, something project 시리즈 매뉴
' History : 2015.09.08 한용민 생성
'####################################################
%>
<%
dim eCode1, eCode2, eCode3, eCode4, eCode5, eCode6, eCode7
IF application("Svr_Info") = "Dev" THEN
	eCode1   =  64880
	eCode2   =  64885
	eCode3   =  64893
	eCode4   =  64898
	eCode5   =  64910
	eCode6   =  64918
	eCode7   =  64933
Else
	eCode1   =  66049
	eCode2   =  66233
	eCode3   =  66242
	eCode4   =  66382
	eCode5   =  66637
	eCode6   =  66453
	eCode7   =  66855
End If

%>
<% '<!-- for dev msg : 오픈 전 <span>...</span> / 오픈 후 <a href="">...</a> / 선택된 탭은 클래스 on 붙여주세요 --> %>

<% If left(currenttime,10)>="2015-09-09" Then %>
	<% if cstr(eCode1)=cstr(eCode) then %>
		<li><a href="eventmain.asp?eventid=<%= eCode1 %>" class="on">01. Date.09.09</a></li>
	<% else %>
		<li><a href="eventmain.asp?eventid=<%= eCode1 %>">01. Date.09.09</a></li>
	<% end if %>
<% else %>
	<li><span>01. Date.09.09</span></li>
<% end if %>

<% If left(currenttime,10)>="2015-09-16" Then %>
	<% if cstr(eCode2)=cstr(eCode) then %>
		<li><a href="eventmain.asp?eventid=<%= eCode2 %>" class="on">02. Date.09.16</a></li>
	<% else %>
		<li><a href="eventmain.asp?eventid=<%= eCode2 %>">02. Date.09.16</a></li>
	<% end if %>
<% else %>
	<li><span>02. Date.09.16</span></li>
<% end if %>

<% If left(currenttime,10)>="2015-09-23" Then %>
	<% if cstr(eCode3)=cstr(eCode) then %>
		<li><a href="eventmain.asp?eventid=<%= eCode3 %>" class="on">03. Date.09.23</a></li>
	<% else %>
		<li><a href="eventmain.asp?eventid=<%= eCode3 %>">03. Date.09.23</a></li>
	<% end if %>
<% else %>
	<li><span>03. Date.09.23</span></li>
<% end if %>

<% If left(currenttime,10)>="2015-09-30" Then %>
	<% if cstr(eCode4)=cstr(eCode) then %>
		<li><a href="eventmain.asp?eventid=<%= eCode4 %>" class="on">04. Date.09.30</a></li>
	<% else %>
		<li><a href="eventmain.asp?eventid=<%= eCode4 %>">04. Date.09.30</a></li>
	<% end if %>
<% else %>
	<li><span>04. Date.09.30</span></li>
<% end if %>

<% If left(currenttime,10)>="2015-10-07" Then %>
	<% if cstr(eCode5)=cstr(eCode) then %>
		<li><a href="eventmain.asp?eventid=<%= eCode5 %>" class="on">05. Date.10.07</a></li>
	<% else %>
		<li><a href="eventmain.asp?eventid=<%= eCode5 %>">05. Date.10.07</a></li>
	<% end if %>
<% else %>
	<li><span>05. Date.10.07</span></li>
<% end if %>

<% If left(currenttime,10)>="2015-10-14" Then %>
	<% if cstr(eCode6)=cstr(eCode) then %>
		<li><a href="eventmain.asp?eventid=<%= eCode6 %>" class="on">06. Date.10.14</a></li>
	<% else %>
		<li><a href="eventmain.asp?eventid=<%= eCode6 %>">06. Date.10.14</a></li>
	<% end if %>
<% else %>
	<li><span>06. Date.10.14</span></li>
<% end if %>

<% If left(currenttime,10)>="2015-10-21" Then %>
	<% if cstr(eCode7)=cstr(eCode) then %>
		<li><a href="eventmain.asp?eventid=<%= eCode7 %>" class="on">07. Date.10.21</a></li>
	<% else %>
		<li><a href="eventmain.asp?eventid=<%= eCode7 %>">07. Date.10.21</a></li>
	<% end if %>
<% else %>
	<li><span>07. Date.10.21</span></li>
<% end if %>
