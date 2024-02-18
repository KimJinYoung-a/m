<%
    'data
    dim SortMet, PageSize
    dim bestlist
    dim wishlist
    dim realtimelist
    dim hoteventlist
    dim gaParam : gaParam = "&gaparam=diarystory_"
    
    SortMet = "dbest"
    PageSize = 12
%>
<script>
$(function(){
    $(".elmore").css("display","none");
    
    var fndiarystory = {
        /*
        best : function(){
            return $(".best .elmore").css("display","");
        },
        */
        wishlist : function(){
            return $(".popular .elmore").css("display","");
        },
        realtime : function(){
            return $(".now .elmore").css("display","");
        },
        getEventList : function(){
            return $.ajax({
                type: "GET",
                url: "/diarystory2019/inc/ajax_event_list.asp",
                data: $("#sFrm").serialize(),
                dataType: "text",
                async: false
            }).responseText;
        },
        diarylink : function(){
            <% if isapp then %>                
                fnAmplitudeEventMultiPropertiesAction('click_diary_search_all', '','', function(bool){if(bool) {fnAPPpopupBrowserURL("다이어리 스토리","<%=wwwUrl%>/apps/appcom/wish/web2014/diarystory2019/search.asp","right",'','sc');}});        
            <% else %>
                location.href = '/diarystory2019/search.asp?gnbflag=1'
            <% end if %>
            return false;
        },
        findtodiary : function(){
            var nm  = document.getElementsByName('design');
			var cm  = document.getElementsByName('contents');
            var km  = document.getElementsByName('keyword');
            var ic  = document.getElementsByName('chkIcd');
		
			document.frm_search.arrds.value = "";
			document.frm_search.arrcont.value = "";
            document.frm_search.arrkey.value = "";
            document.frm_search.iccd.value = "";
	
			for (var i=0;i<nm.length;i++){
				if (nm[i].checked){
					document.frm_search.arrds.value = document.frm_search.arrds.value  + nm[i].value + ",";
				}
            }
		
			for (var i=0;i<cm.length;i++){
				if (cm[i].checked){
					document.frm_search.arrcont.value = document.frm_search.arrcont.value  + cm[i].value + ",";
				}
            }
	
			for (var i=0;i<km.length;i++){
				if (km[i].checked){
					document.frm_search.arrkey.value = document.frm_search.arrkey.value  + km[i].value + ",";
				}
            }

            for (var i=0;i<ic.length;i++){
				if (ic[i].checked){
					document.frm_search.iccd.value = document.frm_search.iccd.value  + ic[i].value + ",";
				}
            }
            <% if isapp then %>
            var searchparameters = $("#frm_search").serialize();
            fnAmplitudeEventMultiPropertiesAction('click_diary_search', '','', function(bool){if(bool) {fnAPPpopupBrowserURL("다이어리 스토리","<%=wwwUrl%>/apps/appcom/wish/web2014/diarystory2019/search.asp?"+searchparameters,"right");}});                    
            return false;
            <% else %>
			document.frm_search.action = "/diarystory2019/search.asp";
            document.frm_search.submit();
            <% end if %>
        }
    };
    
    $('.btn-block').click(function(){
        /*
        if($(this).parents('.diary-list').hasClass('best')){
            fndiarystory.best();
            $(this).hide();
        }
        */
        if($(this).parents('.diary-list').hasClass('popular')){
            fndiarystory.wishlist();
            $(this).hide();
        }
        if($(this).parents('.diary-list').hasClass('now')){
            fndiarystory.realtime();
            $(this).hide();
        }
        if($(this).parents('.list-card').hasClass('eventlist')){
            document.sFrm.cpg.value = parseInt(document.sFrm.cpg.value) + 1;
            $('#evtlist').append(fndiarystory.getEventList());
            if(!fndiarystory.getEventList()){
                alert("마지막 이벤트 입니다.");
                //$(this).hide();
            }
        }
        if($(this).parents('div').hasClass('all-diary')){
            fndiarystory.diarylink();
        }
        if($(this).parents('div').hasClass('filter-list')){
            fndiarystory.findtodiary();
        }
    });

    /* multi select in checkbox */
	$(".filter ul li").on("click", function(){
		$(this).find('label').toggleClass("on")
		if ($(this).find('label').hasClass("on")){
			$(this).find('.checkel').prop('checked', true);
		}else{
			$(this).find('.checkel').prop('checked', false);
		}
		return false;
    });
    
    /* 검색 필터 접기 */
    $(".diary-main .filter ul").hide();
	$( ".diary-main .filter > p" ).click(function() {
		$(this).toggleClass("selected");
		if ($(this).hasClass('selected')){
			$(this).next('ul').show();
		} else {
			$(this).next('ul').hide();
		}
	});
});

