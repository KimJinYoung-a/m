<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
'####################################################
' Description : 정기세일 메인페이지
' History : 2020-03-27 이종화 생성
'####################################################
dim gnbflag : gnbflag = RequestCheckVar(request("gnbflag"),1)
dim aType : aType = RequestCheckVar(request("atype"),2)
dim vDisp : vDisp = RequestCheckVar(request("disp"),3)
dim dateGubun : dateGubun = RequestCheckVar(request("dategubun"),1)	'기간별 검색 w:주간, m:월간

If gnbflag = "1" Then '//gnb 숨김 여부
	gnbflag = true 
Else 
	gnbflag = False
	strHeadTitleName = "2020 정기세일 메인페이지"
End if

IF dateGubun = "" THEN dateGubun = "w"

Response.Cookies("sale2020")("atype") = aType
Response.Cookies("sale2020")("disp") = vDisp
Response.Cookies("sale2020")("dategubun") = dateGubun
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<body class="default-font body-<%=chkiif(gnbflag,"main","sub")%>">
    <% server.Execute("/event/sale2020/index.asp") %>
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->