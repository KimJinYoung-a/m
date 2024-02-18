Vue.component('MODAL-POSTING', {
    template : `
        <div id="modalPosting" class="modalV20 modal_type4">
            <div @click="close" class="modal_overlay"></div>
            <div class="modal_wrap modal_forum">
                <div class="modal_header">
                    <h2>모달</h2>
                    <button @click="close" class="btn_close"><i class="i_close"></i>모달닫기</button>
                    <div v-if="posting.creator" class="btn_re_delete">
                        <button @click="modifyPosting" type="button">수정</button>
                        <button @click="deletePosting" type="button">삭제</button>
                    </div>
                    <div class="declaration_container">
                        <button v-if="!posting.creator" @click="clickReportPosting" type="button" class="btn_Declaration">
                            {{posting.reported ? '신고 취소하기' : '신고하기'}}
                            <div v-if="showPostingReportBubble" class="sp_bubble">신고 5회 누적 시 내용이 가려집니다.</div>
                        </button>
                    </div>
                </div>
                <div class="modal_body">
                    <div class="modal_cont forum_conts">
                        
                        <!-- region 프로필, 내용 -->
                        <div class="login_profile">
                            <div class="login_info_area">
                                <div class="img"><img :src="posting.creatorThumbnail"></div>
                                <div class="info">
                                    <p v-if="posting.creatorDescription" class="txt">{{posting.creatorDescription}}</p>
                                    <p class="id">{{posting.creatorNickname}}</p>
                                </div>
                            </div>
                        </div>
                        <div class="my_word">
                            <p v-for="c in postingContents">{{c}}</p>
                        </div>
                        <!-- endregion -->
                        
                        <!-- region 링크, 박수 -->
                        <div class="my_pick_prd">
                            <div v-if="posting.linkValue" class="copy_view">
                                <div class="link_info">
                                    <div @click="goLink" :class="linkThumbnailClass">
                                        <img :src="posting.linkThumbnail">
                                    </div>
                                    <div @click="goLink" v-if="posting.linkType === 2" class="link">
                                        <p class="pro_tit">기획전</p>
                                        <p class="pro_sub">{{posting.linkTitle}}</p>
                                    </div>
                                    <div @click="goLink" v-else-if="posting.linkType === 1 || posting.linkType === 7" class="link">
                                        <p v-if="posting.linkType === 1" class="tit">{{posting.linkDescription}}</p>
                                        <p class="sub">{{posting.linkTitle}}</p>
                                    </div>
                                    <div @click="goLink" v-else-if="posting.linkType === 99" class="link">
                                        <p class="url">{{posting.linkTitle}}</p>
                                    </div>
                                    <div v-if="posting.linkType === 1 || posting.linkType === 7" id="wish" class="select_prd">
                                        <button id="wish" type="button" class="btn_wish" @click="wish">
                                            <figure class="ico_wish"></figure>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <button @click="postClap" type="button" class="btn_clap"><span class="icon"></span><span>{{posting.clapCount > 0 ? numberFormat(posting.clapCount) : '멋져요! 짝짝짝'}}</span></button>
                        </div>
                        <!-- endregion -->
                        
                        <!-- region 댓글 -->
                        <div class="my_comment_area">
                            <div v-if="comments.length > 0" class="forum_my_comment">
                                <MODAL-POSTING-COMMENT v-for="comment in comments" :key="comment.commentIndex" :comment="comment"
                                    @postReComment="postReComment" @deleteComment="getPostingComments"/>
                            </div>
                            <div v-else class="no_comment">
                                <span class="icon"></span>
                                <p class="sub">설레는 첫 답글을 남겨보세요 :)</p>
                            </div>
                        </div>
                        
                        <div id="commentArea" class="bottom_comment">
                            <div class="textarea_comment">
                                <textarea v-model="commentContent" @blur="blurComment" @focus="focusCommentTextarea" 
                                    class="autosize" id="comment" :placeholder="commentPlaceHolder" maxlength="500"></textarea>
                                <button @click="postComment" type="button" class="btn_enter_comment">답글달기</button>
                            </div>
                        </div>
                        <!-- endregion -->
                    </div>
                </div>
            </div>
        </div>
    `,
    data() {return {
        postingIndex : 0,
        //region posting 포스팅
        posting : {
            clapCount: 0, // 박수 수
            content: '', // 내용
            creatorDescription: '', // 작성자 설명
            creatorNickname: '', // 작성자 별명
            creatorThumbnail: '', // 작성자 썸네일
            linkDescription: '', // 링크 설명
            linkThumbnail: '', // 링크 썸네일
            linkTitle: '', // 링크 타이틀
            linkType: 0, // 링크 구분
            linkValue: '', // 링크 값
            linkWish: false, // 링크 위시 여부
            creator: false, // 작성자 여부
            reported : false // 포스팅 본인 신고 여부
        },
        //endregion
        comments: [], // 댓글 리스트
        upperCommentIndex : null, // 상위 댓글 일련번호
        commentContent : '', // 댓글 내용
        aniWish : null,
        showPostingReportBubble : false, // 포스팅 신고 말풍선 노출 여부
        safariVersion : 0, // safari 버전
    }},
    mounted() {
        if( !this.linkerApp ) {
            const mobileDetect = new MobileDetect(navigator.userAgent);
            const version = mobileDetect.is('ios') ? mobileDetect.version('Version') : 0;
            if( !isNaN(version) ) {
                this.safariVersion = Number(version);
            }
        }
    },
    computed : {
        //region linkThumbnailClass 링크 썸네일 클래스
        linkThumbnailClass() {
            if( this.posting.linkValue !== '' ) {
                if( this.posting.linkType === 2 )
                    return 'pro_img';
                else if( this.posting.linkType === 99 )
                    return 'url_img';
                else
                    return 'img';
            } else {
                return '';
            }
        },
        //endregion
        //region commentPlaceHolder 댓글 입력영역 placeholder
        commentPlaceHolder() {
            if( !this.isLogin )
                return '로그인이 필요한 서비스입니다';
            else if( !this.isProfileRegister )
                return '프로필 등록이 필요한 서비스입니다';
            else
                return '답글을 입력해주세요';
        },
        //endregion
        postingContents() {
            if( this.posting.content )
                return this.posting.content.split('\n');
            else
                return [];
        },
    },
    props : {
        isLogin : { type:Boolean, default:false }, // 로그인 유저인지 여부
        forumIndex : { type:Number, default:0 }, // 포럼 일련번호
        isProfileRegister : { type:Boolean, default:false }, // 프로필 등록 여부
    },
    methods : {
        //region open 모달 열기
        open(postingIndex) {
            this.postingIndex = postingIndex;
            this.getPostingDetail();
            this.getPostingComments();
        },
        //endregion
        //region close 모달 닫기
        close() {
            this.clearCommentInput();
            this.closeModal('modalPosting');
            this.$emit('close');
        },
        //endregion
        //region getPostingDetail 포스팅 상세 Get
        getPostingDetail() {
            getFrontApiDataV2('GET', `/linker/posting/${this.postingIndex}`
                , null, this.setPosting);
        },
        //endregion
        //region setPosting 포스팅 Set
        setPosting(data) {
            this.posting = data;
            this.openModal('modalPosting');
        },
        //endregion
        //region getPostingComments 포스팅 댓글 리스트 Get
        getPostingComments() {
            getFrontApiDataV2('GET', `/linker/posting/${this.postingIndex}/comments`
                , null, this.setPostingComments);
        },
        //endregion
        //region setPostingComments 포스팅 Set
        setPostingComments(data) {
            this.comments = data;
            this.calculateCommentAreaMargin();
        },
        //endregion
        //region focusCommentTextarea 댓글 작성 유저 권한 체크
        focusCommentTextarea(e) {
            if( this.safariVersion>= 15 ){
                document.getElementById('commentArea').style.marginBottom = '3.84rem';
            }

            if( !this.isLogin ) {
                if( confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠어요?') )
                    this.$emit('goLoginPage');
                e.target.blur();
            } else if( !this.isProfileRegister ) {
                this.$emit('openProfileWrite');
                e.target.blur();
            }
        },
        //endregion
        //region postComment 댓글 등록
        postComment() {
            if( !this.isLogin ) {
                this.goLoginPage();
                return false;
            } else if( !this.isProfileRegister ) {
                this.$emit('openProfileWrite');
                return false;
            }

            const data = {
                postingIndex : this.postingIndex,
                content : this.commentContent
            }
            if( this.upperCommentIndex != null )
                data.upperCommentIndex = this.upperCommentIndex;

            fnAmplitudeEventMultiPropertiesAction('click_upload_comment', '', '');

            getFrontApiDataV2('POST', '/linker/posting/comment', data, this.successRegisterComment)
        },
        //endregion
        //region postReComment 대댓글 등록
        postReComment(comment) {
            this.upperCommentIndex = comment.commentIndex;
            const textarea = document.getElementById('comment');
            textarea.placeholder = this.createReCommentPlaceHolder(comment.creatorNickname);
            textarea.focus();
        },
        createReCommentPlaceHolder(nickName) {
            let name = nickName.length > 5 ? (nickName.substr(0, 5)+'...') : nickName;
            return `${name}님에게 답글을 입력해주세요`;
        },
        blurComment(e) {
            if( this.safariVersion>= 15 ) {
                document.getElementById('commentArea').style.marginBottom = '';
            }
            e.target.placeholder = '답글을 입력해주세요';
        },
        //endregion
        //region successRegisterComment 댓글 등록 성공
        successRegisterComment() {
            this.getPostingComments();
            this.commentContent = '';
            this.upperCommentIndex = null;
            $("textarea.autosize").height(1).height( $(this).prop('scrollHeight'));
        },
        //endregion
        //region postClap 박수 등록
        postClap() {
            if( !this.isLogin ) {
                this.goLoginPage();
                return false;
            }

            const _this = this;

            const success = function(data) {
                if( data.result )
                    _this.posting.clapCount++;
                else
                    alert('고마워요! 하지만 박수는 다섯번까지만 칠 수 있어요 :)');
            }
            const fail = function(e) {
                console.log(e);
            }

            fnAmplitudeEventMultiPropertiesAction('click_posting_clap', 'forum_index|posting_index|place',
                `${this.forumIndex}|${this.postingIndex}|posting_popup`);

            getFrontApiDataV2('POST', `/linker/posting/${this.postingIndex}/clap`, null, success, fail);
        },
        //endregion
        //region numberFormat 숫자 format
        numberFormat(number) {
            if( number == null || isNaN(number) )
                return '0';
            else
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        //endregion
        //region calculateCommentAreaMargin 댓글 영역 하단 마진 계산
        calculateCommentAreaMargin() {
            /* comment 영역 height 계산 */
            setTimeout(function() {
                var h_botom_co = $('.bottom_comment').height()+60;
                $('.my_comment_area').css( { margin: `0 0 ${h_botom_co}px 0` } );
            }, 500);

            /* textarea 자동 높이 조절 */
            $("textarea.autosize").on('keydown keyup', function (e) {
                if( e.target.value === '' ) {
                    $(this).height('3.79rem');
                } else {
                    const scrollHeight = $(this).prop('scrollHeight');
                    $(this).height(1).height( scrollHeight > 55 ? 55 : scrollHeight);
                }
            });
        },
        //endregion
        //region modifyPosting 포스팅 수정
        modifyPosting() {
            if( this.posting.creator ) {
                this.$emit('modifyPosting', this.postingIndex);
                this.close();
            }
        },
        //endregion
        //region deletePosting 포스팅 삭제
        deletePosting() {
            if ( confirm('포스트를 제거하시겠어요?') ) {
                const success = function (data) {
                    location.reload();
                }
                getFrontApiDataV2('POST', `/linker/posting/delete/${this.postingIndex}`, null, success);
            }
        },
        //endregion
        //region wish 위시
        wish() {
            let url = '/wish';
            let data = {
                method : !this.posting.linkWish ? 'POST' : 'DELETE'
            };
            switch (this.posting.linkType) {
                case 1 : // 상품
                    url += '/item';
                    data.item_id = this.posting.linkValue;
                    break;
                case 7 : // 브랜드
                    url += '/brand';
                    data.brand_id = this.posting.linkValue;
                    break;
            }
            getFrontApiData('POST', url, data, this.successWish);
        },
        successWish() {
            this.posting.linkWish = !this.posting.linkWish;

            if( this.posting.linkWish ) {
                this.sendWishAmplitude('on');
                this.aniWish.playSegments([0,18], true);
            } else {
                this.sendWishAmplitude('off');
                this.aniWish.playSegments([18,30], true);
            }
        },
        sendWishAmplitude(on_off) {
            const idType = this.posting.linkType === 1 ? 'itemid' : 'brand_id';
            fnAmplitudeEventMultiPropertiesAction('click_wish', `on_off|place|${idType}`,
                `${on_off}|linker_posting|${this.posting.linkValue}`);
        },
        createWishAnimation() {
            this.aniWish = bodymovin.loadAnimation({
                container: document.querySelector('#wish figure'),
                loop: false,
                autoplay: false,
                path: 'https://assets2.lottiefiles.com/private_files/lf30_jgta4mcw.json'
            });
            if( this.posting.linkWish ) {
                this.aniWish.goToAndStop(18, true);
            } else {
                this.aniWish.goToAndStop(0, true);
            }
        },
        //endregion
        //region clickReportPosting 포스팅 신고하기 클릭
        clickReportPosting() {
            if( this.posting.reported )
                this.cancelReportPosting();
            else
                this.reportPosting();
        },
        //endregion
        //region reportPosting 포스팅 신고
        reportPosting() {
            if( !this.posting.creator && confirm('포스트를 신고하시겠어요?') ) {
                const _this = this;
                const success = function(result) {
                    if( !result ) {
                        alert('이미 신고하셨습니다.');
                    } else {
                        _this.showPostingReportBubble = true;
                        setTimeout(() => _this.showPostingReportBubble = false, 5000);
                    }
                    _this.posting.reported = true;
                }
                getFrontApiDataV2('POST', `/linker/posting/${this.postingIndex}/report`, null, success);
            }
        },
        //endregion
        //region cancelReportPosting 포스팅 신고 취소하기
        cancelReportPosting() {
            if( !this.posting.creator && confirm('신고를 취소하시겠어요?') ) {
                const _this = this;
                const success = function() { _this.posting.reported = false; }
                getFrontApiDataV2('POST', `/linker/posting/${this.postingIndex}/report/delete`, null, success);
            }
        },
        //endregion
        //region goLink 링크 이동
        goLink() {
            switch(this.posting.linkType) {
                case 1: this.goLinkProduct(); break;
                case 2: this.goLinkEvent(); break;
                case 7: this.goLinkBrand(); break;
                case 99: this.goLinkUrl(); break;
            }
        },
        //endregion
        //region goLinkProduct 링크 상품 이동
        goLinkProduct() {
            const itemId = this.posting.linkValue;
            if( this.linkerApp )
                fnAPPpopupProduct(itemId);
            else
                location.href = '/category/category_itemPrd.asp?itemid=' + itemId;
        },
        //endregion
        //region goLinkEvent 링크 이벤트 이동
        goLinkEvent() {
            const eventCode = this.posting.linkValue;
            if( this.linkerApp )
                fnAPPpopupEvent(eventCode);
            else
                location.href = '/event/eventmain.asp?eventid=' + eventCode;
        },
        //endregion
        //region goLinkBrand 링크 브랜드 이동
        goLinkBrand() {
            const brandId = this.posting.linkValue;
            if( this.linkerApp )
                callNativeFunction('popupBrand', {
                    "openType": OpenType.FROM_RIGHT,
                    "ltbs": [],
                    "title": "브랜드",
                    "rtbs": [BtnType.SEARCH, BtnType.CART],
                    "brandid": brandId
                });
            else
                location.href = '/brand/brand_detail2020.asp?brandid=' + brandId;
        },
        //endregion
        //region goLinkUrl 링크 외부링크 이동
        goLinkUrl() {
            window.open(this.posting.linkValue, '_blank');
        },
        //endregion
        //region goLoginPage 로그인 페이지 이동
        goLoginPage() {
            if( confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠어요?') )
                this.$emit('goLoginPage');
        },
        //endregion
        //region clearCommentInput 댓글 작성창 초기화
        clearCommentInput() {
            this.commentContent = '';
            this.upperCommentIndex = null;
            $(this).height('3.79rem');
        },
        //endregion
    },
    watch : {
        //region postingIndex 포스팅 달라질 때 마다 위시 lotti 다시 그림
        postingIndex() {
            const _this = this;
            if( _this.aniWish != null ) {
                _this.aniWish.destroy();
            }
            setTimeout(function() {
                if( _this.posting.linkType === 1 || _this.posting.linkType === 7 ) {
                    _this.createWishAnimation();
                }
            }, 150);
        },
        //endregion
    }
})