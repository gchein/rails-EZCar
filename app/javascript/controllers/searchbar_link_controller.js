import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  static targets = ["address", "mainSearchbar", "map"]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.mapTarget,
      style: "mapbox://styles/mapbox/streets-v10",
      proximity: "0,0"
    })



    this.addMarkersToMap()
    this.fitMapToMarkers()
    this.mapSearchBar = new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl })
    this.map.addControl(this.mapSearchBar)

    this.createSearchbar()
  }

  createSearchbar() {
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address"
    })
    this.geocoder.addTo(this.mainSearchbarTarget)

    this.geocoder.on("result", event => this.setInputValue(event))
    this.geocoder.on("clear", () => this.clearInputValue())
  }


  addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      const customMarker = document.createElement("div")
      customMarker.innerHTML = marker.car_mark_html
      new mapboxgl.Marker(customMarker)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  disconnect() {
    this.geocoder.onRemove()
  }

  setInputValue(event) {
    // console.log(event.result["place_name"]);
    // console.log(this.mapSearchBar);
    this.mapSearchBar.value = event.result["place_name"]
    // this.connect(event.result["place_name"])
  }

  clearInputValue() {
    this.addressTarget.value = ""
  }
}
