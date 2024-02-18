<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/culturestation/culture_stationcls.asp" -->
<%
	'// 이벤트 목록 접수

	dim oevent, moreevent, i, chkBig, bnrImg
	dim page, page2, etype, sortMtd, viewlist, mylist
	page = getNumeric(requestCheckVar(request("page"),5))
	page2 = getNumeric(requestCheckVar(request("page2"),5))
	etype = getNumeric(requestCheckVar(request("etype"),1))
	sortMtd = requestCheckVar(request("sort"),3)
	viewlist = requestCheckVar(request("viewlist"),1)
	mylist = requestCheckVar(request("mylist"),1)
If etype="" Then
Response.End
End If
	if page="" then page=1
	If page2="" Then page2=2
	'if etype="" then etype="0"
	if sortMtd="" then sortMtd="dl"
	If viewlist="" Then viewlist="L"

	set oevent = new cevent_list
	oevent.FCurrPage = 1
	oevent.FPageSize = 10*page '한페이지 16개 (추가 접수는 18개)
	oevent.frectevt_type = etype
	oevent.frectSrotMtd = sortMtd
	If mylist="Y" Then
	oevent.frectUserid = GetEncLoginUserID()
	End If
	oevent.fevent_list()

	set moreevent = new cevent_list
	moreevent.FCurrPage = 1
	moreevent.FPageSize = 10*page2 '한페이지 16개 (추가 접수는 18개)
	moreevent.frectevt_type = etype
	moreevent.frectSrotMtd = sortMtd
	If mylist="Y" Then
	moreevent.frectUserid = GetEncLoginUserID()
	End If
	moreevent.fevent_list_more()
%>
<% If oevent.FResultCount >= 4 Then %>
			<% if oevent.FResultCount>0 Then %>
			<% If viewlist="L" Then %>
			<div class="cult-list list">
			<% Else %>
			<div class="cult-list grid">
			<% End If %>
				<ul>
					<% for i=0 to oevent.FResultCount-1 %>
					<li>
						<a href="culturestation_event.asp?evt_code=<%=oevent.FItemList(i).fevt_code%>">
							<div class="inner">
								<div class="thumbnail">
									<img src="<%=oevent.FItemList(i).fimage_barner2%>" alt="" />
									<div class="bg" style="background-image:url(<%=oevent.FItemList(i).fimage_barner2%>);"></div>
									<% If oevent.FItemList(i).fenddate < now() Then %>
									<div class="endEvt">종료된<br />이벤트입니다.</div>
									<% End If %>
								</div>
								<div class="des">
									<% If oevent.FItemList(i).fevt_kind="3" Then %>
									<span class="label musical">
									<% ElseIf oevent.FItemList(i).fevt_kind="4" Then %>
									<span class="label book">
									<% Else %>
									<span class="label">
									<% End If %><%=oevent.FItemList(i).GetEvtKindName%></span>
									<p class="tit"><%=oevent.FItemList(i).fevt_name%></p>
									<p class="present"><%=oevent.FItemList(i).fevt_comment%></p>
									<p class="date"><%= formatDate(oevent.FItemList(i).fstartdate,"0000.00.00") & "~" & formatDate(oevent.FItemList(i).fenddate,"0000.00.00")%></p>
									<span class="numCmt"><span class="icon icon-cmt"><%=oevent.FItemList(i).fdcount%></span></span>
								</div>
							</div>
						</a>
					</li>
				<% If i=3 And oevent.FResultCount>=4 Then %>
				</ul>
				<% If not(IsUserLoginOK()) Then %>
				<div class="bnr-myhistory"><a href="javascript:parent.jsChklogin_mobile('','<%=Server.URLencode("/culturestation/")%>');">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
				<% else %>
				<div class="bnr-myhistory"><a href="/my10x10/myeventmaster.asp?pagegubun=j">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
				<% End IF %>
				<ul>
				<% End If %>
					<% Next %>
				<% if moreevent.FResultCount>0 Then %>
					<% for i=0 to moreevent.FResultCount-1 %>
					<li>
						<a href="culturestation_event.asp?evt_code=<%=moreevent.FItemList(i).fevt_code%>">
							<div class="inner">
								<div class="thumbnail">
									<img src="<%=moreevent.FItemList(i).fimage_barner2%>" alt="" />
									<div class="bg" style="background-image:url(<%=moreevent.FItemList(i).fimage_barner2%>);"></div>
									<% If moreevent.FItemList(i).fenddate < now() Then %>
									<div class="endEvt">종료된<br />이벤트입니다.</div>
									<% End If %>
								</div>
								<div class="des">
									<% If moreevent.FItemList(i).fevt_kind="3" Then %>
									<span class="label musical">
									<% ElseIf moreevent.FItemList(i).fevt_kind="4" Then %>
									<span class="label book">
									<% Else %>
									<span class="label">
									<% End If %><%=moreevent.FItemList(i).GetEvtKindName%></span>
									<p class="tit"><%=moreevent.FItemList(i).fevt_name%></p>
									<p class="present"><%=moreevent.FItemList(i).fevt_comment%></p>
									<p class="date"><%= formatDate(moreevent.FItemList(i).fstartdate,"0000.00.00") & "~" & formatDate(moreevent.FItemList(i).fenddate,"0000.00.00")%></p>
									<span class="numCmt"><span class="icon icon-cmt"><%=moreevent.FItemList(i).fdcount%></span></span>
								</div>
							</div>
						</a>
					</li>
					<% Next %>
				<% End If %>
				</ul>
			</div>
			<% End If %>
