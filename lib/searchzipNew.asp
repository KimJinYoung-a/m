<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%

' -------------------------------------
' 회원의 주소를 찾는 Popup Window 화면
' -------------------------------------
Dim strTarget
Dim strQuery
Dim strMode, stype

strTarget	= requestCheckVar(Request("target"),32)
strQuery	= requestCheckVar(Request("query"),32)
strMode     = requestCheckVar(Request("strMode"),32)
stype		= requestCheckVar(Request("stype"),4)
if stype="" then stype="addr"


Dim strSql
Dim nRowCount

Dim strAddress

Dim strAddress1
Dim strAddress2

dim useraddr01, useraddr02
dim FRecultCount

	if stype="road" then
		strSql = "SELECT top 1000 ADDR_ZIP1, ADDR_ZIP2, ADDR_SI,ADDR_GU,ADDR_DONG,ADDR_ROAD,ADDR_BLDNO1,ADDR_BLDNO2,ADDR_ETC,ADDR_Fulltext " &_
				" FROM [db_zipcode].[dbo].ROAD010 " &_
				" WHERE ADDR_ROAD like '" & strQuery & "%' and ADDR_sortNo<>'999' " &_
				" order by addr_zip1, addr_Gu, addr_Road, Addr_BldNo1 "
	else
		strSql = "SELECT top 1000 ADDR_ZIP1, ADDR_ZIP2, ADDR_SI,ADDR_GU,ADDR_DONG,ADDR_ETC,ADDR_Fulltext " &_
				" FROM [db_zipcode].dbo.ADDR080TL " &_
				" WHERE ADDR_Fulltext like '%" & strQuery & "%' and ADDR_sortNo<>'999' " &_
				" order by addr_zip1, addr_gu, addr_dong, addr_etc, addr_etc1 "
	end if

    if (strQuery<>"") then
        rsget.Open strSQL,dbget,1
        FRecultCount = rsget.RecordCount
        
    end if
    
    
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/mytenten2013.css">
<title>10x10: 우편번호 찾기</title>
<style type="text/css">
<!--
#code_result {height:120px;overflow: auto;}
-->
</style>
<script type="text/javascript" src="/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="/lib/js/nicescroll/jquery.nicescroll.min.js"></script>
	<SCRIPT>
	$(document).ready(function() {
		$("#code_result").niceScroll({cursoropacitymin:.25});
	});
		
	function CopyZip(t,post1,post2,add,dong)
	{
		var frm = eval("parent." + t);
		// copy
		<%
			Select Case strMode
				Case "MyAddress"
		%>
			frm.zip1.value			= post1;
			frm.zip2.value			= post2;
			frm.reqZipaddr.value	= add;
			frm.reqAddress.value	= dong;
		<%		Case "buyer" %>
			frm.buyZip1.value		= post1;
			frm.buyZip2.value		= post2;
			frm.buyAddr1.value		= add;
			frm.buyAddr2.value		= dong;
		<%		Case "userinfo" %>
			frm.txZip1.value		= post1;
			frm.txZip2.value		= post2;
			frm.txAddr1.value		= add;
			frm.txAddr2.value		= dong;
			parent.document.getElementById("boxscroll3").style.display = "none";
		<%		Case Else %>
			frm.txZip1.value		= post1;
			frm.txZip2.value		= post2;
			frm.txAddr1.value		= add;
			frm.txAddr2.value		= dong;
		<%	End Select %>

		// focus
		parent.focus();
		
		<% If strMode = "buyer" Then %>
		$("#boxscroll3", parent.document).css("height","0px");
		$("#boxscroll3", parent.document).css("display","none");
		<% Else %>
		$("#boxscroll4", parent.document).css("height","0px");
		$("#boxscroll4", parent.document).css("display","none");
		<% End If %>
	}
	function SubmitForm(frm)
	{
			if (frm.query.value.length < 2) { alert("동 이름을 두글자 이상 입력하세요."); return; }
			frm.submit();
	}

	function chgTab(dv) {
		location.href = "/lib/searchzipNew.asp?target=<%=strTarget%>&strMode=<%=strMode%>&stype="+dv+"";
		return;
		
		if(dv=="a") {
			$("#kTab1").attr("src","http://fiximage.10x10.co.kr/m/mytenten/tab_house_on.png");
			$("#kTab2").attr("src","http://fiximage.10x10.co.kr/m/mytenten/tab_street_off.png");
			$("#imgStt").attr("src","http://fiximage.10x10.co.kr/m/mytenten/my_post_txt.png");
			$("#dRowEx").html("(예: 대치동,곡성읍,오곡면)");
			$("#stype").val("addr");
		} else {
			$("#kTab1").attr("src","http://fiximage.10x10.co.kr/m/mytenten/tab_house_off.png");
			$("#kTab2").attr("src","http://fiximage.10x10.co.kr/m/mytenten/tab_street_on.png");
			$("#imgStt").attr("src","http://fiximage.10x10.co.kr/m/mytenten/my_post_txt2.png");
			$("#dRowEx").html("(예: 동숭1길, 세종대로)");
			$("#stype").val("road");
		}
	}

	function closediv()
	{
		parent.document.getElementById("boxscroll3").style.display = "none";
	}
	</SCRIPT>
