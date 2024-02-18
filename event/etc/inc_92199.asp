<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 버킷리스트 튜터링
' History : 2019-01-25 이종화 생성
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim currenttime
	currenttime =  now()

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90220
Else
	eCode   =  92199
End If

dim userid, commentcount, i
	userid = GetEncLoginUserID()

commentcount = getcommentexistscount(userid, eCode, "", "", "", "Y")

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop, pagereload, page
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	iCCurrpage	= getNumeric(requestCheckVar(Request("iCC"),10))	'현재 페이지 번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	pagereload	= requestCheckVar(request("pagereload"),2)

	page	= getNumeric(requestCheckVar(Request("page"),10))

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
if blnFull then
	iCPageSize = 6		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if
'iCPageSize = 1

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
.mEvt9819 .botton {background-color:transparent;}
.topic {position:relative;}
.topic p {display:inline-block; position:absolute; top:5.6%; right:3.6%; width:25.3%; animation:bounce .7s 20;}
.info {position:relative;}
.info .key-word {overflow:hidden; position:absolute; top:0; left:0; z-index:10; width:100%; height:17.02%; padding:0 6.6%;}
.info .key-word li {float:left; width:25%; height:100%; text-indent:-999em;}
.info .rolling {position:relative;}
.info .rolling .pagination {position:absolute; bottom:7.57%; left:0; width:100%; height:0.68rem; z-index:50; padding-top:0;}
.info .rolling .pagination span {display:inline-block; width:.68rem; height:100%; margin:0 .42rem; border:solid #000 .17rem; background-color:transparent;}
.info .rolling .pagination .swiper-active-switch {background-color:#000;}
.cmt-area {background-color:#bbe2f9; text-align:center;}
.cmt-area .input-box {position:relative; width:32rem; margin:0 auto;}
.cmt-area .input-box .textarea-wrap {position:absolute; top:0; left:0; width:100%; height:100%; padding:10.01% 17.73% 12%; }
.cmt-area .input-box .textarea-wrap .now-txt {position: absolute; bottom: 8%; right: 16%; color:#999; font-size:1.1rem;}
.cmt-area .input-box textarea {overflow:hidden;width:100%; height:100%; padding:0; border:0; background-color:transparent; color:#666; font-size:1.19rem; line-height:2.82rem; font-weight:600; text-align:left;}
.cmt-area .input-box textarea::-webkit-input-placeholder {color:#999;}
.cmt-area .input-box textarea::-moz-placeholder {color:#999;}
.cmt-area .input-box textarea:-ms-input-placeholder {color:#999;}
.cmt-area .input-box textarea:-moz-placeholder {color:#999;}
.cmt-area .submit {width:32rem;}
.cmt-area .cmt-list ul {padding:1.71rem 8% 0;background-color:#a1d0ec;}
.cmt-area .cmt-list ul li {position:relative; margin-top:1.71rem; padding:2.05rem 2.99rem 2.56rem; background-color:#e2ffed; text-align:left;}
.cmt-area .cmt-list ul .desc {overflow:hidden; padding-bottom:1rem; border-bottom:solid .085rem rgba(0,0,0,.1);}
.cmt-area .cmt-list ul .desc .num {float:left; font-size:1.54rem; font-weight:bold;}
.cmt-area .cmt-list ul .desc .writer {float:right; font-size:1.11rem;}
.cmt-area .cmt-list ul .conts {margin-top:1.62rem; font-size:1.28rem; line-height:1.67; word-wrap:break-word; word-break: break-all;}
.cmt-area .cmt-list .delete {display:inline-block; position:absolute; top:.85rem; right:.85rem; width:1.66rem; height:1.66rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/92199/m/btn_delete.png) no-repeat 50% 50%; background-size:contain; text-indent:-999em;}
.cmt-area .pagingV15a {margin-top:0rem; padding-top:2.13rem; padding-bottom:4.27rem; background-color:#a1d0ec;}
.cmt-area .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#417797; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.cmt-area .pagingV15a a {padding-top:0;}
.cmt-area .pagingV15a .current {color:#fff; background:#417797; border-radius:50%;}
.cmt-area .pagingV15a .prevBtn a,
.cmt-area .pagingV15a .nextBtn a {display: block;}
.cmt-area .pagingV15a .prevBtn a img,
.cmt-area .pagingV15a .nextBtn a img {width: auto; width: 25%; vertical-align: middle;}
.noti {padding-bottom:3.84rem; background-color:#445269;}
.noti ul {padding:0 6.67%;}
.noti li {margin:.68rem 0; padding-left:.77rem; color:#96a4bc; font-size:1.1rem; line-height:1.84; text-indent:-.77rem;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript">
$(function () {
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
    <% end if %>
    
    rolling1 = new Swiper(".rolling .swiper-container",{
        effect:'fade',
        loop:true,
        autoplay:2000,
        speed:800,
        pagination:".rolling .pagination",
        paginationClickable:true
    });

	$(".key-word li:nth-child(1)").on("click", function(e){$( ".pagination span:nth-child(1)" ).click();});
	$(".key-word li:nth-child(2)").on("click", function(e){$( ".pagination span:nth-child(2)" ).click();});
	$(".key-word li:nth-child(3)").on("click", function(e){$( ".pagination span:nth-child(3)" ).click();});
	$(".key-word li:nth-child(4)").on("click", function(e){$( ".pagination span:nth-child(4)" ).click();});

	$(".cmt-list li:nth-child(2n-1)").css('background-color', '#ffe0ea');
	$(".cmt-list li:nth-child(2n)").css('background-color', '#fffec6');
});

function pagedown(){
	window.$('html,body').animate({scrollTop:$(".cmt-list").offset().top}, 0);
}

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If not( left(currenttime,10)>="2019-01-25" and left(currenttime,10)<"2019-02-07" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("한 ID당 1회만 참여 가능합니다.");
				return false;
			<% else %>
				frm.txtcomm.value = frm.txtcomm1.value
				frm.action = "/event/lib/doEventComment.asp";
				frm.submit();
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	<% End IF %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmactNew.Cidx.value = cidx;
   		document.frmactNew.submit();
	}
}

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
		return false;
	}
}

function fnChkByte(obj) {
    var maxByte = 300; //최대 입력 바이트 수
    var str = obj.value;
    var str_len = str.length;
 
    var rbyte = 0;
    var rlen = 0;
    var one_char = "";
    var str2 = "";
 
    for (var i = 0; i < str_len; i++) {
        one_char = str.charAt(i);
 
        if (escape(one_char).length > 4) {
            rbyte += 2; //한글2Byte
        } else {
            rbyte++; //영문 등 나머지 1Byte
        }
 
        if (rbyte <= maxByte) {
            rlen = i + 1; //return할 문자열 갯수
        }
    }

    console.log("현재:"+rbyte+"전체"+maxByte);
 
    if (rbyte > maxByte) {
        alert("한글 "+ (maxByte / 2) +"자 이내로 작성 가능합니다.");
        str2 = str.substr(0, rlen); //문자열 자르기
        obj.value = str2;
        fnChkByte(obj, maxByte);
    } else {
        document.getElementById('byteInfo').innerText = Math.ceil(rbyte / 2);
    }
}
</script>
<div class="mEvt9819">
    <%' 최상단 %>
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/tit_bucket.png" alt="튜터링과 함께 영어공부"></h2>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/img_winner.png" alt="총 당첨자 100명!"></p>
    </div>

    <%' 브랜드 소개 %>
    <div class="info">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/tit_info.png?v=1.01" alt="튜터링이 궁금해요!"></h3>
        <div class="rolling">
            <div class="swiper-container">
                <div class="swiper-wrapper">
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/92199/m/img_slide_1.jpg?v=1.01" alt="일을 좋아하고, 더 잘하고 싶은 사람들을 위한 모든 콘텐츠를 만나는 곳, PUBLY!" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/92199/m/img_slide_2.jpg?v=1.01" alt="다른 사람의 경험으로부터 배워보세요! PUBLY는 다양한 분야에서 일하는 저자들의 경험이 담긴 콘텐츠가 가득해요!" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/92199/m/img_slide_3.jpg?v=1.01" alt="여러분이 직접 찾아내고 가려내는 번거로움 없이, PUBLY가 선별하고 검증한 콘텐츠를 즐기기만 하세요!" /></div>
                    <div class="swiper-slide"><img src="http://webimage.10x10.co.kr/fixevent/event/2019/92199/m/img_slide_4.jpg?v=1.01" alt="마케팅, 브랜드, 테크를 포함한 29가지 기획의 다양한 콘텐츠가 발행됩니다. 시각을 넓혀줄 신선한 인사이트를 만나보세요!" /></div>
                </div>
            </div>
            <div class="pagination"></div>
            <ul class="key-word">
                <li>#24시간</li>
                <li>#수업주제</li>
                <li>#공부법</li>
                <li>#1:1피드백</li>
            </ul>
        </div>
    </div>

    <%' 코멘트(6개씩 노출) %>
    <div class="cmt-area">
        <h4><img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/tit_cmt_evt.png" alt="튜터링에서 읽고 싶은 콘텐츠를 남겨주세요!"></h4>
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
        <input type="hidden" name="isApp" value="<%= isApp %>">                
        <div class="input-box">
            <img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/bg_txt_area.png?v=1.01" alt="">
            <div class="textarea-wrap">
                <textarea name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" onKeyUp="fnChkByte(this);" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> placeholder="띄어쓰기 포함 150자 이내로 적어주세요!"></textarea>
                <p class="now-txt"><span id="byteInfo">0</span> / 150자</p>
            </div>
        </div>
        <button class="submit" onclick="jsSubmitComment(document.frmcom); return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/btn_submit.png" alt="등록하기"></button>
        <p><img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/txt_caution.png" alt="한 ID당 한번 참여 가능합니다. 통신예절에 어긋나는 글이나 상업적인 글은 이벤트 참여에 제한을 받을 수 있습니다."></p>
		</form>
        <form name="frmactNew" method="post" action="/event/lib/doEventComment.asp" style="margin:0px;">
        <input type="hidden" name="mode" value="del">
        <input type="hidden" name="pagereload" value="ON">
        <input type="hidden" name="Cidx" value="">
        <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
        <input type="hidden" name="eventid" value="<%= eCode %>">
        <input type="hidden" name="linkevt" value="<%= eCode %>">
        <input type="hidden" name="isApp" value="<%= isApp %>">
        </form>        
        <div class="cmt-list">
			<% IF isArray(arrCList) THEN %>        
            <ul>
				<% For intCLoop = 0 To UBound(arrCList,2) %>                
                    <li>
                        <div class="desc">
                            <p class="num"><%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                            <p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
                        </div>
                        <div class="conts">
                            <%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%>
                        </div>
                        <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
                        <button class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">삭제</button>
                        <% end if %>
                    </li>
                <% Next %>
            </ul>
            <% End If %>
        </div>
        <div class="paging pagingV15a">
            <% If isArray(arrCList) Then %>
            <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
            <% End If %>
        </div>
    </div>

    <%' 유의사항 %>
    <div class="noti">
        <h5><img src="//webimage.10x10.co.kr/fixevent/event/2019/92199/m/tit_noti.png" alt="유의사항"></h5>
        <ul>
            <li>- 해당 이벤트는 로그인 후, 한 ID 당 1회만 참여할 수 있습니다.</li>
            <li>- 입력 완료된 댓글 내용은 수정이 불가합니다.</li>
            <li>- 통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며, 이벤트 참여에 제한을 받을 수 있습니다.</li>
            <li>- 이벤트 당첨자는 2019년 2월 8일 금요일 텐바이텐 공지사항에 기재 및 개별 연락 드릴 예정입니다.</li>
        </ul>
    </div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->