<% Else %>
			<% if oevent.FResultCount>0 Then %>
			<% If viewlist="L" Then %>
			<div class="cult-list list">
			<% Else %>
			<div class="cult-list grid">
			<% End If %>
				<ul>
					<% for i=0 to oevent.FResultCount-1 %>
					<li>
						<a href="culturestation_event.asp?evt_code=<%=oevent.FItemList(i).fevt_code%>">
							<div class="inner">
								<div class="thumbnail">
									<img src="<%=oevent.FItemList(i).fimage_barner2%>" alt="" />
									<div class="bg" style="background-image:url(<%=oevent.FItemList(i).fimage_barner2%>);"></div>
									<% If oevent.FItemList(i).fenddate < now() Then %>
									<div class="endEvt">종료된<br />이벤트입니다.</div>
									<% End If %>
								</div>
								<div class="des">
									<% If oevent.FItemList(i).fevt_kind="3" Then %>
									<span class="label musical">
									<% ElseIf oevent.FItemList(i).fevt_kind="4" Then %>
									<span class="label book">
									<% Else %>
									<span class="label">
									<% End If %><%=oevent.FItemList(i).GetEvtKindName%></span>
									<p class="tit"><%=oevent.FItemList(i).fevt_name%></p>
									<p class="present"><%=oevent.FItemList(i).fevt_comment%></p>
									<p class="date"><%= formatDate(oevent.FItemList(i).fstartdate,"0000.00.00") & "~" & formatDate(oevent.FItemList(i).fenddate,"0000.00.00")%></p>
									<span class="numCmt"><span class="icon icon-cmt"><%=oevent.FItemList(i).fdcount%></span></span>
								</div>
							</div>
						</a>
					</li>
					<% Next %>
				<% if moreevent.FResultCount>0 Then %>
					<% for i=0 to moreevent.FResultCount-1 %>
					<li>
						<a href="culturestation_event.asp?evt_code=<%=moreevent.FItemList(i).fevt_code%>">
							<div class="inner">
								<div class="thumbnail">
									<img src="<%=moreevent.FItemList(i).fimage_barner2%>" alt="" />
									<div class="bg" style="background-image:url(<%=moreevent.FItemList(i).fimage_barner2%>);"></div>
									<% If moreevent.FItemList(i).fenddate < now() Then %>
									<div class="endEvt">종료된<br />이벤트입니다.</div>
									<% End If %>
								</div>
								<div class="des">
									<% If moreevent.FItemList(i).fevt_kind="3" Then %>
									<span class="label musical">
									<% ElseIf moreevent.FItemList(i).fevt_kind="4" Then %>
									<span class="label book">
									<% Else %>
									<span class="label">
									<% End If %><%=moreevent.FItemList(i).GetEvtKindName%></span>
									<p class="tit"><%=moreevent.FItemList(i).fevt_name%></p>
									<p class="present"><%=moreevent.FItemList(i).fevt_comment%></p>
									<p class="date"><%= formatDate(moreevent.FItemList(i).fstartdate,"0000.00.00") & "~" & formatDate(moreevent.FItemList(i).fenddate,"0000.00.00")%></p>
									<span class="numCmt"><span class="icon icon-cmt"><%=moreevent.FItemList(i).fdcount%></span></span>
								</div>
							</div>
						</a>
					</li>
				<% If (i+1+oevent.FResultCount)=4 Then %>
				</ul>
				<% If not(IsUserLoginOK()) Then %>
				<div class="bnr-myhistory"><a href="javascript:parent.jsChklogin_mobile('','<%=Server.URLencode("/culturestation/")%>');">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
				<% else %>
				<div class="bnr-myhistory"><a href="/my10x10/myeventmaster.asp?pagegubun=j">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
				<% End IF %>
				<ul>
				<% End If %>
					<% Next %>
				<% End If %>
				</ul>
				<% If (oevent.FResultCount+moreevent.FResultCount)<4 Then %>
					<% If not(IsUserLoginOK()) Then %>
				<div class="bnr-myhistory"><a href="javascript:parent.jsChklogin_mobile('','<%=Server.URLencode("/culturestation/")%>');">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
					<% else %>
				<div class="bnr-myhistory"><a href="/my10x10/myeventmaster.asp?pagegubun=j">내가 응모한 컬쳐스테이션이 궁금하다면? 〉</a></div>
					<% End IF %>
				<% End If %>
			</div>
			<% End If %>
<% End If %>
			<input type="hidden" id="tcount" value="<%=oevent.FTotalCount %>">
			<input type="hidden" id="more" value="Y">
			<input type="hidden" id="page2" value="<%=page2+1%>">
<!-- #include virtual="/lib/db/dbclose.asp" -->