// 이벤트 이동
function goEventLink(evt, evtName) {
	<% if isApp then %>
        fnAmplitudeEventMultiPropertiesAction('click_diary_event', 'eventcode|eventname',evt+'|'+evtName, function(bool){if(bool) {fnAPPpopupEvent(evt);}});
	<% else %>
        fnAmplitudeEventMultiPropertiesAction('click_diary_event','eventcode|eventname',evt+'|'+evtName);
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
<%' 추천다이어리 %>
<section class="diary-rcmd" id="diarybest">
    <div class="diary-nav">
        <ul>
            <li class="on"><a href="#diarybest" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','추천 다이어리');">추천 다이어리</a></li>
            <li><a href="#eventlist" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','이벤트');">이벤트</a></li>
            <li><a href="#finddiary" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','다이어리 찾기');">다이어리 찾기</a></li>
        </ul>
    </div>
    <%'추천다이어리(베스트셀러)
        'Set bestlist = new cdiary_list
        '아이템 리스트
        '    bestlist.FPageSize = PageSize
        '    bestlist.FCurrPage = 1
        '    bestlist.fmdpick = "o"
        '    bestlist.getDiaryAwardBest
    %>
    <%
        '추천다이어리(방금판매된)
        set realtimelist = new cdiary_list
            realtimelist.getNowSellingItems
    %>
    <div class="diary-list now">
        <p>방금 판매된 다이어리</p>
        <div class="items type-grid">
            <ul>
                <%
                If realtimelist.FResultCount > 0 Then
                    For i = 0 To realtimelist.FResultCount - 1

                    IF application("Svr_Info") = "Dev" THEN
                        realtimelist.FItemList(i).FImageicon1 = left(realtimelist.FItemList(i).FImageicon1,7)&mid(realtimelist.FItemList(i).FImageicon1,12)
                    end if
                %>
                <li <%=chkiif(i > 5,"class='elmore'","")%>> 
                    <% If isapp Then %>                                        
                        <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_recommend_justsold_item','item_index|itemid|brand_name','<%=i+1%>|<%=realtimelist.FItemList(i).FItemid%>|<%=replace(realtimelist.FItemList(i).FBrandName,"'","")%>',function(bool){if(bool) {fnAPPpopupAutoUrl('/category/category_itemprd.asp?itemid=<%=realtimelist.FItemList(i).FItemid%><%=gaParam&"latestsell_"&i+1%>');}});return false;">                    
                    <% Else %>                        
                        <a href="/category/category_itemprd.asp?itemid=<%=realtimelist.FItemList(i).FItemid%><%=gaParam&"latestsell_"&i+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_recommend_justsold_item','item_index|itemid|brand_name','<%=i+1%>|<%=realtimelist.FItemList(i).FItemid%>|<%=replace(realtimelist.FItemList(i).FBrandName,"'","")%>')">                        
                    <% End if %>                                           
                        <div class="thumbnail"><img src="<%=realtimelist.FItemList(i).FImageBasic %>" alt="" /><em><%= realtimelist.FItemList(i).Gettimeset %></em><% if realtimelist.FItemList(i).IsSoldOut then %><b class="soldout">일시 품절</b><% end if %></div>
                        <div class="desc">
                            <p class="name">
                                <% If realtimelist.FItemList(i).isSaleItem Or realtimelist.FItemList(i).isLimitItem Then %>
                                    <%= chrbyte(realtimelist.FItemList(i).FItemName,30,"Y") %>
                                <% Else %>
                                    <%= realtimelist.FItemList(i).FItemName %>
                                <% End If %>
                            </p>
                            <div class="price">
                                <div class="unit">
                                    <% if realtimelist.FItemList(i).IsSaleItem or realtimelist.FItemList(i).isCouponItem Then %>
                                        <% IF realtimelist.FItemList(i).IsCouponItem Then %>
                                            <b class="sum"><%=FormatNumber(realtimelist.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b>
                                            <b class="discount color-green"><%=realtimelist.FItemList(i).GetCouponDiscountStr%></b>                                        
                                        <%else' IF realtimelist.FItemList(i).IsSaleItem then %>
                                            <b class="sum"><%=FormatNumber(realtimelist.FItemList(i).getRealPrice,0)%><span class="won">원</span></b>
                                            <b class="discount color-red"><%=realtimelist.FItemList(i).getSalePro%></b>
                                        <% End If %>
                                    <% else %>
                                        <b class="sum"><%=FormatNumber(realtimelist.FItemList(i).getRealPrice,0) & chkIIF(realtimelist.FItemList(i).IsMileShopitem,"Point","<span class='won'>원</span>")%></b>
                                    <% end if %>
                                </div>
                            </div>
                        </div>
                    </a>
                </li>
                <%
                    Next
                end If
                %>
            </ul>
            <button onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_recommend_justsold_morebtn','','')" class="btn btn-large  btn-block btn-more">더보기<span class="btn-icon"></span></button>
        </div>
    </div>
    <%
        set realtimelist = Nothing
    %>
    <%' 추천다이어리(장바구니에 많이 담긴)
        Set wishlist = new cdiary_list
        '아이템 리스트
            wishlist.FPageSize = PageSize
            wishlist.FCurrPage = 1
            wishlist.Fbestgubun = "f"
            wishlist.ftectSortMet = SortMet
            wishlist.getDiaryAwardBest
    %>
    <div class="diary-list popular">
        <p>장바구니 베스트</p>
        <div class="items type-grid">
            <ul>
                <%
                If wishlist.FResultCount > 0 Then
                    For i = 0 To wishlist.FResultCount - 1

                    IF application("Svr_Info") = "Dev" THEN
                        wishlist.FItemList(i).FImageicon1 = left(wishlist.FItemList(i).FImageicon1,7)&mid(wishlist.FItemList(i).FImageicon1,12)
                    end if
                %>
                <li <%=chkiif(i > 5,"class='elmore'","")%>> 
                    <% If isapp Then %>                                        
                        <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_recommend_cart_item','item_index|itemid|brand_name','<%=i+1%>|<%=wishlist.FItemList(i).FItemid%>|<%=replace(wishlist.FItemList(i).FBrandName,"'","")%>',function(bool){if(bool) {fnAPPpopupAutoUrl('/category/category_itemprd.asp?itemid=<%=wishlist.FItemList(i).FItemid%><%=gaParam&"wish_"&i+1%>');}});return false;">                    
                    <% Else %>                        
                        <a href="/category/category_itemprd.asp?itemid=<%=wishlist.FItemList(i).FItemid%><%=gaParam&"wish_"&i+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_recommend_cart_item','item_index|itemid|brand_name','<%=i+1%>|<%=wishlist.FItemList(i).FItemid%>|<%=replace(wishlist.FItemList(i).FBrandName,"'","")%>')">                        
                    <% End if %>                                                                            
                        <div class="thumbnail"><img src="<%= wishlist.FItemList(i).FDiaryBasicImg2 %>" alt="" /><% If wishlist.FItemList(i).Ffavcount > 0 Then %><em><%=formatnumber(wishlist.FItemList(i).Ffavcount,0)%>명</em><% end if %><% if wishlist.FItemList(i).IsSoldOut then %><b class="soldout">일시 품절</b><% end if %></div>
                        <div class="desc">
                            <p class="name">
                                <% If wishlist.FItemList(i).isSaleItem Or wishlist.FItemList(i).isLimitItem Then %>
                                    <%= chrbyte(wishlist.FItemList(i).FItemName,30,"Y") %>
                                <% Else %>
                                    <%= wishlist.FItemList(i).FItemName %>
                                <% End If %>
                            </p>
                            <div class="price">
                                <div class="unit">
                                    <% if wishlist.FItemList(i).IsSaleItem or wishlist.FItemList(i).isCouponItem Then %>
                                        <% IF wishlist.FItemList(i).IsCouponItem Then %>
                                            <b class="sum"><%=FormatNumber(wishlist.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b>
                                            <b class="discount color-green"><%=wishlist.FItemList(i).GetCouponDiscountStr%></b>
                                        <% else %>                                                                            
                                            <b class="sum"><%=FormatNumber(wishlist.FItemList(i).getRealPrice,0)%><span class="won">원</span></b>
                                            <b class="discount color-red"><%=wishlist.FItemList(i).getSalePro%></b>
                                        <% End If %>
                                    <% else %>
                                        <b class="sum"><%=FormatNumber(wishlist.FItemList(i).getRealPrice,0) & chkIIF(wishlist.FItemList(i).IsMileShopitem,"Point","<span class='won'>원</span>")%></b>
                                    <% end if %>
                                </div>
                            </div>
                        </div>
                    </a>
                </li>                
                <%
                    Next
                end If
                %>
            </ul>
            <button onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_recommend_cart_morebtn','','')" class="btn btn-large  btn-block btn-more">더보기<span class="btn-icon"></span></button>
        </div>
    </div>
    <%
        Set wishlist = Nothing
    %>
</section>
<%'추천다이어리%>

<%'이벤트 %>
<section class="diary-evt" id="eventlist">
    <div class="diary-nav">
        <ul>
            <li><a href="#diarybest" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','추천 다이어리');">추천 다이어리</a></li>
            <li class="on"><a href="#eventlist" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','이벤트');">이벤트</a></li>
            <li><a href="#finddiary" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','다이어리 찾기');">다이어리 찾기</a></li>            
        </ul>
    </div>
    <%
        set hoteventlist = new cdiary_list
            hoteventlist.FCurrPage  = 1
            hoteventlist.FPageSize	= 5
            hoteventlist.FselOp		= 0 '0 신규순 1 종료 임박 2 인기순
            hoteventlist.FEvttype   = "1"
            hoteventlist.Fisweb	 	= "0"
            hoteventlist.Fismobile	= "1"
            hoteventlist.Fisapp	 	= "1"
            hoteventlist.fnGetdievent
    %>
    <div class="list-card eventlist">
        <ul id="evtlist">
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
                <a href="" onclick="goEventLink('<%=hoteventlist.FItemList(i).fevt_code%>', '<%=db2html(hoteventlist.FItemList(i).FEvt_subname)%>');return false;" >
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
        </ul>
        <button onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_event_morebtn','','')" class="btn btn-large  btn-block btn-more">더보기<span class="btn-icon"></span></button>
    </div>
    <%
        set hoteventlist = Nothing
    %>
</section>
<%'이벤트%>

<%'다이어리찾기%>
<section class="diary-finder" id="finddiary">
    <div class="diary-nav">
        <ul>
            <li><a href="#diarybest" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','추천 다이어리');">추천 다이어리</a></li>
            <li><a href="#eventlist" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','이벤트');">이벤트</a></li>
            <li class="on"><a href="#finddiary" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_menu','menuname','다이어리 찾기');">다이어리 찾기</a></li>                        
        </ul>
    </div>
    <div class="all-diary">
        <div><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/img_all_diary.jpg" alt="all diary"></div>
        <button onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_search_all','','')" class="btn  btn-block">다이어리 모두보기</button>
    </div>
</section>
<div class="filter-list">
    <form name="frm_search" id="frm_search" method="post" style="margin:0px;">
    <input type="hidden" name="arrds" value="">
    <input type="hidden" name="arrcont" value="">
    <input type="hidden" name="arrkey" value="">
    <input type="hidden" name="limited" value="">
    <input type="hidden" name="iccd" value="">
    <input type="hidden" name="cpg" value="1">
    <div class="inner">
        <p class="tit">내가 원하는 다이어리 찾기</p>
        <p class="sub">디자인을 선택 후 아래의 ‘찾기’ 버튼을 눌러주세요. </p>
        <div class="filter filter1">
            <p>디자인</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optS1" name="design" value="10"/> <label for="optS1">심플</label></li>
                <li><input type="checkbox" class="checkel" id="optS2" name="design" value="20"/> <label for="optS2">일러스트</label></li>
                <li><input type="checkbox" class="checkel" id="optS3" name="design" value="30"/> <label for="optS3">패턴</label></li>
                <li><input type="checkbox" class="checkel" id="optS4" name="design" value="40"/> <label for="optS4">포토</label></li>
            </ul>
        </div>
        <div class="filter filter2">
            <p>날짜</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt1-1" name="contents" value="'2019 날짜형'"/> <label for="optCt1-1">2019 날짜형</label></li>
                <li><input type="checkbox" class="checkel" id="optCt1-2" name="contents" value="'만년형'"/> <label for="optCt1-2">만년형</label></li>
            </ul>
        </div>
        <div class="filter filter3">
            <p>기간</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt2-1" name="contents" value="'분기별'"/> <label for="optCt2-1">분기별</label></li>
                <li><input type="checkbox" class="checkel" id="optCt2-2" name="contents" value="'6개월'"/> <label for="optCt2-2">6개월</label></li>
                <li><input type="checkbox" class="checkel" id="optCt2-3" name="contents" value="'1년'"/> <label for="optCt2-3">1년</label></li>
                <li><input type="checkbox" class="checkel" id="optCt2-4" name="contents" value="'1년 이상'"/> <label for="optCt2-4">1년 이상</label></li>
            </ul>
        </div>
        <div class="filter filter3">
            <p>내지 구성</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt3-1" name="contents" value="'연간스케줄'"/> <label for="optCt3-1">연간스케줄</label></li>
                <li><input type="checkbox" class="checkel" id="optCt3-2" name="contents" value="'먼슬리'"/> <label for="optCt3-2">먼슬리</label></li>
                <li><input type="checkbox" class="checkel" id="optCt3-3" name="contents" value="'위클리'"/> <label for="optCt3-3">위클리</label></li>
                <li><input type="checkbox" class="checkel" id="optCt3-4" name="contents" value="'일스케줄'"/> <label for="optCt3-4">일스케줄</label></li>
            </ul>
        </div>
        <div class="filter filter4">
            <p>테마</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt4-1" name="contents" value="'다이어리'"/> <label for="optCt4-1">다이어리</label></li>
                <li><input type="checkbox" class="checkel" id="optCt4-2" name="contents" value="'스터디'"/> <label for="optCt4-2">스터디</label></li>
                <li><input type="checkbox" class="checkel" id="optCt4-3" name="contents" value="'가계부'"/> <label for="optCt4-3">가계부</label></li>
                <li><input type="checkbox" class="checkel" id="optCt4-4" name="contents" value="'자기계발'"/> <label for="optCt4-4">자기계발</label></li>
            </ul>
        </div>
        <div class="filter filter4">
            <p>옵션</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt5-1" name="contents" value="'포켓'"/> <label for="optCt5-1">포켓</label></li>
                <li><input type="checkbox" class="checkel" id="optCt5-2" name="contents" value="'밴드'"/> <label for="optCt5-2">밴드</label></li>
                <li><input type="checkbox" class="checkel" id="optCt5-3" name="contents" value="'펜홀더'"/> <label for="optCt5-3">펜홀더</label></li>
                <li></li>
            </ul>
        </div>
        <div class="filter filter4">
            <p>커버 재질</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCv1-1" name="keyword" value="50"/> <label for="optCv1-1">소프트커버</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-2" name="keyword" value="51"/> <label for="optCv1-2">하드커버</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-3" name="keyword" value="52"/> <label for="optCv1-3">가죽</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-4" name="keyword" value="53"/> <label for="optCv1-4">PVC</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-5" name="keyword" value="54"/> <label for="optCv1-5">패브릭</label></li>
                <li></li>
            </ul>
        </div>
        <div class="filter filter5">
            <p>제본</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCv2-1" name="keyword" value="55"/> <label for="optCv2-1">양장/무선</label></li>
                <li><input type="checkbox" class="checkel" id="optCv2-2" name="keyword" value="56"/> <label for="optCv2-2">스프링</label></li>
                <li><input type="checkbox" class="checkel" id="optCv2-3" name="keyword" value="60"/> <label for="optCv2-3">바인더(2공~6공)</label></li>
                <li></li>
            </ul>
        </div>
        <div class="filter filter6">
            <p>색상</p>
            <ul class="option-list colorchips">
                <li class="wine"><input type="checkbox" class="checkel" id="wine" name="chkIcd" value="28"/><label for="wine">Wine</label></li>
                <li class="red"><input type="checkbox" class="checkel" id="red" name="chkIcd" value="2"/><label for="red">Red</label></li>
                <li class="orange"><input type="checkbox" class="checkel" id="orange" name="chkIcd" value="16"/><label for="orange">Orange</label></li>
                <li class="brown"><input type="checkbox" class="checkel" id="brown" name="chkIcd" value="24"/><label for="brown">Brown</label></li>
                <li class="camel"><input type="checkbox" class="checkel" id="camel" name="chkIcd" value="29"/><label for="camel">Camel</label></li>
                <li class="green"><input type="checkbox" class="checkel" id="green" name="chkIcd" value="19"/><label for="green">Green</label></li>
                <li class="khaki"><input type="checkbox" class="checkel" id="khaki" name="chkIcd" value="31"/><label for="khaki">Khaki</label></li>
                <li class="beige"><input type="checkbox" class="checkel" id="beige" name="chkIcd" value="18"/><label for="beige">Beige</label></li>
                <li class="yellow"><input type="checkbox" class="checkel" id="yellow" name="chkIcd" value="17"/><label for="yellow">Yellow</label></li>
                <li class="ivory"><input type="checkbox" class="checkel" id="ivory" name="chkIcd" value="30"/><label for="ivory">Ivory</label></li>
                <li class="mint"><input type="checkbox" class="checkel" id="mint" name="chkIcd" value="32"/><label for="mint">Mint</label></li>
                <li class="skyblue"><input type="checkbox" class="checkel" id="skyblue" name="chkIcd" value="20"/><label for="skyblue">Sky Blue</label></li>
                <li class="blue"><input type="checkbox" class="checkel" id="blue" name="chkIcd" value="21"/><label for="blue">Blue</label></li>
                <li class="navy"><input type="checkbox" class="checkel" id="navy" name="chkIcd" value="33"/><label for="navy">Navy</label></li>
                <li class="violet"><input type="checkbox" class="checkel" id="violet" name="chkIcd" value="22"/><label for="violet">Violet</label></li>
                <li class="lightgrey"><input type="checkbox" class="checkel" id="lightgrey" name="chkIcd" value="25"/><label for="lightgrey">Light Grey</label></li>
                <li class="white"><input type="checkbox" class="checkel" id="white" name="chkIcd" value="7"/><label for="white">White</label></li>
                <li class="pink"><input type="checkbox" class="checkel" id="pink" name="chkIcd" value="23"/><label for="pink">Pink</label></li>
                <li class="babypink"><input type="checkbox" class="checkel" id="babypink" name="chkIcd" value="35"/><label for="babypink">Baby Pink</label></li>
                <li class="lilac"><input type="checkbox" class="checkel" id="lilac" name="chkIcd" value="34"/><label for="lilac">Lilac</label></li>
                <li class="charcoal"><input type="checkbox" class="checkel" id="charcoal" name="chkIcd" value="36"/><label for="charcoal">Charcoal</label></li>
                <li class="black"><input type="checkbox" class="checkel" id="black" name="chkIcd" value="8"/><label for="black">Black</label></li>
                <li class="silver"><input type="checkbox" class="checkel" id="silver" name="chkIcd" value="26"/><label for="silver">Silver</label></li>
                <li class="gold"><input type="checkbox" class="checkel" id="gold" name="chkIcd" value="27"/><label for="gold">Gold</label></li>
                <li class="hologram"><input type="checkbox" class="checkel" id="hologram" name="chkIcd" value="58"/><label for="hologram">Hologram</label></li>
            </ul>
        </div>
    </div>
    </form>
    <button onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_search','','')" class="btn btn-block">다이어리 찾기</button>
</div>
<form name="sFrm" id="sFrm" method="post">
<input type="hidden" name="cpg" value="1"/>
</form>
<%'!-- 다이어리찾기 --%>