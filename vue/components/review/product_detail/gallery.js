Vue.component('GALLERY', {
    template : `
        <div class="review-gallery">
            <div class="swiper-container">
                <ul class="swiper-wrapper">
                    <li v-for="(review, index) in reviewGalleries" v-if="index < 9" @click="clickReviewGallery(index)"
                        :class="['swiper-slide', {'more-review' : isMoreReview(index)}]">
                        <span class="thumbnail">
                            <i :style="{'background-image':'url(' + decodeBase64(review.image) + ')'}"></i>
                            <em v-if="isMoreReview(index)">더보기</em>
                        </span>
                    </li>
                </ul>
            </div>
        </div>
    `,
    data() { return {
        swiper: null
    } },
    props : {
        reviewGalleries : { type : Array, default : function () {return [];} }
    },
    methods : {
        setSwiper() {
            if( this.swiper == null ) {
                this.swiper = new Swiper('.review-gallery .swiper-container', {
                    slidesPerView:'auto',
                    freeMode:true
                });
            }
        },
        clickReviewGallery(index) {
            this.$emit('clickReviewGallery', index, this.isMoreReview(index));
        },
        // 후기 갤러리 더보기 여부
        isMoreReview(index) {
            return index == 8 && this.reviewGalleries.length > 9;
        },
        // Base64 디코딩
        decodeBase64(str) {
            return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
        }
    }
});