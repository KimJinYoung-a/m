<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'########################################################
' PLAY #14 Audio_이 순간, 당신은 어떤 노래를 듣고 있나요. 
' 2014-11-07 이종화 작성
'########################################################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21356
Else
	eCode   =  56366
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

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

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

	Dim rencolor
	 
	randomize

	rencolor=int(Rnd*30)+1
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {width:100%; vertical-align:top;}
.this-moment {background-color:#fff;}
.section .copyright {margin-top:8px; padding-top:0; padding-right:15px; color:#888; font-size:11px; line-height:1.25em; text-align:right;}
.section .copyright em {border-bottom:1px solid #81b9d5; color:#81b9d5;}

.section1 {padding-bottom:15%; background:url(http://webimage.10x10.co.kr/playmo/ground/20141110/bg_paper.gif) no-repeat 0 0; background-size:100% auto;}
.section1 h1 {padding-top:10%}
.movie-wrap {margin:10% 10px 0;}
.movie-wrap-inner {padding:5px; background-color:#fff; box-shadow:0 0 5px 5px rgba(173,173,173,0.1);}
.movie {overflow:hidden; position:relative; height:0; padding-bottom:56.25%; background:#000;}
.movie iframe {position:absolute; top:0; left:0; width:100%; height:100%}
.section2 {padding-bottom:15%;}
.section3 {position:relative;}
.section3 .play {position:absolute; right:1.5%; bottom:25%; width:26%;}
.section4 {padding:25% 0; text-align:center;}
.section4 time {color:#484848; font-size:36px; line-height:1.25em; letter-spacing:-2px;}
.section5 {padding:15% 0 5%; background:url(http://webimage.10x10.co.kr/playmo/ground/20141110/bg_line_pattern.gif) repeat-y 0 0; background-size:100% auto;}
.section5 h2 + p {margin-top:7%;}
.section5 .btnGo {width:40%; margin:5% auto 0;}
.section5 .field {margin-top:10%;}
.section5 .field legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
.recommend-wrap {overflow:hidden; margin:0 5%;}
.recommend-wrap .label {float:left; width:45%;}
.recommend-wrap .label img {width:80%;}
.recommend-wrap .itext {float:left; width:55%;}
.recommend-wrap .itext input[type=text] {width:100%; margin-bottom:5%;}
.field .btn-submit {margin:5% 15% 0;}
.field input[type=image] {width:100%;}
.section5 .copyright {margin-top:12%;}
.section6 {padding-bottom:45px;}
.comment-list ul {overflow:hidden; padding:0 10px;}
.comment-list ul li {float:left; position:relative; width:50%; min-height:230px; margin-top:45px; padding:0 20px; text-align:center;}
.comment-list ul li span, .comment-list ul li strong, .comment-list ul li em {display:block;}
.comment-list ul li .song, .comment-list ul li .date {line-height:1.25em;}
.comment-list ul li .now {margin-top:17px; color:#81b9d5; font-size:13px; line-height:1.25em;}
.comment-list ul li .now, .comment-list ul li .song {overflow:hidden; width:90%; margin:0 auto; text-overflow:ellipsis; white-space:nowrap;}
.comment-list ul li .now {margin-top:17px;}
.comment-list ul li .song, .comment-list ul li .singer {margin-top:2px; color:#333; font-size:13px;}
.comment-list ul li .date {margin-top:5px; color:#888; font-size:12px;}
.comment-list ul li .date img {width:9px; vertical-align:middle;}
.comment-list ul li .btnDel {position:absolute; right:20%; top:0; width:27px; height:27px; background:url(http://webimage.10x10.co.kr/playmo/ground/20141110/btn_del.png) no-repeat 0 0; background-size:27px 27px; text-indent:-999em;}
.comment-list .paging {margin-top:45px;}

@media all and (min-width:360px){
	.recommend-wrap .label img {width:70%;}
}
@media all and (min-width:480px){
	.section .copyright {margin-top:12px; font-size:15px;}
	.movie-wrap {margin:10% 20px 0; padding:10px;}
	.section4 time {font-size:54px;}
	.recommend-wrap .label img {width:50%;}
	.section5 .copyright {margin-top:12%;}
	.comment-list ul li .now {font-size:20px;}
	.comment-list ul li .song, .comment-list ul li .singer {margin-top:3px; font-size:20px;}
	.comment-list ul li .now {margin-top:25px;}
	.comment-list ul li .date {margin-top:8px; font-size:18px;}
	.comment-list ul li .btnDel {width:40px; height:40px; background-size:40px 40px;}
}
@media all and (min-width:766px){
	.recommend-wrap .label img {width:55%;}
}
</style>
<script type="text/javascript">
$(function() {
	$(".section1 h1").css({"opacity":"0"});
	function showText() {
		$(".section1 h1").delay(300).animate({"opacity":"1"},500);
	}
	setInterval(function(){
			showText()
	},300);
});
</script>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>

	   
	    if(!frm.qtext1.value){
	    alert("지금 상태를 입력해주세요");
		document.frmcom.qtext1.value="";
	    frm.qtext1.focus();
	    return false;
	   }

	   if(!frm.qtext2.value){
	    alert("가수명을 입력해주세요");
		document.frmcom.qtext2.value="";
	    frm.qtext2.focus();
	    return false;
	   }

	   if(!frm.qtext3.value){
	    alert("노래명을 입력해주세요");
		document.frmcom.qtext3.value="";
	    frm.qtext3.focus();
	    return false;
	   }

	   frm.action = "doEventSubscript56366.asp";
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
			if(document.frmcom.qtext1.value =="1번째"){
				document.frmcom.qtext1.value="";
			}
			return true;
		} else {
			<% if Not(IsUserLoginOK) then %>
				<% If isApp="1" or isApp="2" Then %>
				parent.calllogin();
				return false;
				<% else %>
				parent.jsevtlogin();
				return;
				<% end if %>			
			<% end if %>
		}

		return false;
	}

	function jsChklogin22(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext2.value =="2번째"){
				document.frmcom.qtext2.value="";
			}
			return true;
		} else {
			<% if Not(IsUserLoginOK) then %>
				<% If isApp="1" or isApp="2" Then %>
				parent.calllogin();
				return false;
				<% else %>
				parent.jsevtlogin();
				return;
				<% end if %>			
			<% end if %>
		}

		return false;
	}

	function jsChklogin33(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.qtext3.value =="3번째"){
				document.frmcom.qtext3.value="";
			}
			return true;
		} else {
			<% if Not(IsUserLoginOK) then %>
				<% If isApp="1" or isApp="2" Then %>
				parent.calllogin();
				return false;
				<% else %>
				parent.jsevtlogin();
				return;
				<% end if %>			
			<% end if %>
		}

		return false;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}
//-->
</script>
<script>
var minus_second = 0;
var montharray=new Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
var today=new Date(<%=Year(now)%>, <%=Month(now)-1%>, <%=Day(now)%>, <%=Hour(now)%>, <%=Minute(now)%>, <%=Second(now)%>);

function countdown(){
	today = new Date(Date.parse(today) + (1000+minus_second));	//서버시간에 1초씩 증가
	var todayy=today.getYear()

	if(todayy < 1000)
		todayy+=1900
		

		var todaym=today.getMonth()
		var todayd=today.getDate()
		var todayh=today.getHours()
		var todaymin=today.getMinutes()
		var todaysec=today.getSeconds()
		var todaystring=montharray[todaym]+" "+todayd+", "+todayy+" "+todayh+":"+todaymin+":"+todaysec
		var apname = "";

		if(todayh < 0)
		{
			$("#lyrCounter").hide();
			return;
		}

		//am pm 설정
		if(todayh > 12 && todayh < 24 ) {
			apname = " pm"
			todayh = todayh - 12;
		}else{
			apname = " am"
		}

		if(todayh < 10) {
			todayh = "0" + todayh;
		}

		if(todaymin < 10) {
			todaymin = "0" + todaymin;
		}
		if(todaysec < 10) {
			todaysec = "0" + todaysec;
		}

		$("#lyrCounter").html(todayh +" : "+ todaymin +" : "+ todaysec + apname);
	
		minus_second = minus_second + 1;

	setTimeout("countdown()",1000)
}

$(function(){
	countdown();
});
</script>
</head>
<body>
<div class="mPlay20141110">
	<div class="this-moment">
		<div id="section1" class="section section1">
			<h1><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/tit_this_moment_music.png" alt="이 순간, 당신은 어떤 노래를 듣고 있나요?" /></h1>
			<div class="movie-wrap">
				<div class="movie-wrap-inner">
					<div class="movie">
						<!-- for dev msg : 아침6시~오후2시 -->
						<% If hour(now) >= 6 And hour(now) < 14 Then %>
						<iframe src="//player.vimeo.com/video/111078071?autoplay=1&amp;loop=1;" frameborder="0" title="" allowfullscreen></iframe>
						<!-- for dev msg : 오후2시~오후10시 -->
						<% elseIf hour(now) >= 14 And hour(now) < 22 Then %>
						<iframe src="//player.vimeo.com/video/111078749?autoplay=1&amp;loop=1;" frameborder="0" title="" allowfullscreen></iframe>
						<!-- for dev msg : 오후10시~아침6시 -->
						<% elseIf hour(now) >= 22 And hour(now) < 6 Then %>
						<iframe src="//player.vimeo.com/video/111078230?autoplay=1&amp;loop=1;" frameborder="0" title="" allowfullscreen></iframe>
						<% End If %>
					</div>
				</div>
			</div>
			<p class="copyright">작품 <a href="http://vimeo.com/94706446" target="_blank" title="Time Remapper 풀 버전 보기 새창"><em>&lt;Time Remapper&gt;</em></a> Bruno Wang</p>
		</div>

		<div id="section2" class="section section2">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/txt_with_good_music_01.gif" alt="Every time with good music in our life" /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/txt_with_good_music_02.gif" alt="해와 달이 뜨고 지는, 하루를 보내는 순간순간 우리는 좋은 노래들과 함께 합니다." /></p>
		</div>

		<div id="section3" class="section section3">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/txt_now_music_01.jpg" alt="지금, PLAY 페이지에 머물러 있는 당신은..." /></p>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/txt_now_music_02.jpg" alt="하루의 시간을 보내면서 어떤 노래들을 듣고 있는지 궁금해졌습니다. 그리고 함께 듣고 싶어졌습니다. 지금 보고 있는 이 웹 페이지는 큰 라디오가 됩니다. 여러분은 이 시간만큼은 최고의 DJ가 되어 이 공간을 함께 하고 있는 사람들에게 좋은 노래들을 선곡하고 공유해 주세요 :)" /></p>
			<span class="play"><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/btn_play.gif" alt="" /></span>
		</div>

		<!-- time -->
		<div id="section4" class="section section4">
			<time id="lyrCounter">05 : 31 : 27 am</time>
		</div>

		<!-- comment event -->
		<div id="section5" class="section section5">
			<div class="comment-evt">
				<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/tit_comment_event.png" alt="코멘트 이벤트" /></h2>
				<p><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/txt_gift.png" alt="당신이 지금 이 순간, 함께 듣고 싶은 노래를 공유해 주세요. 추첨을 통해 5분께 언제나 가까이에서 음악과 함께 하실 수 있는 아이리버 블루투스 스피커를 선물로 드립니다. 이벤트 기간은 2014년 11월 10일부터 11월 19일까지며, 당첨자 발표는 2014년 11월 21일입니다." /></p>
				<div class="btnGo"><a href="<% If isApp="1" or isApp="2" Then %>javascript:parent.fnAPPpopupProduct('1091239'); <% Else %>/category/category_itemPrd.asp?itemid=1091239<% End If %>" target="_top"><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/btn_go.png" alt="상품 보러 가기" /></a></div>

				<div class="field">
					<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>"/>
					<input type="hidden" name="bidx" value="<%=bidx%>"/>
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>"/>
					<input type="hidden" name="iCTot" value=""/>
					<input type="hidden" name="mode" value="add"/>
					<input type="hidden" name="spoint" value="<%=rencolor%>">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>"/>
						<fieldset>
						<legend>지금 이 순간 함께 듣고 싶은 노래 추천하기</legend>
							<div class="recommend-wrap">
								<div class="label"><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/txt_label.png" alt="" /></div>
								<div class="itext">
									<input type="text" title="나 지금" placeholder="잠이 안 오는 이 순간" name="qtext1" value="" onClick="jsChklogin11('<%=IsUserLoginOK%>');"/>
									<input type="text" title="이 가수" placeholder="브로콜리너마저" name="qtext2" value="" onClick="jsChklogin22('<%=IsUserLoginOK%>');"/>
									<input type="text" title="이 노래" placeholder="보편적인 노래" name="qtext3" value="" onClick="jsChklogin33('<%=IsUserLoginOK%>');"/>
								</div>
							</div>
							<div class="btn-submit">
								<input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20141110/btn_recommend.png" alt="추천하기" class="animated fadeIn" />
							</div>
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
				<% IF isArray(arrCList) THEN %>
				<p class="copyright">텐바이텐 감성매거진 <em>&lt;HITCHHIKER&gt;</em>의 사진</p>
				<% End If %>
			</div>
		</div>

		<!-- comment list -->
		<% IF isArray(arrCList) THEN %>
		<div id="section6" class="section section6">
			<div class="comment-list">
				<ul>
					<% For intCLoop = 0 To UBound(arrCList,2) %>
					<% 
							Dim opt1 , opt2 , opt3
							If arrCList(1,intCLoop) <> "" then
								opt1 = SplitValue(arrCList(1,intCLoop),"//",0)
								opt2 = SplitValue(arrCList(1,intCLoop),"//",1)
								opt3 = SplitValue(arrCList(1,intCLoop),"//",2)
							End If 
					%>
					<li>
						<span class="thumb"><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/img_album_<%=chkiif(arrCList(3,intCLoop)<10,"0"&arrCList(3,intCLoop),arrCList(3,intCLoop))%>.jpg" alt="" /></span>
						<strong class="now"><%=opt1%></strong>
						<em class="singer"><%=opt2%></em>
						<em class="song"><%=opt3%></em>
						<span class="date"><% If arrCList(8,intCLoop) = "M"  then%><img src="http://webimage.10x10.co.kr/playmo/ground/20141110/ico_mobile.gif" alt="모바일에서 작성된 글" /><% End If %> &nbsp;<%=printUserId(arrCList(2,intCLoop),2,"*")%> / <%=formatdate(arrCList(4,intCLoop),"00:00")%></span>
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<button type="button" class="btnDel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');">삭제</button>
						<% end if %>
					</li>
					<% Next %>
				</ul>
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
		</div>
		<% End If %>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->