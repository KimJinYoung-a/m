Vue.component('GALLERY-MODAL', {
    template: `
        <div class="ly-review-gallery" style="display: block;">
            <div class="swiper-container">
                <ul class="swiper-wrapper">
                    <li v-for="review in reviewGalleries" class="swiper-slide">
                        <a @click="clickLayerReviewGallery(review.index)">
                            <span class="thumbnail">
                                <i class="swiper-lazy" :style="{'background-image' : 'url(' + decodeBase64(review.image) + ')'}">
                                    <div class="swiper-lazy-preloader"></div>
                                </i>
                            </span>
                            <div class="review-info">
                                <div class="writer">
                                    <span :class="getLayerReviewGalleryUserLevelThumbnailClass(review.userLevel)"></span>
                                    <span>{{review.userId}}</span>
                                </div>
                                <div class="review-conts items">
                                    <div v-if="review.itemOptionName" class="purchaseOption">
                                        <em class="ellipsis">{{review.itemOptionName}}</em>
                                    </div>
                                    <span class="icon icon-rating">
                                        <i :style="{'width' : review.point + '%'}"></i>
                                    </span>
                                    <div class="txt-review">{{review.content}}</div>
                                    <b>본문 더보기</b>
                                </div>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
            <button @click="closeModal" class="btn-close"></button>
        </div>
    `,
    data() {return {
        slider : null
    }},
    props: {
        reviewGalleries : { type: Array, default: function () { return []; } }
    },
    methods : {
        clickLayerReviewGallery(reviewIndex) {
            this.$emit('clickLayerReviewGallery', reviewIndex);
        },
        // 레이어 후기 갤러리 유저 등급 썸네일 클래스
        getLayerReviewGalleryUserLevelThumbnailClass(userLevel) {
            return ['thumb', this.getUserLevelClass(userLevel)];
        },
        // GET 유저 등급 클래스명
        getUserLevelClass(userLevel) {
            switch(userLevel) {
                case 1: return "red";
                case 2: return "vip";
                case 3: return "vipgold";
                case 4:
                case 6:
                case 7:
                    return "vvip";
                default:
                    return "white";
            }
        },
        // Base64 디코딩
        decodeBase64(str) {
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        },
        setSlider(index) {
            this.slider = new Swiper('.ly-review-gallery .swiper-container', {
                slidesPerView:'auto',
                preloadImages:false,
                lazy:true,
                initialSlide: index
            });
        },
        closeModal() {
            this.$emit('closeModal');
        }
    }
});