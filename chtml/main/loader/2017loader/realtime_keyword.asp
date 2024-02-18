<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<%
response.charset = "utf-8"
Session.Codepage = 65001
'#######################################################
' Discription : today _ 실시간 급상승 검색어
' History : 2017-04-24 이종화 생성
'#######################################################

Dim gaParam : gaParam = "&gaparam=today_searchkeyword_" '//GA 체크 변수
dim chkMyKeyword : chkMyKeyword=True '나의 검색어
	dim arrMyKwd, mykeywordloop
	dim retUrl
	retUrl = request.ServerVariables("HTTP_REFERER")

	'//검색어
	DIM oPpkDoc, arrPpk
	Dim arrRtp , arrRTg 
	SET oPpkDoc = New SearchItemCls
		oPpkDoc.FPageSize = 15
		oPpkDoc.getRealtimePopularKeyWords arrRtp,arrRTg		'순위정보 포함
	SET oPpkDoc = NOTHING 


on Error Resume Next
If isArray(arrRtp)  THEN
%>
<section class="keyword-raking">
	<h2 class="headline headline-speech"><span lang="ko">급상승</span> <small>인기 검색어</small></h2>
	<ul>
	<%
		dim vArwhtml , t_keyword 
		Dim ii : ii = 0
		If Ubound(arrRtp)>0 then
			For mykeywordloop=0 To UBOUND(arrRtp)
				If arrRtp(mykeywordloop) <> t_keyword Then
					If ii > 9 Then Exit For 
					if trim(arrRtp(mykeywordloop))<>"" Then

					'등락표시
					if cStr(arrRTg(mykeywordloop))="new" then
						vArwhtml = "<span class=""icon icon-new"">NEW</span>"
					elseif arrRTg(mykeywordloop)="0" or arrRTg(mykeywordloop)="" then
						vArwhtml = ""
					elseif arrRTg(mykeywordloop)>0 then
						vArwhtml = "<span class=""icon icon-up"">상승</span>"
					else
						vArwhtml = ""
					end if
	%>
		<li>
			<% If isapp = "1" Then %>
			<a href="" onclick="fnAPPpopupSearch('<%=arrRtp(mykeywordloop) %>');return false;"><span class="no"><%=ii+1%></span> <span class="keyword"><%=arrRtp(mykeywordloop) %></span> <%=vArwhtml%></a>
			<% Else %>
                <a href="/search/search_result2020.asp?keyword=<%=Server.URLEncode(arrRtp(mykeywordloop)) %>&burl=<%=Server.URLEncode(retUrl)%><%=gaParam%><%=Server.URLEncode(arrRtp(mykeywordloop)) %>"><span class="no"><%=ii+1%></span> <span class="keyword"><%=arrRtp(mykeywordloop) %></span> <%=vArwhtml%></a>
			<% End If %>
		</li>
<%				End If
				ii = ii + 1
				end If
			t_keyword = arrRtp(mykeywordloop)
			Next
		End If
	%>
	</ul>
	<% If isapp = "1" Then %>
	<div class="btn-group"><a href="" onclick="fnAPPpopupBrowserURL('실시간 인기 검색어','<%=wwwUrl%>/apps/appCom/wish/web2014/todaykeywordlist/index.asp?gaparam=keywordmore','right','','sc');return false;" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 상품 보러가기</a></div>
	<% Else %>
	<div class="btn-group"><a href="/todaykeywordlist/?gaparam=keywordmore" class="btn-plus color-blue"><span class="icon icon-plus icon-plus-blue"></span> 상품 보러가기</a></div>
	<% End If %>
</section>
<%
End If 
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->