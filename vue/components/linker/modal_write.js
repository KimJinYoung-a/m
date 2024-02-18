Vue.component('MODAL-WRITE', {
    template : `
        <transition name="fade">
            <div class="modalV20 modal_anniv20 show">
                <div @click="close" class="modal_overlay"></div>
                <div class="anniv_modal_wrap login">
                    <div class="anniv_modal_header">
                        <div class="header_btn_area">
                            <button @click="close" type="button" class="btn_close"><i class="i_close"></i></button>
                            <button @click="register" type="button" :class="['btn_anniv_apply', {on : canRegister}]">등록하기</button>
                        </div>
                        <!--region 프로필-->
                        <div class="login_profile">
                            <div class="login_info_area">
                                <div class="img"><img :src="userThumbnail"></div>
                                <div class="info">
                                    <p class="txt">{{userDescription}}</p>
                                    <p class="id">{{profile.nickName}}</p>
                                </div>
                            </div>
                            <div class="count_word"><span>{{content.length}}</span> / 500자</div>
                        </div>
                        <!--endregion-->
                    </div>
                    <div class="anniv_modal_conts login">
                        <textarea v-model="content" class="" placeholder="내용을 입력해주세요." maxlength="500"></textarea>
                        
                        <!-- region 링크 추가 종류 탭 -->
                        <div v-show="!linkItem.id" class="link-list-area">
                            <span class="line"></span>
                            <div class="link_list">
                                <div @click="clickLinkType('product')" class="list_prd">
                                    <button type="button" class="btn_prd"></button>
                                    <p>상품</p>
                                </div>
                                <div @click="clickLinkType('brand')" class="list_prd">
                                    <button type="button" class="btn_brd"></button>
                                    <p>브랜드</p>
                                </div>
                                <div @click="clickLinkType('event')" class="list_prd">
                                    <button type="button" class="btn_produce"></button>
                                    <p>기획전</p>
                                </div>
                                <div @click="clickLinkType('url')" class="list_prd">
                                    <button type="button" class="btn_url"></button>
                                    <p>URL</p>
                                </div>
                            </div>
                        </div>
                        <!-- endregion -->
                        
                        <!-- region 링크 아이템 -->
                        <div v-show="linkItem.id" class="copy_view">
                            <div @click="clickLinkType(linkItemType)" class="link_info">
                                <div :class="linkThumbnailClass">
                                    <img :src="linkItem.image">
                                </div>
                                <div v-if="linkItemType === 'event'" class="link">
                                    <p class="pro_tit">기획전</p>
                                    <p class="pro_sub">{{linkItem.title}}</p>
                                </div>
                                <div v-else-if="linkItemType === 'product' || linkItemType === 'brand'" class="link">
                                    <p v-if="linkItemType === 'product'" class="tit">{{linkItem.subTitle}}</p>
                                    <p class="sub">{{linkItem.title}}</p>
                                </div>
                                <div v-else-if="linkItemType === 'url'" class="link">
                                    <p class="url">{{linkItem.title}}</p>
                                </div>
                            </div>
                            <button @click="clearLinkItem(true)" class="btn_link_close">닫기</button>
                        </div>
                        <!-- endregion -->
                    </div>
                </div>
            </div>
        </transition>
    `,
    data() {return {
        content : '', // 내용
        showLinkSelect : false, // 링크 종류탭 노출 여부
        linkItemType : '', // 링크 아이템 유형(상품:product, 브랜드:brand, 기획전:event, URL:url)
        linkItem : {}, // 링크 아이템
        postingIndex : null, // 포스팅 일련번호(수정용)
        isLoading : false, // 작성 중 여부
    }},
    props : {
        profile : {
            auth : { type:String, default:'N' },
            avataNo : { type:Number, default:0 },
            description : { type:String, default:'' },
            levelName : { type:String, default:'' },
            image : { type:String, default:'' },
            nickName : { type:String, default:'' }
        },
        forumIndex : { type:Number, default:0 }
    },
    computed : {
        //region canRegister 등록가능 여부
        canRegister() {
            return this.content.trim() !== '';
        },
        //endregion
        //region linkTypeNumber 링크 구분 숫자값(API전달용)
        linkTypeNumber() {
            switch (this.linkItemType) {
                case 'product': return 1;
                case 'event': return 2;
                case 'brand': return 7;
                default: return 99;
            }
        },
        //endregion
        //region userThumbnail 유저 썸네일 이미지
        userThumbnail() {
            if( this.profile.image != null && this.profile.image !== '' )
                return this.profile.image;
            else
                return `//fiximage.10x10.co.kr/web2015/common/img_profile_${this.profile.avataNo < 10 ? '0' : ''}${this.profile.avataNo}.png`;
        },
        //endregion
        //region userDescription 유저 설명
        userDescription() {
            if( this.profile.auth === 'H' || this.profile.auth === 'G' ) {
                return this.profile.description;
            } else if( this.profile.levelName !== 'RED' && this.profile.levelName !== 'WHITE' ) {
                return this.profile.levelName;
            } else {
                return '';
            }
        },
        //endregion
        //region linkThumbnailClass 링크 아이템 이미지 div 클래스
        linkThumbnailClass() {
            if( this.linkItem.id ) {
                if( this.linkItemType === 'event' )
                    return 'pro_img';
                else if( this.linkItemType === 'url' )
                    return 'url_img';
                else
                    return 'img';
            } else {
                return '';
            }
        },
        //endregion
    },
    methods : {
        //region clickLinkType 링크 추가 유형 클릭
        clickLinkType(type) {
            this.sendClickLinkTypeAmplitude(type);
            this.$emit('clickLinkType', type);
        },
        //endregion
        //region sendClickLinkTypeAmplitude 링크 추가 클릭 앰플리튜드 이벤트 전송
        sendClickLinkTypeAmplitude(type) {
            const amplitudeType = type === 'product' ? 'item' : type;
            fnAmplitudeEventMultiPropertiesAction("click_add_link","forum_index|type", `${this.forumIndex}|${amplitudeType}`);
        },
        //endregion
        //region close 모달 닫기
        close() {
            this.content = '';
            this.clearLinkItem();
            this.$emit('close');
        },
        //endregion
        //region addLink 링크 추가
        addLink(type, item) {
            this.linkItemType = type;
            this.linkItem = item;
        },
        //endregion
        //region clearLinkItem 링크 아이템 초기화
        clearLinkItem(isConfirm) {
            if( !isConfirm || confirm('링크를 제거하시겠어요?') ) {
                this.linkItemType = '';
                this.linkItem = {};
            }
        },
        //endregion
        //region register 등록하기
        register() {
            if( !this.isLoading && this.content.trim() !== '' && confirm('작성한 내용을 등록할까요?') ) {
                this.isLoading = true;
                fnAmplitudeEventMultiPropertiesAction("click_upload_posting","forum_index", this.forumIndex.toString());

                const data = this.createRegisterData();
                let url;
                if( this.postingIndex ) {
                    url = '/linker/posting/update';
                    data.postingIndex = this.postingIndex;
                } else {
                    url = '/linker/posting';
                    data.forumIndex = this.forumIndex;
                }

                getFrontApiDataV2('POST', url, data, this.successRegister, this.failRegister);
            } else if( this.isLoading ) {
                alert('등록 중이에요.\n잠시만 기다려주세요 :)');
            }
        },
        //endregion
        //region createRegisterData 등록 api 데이터 생성
        createRegisterData() {
            const data = {
                content : this.content
            };
            if( this.linkItem.id ) {
                data.linkType = this.linkTypeNumber;
                data.linkTitle = this.linkItem.title;
                data.linkValue = this.linkItem.id;
                data.thumbnailImage = this.linkItem.image;
            }
            return data;
        },
        //endregion
        //region successRegister 등록 성공 callback
        successRegister() {
            location.reload();
        },
        //endregion
        //region failRegister 등록 실패 callback
        failRegister() {
            this.isLoading = false;
        },
        //endregion
        //region setModifyPostingData 포스팅 수정 data Set
        setModifyPostingData(postingIndex) {
            const _this = this;
            const success = function(data) {
                _this.postingIndex = Number(postingIndex);
                _this.content = data.content;
                if( data.linkValue ) {
                    switch(data.linkType) {
                        case 1: _this.linkItemType = 'product'; break;
                        case 2: _this.linkItemType = 'event'; break;
                        case 7: _this.linkItemType = 'brand'; break;
                        default: _this.linkItemType = 'url'; break;
                    }
                    _this.linkItem = {
                        id : data.linkValue,
                        image : data.linkThumbnail,
                        title : data.linkTitle,
                        subTitle : data.linkDescription
                    }
                }
            }
            getFrontApiDataV2('GET', `/linker/posting/${postingIndex}`, null, success,
                function(){alert('존재하지 않는 포스팅입니다.');})
        },
        //endregion
    }
})