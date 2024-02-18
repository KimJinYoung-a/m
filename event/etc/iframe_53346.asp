<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  <PLAY> 여행하듯 랄랄라
' History : 2014.07.04 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%
Dim eCode, userid, sub_idx, i
	eCode=getevt_code
	userid = getloginuserid()
Dim iCPerCnt, iCPageSize, iCCurrpage
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	
function getnowdate()
	dim nowdate
	
	nowdate = date()
	nowdate = "2014-07-07"
	
	getnowdate = nowdate
end function

function getevt_code()
	dim evt_code
	
	IF application("Svr_Info") = "Dev" THEN
		evt_code   =  21225
	Else
		evt_code   =  53346
	End If
	
	getevt_code = evt_code
end function

IF iCCurrpage = "" THEN iCCurrpage = 1
iCPageSize = 4
iCPerCnt = 4		'보여지는 페이지 간격
	
dim ccomment
set ccomment = new Cevent_etc_common_list
	ccomment.FPageSize        = iCPageSize
	ccomment.FCurrpage        = iCCurrpage
	ccomment.FScrollCount     = iCPerCnt
	ccomment.frectordertype="new"
	ccomment.frectevt_code      	= eCode
	ccomment.event_subscript_paging
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 당신은 어떤노트를 쓰고있나요</title>
<style type="text/css">
.content {padding-bottom:0;}
.bookConcert img {vertical-align:top; width:100%;}
.bookConcert p {max-width:100%;}
.bookConcert .section, .bookConcert .section h3 {margin:0; padding:0;}
.bookConcert .section3 .group1 {position:relative;}
.bookConcert .section3 .group1 legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.bookConcert .section3 .group1 .part {position:absolute; bottom:25%; left:0; width:100%; padding:0 23.95833% 0 8.75%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.bookConcert .section3 .group1 .part .tArea {overflow:hidden; position:relative; height:0; padding-bottom:30%;}
.bookConcert .section3 .group1 .part textarea {position:absolute; top:0; left:0; width:100%; height:100%; padding:10px; border:1px solid #e8e7da; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box; font-size:13px;}
.bookConcert .section3 .group1 .part .btnSubmit {position:absolute; right:5%; bottom:-1%; width:17.91666%;}
.bookConcert .section3 .group1 .part .btnSubmit input {width:100%;}
.bookConcert .section3 .group2 {padding-bottom:30px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53332/bg_paper.gif) 0 0 repeat-y;}
.bookConcert .section3 .group2 .comment {padding:5% 6.25% 5% 3.125%;}
.bookConcert .section3 .group2 .comment .area {overflow:hidden; position:relative; height:0; padding-bottom:40%;}
.bookConcert .section3 .group2 .comment .area .part {position:absolute; top:0; left:0; width:100%; height:100%;}
.bookConcert .section3 .group2 .comment .area .writer {position:relative; margin-top:5%; padding-left:9%; color:#fff; font-size:11px; text-align:left;}
.bookConcert .section3 .group2 .comment .area .writer strong {padding-left:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53332/blt_dot.png) 0 50% no-repeat; background-size:3px auto;}
.bookConcert .section3 .group2 .comment .area .writer span {position:absolute; top:0; right:10%;}
.bookConcert .section3 .group2 .comment .area p {overflow:auto; height:70px; margin:5% 5% 0 10%; padding-right:3%; color:#555; font-size:12px; line-height:1.313em; text-align:left; -webkit-overflow-scrolling:touch;}
.bookConcert .section3 .group2 .comment .area button {margin:0; padding:0; border:0; background:none; cursor:pointer;}
.bookConcert .section3 .group2 .comment .area .btnDel {position:absolute; top:2%; right:0; width:20px; height:20px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/53332/btn_del.png) 0 0 no-repeat; background-size:20px auto; text-indent:-999em;}
.bookConcert .section3 .group2 .comment .area1 .part {background:url(http://webimage.10x10.co.kr/eventIMG/2014/53332/bg_comment_box_01.png) 0 0 no-repeat; background-size:100% auto;}
.bookConcert .section3 .group2 .comment .area2 .part {background:url(http://webimage.10x10.co.kr/eventIMG/2014/53332/bg_comment_box_02.png) 0 0 no-repeat; background-size:100% auto;}
.bookConcert .section3 .group2 .comment .area3 .part {background:url(http://webimage.10x10.co.kr/eventIMG/2014/53332/bg_comment_box_03.png) 0 0 no-repeat; background-size:100% auto;}
.bookConcert .section3 .group2 .comment .area4 .part {background:url(http://webimage.10x10.co.kr/eventIMG/2014/53332/bg_comment_box_04.png) 0 0 no-repeat; background-size:100% auto;}
@media all and (max-width:480px){
	.bookConcert .section3 .group2 .comment .area .writer {margin-top:3.2%;}
	.bookConcert .section3 .group2 .comment .area p {height:55px; margin-top:2%; font-size:11px;}
	.bookConcert .section3 .group2 .comment .area .btnDel {top:0;}
}
</style>
<script type="text/javascript">
function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #07/17/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-07-07" and getnowdate<"2014-07-18" Then %>
				if(frm.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
					jsChklogin('<%=IsUserLoginOK%>');
					return false;
				}
				if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 600 || frm.txtcomm.value == '코멘트를 입력해 주세요.(300자 이내)'){
					alert("코맨트가 없거나 제한길이를 초과하였습니다. 300자 까지 작성 가능합니다.");
					frm.txtcomm.focus();
					return;
				}

		   		frm.mode.value="addcomment";
				frm.action="doEventSubscript53346.asp";
				frm.target="evtFrmProc";
				frm.submit();
				return;
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		parent.jsevtlogin();
	<% End IF %>
}

function jsGoComPage(iP){
	document.frmcomm.iCC.value = iP;
	document.frmcomm.submit();
}

function jsDelComment(sub_idx)	{
	if(confirm("삭제하시겠습니까?")){
		frmcomm.sub_idx.value = sub_idx;
		frmcomm.mode.value="delcomment";
		frmcomm.action="doEventSubscript53346.asp";
		frmcomm.target="evtFrmProc";
   		frmcomm.submit();
	}
}

</script>
</head>
<body>
	<!-- BOOK CONCERT -->
	<div class="mEvt53181">
		<div class="bookConcert">
			<div class="section section1">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_book_concert.jpg" alt="책과 노래가 함께하는 북콘서트 여행하듯 랄랄라 텐바이텐에서 만끽하는 도심 속 여름 여행, 그 설레는 시작에 당신을 초대합니다" /></p>
				<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/img_illust.jpg" alt="" /></div>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_ground_topic.jpg" alt="그라운드 열번째 주제, 여행 텐바이텐 그라운드 열번째 주제, 여행 텐바이텐 그라운드 열번째 주제, 여행 텐바이텐 그라운드 열번째 주제, 여행 텐바이텐 그라운드 열번째 주제, 여행 텐바이텐 그라운드 열번째 주제, 여행" /></p>
			</div>

			<div class="section section2">
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/tit_book_concert_programe.jpg" alt="북 콘서트 프로그램" /></h3>
				<ul>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_program_01.jpg" alt="첫번째 &lt;끌림&gt;, &lt;바람이 분다 당신이 좋다&gt;의 이병률 시인과 함께 나눠보는 REAL 여행과 제주에 대한 이야기" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_program_02.jpg" alt="두번째 황의정 작가가 들려주는 생활 속 보석 찾기에 대한 이야기, 그리고 나만의 지우개 도장 만들기" /></li>
					<li><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_program_03.jpg" alt="세번째 여행을 소재로 한 노래를 선보이는 혼성 10인조 밴드 투어리스트와 함께 부르는 여행의 설렘을 담은 노래!" /></li>
				</ul>
			</div>

			<div class="section section3">
				<div class="group group1">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_lalala.jpg" alt="책과 노래가 함께하는 북콘서트 여행하듯 랄랄라" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_leave_comment.jpg" alt="텐바이텐이 함께 하는 북콘서트 여행하듯 랄라라의 기대평을 남겨주세요. 30쌍을 추첨해 특별한 도심 속 여행을 선물합니다. Special gift도 준비되어 있어요." /></p>
					<div class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/bg_painting_box.jpg" alt="" /></div>
					
					<form name="frmcomm" action="" onsubmit="return false;" method="post" style="margin:0px;">
					<input type="hidden" name="mode">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="sub_idx">
					<div class="part">
							<fieldset>
							<legend>콘서트 여행하듯 랄라라 기대명 쓰기</legend>
								<div class="tArea"><textarea name="txtcomm" title="코멘트 입력" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> cols="60" rows="5" placeholder="<%=chkIIF(NOT(IsUserLoginOK),"로그인 후 글을 남길 수 있습니다.","코멘트를 입력해 주세요.(300자 이내)")%>"></textarea></div>
								<div class="btnSubmit"><input type="image" onclick="jsSubmitComment(frmcomm); return false;" src="http://webimage.10x10.co.kr/eventIMG/2014/53332/btn_submit.png" alt="이벤트 참여" /></div>
							</fieldset>
						</form>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53332/txt_info.jpg" alt="이벤트기간은 2014년 7월 7일 월요일부터 7월 17일 목요일까지이며, 당첨자 발표는 2014년 7월 18일 금요일에 합니다. 콘서트 일시는 2014년 7월 24일 목요일 저녁 8시이며, 장소는 텐바이텐 대학로 라운지 2층에서 열립니다." /></p>
				</div>

				<!-- comment -->
				<% IF ccomment.ftotalcount>0 THEN %>
				<div class="group group2">
					<div class="comment">
						<%
						for i = 0 to ccomment.fresultcount - 1
						%>
						<div class="area area<%= i + 1 %>">
							<div class="part">
								<div class="writer"><strong><%=printUserId(ccomment.FItemList(i).fuserid,2,"*")%></strong> <span>no.<%=ccomment.FTotalCount-i-(ccomment.FPageSize*(ccomment.FCurrPage-1))%></span></div>
								<p><%=ReplaceBracket(ccomment.FItemList(i).fsub_opt3)%></p>
								<% if ((userid = ccomment.FItemList(i).fuserid) or (userid = "10x10")) and ( ccomment.FItemList(i).fuserid<>"") then %>
									<button type="button" onclick="jsDelComment('<%= ccomment.FItemList(i).fsub_idx %>'); return false;" class="btnDel">삭제</button>
								<% end if %>
							</div>
						</div>
						<%
						next
						%>
					<div class="paging">
						<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
					</div>
				</div>
				<!-- //comment -->
				<% END IF %>
				</form>
			</div>
		</div>
	</div>
	<!-- //BOOK CONCERT -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width="0" height="0"></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->