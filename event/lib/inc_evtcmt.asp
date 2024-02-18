<!-- 코멘트 타이틀 영역 -->
<div class="evtDescWrap">
<%
	Function cmtclass(v)
		Select Case v
		case "1"
			Response.write " cmtDesc"
		case "2"
			Response.write " testerDesc"
		case "3"
			Response.write " reviewDesc"
		case "4"
			Response.write " giftDesc"
		case "5"
			Response.write " reserveDesc"
		case Else  
			Response.write ""
		End select
	End function
%>
<% For intT = 0 To UBound(arrTextTitle,2) %>
	<div class="evtDesc <%=cmtclass(arrTextTitle(1,intT))%>">
		<h3>
			<% If arrTextTitle(1,intT) = 1 And blncomment Then %>COMMENT EVENT<% End If %>
			<% If arrTextTitle(1,intT) = 2 And blncomment Then %>TESTER EVENT<% End If %>
			<% If arrTextTitle(1,intT) = 3 And blnitemps Then %>REVIEW EVENT<% End If %>
			<% If arrTextTitle(1,intT) = 4 And blngift Then %>GIFT<% End If %>
			<% If arrTextTitle(1,intT) = 5 And blnbookingsell Then %>예약판매<% End If %>
		</h3>
		<% If arrTextTitle(2,intT) <> "" Then %><p class="box1"><%=nl2br(arrTextTitle(2,intT))%></p><% End If %>
		<% If arrTextTitle(1,intT) = 1 or arrTextTitle(1,intT) = 2 Or arrTextTitle(1,intT) = 3 Then %><% If arrTextTitle(3,intT) <> "" Then %><p class="txt"><%=nl2br(arrTextTitle(3,intT))%></p><% End If %><% End If %>
		<% IF ((arrTextTitle(1,intT) = 1 or arrTextTitle(1,intT) = 2) And blncomment) Or (arrTextTitle(1,intT) = 3 And blnitemps) Then %>
		<div class="date">
			<span><%=chkIIF(vDateView,"&nbsp;",Replace(esdate,"-",".") & " ~ " & Replace(eedate,"-","."))%></span><span>발표 : <%=formatdate(epdate,"0000.00.00")%></span>
		</div>
			<% If (arrTextTitle(1,intT) = 1 or arrTextTitle(1,intT) = 2) And blncomment Then '//코멘트 %>
			<p><span class="button btM2"><a href="#replyList">코멘트 쓰러 가기<em></em></a></span></p>
			<% End If %>
			<% If arrTextTitle(1,intT) = 3 And blnitemps Then '//상품후기%>
			<p><span class="button btM2"><a href="#replyPrdList">상품 후기 보러가기<em></em></a></span></p>
			<% End If %>
		<% End If %>
	</div>
<% Next %>
</div>
<!-- 코멘트 타이틀 영역 -->