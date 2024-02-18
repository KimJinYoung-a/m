<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
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


Dim eCode ,  pagereload
IF application("Svr_Info") = "Dev" THEN
	eCode   =  102223
Else
	eCode   =  105778
End If

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

IF blnFull = "" THEN blnFull = True
IF blnBlogURL = "" THEN blnBlogURL = False

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 4		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 4		'메뉴가 있으면 10개		'/수기이벤트 둘다 강제 12고정
end if

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt      '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt            '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
						    <% If isArray(arrCList) Then %>
                            <h4><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/tit_cmt2.png" alt="다른 사람들이 고른 다이어리 구경하기"></h4>
 							<ul id="clist">
                                <% For intCLoop = 0 To UBound(arrCList,2) %>
								<li id="list<% = arrCList(0,intCLoop) %>">
									<div class="thumbnail">
                                    <% If isApp="1" or isApp="2" Then %>
                                        <a href="" onclick="fnAPPpopupBrowserURL('상품정보','http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemprd.asp?itemid=<% = arrCList(3,intCLoop) %>&pEtr=<%=eCode%>');return false;" class="mApp">
                                    <% else %>
                                        <a href="/category/category_itemprd.asp?itemid=<% = arrCList(3,intCLoop) %>&pEtr=<%=eCode%>" class="mWeb" target="_blank">
                                    <% end if %>
                                        <span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span><img src="<%=arrCList(7,intCLoop)%>" alt=""></a>
                                    </div>
									<div class="cmt-wrap">
										<div class="user-info">
											<em class="user-grade vip"></em><span class="user-id"><%=printUserId(arrCList(2,intCLoop),2,"*")%>님</span>
                                            <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
											<div class="btn-group">
												<button class="btn-modify" onclick="fnMyCommentEdit(<% = arrCList(0,intCLoop) %>);">수정하기</button>
												<button class="btn-delete" onclick="fnDelComment(<% = arrCList(0,intCLoop) %>);">삭제하기</button>
												<button class="btn-submit" onclick="fnEditComment(<% = arrCList(0,intCLoop) %>);">확인</button>
											</div>
                                            <% end if %>
										</div>
										<div class="cmt-cont">
											<div><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></div>
										</div>
									</div>
								</li>
                                <% Next %>
							</ul>
							<!-- pagination -->
							<div class="pageWrapV15">
								<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
							</div>
                            <% else %>
                            <h4><img src="//webimage.10x10.co.kr/fixevent/event/2020/105778/m/tit_cmt2.png" alt="다른 사람들이 고른 다이어리 구경하기"></h4>
                            <ul id="clist">
                            </ul>
                            <% end if %>