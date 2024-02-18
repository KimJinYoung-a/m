<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'#################################################################
' Description : 2022 코멘트 이벤트
' History : 2021.12.16 정태훈
'#################################################################
%>
<%
Dim userid
userid = GetEncLoginUserID()

Dim eCode ,  pagereload
IF application("Svr_Info") = "Dev" THEN
	eCode   =  109436
Else
	eCode   =  115624
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

Function fnEventDisplayPageNavigate(strCurrentPage, intTotalRecord, intRecordPerPage, intBlockPerPage, strJsFuncName)
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
	
	vPageBody = vPageBody & "<ul id=""pagination"">" & vbCrLf
	
	'## 이전 페이지
	If intTotalPage > 5 and intCurrentPage > 3 Then
		vPageBody = vPageBody & "			<li class=""prev btn_arrow""><a href=""javascript:" & strJsFuncName & "(" & prePgNum & ")""><img src=""//webimage.10x10.co.kr/fixevent/event/2021/115624/arrow.png""></a></li>" & vbCrLf
	End If

	'## 현재 페이지
	If intTotalPage > 1 Then
		For intLoop = intStartBlock To intEndBlock
			If intLoop > intTotalPage Then Exit For
			If Int(intLoop) = Int(intCurrentPage) Then
				vPageBody = vPageBody & "			<li><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"" class=""active"">" & intLoop & "</a></li>" & vbCrLf
			Else
				vPageBody = vPageBody & "			<li><a href=""javascript:" & strJsFuncName & "(" & intLoop & ")"">" & intLoop & "</a></li>" & vbCrLf
			End If
		Next
	Else
		vPageBody = vPageBody & "			<li><a href=""javascript:" & strJsFuncName & "(1)"" class=""active"">1</a></li>" & vbCrLf
	End If
	
	'## 다음 페이지
	if intTotalPage > 5 and (intTotalPage-intCurrentPage) > 2 then
		vPageBody = vPageBody & "			<li class=""next btn_arrow""><a href=""javascript:" & strJsFuncName & "(" & intEndBlock+1 & ")"" class=""arrow""><img src=""//webimage.10x10.co.kr/fixevent/event/2021/115624/arrow.png""></a></li>" & vbCrLf
	End If
	
	vPageBody = vPageBody & "</ul>" & vbCrLf
	
	fnEventDisplayPageNavigate = vPageBody
	
End Function

function fnCharacterName(cnum)
    if cnum="1" then
        fnCharacterName="disney"
    elseif cnum="2" then
        fnCharacterName="snoopy"
    elseif cnum="3" then
        fnCharacterName="bbb"
    elseif cnum="4" then
        fnCharacterName="sanrio"
    end if
End Function
%>
					<div class="comment_zone" id="clist">
                    <% If isArray(arrCList) Then %>
                        <% For intCLoop = 0 To UBound(arrCList,2) %>
						<div class="comment <% = fnCharacterName(arrCList(3,intCLoop)) %>" id="list<% = arrCList(0,intCLoop) %>">
							<% if (GetLoginUserID = arrCList(2,intCLoop)) and ( arrCList(2,intCLoop)<>"") then %>
                            <div class="click">
								<a href="" class="btn_close" onclick="fnDelComment(<% = arrCList(0,intCLoop) %>);return false;"></a>
							</div>
                            <% end if %>
							<p class="num">No. <span><%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span></p>
							<p class="user_id"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
							<div class="scrollbar">
								<div class="force-overflow"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></div>
							</div>
						</div>
                        <% Next %>
                    <% end if %>
					</div>
					<div class="page_wrap">
                        <%=fnEventDisplayPageNavigate(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage")%>
					</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->     