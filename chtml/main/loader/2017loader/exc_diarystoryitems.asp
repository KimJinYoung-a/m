<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/diarystory2019/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : today_main 다이어리스토리 베스트 모음
' History : 2018-12-10 이종화 생성
'#######################################################
Dim gaParam : gaParam = "&gaparam=today_diarystorybest_" '// Best 상품
Dim gaParamEvent : gaParamEvent = "&gaparam=today_diarystoryevent_" '// 이벤트
dim gaParamDaccu : gaParamDaccu = "&gaparam=today_diarystorydaccu_" '// 다꾸 아이템
dim gaParamDaccuChannel : gaParamDaccuChannel = "&gaparam=today_diarystorydaccuchannel" '// 다꾸 채널
dim bestlist , i , di , lp
dim oDaccuRanking , hoteventlist , sqlStr , vDate

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "diaryBest"&Cint(timer/60)
Else
	cTime = 60*5
	dummyName = "diaryBest"
End If

' vDate
sqlStr = "SELECT MAX(rankdate) as maxRankDate FROM db_temp.dbo.tbl_DiaryDecoItemRanking"
rsget.Open sqlStr, dbget, 1
If Not rsget.EOF Then
    If left(Trim(rsget("maxRankDate")),10) <> Trim(vDate) Then
        vDate = left(Trim(rsget("maxRankDate")),10)
    End If
End if
rsget.close

' 다이어리 Pick 상품
Set bestlist = new cdiary_list
    '아이템 리스트
    bestlist.FPageSize = 8
    bestlist.FCurrPage = 1
    bestlist.fmdpick = "o"
    bestlist.getDiaryAwardBest

' 다이어리 이벤트
set hoteventlist = new cdiary_list
    hoteventlist.FCurrPage  = 1
    hoteventlist.FPageSize	= 4
    hoteventlist.FselOp		= 0 '0 신규순 1 종료 임박 2 인기순
    hoteventlist.FEvttype   = "1"
    hoteventlist.Fisweb	 	= "0"
    hoteventlist.Fismobile	= "1"
    hoteventlist.Fisapp	 	= "1"
    hoteventlist.fnGetdievent

set oDaccuRanking = new cdiary_list
    oDaccuRanking.frecttoplimit = 8
    oDaccuRanking.FRectRankingDate = vDate
    oDaccuRanking.GetDiaryDaccuItemRanking


