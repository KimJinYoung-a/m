Vue.component('WISH',{
    template : `
            <!-- 위시 버튼 -->
            <button :id="btn_id" type="button" @click="click_wish" :class="['btn_wish']">
                <figure class="ico_wish"></figure>
                <span class="cnt" v-if="wish_cnt > 0">{{number_format(wish_cnt)}}</span>
            </button>
    `,
    data() {return {
        aniWish : null
    }},
    mounted() {
        this.create_animation();
    },
    updated() {
        this.aniWish.destroy();
        this.create_animation();
    },
    props : {
        id : { // ID(product:item_id, brand:brand_id, event:evt_code)
            type : [String, Number],
            default : '0'
        },
        type : { // 위시 Type (product: 상품, brand: 브랜드)
            type : String,
            default : 'product'
        },
        place : { // 사용되는 곳
            type : String,
            default : 'place'
        },
        on_flag : { // On/Off Flag (true: on / false: off)
            type : Boolean,
            default : false
        },
        is_white : { // 테두리 하얀색 여부(바탕이 하얗지 않을떄)
            type : Boolean,
            default : false
        },
        isApp : {type : Boolean, default : false}, // 앱 여부
        wish_cnt : {type : Number, default : 0}, // 위시 수
        category: {type:Number, default:0}, // 현재 카테고리
        brand: {type:String, default:''}, // 브랜드ID
        product_name: {type:String, default:''}, // 상품명
        brand_name_en: {type:String, default:''}, // 브랜드 영문 명
        view_type: {type:String, default:''}, // 뷰 타입
        sort: {type:String, default:''}, // 정렬
        filter_recommend: {type:Array, default:function(){return [];}}, // 필터 - 추천
        filter_category: {type:Array, default:function(){return [];}}, // 필터 - 카테고리
        filter_brand: {type:Array, default:function(){return [];}}, // 필터 - 브랜드ID
        filter_delivery: {type:Array, default:function(){return [];}}, // 필터 - 배송
        filter_lowprice: {type:String, default:''}, // 필터 - 가격 최저가
        filter_highprice: {type:String, default:''}, // 필터 - 가격 최고가
    },
    computed : {
        btn_id() { // 버튼 ID
            return `wish_${this.place}_${this.id}_${Math.round(Math.random()*100)}`;
        }
    },
    methods : {
        // 위시 등록/제거
        click_wish : function (event) {
            if( this.on_flag ) {
                // 위시 제거
                if( this.call_wish_api('delete') ) {
                    this.aniWish.playSegments([18,30], true);
                    this.$emit('change_wish_flag', this.id, false);
                }
            } else {
                // 위시 등록
                if( this.call_wish_api('post') ) {
                    this.aniWish.playSegments([0,18], true);
                    this.$emit('change_wish_flag', this.id, true);
                }
            }
        },

        // CALL API
        call_wish_api : function (method) {
            const _this = this;
            let _url = apiurl + '/wish';
            let request = {
                method : method
            };
            switch (this.type) {
                case 'product' : // 상품
                    _url += '/item';
                    request.item_id = this.id;
                    break;
                case 'brand' : // 브랜드
                    _url += '/brand';
                    request.brand_id = this.id;
                    break;
            }

            let result = false;
            $.ajax({
                type : 'POST',
                url: _url,
                data: request,
                ContentType : "json",
                crossDomain: true,
                async: false,
                xhrFields: {
                    withCredentials: true
                },
                success: function(data) {
                    result = true;

                    _this.send_amplitude(method === 'post' ? 'on' : 'off'); // Amplitude 전송
                    //_this.send_datadive(method === 'post');
                },
                error: function (xhr) {
                    console.log(xhr);
                    const error = JSON.parse(xhr.responseText);
                    if( error.code === -10 ) {
                        if( _this.isApp ) {
                            fnAPPpopupLogin(location.pathname + location.search);
                        } else {
                            location.href = '/login/login.asp?backpath=' + location.pathname + location.search;
                        }
                    }
                }
            });
            return result;
        },
        // 앰플리튜드 전송
        send_amplitude(on_off) {
            const parameter = this.create_amplitude_parameter(on_off);
            fnAmplitudeEventMultiPropertiesAction('click_wish', parameter.keys, parameter.values);
        },
        // Amplitude 파라미터 생성
        create_amplitude_parameter(on_flag) {
            let keys = 'on_off|place';
            let values = on_flag + '|' + this.place;

            // 카테고리
            if( this.category !== 0 ) {
                keys += '|category';
                values += '|' + this.category;
            }

            // 브랜드
            if( this.brand !== '' ) {
                keys += '|brand';
                values += '|' + this.brand;
            }

            // 보기모드
            if( this.view_type !== '' ) {
                keys += '|list_type';
                values += '|' + (this.view_type === 'photo' ? 'photo' : 'list');
            }

            // 정렬
            let sort_name = amplitudeSort(this.sort);
            if( sort_name !== '' ) {
                keys += '|sort';
                values += '|' + sort_name;
            }

            // 필터 - 추천
            if( this.filter_recommend != null && this.filter_recommend.length > 0 ) {
                keys += '|filter_recommend';
                values += '|' + this.filter_recommend.join(',');
            }

            // 필터 - 카테고리
            if( this.filter_category != null && this.filter_category.length > 0 ) {
                keys += '|filter_category';
                values += '|' + this.filter_category.join(',');
            }

            // 필터 - 브랜드
            if( this.filter_brand != null && this.filter_brand.length > 0 ) {
                keys += '|filter_brand';
                values += '|' + this.filter_brand.join(',');
            }

            // 필터 - 배송
            if( this.filter_delivery != null && this.filter_delivery.length > 0 ) {
                keys += '|filter_delivery';
                values += '|' + this.filter_delivery.join(',');
            }

            // 필터 - 가격 최저가
            if( this.filter_lowprice !== '' && !isNaN(this.filter_lowprice) ) {
                keys += '|filter_lowprice';
                values += '|' + Number(this.filter_lowprice);
            }

            // 필터 - 가격 최고가
            if( this.filter_highprice !== '' && !isNaN(this.filter_highprice) ) {
                keys += '|filter_highprice';
                values += '|' + Number(this.filter_highprice);
            }

            // 상품ID
            if( this.type === 'product' && !isNaN(this.id) && Number(this.id) > 0 ) {
                keys += '|itemid';
                values += '|' + this.id;
            }

            // 브랜드ID
            if( this.type === 'brand' && this.id !== '' ) {
                keys += '|brand_id';
                values += '|' + this.id;
            }

            return {
                keys : keys,
                values : values
            };
        },
        // 위시 이벤트 애니메이션 생성
        create_animation() {
            const _this = this;
            const lottie_path = this.is_white ? 'https://assets4.lottiefiles.com/private_files/lf30_n9czk9v0.json'
                : 'https://assets2.lottiefiles.com/private_files/lf30_jgta4mcw.json';
            this.aniWish = bodymovin.loadAnimation({
                container: document.querySelector('#' + _this.btn_id + ' .ico_wish'),
                loop: false,
                autoplay: false,
                path: lottie_path
            });
            if( this.on_flag ) {
                this.aniWish.goToAndStop(18, true);
            } else {
                this.aniWish.goToAndStop(0, true);
            }
        }
    }
})