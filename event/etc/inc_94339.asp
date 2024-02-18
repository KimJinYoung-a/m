<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 토로로 이벤트 
' History : 2019-05-20 최종원 생성
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
dim evtStartDate, evtEndDate, currentDate
	currentDate =  date()

evtStartDate = Cdate("2019-05-20")
evtEndDate = Cdate("2019-06-02")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90289
Else
	eCode   =  94339
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
	iCPageSize = 5		'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 5		'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
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
.mEvt94339 {position: relative; background-color: #12418f; overflow: hidden;}
.mEvt94339 > div {position: relative; z-index: 8;}
.mEvt94339 .posr {position: relative;}
.mEvt94339 .pos {position: absolute; top: 0; left: 0; width: 100%;}
.from-top {transform: translateY(5rem); opacity: 0; transition-duration: 1.2s;}
.from-top.on {transform: translateY(0); opacity: 1;}
.topic {z-index: 6;}
.topic p {padding-top: 5.3rem; }
.topic h2 {position: relative; margin-top: 1.8rem; transition-delay: .4s;}
.topic h2:after {content: ''; position: absolute; display: block; top: -34%; left: 45%; width: 2.78rem; height: 2.52rem; background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_dust.png); background-repeat: no-repeat; background-size: contain; }
.btn-area a {float: left; display: block; width: 50%; padding-bottom: 44.44%; text-indent: -999rem;}
.cmt-area .radio-area span {float: left; display: block; width: 50%;}
.cmt-area .radio-area input {position: absolute;left: -999rem;}
.cmt-area .radio-area label{position: relative; display: block; cursor: pointer; width: 100%; padding-bottom: 70.5%;}
.cmt-area .radio-area label:before {content: ''; position: absolute; left: 50%; top: .8rem; display: block; width: 1.54rem;height: 1.62rem; background-color: transparent; background-repeat: no-repeat; background-size: contain;}
.cmt-area .radio-area span:nth-child(2n) label:before {left: 42%;} 
.cmt-area .radio-area input:checked+label:before{background-image: url('//webimage.10x10.co.kr/fixevent/event/2019/94339/m/ico_check.png');}
.cmt-area .radio-area:after {content: ''; display: block; clear: both;}
.cmt-area .input-box {width: 100%; padding-top: 11.5%;}
.cmt-area .input-box input {width: 56%; height: 1.75rem; padding: 0; margin-left: 14%; font-family: 'AppleSDGothicNeo-Regular'; font-size: 1.7rem; background-color: transparent; border: 0; color: #444;}
.cmt-area .input-box input::-webkit-input-placeholder {color: #999;}
.cmt-area .input-box input:focus::placeholder  {opacity: 0;} 
.cmt-area > button {margin-top: -.1rem;}
.cmt-list {background-color:#1d3481}
.cmt-list ul {padding:2.56rem 3.5rem 0;}
.cmt-list ul li {position:relative; margin-bottom:1.71rem; padding:2.65rem 3.11rem 1.7rem; background-color:#f4fbff; text-align:center;}
.cmt-list ul li:nth-child(2n) {background-color: #fff4f8;}
.cmt-list ul li .desc:after {content: ''; display: block; clear: both;}
.cmt-list ul li .desc .num {float:left; font-size:1.54rem; font-weight:bold;}
.cmt-list ul li .desc .writer {float:right; font-size:1.11rem;}
.cmt-list ul li .conts {font-family: 'AppleSDGothicNeo-Regular'; font-size:1.56rem; line-height:1.67; word-wrap:break-word; word-break: break-all;}
.cmt-list ul li .conts span {display: block; margin: 1.28rem 0 1.5rem;}
.cmt-list ul li .conts p {line-height: 1.1; color: #004cf7; }
.cmt-list li:nth-child(2n) .conts p {color: #f40056;}
.cmt-list ul li .conts:after {content: '토토로';}
.cmt-list .delete {position:absolute; top:0; right:0; width:4.05rem; height:4.05rem; background:url(//webimage.10x10.co.kr/fixevent/event/2019/94339/m/btn_close.png) no-repeat 50% 50%; background-size:contain; text-indent:-999em;}
.pagingV15a {margin-top:0rem; padding-top:2.13rem; padding-bottom:4.27rem; background-color:#1d3481;}
.pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#aabdfc; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.pagingV15a a {padding-top:0;}
.pagingV15a .current {color:#fff; background:#ff5ab7; border-radius:50%;}
.pagingV15a .arrows a {display: block; background-image:url(//webimage.10x10.co.kr/fixevent/event/2019/94339/m/btn_prev.png); background-size: contain; text-indent: -999rem;}
.pagingV15a .arrows.nextBtn a {transform: rotateY(180deg);}
html{scroll-behavior: smooth;}
</style>
<script type="text/javascript">
$(function(){
    $('.from-top').addClass('on');
    swiper = new Swiper('.slide1', {
        autoplay:2800,
        loop: true,
        effect:'fade',
        speed:700
    });
    $('input[name=totoroImg]').click(function(){	        
        $("#spoint").val($(this).val())
    })        
}); 
</script>
<script type="text/javascript">
$(function () {
	<% if pagereload<>"" then %>
		setTimeout("pagedown()",500);
    <% end if %>
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
		<% If not( currentDate >= evtStartDate and currentDate <= evtEndDate ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if commentcount>0 then %>
				alert("한 ID당 1회만 참여 가능합니다.");
				return false;
            <% else %>
                if(frm.txtcomm1.value == ""){
                    alert('내용을 넣어주세요')
                    frm.txtcomm1.focus()
                    return false;
                }            
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

</script>

            <!-- 94339 이웃집 토토로 -->
            <div class="mEvt94339">
                <div class="topic ">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_top.jpg?v=1.01" alt="" /></span>
                    <div class="pos">
                        <p class="from-top"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/tit_sub.png" alt="전 세계를 사로잡은 사랑스러운 판타지"></p>
                        <h2 class="from-top"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/tit_totoro.png" alt="이웃집 토토로"></h2>
                    </div>
                </div>
                <div class="vod-area">
                    <div class="vod-wrap shape-rtgl ani">
                        <div class="vod">
                            <iframe src="https://www.youtube.com/embed/8LLmvVSnYiw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                        </div>
                    </div>
                    <div class="btn-area posr">
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/btn_grp.jpg" alt="" /></span>
                        <div class="pos">
                            <a href="#totoro-evt">이벤트 참여하기</a>
                            <a href="#eventitemlist">이웃집 토토로 굿즈 구경하기</a>
                        </div>
                    </div>
                </div>
                <div class="movie-info">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_info.jpg?v=1.01" alt="movie info">
                </div>
                <div class="synopsis">
                    <div class="slide1">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_slide_01.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_slide_02.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_slide_03.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_slide_04.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_slide_05.jpg" alt="" /></div>
                            <div class="swiper-slide"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_slide_06.jpg?v=1.01" alt="" /></div>
                        </div>
                    </div>
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_synopsis.jpg" alt="숲속에 살고 있는 특별한 친구를 만났다"></span>
                </div>
                <div class="totoro-card" id="totoro-evt">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_card.jpg?v=1.02" alt="여러분에게 토토로는 어떤 친구인가요?"></span>
                    <div class="cmt-area posr">
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_slt.jpg?v=1.03" alt=""></span>
                        <div class="pos">
                            <!-- for dev msg: 카드 고르기 -->
                            <div class="radio-area">
                                <span>
                                    <input type="radio" name="totoroImg" value="1" checked="checked" id="totoro-01"/>
                                    <label for="totoro-01"></label>
                                </span>
                                <span>
                                    <input type="radio" name="totoroImg" value="2" id="totoro-02"/> 
                                    <label for="totoro-02"></label>
                                </span>
                                <span>
                                    <input type="radio" name="totoroImg" value="3" id="totoro-03"/> 
                                    <label for="totoro-03"></label>
                                </span>
                                <span>
                                    <input type="radio" name="totoroImg" value="4" id="totoro-04"/> 
                                    <label for="totoro-04"></label>
                                </span>
                            </div>
                            <div class="input-box">
                                <form name="frmcom" method="post" onSubmit="return false;">
                                    <input type="hidden" name="mode" value="add">
                                    <input type="hidden" name="pagereload" value="ON">
                                    <input type="hidden" name="iCC" value="1">
                                    <input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
                                    <input type="hidden" name="eventid" value="<%= eCode %>">
                                    <input type="hidden" name="linkevt" value="<%= eCode %>">
                                    <input type="hidden" name="blnB" value="<%= blnBlogURL %>">
                                    <input type="hidden" name="returnurl" value="<%= appUrlPath %>/event/eventmain.asp?eventid=<%= eCode %>&pagereload=ON">
                                    <input type="hidden" id="spoint" name="spoint" value="1">
                                    <input type="hidden" name="txtcomm">
                                    <input type="hidden" name="isApp" value="<%= isApp %>">                
                                    <input type="text" name="txtcomm1" id="txtcomm1" onClick="jsCheckLimit();" title="검색어 입력" placeholder="내 어릴적 친구" maxlength="12" />
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
                            </div>
                        </div>
                        <button type="button" onclick="jsSubmitComment(document.frmcom);"><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/btn_make.png" alt="포토카드 만들기"></button>
                    </div>
                    <div class="cmt-list">
                        <!-- for dev msg: 5개씩 노출 -->
                        <% IF isArray(arrCList) THEN %>        
                        <ul>
                        	<% 
                            dim tmpImgCode
                            For intCLoop = 0 To UBound(arrCList,2) 

                            tmpImgCode = Format00(2, arrCList(3,intCLoop))
                            %>                
                            <li>
                                <div class="desc">
                                    <p class="num">NO. <%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
                                    <p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
                                </div>
                                <div class="conts">
                                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_card_<%=tmpImgCode%>.png?v=1.01" ></span>
                                    <p><%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%></p>
                                </div>
                                <% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>                                
                                    <button class="delete" type="button" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>'); return false;">
                                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/btn_close.png" >
                                    </button>
                                <% end if %>                                
                            </li>
                            <% Next %>
                        </ul>
                        <% end if %>
                        <div class="paging pagingV15a">
                            <% If isArray(arrCList) Then %>
                            <%= fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,iCPerCnt,"jsGoComPage") %>
                            <% End If %>
                        </div>           
                    </div>
                </div>
                <div class="notice">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/94339/m/img_notice.jpg" alt="유의사항"></span>
                </div>
            </div>
            <!-- // 94339 이웃집 토토로 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->