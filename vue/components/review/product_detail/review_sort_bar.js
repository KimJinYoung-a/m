Vue.component('REVIEW-SORT-BAR', {
    template : `
        <div class="sortingbar">
            <!-- 정렬 옵션 -->
            <div class="option-left">
                <ul id="evalSearchOrderBy">
                    <li v-for="sm in sortMethods" @click="$emit('changeSortMethod', sm.value)"
                        :class="{'current' : reviewParameter.sortMethod === sm.value}">
                        {{sm.name}}
                    </li>
                </ul>
            </div>

            <!-- 상품 옵션 -->
            <template v-if="itemOptions.length > 0">
                <div class="option-right">
                    <button @click="expandProductOptions" class="btn-option btn btn-line-red">옵션별<span class="icon icon-arrow"></span></button>
                </div>
                <div class="lyDropdownOption">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <div class="dropBoxEval">
                                    <ul>
                                        <li @click="$emit('changeProductOption', '')" :class="{'on' : reviewParameter.productOptionCode === ''}">
                                            <div class="option">전체보기</div>
                                        </li>
                                        <li v-for="option in itemOptions"
                                            @click="$emit('changeProductOption', option.code)" :class="{'on' : reviewParameter.productOptionCode === option.code}">
                                            <div class="option">{{option.name}}</div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-scrollbar"></div>
                    </div>
                </div>
            </template>
        </div>
    `,
    data() {return {
        //region sortMethods 후기 정렬 기준 리스트
        sortMethods : [
            { 'name' : '최신순', 'value' : 'ne' },
            { 'name' : '높은평점순', 'value' : 'hs' },
            { 'name' : '낮은평점순', 'value' : 'rs' },
        ],
        //endregion
    }},
    props : {
        //region reviewParameter 후기 파라미터
        reviewParameter : {
            page : { type:Number, default:1 }, // 현재 후기 페이지
            pageSize : { type:Number, default:1 }, // 페이지 별 노출 후기 수
            productOptionCode : { type:String, default:'' }, // 페이지 별 노출 후기 수
            reviewType : { type:String, default:'a' }, // 후기 유형
            sortMethod : { type:String, default:'ne' }, // 후기 정렬 기준
        },
        //endregion
        //region itemOptions 상품 옵션 리스트
        itemOptions : {
            code : { type:String ,default:'' }, // 상품 옵션 코드
            name : { type:String ,default:'' }, // 상품 옵션 명
        },
        //endregion
    },
    methods : {
        //region expandProductOptions 후기 상품옵션 펼치기
        expandProductOptions() {
            $( ".lyDropdownOption" ).slideToggle("300");
            $( ".sortingbar .option-right button" ).toggleClass("on");

            new Swiper('.lyDropdownOption .swiper-container', {
                scrollbar:'.lyDropdownOption .swiper-scrollbar',
                direction:'vertical',
                slidesPerView:'auto',
                mousewheelControl:true,
                freeMode:true
            });
        },
        //endregion
    }
})