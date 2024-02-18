Vue.component('Sortbar',{
    template : `
            <!-- 정렬바 컴포넌트 (sortbar) -->
            <div :class="['sortbar', {biz_sortbar : is_biz}]">
                <div class="sort_l">
                    <button @click="open_pop('modal_sorting')" class="drpdown"><span>{{sort_text}}</span><i class="i_arw_d2"></i></button>
                </div>
                <div v-if="kkomkkom_flag" class="sort_r">
                    <button @click="pop_kkomkkom" :class="kkomkkom_btn_class">꼼꼼하게 찾기</button>
                    <p @click="kkomkkom_reset" v-if="do_search_flag && is_show_kkomkkom_btn" class="bbl_blk bbl_t"><i class="i_refresh2"></i>초기화 할까요?</p>
                </div>
            </div>
    `,
    data() {return {
        is_show_kkomkkom_btn : true // 꼼꼼하게찾기 버튼 4초 후 사라지는 타이머
    };},
    mounted() {
        this.reset_kkomkkom_flag(); // 꼼꼼하게 찾기 reset for 4초 타이머
    },
    props : {
        isApp : {type:Boolean, default:false}, // 앱 여부
        sort : {type:String, default:''}, // 정렬 값
        search_type : {type:String, default:''}, // 검색구분값
        kkomkkom_flag : {type:Boolean, default:false}, // 꼼꼼하게 찾기 사용 여부
        do_search_flag : {type:Boolean, default:false}, // 꼼꼼하게 찾기 이후 상태인지 여부
        is_biz : {type:Boolean, default:false}, // Biz 여부 (css클래스 추가)
    },
    computed : {
        sort_text : function () { // 정렬 노출 텍스트

            let type_str = '';
            if( this.search_type !== '' ) {
                switch (this.search_type) {
                    case 'product': type_str = '상품'; break;
                    case 'review': type_str = '상품후기'; break;
                    case 'exhibition': type_str = '기획전'; break;
                    case 'event': type_str = '이벤트'; break;
                    case 'brand': type_str = '브랜드'; break;
                }
            }

            let sort_str;
            switch (this.sort) {
                case 'new': sort_str = '신규'; break;
                case 'bs': sort_str = '판매량'; break;
                case 'best': sort_str = '인기'; break;
                case 'br': sort_str = '평가좋은'; break;
                case 'lp': sort_str = '낮은가격'; break;
                case 'hp': sort_str = '높은가격'; break;
                case 'hs': sort_str = '할인율'; break;
                case 'ws': sort_str = '위시'; break;
                case 'rc': sort_str = '추천'; break;
                case 'duedate': sort_str = '마감임박'; break;
                case 'eng': sort_str = '영어정렬'; break;
                case 'kor': sort_str = '한글정렬'; break;
                case 'rank': sort_str = '판매순위'; break;
            }
            return (type_str !== '' ? type_str + '/' : '') + sort_str + '순으로 보기';
        },
        kkomkkom_btn_class() { // 꼼꼼하게 찾기 버튼 클래스
            return ['btn_type2', 'btn_wht', {'on' : this.do_search_flag}];
        }
    },
    methods : {
        // 꼼꼼하게찾기 버튼 클릭 - 꼼꼼하게찾기 팝업
        pop_kkomkkom : function () {
            this.$emit('pop_kkomkkom');
        },

        // 초기화 하실래요? 클릭 - 꼼꼼하게 찾기 초기화
        kkomkkom_reset : function () {
            this.$emit('kkomkkom_reset');
        },
        set_sortbar_float() { // 정렬 옵션 상단 플로팅 (카테고리 상세, 브랜드 상세)
            var sortbar = $('.sortbar'),
                sortbarTop = sortbar.offset().top,
                headerH = $('.tenten_header').outerHeight(),
                itemBtn = $('.ctgr_nav_group .btn_more');

            $(window).on('scroll', function () {
                if(!itemBtn.is(':visible') && !(sortbar.hasClass('fixed'))) sortbarTop = sortbar.offset().top; // 카테고리 상세 접힌 영역 때문에 추가
    
                if($(window).scrollTop() >= (sortbarTop - headerH + 100)) {
                    sortbar.addClass('fixed');
                } else {
                    sortbar.removeClass('fixed');
                }        
            });
        },
        reset_kkomkkom_flag() { // 꼼꼼하게 찾기 reset for 4초 타이머
            const _this = this;
            _this.is_show_kkomkkom_btn = true;
            setTimeout(() => {
                _this.is_show_kkomkkom_btn = false; // 4초 후 꼼꼼하게 찾기 버튼 사라짐
            }, 4000);
        }
    }
});