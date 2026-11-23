import "@hotwired/turbo-rails"
import { application } from "./controllers/application"
import SidebarController from "./controllers/sidebar_controller"
import FilterController from "./controllers/filter_controller"
import SummaryController from "./controllers/summary_controller"

application.register("sidebar", SidebarController)
application.register("filter", FilterController)
application.register("summary", SummaryController)
