<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2021/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls_B.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<%
dim mktevent, hoteventlist, selOp, scType, CurrPage, i
scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
CurrPage 	= requestCheckVar(request("cpg"),9)

set hoteventlist = new cdiary_list
    hoteventlist.FCurrPage  = CurrPage
    hoteventlist.FPageSize	= 20
    hoteventlist.FselOp		= 0
    hoteventlist.FSCType 	= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
    hoteventlist.FEvttype   = "1"
    hoteventlist.Fisweb	 	= "0"
    hoteventlist.Fismobile	= "1"
    hoteventlist.Fisapp	 	= "1"
    hoteventlist.fnGetdievent
%>
<!-- md -->
<% If hoteventlist.FResultCount > 0 Then  %>
<% for i = 0 to hoteventlist.FResultCount-1 %>
<article class="dr_evt_item">
    <figure class="dr_evt_img"><img src="<%=hoteventlist.FItemList(i).fevt_mo_listbanner %>" alt=""></figure>
    <div class="dr_evt_info">
        <div class="dr_evt_badge">
            <% if hoteventlist.FItemList(i).fissale and hoteventlist.FItemList(i).FSalePer <> "" and hoteventlist.FItemList(i).FSalePer <> "0"  then %><span class="badge_type2"><%=hoteventlist.FItemList(i).FSalePer%>%</span><% end if %>
            <% If hoteventlist.FItemList(i).fisgift Then %><span class="badge_type1">사은품</span><% end if %>
            <% If hoteventlist.FItemList(i).FGiftCnt>0 Then %><span class="badge_type1"><%=formatnumber(hoteventlist.FItemList(i).FGiftCnt,0)%>개 남음</span><% end if %>
            <% If hoteventlist.FItemList(i).fisOnlyTen Then %><span class="badge_type1">단독</span><% end if %>
        </div>
        <p class="dr_evt_name"><%=split(hoteventlist.FItemList(i).FEvt_name,"|")(0)%></p>
    </div>
    <% if isapp = 1 then %>
        <a href="javascript:fnAPPpopupEvent('<%=hoteventlist.FItemList(i).fevt_code %>');" class="dr_evt_link">
    <% else %>
        <a href="/event/eventmain.asp?eventid=<%=hoteventlist.FItemList(i).fevt_code %>" class="dr_evt_link">
    <% end if %>
    <span class="blind">이벤트바로가기</span></a>
    <%=fngetDiaryEvtItemHtml(hoteventlist.FItemList(i).FEvt_code)%>
</article>
<% next %>
<% else '<!-- 결과 없을떄 -->%>
    <% if CurrPage="1" then %>
	<section class="nodata nodata_search">
		<p><b>아쉽게도 일치하는 내용이 없습니다</b></p>
		<p>품절 또는 종료된 경우에는 검색되지 않습니다</p>
	</section>
    <% end if %>
<% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->