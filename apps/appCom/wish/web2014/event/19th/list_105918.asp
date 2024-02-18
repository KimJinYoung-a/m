<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/event/19th/105918Cls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description :  19주년 그림일기장 리스트
' History : 2020-09-24 정태훈
'#################################################################
%>
<%
Dim userid, currentDate, isMyComm
currentDate =  now()
userid = GetEncLoginUserID()

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = 103233
Else
	eCode = 105918
End If

dim cEvtBBC ,iCCurrpage, searchTxt, iCPageSize, sortDiv
dim iCTotCnt, arrCList, intCLoop, iCTotalPage, iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	searchTxt			= requestCheckVar(Request("searchTxt"),32)
	sortDiv		= requestCheckVar(Request("sortDiv"),10)
if sortDiv="" then sortDiv=1
IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 5		'보여지는 페이지 간격
iCPageSize = 8      '한 페이지의 보여지는 열의 수

'데이터 가져오기
set cEvtBBC = new ClsEvtBBS
	cEvtBBC.FECode 		= eCode
	cEvtBBC.FsearchTxt	= searchTxt
	cEvtBBC.FsortDiv    	= sortDiv
	cEvtBBC.FCPage 		= iCCurrpage	'현재페이지
	cEvtBBC.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEvtBBC.FUserID = userid
	cEvtBBC.FTotCnt 	= iCTotCnt      '전체 레코드 수

	arrCList = cEvtBBC.fnGetBBSList		'리스트 가져오기
	iCTotCnt = cEvtBBC.FTotCnt            '리스트 총 갯수
set cEvtBBC = nothing

iCTotalPage = Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

Function fnDisplayPagingDiary(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
	intBlockPerPage = 5 '페이징 리뉴얼 이후 모바일은 고정으로 5개 블럭 나옴(기존 4개)

	'변수 선언
	Dim intCurrentPage, strCurrentPath, vPageBody
	Dim intStartBlock, intEndBlock, intTotalPage, intNextPage
	Dim strParamName, intLoop

	'현재 페이지 설정
	intCurrentPage = strCurrentPage		'현재 페이지 값

	'총 페이지 수 설정
	intTotalPage =   int((intTotalRecord-1)/intRecordPerPage) +1

	intNextPage = int(intTotalPage-intCurrentPage)
	
	'해당페이지에 표시되는 시작페이지와 마지막페이지 설정
	if intCurrentPage > 3 then
		if intNextPage > 1 then
			intStartBlock = Int(intCurrentPage-2)
			intEndBlock = Int(intCurrentPage+2)
		elseif intNextPage < 1 then
			intStartBlock = Int(intCurrentPage-4)
			intEndBlock = Int(intCurrentPage+2)
		else
			intStartBlock = Int(intCurrentPage-3)
			intEndBlock = Int(intCurrentPage+2)
		end if
	else
		intStartBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + 1
		intEndBlock = Int((intCurrentPage - 1) / intBlockPerPage) * intBlockPerPage + intBlockPerPage
	end if

	dim prePgNum
	if intStartBlock > 1 then
		prePgNum = intStartBlock - 1
	else
		prePgNum = 1
	end if
		
	''eastone 추가
	if (intTotalPage<1) then intTotalPage=1
	if intStartBlock < 2 then intStartBlock = 1
	
	vPageBody = ""
	
	'## 이전 페이지
	If intTotalPage > 5 and intCurrentPage > 3 Then
		vPageBody = vPageBody & "<a href=""javascript:" & strJsFuncName & "(" & prePgNum & ","&sortDiv&",'"&searchTxt&"')"" class=""page-prev"">이전</a>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "<a href=""javascript:" & strJsFuncName & "(" & intLoop & ","&sortDiv&",'"&searchTxt& "')"" class=""active"">" & intLoop & "</a>" & vbCrLf
			Else
				vPageBody = vPageBody & "<a href=""javascript:" & strJsFuncName & "(" & intLoop & ","&sortDiv&",'"&searchTxt& "')"">" & intLoop & "</a>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "<a href=""javascript:" & strJsFuncName & "(1"& ","&sortDiv&",'"&searchTxt&"')"" class=""active"">1</a>" & vbCrLf
	End If
	
	'## 다음 페이지
	if intTotalPage > 5 and (intTotalPage-intCurrentPage) > 2 then
		vPageBody = vPageBody & "<a href=""javascript:" & strJsFuncName & "(" & intEndBlock+1 & ","&sortDiv&",'"&searchTxt& "')"" class=""page-next"">다음</a>" & vbCrLf
	End If
	
	fnDisplayPagingDiary = vPageBody
	
End Function
%>
                        <% If isArray(arrCList) Then %>
                            <ul class="pic-list" id="diarylist">
                            <% For intCLoop = 0 To UBound(arrCList,2) %>
                                <li class="pic-item">
                                    <a href="" onClick="fnViewDiary(<% =arrCList(0,intCLoop) %>,'list');return false;">
                                        <div class="thumbnail"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_<% =Format00(2,arrCList(3,intCLoop)) %>.jpg" alt=""></div>
                                        <div class="desc">
                                            <div class="tit"><% =arrCList(2,intCLoop) %></div>
                                            <div class="userid"><% =printUserId(arrCList(1,intCLoop),2,"*") %></div>
                                            <div class="stamp"><% =FormatNumber(arrCList(4,intCLoop),0) %></div>
                                        </div>
                                    </a>
                                    <% if ((GetLoginUserID = arrCList(1,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(1,intCLoop)<>"") then %><button type="button" class="btn-del" onClick="fnDelDiary(<% =arrCList(0,intCLoop) %>);">삭제</button><% end if %>
                                </li>
                            <% Next %>
                            </ul>
                            <div class="paging">
                                <%=fnDisplayPagingDiary(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
                            </div>
                        <% end if %>
<!-- #include virtual="/lib/db/dbclose.asp" -->