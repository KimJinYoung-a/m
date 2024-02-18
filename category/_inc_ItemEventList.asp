<%
	dim tmpSQL, arrEvt, chkEvtDiv(2)
	dim strLink, strLinkName, chkDl, chkCnt, vEvtListBody, strEvtRc, strLinkNameSale, strLinkNameTag, strLinkNameImg
	chkDl = 0: chkCnt = 0
	vEvtListBody = ""

	tmpSQL = "Execute [db_item].[dbo].sp_Ten_EvtByItem_Temp @vItemid=" & itemid & ", @device='M'"
'DB Ver.
'		rsget.CursorLocation = adUseClient
'		rsget.CursorType=adOpenStatic
'		rsget.Locktype=adLockReadOnly
'		rsget.Open tmpSQL, dbget
'		If Not rsget.EOF Then
'			arrEvt 	= rsget.GetRows
'		End if
'		rsget.close
'db_Cache Ver.
		dim rsMem : set rsMem = getDBCacheSQL(dbget,rsget,"EVT",tmpSQL,60*10)
		If Not rsMem.EOF Then
			arrEvt 	= rsMem.GetRows
		End if
		rsMem.close

	If isArray(arrEvt) and not(isnull(arrEvt)) Then

		FOR i=0 to ubound(arrEvt,2)
			strLink = "": strLinkName="": strLinkNameSale="": strLinkNameTag="": strLinkNameImg=""
			strEvtRc = "rc=item_event_" & (chkCnt+1)		'// Log Param 추가(2017.03.20 허진원)
			''Response.write arrEvt(34,i) & "/" & arrEvt(21,i)
			'상품배너형 이벤트 변경 사항 적용 정태훈(2017.12.13)
			If arrEvt(34,i)="80" Then'모바일 유형이 엠디 등록형일때
				If arrEvt(21,i)="5" Then'모바일 엠디 등록형 테마가 상품배너형일때
					arrEvt(0,i)="13"
				End If
			End If

			SELECT CASE cStr(arrEvt(0,i))
				'' arrEvt(16,i) : 정사각 이미지(어드민-대표상품정보 및 배너)
				'' arrEvt(17,i) : 서브카피KO(어드민-WWW서브카피KO) PC에서 사용하는거
				'' arrEvt(18,i) : 서브카피(어드민-모바일 서브카피)
				case "1", "29", "31" '//쇼핑 찬스, 헤이썸띵
					IF arrEvt(6,i)="I" and arrEvt(7,i)<>"" Then
						strLink = "<a href="""& arrEvt(7,i) & chkIIF(instr(arrEvt(7,i),"?")>0,"&","?") & strEvtRc & """>"
					Else
						strLink = "<a href=""/event/eventmain.asp?eventid=" & arrEvt(4,i) & "&"&strEvtRc & """>"
					End If

					if ubound(Split(arrEvt(2,i),"|"))> 0 Then
						strLinkName	= "<p class='pName'>"&cStr(Split(arrEvt(2,i),"|")(0)) &"</p>"
						strLinkNameSale =  "<span class='cRd1V16a'>"&cStr(Split(arrEvt(2,i),"|")(1))&"</span>"
					Else
						strLinkName = "<p class=""pName"">"&db2html(arrEvt(2,i))&"</p>"
					end If

					'서브카피 추가(2017-04-12 유태욱)
					If arrEvt(18,i) <> "" Then
						strLinkName	= strLinkName & "<p class='pDesc'>"&db2html(arrEvt(18,i))&"</p>"
					End If

					If arrEvt(13,i)="True" Then
						strLinkNameTag	= strLinkNameTag&" <i class='cRd1V16a'>SALE</i>"
					End If
				
					If arrEvt(14,i)="True" Then
						strLinkNameTag	= strLinkNameTag&" <em class='cGr1V16a'>쿠폰</em>"
					End If

					If arrEvt(15,i)="True" Then
						strLinkNameTag	= strLinkNameTag&" <em class='cTqi1V16a'>GIFT</em>"
					End If

					'정사각 대표이미지 추가(2017-04-12 유태욱)
					If arrEvt(16,i) <> "" Then
						strLinkNameImg	= strLinkNameImg&" <img src='"&arrEvt(16,i)&"' alt='' />"
					End If
					
				Case "13"	'//상품 이벤트
					If arrEvt(4,i) <> "" Then
						Dim evt_tagkind , evt_tagopt1 , etc_opt1 , etc_opt2 , stdate , eddate
						stdate = arrEvt(11,i)
						eddate = arrEvt(12,i)
						
						tmpSQL = "select evt_tagkind , evt_tagopt1 , etc_opt1 , etc_opt2 from db_event.dbo.tbl_event_mobile_addetc where evt_code = '"& arrEvt(4,i) &"' "
						rsget.CursorLocation = adUseClient
						rsget.CursorType=adOpenStatic
						rsget.Locktype=adLockReadOnly
						rsget.Open tmpSQL, dbget
						If Not rsget.EOF Then
							evt_tagkind = rsget("evt_tagkind")
							evt_tagopt1 = rsget("evt_tagopt1")
							etc_opt1 = rsget("etc_opt1")
							etc_opt2 = rsget("etc_opt2")
						End if
						rsget.close
					End If 
			End SELECT
			
			If strLink <> "" Then
				if strLinkNameImg <> "" then
					vEvtListBody = vEvtListBody & "	<li>"
					vEvtListBody = vEvtListBody & 		strLink
					vEvtListBody = vEvtListBody & "			<div class=""pPhoto"">"
					vEvtListBody = vEvtListBody & 				strLinkNameImg
					vEvtListBody = vEvtListBody & "			</div>"
					vEvtListBody = vEvtListBody & "			<div class=""pdtCont"">"
					vEvtListBody = vEvtListBody & "				<div class=""inner"">"
					vEvtListBody = vEvtListBody & 					strLinkName
					vEvtListBody = vEvtListBody & "					<div class=""pTag"">"
					vEvtListBody = vEvtListBody & 						strLinkNameSale
					vEvtListBody = vEvtListBody & 						strLinkNameTag
					vEvtListBody = vEvtListBody & "					</div>"
					vEvtListBody = vEvtListBody & "				</div>"
					vEvtListBody = vEvtListBody & "			</div>"
					vEvtListBody = vEvtListBody & "		</a>"
					vEvtListBody = vEvtListBody & "	</li>" & vbCrLf

