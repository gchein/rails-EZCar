import { Controller } from "stimulus";
import { get } from "@rails/request.js";

export default class extends Controller {
  static targets = ["input", "results", "resultsContainer"];

  connect() {
    this.inputTarget.addEventListener("input", this.search.bind(this));
  }

  async search(event) {
    const query = this.inputTarget.value;

    if (query.length > 2) {
      const response = await get(`/cars/search?query=${query}`, {
        responseKind: "json"
      });

      if (response.ok) {
        const cars = await response.json;
        this.updateResults(cars);
      } else {
        console.error("Search request failed");
      }
    } else {
      this.resultsTarget.innerHTML = "";
    }
  }

  updateResults(cars) {
    this.resultsTarget.innerHTML = "";

    if (cars.length > 0) {
      cars.forEach((car) => {
        const item = document.createElement("a");
        item.href = `/cars/${car.id}`;
        item.className = "list-group-item list-group-item-action";
        item.textContent = `${car.year} ${car.brand} ${car.model}`;
        this.resultsTarget.appendChild(item);
      });
    } else {
      const item = document.createElement("div");
      item.className = "list-group-item";
      item.textContent = "No results found";
      this.resultsTarget.appendChild(item);
    }
  }
}
