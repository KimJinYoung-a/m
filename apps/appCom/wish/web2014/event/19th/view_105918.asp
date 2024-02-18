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
' Description :  19주년 그림일기장 뷰
' History : 2020-09-25 정태훈
'#################################################################
%>
<%
Dim bbs_idx, cEvtBBC, viewdiv, sortdiv, searchTxt
bbs_idx	= requestCheckVar(Request("bbs_idx"),10)	'현재 페이지 번호
viewdiv	= requestCheckVar(Request("viewdiv"),10)	 '뷰구분
sortdiv	= requestCheckVar(Request("sortdiv"),1)	        '정렬구분
searchTxt	= requestCheckVar(Request("searchtxt"),16) '검색어
if sortdiv="" then sortdiv=1

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode = 103233
Else
	eCode = 105918
End If

if bbs_idx="" then 
	response.write "<script>alert('데이터를 받아오는데 실패하였습니다.');</script>"
	response.end
end if

'데이터 가져오기
set cEvtBBC = new ClsEvtBBS
cEvtBBC.FEBidx 	= bbs_idx
cEvtBBC.FsearchTxt	= searchTxt
cEvtBBC.FsortDiv = sortdiv
cEvtBBC.fnGetBBSContent		'리스트 가져오기

if cEvtBBC.Fscore = "" then cEvtBBC.Fscore=0

cEvtBBC.FECode = eCode
cEvtBBC.FgoodCNT = cEvtBBC.Fscore
if viewdiv="best" then
cEvtBBC.fnGetBestDiaryPrevious
cEvtBBC.fnGetBestDiaryNext
else
cEvtBBC.fnGetDiaryPrevious
cEvtBBC.fnGetDiaryNext
end if
function WeekKor(weeknum)
    if weeknum="1" then
        WeekKor="일"
    elseif weeknum="2" then
        WeekKor="월"
    elseif weeknum="3" then
        WeekKor="화"
    elseif weeknum="4" then
        WeekKor="수"
    elseif weeknum="5" then
        WeekKor="목"
    elseif weeknum="6" then
        WeekKor="금"
    elseif weeknum="7" then
        WeekKor="토"
    end if
end function
%>
						<div class="diary-wrap">
							<div class="diary-head">
								<span class="name"><input type="text" value="<% =cEvtBBC.FuserName %>" readonly></span>
								<!-- for dev msg : 해당 날짜 --><span class="date"><em><%=month(cEvtBBC.Fegdate)%></em><em><%=day(cEvtBBC.Fegdate)%></em><em><%=WeekKor(weekday(cEvtBBC.Fegdate))%></em></span>
								<span class="weather">
									<em class="w1"><input type="radio" disabled<% if cEvtBBC.Fweather="1" then response.write " checked" %>><label for=""></label></em>
									<em class="w2"><input type="radio" disabled<% if cEvtBBC.Fweather="2" then response.write " checked" %>><label for=""></label></em>
									<em class="w3"><input type="radio" disabled<% if cEvtBBC.Fweather="3" then response.write " checked" %>><label for=""></label></em>
									<em class="w4"><input type="radio" disabled<% if cEvtBBC.Fweather="4" then response.write " checked" %>><label for=""></label></em>
								</span>
							</div>
							<div class="diary-pic"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_pic_<% =Format00(2,cEvtBBC.Fpicture) %>.jpg" alt=""></div>
							<div class="diary-foot">
								<div class="tit"><input type="text" value="<% =cEvtBBC.Fsubject %>" readonly></div>
								<div class="con">
									<textarea cols="30" rows="10" readonly><% =cEvtBBC.Fcontent %></textarea>
								</div>
							</div>
						</div>
						<!-- for dev msg : 도장 클릭시 추천 -->
						<button type="button" class="btn-stamp" onClick="fnGoodStemp(<% =bbs_idx %>);"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_stamp.png" alt="클릭"></button>
						<div class="stamp"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/105918/m/img_stamp_checked.png" alt="도장"></div>
                        <% if cEvtBBC.FPreviousIDX<>"0" then %>
                            <button button type="button" class="post-prev" onclick="fnViewDiary(<%=cEvtBBC.FPreviousIDX%>,'<%=viewdiv%>')">이전글</button>
                        <% end if%>
                        <% if cEvtBBC.FNextIDX<>"0" then %>
                            <button type="button" class="post-next" onclick="fnViewDiary(<%=cEvtBBC.FNextIDX%>,'<%=viewdiv%>')">다음글</button>
                        <% end if%>
<% set cEvtBBC = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->