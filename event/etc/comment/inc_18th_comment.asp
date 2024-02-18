<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : 18주년 댓글 이벤트
' History : 2019-09-24
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
public function getWord(evtcode)
    dim word, sqlstr 
    
    sqlStr = sqlStr & "  SELECT top 1 option1 as 'word' " &vbcrlf
    sqlStr = sqlStr & "  FROM DB_EVENT.DBO.tbl_realtime_event_obj " &vbcrlf
    sqlStr = sqlStr & "  where evt_code = "& evtcode &vbcrlf
    sqlStr = sqlStr & "      and datediff(day, open_date, getdate()) = 0 " &vbcrlf

    rsget.Open sqlstr, dbget, 1
    IF Not rsget.EOF THEN
        word = rsget("word")
    end if	
    rsget.close
		
    getWord = word	
end function
%>
<%
dim evtStartDate, evtEndDate, currentDate, presentDate

currentDate =  date()
evtStartDate = Cdate("2019-09-24")
evtEndDate = Cdate("2019-10-31")

'test
'currentDate = Cdate("2019-12-31")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90391'
Else
	eCode   =  97588
End If

dim userid
	userid = GetEncLoginUserID()
dim todaysWord
todaysWord = getWord(eCode)
%>
<style type="text/css">
.mEvt97329 {position: relative; overflow: hidden; background-color:#feb86b;}
.mEvt97329 .hide {display: none; opacity: 0;}
.mEvt97329 .pos {position: relative; margin: 0 auto;}
.mEvt97329 .pos div {position: absolute; top: 0; left: 0; width: 100%;}
.mEvt97329 button {background-color: transparent; border: 0;}
.mEvt97329 input:focus::-webkit-input-placeholder {opacity: 0;}
.mEvt97329 .topic {position: relative; background-color: #fff;}
.mEvt97329 .topic div {position: absolute; bottom: 4rem; width: 100%;  color: #95530c; font-size: 1.1rem; font-weight: 500; text-align: center; line-height: 1.5;}
.mEvt97329 .topic div b {font-weight: 600;}
.mEvt97329 .topic div p {color: #663806; font-weight: bold;}
.mEvt97329 .cmt-input {width: 32rem;}
.mEvt97329 .tit-plan {height: 4.7rem; margin-bottom: 2.6rem; font-size: 1.8rem; font-weight: bold; text-align: center; line-height: 4.7rem; }
.mEvt97329 .tit-plan b {color: #5c1af3;}
.mEvt97329 .list-plan li {position: relative; width: 25rem; margin: 0 auto 1.25rem; font-size: 1.2rem; font-weight: 500; line-height: 3.4rem; cursor:pointer; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;}
.mEvt97329 .list-plan li .now-txt {position: absolute; bottom: -.5rem; right:.5rem; color:#999; font-size:0.8rem; font-weight: 500;}
.mEvt97329 .list-plan li input[type=text] {overflow:hidden; width:90%; height: 3.4rem; padding-left: 3.7rem; border:0; background-color:transparent; font-size: 1.2rem; color:#444; vertical-align: 0; box-sizing: border-box;}
.mEvt97329 .list-plan li input::-webkit-input-placeholder {color:#999;}
.mEvt97329 .list-plan li input:focus::-webkit-input-placeholder {opacity: 0;}
.mEvt97329 .list-plan li input[type="checkbox"] {position:absolute; width:0; height:0; opacity:0;}
.mEvt97329 .list-plan li input[type="checkbox"] + label {display:block; position:relative; height:3.4rem; padding-left: 3.7rem; }
.mEvt97329 .list-plan li input[type="checkbox"]:checked + label:before,
.mEvt97329 .list-plan li.checked:before {content:' '; display:inline-block; position:absolute; top:0; left:0; width:2.26rem; height:2.26rem; background: url(//webimage.10x10.co.kr/fixevent/event/2019/97329/m/ico_check.png) no-repeat  right center; background-size: contain;}
.mEvt97329 .slide1 {position: relative;}
.mEvt97329 .slide1 button {position: absolute; top: 50%; z-index: 1; padding: 0 2rem;}
.mEvt97329 .slide1 button.btn-next {right: 0;}
.mEvt97329 .cmt-list {padding-bottom: 3rem; background-color: #f5a54a;}
.mEvt97329 .cmt-list .pos {padding-bottom: 26rem; background: no-repeat 0 0 /32rem auto ;}
.mEvt97329 .cmt-list .pos:nth-child(4n-3) {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/97329/m/bg_other_1.jpg);}
.mEvt97329 .cmt-list .pos:nth-child(4n-3) b {color: #f31aa9;}
.mEvt97329 .cmt-list .pos:nth-child(4n-2) {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/97329/m/bg_other_2.jpg);}
.mEvt97329 .cmt-list .pos:nth-child(4n-2) b {color: #291af3;}
.mEvt97329 .cmt-list .pos:nth-child(4n-1) {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/97329/m/bg_other_3.jpg);}
.mEvt97329 .cmt-list .pos:nth-child(4n-1) b {color: #761af3;}
.mEvt97329 .cmt-list .pos:nth-child(4n) {background-image: url(//webimage.10x10.co.kr/fixevent/event/2019/97329/m/bg_other_4.jpg);}
.mEvt97329 .cmt-list .pos:nth-child(4n) b {color: #f33e1a;}
.mEvt97329 .cmt-list .list-plan li {padding-left: 3.7rem;}
.mEvt97329 .pagingV15a {margin-top:0 }
.mEvt97329 .pagingV15a span {width:2.77rem; height:2.77rem; margin:0 0.34rem; color:#fff4e9; font-size:1.28rem; line-height:2.8rem; font-weight:600;}
.mEvt97329 .pagingV15a a {padding-top:0;}
.mEvt97329 .pagingV15a .current {color:#fff; background:#291af3; border-radius:50%;}
.mEvt97329 .pagingV15a .arrow a:after {left:0; top:0; width:2.77rem; height:2.77rem; margin:0; background:url(//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn_next.png) 0 0 no-repeat; background-size:100% 100%;}
.mEvt97329 .noti {padding:0 6.67% 3rem; background-color:#605243; color: #fff4e9; }
.mEvt97329 .noti li {padding-left: .7rem; margin:.68rem 0; font-size:1.11rem; line-height:1.6; word-break: keep-all}
.mEvt97329 .noti li:before {content: '-'; display: inline-block; width: .7rem; margin-left: -.7rem;}
.mEvt97329 .layerPopup {background: none;}
.mEvt97329 .layerPopup .layerPopup-cont {position: absolute; z-index: 88; top: 50%; left: 50%;width: 27.52rem;  transform: translate(-50%,-50%); background-color: #fff;}
.mEvt97329 .layerPopup .layerPopup-cont .btn-close {position: absolute; z-index: 1; top: 0; right: 0; width: 4.6rem;}
.mEvt97329 .layerPopup .layerPopup-cont .pos div {top: auto; bottom: 2rem; font-size: 1.2rem; text-align: center; font-weight: 600; line-height: 1.6;}
.mEvt97329 .layerPopup .layerPopup-cont .pos div b {color: #fe397a;}
.mEvt97329 .layerPopup .mask {display: block;}
</style>
<script type="text/javascript">
    $(function(){
        getList(1, true);
    })
    function shuffleItems(){
        //댓글 배경이미지 랜덤
        var cmtBg = new Array(6);
        for (var i = 0; i < cmtBg.length; i++) {
            cmtBg[i]=Math.floor(Math.random()*6 +1)
            for (var j=0; j<i; j++){
                if(cmtBg[j]==cmtBg[i]){i--;}
            }
        }
        $('.cmt-list li').each(function(){
            var t=$(this).index();
            $('.cmt-list li').eq(t).css({'background-image': 'url(//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bg_cmt_list_'+cmtBg[t]+'.png?v=1.01)' })
        })
    }
    function validate(){        
        var chkRes = true
        $(".cmt-input input[type='text']").each(function(idx, el){
            if(el.value == ''){
                alert('댓글을 적어주세요.');
                el.focus();
                chkRes = false
                return false;
            }
            chkRes = true
        })
        return chkRes
    }
    function chkLogin(){
        <% If not IsUserLoginOK() Then %>
            <% if isApp=1 then %>
                calllogin();
                return false;
            <% else %>
                jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
                return false;
            <% end if %>
        <% end if %>
        return true
    }
    function jsSubmitComment(mode, idx){
        <% if not ( currentDate >= evtStartDate and currentDate <= evtEndDate ) then %>
            alert("이벤트 참여기간이 아닙니다.");
            return false;
        <% end if %>
        if(!chkLogin()) return false;
        if(mode == 'addoo'){if(!validate()) return false;}
        if(mode == 'del'){if(!confirm('삭제 하시겠습니까?')) return false;}

        var payLoad = {
            mode: mode,
            eventCode: '<%=eCode%>',
            inputCommentData: $("#txtContent").val(),
            idx: idx
        }
        $.ajax({
            type: "post",
            url: "/event/evt_comment/api/comment_action.asp",
            data: payLoad,
            success: function(data){
                var res = data.split("|")
                if(res[0] == "ok"){
                    getList(1);
                    resetForm()
                }else if(res[0] == "Err") {
                    alert(res[1])
                }
                // console.log(data, mode)
            },
            error: function(e){
                console.log(e)
            }
        })
    }
    function resetForm(){
        $(".cmt-input input[type='text']").each(function(idx, el){el.value = ''})
    }

    function getList(currentPage, init){
        var pageSize = 6

        if (!currentPage){
            currentPage=1;
        }
        var payLoad = {
            currentPage: currentPage,
            eventCode: '<%=eCode%>',
            pageSize: pageSize,
            scrollCount: 5,
            evtCmtDataType: 2
            // isMyComments: 1
        }
        var items = []
        var pagingData = {}

        $.ajax({
            type: "GET",
            url: "/event/evt_comment/api/comment_list.asp",
            data: payLoad,
            dataType: "json",
            success: function(Data){
                items = Data.comments
                pagingData = Data.pagingData

                renderPaging(pagingData)
                renderItems(items)
                shuffleItems();
                if(!init) window.$('html,body').animate({scrollTop:$("#cmtList").offset().top}, 400);
            },
            error: function(e){
                console.log('데이터를 받아오는데 실패하였습니다.')
            }
        })
    }
    function renderPaging(pagingObj){
        // if(Object.keys(pagingObj).length === 0 && pagingObj.constructor === Object) return false;
        var pagingHtml='';
        var totalpage = parseInt(pagingObj.totalpage);
        var currpage = parseInt(pagingObj.currpage);
        var scrollpage = parseInt(pagingObj.scrollpage);
        var scrollcount = parseInt(pagingObj.scrollcount);
        var totalcount = parseInt(pagingObj.totalcount);        
        var totalHtml = totalpage > 0 ? '<h3>총 <b>'+ totalcount +'</b>개의 이야기</h3>' : ''
        $("#totCnt").html(totalHtml)
        if(totalpage > 0){            
            var prevHtml = currpage>1 ? ' <span class="arrow prevBtn"><a href="" onclick="getList('+(currpage-1)+'); return false;">prev</a></span> ' : ''
            var nextHtml = currpage < totalpage ? ' <span class="arrow nextBtn"><a href="" onclick="getList('+(currpage+1)+'); return false;">next</a></span>' : ''

            pagingHtml +='<div class="paging pagingV15a">' + prevHtml
            for (var ii=(0+scrollpage); ii< (scrollpage+scrollcount); ii++) {
                if(ii > totalpage){
                    break;
                }
                if(ii==currpage){
                    pagingHtml +=' <span class="current"><a href="javascript:void(0)">'+ii+'</a></span> '
                }else{
                    pagingHtml +=' <span><a href="" onclick="getList('+ii+'); return false;" >'+ii+'</a></span> '
                }
            }
            pagingHtml += nextHtml + '</div>';
        }
        $("#pagingElement").html(pagingHtml);
    }
    function renderItems(items){
        if(items.length < 1){
            var noResultHtml = ''
            $("#listContainer").html(noResultHtml);
            return false;
        }
        var listHtmlStr = ''
        var deleteBtn = ''
        items.forEach(function(item){
            deleteBtn = item.isMyContent ? '<a href="javascript:jsSubmitComment(\'del\', '+ item.contentId +')" class="btn-del"><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/btn_cmt_del.png" alt="삭제"></a>' : ''
            listHtmlStr += '\
                    <li><span>\
                    '+ item.content +'\
                    '+ deleteBtn +'\
                    </span></li>\
            '
        })
        $("#listContainer").html(listHtmlStr);
    }
</script>
			<!-- 18주년댓글이벤트:나에게 텐바이텐은? -->
			<div class="anniversary18th bg-random cmtEvt">
            <!-- 헤드 -->
                <link rel="stylesheet" type="text/css" href="/lib/css/anniversary18th.css?v=1.11">
                <script>
                $(function () {
                    // 위시 버튼
                    $('.btn-wish').click(function (e) {
                        $(this).toggleClass("on");
                        return false
                    });

                    // 상단 배경이미지 랜덤
                    var random10 = Math.floor(Math.random()*10 +1);
                    $('.bg-random').css({'background-image': 'url(//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bg_main'+ random10 +'.png)' });
                });
                </script>

                <!-- intro -->
                <div class="intro">
                    <div class="inner">
                        <span class="anniversary">18th</span>
                        <h2>Your 10X10</h2>
                        <div class="intro-sub">18번째 생일,<br>텐바이텐과 함께 해주셔서 고맙습니다.</div>
                        <ul class="evt-list">
                            <li>
                                <% if isapp > 0 then %>
                                <a href="javascript:fnAPPpopupEvent_URL('<%=wwwUrl%>/apps/appCom/wish/web2014/event/eventmain.asp?eventid=97589');">
                                <% else %> 
                                <a href="/event/eventmain.asp?eventid=97589">
                                <% end if %>
                                스누피의 선물 
                                <span class="icon-chev"></span>
                                </a>
                            </li>
                            <li>
                                <% if isapp > 0 then %>
                                <a href="javascript:fnAPPpopupBrowserURL('오늘의 취향','<%=wwwUrl%>/apps/appCom/wish/web2014/event/18th/index.asp?gnbflag=1');">
                                <% else %> 
                                <a href="/event/18th/">
                                <% end if %>                                                            
                                오늘의 취향 
                                <span class="icon-chev"></span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
                <!-- // intro -->
                <div class="topic">
                    <div class="hello">
                        <span>안녕! <%=chkIIF(IsUserLoginOK(), "<b>"& GetLoginUserName() &"</b>님", "")%><br><%=todaysWord%></span>
                        <p>당신에게 텐바이텐이란 무엇인지 들려주세요! </p>
                    </div>
                    <div class="guide">
                        <dl>
                            <dt>기간</dt>
                            <dd>10.01 – 31</dd>
                        </dl>
                        <dl>
                            <dt>당첨자 발표</dt>
                            <dd>11.05</dd>
                        </dl>
                        <dl>
                            <dt>GIFT</dt>
                            <dd>1,000명  / 기프트카드 1,000원</dd>
                        </dl>
                    </div>
                </div>
                <div class="cmt-area pos">
                    <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/18th/m/bg_cmt_input.jpg" alt=""></span>
                    <div class="inner">
                        <div class="cmt-input">
                            <span>오늘, <br>나에게 텐바이텐은</span>
                            <input type="text" id="txtContent" onclick="chkLogin()" maxlength=50>다
                            <button class="btn-submit" onclick="jsSubmitComment('addoo')">등록</button>
                        </div>
                        <p>통신예절에 어긋나는 글은 관리자에 의해 <br>사전 통보 없이 삭제될 수 있습니다.</p>
                    </div>
                </div>
                <div class="cmt-list" id="cmtList">
                    <div id="totCnt"></div>
                    <ul id="listContainer"></ul>
                    <div id="pagingElement"></div>
                </div>
                <!-- 배너영역 -->
                <!-- #include virtual="/event/18th/inc_banner.asp" -->        
            </div>
			<!--// 18주년댓글이벤트:나에게 텐바이텐은? -->