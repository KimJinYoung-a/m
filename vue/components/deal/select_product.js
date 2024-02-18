Vue.component('SELECT-PRODUCT', {
    template : `
        <div class="dropdwon-box">
            <div class="dropDown">
                
                <button v-if="selectedProduct" @click="showDropBox = !showDropBox" type="button" :class="dropButtonClass">
                    [상품{{selectedProduct.number}}] {{selectedProduct.itemName}}
                </button>
                
                <div :class="dropBoxClass">
                    <ul v-if="dealProducts && dealProducts.length > 0">
                        <li v-for="product in dealProducts">
                            <a @click="changeProduct(product.itemId)">
                                <div class="option">
                                    [상품{{product.number}}] {{product.itemName}} 
                                    <em class="value">{{numberFormat(product.reviewCount)}}건</em>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
                
            </div>
        </div>
    `,
    data() {return {
        showDropBox : false,
    }},
    props : {
        dealProducts : {
            itemId : { type:Number, default:0 }, // 상품 ID
            itemName : { type:String, default:'' }, // 상품명
            reviewCount : { type:Number, default:0 }, // 후기 갯수
        }
    },
    computed : {
        dropButtonClass() {
            return ['btnDrop', 'review', {on : this.showDropBox}];
        },
        dropBoxClass() {
            return ['reviewBox', 'dropBox', 'multi', {on : this.showDropBox}];
        },
        //region selectedProduct 선택 중인 상품
        selectedProduct() {
            return this.dealProducts.find(p => p.selected);
        },
        //endregion
    },
    methods : {
        changeProduct(itemId) {
            this.showDropBox = false;
            this.$emit('changeProduct', itemId);
        },
        //region numberFormat 숫자 포맷
        numberFormat(num){
            num = num.toString();
            return num.replace(/(\d)(?=(?:\d{3})+(?!\d))/g,'$1,');
        },
        //endregion
    }
});