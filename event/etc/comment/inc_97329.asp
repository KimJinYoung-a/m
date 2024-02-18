<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : TO DO LIST
' History : 2019-09-19
'###########################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
dim evtStartDate, evtEndDate, currentDate, presentDate

currentDate =  date()
evtStartDate = Cdate("2019-09-19")
evtEndDate = Cdate("2019-10-13")
presentDate = Cdate("2019-12-31")

'test
'currentDate = Cdate("2019-12-31")

dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  90389
Else
	eCode   =  97329
End If

dim userid
	userid = GetEncLoginUserID()

dim isWinner : isWinner = true
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
.mEvt97329 .cmt-input .btn-area {position: static; display: flex;}
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
.mEvt97329 .cmt-list .pos {padding-bottom: 26rem; background: no-repeat 50% 0 /32rem auto ;}
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
<script>
$(function(){
    swiper = new Swiper('.slide1', {
        nextButton:'.slide1 .btn-next',
	    prevButton:'.slide1 .btn-prev'
    })
    $('#layerPopup1 .mask, #layerPopup1 .btn-close ').click(function(){
        $('.layer-area').hide();
        window.$('html,body').animate({scrollTop:$("#alarm").offset().top}, 400);
        return false;
    })
});
</script>
<script type="text/javascript">
    $(function(){
        getList(1, true);
        <% If IsUserLoginOK() Then %>
        getMyComment();
        <% end if %>
    })
    function validate(){
        var chkRes = true
        $(".list-plan input[type='text']").each(function(idx, el){
            if(el.value == ''){
                alert('목표3가지를 모두 작성해주세요!');
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
    function jsSubmitComment(mode){
        if(!chkLogin()) return false;
        if(!validate()) return false;

        var payLoad = {
            mode: mode,
            eventCode: '<%=eCode%>',
            txtcomm:  $("#content1").val(),
            txtcomm2: $("#content2").val(),
            txtcomm3: $("#content3").val(),
            option1: mode == 'add' ? '0': $('input:checkbox[id="option1"]').is(':checked') ? 1 : 0,
            option2: mode == 'add' ? '0': $('input:checkbox[id="option2"]').is(':checked') ? 1 : 0,
            option3: mode == 'add' ? '0': $('input:checkbox[id="option3"]').is(':checked') ? 1 : 0,
            commentNum: 1,
            commidx: $('#my_comment').attr("idx")
        }
        $.ajax({
            type: "post",
            url: "/event/evt_comment/api/util_comment_action.asp",
            data: payLoad,
            success: function(data){
                var res = data.split("|")
                if(res[0] == "ok"){
                    if(mode == "add") {
                        $('.layer-area#submit').show();
                        getList(1, true);
                    }
                    $('#inputContainer').hide()
                    getMyComment();
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
        $(".list-plan input[type='text']").each(function(idx, el){el.value = ''})
        $("[id*=disp]").each(function(idx, el){$(el).text("0")})
    }

    function getList(currentPage, init){
        var pageSize = 4

        if (!currentPage){
            currentPage=1;
        }
        var payLoad = {
            currentPage: currentPage,
            eventCode: '<%=eCode%>',
            pageSize: pageSize,
            scrollCount: 5,
            // isMyComments: 1
        }
        var items = []
        var pagingData = {}

        $.ajax({
            type: "GET",
            url: "/event/evt_comment/api/util_comment_list.asp",
            data: payLoad,
            dataType: "json",
            success: function(Data){
                items = Data.comments
                pagingData = Data.pagingData
                <% if userid="ley330" or userid="greenteenz" or userid="rnldusgpfla" or userid="cjw0515" Then %>
                $("#dispTotalCnt").text('응모수 : '+pagingData.totalcount)
                <% end if %>
                renderItems(items)
                renderPaging(pagingData)

                if(!init) window.$('html,body').animate({scrollTop:$("#cmtList").offset().top}, 400);
            },
            error: function(e){
                console.log('데이터를 받아오는데 실패하였습니다.')
            }
        })
    }
    function getMyComment(){
        var payLoad = {
            currentPage: 1,
            eventCode: '<%=eCode%>',
            pageSize: 1,
            scrollCount: 1,
            isMyComments: 1
        }
        var items = []

        $.ajax({
            type: "GET",
            url: "/event/evt_comment/api/util_comment_list.asp",
            data: payLoad,
            dataType: "json",
            success: function(Data){
                items = Data.comments
                if(items.length > 0){
                    $('#inputContainer').hide()
                    var myHtmlStr = ''
                    var content = items[0].content
                    var content2 = items[0].content2
                    var content3 = items[0].content3
                    var option1 = items[0].option1
                    var option2 = items[0].option2
                    var option3 = items[0].option3
                    var userid = items[0].userId
                    var regdate = items[0].regDate
                    var tmpFlag = function(flag){return flag == "1" ? 'checked' : ''}

                    items.forEach(function(item){
                        myHtmlStr += '\
                        <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/bg_input_after_v1.jpg?v=1.02" alt=""></span>\
                        <div id="my_comment" idx='+ items[0].contentId +'>\
                            <p class="tit-plan"><b>'+ userid +'</b>의 목표</p>\
                            <ul class="list-plan">\
                                <li><input type="checkbox" value="1" onclick="jsSubmitComment(\'mod\')" id="option1" '+ tmpFlag(option1) +'><label for="option1">'+ content +'</label></li>\
                                <li><input type="checkbox" value="1" onclick="jsSubmitComment(\'mod\')" id="option2" '+ tmpFlag(option2) +'><label for="option2">'+ content2 +'</label></li>\
                                <li><input type="checkbox" value="1" onclick="jsSubmitComment(\'mod\')" id="option3" '+ tmpFlag(option3) +'><label for="option3">'+ content3 +'</label></li>\
                            </ul>\
                        </div>\
                        <button type="button" onclick="setUpdateForm(true)" class="btn-submit"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn_modify.jpg" alt="수정하기"></button>\
                        '
                    })
                    $("#myList").html(myHtmlStr);
                    setUpdateForm(false)
                    $("#dipDate").html(regdate.substring(6, 7)+'월 '+regdate.substring(8, 10)+'일')
                }
            },
            error: function(e){
                console.log('데이터를 받아오는데 실패하였습니다.')
            }
        })
    }
    function setUpdateForm(toggle){
        if(toggle){
            $("#myList").hide();
            $('#inputContainer').show()
            $('#submitBtn').hide();
            $('#updateBtn').show();
            $(".txt-form input[type='text']").each(function(idx, el){
                chkWord(el, 15, 'disp'+(parseInt(idx)+1))
            })            
        }else{
            $("#myList").show();
            $('#inputContainer').hide()
            $('#submitBtn').show();
            $('#updateBtn').hide();
            // original values
            $("#content1").val($("#option1").next().text())
            $("#content2").val($("#option2").next().text())
            $("#content3").val($("#option3").next().text())
        }
    }
    function renderPaging(pagingObj){
        if(Object.keys(pagingObj).length === 0 && pagingObj.constructor === Object) return false;
        var pagingHtml='';
        var totalpage = parseInt(pagingObj.totalpage);
        var currpage = parseInt(pagingObj.currpage);
        var scrollpage = parseInt(pagingObj.scrollpage);
        var scrollcount = parseInt(pagingObj.scrollcount);
        var totalcount = parseInt(pagingObj.totalcount);

        if(totalpage > 1){
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

        var tmpFlag = function(flag){return flag == "1" ? 'class=\'checked\'' : ''}
        listHtmlStr += '<ul>'
        items.forEach(function(item){
            listHtmlStr += '\
                    <li class="pos">\
                        <div>\
                            <p class="tit-plan"><b>'+ item.userId +'</b>의 목표</h3>\
                            <ul class="list-plan">\
                                <li '+ tmpFlag(item.option1) +'>'+ item.content +'</li>\
                                <li '+ tmpFlag(item.option2) +'>'+ item.content2 +'</li>\
                                <li '+ tmpFlag(item.option3) +'>'+ item.content3 +'</li>\
                            </ul>\
                        </div>\
                    </li>\
            '
        })
        listHtmlStr += '</ul>'
        $("#listContainer").html(listHtmlStr);
    }
    function chkWord(obj, maxLength, txtId){
        var currentLengh = obj.value.length < maxLength ? obj.value.length : maxLength
        obj.value = obj.value.substr(0, maxLength)
        $("#"+txtId).text(parseInt(currentLengh));
    }
</script>

<!-- MKT_97329_To do list -->
<div id="dispTotalCnt"></div>
<div class="mEvt97329">
    <div class="topic">
        <h2><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/tit.jpg?v=1.01" alt="To do list"></h2>
        <div>
            앞으로 <b><%=DateDiff("d", Cdate("2020-01-01"), date()) * -1%></b>일 남은 2019년!
            <p>올해 꼭 이루고 싶은 목표 적고 기프트카드 받아가세요!</p>
        </div>
    </div>
    <div class="todo">
        <div class="cmt-input pos" id="inputContainer" style="display:<%=chkIIF(currentDate <= evtEndDate, "", "none" )%>">
            <span><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/bg_input.jpg" alt=""></span>
            <div>
                <p class="tit-plan"><b><%=chkIIF(userid <> "",userid ,"__________")%></b>의 목표</p>
                <ul class="list-plan txt-form">
                    <li>
                        <input type="text" onclick="chkLogin()" onkeyup="chkWord(this, 15, 'disp1');" id="content1" placeholder="첫 번째 목표를 입력해주세요.">
                        <p class="now-txt" name="입력한 글자 수"><span id='disp1'>0</span>/15</p>
                    </li>
                    <li>
                        <input type="text" onclick="chkLogin()" onkeyup="chkWord(this, 15, 'disp2');" id="content2" placeholder="두 번째 목표를 입력해주세요.">
                        <p class="now-txt" name="입력한 글자 수"><span id='disp2'>0</span>/15</p>
                    </li>
                    <li>
                        <input type="text" onclick="chkLogin()" onkeyup="chkWord(this, 15, 'disp3');" id="content3" placeholder="세 번째 목표를 입력해주세요.">
                        <p class="now-txt" name="입력한 글자 수"><span id='disp3'>0</span>/15</p>
                    </li>
                </ul>
            </div>
            <button type="button" id="submitBtn" class="btn-submit" onclick="jsSubmitComment('add')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn.jpg?v=1.01" alt="목표 제출하기"></button>
            <div class="btn-area" id="updateBtn"  style="display: none">
                <button type="button" onclick="setUpdateForm(false)"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn_cancel.jpg" alt="취소"></button>
                <button type="button" onclick="jsSubmitComment('mod')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn_modsubmit.jpg" alt="수정완료"></button>
            </div>
        </div>
        <div class="cmt-input after pos" style="display:" id="myList"></div>
    </div>
    <div><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/txt_guide.jpg" alt="이벤트기간 2019년 9월 23일 - 10월 13일까지"></div>
    <% if currentDate <= Cdate("2019-12-30") then %>
    <div class="alarm" id="alarm">
        <a href="javascript:regAlram();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/tit_alarm.jpg" alt="알림신청하기"></a>
        <div class="slide1 swiper-container-horizontal">
            <div class="swiper-wrapper">
                <div class="swiper-slide swiper-slide-active" style="width: 383px;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/img_alarm_1.jpg" alt="푸시 수신 확인 방법 APP 화면 하단바에 있는 마이텐바이텐 클릭"></div>
                <div class="swiper-slide swiper-slide-next" style="width: 383px;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/img_alarm_2.jpg" alt="마이텐바이텐 오른쪽에 있는 설정 아이콘 클릭 광고성 알림 설정에 빨갛게 표시되면 수신 동의"></div>
                <div class="swiper-slide" style="width: 383px;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/img_alarm_3.jpg" alt="업로드한 영상 URL 입력 후 지원하기!"></div>
            </div>
            <button type="button" class="btn-prev swiper-button-disabled"><svg height="30" width="15"><polyline points="15,0,0,15 15,30" style="fill:none;stroke:#fff;stroke-width:2"></polyline></svg></button>
            <button type="button" class="btn-next"><svg height="30" width="15"><polyline points="0,0,15,15 0,30" style="fill:none;stroke:#fff;stroke-width:2"></polyline></svg></button>
        </div>
    </div>
    <% end if %>
    <!-- 다른 사람의 목표 구경하기 -->
    <div class="cmt-list" id="cmtList">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/tit_other.jpg" alt="다른 사람의 목표 구경하기" /></h3>
        <div id="listContainer"></div>
        <div id="pagingElement"></div>
    </div>
    <div class="noti">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/tit_note.jpg" alt="유의사항" /></h3>
        <ul>
            <li>push 수신 동의를 하신 분에 한하여, 당첨자 발표 공지 push가 발송됩니다.</li>
            <li>사전에 push 동의가 되어 있는 분은 이벤트만 참여하면 당첨자 대상에 포함됩니다.</li>
        </ul>
    </div>
    <%'<!-- 9/23 팝업 -->%>
    <div class="layer-area" id="submit" style="display:none">
        <div class="layerPopup" id="layerPopup1">
            <div class="layerPopup-cont">
                <a href="" class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn_close.png" alt="닫기" /></a>
                <img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/layer_submit.jpg" alt="목표 제출 완료!" />
                <button type="button" onclick="regAlram()"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/layer_btn.jpg?v=1.01" alt="당첨자 발표 알림 신청"></button>
            </div>
            <div class="mask"></div>
        </div>
    </div>
    <%'<!-- 12/31 당첨 -->%>
<% If false Then %>

    <% if currentDate >= Cdate("2019-12-31") and IsUserLoginOK() then %>
        <script>
        $(function(){
            $('.layerPopup .btn-check, .layerPopup .btn-close ').click(function(){
                $('.layer-area').hide();
                window.$('html,body').animate({scrollTop:$("#my_comment").offset().top}, 400);
                return false;
            })
        })
        </script>
        <% if isWinner then %>
        <div class="layer-area">
            <div class="layerPopup">
                <div class="layerPopup-cont">
                    <a href="javascript:void(0)" class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn_close.png" alt="닫기" /></a>
                    <div class="pos">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/layer_win.jpg" alt="축하합니다!" />
                        <div>
                            <b id="dipDate"></b>에 적은 <b><%=userid%></b>님의
                            <p>목표를 다시 한 번 확인해보세요!</p>
                        </div>
                    </div>
                    <button type="button" class="btn-check"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/layer_btn_mytodo.jpg" alt="목표 확인하러 가기"></button>
                </div>
                <div class="mask"></div>
            </div>
        </div>
        <% else %>
        <div class="layer-area">
            <div class="layerPopup">
                <div class="layerPopup-cont">
                    <a href="javascript:void(0)" class="btn-close"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/btn_close.png" alt="닫기" /></a>
                    <div class="pos">
                        <img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/layer_fail.jpg" alt="당첨은 되지 않았지만, 쿠폰을 드려요!!" />
                        <div>
                            <b id="dipDate"></b>에 적은 <b><%=userid%></b>님의
                            <p>목표를 다시 한 번 확인해보세요!</p>
                        </div>
                    </div>
                    <button type="button" class="btn-check"><img src="//webimage.10x10.co.kr/fixevent/event/2019/97329/m/layer_btn_mytodo.jpg" alt="목표 확인하러 가기"></button>
                </div>
                <div class="mask"></div>
            </div>
        </div>
        <% end if %>
    <% end if %>
<% end if %>
</div>
<script type="text/javascript" src="/event/etc/json/js_regAlram.js?v=1.5"></script>