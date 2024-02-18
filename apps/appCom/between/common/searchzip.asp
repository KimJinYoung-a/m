<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% 
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
'###########################################################
' Description :  비트윈 도로명 , 지번 검색 변경
' History : 2014.04.23 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appcom/between/lib/commFunc.asp" -->
<%
	Dim stype , strQuery , strMode , strTarget
	stype = requestCheckVar(Request("stype"),4)
	strQuery = requestCheckVar(Request("query"),32)
	strTarget	= requestCheckVar(Request("target"),32)
	strMode     = requestCheckVar(Request("strMode"),32)

	Dim strSql
	Dim nRowCount

	Dim strAddress
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
<script>
	function CopyZip(codeid) {
		var frm = eval("document.<%=strTarget%>");
		var post1	= $("#"+codeid).attr("addrzip1");
		var post2	= $("#"+codeid).attr("addrzip2");
		var add		= $("#"+codeid).attr("useraddr1");
		var dong	= $("#"+codeid).attr("useraddr2");

		// copy
		frm.txZip1.value		= post1;
		frm.txZip2.value		= post2;
		frm.txAddr1.value		= add;
		frm.txAddr2.value		= dong;

		// focus
		frm.txAddr2.focus();
		
		//모달창 닫기 - common.js
		jsClosePopup();

	}
</script>
<% if (FRecultCount>0) then %>
	<ul>
	<% if (not rsget.eof) then 
		Dim ii : ii = 1
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
				useraddr02 = trim(Replace(useraddr02,"'","\'"))
			else
				'지번주소
				strAddress = trim(rsget("ADDR_Fulltext"))

				useraddr01 = trim(rsget("ADDR_SI")) & " " & trim( rsget("ADDR_GU"))
				useraddr02 = trim( rsget("ADDR_DONG")) & " " & trim( rsget("ADDR_ETC"))
				useraddr02 = trim(Replace(useraddr02,"'","\'"))
			end if
	%>
	<li>
		<a href="javascript:CopyZip('shzip<%=ii%>')"><span><%=rsget("ADDR_zip1")%>-<%=rsget("ADDR_zip2")%></span> <span><%=strAddress%></span></a>
		<div style="display:none;" id="shzip<%=ii%>" addrzip1="<%=rsget("ADDR_ZIP1")%>" addrzip2="<%=rsget("ADDR_ZIP2")%>" useraddr1="<% = useraddr01 %>" useraddr2="<% = useraddr02 %>"></div>
	</li>
	<%
			ii = ii + 1
			rsget.MoveNext
		loop
		end if
		rsget.close
	%>
	</ul>
<% else %>
	<% if (strQuery="") then %>
	<p class="noResult">지역명 혹은 도로명을 입력 해주세요</p>
	<% else %>
	<p class="noResult">검색 결과가 없습니다.</p>
	<% end if %>
<% End if%>
<!-- #include virtual="/lib/db/dbclose.asp" -->