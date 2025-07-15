// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Required by Blacklight
import * as bootstrap from "bootstrap"
import Blacklight from "blacklight-frontend";

// Required by Spotlight
import githubAutoCompleteElement from "@github/auto-complete-element";
import "./spotlight"
// Import custom osd event listeners before osd to ensure listeners are set up correctly
import "./openseadragon_listeners"
import "openseadragon"
import "openseadragon-rails"
import "./blacklight_oembed"
import "blacklight-gallery/blacklight-gallery.esm.js"

// Custom JavaScript
import "./sir_trevor_block_overrides"
import "./openseadragon_overrides"
import "./related_pages"
import "./carousel"
