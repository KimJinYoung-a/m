// 스페티벌 Top7 상품
Vue.component('Spetival-Item',{
    template : `
        <li>
            <a @click="goProductDetail(item.itemId)">
                <div class="thumbnail"><img :src="item.itemImage" alt=""></div>
                <div class="desc">
                    <p class="brand">{{item.brandName}}</p>
                    <p class="name">{{item.itemName}}</p>
                    <p :class="['price', {'not-sale' : item.salePercent === 0}]">
                        <s v-if="item.salePercent > 0">{{numberFormat(item.orgPrice)}}</s>
                        {{numberFormat(item.price)}}
                        <span v-if="item.salePercent > 0">{{item.salePercent}}%</span>
                    </p>
                </div>
            </a>
        </li>
    `,
    props : {
        isApp : { type : Boolean, default : false }, // App 여부
        item : {
            itemId: {type: Number, default: 0}, // 상품ID
            itemImage: {type: String, default: ''}, // 이미지
            brandName: {type: String, default: ''}, // 브랜드명
            itemName: {type: String, default: ''}, // 상품명
            orgPrice: {type: Number, default: 0}, // 기존가격
            price: {type: Number, default: 0}, // 상품가격
            salePercent: {type: Number, default: 0}, // 할인율
        }
    },
    methods : {
        numberFormat(number) {
            if( number == null || isNaN(number) )
                return '';
            else
                return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
        goProductDetail(itemId) {
            this.$emit('goProductDetail', itemId);
        }
    }
})