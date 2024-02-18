Vue.component('Row-Category',{
    template : '\
    <ul class="ctgr_nav_list">\
        <li v-for="(category, index) in categories" v-bind:key="category.catecode" v-show="index < view_count">\
            <a @click="click_category(category.catecode, category.hasRowList)">\
                <span class="txt">{{category.catename}}</span>\
                <span class="cnt">{{number_format(category.itemCount)}}</span>\
            </a>\
        </li>\
    </ul>\
    ',
    props : {
        categories : { // 하위 카테고리 리스트
            catecode : {type:Number, default:0}, // 카테고리 코드
            catename : {type:String, default:''}, // 카테고리명
            itemCount : {type:Number, default:0}, // 상품 수
            hasRowList : {type:Boolean, default:false} // 하위 카테고리 보유 여부
        },
        view_count : {type:Number, default:0} // 처음 노출할 하위 카테고리 수
    },
    methods : {
        click_category (category_code, has_row_list) { // 하위 카테고리 클릭
            this.$emit('click_category', category_code, has_row_list);
        }
    }
});