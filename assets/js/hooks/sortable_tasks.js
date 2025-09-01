import Sortable from "sortablejs"

let SortableTasks = {
  mounted() {
    this.sortable = new Sortable(this.el, {
      animation: 150,
      group: "lists",
      onEnd: (evt) => {
        let taskId = evt.item.dataset.id
        let afterTask = evt.item.previousElementSibling
          ? evt.item.previousElementSibling.dataset.id
          : null
        let listId = evt.to.dataset.listId

        this.pushEvent("reorder_task", {
          task_id: taskId,
          after_task_id: afterTask,
          list_id: listId
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
