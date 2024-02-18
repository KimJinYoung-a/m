Vue.use(VueAwesomeSwiper)

const app = new Vue({
    el : '#app'
    , store: store
    , mixins : [item_mixin, modal_mixin, common_mixin]
    , template : `
        <div id="content" class="content typeI">
            <!--11 유형만 사용한다해서 나머지는 없음-->
            
            <div class="evtContV15">                
                <template v-if="!content.endlessView">
                    <script type="text/javascript" :src="'/common/addlog.js?tp=noresult&ror=' + referrer"></script>
                    <div class="finish-event">이벤트가 종료되었습니다.</div>
                </template>
                
                <template v-if="evt_isExec_mo > 0">
                    <% If checkFilePath(server.mappath(evtFile_mo)) Then %>
                        <div width="100%"><% server.execute(evtFile_mo)%></div>
                    <% End If %>
                </template>

                <% If Trim(evt_html_mo)="" Or not isnull(evt_html_mo) Then %>
                    <%=evt_html_mo%>
                <% End If %>
                <div class="bnrTemplate"><%=tArea%></div>
                </div>
    
                <!-- type 2 : full rolling 타입 -->
                <div class="event-article event-full-rolling-type"<%=CHKIIF(topSlideCheck>0," style='display:none'","")%>>
                    <!-- I형 이미지 슬라이더 -->
                    <div class="evt-sliderV19">
                        <div class="swiper-container">
                            <% If fnGetMoTopSlideImgCnt(eCode) > 1 Then %>
                            <div class="swiper-wrapper">
                                <% If videoFullLink<>"" Then %>
                                <div class="swiper-slide has-vod">
                                    <div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
                                </div>
                                <% End If %>
                                <% sbTopSlidetemplateMD %>
                            </div>
                            <div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
                            <% ElseIf fnGetMoTopSlideImgCnt(eCode) > 0 And videoFullLink<>"" Then %>
                            <div class="swiper-wrapper">
                                <% If videoFullLink<>"" Then %>
                                <div class="swiper-slide has-vod">
                                    <div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
                                </div>
                                <% End If %>
                                <% sbTopSlidetemplateMD %>
                            </div>
                            <div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
                            <% ElseIf fnGetMoTopSlideImgCnt(eCode) < 1 And videoFullLink<>"" Then %>
                                <div class="swiper-slide has-vod">
                                    <div class="vod-wrap"><div class="vod"><%=videoFullLink%></div></div>
                                </div>
                            <% Else %>
                            <div class="swiper-wrapper">
                                <% sbTopSlidetemplateMD %>
                            </div>
                            <div class="pagination-progressbar"><span class="pagination-progressbar-fill"></span></div>
                            <% End If %>
                        </div>
                    </div>
                    <section class="hgroup-event"<% if CopyHide="1" then %> style="display:none"<% end if %>>
                        <h2 style="word-break:keep-all;" id="title"><%=title_mo%></h2>
                        <p class="subcopy" style="word-break:keep-all;"><%=evt_subname%></p>
                        <div class="labels">
                            <% If blnsale Or blncoupon Then %>
                            <% If blnsale And salePer>"0" Then %><span class="labelV19 label-red" id="esale">~<%=salePer%>%</span><% end if %>
                            <% If blncoupon And saleCPer>"0" Then %>&nbsp;<span class="labelV19 label-green">~<%=saleCPer%>%</span><% end if %>
                            <% end if %>
                            <% If blngift Then %>&nbsp;<span class="labelV19 label-blue">GIFT</span><% end if %>
                            <% If isOnePlusOne Then %>&nbsp;<span class="labelV19 label-blue">1+1</span><% end if %>
                            <% If isNew Then %>&nbsp;<span class="labelV19 label-black">런칭</span><% end if %>
                            <% If blncomment or blnbbs or blnitemps Then %>&nbsp;<span class="labelV19 label-black">참여</span><% end if %>
                            <% If isOnlyTen Then %>&nbsp;<span class="labelV19 label-black">단독</span><% end if %>
                        </div>
                    </section>
                </div>
                <div class="bnrTemplate"><%=mArea%></div><%'모바일 중간 추가 이미지 %>
    
                <% sbMultiContentsView %>
    
                <%=newGiftBox%>
    
                <!-- 코멘트 박스 -->
                <% If blncomment Then %>
                <section class="comment-eventV19">
                    <h3 style="color:<%=ThemeBarColorCode%>;">Comment Event</h3>
                    <p class="topic"><%=nl2br(comm_text)%></p>
                    <ul>
                        <li>작성기간 <span class="date"><%=Replace(comm_start,"-",".")%> ~ <%=Replace(comm_end,"-",".")%></span></li>
                        <li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
                    </ul>
                    <div class="btnGroup">
                        <a href="#replyList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
                    </div>
                    <% if freebie_img<>"" then %><div class="thumbnail"><img src="<%=freebie_img%>" alt=""></div><% End If %>
                </section>
                <% End If %>
    
                <!-- 상품후기 박스 -->
                <% If blnitemps Then %>
                <section class="comment-eventV19">
                    <h3 style="color:<%=ThemeBarColorCode%>;">Review Event</h3>
                    <p class="topic"><%=nl2br(eval_text)%></p>
                    <ul>
                        <li>작성기간 <span class="date"><%=Replace(eval_start,"-",".")%> ~ <%=Replace(eval_end,"-",".")%></span></li>
                        <li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
                    </ul>
                    <div class="btnGroup">
                        <a href="#replyPrdList" class="btn-go">리뷰 쓰러가기<span class="icon"></span></a>
                    </div>
                    <% if eval_freebie_img<>"" then %><div class="thumbnail"><img src="<%=eval_freebie_img%>" alt=""></div><% End If %>
                </section>
                <% End If %>
    
                <!-- 포토 코멘트 박스 -->
                <% If blnbbs Then %>
                <section class="comment-eventV19">
                    <h3 style="color:<%=ThemeBarColorCode%>;">Photo Comment Event</h3>
                    <p class="topic"><%=nl2br(board_text)%></p>
                    <ul>
                        <li>작성기간 <span class="date"><%=Replace(board_start,"-",".")%> ~ <%=Replace(board_end,"-",".")%></span></li>
                        <li>당첨자 발표 <span class="date"><%=Replace(epdate,"-",".")%></span></li>
                    </ul>
                    <div class="btnGroup">
                        <a href="#replyPhotoList" class="btn-go">코멘트 쓰러가기<span class="icon"></span></a>
                    </div>
                    <% if board_freebie_img<>"" then %><div class="thumbnail"><img src="<%=board_freebie_img%>" alt=""></div><% End If %>
                </section>
                <% End If %>
    
                <%'// 상품 리스트 분리 -- 이종화 %>
                <div id="eventitemlist" v-cloak>
                    <div class="exhibition-list-wrap<% If isArray(arrGroup) Then %> exhibition-list-wrap<% Else %> exhibition-list-wrap-nogroupbar<% End If %>">
                        <% If isArray(arrGroup) Then %>
                            <group-itemlist v-for="(item,index) in sliced" v-if="sliced" :items="item" :groups="groups" :key="index" :wrapper="true" :barcolor="themebarColor" :ltype="listType" ></group-itemlist>
                        <% Else %>
                            <nogroup-itemlist :items="sliced" :ltype="listType" ></nogroup-itemlist>
                        <% End If %>
                        <temp-layout v-if="tempFlag"></temp-layout>
                    </div>
                </div>
    
                <script>
                $(function(){
                    $('img[usemap]').rwdImageMaps();
                    $('.evt-sliderV19 .pagination-progressbar-fill').css('background', '<%=ThemeBarColorCode%>'); // for dev msg : 테마색상 등록
                    // I형 이미지 슬라이더
                    $('.evt-sliderV19').each(function(index, slider) {
                        var slider = $(this).find('.swiper-container');
                        var amt = slider.find('.swiper-slide').length;
                        var progress = $(this).find('.pagination-progressbar-fill');
                        if (amt > 1) {
                            var evtSwiper = new Swiper(slider, {
                                autoplay: 1700,
                                loop: true,
                                speed: 800,
                                autoplayDisableOnInteraction: false,
                                onInit: function(evtSwiper) {
                                    var init = (1 / amt).toFixed(2);
                                    progress.css('transform', 'scaleX(' + init + ') scaleY(1)');
                                },
                                onSlideChangeStart: function(evtSwiper) {
                                    var activeIndex = evtSwiper.activeIndex;
                                    var realIndex = parseInt(evtSwiper.slides.eq(activeIndex).attr('data-swiper-slide-index') || activeIndex, 10);
                                    var calc = ( (realIndex+1) / amt ).toFixed(2);
                                    progress.css('transform', 'scaleX(' + calc + ') scaleY(1)');
                                }
                            });
                        } else {
                            var evtSwiper = new Swiper(slider, {
                                noSwiping: true,
                                noSwipingClass: '.noswiping'
                            });
                            $(this).find('.pagination-progressbar').hide();
                        }
                    });
    
                    $(window).scroll(function(){
                        var headerTop = $(window).scrollTop() + $(".header_wrap").outerHeight();
                        var menuTop = $("#eventitemlist").offset().top;
    
                        if( headerTop >= menuTop ) {
                            $(".dropdownWrap").css({"position":"fixed","top":"4.1rem"});
                        } else {
                            $(".dropdownWrap").css({"position":"absolute","top":"0"});
                        }
    
                        <% If isArray(arrGroup) Then %>
                        <% For intG = 1 To UBound(arrGroup,2) %>
                        // for dev msg : 2017.06.08 id값은 기차코드로 뿌려주세요 group******
                        if($("#group<%=arrGroup(0,intG)%>").length) {
                            if( $(window).scrollTop()>=$("#group<%=arrGroup(0,intG)%>").offset().top-$(".dropdownWrap").outerHeight()) {
                                var groupbar = $("#group<%=arrGroup(0,intG)%>").children("h3").text();
                                $("#eventitemlist").find(".btnDrop").text(groupbar);
                            }
                        }
                        <% next %>
                        <% end if %>
                        if($("#remove").length) {
                            if( $(window).scrollTop()>=$("#remove").offset().top-$(".dropdownWrap").outerHeight()) {
                                $(".dropdownWrap").css({"position":"absolute","top":"0"});
                            }
                        }
                    });
                });
                </script>
                <div class="bnrTemplate"><%=bArea%></div>
                <div id="remove"></div>
        </div>
    `
    , created() {
        this.$store.dispatch('GET_CONTENT');
        this.referrer = document.referrer;
    }
    , mounted() {

    }
    , data() {
        return {
            referrer : ""
        }

    }
    , computed : {
        content() {
            return this.$store.getters.content;
        }
    }
    , methods : {

    }
});