<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  내 옆에 있는 사람 
' History : 2015-07-30 이종화
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64842
Else
	eCode   =  65212
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 26		'한 페이지의 보여지는 열의 수
	iCPerCnt = 10		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

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
<style type="text/css">
img {vertical-align:top;}

.book {position:relative;}
.book .btnmore {position:absolute; right:8.59%;; bottom:18.7%; width:45.31%;}

.guest h3, .commentevt h3 {visibility:hidden; width:0; height:0;}

.guest {background-color:#e6e9ed;}
.youtube {overflow:hidden; position:relative; width:76.56%; height:0; margin:0 auto; padding-bottom:56.25%; background:#000;}
.youtube iframe {position:absolute; top:0; left:0; width:100%; height:100%}

.commentevt {position:relative;}
.commentevt legend {visibility:hidden; width:0; height:0;}
.commentevt .who {position:absolute; top:50%; left:50%; width:87.5%; margin-left:-43.75%;}
.commentevt .itext {overflow:hidden; display:block; position:absolute; top:37.5%; left:50%; width:60%; height:0; margin-left:-30%; padding-bottom:11.25%;}
.commentevt .itext input {position:absolute; top:0; left:0; width:100%; height:100%; border:2px solid #758fb6; border-radius:0; background-color:transparent; /*background-color:red; opacity:0.3;*/ color:#6b8ab9; font-size:15px; font-weight:500; line-height:1.688em; text-align:center; opacity:1;}
.commentevt .who ::-webkit-input-placeholder {color:#6b8ab9; opacity:0.3;}
.commentevt .who ::-moz-placeholder {color:#6b8ab9; opacity:0.3;} /* firefox 19+ */
.commentevt .who :-ms-input-placeholder {color:#6b8ab9; opacity:0.3;} /* ie */
.commentevt .who input:-moz-placeholder {color:#6b8ab9; opacity:0.3;}
.commentevt .btnsubmit {position:absolute; bottom:7.8%; left:50%; width:45.3%; margin-left:-22.65%;}
.commentevt .btnsubmit input {width:100%;}

.count p {padding:7% 0; background-color:#51698e; color:#fff; font-size:13px; text-align:center;}
.count p strong {font-weight:normal;}

.commentlist {padding:0 3.125%;}
.commentlist .listwrap {padding-bottom:5%; border-bottom:1px solid #d6e0e3;}
.commentlist ul {text-align:center;}
.commentlist ul li {display:inline-block; height:23px; margin:0 1px 5px 0; padding:1px 6px 3px; border:1px solid #cdd5e1; border-radius:2px; background-color:#f6f6f6; color:#666; font-family:'Dotum', 'Verdana'; font-size:12px; line-height:20px;}
.commentlist ul li.color1 {border-color:#cdd5e1;}
.commentlist ul li.color2 {border-color:#e2c9e7;}
.commentlist ul li.color3 {border-color:#b9dde4;}

.paging {margin-top:1%; padding-top:7%; border-top:2px solid #d6e0e3;}

@media all and (min-width:480px){
	.count p {font-size:19px;}
	.commentevt .itext input {font-size:22px;}
	.commentlist ul li {height:34px; margin:0 2px 7px 0; padding:2px 9px 3px; font-size:18px; line-height:28px;}
}
</style>
<script>
<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
				calllogin();
				return false;
			<% else %>
				jsevtlogin();
				return;
			<% end if %>	
		<% end if %>

	   if(!frm.txtcomm.value){
	    alert("내 옆에 있는 사람을 입력 해주세요");
		document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }

	   frm.action = "/event/lib/evt_cmtproc.asp";
	   return true;
	}
//-->
</script>
<div class="mEvt65212">
	<div class="topic">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/txt_book_concert.jpg" alt="텐바이텐 컬쳐스테이션 아홉번째 만남 책과 노래가 함께 하는 북콘서트 내 옆에 있는 사람 소중한 사람과 함께 하면 더 좋을 이번 공연에 당신을 초대합니다." /></p>
	</div>

	<div class="story">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/img_story.jpg" alt="아주 평범한 일상 같기도 하지만 또 전혀 예상치 못한 인연이 만들어 내는 굉장한 이야기" /></p>
	</div>

	<div class="book">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/txt_book.jpg" alt="내 옆에 있는 사람의 저자는 이병률, 발행일은 2015년 7월 1일이며, 이 책의 장르는 에세이 여행산문집입니다." /></p>
		<a href="/culturestation/culturestation_event.asp?evt_code=3030" target="_blank" title="새창" class="btnmore"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/btn_more.gif" alt="내 옆에 있는 사람 도서 더 자세히 보러 가기" /></a>
	</div>

	<div class="guest">
		<h3>스페셜 게스트</h3>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/txt_guest.jpg" alt="제주에서 온 강아솔 강아솔의 노래는 솔직하게 다가가 듣는 이의 마음을 강하게 움직이는 힘을 가지고 있다. 또 그녀의 공연에서 관객들은 웃다가 울다가 짙은 여운을 안고 간다." /></p>
		<div class="youtube">
			<iframe src="https://www.youtube.com/embed/Pp-U23KGcNQ?list=PL-pnWgiZ4jYdLkfx2S_fYDe1RUVV567ia" frameborder="0" title="강아솔 언제든 내게" allowfullscreen></iframe>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/txt_bgm.png" alt="BGM 강아솔 언제든 내게" /></p>
	</div>

	<div class="commentevt" id="need">
		<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>"/>
		<input type="hidden" name="bidx" value="<%=bidx%>"/>
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
		<input type="hidden" name="iCTot" value=""/>
		<input type="hidden" name="mode" value="add"/>
		<input type="hidden" name="spoint" value="1">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
		<input type="hidden" name="hookcode" value="#need"/>
			<fieldset>
			<legend>함께 공연하고싶은 사람 입력</legend>
				<h3>코멘트 이벤트</h3>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/txt_comment_event.png" alt="텐바이텐이 함께 만드는 북콘서트 내 옆에 있는 사람에 누구와 함께 오고 싶으신가요? 사연을 남겨주시면 30쌍을 추첨해 북콘서트에 초대합니다." /></p>
				<div class="who">
					<img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/txt_who.png" alt="나는 내 옆에 있는 사람, 함께 이 공연을 즐기고 싶어요!" />
					<div class="itext"><input type="text" title="함께 공연을 즐기고 싶은 사람 입력" placeholder="10자 이내로 입력하세요." name="txtcomm" maxlength="10"/></div>
				</div>
				<div class="btnsubmit"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/btn_submit.png" alt="응모하기" /></div>
			</fieldset>
		</form>
		<form name="frmdelcom" method="post" action="/event/lib/comment_process.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
	</div>

	<div class="count">
		<p>[내 옆에 있는 사람 ] 신청자는 총 <strong><%=FormatNumber(iCTotCnt,0)%></strong>명 입니다.</p>
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/65212/m/ico_ampersand.png" alt="" /></div>
	</div>

	<% IF isArray(arrCList) THEN %>
	<div class="commentlist">
		<div class="listwrap">
			<ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>
				<li><%=arrCList(1,intCLoop)%></li>
				<% Next %>
			</ul>
		</div>

		<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
	</div>
	<% End If %>
</div>
<script type="text/javascript">
$(function(){
	/* list border color randow */
	var classes = ["color1", "color2", "color3"];
	$(".commentlist ul li").each(function(){
		$(this).addClass(classes[~~(Math.random()*classes.length)]);
	});
});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->