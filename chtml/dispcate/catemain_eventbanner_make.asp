<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<%
	Dim vQuery, vCateCode, vBody, vTotalCount, i, vEitemimg
	vCateCode = Request.Form("catecode")
	
	If Request.Form("gb") <> "proc" Then
		Response.Write "<script>alert('잘못된 접근임!');window.close();</script>"
		dbget.close()
		Response.End
	End IF
	
	If vCateCode = "" Then
		Response.Write "<script>alert('잘못된 접근임!');window.close();</script>"
		dbget.close()
		Response.End
	End IF
	
	If isNumeric(vCateCode) = False Then
		Response.Write "<script>alert('잘못된 접근임!');window.close();</script>"
		dbget.close()
		Response.End
	End IF
	'----------------------------------------------------------------------------------------------------------------------------------------
	vQuery = "SELECT TOP 3 b.evt_code, e.evt_name, e.evt_subcopyK, e.evt_startdate, convert(varchar(10),e.evt_enddate,102) as evt_enddate, "
	vQuery = vQuery & " 	case when isNull(d.etc_itemimg,'') = '' then (select icon1image from [db_item].[dbo].[tbl_item] where itemid = d.etc_itemid) else d.etc_itemimg end as etc_itemimg, "
	vQuery = vQuery & " 	case when d.evt_LinkType = 'I' then d.evt_bannerlink else '/event/eventmain.asp?eventid=' + convert(varchar,b.evt_code) end as evt_link, "
	vQuery = vQuery & "		d.issale, d.isgift, d.iscoupon, d.isOnlyTen, d.isoneplusone, d.isfreedelivery, d.isbookingsell, d.iscomment, d.etc_itemid "
	vQuery = vQuery & " 	FROM [db_sitemaster].[dbo].tbl_category_main_eventBanner as b "
	vQuery = vQuery & "	INNER Join [db_event].dbo.tbl_event e on b.evt_code = e.evt_code "
	vQuery = vQuery & "	INNER Join [db_event].dbo.tbl_event_display d on b.evt_code = d.evt_code "
	vQuery = vQuery & " WHERE b.disp1 = '" & vCateCode & "' AND b.isusing = 'Y' "
	vQuery = vQuery & " ORDER BY b.viewidx asc, b.idx desc"
	rsget.Open vQuery,dbget,1
	vTotalCount = rsget.RecordCount
	
	If CStr(vTotalCount) <> "3" Then
		rsget.close
		Response.Write "<script>alert('이벤트베너 에 올릴 상품은 3개가 되어야합니다.');</script>"
		dbget.close()
		Response.End
	End If
	
	IF Not rsget.Eof Then
		vBody = ""
		
		i = 1
		Do Until rsget.Eof
		
		vEitemimg = rsget("etc_itemimg")
		If Left(vEitemimg,1) = "S" Then
			vEitemimg = "http://webimage.10x10.co.kr/image/icon1/" & GetImageSubFolderByItemid(rsget("etc_itemid")) & "/" & vEitemimg & ""
		End IF
		
		vBody = vBody & "							<div class=""swiper-slide swiper-slide0"&i&""">" & vbCrLf
		vBody = vBody & "								<div class=""swiper-slide-content"">" & vbCrLf
		vBody = vBody & "									<a href=""" & rsget("evt_link") & """>" & vbCrLf
		vBody = vBody & "										<div class=""thumbNail""><img src=""" & vEitemimg & """ alt=""" & Replace(db2html(rsget("evt_name")),chr(34),"") & """ /></div>" & vbCrLf
		vBody = vBody & "										<span class=""tag"">"
		
		If rsget("isOnlyTen") Then
			vBody = vBody & "<img src=""http://fiximage.10x10.co.kr/web2013/shopping/tag_only.gif"" alt=""ONLY"" height=""14"" /> "
		End IF
		If rsget("issale") Then
			vBody = vBody & "<img src=""http://fiximage.10x10.co.kr/web2013/shopping/tag_sale.gif"" alt=""SALE"" height=""14"" /> "
		End IF
		If rsget("iscoupon") Then
			vBody = vBody & "<img src=""http://fiximage.10x10.co.kr/web2013/shopping/tag_coupon.gif"" alt=""쿠폰"" height=""14"" /> "
		End IF
		If rsget("isoneplusone") Then
			vBody = vBody & "<img src=""http://fiximage.10x10.co.kr/web2013/shopping/tag_oneplus.gif"" alt=""1+1"" height=""14"" /> "
		End IF
		If rsget("isgift") Then
			vBody = vBody & "<img src=""http://fiximage.10x10.co.kr/web2013/shopping/tag_gift.gif"" alt=""GIFT"" height=""14"" /> "
		End IF
		If datediff("d",rsget("evt_startdate"),date)<=3 Then
			vBody = vBody & "<img src=""http://fiximage.10x10.co.kr/web2013/shopping/tag_new.gif"" alt=""NEW"" height=""14"" /> "
		End IF
		If rsget("iscomment") Then
			vBody = vBody & "<img src=""http://fiximage.10x10.co.kr/web2013/shopping/tag_involve.gif"" alt=""참여"" height=""14"" /> "
		End IF
		
		vBody = vBody & "</span>" & vbCrLf
		vBody = vBody & "										<strong class=""name"">" & chrbyte(db2html(rsget("evt_name")),28,"Y") & "</strong>" & vbCrLf
		vBody = vBody & "										<span class=""copy"">" & chrbyte(Replace(db2html(rsget("evt_subcopyK")),vbCrLf,""),30,"Y") & "</span>" & vbCrLf
		vBody = vBody & "									</a>" & vbCrLf
		vBody = vBody & "								</div>" & vbCrLf
		vBody = vBody & "							</div>" & vbCrLf

		i = i + 1
		rsget.MoveNext
		Loop
		
	    if (vBody<>"") then
	    	Dim tFile, fso
'			Scripting.FileSystemObject 는 utf-8 지원 안함!!
'	        Set fso = Server.CreateObject("Scripting.FileSystemObject")
'	        fso.Open
'	        Set tFile = fso.CreateTextFile(server.mappath("/chtml/dispcate/main/")+ "\"&"catemain_eventbanner_"&vCateCode&".html")
'		    tFile.Write vBody
'		    tFile.Close
'		    Set tFile = Nothing
'	        Set fso = Nothing
	        
			Set fso = Server.CreateObject("ADODB.Stream")
			fso.Open
			fso.Type = 2
			fso.Charset = "utf-8"
			fso.WriteText (vBody)
			fso.SaveToFile server.mappath("/chtml/dispcate/main/")+ "\"&"catemain_eventbanner_"&vCateCode&".html", 2
			Set fso = nothing
	    end if
	End If
	rsget.close()
%>


<script>alert("Mobile Version OK!!");</script>
<form name="refreshFrm" method="post" action="http://<%=CHKIIF(application("Svr_Info")="Dev","testm","m1")%>.10x10.co.kr/chtml/dispcate/catemain_eventbanner_2014make.asp">
<input type="hidden" name="gb" value="proc">
<input type="hidden" name="catecode" value="<%=vCateCode%>">
</form>
<script>
	refreshFrm.submit();
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->