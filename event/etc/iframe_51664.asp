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
<!-- #include virtual="/event/etc/event49651Cls.asp" -->
<%

Dim UsName, UsPhone, vtQuery, vUserID
vUserID = GetLoginUserID

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21167
Else
	eCode   =  51664
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
<head>
<title>생활감성채널, 텐바이텐 > 이벤트 > For Me! For You! For Us!</title>
<style type="text/css">
.mEvt51664 img {vertical-align:top; width:100%;}
.mEvt51664 p {max-width:100%;}
.mEvt51664 .applyEvt {padding-bottom:28px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51664/bg_evt_cont.png) 0 0 repeat-y; background-size:100%;}
.mEvt51664 .applyEvt ul {overflow:hidden; padding:25px 8% 8px;}
.mEvt51664 .applyEvt li {float:left; width:50%; padding:0 2% 8px; text-align:center; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt51664 .applyEvt li label {display:block; margin-bottom:4px;}
.mEvt51664 .applyEvt .writeCmt {width:80%; margin:0 auto 22px; }
.mEvt51664 .applyEvt .writeCmt textarea {width:100%; height:65px; border:0; background-color:#e5e5e5; padding:1em; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; font-size:13px; color:#333; font-weight:bold;}
.mEvt51664 .applyEvt .applyBtn {display:block; width:64%; margin:0 auto;}
.mEvt51664 .evtCmtArea {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg4.png) 0 0 repeat-y; background-size:100%;}
.mEvt51664 .evtCmtBox {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg5.png) 0 100% no-repeat; background-size:100%; padding-bottom:30px;}
.mEvt51664 .evtCmtList {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_bg3.png) 0 0 no-repeat; background-size:100%; padding:30px 15px 20px 15px; overflow:hidden; _zoom:1;}
.mEvt51664 .evtCmtList li {position:relative;  margin-top:23px; padding:6px 10px 6px 135px; background-color:#fff; background-repeat:no-repeat; background-position:3px center; background-size:125px 73px;}
.mEvt51664 .evtCmtList li:first-child {margin-top:17px;}
.mEvt51664 .evtCmtList li div {display:table-cell; vertical-align:middle; height:93px; border-left:1px dotted #ccc; font-size:10px; line-height:1; padding-left:16px; border-radius:3px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt51664 .evtCmtList li.type01 {border:3px solid #f96868; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_surprise.png);}
.mEvt51664 .evtCmtList li.type02 {border:3px solid #fa5b9b; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_great.png);}
.mEvt51664 .evtCmtList li.type03 {border:3px solid #6b88f4; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_omg.png);}
.mEvt51664 .evtCmtList li.type04 {border:3px solid #5bdc98; background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_oops.png);}
.mEvt51664 .evtCmtList li .deleteBtn {position:absolute; right:-3px; top:-19px; width:22px; height:19px; border-top-left-radius:11px; border-top-right-radius:11px; -webkit-border-top-left-radius:11px; -webkit-border-top-right-radius:11px; font-size:18px; color:#fff; text-align:center;}
.mEvt51664 .evtCmtList li.type01 .deleteBtn {background:#f96868;}
.mEvt51664 .evtCmtList li.type02 .deleteBtn {background:#fa5b9b;}
.mEvt51664 .evtCmtList li.type03 .deleteBtn {background:#6b88f4;}
.mEvt51664 .evtCmtList li.type04 .deleteBtn {background:#5bdc98;}
.mEvt51664 .evtCmtList li .num {color:#fff; padding:0 8px; border-radius:15px; background:#d0d0d0;}
.mEvt51664 .evtCmtList li p {padding:8px 0; color:#333; font-size:13px; line-height:1.2;}
.mEvt51664 .evtCmtList li .writer {color:#777;}
.mEvt51664 .notiBox {background-color:#fff4d1; padding-bottom:1em;}
.mEvt51664 .notiBox ul {padding:0.2em 1em;}
.mEvt51664 .notiBox li {padding:0 0 0.5em 1em; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_blt.png) 0 5px no-repeat; background-size:6px 4px; color:#777; font-weight:bold; font-size:10px; line-height:12px;}
@media all and (min-width:480px){
	.mEvt51664 .applyEvt .writeCmt textarea {height:100px; font-size:16px;}
	.mEvt51664 .notiBox ul {padding:0.3em 1.5em;}
	.mEvt51664 .notiBox li {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_blt.png) 0 7px no-repeat; background-size:9px 6px; font-size:15px; line-height:18px;}
}
</style>
<script src="/lib/js/swiper-2.1.min.js"></script>
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

	<% If getnowdate>="2014-05-09" and getnowdate<="2014-05-18" Then %>

		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.greet_txt[0].checked||frm.greet_txt[1].checked||frm.greet_txt[2].checked||frm.greet_txt[3].checked)){
	    alert("첫 감탄사를 선택해주세요.");
	    return false;
	   }


	   if(!frm.txtcomm.value||frm.txtcomm.value=="첫 인사를 20자 이내로 적어주세요."){
	    alert("코멘트를 입력해주세요");
	    frm.txtcomm.focus();
	    document.frmcom.txtcomm.value="";
	    return false;
	   }
	   if(GetByteLength(frm.txtcomm.value)>60){
		alert('문구 입력은 한글 최대 30자 까지 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}
	   frm.action = "/event/etc/doEventSubscript51664.asp";
	   frm.submit();

		<% else %>
			alert('이벤트 응모기간이 아닙니다.');
			return false;
		<% end if %>

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
			if(document.frmcom.txtcomm.value =="첫 인사를 20자 이내로 적어주세요."){
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
			document.frmcom.txtcomm.value="첫 인사를 20자 이내로 적어주세요.";
		}
	}

	function jsChkLength()
	{
		if (GetByteLength(document.frmcom.txtcomm.value) > 40)
		{
			alert('문구 입력은 한글 최대 20자 까지 가능합니다.');
		    document.frmcom.txtcomm.focus();
		    return false;
		}
	}

	$(function(){
		showSwiper= new Swiper('.specialSwiper',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true,
			pagination:'.pagination',
			paginationClickable:true,
			speed:300,
			autoplay:3000
		});
		$('.arrow-left').on('click', function(e){
			e.preventDefault()
			showSwiper.swipePrev()
		})
		$('.arrow-right').on('click', function(e){
			e.preventDefault()
			showSwiper.swipeNext()
		});
		//화면 회전시 리드로잉(지연 실행)
		$(window).on("orientationchange",function(){
			var oTm = setInterval(function () {
				showSwiper.reInit();
					clearInterval(oTm);
				}, 1);
		});
	});


</script>


<body>

<!-- content area -->
	<div class="mEvt51664">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_between_head.png" alt="텐바이텐&amp;비트윈 GIFT SHOP OPEN!" /></p>
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/tit_between_forus.png" alt="For Me! For You! For Us!" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/iimg_phone.png" alt="" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/img_between_app.png" alt="커플들의 필수 어플 비트윈! 발렌타인 데이, 크리스마스, 그와 그녀의 생일! 기념일을 더욱 특별하게 만들어 줄 기프트샵을 만나보세요!" /></p>
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greeting.png" alt="기프트샵에 대한 첫 감탄사를 선택하고 첫 인사를 적어주세요! 알콩달콩! 저녁 데이트 선물을 드립니다!" /></h3>
		<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<div class="applyEvt">
			<ul>
				<li>
					<label for="greet01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_surprise.png" alt="Oh~ Surprise!" /></label>
					<input type="radio" id="greet01" name="greet_txt" value="1"/>
				</li>
				<li>
					<label for="greet02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_great.png" alt="Oh~ Great!" /></label>
					<input type="radio" id="greet02" name="greet_txt" value="2"/>
				</li>
				<li>
					<label for="greet03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_omg.png" alt="Oh~ My God!" /></label>
					<input type="radio" id="greet03" name="greet_txt" value="3"/>
				</li>
				<li>
					<label for="greet04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_greet_oops.png" alt="Oh~ Oops!" /></label>
					<input type="radio" id="greet04" name="greet_txt" value="4"/>
				</li>
			</ul>
			<div class="writeCmt"><textarea cols="10" rows="10" name="txtcomm" id="txtcomm" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onfocus="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyup="jsChkLength();">첫 인사를 20자 이내로 적어주세요.</textarea></div>
			<p><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51664/btn_apply.png" alt="이벤트 응모하고 기프트샵 방문하기" class="applyBtn" /></p>
		</div>
		<dl>
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/txt_gift.png" alt="알콩달콩! 저녁 데이트 선물 받으세요~!" /></dt>
			<dd><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/img_gift.png" alt="VIPS 2명/아웃백 5명/도미노 10명/ 콜드스톤 20명" /></dd>
		</dl>
		</form>
		<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript51664.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
		<!-- comment list -->
		<div class="evtCmtArea">
			<% IF isArray(arrCList) THEN %>
			<div class="evtCmtBox">
				<ul class="evtCmtList">
					<% For intCLoop = 0 To UBound(arrCList,2)%>
						<li class="type0<%=arrCList(3,intCLoop)%>">
							<div>
								<span class="num">NO.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></span>
								<p><%=nl2br(arrCList(1,intCLoop))%></p>
								<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>=
							</div>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
								<span class="deleteBtn" onclick="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">&times;</span><!-- 내가 쓴 글일경우 삭제버튼 노출 -->
							<% End If %>
						</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
			</div>
			<% End If %>
		</div>
		<!--// comment list -->
		<div class="notiBox">
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51665/51665_subtit3.png" alt="이벤트 내용" /></dt>
				<dd>
					<ul>
						<li>본 이벤트는 텐바이텐 고객 분들만 참여 가능합니다.</li>
						<li>ID 당 1회만 응모 가능합니다.</li>
						<li>SNS로 알릴 경우, 당첨 확률은 더 올라갑니다.</li>
						<li>기프티콘은 개인정보에 등록하신 휴대폰 번호로 5월 22일 일괄발송됩니다.</li>
					</ul>
				</dd>
			</dl>
		</div>
		<p><a href="http://link.between.us/intent/gift_shop/" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51664/btn_go_between.png" alt="Between 바로가기" /></a></p>
	</div>
<!-- //content area -->
</body>
</html>
<!-- #INCLUDE Virtual="/lib/footer.asp" -->
<!-- #include virtual="/lib/db/dbclose.asp" -->