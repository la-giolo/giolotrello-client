import Sortable from "sortablejs"

let SortableTasks = {
  mounted() {
    this.sortable = new Sortable(this.el, {
      animation: 150,
      onEnd: (evt) => {
        let taskId = evt.item.dataset.id
        let afterTask = evt.item.previousElementSibling
          ? evt.item.previousElementSibling.dataset.id
          : null

        this.pushEvent("reorder_task", {
          task_id: taskId,
          after_task_id: afterTask
        })
      },
    })
  },
  destroyed() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }
}

export default SortableTasks
