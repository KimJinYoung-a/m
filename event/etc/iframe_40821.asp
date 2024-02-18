<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<%

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20875
Else
	eCode   =  40820
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt
	Dim cate


	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 5		'한 페이지의 보여지는 열의 수
	iCPerCnt = 5		'보여지는 페이지 간격

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<script type="text/javascript">

<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function goPage(page)
	{
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked)){
	    alert("원하는 날짜를 선택해주세요.");
	    return false;
	   }

	   if(!(frm.com_egC[0].checked||frm.com_egC[1].checked||frm.com_egC[2].checked)){
	    alert("원하는 인원을 선택해주세요.");
	    return false;
	   }


	   if(!frm.txtcomm.value||frm.txtcomm.value=="100자 이내로 입력해주세요."){
	    alert("신청이유를 남겨주세요");
	    frm.txtcomm.focus();
	    document.frmcom.txtcomm.value="";
	    return false;
	   }

	   frm.action = "/event/etc/doEventSubscript40821.asp";
	   return true;

	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm.value =="100자 이내로 입력해주세요."){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur()
	{
		if(document.frmcom.txtcomm.value ==""){
			document.frmcom.txtcomm.value="100자 이내로 입력해주세요.";
		}
	}


//-->
</script>
<style type="text/css">
	.mEvt40821 .cmtSelect {overflow:hidden; padding:0 5.5%;}
	.mEvt40821 .cmtSelect table {width:100%;}
	.mEvt40821 .cmtSelect th {text-align:center; background:#999;}
	.mEvt40821 .cmtSelect td {text-align:center; width:20%; padding:0; margin:0;}
	.mEvt40821 .cmtSelect td p {padding-bottom:5px;}
	.mEvt40821 .cmtWrite {background:url(http://fiximage.10x10.co.kr/m/event/40821/40821_bg2.png) left top repeat-y; background-size:100%;}
	.mEvt40821 .cmtWrite dl {padding:0 6% 6% 6%; margin-top:15px;}
	.mEvt40821 .cmtWrite dl dd {padding-top:0.5em; text-align:center;}
	.mEvt40821 .cmtList {background:#baf0fb; padding:2.08333%;}
	.mEvt40821 .cmtList li {padding:2.08333% 2.08333% 2.08333% 80px; background:#fff; overflow:hidden; margin:10px 0; position:relative; vertical-align:top;}
	.mEvt40821 .cmtList .sltDate {position:absolute; left:2.08333%; top:7px; width:63px; height:114px; background-repeat:no-repeat; background-position:center center; background-size:49px 67px; float:left;}
	.mEvt40821 .cmtList .date01 .sltDate {background-color:#ffe654; background-image:url(http://fiximage.10x10.co.kr/m/event/40821/40821_opt01.png);}
	.mEvt40821 .cmtList .date02 .sltDate {background-color:#88dec0; background-image:url(http://fiximage.10x10.co.kr/m/event/40821/40821_opt02.png);}
	.mEvt40821 .cmtList .cmt {text-align:left; font-size:0.75em; color:#888;}
	.mEvt40821 .cmtList .cmt .cmtNo {font-weight:bold; padding:0 0 2px 0;}
	.mEvt40821 .cmtList .cmt .cmtCont {padding:5px 0; border-top:1px solid #ddd; border-bottom:1px solid #ddd; min-height:65px; line-height:1.2;}
	.mEvt40821 .cmtList .cmt .cmtInfo {padding-top:3px;}
	.mEvt40821 .cmtList .cmt .cmtInfo span {padding-right:8px;}
	.mEvt40821 .cmtList .cmt .cmtInfo span strong {border-right:1px solid #ddd; padding-right:10px; line-height:11px; height:11px; display:inline-block;}
	.mEvt40821 .photoView {background:url(http://fiximage.10x10.co.kr/m/event/40821/40821_bg.png) left top repeat-y; background-size:100%;}
	@media all and (orientation:landscape){
	.cmtList .sltDate {top:12px;}
	}
</style>


<!-- 헤더영역 -->
<div selected="true">
	<div class="mEvt40821">
		<p><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_head.png" alt="ONLY YOU ONLY 1TABLE" style="width:100%;" /></p>
		<div class="photoView">
			<img src="http://fiximage.10x10.co.kr/m/event/40821/40821_photo01.png" alt="one Table 사진" style="width:100%" />
		</div>
		<p><a href="http://blog.naver.com/tohko02" target="_blank"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_img01.png" alt="여러분을 초대합니다." style="width:100%;" /></a></p>
		<p><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_img02.png" alt="함께 하고 싶은 사람들을 떠올리며 1 Table Party를 신청하세요!" style="width:100%;" /></p>
		<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<div class="cmtWrite">
			<div class="cmtSelect">
				<table cellpadding="0" cellspacing="5">
					<thead>
						<tr>
							<th colspan="2"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_txt01.png" alt="원하는 날짜를 선택해주세요" style="width:100%" /></th>
							<th colspan="3"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_txt02.png" alt="원하는 인원을 선택해주세요" style="width:100%;" /></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								<p><label for="sltDate1"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_opt01.png" alt="04.05 PM 8:00" style="width:100%;" /></label></p>
								<p><input type="radio" name="spoint" value="1" id="sltDate1" /></p>
							</td>
							<td>
								<p><label for="sltDate2"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_opt02.png" alt="04.13 PM 8:00" style="width:100%;" /></label></p>
								<p><input type="radio" name="spoint" value="2" id="sltDate2" /></p>
							</td>
							<td>
								<p><label for="sltPeople1"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_opt03.png" alt="2명" style="width:100%;" /></label></p>
								<p><input type="radio" name="com_egC" value="2" id="sltPeople1" /></p>
							</td>
							<td>
								<p><label for="sltPeople2"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_opt04.png" alt="3명" style="width:100%;" /></label></p>
								<p><input type="radio" name="com_egC" value="3" id="sltPeople2" /></p>
							</td>
							<td>
								<p><label for="sltPeople3"><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_opt05.png" alt="4명" style="width:100%;" /></label></p>
								<p><input type="radio" name="com_egC" value="4" id="sltPeople3" /></p>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<dl>
				<dt><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_cmtit.png" alt="신청이유" style="width:19.76190%;" /></dt>
				<dd><textarea name="txtcomm" maxlength="100" style="border:1px solid #ddd; width:99%; height:50px; margin:0 auto; -webkit-appearance:none; -webkit-border-radius:0; font-size:0.75em; color:#888;" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>>100자 이내로 입력해주세요.</textarea></dd>
				<dd><input type="image" src="http://fiximage.10x10.co.kr/m/event/40821/40821_btn.png" alt="신청하기" style="width:30.71428%;" /></dd>
			</dl>
		</div>
		</form>
		<p><img src="http://fiximage.10x10.co.kr/m/event/40821/40821_img03.png" alt="당첨되신 고객은 개별적으로 당첨 연락을 드릴 예정입니다. 기본 정보지에 있는 연락처를 꼭 확인 해주시기 바랍니다." style="width:100%;" /></p>
		<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript40821.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
		<% IF isArray(arrCList) THEN %>
		<div class="cmtList">
			<ul>
			<% For intCLoop = 0 To UBound(arrCList,2)%>
				<li class="date0<%=chkiif(arrCList(3,intCLoop)="0","1",arrCList(3,intCLoop))%>">
					<p class="sltDate"></p>
					<div class="cmt">
						<p class="cmtNo">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
						<p class="cmtCont"><%=nl2br(arrCList(1,intCLoop))%></p>
						<p class="cmtInfo">
							<span><strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong></span>
							<span><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%></span>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')"><img src="http://fiximage.10x10.co.kr/web2012/common/btn_cmt_del.gif" alt="삭제" class="icoImg" /></a><% end if %>
						</p>
					</div>
				</li>
			<% Next %>
			</ul>
		</div>
	<div id="paging">
		<%=fnPaging("iCC", iCTotCnt , iCCurrpage, iCPageSize, iCPerCnt)%>
	</div>
	<% End if %>
	</div>
</div>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
