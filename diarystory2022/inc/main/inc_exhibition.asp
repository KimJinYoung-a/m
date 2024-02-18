<%
public function couponDisp(couponVal)
	if couponVal = "" or isnull(couponVal) then exit function
	couponDisp = chkIIF(couponVal > 100, couponVal, couponVal & "%")
end function
	dim mktevent, hoteventlist

	if RBeventCodeArr="" then RBeventCodeArr=0
	RBeventCodeArr = left(RBeventCodeArr,len(RBeventCodeArr)-1)

	set mktevent = new cdiary_list
		mktevent.fnGetDiaryMKTEvent

	set hoteventlist = new cdiary_list
		hoteventlist.FCurrPage  = 1
		hoteventlist.FPageSize	= 3
		hoteventlist.FselOp		= 0 '0 신규순 1 종료 임박 2 인기순
		hoteventlist.FEvttype   = "1"
		hoteventlist.Fisweb	 	= "0"
		hoteventlist.Fismobile	= "1"
		hoteventlist.Fisapp	 	= "1"
		hoteventlist.FExcCode = RBeventCodeArr
		hoteventlist.fnGetdievent
%>
<script>
function fnGoToDiaryEventList(){
	var link = "/diarystory2022/exhibition.asp"
	// console.log(link)
	<% if isapp > 0 then %>
	fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다이어리 기획전', [BtnType.SEARCH, BtnType.CART], 'http://m.10x10.co.kr/apps/appCom/wish/web2014' + link)
	<% else %>
	window.document.location.href = link
	<% end if %>
}
</script>
	<section class="sect_evt">

		<h2><a href="javascript:fnGoToDiaryEventList();">주목해야 할<br/>기획전<i class="i_arw_r2"></i></a></h2>
        <% if mktevent.FOneItem.FEvt_code<>"" then %>
        <!-- mkt -->
		<article class="dr_evt_item dr_evt_mkt">
			<figure class="dr_evt_img"><img src="<%=mktevent.FOneItem.FEvt_bannerimg%>" alt=""></figure>
			<div class="dr_evt_info">
				<div class="dr_evt_badge">
					<span class="badge_type1">쇼핑꿀팁</span>
				</div>
				<p class="dr_evt_name ellipsis2"><%=mktevent.FOneItem.FEvt_name%></p>
			</div>
            <% if isapp = 1 then %>
                <a href="javascript:TnGotoAPPDiaryEvent('<%=mktevent.FOneItem.FEvt_code%>');" class="dr_evt_link" onclick="fnAmplitudeEventAction('click_diarystory_event','event_code','<%=mktevent.FOneItem.fevt_code %>');">
            <% else %>
                <a href="javascript:TnGotoDiaryEvent(<%=mktevent.FOneItem.FEvt_code%>);" class="dr_evt_link" onclick="fnAmplitudeEventAction('click_diarystory_event','event_code','<%=mktevent.FOneItem.fevt_code %>');">
            <% end if %>
			<span class="blind">이벤트바로가기</span></a>
		</article>
        <% end if %>
		<% If hoteventlist.FResultCount > 0 Then  %>
        <!-- md -->
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
				<p class="dr_evt_name ellipsis2"><%=split(hoteventlist.FItemList(i).FEvt_name,"|")(0)%></p>
			</div>
            <% if isapp = 1 then %>
                <a href="javascript:TnGotoAPPDiaryEvent('<%=hoteventlist.FItemList(i).fevt_code %>');" class="dr_evt_link" onclick="fnAmplitudeEventAction('click_diarystory_event','event_code','<%=hoteventlist.FItemList(i).fevt_code %>');">
            <% else %>
                <a href="javascript:TnGotoDiaryEvent(<%=hoteventlist.FItemList(i).fevt_code %>);" class="dr_evt_link" onclick="fnAmplitudeEventAction('click_diarystory_event','event_code','<%=hoteventlist.FItemList(i).fevt_code %>');">
            <% end if %>
			<span class="blind">이벤트바로가기</span></a>
			<%=fngetDiary2022EvtItemHtml(hoteventlist.FItemList(i).FEvt_code)%>
		</article>
        <% next %>
        <% end if %>
		<button class="btn_type2 btn_gry btn_block" onclick="fnGoToDiaryEventList();">주목해야 할 기획전 전체보기</button>
	</section>
<%
set mktevent = nothing
set hoteventlist = nothing
%>