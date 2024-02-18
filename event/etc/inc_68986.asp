<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "UTF-8" %>
<%
'####################################################
' Description : [컬쳐콘서트#10] 카피 한잔
' History : 2016-02-12 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim oItem, pagereload, classboxcol, cmtYN
dim currenttime
	currenttime =  now()
'																								currenttime = #02/15/2016 09:00:00#
	cmtYN = "Y"
dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  66026
Else
	eCode   =  68986
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, ecc
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),10)

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
if blnFull then
	iCPageSize = 6
else
	iCPageSize = 6
end if

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
<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:21px;}}

img {vertical-align:top;}
.mEvt68986 {position:relative; background-color:#fff; padding-bottom:50px; margin-bottom:-50px;}
.mEvt68986 button {background:transparent;}
.mEvt68986 .itemWrap {position:relative;}
.mEvt68986 .item li {position:absolute; overflow:hidden; text-indent:-999em; cursor:pointer;}
.mEvt68986 #item1 {width:49%; height:49%; left:0; top:5%;}
.mEvt68986 #item2 {width:21%; height:33%; left:49%; top:0;}
.mEvt68986 #item3 {width:51%; height:24%; left:49%; top:33%;}
.mEvt68986 #item4 {width:49%; height:30%; left:0; top:54%;}
.mEvt68986 #item5 {width:51%; height:27%; left:49%; top:57%;}
.mEvt68986 #item6 {width:30%; height:30%; left:70%; top:3%;}
.mEvt68986 .itemLyr {display:none; position:absolute; top:10%; left:50%; z-index:50; width:86.5625%; margin-left:-43.28125%;}
.mEvt68986 .itemLyr div {display:none;}
.mEvt68986 .btnClose {position:absolute; right:6%; top:9%; width:12%; height:9%; overflow:hidden; text-indent:-999em;}
.mEvt68986 .copyInput {position:relative;}
.mEvt68986 .copyInput label {position:absolute; visibility:hidden; font-size:0; line-height:0;}
.mEvt68986 .copyInput input {position:absolute;}
.mEvt68986 .copyInput input[type=text] {left:33%; top:52%; border:1px solid #6c3e37; padding:4%; font-size:1.1rem; color:#6d6d6d; border-radius:0;}
.mEvt68986 .copyInput textarea {position:absolute; left:33%; top:62%; border:1px solid #6c3e37; padding:4%; font-size:1.1rem; color:#6d6d6d; border-radius:0;}
.mEvt68986 .copyInput .copyBtn {left:0; top:82%; width:100%;}
.mEvt68986 .cmtListWrap ul {overflow:hidden; padding:1rem 1rem 1rem 1.3rem;}
.mEvt68986 .cmtListWrap ul li {position:relative; width:100%; padding-bottom:50%; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68986/m/bg_copy_list2.png) 50% 0 no-repeat; background-size:100%;}
.mEvt68986 .cmtListWrap ul li div {position:absolute; left:8%; top:7.5%; right:8%; bottom:10%;}
.mEvt68986 .cmtListWrap ul li div .num {display:block; font-size:0.8rem; color:#d69c8c;}
.mEvt68986 .cmtListWrap ul li div .copy {display:block; padding:1rem 0; font-size:1.2rem; line-height:1.3; color:#b5634d; text-align:center;}
.mEvt68986 .cmtListWrap ul li div .copyView {overflow:hidden; padding-bottom:0.5rem; color:#d28e7c; font-size:1rem; line-height:1.4; height:39%; -webkit-overflow-scrolling:touch; overflow-y:auto;}
.mEvt68986 .cmtListWrap ul li div .writer {position:absolute; right:0; bottom:8%; color:#b5644e; text-decoration:underline;}
.mEvt68986 .cmtListWrap ul li div .cmtDel {overflow:hidden; position:absolute; right:-8.5%; top:-9%; width:1.85rem; height:1.85rem; background:url(http://webimage.10x10.co.kr/eventIMG/2016/68986/m/btn_copy_lyr_del.png) 0 0 no-repeat; text-indent:-999em; background-size:100%;}
#mask {display:none; position:absolute; top:0; left:0; z-index:45; width:100%; height:100%; background:rgba(0,0,0,.6);}
.itemLyr {display:none;}
</style>
<script type="text/javascript">
$(function(){
	/* layer */
	$(".item li").click(function(){
		var itemId = $(this).attr('id');
		$(".itemLyr").show();
		$(".itemLyr div").hide();
		$('#' + itemId +'Lyr').show();
		$("#mask").show();
		var val = $('.itemLyr').offset();
		$('html,body').animate({scrollTop:val.top},200);
	});

	$("#mask").click(function(){
		$(".itemLyr").hide();
		$(".itemLyr div").hide();
		$("#mask").fadeOut();
	});

	$(".btnClose").click(function(){
		$(".itemLyr").hide();
		$(".itemLyr div").hide();
		$("#mask").fadeOut();
	});
});

$(function(){
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",300);
	<% else %>
		setTimeout("pagup()",300);
	<% end if %>
});

function pagup(){
	window.$('html,body').animate({scrollTop:$(".mEvt68986").offset().top}, 0);
}

function pagedown(){
	window.$('html,body').animate({scrollTop:$("#commentevt").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2016-02-15" and left(currenttime,10)<"2016-02-22" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("한 ID당 한번만 참여할 수 있습니다.");
				return false;
			<% else %>

				if (frm.txtcomm1.value == '' || GetByteLength(frm.txtcomm1.value) > 30 || frm.txtcomm1.value == '15자 이내로 적어주세요.'){
					alert("띄어쓰기 포함\n최대 한글 15자 이내로 적어주세요.");
					frm.txtcomm1.focus();
					return false;
				}

				if (frm.txtcomm2.value == '' || GetByteLength(frm.txtcomm2.value) > 300 || frm.txtcomm2.value == '150자 이내로 적어주세요.'){
					alert("띄어쓰기 포함\n최대 한글 150자 이내로 적어주세요.");
					frm.txtcomm2.focus();
					return false;
				}

				frm.txtcommURL.value = frm.txtcomm1.value
				frm.txtcomm.value = frm.txtcomm2.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit(textgb) {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	}

	if (textgb =='text1'){
		if (frmcom.txtcomm1.value == '15자 이내로 적어주세요.'){
			frmcom.txtcomm1.value = '';
		}
	}else if(textgb =='text2'){
		if (frmcom.txtcomm2.value == '150자 이내로 적어주세요.'){
			frmcom.txtcomm2.value = '';
		}
	}else{
		alert('잠시 후 다시 시도해 주세요');
		return;
	}
}
</script>
	<div class="mEvt68986">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/tit_copy.png" alt="크리에이티브 콘서트 카피 한 잔에 여러분을 초대합니다." /></h2>
		<div class="itemWrap">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy.png" alt="사물을 클릭해 도서 &lt;카피책&gt;을 미리 둘러보세요" /></p>
			<ul class="item">
				<li id="item1">카피책</li>
				<li id="item2">가위</li>
				<li id="item3">계산기</li>
				<li id="item4">라디오</li>
				<li id="item5">연필과 지우개</li>
				<li id="item6">커피</li>
			</ul>
		</div>

		<div class="itemLyr">
			<div id="item1Lyr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_lyr1.png" alt="도서 카피책" /></div>
			<div id="item2Lyr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_lyr2.png" alt="카피 작법1 - 싹둑 싹둑 자르십시오" /></div>
			<div id="item3Lyr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_lyr3.png" alt="카피 작법2 - 더하고 빼고 곱하고 나누십시오" /></div>
			<div id="item4Lyr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_lyr4.png" alt="카피 작법3 - 귀에 들리는 말을 채집하십시오" /></div>
			<div id="item5Lyr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_lyr5.png" alt="카피 작법4 - 쓴다/지운다 두가지 일을 하십시오" /></div>
			<div id="item6Lyr"><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_lyr6.png" alt="카피 작법5 - 정철이 들려 준 이야기" /></div>
			<button type="button" id="btnClose02" class="btnClose">닫기</button>
		</div>

		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_man.png" alt="함께 커피 마실 남자 정철" /></p>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/img_copy_guest.png" alt="Special Guest 표시형" /></p>

		<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="iCC" value="1">
		<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="blnB" value="<%= blnBlogURL %>">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
		<input type="hidden" name="txtcomm">
		<input type="hidden" name="txtcommURL">
		<input type="hidden" name="gubunval">
		<input type="hidden" name="isApp" value="<%= isApp %>">	
		<div class="copyInput">
			<h3 class="hide">Comment Event - 카피라이터 정철의 크리에이티브 콘서트 &lt;카피 한 잔&gt;에 여러분을 초대합니다.</h3>
			<label>나의 인생카피는?</label>
			<input type="text" name="txtcomm1" id="txtcomm1" style="width:62%" onClick="jsCheckLimit('text1');" onKeyUp="jsCheckLimit('text1');"  value="<%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>15자 이내로 적어주세요.<%END IF%>"/>

			<label>카피 한 잔 기대평</label>
			<textarea rows="3" style="width:62%" name="txtcomm2" id="txtcomm2" onClick="jsCheckLimit('text2');" onKeyUp="jsCheckLimit('text2');"><%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>150자 이내로 적어주세요.<%END IF%></textarea>

			<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/btn_copy.png" onclick="jsSubmitComment(document.frmcom); return false;" alt="응모하기" class="copyBtn" />
			<img src="http://webimage.10x10.co.kr/eventIMG/2016/68986/m/txt_copy.png" alt="나에게 가장 큰 울림을 줬던 카피를 기대평과 함께 남겨주세요." />
		</div>
		</form>

		<form name="frmdelcom" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="pagereload" value="ON">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
		<input type="hidden" name="eventid" value="<%= eCode %>">
		<input type="hidden" name="linkevt" value="<%= eCode %>">
		<input type="hidden" name="isApp" value="<%= isApp %>">
		</form>

		<% if cmtYN = "Y" then %>
			<% IF isArray(arrCList) THEN %>
				<div class="cmtListWrap" id="commentevt">
					<ul>
						<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<div>
									<span class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1))%></span>
									<strong class="copy"><%=ReplaceBracket(db2html(arrCList(7,intCLoop)))%></strong>
									<p class="copyView"><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
									<span class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
									<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<a href="" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;" class="cmtDel">삭제</a>
									<% end if %>
								</div>
							</li>
						<% next %>
					</ul>
					<%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
				</div>
			<% end if %>
		<% end if %>
		<div id="mask"></div>
	</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->