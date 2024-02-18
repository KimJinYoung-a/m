<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/play/playCls.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim cPl, i, vArr, vPage, vType, vIsMine, vSort, vResultCount, vTotalCount, vTotalPage, chgtype
	vPage = RequestCheckVar(request("page"),3)
	vType = RequestCheckVar(request("type"),1)
	vIsMine = RequestCheckVar(request("ismine"),1)
	vSort = RequestCheckVar(request("sort"),2)
	If vPage = "" Then vPage = "1" End If
	If vSort = "" Then vSort = "ne" End If

	'// 정렬방법 통일로 인한 코드 변환
	Select Case vSort
		Case "ne": chgtype = "1"		'신상순
		Case "be": chgtype = "2"		'인기순
		Case Else: chgtype = "1"		'기본값(인기순)
	End Select

	If vIsMine = "o" AND IsUserLoginOK() = False Then
		Response.Redirect "/apps/appCom/wish/web2014/play/"
		dbget.close()
		Response.End
	End If
	
	
	SET cPl = New CPlay
	cPl.FPageSize		= 5
	cPl.FCurrPage		= vPage
	cPl.FRectType		= vType
	cPl.FRectSort		= chgtype
	
	If vIsMine = "o" Then
		cPl.FRectIsMine		= "_Mine"
		cPl.FRectUserID		= GetLoginUserID()
	End If
	vArr = cPl.GetPlayList()
	
	vResultCount = cPl.FResultCount
	vTotalCount = cPl.FTotalCount
	vTotalPage = cPl.FTotalPage
%>

<%
If (cPl.FResultCount < 1) Then
Else
	For i = 0 To cPl.FResultCount-1
%>
	<li>
		<a href="" onClick="fnAPPpopupPlay_URL('<%=wwwUrl%>/apps/appCom/wish/web2014<%=fnPlayLinkMoWeb(cPl.FItemList(i).Ftype)%>?idx=<%=cPl.FItemList(i).Fidx%>&contentsidx=<%=cPl.FItemList(i).Fcontents_idx%>&type=<%=cPl.FItemList(i).Ftype%>'); return false;"><img src="<%=getThumbImgFromURL(cPl.FItemList(i).Flistimg,400,"","true","false")%>" alt="<%=Replace(cPl.FItemList(i).Ftitle,chr(34),"")%>" /></a>
		<div class="playCont">
			<span class="type"><a href="" onClick="jsChangeType('<%=cPl.FItemList(i).Ftype%>'); return false;"><%=cPl.FItemList(i).Ftypename%></a></span>
			<p class="tit"><strong><% If cPl.FItemList(i).Ftype = "1" Then %><%=cPl.FItemList(i).Fviewno%>&nbsp;<%=cPl.FItemList(i).Fviewnotxt%><% Else %><%=cPl.FItemList(i).Ftitle%><% End If %></strong></p>
			<% If cPl.FItemList(i).Fsubcopy <> "" Then %>
			<p class="subTit"><%=chrbyte(cPl.FItemList(i).Fsubcopy,"120","Y")%></p>
			<!--<a href="/apps/appCom/wish/web2014<%=fnPlayLinkMoWeb(cPl.FItemList(i).Ftype)%>?idx=<%=cPl.FItemList(i).Fidx%>&contentsidx=<%=cPl.FItemList(i).Fcontents_idx%>&type=<%=cPl.FItemList(i).Ftype%>" class="more">더보기</a></p>//-->
			<% End If %>
			<!--
			<p id="wish<%=i%>" class="circleBox wishView" onClick="alert('로그인을 하셔야 합니다.');"><span>찜하기</span></p>
			//-->
		</div>
	</li>
<%
	Next
End If
%>

<!-- #include virtual="/lib/db/dbclose.asp" -->