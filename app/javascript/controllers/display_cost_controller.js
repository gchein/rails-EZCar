import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="display-cost"
export default class extends Controller {
  static targets = ['totalCost', 'startDate', 'endDate']

  static values = {
    dailyPrice: Number
  }

  connect() {
  }

  calculateCost() {
    if (this.canCalculateCost()) {
      const startDate = this.startDateTarget.value;
      const endDate = this.endDateTarget.value;

      const date1 = new Date(endDate);
      const date2 = new Date(startDate);

      // Step 2: Get the time values in milliseconds
      const time1 = date1.getTime();
      const time2 = date2.getTime();

      // Step 3: Subtract the time values
      const timeDifference = time1 - time2; // difference in milliseconds

      // Step 4: Convert the difference to days
      const millisecondsInOneDay = 1000 * 60 * 60 * 24;
      const dayDifference = timeDifference / millisecondsInOneDay;

      this.totalCostTarget.classList.remove('d-none')
      this.totalCostTarget.innerHTML = `Total Cost: ${dayDifference * this.dailyPriceValue / 100}`
    }
  }


  canCalculateCost() {
    return this.startDateTarget.value != '' && this.endDateTarget.value != ''
  }
}
