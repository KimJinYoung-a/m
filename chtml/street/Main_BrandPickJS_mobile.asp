<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<% 
Dim i , imagecount , idx ,savePath ,FileName ,refip
idx = Request("idx")
imagecount = Ubound(Split(idx,",")) + 1
savePath = server.mappath("/chtml/street/js/main/") + "\"
FileName = "brand_MainBranPick_mobile.js"
refip = request.ServerVariables("HTTP_REFERER")

Dim sqlStr, vImageCount, vTotalCount
vImageCount = 4
	
If cint(vImageCount) <> cint(imagecount) Then
    response.write "<script language=javascript>"
    response.write     "alert('적용에 필요한 이미지 수가 일치 하지 않습니다.\n\n(※ " & vImageCount & "건 필요.)');"    
    response.write     "self.close();"    
    response.write "</script>"
	dbget.close()	:	response.End
End If

Dim fnGetList

	sqlStr = ""
	sqlStr = sqlStr & " SELECT TOP 4 B.imagepath, B.linkpath, C.socname "
	sqlStr = sqlStr & " ,H.designis,c.newflg, c.hitflg, c.onlyflg , B.makerid "
	sqlStr = sqlStr & " from db_brand.dbo.tbl_2013brand_image as B "
	sqlStr = sqlStr & " JOIN db_user.dbo.tbl_user_c as C on B.makerid = C.userid "
	sqlStr = sqlStr & " JOIN db_brand.dbo.tbl_street_Hello as H on C.userid = H.makerid "
	sqlStr = sqlStr & " where B.idx in (" & idx & ") "
	sqlStr = sqlStr & " and B.gubun = '2' "
	sqlStr = sqlStr & " ORDER BY B.image_order ASC "
    rsget.Open SqlStr, dbget, 1
    vTotalCount = rsget.RecordCount
	fnGetList =	rsget.getRows()

    If CInt(vImageCount) >= CInt(vTotalCount) Then
		dim fso, tFile, BufStr, VarName, DoubleQuat, omd,ix
		VarName = "brand_MainBrandPick"
		DoubleQuat = Chr(34)
			BufStr = ""
			BufStr = "var " + VarName + ";" + VbCrlf
    		BufStr = BufStr + VarName + " = " + DoubleQuat + DoubleQuat + ";" + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "<section class='brandStreetV15a'>" + DoubleQuat + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "<div class='swiper-container swiper1'>" + DoubleQuat + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "<div class='swiper-wrapper'>" + DoubleQuat + VbCrlf
		For i = 1 to vTotalCount
    		BufStr = BufStr + VarName + "+=" + DoubleQuat + "<div class='swiper-slide'>" + DoubleQuat + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "	<a href='/brand/brand_detail2020.asp?brandid="& fnGetList(7,i-1) &"'><div class='brandInfoV15a'>" + DoubleQuat + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "		<strong>"& db2Html(fnGetList(2,i-1)) &"</strong>" + DoubleQuat + VbCrlf
		If fnGetList(3, i-1) <> "" Then
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "		<p>디자인은, "&chrbyte(db2Html(fnGetList(3,i-1)),48,"Y")&"</p>" + DoubleQuat + VbCrlf
		End If
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "	</div>" + DoubleQuat + VbCrlf
			if instr(fnGetList(0,i-1),"http://")>0 then
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "	<img src='" & db2Html(fnGetList(0,i-1)) &"' alt='브랜드Pick"&i&"' />" + DoubleQuat + VbCrlf
			Else
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "	<img src='" & staticImgUrl & "/brandstreet/main/" & db2Html(fnGetList(0,i-1)) &"' alt='브랜드Pick"&i&"' />" + DoubleQuat + VbCrlf
			end if
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "</a></div>" + DoubleQuat + VbCrlf
		Next
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "</div>" + DoubleQuat + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "</div>" + DoubleQuat + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "<div class='bnrPagingV15a'></div>" + DoubleQuat + VbCrlf
			BufStr = BufStr + VarName + "+=" + DoubleQuat + "</section>" + DoubleQuat + VbCrlf
			BufStr = BufStr + "document.write(" + VarName + ");" + VbCrlf

		Set fso = Server.CreateObject("ADODB.Stream")
			fso.Open
			fso.Type = 2
			fso.Charset = "UTF-8"
			fso.WriteText (BufStr)
			fso.SaveToFile savePath & FileName, 2
		Set fso = nothing
	    rsget.Close
	Else
		Response.Write "<script>alert('Hello에 입력하신 브랜드가 있는 지 확인하세요');window.close();</script>"
		rsget.Close
		dbget.close()
		Response.End
	End If
%>
<script type="text/javascript">
alert('Mobile OK');
location.href="http://m1.10x10.co.kr/chtml/street/Main_BrandPickJS_app.asp?idx=<%=idx%>&imagecount=<%=imagecount%>";
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->