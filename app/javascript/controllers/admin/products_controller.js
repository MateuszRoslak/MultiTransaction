import {Controller} from "@hotwired/stimulus"
import apiRequest from "../../utils/apiRequest";

export default class extends Controller {
    async toggleActive({target}) {
        const id = target.dataset.id
        const body = {active: target.checked}

        await apiRequest(`/admin/products/${id}/toggle_active`, 'PUT', body)
            .then(response => response.text())
            .then(Turbo.renderStreamMessage)
    }
}
