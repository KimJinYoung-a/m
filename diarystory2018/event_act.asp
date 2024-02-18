<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (M)다이어리스토리2018 이벤트페이지 ajax 페이지
' History : 2017-10-12 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2018/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2018/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
dim odibest, i, selOp , scType, CurrPage, PageSize
	selOp		= requestCheckVar(Request("sop"),1) '정렬
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	CurrPage 	= requestCheckVar(request("cpg"),9)
	
	IF CurrPage = "" then CurrPage = 1
	If selOp = "" then selOp = "0"

	PageSize = 10

	set odibest = new cdiary_list
		odibest.FPageSize = PageSize
		odibest.FCurrPage = CurrPage
		odibest.FselOp	 	= selOp			'이벤트정렬
		odibest.FSCType 	= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
		odibest.FEScope = 2
		odibest.FEvttype = "1"
'		odibest.FEvttype = "19,26"
		odibest.Fisweb	 	= "0"
		odibest.Fismobile	= "1"
		odibest.Fisapp	 	= "1"
		odibest.fnGetdievent
%>
	<% If odibest.FResultCount > 0 Then %>
	<ul>
		<% FOR i = 0 to odibest.FResultCount -1 %>
			<li>
				<a href="" onclick="goEventLink('<%=odibest.FItemList(i).fevt_code %>'); return false;">
					<div class="thumbnail"><img src="<%=odibest.FItemList(i).fevt_mo_listbanner %>" alt=""></div>
					<p class="desc">
						<%
						Dim tmpevtname, tmpevtnamesale
						if ubound(Split(odibest.FItemList(i).FEvt_name,"|"))> 0 Then
							tmpevtname = cStr(Split(odibest.FItemList(i).FEvt_name,"|")(0))
							tmpevtnamesale = cStr(Split(odibest.FItemList(i).FEvt_name,"|")(1))
						else
							tmpevtname = odibest.FItemList(i).FEvt_name
							tmpevtnamesale	= ""
						end if
							
						%>

						<b class="headline">
							<span class="ellipsis <% if tmpevtnamesale = "" then %>full<% end if %>"><%=db2html(tmpevtname) %></span> 
							<% if tmpevtnamesale <> "" then %>
								<b class="discount color-red"><%=db2html(tmpevtnamesale)%></b>
							<% end if %>
						</b>
						
						<% if odibest.FItemList(i).FEvt_subname <> "" then %>
							<span class="subcopy">
							<%
								dim vicon
								If odibest.FItemList(i).fiscomment Then vIcon = " <em class=""color-blue"">코멘트</em>" End IF
								If odibest.FItemList(i).fisOnlyTen Then vIcon = " <em class=""color-blue"">단독</em>" End IF
								If odibest.FItemList(i).fisoneplusone Then vIcon = " <em class=""color-blue"">1+1</em>" End IF
								If odibest.FItemList(i).fisgift Then vIcon = " <em class=""color-blue"">기프트</em>" End IF
								If odibest.FItemList(i).fiscoupon Then vIcon = " <em class=""color-green"">쿠폰</em>" End IF
								If odibest.FItemList(i).fisfreedelivery Then vIcon = " <em class=""color-blue"">무료배송</em>" End IF
							%>
								<span class="label label-color">
									<%= vIcon %>
								</span>
								<%=db2html(odibest.FItemList(i).FEvt_subname) %>
							</span>
						<% end if %>
					</p>
				</a>
			</li>
		<% next %>
	</ul>
	<% end if %>

<% set odibest = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->