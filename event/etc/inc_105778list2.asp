<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : 다이어리 스토리 오픈 이벤트 
' History : 2020-09-09 정태훈
'#################################################################
%>
<%
Dim userid, currentDate, eventStartDate, eventEndDate
currentDate =  now()
userid = GetEncLoginUserID()
eventStartDate  = cdate("2020-09-14")		'이벤트 시작일
eventEndDate 	= cdate("2020-10-04")		'이벤트 종료일


Dim eCode, i
IF application("Svr_Info") = "Dev" THEN
	eCode   =  102223
Else
	eCode   =  105778
End If

dim cEComment
dim iCTotCnt
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	isMyComm	= requestCheckVar(request("isMC"),1)

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
iCPageSize = 8		'메뉴가 있으면 10개		'/수기이벤트 둘다 강제 12고정

dim ccomment
set ccomment = new Cevent_etc_common_list
	ccomment.FPageSize        = iCPageSize
	ccomment.FCurrpage        = iCCurrpage
	ccomment.FScrollCount     = iCPerCnt
	ccomment.frectevt_code    = eCode
    ccomment.frectsub_opt2="1"
    ccomment.frectordertype="new"
	ccomment.event_subscript_paging
    iCTotCnt = ccomment.FTotalCount            '리스트 총 갯수
iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
                            <% IF ccomment.ftotalcount>0 THEN %>
							<h4><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/tit_cmt.png" alt="다른 사람들의 6글자"></h4>
							<% '<!-- for dev msg 8개 노출 --> %>
                                <ul id="clist2">
                                    <% for i = 0 to ccomment.fresultcount - 1 %>
                                    <li id="list_<% = ccomment.FItemList(i).fsub_idx %>">
                                        <div class="cmt-wrap">
                                            <span class="num">NO.<%=iCTotCnt-i-(iCPageSize*(iCCurrpage-1))%></span>
                                            <% if ((userid = ccomment.FItemList(i).fuserid) or (userid = "10x10")) and (ccomment.FItemList(i).fuserid<>"") then %>
                                            <div class="btn-group">
                                                <button class="btn-modify" onclick="fnMyCommentEdit2(<% = ccomment.FItemList(i).fsub_idx %>)">수정하기</button>
                                                <button class="btn-submit" onclick="fnEditComment2(<% = ccomment.FItemList(i).fsub_idx %>);">확인</button>
                                            </div>
                                            <% end if %>
                                            <div class="cmt-cont">
                                                <div><%=ReplaceBracket(ccomment.FItemList(i).fsub_opt1)%></div>
                                            </div>
                                            <div class="user-info"><%=printUserId(ccomment.FItemList(i).fuserid,2,"*")%>님</div>
                                        </div>
                                    </li>
                                    <% next %>
                                </ul>
                                <% '<!-- pagination --> %>
                                <%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage2") %>
                            <% else %>
                            <h4><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/tit_cmt.png" alt="다른 사람들의 6글자"></h4>
                            <ul id="clist2"></ul>
                            <% end if %>
