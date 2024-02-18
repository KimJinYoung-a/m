<%
	dim tmpSQL, arrEvt, chkEvtDiv(2)
	dim strLink, strLinkName, chkDl, chkCnt, vEvtListBody
	chkDl = 0: chkCnt = 0
	vEvtListBody = ""

	tmpSQL = "Execute [db_item].[dbo].sp_Ten_EvtByItem @vItemid = " & itemid

'		rsget.CursorLocation = adUseClient
'		rsget.CursorType=adOpenStatic
'		rsget.Locktype=adLockReadOnly
'		rsget.Open tmpSQL, dbget
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVT",tmpSQL,60*30)
		If Not rsMem.EOF Then
			arrEvt 	= rsMem.GetRows
		End if
		rsMem.close

	If isArray(arrEvt) and not(isnull(arrEvt)) Then

		FOR i=0 to ubound(arrEvt,2)
			strLink = "": strLinkName=""

			SELECT CASE cStr(arrEvt(0,i))
				case "19" '/¼îÇÎ Âù½º
					IF arrEvt(6,i)="I" and arrEvt(7,i)<>"" Then
						strLink = "<a href="""& arrEvt(7,i) &""">"
					Else
						strLink = "<a href="""" onclick=""TnGotoEventMain('" & arrEvt(4,i) & "');return false;"">"
					End If
					strLinkName = db2html(arrEvt(2,i))
			End SELECT
			
			If strLink <> "" Then
				vEvtListBody = vEvtListBody & "	<li>" & strLink & strLinkName & "</a></li>" & vbCrLf
			End If
		Next
		
		If vEvtListBody <> "" Then
%>
<div class="evtnIsu box1">
	<h2><span>EVENT &amp; ISSUE</span></h2>
	<ul class="list01">
		<%= vEvtListBody %>
	</ul>
</div>
<%
		End If
	End If
%>