<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
dim currentdate
	currentdate = date()
	'currentdate = "2015-03-09"
	
	'response.write currentdate
%>
<%
'#######################################################################
'	작업자 전달 사항
'
'	* 어드민에 소스 넣을때.asp 뒤에 ?eventid=코드 꼭 넣으세요!!
'
'#######################################################################
	Dim vEventID, appevturl , vGnbflag
	Dim gnbUse : gnbUse = False '//app GNB영역 구분
	vEventID = requestCheckVar(Request("eventid"),9)
	vGnbflag = requestCheckVar(Request("gnbflag"),1)

	If vGnbflag = "1" Then 
		gnbUse = true
	End If 

	If isapp = "1" Then
		If gnbUse Then 
			appevturl = "/apps/appcom/wish/web2014/event/gnbeventmain.asp?"
		Else
			appevturl = "/apps/appcom/wish/web2014/event/eventmain.asp?"
		End If 
	Else
		appevturl = "/event/eventmain.asp?"
	End If
%>
<style type="text/css">
.navigator {overflow:hidden; height:4.7rem; padding:0 17%; color:#ba301d; background:#f96653;}
.navigator li {position:relative; float:left; width:33.33333%; height:4.7rem; text-align:center; font-size:1.2rem; line-height:4.7rem; font-weight:600;}
.navigator li:before {content:''; position:absolute; left:-0.17rem; top:50%; width:0.34rem; height:0.34rem; margin-top:-0.2rem;background:#e34530; border-radius:50%;}
.navigator li:first-child:before {display:none;}
.navigator li.open a,
.navigator li.current a {color:#fff;}
.navigator li.current:after {content:''; position:absolute; left:0; bottom:0; width:100%; height:0.3rem; background:#fff;}
.navigator li a {display:block; height:4.7rem;}
</style>
<ul id="navigator" class="navigator">
	<% if currentdate < "2017-09-21" then %>
	<li>09.21</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="80684"," current","")%>">
		<a href="<%=appevturl%>eventid=80684<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">09.21</a>
	</li>
	<% End If %>

	<% if currentdate < "2017-09-28" then %>
	<li>09.28</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="80890"," current","")%>">
		<a href="<%=appevturl%>eventid=80890<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">09.28</a>
	</li>
	<% End If %>

	<% if currentdate < "2017-10-12" then %>
	<li>10.12</li>
	<% Else %>
	<li class="open <%=CHKIIF(vEventID="81126"," current","")%>">
		<a href="<%=appevturl%>eventid=81126<%=chkiif(gnbUse,"&gnbflag=1","")%>" target="_top">10.12</a>
	</li>
	<% End If %>
</ul>