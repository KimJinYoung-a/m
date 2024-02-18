Vue.component('MODAL-LINK-ITEM', {
    template : `
        <div @click="selectItem(item)" :class="['search_list', {on:selectedValue==item.id}]">
            <span class="btn_radio"></span>
            <div class="list_info">
                <!-- 상품일때 -->
                <div :class="['img', {brand:type==='brand'}, {produce:type==='event'}]">
                    <img :src="item.image" alt="">
                </div>
                <div class="info">
                    <p v-if="item.subTitle" class="prd_tit">{{item.subTitle}}</p>
                    <p class="prd_txt">{{item.title}}</p>
                </div>
            </div>
            <div class="price">{{type==='product' ? numberFormat(item.price) + '원' : ''}}</div>
        </div>
    `,
    props : {
        type : { type:String, default:'product' }, // 아이템 유형
        selectedValue : { type:String, default:'' }, // 선택된 값
        item : {
            id : {type: String, default:''}, // ID
            image: {type: String, default: ''}, // 이미지
            subTitle: {type: String, default: ''}, // 서브타이틀
            title: {type: String, default: ''}, // 타이틀
            price: {type: String, default: ''}, // 가격
        }
    },
    methods : {
        selectItem(item) {
            this.$emit('selectItem', item);
        }
    }
})