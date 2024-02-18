<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'#######################################################
'	History	: 2014.09.17 한용민 생성
'	Description : CS Center
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/thanks10x10cls.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
dim oip, myoip, searchFlag, page, evt_type, listisusing, i

evt_type = "T"		'고마워텐텐 지정

	page = getNumeric(requestCheckVar(request("page"),5))
	searchFlag = requestCheckVar(request("sf"),2)
	if page = "" then page = 1
		
set oip = new cthanks10x10_list
	oip.FPageSize = 5
	oip.FCurrPage = page
	oip.FsearchFlag = searchFlag
	oip.fthanks10x10_list()
%>
					<% If oip.FResultCount > 0 Then %>
							<% For i = 0 To oip.FResultCount -1 %>
							<li>
								<% If oip.FItemList(i).fgubun="0" Then %>
								<div class="thx-tag thx-tag-black"><div>Best<br />Friend</div></div>
								<% ElseIf oip.FItemList(i).fgubun="1" Then %>
								<div class="thx-tag thx-tag-pink"><div>I Love<br />you</div></div>
								<% ElseIf oip.FItemList(i).fgubun="2" Then %>
								<div class="thx-tag thx-tag-blue"><div>Very<br />Good</div></div>
								<% ElseIf oip.FItemList(i).fgubun="3" Then %>
								<div class="thx-tag thx-tag-orange"><div>Always<br />Smile</div></div>
								<% ElseIf oip.FItemList(i).fgubun="4" Then %>
								<div class="thx-tag thx-tag-green"><div>Thank<br />you</div></div>
								<% end if %>
								<div class="thx-content-box">
									<div class="thx-cont"><%= nl2br(oip.FItemList(i).fcontents) %></div>
									<p class="cont-info"><%= printUserId(oip.FItemList(i).fuserid,2,"*") %> <span><%= FormatDate(oip.FItemList(i).freg_date,"0000.00.00") %></span></p>
									<% if oip.FItemList(i).fcomment <> "" then %>
									<div class="thx-answer">
										<%= nl2br(oip.FItemList(i).fcomment) %>
									</div>
									<% end if %>
								</div>
							</li>
							<% Next %>
					<% end if %>
<%
Set oip = Nothing
%>	
<!-- #include virtual="/lib/db/dbclose.asp" -->