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
	vQuery = "SELECT TOP 3 b.evt_code, e.evt_name, e.evt_subcopyK, e.evt_subname, e.evt_startdate, convert(varchar(10),e.evt_enddate,102) as evt_enddate, "
	vQuery = vQuery & " 	d.evt_mo_listbanner , "
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
		vBody = vBody & "<div class=""inner10 eventListWrap"">" & vbCrLf
		vBody = vBody & "	<h2 class=""tit02 tMar30""><span>ENJOY EVENT</span></h2>" & vbCrLf
		vBody = vBody & "	<span class=""moreBtn""><a href=""#"" onclick=""fnAPPselectGNBMenu('event', 'http://m.10x10.co.kr/apps/appCom/wish/web2014/shoppingtoday/shoppingchance_allevent.asp?scT=&disp="&vCateCode&"');return false;"">이벤트 리스트로 이동</a></span>" & vbCrLf
		vBody = vBody & "	<ul class=""evtList"">" & vbCrLf

		i = 1
		Do Until rsget.Eof
		
		vBody = vBody & "		<li onclick=""fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014" & rsget("evt_link") & "');"">" & vbCrLf
		vBody = vBody & "			<div class=""pic""><img src="""& rsget("evt_mo_listbanner") &""" alt="""" /></div>" & vbCrLf
		vBody = vBody & "			<dl>" & vbCrLf
		vBody = vBody & "				<dt>" & vbCrLf
		vBody = vBody & "					" & db2html(rsget("evt_name")) & "" & vbCrLf

		If rsget("issale") Then
			vBody = vBody & "<span class=""cRd1"">30%~</span>" & vbCrLf
		End IF
		If rsget("iscoupon") Then
			vBody = vBody & "<span class=""cGr1"">30%~</span>" & vbCrLf
		End IF
		If rsget("isoneplusone") Then
			vBody = vBody & "<span class=""cGr2"">1+1</span>" & vbCrLf
		End IF
		If rsget("isgift") Then
			vBody = vBody & "<span class=""cGr2"">GIFT</span>" & vbCrLf
		End IF
		If rsget("iscomment") Then
			vBody = vBody & "<span class=""cBl2"">참여</span>" & vbCrLf
		End If

		vBody = vBody & "				</dt>" & vbCrLf
		vBody = vBody & "				<dd>"& db2html(rsget("evt_subname")) &"</dd>" & vbCrLf
		vBody = vBody & "			</dl>" & vbCrLf
		vBody = vBody & "		</li>" & vbCrLf

		i = i + 1
		rsget.MoveNext
		Loop
		
		vBody = vBody & "	</ul>" & vbCrLf
		vBody = vBody & "</div>" & vbCrLf
		
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
			fso.SaveToFile server.mappath("/chtml/dispcate/appmain/")+ "\"&"catemain_eventbanner_"&vCateCode&".html", 2
			Set fso = nothing
	    end if
	End If
	rsget.close()
%>
<script>alert("2014 App Version OK!!");</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->