</head>
<body>
<form action="/lib/searchzipNew.asp" method="get" name="gil" onsubmit="SubmitForm(document.gil); return false;">
<input type="hidden" name="target"	value="<%=strTarget%>">
<input type="hidden" name="strMode"	value="<%=strMode%>">
<input type="hidden" name="stype"	id="stype" value="<%=stype%>" >
<div class="popup" id="contentArea" style="height:290px;background-color:#f9f9f9;">
	<div class="popTit nav">
		<h1>우편번호 찾기</h1>
		<p class="close"><a href="javascript:closediv();">닫기</a></p>
	</div>

	<ul class="tabItem tMar20">
		<li class="<%=chkIIF(stype="addr","on","")%> w50"><a href="javascript:chgTab('addr');">지번검색<span class="elmBg"></span></a></li>
		<li class="<%=chkIIF(stype="road","on","")%> w50"><a href="javascript:chgTab('road');">도로명검색<span class="elmBg"></span></a></li>
	</ul>

	<% If stype="addr" Then %>
	<p class="innerH15W10 ct ftMidSm lh12">찾고자 하는 주소의 동, 읍, 면 이름을 입력하세요.<br /><span class="fsSmall c999">(예: 대치동,곡성읍,오곡면)</span></p>
	<% Else %>
	<p class="innerH15W10 ct ftMidSm lh12">찾고자 하는 주소의 도로명을 입력하세요.<br /><span class="fsSmall c999">(예: 동숭1길, 세종대로)</span></p>
	<% End If %>
	<div class="innerH15W10 bgGry2 ct">
		<input type="text" name="query" style="width:160px; height:20px;" title="주소를 입력하세요." />
		<span class="btn btn3 redB w70B"><a href="javascript:SubmitForm(document.gil);">검색</a></span>
	</div>
	<% if (FRecultCount>0) then %>
	<ul class="zipCode ftMidSm2 c999" id="code_result" style="font-size:12px; color:#777;padding:20px 0; text-align:center;">
		<% if (not rsget.eof) then 
		do while (not rsget.EOF and nRowCount < rsget.PageSize)

			if stype="road" then
				'도로명주소
				strAddress = trim(rsget("ADDR_Fulltext")) & " " & trim( rsget("ADDR_BLDNO1"))
				if Not(rsget("ADDR_BLDNO2")="" or isNull(rsget("ADDR_BLDNO2"))) then
					strAddress = strAddress & " ~ " & trim(rsget("ADDR_BLDNO2"))
				end if

				useraddr01 = trim(rsget("ADDR_SI")) & " " & trim( rsget("ADDR_GU"))
				useraddr02 = trim( rsget("ADDR_ROAD"))
				if Not(rsget("ADDR_ETC")="" or isNull(rsget("ADDR_ETC"))) then
					'다량 배송처가 있는 곳은 단일 건물
					useraddr02 = useraddr02 & " " & trim(rsget("ADDR_BLDNO1")) & " " & trim(rsget("ADDR_ETC"))
				end if
				useraddr02 = Replace(useraddr02,"'","\'")
			else
				'지번주소
				strAddress = trim(rsget("ADDR_Fulltext"))

				useraddr01 = trim(rsget("ADDR_SI")) & " " & trim( rsget("ADDR_GU"))
				useraddr02 = trim( rsget("ADDR_DONG")) & " " & trim( rsget("ADDR_ETC"))
				useraddr02 = Replace(useraddr02,"'","\'")
			end if
		%>
		<li onclick="CopyZip('<%= strTarget %>','<%=rsget("ADDR_ZIP1")%>','<%=rsget("ADDR_ZIP2")%>','<% = useraddr01 %>', '<% = useraddr02 %>')" ><span><%=rsget("ADDR_zip1")%>-<%=rsget("ADDR_zip2")%></span> <%=strAddress%></li>
		<%
			  rsget.MoveNext
			loop
			end if
			rsget.close
		%>
	</ul>
	<% else %>
	<ul class="zipCode ftMidSm2 c999" id="code_result" style="font-size:12px; color:#777;padding:20px 0; text-align:center;">
			<li align="center"><% if (strQuery="") then %>지역명을 입력해 주세요.<% else %>검색 결과가 없습니다.<% end if %></li>
	</ul>
	<% end if %>
</div>
</form>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->