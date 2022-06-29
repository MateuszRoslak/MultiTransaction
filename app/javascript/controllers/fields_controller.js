import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['priceInput']

    priceInputTargetConnected() {
        const value = this.priceInputTarget.value;

        if (value && value !== '0') {
            this.priceInputTarget.value = `${value.slice(0, value.length - 2)}.${value.slice(-2)}`
        }

        this.formatPrice()
    }

    formatPrice() {
        const value = this.priceInputTarget.value.replace(',', '')

        let price = parseFloat(value)
            .toFixed(2)
            .replace(/\d(?=(\d{3})+\.)/g, '$&,');

        if (price === 'NaN') { price = '0.00' }

        this.priceInputTarget.value = price
    }
}