on Error Resume Next
If bestlist.FResultCount > 0 Then
%>
<div class="category-item-content bg-grey" style="padding-bottom:1.71rem;">
    <section class="category-item-list diary2019-item-list">
        <h2 class="headline"><span class="icon-diary2019"></span>다이어리, 이제 한번 꾸며볼까?</h2>
        <%'!-- 추천다이어리 --%>
        <!--div class="inner diary-item">
            <p>추천 다이어리</p>
            <div class="items">
                <ul>
                    <%
                        dim link , alink
                        For i = 0 To bestlist.FResultCount - 1

                        IF application("Svr_Info") = "Dev" THEN
                            bestlist.FItemList(i).FImageicon1 = left(bestlist.FItemList(i).FImageicon1,7)&mid(bestlist.FItemList(i).FImageicon1,12)
                        end if

                        link = "/category/category_itemPrd.asp?itemid="&bestlist.FItemList(i).Fitemid

                        IF isapp THEN 
                            alink = "fnAmplitudeEventAction('click_maindiarybest_views','bestitems','"& bestlist.FItemList(i).Fitemid &"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& link & gaparam & (i+1) &"');}});return false;"
                        ELSE
                            alink = link & gaparam & i+1
                        END IF
                    %>
                    <li>
                        <% if isapp then %>
                        <a href="" onclick="<%=alink%>">
                        <% else %>
                        <a href="<%=alink%>" onclick="fnAmplitudeEventAction('click_maindiarybest_views','bestitems','<%= bestlist.FItemList(i).Fitemid %>','');">
                        <% end if %>
                            <div class="thumbnail"><img src="<%= bestlist.FItemList(i).FDiaryBasicImg2 %>" alt="" /></div>
                            <div class="desc">
                                <p class="name">
                                    <% If bestlist.FItemList(i).isSaleItem Or bestlist.FItemList(i).isLimitItem Then %>
                                        <%= chrbyte(bestlist.FItemList(i).FItemName,30,"Y") %>
                                    <% Else %>
                                        <%= bestlist.FItemList(i).FItemName %>
                                    <% End If %>
                                </p>
                                <div class="price">
                                    <% if bestlist.FItemList(i).IsSaleItem or bestlist.FItemList(i).isCouponItem Then %>
                                        <% IF bestlist.FItemList(i).IsCouponItem Then %>
                                            <b class="discount color-green"><%=bestlist.FItemList(i).GetCouponDiscountStr%></b>
                                            <b class="sum"><%=FormatNumber(bestlist.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b>                                        
                                        <% else'IF bestlist.FItemList(i).IsSaleItem then %>
                                            <b class="discount color-red"><%=bestlist.FItemList(i).getSalePro%></b>
                                            <b class="sum"><%=FormatNumber(bestlist.FItemList(i).getRealPrice,0)%><span class="won">원</span></b>
                                        <% End If %>
                                    <% else %>
                                        <b class="sum"><%=FormatNumber(bestlist.FItemList(i).getRealPrice,0) & chkIIF(bestlist.FItemList(i).IsMileShopitem,"Point","<span class='won'>원</span>")%></b>
                                    <% end if %>
                                </div>
                            </div>
                        </a>
                    </li>
                   <% 
                        Next
                    %>
                </ul>
            </div>
        </div-->
        <%'!--// 추천다이어리 --%>
        <%'!-- 다이어리이벤트 --%>
        <div class="inner diary-event">
            <p>다이어리 이벤트</p>
            <div class="list-card">
                <ul>
                    <% 
                        dim vName , elink , Ealink
                        FOR di = 0 to hoteventlist.FResultCount-1
                            vName = ""
                            if ubound(Split(hoteventlist.FItemList(di).FEvt_name,"|"))> 0 Then
                                If hoteventlist.FItemList(di).fissale Or (hoteventlist.FItemList(di).fissale And hoteventlist.FItemList(di).fiscoupon) then
                                    vName = "<p class='tit'><span>"& cStr(chrbyte(Split(hoteventlist.FItemList(di).FEvt_name,"|")(0),100,"Y"))&"</span><em class='discount color-red'>"&cStr(Split(hoteventlist.FItemList(di).FEvt_name,"|")(1)) &"</em></p>"
                                ElseIf hoteventlist.FItemList(di).fiscoupon Then
                                    vName = "<p class='tit'><span>"& cStr(chrbyte(Split(hoteventlist.FItemList(di).FEvt_name,"|")(0),100,"Y"))&"</span><em class='discount color-green'>"&cStr(Split(hoteventlist.FItemList(di).FEvt_name,"|")(1)) &"</em></p>"
                                end if 
                            else
                                vName = "<p class='tit'><span>"& hoteventlist.FItemList(di).FEvt_name &"</span></p>"
                            end if

                            elink = "/event/eventmain.asp?eventid="& hoteventlist.FItemList(di).fevt_code
                            IF isapp THEN 
                                Ealink = "fnAmplitudeEventAction('click_maindiarybest_views','events','"& hoteventlist.FItemList(di).fevt_code &"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& elink & gaParamEvent & (di+1) &"');}});return false;"
                            ELSE
                                Ealink = elink & gaParamEvent & di+1
                            END IF
                    %>
                    <li>
                        <% if isapp then %>
                        <a href="" onclick="<%=Ealink%>">
                        <% else %>
                        <a href="<%=Ealink%>" onclick="fnAmplitudeEventAction('click_maindiarybest_views','events','<%=hoteventlist.FItemList(di).fevt_code%>','');">
                        <% end if %>
                            <div class="thumbnail"><img src="<%=hoteventlist.FItemList(di).fevt_mo_listbanner %>" alt=""></div>
                            <div class="desc">
                                <%=vName%>
                                <p class="subcopy"><%=db2html(hoteventlist.FItemList(di).FEvt_subname) %></p>
                            </div>
                        </a>
                    </li>
                    <%		
                        Next 
                    %>
                </ul>
            </div>
        </div>
        <%'!--// 다이어리이벤트 --%>
        <%'-- 베스트데코템 --%>
        <div class="inner diary-item">
            <p>베스트 데코템</p>
            <div class="items">
                <ul>
                    <%	
                        dim dlink , dalink
                        For lp=0 to oDaccuRanking.FResultCount-1 

                        dlink = "/category/category_itemPrd.asp?itemid="& oDaccuRanking.FItemList(lp).FItemID
                        IF isapp THEN 
                            dalink = "fnAmplitudeEventAction('click_maindiarybest_views','daccuitems','"& oDaccuRanking.FItemList(lp).FItemID &"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& dlink & gaParamDaccu & (lp+1) &"');}});return false;"
                        ELSE
                            dalink = dlink & gaParamDaccu & lp+1
                        END IF
                    %>
                    <li>
                        <% if isapp then %>
                        <a href="" onclick="<%=dalink%>">
                        <% else %>
                        <a href="<%=dalink%>" onclick="fnAmplitudeEventAction('click_maindiarybest_views','daccuitems','<%= oDaccuRanking.FItemList(lp).FItemID %>','');">
                        <% end if %>
                            <div class="thumbnail"><img src="<%=getThumbImgFromURL(oDaccuRanking.FItemList(lp).FImageBasic,"200","200","true","false") %>" alt="" /></div>
                            <div class="desc">
                                <p class="name"><%=oDaccuRanking.FItemList(lp).FItemName %></p>
                                <div class="price">
                                    <% if oDaccuRanking.FItemList(lp).IsSaleItem or oDaccuRanking.FItemList(lp).isCouponItem Then %>
                                        <% IF oDaccuRanking.FItemList(lp).IsSaleItem then %>
                                            <span class="discount color-red"><%=oDaccuRanking.FItemList(lp).getSalePro%></span>
                                            <span class="sum"><%=FormatNumber(oDaccuRanking.FItemList(lp).getRealPrice,0)%><span class="won">원</span></span>
                                        <% End If %>
                                        <% IF oDaccuRanking.FItemList(lp).IsCouponItem Then %>
                                            <span class="discount color-green"><%=oDaccuRanking.FItemList(lp).GetCouponDiscountStr%></span>
                                            <span class="sum"><%=FormatNumber(oDaccuRanking.FItemList(lp).GetCouponAssignPrice,0)%><span class="won">원</span></span>
                                        <% end if %>
                                    <% else %>
                                        <span class="sum"><%=FormatNumber(oDaccuRanking.FItemList(lp).getRealPrice,0) & chkIIF(oDaccuRanking.FItemList(lp).IsMileShopitem,"Point","<span class='won'>원</span>")%></span>
                                    <% end if %>
                                </div>
                            </div>
                        </a>
                    </li>
                    <% 
                        next 
                    %>
                </ul>
            </div>
        </div>
        <%'!--// 베스트데코템 --%>

        <%'!-- 다꾸채널(수작업) --%>
        <!--<div class="inner daccu-vod">
            <p>다꾸 채널</p>
            <div class="list-card">
                <ul>
                    <%
                        'dim daflink , dclink , devt_code
                        'devt_code = "91894"
                        'daflink = "/event/eventmain.asp?eventid="& devt_code
                        'IF isapp THEN
                            'dclink = "fnAmplitudeEventAction('click_maindiarybest_views','daccuchannel','"&devt_code&"', function(bool){if(bool) {fnAPPpopupAutoUrl('"& daflink & gaParamDaccuChannel &"');}});return false;"
                        'ELSE
                           ' dclink = daflink & gaParamDaccuChannel
                        'END IF
                    %>
                    <li>
                        <%' if isapp then %>
                        <a href="" onclick="<%'=dclink%>">
                        <%' else %>
                        <a href="<%'=dclink%>" onclick="fnAmplitudeEventAction('click_maindiarybest_views','daccuchannel','<%'=devt_code%>','');">
                        <%' end if %>
                            <div class="thumbnail"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91894/m/img_vod_thumb.gif" alt="다꾸채널 vol013"></div>
                            <span class="represent-item" style="width: 10.92rem; right:-1rem; bottom:0;"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/91894/m/img_item_0.png" alt="대표상품"></span>
                            <div class="desc">
                                <p class="tit">
                                    <span>신비한 마테백과사전 vol.3</span>
                                </p>
                                <p class="subcopy">다이어리 꾸미기 필수템! 마스킹테이프를 알아보자!</p>
                            </div>
                        </a>
                    </li
                </ul>
            </div>
        </div>-->
        <%'!--// 다꾸채널(수작업) --%>

        <!-- 텐텐 탐구 생활 배너 추가 20180128 -->
        <div class="inner daccu-vod">
            <p>다꾸 채널</p>
            <div class="list-card">
                <ul>
                    <li>
                        <a href= "/event/eventmain.asp?eventid=95779" class="mWeb">
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95779/m/img_vod_thumb.gif" alt="다꾸채널 vol20"></div>
                        </a>
                        <a href= "" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '다꾸채널', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=95779');return false;" class="mApp">
                            <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2019/95779/m/img_vod_thumb.gif" alt="다꾸채널 vol20"></div>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!-- 텐텐 탐구 생활 배너 추가 -->
    </section>
</div>
<%
end if 
on Error Goto 0

Set bestlist = Nothing
set hoteventlist = Nothing
Set oDaccuRanking = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->