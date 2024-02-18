<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event59086Cls.asp" -->
<%
dim eCode, vUserID, vEcodeLink
	vUserID = GetLoginUserID()
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21460"
		vEcodeLink = "21468"
	Else
		eCode = "59086"
		vEcodeLink = "59255"
	End If

Dim cEvent, vArrBest, vArrList, vPage, vTotalCount, vTotalPage, vPageSize, iCPerCnt, i, vSort, vIsPaging
	vPage = getNumeric(requestCheckVar(Request("page"),5))
	If vPage = "" Then vPage = 1 End If
	vSort = requestCheckVar(Request("sort"),1)
	vIsPaging = requestCheckVar(Request("paging"),1)
	vPageSize = 9
	iCPerCnt = 10
	If vSort = "" Then vSort = 0 End If
	
	Set cEvent = New evt_59086
	'vArrBest = cEvent.fnEvent_59086_Best
	
	cEvent.FPageSize = vPageSize
	cEvent.FCurrPage = vPage
	cEvent.FRectOrderBy = vSort
	cEvent.FRectUserid = vUserID
	cEvent.FRectEventID = eCode
	vArrList = cEvent.fnEvent_59086_List
	
	vTotalCount = cEvent.FTotalCount
	vTotalPage = cEvent.FTotalPage
	Set cEvent = Nothing
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title></title>
<style type="text/css">
.mEvt59255 {background-color:#fff; margin-bottom:-50px; padding-bottom:50px;}
.mEvt59255 img {vertical-align:top;}
.evtTap {position:relative; width:100%;}
.evtTap ul {position:absolute; left:0; top:0; right:0; bottom:0; overflow:hidden;}
.evtTap ul li {float:left; width:33.333%; height:50%;}
.evtTap ul li a {display:block; width:100%; height:100%; text-indent:-999em; overflow:hidden;}
.cmtSelect {font-size:11px; color:#222; text-align:center; font-family:dotum, '돋움', arial, sans-serif;}
.cmtSelect ul {overflow:hidden; padding:40px 5px 15px 5px;}
.cmtSelect ul li {float:left; width:33.333%;}
.cmtSelect ul li input[type=radio] {-webkit-appearance:none; -webkit-border-radius:0; border:none; width:102px; height:119px; background-repeat:no-repeat; background-position:center top; background-size:100%;}
.cmtSelect ul li input[type=radio]:checked {background-position:center bottom;}
.cmtSelect ul li .selectQ1 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_cmt1.png);}
.cmtSelect ul li .selectQ2 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_cmt2.png);}
.cmtSelect ul li .selectQ3 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_cmt3.png);}
.cmtSelect .cmtWrite {padding:10px;}
.cmtSelect .cmtWrite textarea {width:100%; border:1.5px solid #ddd; -webkit-appearance:none; -webkit-border-radius:0; font-size:11px; font-family:dotum, '돋움', arial, sans-serif;}
.cmtSelect .btB1 a {font-size:15px;}
.cmtJobList {padding:20px 0;}
.cmtJobList ul {border-bottom:1px solid #d2d2d2; padding:0 10px 10px 10px;}
.cmtJobList li {padding:10px 0;}
.cmtJobList li:first-child {padding-top:0;}
.cmtJobList li .cmtBox {background-color:#f4f4f4; background-repeat:no-repeat; background-position:21px 14px; padding:15px 20px 45px 20px; font-size:11px; font-family:dotum, '돋움', arial, sans-serif; color:#777; position:relative; background-size:22px 18px;}
.cmtJobList li.q01 .cmtBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_bg01.png);}
.cmtJobList li.q02 .cmtBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_bg02.png);}
.cmtJobList li.q03 .cmtBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_bg03.png);}
.cmtJobList li .cmtBox .cmtInfo {position:absolute; left:0; bottom:0; right:0; background-color:#e9e9e9; height:30px; overflow:hidden;}
.cmtJobList li .cmtBox .cmtInfo .like {float:left; height:30px; line-height:30px; color:#999; font-family:verdana, tahoma, sans-serif; font-weight:bold; padding-left:32px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/ico_like.png) 18px 50% no-repeat; background-size:12px 9px;}
.cmtJobList li .cmtBox .cmtInfo .likeBtn {float:right; width:87px; height:30px;}
.cmtJobList li .cmtBox .cmtInfo .likeBtn em {text-indent:-999em; overflow:hidden; display:block; width:100%; height:100%; background:#bbb url(http://webimage.10x10.co.kr/eventIMG/2015/59255/btn_like.png) 50% 50% no-repeat; background-size:42px 12px; cursor:pointer;}
.cmtJobList li .cmtBox .cmtInfo .likeBtn em.thisMyLike {background-color:#d60000; cursor:default;}
.cmtJobList li .cmtBox .cmt {padding-top:8px; line-height:1.2;}
.cmtJobList li .cmtBox .write {padding-top:8px; position:relative;}
.cmtJobList li .cmtBox .write em {padding-left:6px;}
.cmtJobList li .cmtBox .write .button {position:absolute; right:0; bottom:-4px;}
.cmtJobList li .cmtBox .cmtNo {text-align:right; color:#aaa; height:15px;}
.cmtJobList li .cmtBox .moWrite {width:9px; height:15px; margin:-2px 6px 0 0;}
@media all and (min-width:480px){
	.cmtSelect {font-size:16px;}
	.cmtSelect ul {padding:60px 7px 22px 7px;}
	.cmtSelect ul li input[type=radio] {width:153px; height:178px;}
	.cmtSelect .cmtWrite {padding:15px;}
	.cmtSelect .cmtWrite textarea {border:2px solid #ddd; font-size:16px;}
	.cmtSelect .btB1 a {font-size:22px;}
	.cmtJobList {padding:30px 0;}
	.cmtJobList ul {border-bottom:2px solid #d2d2d2; padding:0 15px 15px 15px;}
	.cmtJobList li {padding:15px 0;}
	.cmtJobList li .cmtBox {background-position:31px 21px; padding:22px 30px 68px 30px; font-size:16px; background-size:33px 27px;}
	.cmtJobList li .cmtBox .cmtInfo {height:45px;}
	.cmtJobList li .cmtBox .cmtInfo .like {height:45px; line-height:45px; padding-left:48px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/59255/ico_like.png) 27px 50% no-repeat; background-size:18px 13px;}
	.cmtJobList li .cmtBox .cmtInfo .likeBtn {width:130px; height:45px;}
	.cmtJobList li .cmtBox .cmtInfo .likeBtn em {background-size:63px 18px;}
	.cmtJobList li .cmtBox .cmt {padding-top:12px;}
	.cmtJobList li .cmtBox .write {padding-top:12px;}
	.cmtJobList li .cmtBox .write em {padding-left:9px;}
	.cmtJobList li .cmtBox .write .button {bottom:-6px;}
	.cmtJobList li .cmtBox .cmtNo {height:22px;}
	.cmtJobList li .cmtBox .moWrite {width:13px; height:22px; margin:-3px 9px 0 0;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<script type="text/javascript">
function jsLoginLogin(){
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&vEcodeLink&"")%>');
		return false;
	<% end if %>
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsLoginLogin();
	}
}

function jsGoPage(a) {
	document.frmGubun2.page.value = a;
	document.frmGubun2.submit();
}

function jsGoSort(a) {
	document.frmGubun2.page.value = 1;
	document.frmGubun2.sort.value = a;
	document.frmGubun2.submit();
}

function jsSubmitComment(){
	var frm = document.frmcom;
	if(frm.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
	jsLoginLogin();
	return;
	}
	
	<% If vUserID = "" Then %>
	jsLoginLogin();
	return;
	<% End If %>

	<% If vUserID <> "" Then %>
		if(!frmcom.question[0].checked && !frmcom.question[1].checked && !frmcom.question[2].checked)
		{
			alert("질문을 선택하세요!")
			return;
		}

		if(frm.txtcomm.value == "100자 이내로 입력해주세요."){
		    alert("코멘트를 입력해주세요!");
			document.frmcom.txtcomm.value="";
		    frm.txtcomm.focus();
		    return;
		}
		
		if(!frm.txtcomm.value){
			alert("코멘트를 입력해주세요!");
			frm.txtcomm.focus();
			return;
		}
		
		if(GetByteLength(frm.txtcomm.value)>200){
			alert('100자 까지 가능합니다.');
		    frm.txtcomm.focus();
		    return;
		}
		
	
	   frm.action = "/event/etc/doEventSubscript59086.asp";
	   frm.submit();
	<% End If %>

}

function jsChklogin11(blnLogin){
	if (blnLogin == "True"){
		if(document.frmcom.txtcomm.value == "100자 이내로 입력해주세요." ){
			document.frmcom.txtcomm.value="";
		}
		return true;
	} else {
		jsLoginLogin();
	}

	return false;
}

function jsChkUnblur(){
	if(document.frmcom.txtcomm.value ==""){
		document.frmcom.txtcomm.value = "100자 이내로 입력해주세요."
	}
}

function jsLikeIt(i,g){
	<% If vUserID <> "" Then %>
		$('input[id="idx"]').val(i);
		$('input[id="lb"]').val(g);
		frmGubun1.gubun.value = "2";
		frmGubun1.submit();
	<% Else %>
		jsLoginLogin();
		return;
	<% End If %>
}

function jsGoDel(i) {
	if(confirm("선택하신 글을 삭제하시겠습니까?\n\n※삭제한 글은 복구가 안됩니다.") == true) {
		frmGubun1.idx.value = i;
		frmGubun1.gubun.value = "4";
		frmGubun1.submit();
     }
}

</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt49092">
		<div class="mEvt59255">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_tit.png" alt="파란만장 취업백서" /></h2>
			<div class="evtTap">
				<ul>
					<li><a href="eventmain.asp?eventid=59251" target="_top">청춘상담</a></li>
					<li><a href="eventmain.asp?eventid=59252" target="_top">자격요건</a></li>
					<li><a href="eventmain.asp?eventid=59253" target="_top">모집부문</a></li>
					<li><a href="eventmain.asp?eventid=59254" target="_top">서류전형</a></li>
					<li><a href="eventmain.asp?eventid=59255" target="_top">임원면접</a></li>
					<li><a href="eventmain.asp?eventid=59256" target="_top">최종합격</a></li>
				</ul>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_tab.png" alt="파란만장 취업백서 절차" /></p>
			</div>
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_subtit.png" alt="Comment Event" /></h3>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_cmt_txt.png" alt="아래의 3가지 면접관이 가장 많이 묻는 예상 질문 중 하나를 선택하여 자신이 생각하는 모법 답안을 댓글로 남겨주세요." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/59255/59255_gift.png" alt="면접 필수품 선물" /></p>
			<form name="frmcom" method="post" action="/event/etc/doEventSubscript59086.asp" style="margin:0px;" target="prociframe">
			<input type="hidden" name="gubun" value="1">
			<div class="cmtSelect">
				<ul>
					<li><input type="radio" class="selectQ1" name="question" value="1" /></li>
					<li><input type="radio" class="selectQ2" name="question" value="2" /></li>
					<li><input type="radio" class="selectQ3" name="question" value="3" /></li>
				</ul>
				<p>3가지 질문 중 하나를 선택한 후 댓글을 남겨주세요!</p>
				<p class="cmtWrite"><textarea rows="5" name="txtcomm" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%> autocomplete="off" maxlength="100">100자 이내로 입력해주세요.</textarea></p>
				<p><span class="button btB1 btRed cWh1"><a href="" onClick="jsSubmitComment();return false;">입 력</a></span></p>
			</div>
			</form>
			<div class="cmtJobList" id="cmtListList">
				<p class="rt inner10">
					<span class="<%=CHKIIF(vSort="0","button btS1 btRedBdr cRd1","button btS1 btGryBdr cGy1")%>"><a href="" onClick="jsGoSort('0');return false;">NEW순</a></span>
					<span class="<%=CHKIIF(vSort="1","button btS1 btRedBdr cRd1","button btS1 btGryBdr cGy1")%>"><a href="" onClick="jsGoSort('1');return false;">LIKE순</a></span>
				</p>
				<ul>
				<% If isArray(vArrList) Then %>
					<% For i = 0 To UBound(vArrList,2)	'A.idx, A.userid, A.question, A.comment, A.likeCnt, A.regdate, A.device %>
					<li class="q0<%=vArrList(2,i)%>">
						<div class="cmtBox">
							<p class="cmtNo">
							<% If vArrList(6,i) = "m" OR vArrList(6,i) = "a" Then %>
							<img src="http://webimage.10x10.co.kr/eventIMG/2015/59255/ico_mobile.png" alt="모바일에서 작성된 글" class="moWrite" />
							<% End If %> No.<%=vTotalCount-i-(vPageSize*(vPage-1))%></p>
							<p class="cmt"><%=db2html(vArrList(3,i))%></p>
							<p class="write"><%=FormatDate(vArrList(5,i),"0000.00.00")%> <em><%=printUserId(vArrList(1,i),2,"*")%></em>
							<% If vUserID = vArrList(1,i) Then %>
							&nbsp;<span class="button btS2 btWht cBk1"><a href="" onClick="jsGoDel('<%=vArrList(0,i)%>'); return false;">삭제</a></span>
							<% End If %>
							</p>
							<p class="cmtInfo">
								<span class="like" id="listlikecount<%=vArrList(0,i)%>"><%=vArrList(4,i)%></span>
								<span class="likeBtn" id="listlikecountBt<%=vArrList(0,i)%>">
									<% If vArrList(7,i) = "x" Then %>
									<em onClick="jsLikeIt('<%=vArrList(0,i)%>','l'); return false;">이글을 좋아합니다</em>
									<% Else %>
									<em class="thisMyLike">이글을 좋아합니다</em>
									<% End If %>
								</span><!-- for dev msg : 버튼 클릭후 클래스 추가해주세요 -->
							</p>
						</div>
					</li>
					<% Next %>
				<% End If %>
				</ul>
				<%=fnDisplayPaging_New(vPage,vTotalCount,vPageSize,iCPerCnt,"jsGoPage")%>
			</div>
			<!-- 코멘트 리스트 -->
		</div>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
	<form name="frmGubun1" method="post" action="/event/etc/doEventSubscript59086.asp" style="margin:0px;" target="prociframe">
	<input type="hidden" name="gubun" value="">
	<input type="hidden" id="lb" name="lb" value="">
	<input type="hidden" id="idx" name="idx" value="">
	</form>
	<form name="frmGubun2" method="post" action="#cmtListList" style="margin:0px;">
	<input type="hidden" name="page" value="<%=vPage%>">
	<input type="hidden" name="sort" value="<%=vSort%>">
	<input type="hidden" name="paging" value="o">
	</form>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->