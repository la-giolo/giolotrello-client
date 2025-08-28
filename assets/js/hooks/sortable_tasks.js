import Sortable from "sortablejs";

let SortableTasks = {
  mounted() {
    Sortable.create(this.el, {
      animation: 150,
      onEnd: (evt) => {
        let ids = Array.from(this.el.children).map(el => el.dataset.id);
        this.pushEvent("reorder_tasks", { ids: ids });
      }
    });
  }
};

export default SortableTasks;
