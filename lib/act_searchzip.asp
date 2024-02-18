<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
response.charset = "utf-8"
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbAppWishopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim strTarget, strQuery, stype
	strTarget	= requestCheckVar(Request("target"),32)
	strQuery	= requestCheckVar(Request("query"),16)
	stype		= requestCheckVar(Request("stype"),4)
	if stype="" then stype="addr"

	Dim strSql

	Dim strAddress
	Dim strAddress1
	Dim strAddress2

	dim useraddr01, useraddr02

	if stype="road" then
		strSql = "SELECT top 1000 ADDR_ZIP1, ADDR_ZIP2, ADDR_SI,ADDR_GU,ADDR_DONG,ADDR_ROAD,ADDR_BLDNO1,ADDR_BLDNO2,ADDR_ETC,ADDR_Fulltext " & VbCRLF
		strSql = strSql & " FROM [db_zipcode].[dbo].ROAD010 " & VbCRLF
		''strSql = strSql & " WHERE ADDR_ROAD like '" & strQuery & "%' " & VbCRLF
		strSql = strSql & " WHERE (contains(ADDR_ROAD,'""" & strQuery & "*""') or contains(ADDR_ETC,'""" & strQuery & "*""')) " & VbCRLF   '' fullText 변경 2014/12/08
		strSql = strSql & " and ADDR_sortNo<>'999' " & VbCRLF
		strSql = strSql & " order by addr_zip1, addr_Gu, addr_Road, Addr_BldNo1 "
	else
		strSql = "SELECT top 1000 ADDR_ZIP1, ADDR_ZIP2, ADDR_SI,ADDR_GU,ADDR_DONG,ADDR_ETC,ADDR_Fulltext " & VbCRLF
		strSql = strSql & " FROM [db_zipcode].dbo.ADDR080TL " & VbCRLF
		''strSql = strSql & " WHERE ADDR_Fulltext like '%" & strQuery & "%'" & VbCRLF
		strSql = strSql & " WHERE (contains(ADDR_DONG,'""" & strQuery & "*""') or contains(ADDR_ETC,'""" & strQuery & "*""'))" & VbCRLF  '' fullText 변경 2014/12/08
		strSql = strSql & " and ADDR_sortNo<>'999' " & VbCRLF
		strSql = strSql & " order by addr_zip1, addr_gu, addr_dong, addr_etc, addr_etc1 "
	end if

    if (strQuery<>"") then
        rsAppWishget.Open strSQL,dbAppWishget,1

		if Not(rsAppWishget.EOF or rsAppWishget.BOF) then 
			do Until rsAppWishget.EOF
								
			if stype="road" then
				'도로명주소
				strAddress = trim(rsAppWishget("ADDR_Fulltext")) & " " & trim( rsAppWishget("ADDR_BLDNO1"))
				if Not(rsAppWishget("ADDR_BLDNO2")="" or isNull(rsAppWishget("ADDR_BLDNO2"))) then
					strAddress = strAddress & " ~ " & trim(rsAppWishget("ADDR_BLDNO2"))
				end if

				useraddr01 = trim(rsAppWishget("ADDR_SI")) & " " & trim( rsAppWishget("ADDR_GU"))
				'' 동추가 (택배사 주소정제 프로그램에서 동/면이 있어야 인식이됨) 2016/07/07
				'' useraddr02 = trim( rsAppWishget("ADDR_ROAD"))
				useraddr02 = trim( rsAppWishget("ADDR_DONG")) & " " & trim( rsAppWishget("ADDR_ROAD"))
				if Not(rsAppWishget("ADDR_ETC")="" or isNull(rsAppWishget("ADDR_ETC"))) then
					'다량 배송처가 있는 곳은 단일 건물
					useraddr02 = useraddr02 & " " & trim(rsAppWishget("ADDR_BLDNO1")) & " " & trim(rsAppWishget("ADDR_ETC"))
				end if
				useraddr02 = Replace(useraddr02,"'","\'")
			else
				'지번주소
				strAddress = trim(rsAppWishget("ADDR_Fulltext"))

				useraddr01 = trim(rsAppWishget("ADDR_SI")) & " " & trim( rsAppWishget("ADDR_GU"))
				useraddr02 = trim( rsAppWishget("ADDR_DONG")) & " " & trim( rsAppWishget("ADDR_ETC"))
				useraddr02 = Replace(useraddr02,"'","\'")
			end if
%>
	<li><p class="addr" onclick="DetailPost(this,'<%=rsAppWishget("ADDR_ZIP1")%>','<%=rsAppWishget("ADDR_ZIP2")%>','<%=useraddr01%>', '<%=useraddr02%>');"><span><%=rsAppWishget("ADDR_zip1")%>-<%=rsAppWishget("ADDR_zip2")%></span><%=strAddress%></p></li>
<%
			  rsAppWishget.MoveNext
			loop
		else
%>
	<li align="center" style="padding:20px 0; text-align:center;">검색 결과가 없습니다.</li>
<%
		end if

		rsAppWishget.close
%>
<%	else %>
	<li align="center" style="padding:20px 0; text-align:center;">지역명을 입력해 주세요.</li>
<%
	end if
%>
<!-- #include virtual="/lib/db/dbAppWishclose.asp" -->