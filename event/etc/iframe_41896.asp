<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/header.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->

<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20889
Else
	eCode   =  41895
End If

dim cEComment ,blnFull, cdl_e, com_egCode, bidx, blnBlogURL, strBlogURL, LinkEvtCode
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt

	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	'eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	LinkEvtCode		= requestCheckVar(Request("linkevt"),10) '관련 이벤트 코드번호(온라인 메인 이벤트 코드)
	cdl_e			= requestCheckVar(Request("cdl_e"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL		= requestCheckVar(Request("blnB"),10)

	If eCode = "" Then
		Response.Write "<script>alert('올바른 접근이 아닙니다.');window.close();</script>"
		dbget.close()
		Response.End
	End If

	IF blnFull = "" THEN blnFull = True
	IF blnBlogURL = "" THEN blnBlogURL = False

	IF iCCurrpage = "" THEN
		iCCurrpage = 1
	END IF
	IF iCTotCnt = "" THEN
		iCTotCnt = -1
	END IF
	IF LinkEvtCode = "" THEN
		LinkEvtCode = 0
	END IF

	iCPerCnt = 10		'보여지는 페이지 간격
	iCPageSize = 10		'한 페이지의 보여지는 열의 수

	'데이터 가져오기
	set cEComment = new ClsEvtComment

	if LinkEvtCode>0 then
		cEComment.FECode 		= LinkEvtCode
	else
		cEComment.FECode 		= eCode
	end if
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

	dim nextCnt		'다음페이지 게시물 수
	if (iCTotCnt-(iCPageSize*iCCurrpage)) < iCPageSize then
		nextCnt = (iCTotCnt-(iCPageSize*iCCurrpage))
	else
		nextCnt = iCPageSize
	end if
%>
<script type="text/javascript">
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}
	 	function jsGoPage(iP){
			document.frmSC.iC.value = iP;
			document.frmSC.submit();
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

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked)){
	    alert("감사의 마음을 전하고픈 사람을 선택해주세요.");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="감사의 메시지를 작성해 주세요(최대 100자)"){
	    alert("코멘트를 입력해주세요");
	    frm.txtcomm.focus();
	    document.frmcom.txtcomm.value="";
	    return false;
	   }
	   if(GetByteLength(frm.txtcomm.value)>200){
			alert('문구 입력은 한글 최대 100자 까지 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}
	   frm.action = "/event/etc/doEventSubscript41896.asp";
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
			if(document.frmcom.txtcomm.value =="감사의 메시지를 작성해 주세요(최대 100자)"){
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
			document.frmcom.txtcomm.value="감사의 메시지를 작성해 주세요(최대 100자)";
		}
	}
</script>
<style type="text/css">
	.evt41896 img {vertical-align:top;}
	.evt41896 .tagSelect {overflow:hidden; background-color:#fff9e5; padding:0 10px 15px 10px;}
	.evt41896 .tagSelect li {float:left; width:33.33333%; text-align:center;}
	.evt41896 .tagSelect li p {padding:5px 0;}
	.evt41896 .cmtWrite {background:url(http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_bg.png) left top repeat; background-size:3px 3px; padding:12px 18px; border-bottom:2px solid #ffbfbf; text-align:center;}
	.evt41896 .cmtWrite textarea {border:3px solid #ff8585; font-size:12px; color:#797979; padding:5px;}
	.evt41896 .cmt {text-align:left; color:#b8b8b8; font-size:9px;}
	.evt41896 .cmt span {letter-spacing:-2px;}
	.evt41896 .cmtList {border-top:none;}
	.evt41896 .cmtList li {margin:4px 0; border-bottom:none;}
	.evt41896 .cmtList li {background-position:6px 10px; background-repeat:no-repeat; background-size:70px 52px; padding:10px 11px 10px 76px; min-height:52px;}
	.evt41896 .cmtList li.thanks01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_cmt_bg1.png); background-color:#ff9786;}
	.evt41896 .cmtList li.thanks02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_cmt_bg2.png); background-color:#67dec3;}
	.evt41896 .cmtList li.thanks03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_cmt_bg3.png); background-color:#ffcb4f;}
	.evt41896 .cmtList li .cmtBox {background-color:#fff;}
	.evt41896 .cmtList li .cmtBox > div {color:#565656; font-size:10px; padding:10px 12px; line-height:1.2; position:relative;}
	.evt41896 .cmtList li .cmtBox > div .cmtCont {padding-bottom:5px;}
	.evt41896 .cmtList li .cmtBox p.cmtInfo {overflow:hidden; border-top:1px solid #e1e1e1; padding-top:5px;}
	.evt41896 .cmtList li .cmtBox p.cmtInfo strong {color:#000; font-weight:normal;}
</style>
<!-- content area -->
<div class="content" id="contentArea">
	<div class="evt41896">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_head.png" alt="Thank You Very Much!" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_cont1.png" alt="카네이션" style="width:100%;" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_cont2.png" alt="감사의 마음을 전하고픈 사람을 선택한 후 메시지를 작성해 주세요!" style="width:100%;" /></p>
		<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<ul class="tagSelect">
			<li>
				<p><input type="radio"  name="spoint" value="1" id="thanks01" /></p>
				<p><label for="thanks01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_tag1.png" alt="부모님" style="width:86px" /></label></p>
			</li>
			<li>
				<p><input type="radio"  name="spoint" value="2" id="thanks02" /></p>
				<p><label for="thanks02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_tag2.png" alt="선생님" style="width:86px" /></label></p>
			</li>
			<li>
				<p><input type="radio"  name="spoint" value="3" id="thanks03" /></p>
				<p><label for="thanks03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_tag3.png" alt="고마운 사람" style="width:86px" /></label></p>
			</li>
		</ul>
		<div class="cmtWrite">
			<textarea title="감사의 메시지를 작성해 주세요" name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%> style="width:77%; height:42px">감사의 메시지를 작성해 주세요(최대 100자)</textarea>
			<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/41896/41896_btn.png" alt="마음 전하기" class="lMar05" style="width:45px;" />
		</div>
		</form>
		<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript41896.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
		<p class="cmt inner5 lh12"><span>&gt;</span>&gt; 통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다.</p>

		<p class="inner5 tMar20 ftMidSm2">Total <strong><%=iCTotCnt%></strong> comments</p>
		<% IF isArray(arrCList) THEN %>
		<ul class="cmtList">
			<% For intCLoop = 0 To UBound(arrCList,2)%>
			<li class="thanks0<%=chkiif(arrCList(3,intCLoop)="0","1",arrCList(3,intCLoop))%>">
				<div class="cmtBox">
					<div>
						<p class="cmtCont"><%=nl2br(arrCList(1,intCLoop))%></p>
						<p class="cmtInfo">
							<span class="ftLt">
								<% If arrCList(8,intCLoop)="M" Then %>
								<img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" alt="모바일에서 작성" style="width:9px" />
								<% End If %>
								<strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong>
								<span class="btn btn6 gryB2 w40B"><% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a><% end if %></span>
							</span>
							<span class="ftRt"><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%></span>
						</p>
					</div>
				</div>
			</li>
			<% Next %>
		</ul>
	<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>

	<% End if %>
	</div>
</div>
			<!-- //content area -->
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->