Vue.component('Product-Image-Svg',{
    template : `
                <!-- 상품 리스트 SVG 이미지 영역 -->
                <figure class="prd_img_svg">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 750 750">
                        <g :class="get_shape_class">
                            <image href="//fiximage.10x10.co.kr/m/2020/common/no_img.svg"/>
                            <image :href="image_url" preserveAspectRatio="xMidYMid slice"/>
                            <image v-if="get_mask_src" :href="get_mask_src"/>
                        </g>
                    </svg>
                </figure>
    `,
    data() {return {
        shape : 'circle'
    }},
    mounted() {
        this.shape = this.shape_type;
    },
    props : {
        shape_type : {type:String, default:'circle'}, // SVG 모양
        sell_flag : {type:String, default:'Y'}, // 판매상태
        adult_type : {type:Number, default:0}, // 성인상품 구분
        image_url : {type:String, default:''} // 이미지 url
    },
    computed : {
        // 모양 class
        get_shape_class : function () {
            return 'shp' + this.get_shape_number;
        },

        // 마스크 이미지 src
        get_mask_src : function() {
            const isSoldout = this.sell_flag !== 'Y'; // 품절여부
            const isAdult = this.adult_type === 1; // 성인상품여부

            if( isSoldout && isAdult ) {
                return '//fiximage.10x10.co.kr/m/2020/common/mask_b' + this.get_shape_number + '.jpg';
            } else if( isSoldout ) {
                return '//fiximage.10x10.co.kr/m/2020/common/mask_s' + this.get_shape_number + '.png';
            } else if( isAdult ) {
                return '//fiximage.10x10.co.kr/m/2020/common/mask_a' + this.get_shape_number + '.jpg';
            } else {
                return '//fiximage.10x10.co.kr/m/2020/common/mask_dim.png';
            }
        },

        // SVG 유형별 숫자 값
        get_shape_number : function () {
            switch (this.shape) {
                case 'circle' : return 1; // 원
                case 'round_diamond' : return 2; // 둥근 마름모
                case 'diamond' : return 3; // 마름모
                case 'star_diamond' : return 4; // 별 마름모
                case 'speech_bubble' : return 5; // 말풍선
                case 'clover' : return 6; // 클로버
                case 'bumpy' : return 7; // 울퉁불퉁한 원
                case 'random' : return Math.floor(Math.random() * (8 - 1)) + 1; // 랜덤
            }
        }
    },
    methods : {
        change_image_shpae() {
            const shape_arr = ['circle','round_diamond','diamond','star_diamond','speech_bubble','clover','bumpy'];
            this.shape = shape_arr[Math.floor(Math.random() * (8 - 1))];
        }
    }
})