'기존꺼				vEvtListBody = vEvtListBody & "	<li>" & strLink & strLinkName & "</a></li>" & vbCrLf
					chkCnt = chkCnt+1
				end if
			End If

			If arrEvt(4,i)="85159" Then '웨딩이벤트일경우 안내 배너 노출
				Response.Write "<script>"
				Response.Write " $(""#weddingbanner"").show(); "
				Response.Write "</script>"
			End If

		Next

		If vEvtListBody <> "" Then
%>
			<div class="itemAddWrapV16a evtIsuV17a" id="evtIsuV17aRolling">
				<div class="bxLGy2V16a">
					<h3>관련 기획전</h3>
				</div>
				<div class="bxWt1V16a">
					<div class="pdtListV15a">
						<ul>
							<%= vEvtListBody %>
						</ul>
					</div>
				</div>
			</div>
<%
		End If
	End If

	'//상품이벤트 값이 있을 경우
	Dim styleclass
	IF evt_tagkind <>"" Then

		If evt_tagkind = "1" Then styleclass = "gift"
		If evt_tagkind = "2" Then styleclass = "coupon"
		If evt_tagkind = "3" Then styleclass = "booking"
		If evt_tagkind = "4" Then styleclass = "shipping"
		If evt_tagkind = "5" Then styleclass = "oneplus"
		If evt_tagkind = "6" Then styleclass = "onetoone"
		If evt_tagkind = "7" Then styleclass = "discount"

		vEvtListBody = "<div class=""bnr item-bnr item-bnr-"&styleclass&""">"
		If evt_tagkind = "1" Then vEvtListBody = vEvtListBody & "<strong class=""label"">Gift<br /> Event</strong>" End if
		If evt_tagkind = "2" Then vEvtListBody = vEvtListBody & "<strong class=""label"">"& FormatNumber(evt_tagopt1,0) &"원<br /> Coupon</strong>" End if
		If evt_tagkind = "3" Then vEvtListBody = vEvtListBody & "<strong class=""label"">예약배송</strong>" End if
		If evt_tagkind = "4" Then vEvtListBody = vEvtListBody & "<strong class=""label"">무료배송</strong>" End if
		If evt_tagkind = "5" Then vEvtListBody = vEvtListBody & "<strong class=""label"">1:1<br /> Event</strong>" End if
		If evt_tagkind = "6" Then vEvtListBody = vEvtListBody & "<strong class=""label"">1+1<br /> Event</strong>" End if
		If evt_tagkind = "7" Then vEvtListBody = vEvtListBody & "<strong class=""label"">"& evt_tagopt1 &"%<br /> SALE</strong>" End if
		vEvtListBody = vEvtListBody & "<div class=""desc"">"
		vEvtListBody = vEvtListBody & "<p>"& etc_opt1 &"</p>"
		vEvtListBody = vEvtListBody & "<div class=""date"">"& formatdate(stdate,"0000.00.00") &" ~ "& formatdate(eddate,"00.00") &" <span>"& etc_opt2 &"</span></div>"
		vEvtListBody = vEvtListBody & "</div>"
		vEvtListBody = vEvtListBody & "</div>"

		Response.Write "<script>"
		Response.Write " $(""#itemevent"").html('"& vEvtListBody &"');"
		Response.Write " $(""#itemevent"").show(); "
		Response.Write "</script>"
	end If
%>