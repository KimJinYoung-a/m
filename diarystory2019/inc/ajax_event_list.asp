<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : 다이어리 2019 이벤트 ajax 리스트
' History : 2018-08-31 이종화 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2019/lib/worker_only_view.asp" -->
<!-- #include virtual="/diarystory2019/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
dim hoteventlist, i, selOp , scType, CurrPage, PageSize
	CurrPage 	= requestCheckVar(request("cpg"),9)
	
	IF CurrPage = "" then CurrPage = 1
	If selOp = "" then selOp = "0"

	PageSize = 5

	set hoteventlist = new cdiary_list
        hoteventlist.FCurrPage  = CurrPage
		hoteventlist.FPageSize  = PageSize
		hoteventlist.FselOp		= 0 '0 신규순 1 종료 임박 2 인기순
        hoteventlist.FEvttype   = "1"
        hoteventlist.Fisweb	 	= "0"
        hoteventlist.Fismobile	= "1"
        hoteventlist.Fisapp	 	= "1"
        hoteventlist.fnGetdievent
%>
<% 
If hoteventlist.FResultCount > 0 Then 
    dim vLink, vName
    FOR i = 0 to hoteventlist.FResultCount-1
        if ubound(Split(hoteventlist.FItemList(i).FEvt_name,"|"))> 0 Then
            If hoteventlist.FItemList(i).fissale Or (hoteventlist.FItemList(i).fissale And hoteventlist.FItemList(i).fiscoupon) then
                vName = "<span>"& cStr(Split(hoteventlist.FItemList(i).FEvt_name,"|")(0))&"</span><em class='color-red'>"&cStr(Split(hoteventlist.FItemList(i).FEvt_name,"|")(1)) &"</em>"
            ElseIf hoteventlist.FItemList(i).fiscoupon Then
                vName = "<span>"& cStr(Split(hoteventlist.FItemList(i).FEvt_name,"|")(0))&"</span><em class='color-green'>"&cStr(Split(hoteventlist.FItemList(i).FEvt_name,"|")(1)) &"</em>"
            end if 
        else
            vName = "<span>"& hoteventlist.FItemList(i).FEvt_name &"</span>"
        end if
%>
<li>
    <a href="" onclick="<%=chkiif(isapp,"fnAPPpopupEvent('"& hoteventlist.FItemList(i).fevt_code &"');","goEventLink('"& hoteventlist.FItemList(i).fevt_code &"');")%>return false;" >
        <div class="thumbnail"><img src="<%=hoteventlist.FItemList(i).fevt_mo_listbanner %>" alt="" /><% If hoteventlist.FItemList(i).fisgift Then %><em>GIFT</em><% End If %></div>
        <div class="desc">
            <p class="tit">
                <%=chrbyte(vName,80,"Y")%>
            </p>
            <p class="subcopy"><%=db2html(hoteventlist.FItemList(i).FEvt_subname) %></p>
        </div>
    </a>
</li>
<%		
    Next 
End if 
%>
<% set hoteventlist = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->