<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66216
Else
	eCode   =  80410
End If

dim currenttime
	currenttime =  date()

dim userid, commentcount, i
	userid = GetEncLoginUserID()
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload
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

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
iCPageSize = 7	

'데이터 가져오기
set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = userid
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수
	
	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
set cEComment = nothing

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>

<script type="text/javascript">
$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
	<% end if %>
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#tenCmtList").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10) >= "2017-09-10" and left(currenttime,10) <= "2017-10-25" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 then %>
				alert("코멘트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (!$("#frmCom input[name='spoint']:checked").val()){
					alert("코멘트 아이콘을 선택해주세요.");
					return false;
				}

				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 800){
					alert("코멘트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}
				frm.action = "/event/16th/comment_process.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/")%>');
		return false;
	<% end if %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}
function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/16th/")%>');
		return false;
	<% end if %>
	}
}
</script>

<!-- 코멘트 작성 -->
<div id="comment-write" class="comment-write">
<form name="frmcom" id="frmCom" method="post" onSubmit="return false;" style="margin:0px;">
<input type="hidden" name="eventid" value="<%=eCode%>">
<input type="hidden" name="com_egC" value="<%=com_egCode%>">
<input type="hidden" name="bidx" value="<%=bidx%>">
<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
<input type="hidden" name="iCTot" value="">
<input type="hidden" name="mode" value="add">
<input type="hidden" name="isMC" value="<%=isMyComm%>">
<input type="hidden" name="pagereload" value="ON">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/txt_comment_v2.png" alt="텐바이텐의 16번째 생일을 축하해주세요!" /></h3>
	<div class="select-icon">
		<div><input type="radio" id="select1" name="spoint" value="1" /><label for="select1"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_select_1.png" alt="축하케이크 선택" /></label></div>
		<div><input type="radio" id="select2" name="spoint" value="2" /><label for="select2"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_select_2.png" alt="선물상자 선택" /></label></div>
		<div><input type="radio" id="select3" name="spoint" value="3" /><label for="select3"><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_select_3.png" alt="하트풍선 선택" /></label></div>
	</div>
	<div class="write-cont">
		<textarea cols="50" rows="5" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" placeholder="3가지 아이콘 중 하나를 선택 후 축하글을 남겨주세요 :)" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %><%END IF%></textarea>
		<button type="button" class="btn-submit" onclick="jsSubmitComment(document.frmcom); return false;">축하글<br />남기기</button>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/bg_textarea.png" alt="" /></div>
	</div>
</form>
<form name="frmdelcom" method="post" action = "/event/16th/comment_process.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="com_egC" value="<%=com_egCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="pagereload" value="ON">
</form>
</div>


<% IF isArray(arrCList) THEN %>
<!-- 코멘트 리스트 -->
<div class="comment-list" id="tenCmtList">
	<ul>
	<% For intCLoop = 0 To UBound(arrCList,2) %>
		<li class="cmt<%=arrCList(3,intCLoop)%>">
			<div class="info">
			<% If ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") Then %>
				<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="delete">X삭제</a>
			<% End If %>
				<p class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></p>
				<p class="writer">
					<% If arrCList(8,intCLoop) <> "W" Then %><img src="http://webimage.10x10.co.kr/eventIMG/2017/16th/80410/m/ico_mobile.png" alt="모바일에서 작성" /><% end if %>
					<%=printUserId(arrCList(2,intCLoop),2,"*")%>&nbsp;/&nbsp;<%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %>
				</p>
			</div>
			<div class="comment">
				<p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
			</div>
		</li>
	<% next %>
	</ul>
	<div class="pagingV15a">
		<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
	</div>
</div>
<% end if %>
