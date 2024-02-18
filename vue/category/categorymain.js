// 파라미터를 java Array 변수로 return
function getParametersObject() {		
    var url = unescape(location.href); 
    var paramArr = (url.substring(url.indexOf("?")+1,url.length)).split("&"); 
    
    var returnObject = {};
    for(var i = 0 ; i < paramArr.length ; i++){
        var temp = paramArr[i].split("=");
        returnObject[temp[0]] = temp[1];
    }
    return returnObject;
}
// Decode Base64
function decodeBase64(str) {
    return atob(str.replace(/_/g, '/').replace(/-/g, '+'));
}

var app = new Vue({
    el: '#app',
    store: store,
    template: '\
        <div id="content" class="content category_main">\
            <Group\
                :this_category="this_category"\
                :categories="categories"\
                :first_category_view_count="first_category_view_count"\
                :more_category_count="more_category_count"\
            >\
            </Group>\
            <Contents\
                :content_order="content_order"\
                :banners="banners"\
                :exhibitions="exhibitions"\
            >\
            </Contents>\
        </div>\
    ',
    computed : {
        first_category_view_count : function() { // 첫 카테고리 노출 수
            return this.$store.getters.first_category_view_count;
        },
        more_category_count : function() { // 더보기 카테고리 수
            return this.$store.getters.more_category_count;
        },
        this_category : function() { // 현재 카테고리
            return this.$store.getters.this_category;
        },
        categories : function() { // 카테고리 리스트
            return this.$store.getters.categories;
        },
        content_order : function () { // 컨텐츠 순서
            return this.$store.getters.content_order;
        },
        banners : function() { // 배너 리스트
            return this.$store.getters.banners;
        },
        exhibitions : function() { // 기획전 리스트
            return this.$store.getters.exhibitions;
        }
    },
    created : function() {
        // 파라미터 STORE에 SET
        this.$store.commit('SET_REQ_PARAM', getParametersObject());
        // 메인 아이템 불러오기
        this.$store.dispatch('GET_MAIN_ITEMS');
    },
    updated : function() {
        this.create_banner_slider(); // 배너 슬라이드 생성
    },
    methods : {
        create_banner_slider: function() { // 배너 슬라이드 생성
            $('.evt_slider_type1').each(function(i, el) {
                var slider = $(el).find('.swiper-container'),
                    lth = slider.find('.swiper-slide').length,
                    paging = $(el).find('.paging');
                if (lth > 1) {
                    slider.addClass('on'+i);
                    paging.addClass('on'+i);
                    var evtSwiper1 = new Swiper('.swiper-container.on'+i, {
                        speed: 500,
                        pagination: {
                            el: '.paging.on'+i,
                            type: 'fraction',
                            currentClass: 'em',
                            totalClass: 'total',
                            renderFraction: function (currentClass, totalClass) {
                                return '<em class="' + currentClass + '"></em>' + '<i class="bar">/</i>' + '<span class="' + totalClass + '"></span>';
                            }
                        }
                    });
                } else {
                    $(el).find('.btn_more').hide();
                }
            });
        }
    }
});