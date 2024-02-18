
const app = new Vue({
    el : '#app',
    store : store,
    mixins: [linker_mixin, modal_mixin],
    template : `
        <div class="content anniv20">
            <FORUM-INFO :forumIndex="forumIndex" :forum="forum" :forumCnt="forumCount" :descriptions="descriptions" 
                @openForumDescription="openForumDescription" @openForumList="openForumList"/>
            <!-- 포스팅 리스트 -->
            <div class="forum_posting">
                <div v-if="this.myProfile.registration" class="check_mypost">
                    <input @click="viewMyPostings" type="checkbox" id="mypost" :checked="onlyMyPosting">
                    <label for="mypost">내 글만 보기</label>
                </div>
                
                <div class="forum-post-wrap">
                    <div class="grid" id="container">
                    </div>
                </div>
                <div class="empty_post" style="display:none;">
                    <span class="img_empty"></span>   
                    <p class="tit">아직 작성된 글이 없네요.</p>
                    <p class="txt">가벼운 마음으로 첫번째 글을<br/>
                        올려보는건 어떨까요?</p>
                </div>
                
                <div class="bg-bubble-wrap">
                    <template v-for="i in bubbleCount">
                        <div class="bg-big-bubble"></div>
                        <div class="bg-big-bubble type02"></div>
                    </template>
                </div>
            </div>
            
            <!-- 새 글 쓰기 -->
            <button @click="writePosting" type="button" class="btn_plus"><img src="http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_plus.png?v=2.2" alt=""></button>
            
            <!-- 포럼 설명 모달 -->
            <Modal :type="4" :linker="true" modal_id="forumDescription">
                <FORUM_DESCRIPTION slot="body" ref="forumDescription"/>
            </Modal>

            <!-- 포럼 목록 모달 -->
            <MODAL-FORUM-LIST v-if="showForumList" :forumList="forumList" @closeModal="hideForumList"/>
            
            <!-- 포럼 작성 모달 -->
            <MODAL-WRITE ref="modalWrite" v-show="showWriteModal" :profile="myProfile" :forumIndex="forumIndex"
                @clickLinkType="openLinkModal" @close="closeModalWrite"/>
                
            <!-- 링크 모달 -->
            <MODAL-LINK ref="modalLink" @addLink="addLink"/>
            
            <!-- 포스팅 자세히 보기 모달 -->
            <MODAL-POSTING ref="modalPosting" :isLogin="isLogin" :isProfileRegister="myProfile.registration" :forumIndex="forumIndex"
                @modifyPosting="modifyPosting" @goLoginPage="goLoginPage" @openProfileWrite="showProfileModal = true"
                @close="unlockBodyScroll"/>
            
            <!-- 프로필 작성 모달 -->
            <MODAL-PROFILE-WRITE v-if="showProfileModal" :linker="true" :myProfile="myProfile" :userId="myProfile.userId"
                @closeModal="closeProfileModal" @completePostProfile="completePostProfile"/>
                
            <!-- 탑 버튼 -->
			<Button-Top/>
        </div>
    `,
    data() {return {
        ig : null, // InfiniteGrid
        forumIndex : 0, // 포럼 일련번호
        showWriteModal : false, // 작성 모달 노출 여부
        showProfileModal : false, // 프로필 작성 모달 노출 여부
        loadingPosting : false, // 포스팅 리스트 로딩 중 여부
        lastPostingIndex : 0, // 마지막 포스팅 일련번호
        onlyMyPosting : false, // 내 글만 보기 여부
        viewAllPostings : false, // 포스팅 마지막페이지까지 모두 불러왔는지 여부
        clapingElement : null, // 박수치고 있는 중인 엘리먼트
        postingAreaHeight : 0, // 현재 포스팅 영역 높이
        showForumList: false, // 포럼 리스트 모달 노출 여부
    }},
    //region created
    created() {
        this.forumIndex = forumIndex;
        this.onlyMyPosting = onlyMyPosting;
        this.$store.dispatch('GET_MY_PROFILE');
        this.$store.dispatch('GET_MY_CLAP_COUNTS');
        this.$store.dispatch('GET_FORUM_INFO', forumIndex);
        this.$store.dispatch('GET_DESCRIPTIONS', this.linkerApp);
        this.$store.dispatch('GET_FORUMS');
    },
    //endregion
    //region mounted
    mounted() {
        this.createInfininiteGrid();
        if( this.onlyMyPosting ) {
            this.getPostingsMore();
        } else {
            this.getFirstPostings();
        }

        if( place.startsWith('today_mainroll') )
            place = 'mainrolling';
        fnAmplitudeEventMultiPropertiesAction("view_forum","forum_index|place",`${forumIndex}|${place}`);
    },
    //endregion
    computed : {
        forum() { return this.$store.getters.forum; },
        myProfile() { return this.$store.getters.myProfile; },
        isLogin() { return this.myProfile.userId !== '' && this.myProfile.userId != null },
        forumList() { return this.$store.getters.forumList; },
        forumCount() { return this.$store.getters.forumCount; },
        descriptions() { return this.$store.getters.descriptions; },
        myClapCounts() { return this.$store.getters.myClapCounts; },
        bubbleCount() { return Math.round(this.postingAreaHeight/524); },
    },
    methods : {
        //region createInfiniteGrid InfiniteGrid 생성
        createInfininiteGrid() {
            this.ig = new eg.InfiniteGrid("#container", {
                isConstantSize: true,
                transitionDuration: 0.5,
                useRecycle : true,
                useFit : true,
                isEqualSize : false,
                threshold : 10,
                renderExternal : true,
            }).on({
                "append" : this.appendPosting,
                "layoutComplete" : this.layoutCompleteInfiniteGrid
            });
            this.ig.setLayout(eg.InfiniteGrid.GridLayout, {align: "center", margin:0});
        },
        //endregion
        //region layoutCompleteInfiniteGrid 그리드 레이아웃 추가 완료시 배경 버블 추가를 위한 height 계산
        layoutCompleteInfiniteGrid(e) {
            if( e.isAppend ) {
                this.postingAreaHeight = document.querySelector('.forum_posting').offsetHeight;
            }
        },
        //endregion
        //region openForumDescription 포럼 설명 모달 open
        openForumDescription(descriptionContent) {
            this.$refs.forumDescription.setDescription(descriptionContent);
            this.open_pop('forumDescription');
        },
        //endregion
        //region getFirstPostings 첫 포스팅 리스트 조회(캐시데이터)
        getFirstPostings() {
            getFrontApiDataV2('GET', '/linker/postings/forum/' + this.forumIndex,
                null, this.successGetPostings);
        },
        //endregion
        //region getPostingsMore 포스팅 더 불러오기
        getPostingsMore() {
            getFrontApiDataV2('GET', `/linker/postings/forum/${this.forumIndex}/max/${this.lastPostingIndex}/mine/${this.onlyMyPosting}`,
                null, this.successGetPostings);
        },
        //endregion
        //region successGetPostings 포스팅 불러오기 성공
        successGetPostings(data) {
            if( data.length > 0 ) {
                const html = [];
                for( let i=0 ; i<data.length ; i++ ) {
                    html.push(this.createPostingHtml(data[i]));
                }
                this.ig.append(html);
                this.lastPostingIndex = data[data.length - 1].postingIdx;
            } else {
                if( this.lastPostingIndex === 0 ) {
                    $('.bg-bubble-wrap').hide();
                    $('.empty_post').show();
                }

                this.viewAllPostings = true;
            }
            this.loadingPosting = false;
        },
        //endregion
        //region appendPosting 포스팅 html 더하기
        appendPosting() {
            if( this.loadingPosting || this.viewAllPostings )
                return false;
            else {
                this.loadingPosting = true;
                this.getPostingsMore();
            }
        },
        //endregion
        //region createPostingHtml 포스팅 Html 생성
        createPostingHtml(posting) {
            let blockedHtml = '';
            if( posting.blocked ) {
                this.clearBlockedPostingData(posting);
                blockedHtml = this.createPostingBlockedHtml();
            }

            let longContent = false;
            if( posting.postingContent.length > 200 ) {
                longContent = true;
                posting.postingContent = posting.postingContent.substr(0, 200) + '...';
            }

            if( posting.userDescription === 'RED' || posting.userDescription === 'WHITE' ) {
                posting.userDescription = null;
            }

            let linkHtml = this.createPostingLinkHtml(posting);
            const commentHtml = this.createPostingCommentHtml(posting);
            const clapHtml = this.createPostingClapHtml(posting);

            return `<div class="grid-item" data-idx="${posting.postingIdx}">
                        <div class="post-position ${posting.clapCount >= 30 ? 'over-clap' : ''} ${(!longContent && posting.commentCount === 0) ? 'only-txt' : ''}">
                            <div class="post-list">
                                <div class="profile ${posting.hostOrGuest ? 'p_infu' : ''}"><div class="bd_pro"><img src="${posting.userImage}" alt=""></div></div>
                                ${posting.userDescription ? '<p class="level">' + posting.userDescription + '</p>' : ''}
                                <p class="nick-name">${posting.userNickname}</p>
                                ${linkHtml}
                                <p class="conts">${this.escapeContent(posting.postingContent)}</p>
                                ${longContent ? '<button type="button" class="btn-more">더보기</button>' : ''}
                                ${commentHtml}
                                ${clapHtml}
                                ${blockedHtml}
                            </div>
                        </div>
                    </div>`;
        },
        //endregion
        //region escapeContent 내용 escape
        escapeContent(content) {
            return content.replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;')
        },
        //endregion
        //region clearBlockedPostingData 블락된 포스팅 내용 없앰
        clearBlockedPostingData(posting) {
            posting.postingContent = '';
            posting.userImage = '';
            posting.userNickname = '';
            posting.linkTitle = '';
        },
        //endregion
        //region createPostingBlockedHtml 포스팅 블락부분 HTML 생성
        createPostingBlockedHtml() {
            return `
                <div class="bg_blind">
                    <span class="icon"></span>
                    <p>여러 명의 신고로<br/>가려진 포스팅입니다</p>    
                </div>
            `;
        },
        //endregion
        //region createPostingClapHtml 포스팅 박수 HTML 생성
        createPostingClapHtml(posting) {
            const lottieHtml = this.createPostingLottieHtml(posting.clapCount);
            return `
                <div onclick="app.openPosting(this, '${posting.postingIdx}', ${posting.blocked})" class="lottie-view">
                    ${lottieHtml}
                </div>
                <button onclick="app.postClap(this, ${posting.postingIdx})" type="button" class="btn-like-clap ico-clap ${posting.clapCount >= 30 ? 'on' : ''}">
                    <div class="border">
                        <div class="like-clap">
                            <span class="icon"></span>
                            <span class="clap-count">${posting.clapCount}</span>
                        </div>
                    </div>
                </button>
            `;
        },
        createPostingLottieHtml(clapCount) {
            let html = '';
            for( let i=1 ; i<=5 ; i++ )
                html += `<lottie-player class="ico-claps" src="/vue/linker/bubble0${i}.json?v=1.0" background="transparent" ${(i===5 && clapCount >= 30) ? 'autoplay loop' : ''}></lottie-player>`;
            return html;
        },
        //endregion
        //region createPostingLinkHtml 링크 부분 Html 생성
        createPostingLinkHtml(posting) {
            let linkHtml = '';
            if( posting.linkTitle != null ) {
                if( posting.linkType === 99 )
                    posting.linkThumbnail = 'http://fiximage.10x10.co.kr/web2021/anniv2021/m/icon_url_default.png?v=1.1';

                linkHtml = `
                    <div class="plan">
                        <div class="thum ${posting.linkType === 2 ? 'produce' : ''}">
                            <img src="${posting.linkThumbnail}" alt="" 
                                onerror="app.getCurrentItemBasicImage(this, ${posting.postingIdx}, ${posting.linkType}, ${posting.linkValue})">
                        </div>
                    </div>`;
            }
            return linkHtml;
        },
        //endregion
        //region getCurrentItemBasicImage 링크 상품 에러 이미지 현재 상품 이미지로 교체
        getCurrentItemBasicImage(el, postingIdx, linkType, linkValue) {
            if( linkType !== 1 ) // 일단 상품만 지원
                return false;

            const no_img = '//fiximage.10x10.co.kr/m/2020/common/no_img.svg';
            if( el.src !== no_img ) {
                this.getUpdatedPostingLinkThumbnailImage(postingIdx, linkValue, el, no_img);
            } else {
                el.parentElement.remove();
            }
        },
        getUpdatedPostingLinkThumbnailImage(postingIdx, itemId, el, no_img) {
            const url = `/linker/posting/${postingIdx}/link/item/${itemId}/thumbnail`;
            const success = data => {
                if( el.src === data.image )
                    el.src = no_img;
                else if( el.src === no_img )
                    el.parentElement.remove();
                else
                    el.src = data.image;
            };

            getFrontApiDataV2('PUT', url, null, success, () => el.parentElement.remove());
        },
        //endregion
        //region createPostingCommentHtml 댓글 부분 Html 생성
        createPostingCommentHtml(posting) {
            let commentHtml = '';
            if( posting.commentCount > 0 ) {
                let profileClass = '';
                if( posting.commentImages.length >= 3 ) {
                    profileClass = 'third';
                } else if( posting.commentImages.length === 2 ) {
                    profileClass = 'two';
                }

                let profileHtml = '';
                const commentImagesLength = posting.commentImages.length > 3 ? 3 : posting.commentImages.length;
                for( let i=0 ; i<commentImagesLength ; i++ ) {
                    profileHtml += `<div class="feed-profile pro0${i+1}"><img src="${posting.commentImages[i]}" alt=""></div>`;
                }

                commentHtml = `
                    <div class="feed-area">
                        <div class="feed-count"><span class="icon"></span><span class="count">${posting.commentCount}개</span></div>
                        <div class="profile-conts ${profileClass}">
                            ${profileHtml}
                        </div>
                    </div>
                `;
            }
            return commentHtml;
        },
        //endregion
        //region writePosting 새 포스팅 등록
        writePosting() {
            fnAmplitudeEventMultiPropertiesAction("click_add_posting","forum_index", this.forumIndex.toString());

            if ( !this.isLogin ) {
                if( confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠어요?') )
                    this.goLoginPage();
            } else if ( !this.myProfile.registration ) {
                this.lockBodyScroll();
                this.showProfileModal = true;
            } else {
                this.lockBodyScroll();
                this.showWriteModal = true;
            }
        },
        //endregion
        //region openLinkModal 링크 모달 열기
        openLinkModal(type) {
            this.$refs.modalLink.open(type);
        },
        //endregion
        //region addLink 링크 추가
        addLink(type, item) {
            this.$refs.modalWrite.addLink(type, item);
        },
        //endregion
        //region openPosting 포스팅 자세히 보기 모달 열기
        openPosting(el, postingIndex, blocked) {
            if( el.classList.contains('btn-like-clap') ) { // 박수버튼일 경우 박수
                this.postClap(el, postingIndex);
                return false;
            }

            if( blocked )
                return false;

            const positionIndex = this.getPostingPostingIndex(el);
            fnAmplitudeEventMultiPropertiesAction("click_posting","forum_index|posting_index|position_index",
                `${this.forumIndex}|${postingIndex}|${positionIndex}`);

            this.$refs.modalPosting.open(postingIndex);
            this.lockBodyScroll();
        },
        getPostingPostingIndex(el) {
            return $(el).closest('.grid-item').index();
        },
        //endregion
        //region modifyPosting 포스팅 수정
        modifyPosting(postingIndex) {
            this.showWriteModal = true;
            this.$refs.modalWrite.setModifyPostingData(postingIndex);
            setTimeout(this.lockBodyScroll, 300);
        },
        //endregion
        //region closeModalWrite 포스팅 작성 모달 닫기
        closeModalWrite() {
            this.showWriteModal = false;
            this.unlockBodyScroll();
        },
        //endregion
        //region completePostProfile 포스팅 프로필 등록 완료
        completePostProfile() {
            this.$store.dispatch('GET_MY_PROFILE');
            this.showProfileModal = false;
            this.unlockBodyScroll();
        },
        //endregion
        //region viewMyPostings 내 글만 보기
        viewMyPostings() {
            fnAmplitudeEventMultiPropertiesAction('click_show_mypost', 'forum_index', this.forumIndex.toString());
            location.replace(`?idx=${this.forumIndex}&me=${this.onlyMyPosting ? 0 : 1}`);
        },
        //endregion
        //region closeProfileModal 프로필 모달 닫기
        closeProfileModal() {
            this.showProfileModal = false;
            this.unlockBodyScroll();
        },
        //endregion
        //region postClap 박수 등록
        postClap(el, postingIndex) {
            if( !this.isLogin && confirm('로그인이 필요한 서비스입니다.\n로그인 하시겠어요?') ) {
                this.goLoginPage();
                return false;
            }

            if( this.clapingElement )
                return false;
            else
                this.clapingElement = el;

            const count = this.myClapCounts[postingIndex] ? this.myClapCounts[postingIndex] : 0;
            if( count >= 5 ) {
                alert('고마워요! 하지만 박수는 다섯번까지만 칠 수 있어요 :)');
                this.clapingElement = null;
                return false;
            }

            fnAmplitudeEventMultiPropertiesAction('click_posting_clap', 'forum_index|posting_index|place', `${this.forumIndex}|${postingIndex}|forum_main`);

            const uri = `/linker/posting/${postingIndex}/clap`;
            getFrontApiDataV2('POST', uri, null, this.successPostClap, () => this.clapingElement = null);
        },
        successPostClap(data) {
            if( data.result ) {
                const postingIndex = data.postingIdx;
                const prevClapCount = this.myClapCounts[postingIndex] ? this.myClapCounts[postingIndex] : 0;

                this.playLottie(prevClapCount);
                this.updateMyClapCounts(postingIndex, prevClapCount);

                this.clapingElement.querySelector('.clap-count').innerText = data.clapCount;
            } else {
                alert('고마워요! 하지만 박수는 다섯번까지만 칠 수 있어요 :)');
            }

            this.clapingElement = null;
        },
        playLottie(prevClapCount) {
            const lottie = this.getActiveLottie(prevClapCount);
            lottie.setDirection(1);
            lottie.play();
        },
        getActiveLottie(prevClapCount) {
            const parentElement = this.clapingElement.parentElement;
            return parentElement.querySelectorAll('lottie-player')[prevClapCount];
        },
        updateMyClapCounts(postingIndex, prevClapCount) {
            if( prevClapCount === 0 )
                this.$store.commit('PUT_MY_CLAP_COUNTS', postingIndex);
            else
                this.$store.commit('ADD_MY_CLAP_COUNTS', postingIndex);
        },
        //endregion
        //region lockBodyScroll, unlockBodyScroll 바디 스크롤 잠금/해제
        lockBodyScroll() {
            document.querySelector('body').classList.add('noscroll');
        },
        unlockBodyScroll() {
            document.querySelector('body').classList.remove('noscroll');
        },
        //endregion
        openForumList() {
            this.showForumList = true;
            this.lockBodyScroll();
        },
        hideForumList() {
            this.showForumList = false;
            this.unlockBodyScroll();
        }
    }
});