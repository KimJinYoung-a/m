<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'##################################################################	
' appurl ,카테고리 ,브랜드 랜딩 페이지
' 2014-09-27 이종화 생성
'##################################################################
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%
	Dim param1 , param2 

		param1 = request("param1")
		param2 = request("param2")

	Function URLDecode(sConvert)
		Dim aSplit
		Dim sOutput
		Dim I
		If IsNull(sConvert) Then
		   URLDecode = ""
		   Exit Function
		End If

		If sConvert <> "" then

			' convert all pluses to spaces
			sOutput = REPLACE(sConvert, "+", " ")

			' next convert %hexdigits to the character
			aSplit = Split(sOutput, "%")

			If IsArray(aSplit) Then
			  sOutput = aSplit(0)
			  For I = 0 to UBound(aSplit) - 1
				sOutput = sOutput & _
				  Chr("&H" & Left(aSplit(i + 1), 2)) &_
				  Right(aSplit(i + 1), Len(aSplit(i + 1)) - 2)
			  Next
			End If
		End If 

		URLDecode = sOutput
	End Function
%>
</head>
<body>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script>
	$(document).ready(function() {
		<% if param1 = "1" then %>
			fnAPPchangPopCaption('상품정보');
			setTimeout(function(){ location.replace('<%=URLDecode(param2)%>') }, 100);
		<% end if %>
		
		<% if param1 = "2" then %>
			fnAPPchangPopCaption('이벤트');
			setTimeout(function(){ location.replace('<%=URLDecode(param2)%>') }, 100);
		<% end if %>

		<% if param1 = "3" then %>
			fnAPPchangPopCaption('브랜드 상세');
			var url = "<%=param2%>";
			url = url.replace(/\makerid=/g, "");
			//페이지를 닫으면서
			fnAPPclosePopup();
			//브랜드페이지를 띄움 0.05 눈속임 -_-;
			setTimeout(function(){ 
				fnAPPpopupBrand(url);
			}, 50);
		<% end if %>

		<% if param1 = "4" then %>
			fnAPPchangPopCaption('카테고리');
			var url = "<%=param2%>";
			//페이지를 닫으면서
			fnAPPclosePopup();
			//카테고리 페이지를 띄움 0.05 눈속임 -_-;
			setTimeout(function(){ 
				fnAPPpopupCategory(url,"new");
			}, 50);
		<% end if %>

		<% if param1 = "8" then %>
			fnAPPchangPopCaption('이벤트');
			setTimeout(function(){ location.replace('<%=URLDecode(param2)%>')}, 100);
		<% end if %>

		<% if param1 = "10" then %>
			fnAPPchangPopCaption('BEST');
			//페이지를 닫으면서
			//fnAPPclosePopup();
			//베스트 페이지를 띄움 0.05 눈속임 -_-;
			setTimeout(function(){ 
				fnAPPpopupBrowserURL('BEST','<%=wwwUrl%>/<%=URLDecode(param2)%>&gnbflag=1','right','','sc')
			}, 50);
		<% end if %>

		<% if param1 = "11" then %>
			fnAPPchangPopCaption('장바구니');
			fnAPPclosePopup();			
			setTimeout(function(){ 
				fnAPPpopupBaguni();
			}, 50);
		<% end if %>
	});
</script>
</body>
</html>