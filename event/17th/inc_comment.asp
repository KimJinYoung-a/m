<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  89172
Else
	eCode   =  88938 
End If

dim currenttime
	currenttime =  date()

dim userid, commentcount, i
	userid = GetEncLoginUserID()
	commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, vClassFlag, vClassName    
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)	

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
iCPageSize = 4	

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
	// select icon
	// $(".choice li:first-child").addClass("on");
	$(".choice li").click(function(){
		$(".choice li").removeClass("on");
		$(this).addClass("on");
	});
});
//===============================================
$(function(){
	setIcon();
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
		<% If not( left(currenttime,10) >= "2018-09-28" and left(currenttime,10) <= "2018-10-31" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>4 and userid <> "cjw0515" then %>
				alert("코멘트는 5회까지 참여 가능 합니다.");
				return false;
			<% else %>
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 800){
					alert("코멘트를 남겨주세요.\n한글 400자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return false;
				}
				frm.action = "/event/17th/comment_process.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
	<% If isApp="1" or isApp="2" Then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/17th/index.asp")%>');
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
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/17th/index.asp")%>');
		return false;
	<% end if %>
	}
}
function setIcon(){
	var randomNumber = Math.floor(Math.random() * 3);	
	var obj = $(".choice li")[randomNumber];
	obj.classList.add("on");	
    selectIcon(randomNumber+1);			
}
function selectIcon(iconVal){       
    document.frmcom.spoint.value = iconVal;    
}
</script>
<!-- 17주년 코멘트 -->
			<div class="ten-lif ten-comment" id="ten-comment">
					<!-- comment write -->
					<div class="comment-write">
						<form name="frmcom" id="frmCom" method="post" onSubmit="return false;" style="margin:0px;">
                        <input type="hidden" name="eventid" value="<%=eCode%>">
                        <input type="hidden" name="com_egC" value="<%=com_egCode%>">
                        <input type="hidden" name="bidx" value="<%=bidx%>">
                        <input type="hidden" name="iCC" value="<%=iCCurrpage%>">
                        <input type="hidden" name="iCTot" value="">
                        <input type="hidden" name="mode" value="add">
                        <input type="hidden" name="isMC" value="<%=isMyComm%>">
                        <input type="hidden" name="pagereload" value="ON">
                        <input type="hidden" name="spoint" value="1">
							<fieldset>
							<legend>코멘트 작성 폼</legend>
								<h2><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_cmt_evt_v3.png" alt="축하는 셀프! 캐릭터를 골라 텐바이텐의 17주년을 축하해주세요! 총 10분에게 기프트카드 5,000권을 선물로 드립니다! 이벤트 기간은 10월 10일 월요읿 부터 31일 수요일 까지입니다. 당첨자 발표일은 11월 5일 월요일 입니다." /></h2>
								<div class="inner">
									<ul class="choice">
										<li class="ico ico1" onclick="selectIcon(1)"><button type="button" >축하해요!</button></li>
										<li class="ico ico2" onclick="selectIcon(2)"><button type="button" >멋있어요!</button></li>
										<li class="ico ico3" onclick="selectIcon(3)"><button type="button" >고마워요!</button></li>	
									</ul>                            
									<div class="field">
										<textarea title="축하코멘트 작성" cols="60" rows="5" name="txtcomm" id="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%=chkIIF(NOT(IsUserLoginOK), " placeholder='로그인한 후 코멘트를 남길 수 있습니다'", "")%> <%=chkIIF(NOT(IsUserLoginOK), " readonly", "")%>></textarea>
									</div>
                                    <button class="btn-submit" type="button" onclick="jsSubmitComment(document.frmcom); return false;"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_submit.png" alt="입력하기!" /></button>
								</div>
							</fieldset>
						</form>
                        <form name="frmdelcom" method="post" action = "/event/17th/comment_process.asp" style="margin:0px;">
                            <input type="hidden" name="eventid" value="<%=eCode%>">
                            <input type="hidden" name="com_egC" value="<%=com_egCode%>">
                            <input type="hidden" name="bidx" value="<%=bidx%>">
                            <input type="hidden" name="Cidx" value="">
                            <input type="hidden" name="mode" value="del">
                            <input type="hidden" name="pagereload" value="ON">
                        </form>                        
						<p class="caution" id="tenCmtList"><img src="http://webimage.10x10.co.kr/fixevent/event/2018/17th/88938/m/txt_caution_v3.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다." /></p>
					</div>
					<!-- comment list -->     
                    <% IF isArray(arrCList) THEN %>
					<div class="comment-list">
						<ul>
							<!-- for dev msg 
							- 코멘트 4개씩 노출
							- 선택된 축하 메세지별로 cmt1, cmt2, cmt3 클래스 추가
							- 첫번째 세번째 코멘트에 et1 클래스 추가 + <div class="dc-group">..</> 포함 시켜주세요
							-->
                    	<% 
                           For intCLoop = 0 To UBound(arrCList,2)
                                if intCLoop + 1 = 1 or intCLoop + 1 = 3 then
                                    vClassName=" et1"
                                    vClassFlag= true
                                else    
                                    vClassName=""
                                    vClassFlag= false                                
                                end if                                
                         %>                            
							<li class="cmt<%=arrCList(3,intCLoop)%> <%=vClassName%>"> 
								<div class="ico">축하해요</div>
                                <% if vClassFlag then %>
								<div class="dc-group">
									<span class="dc dc1"></span>
									<span class="dc dc2"></span>
								</div>                                
                                <% end if %>
								<div class="info">
									<p class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></p>
									<p class="writer"><% If arrCList(8,intCLoop) <> "W" Then %><i class="mob"></i><% end if %><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
								</div>
								<div class="txt">
									<%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%>
								</div>
								<p class="date"><%= FormatDate(arrCList(4,intCLoop),"0000.00.00") %></p>
                                <% If ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") Then %>
								<button class="delete" type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;"></button>
                                <% end if %>
							</li>
                        <% next %>                            
						</ul>
                        <div class="paging pagingV15a">
                            <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
                        </div>                        						
					</div>
                    <% end if %>                                
				<!-- //comment event -->
			</div>
			<!--// 17주년 메인 -->