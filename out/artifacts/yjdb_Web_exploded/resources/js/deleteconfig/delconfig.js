function confirmDelete() {
    if (confirm("是否确定删除此文档？"))
        return confirm("删除的文档不可恢复。是否继续？");

    return false;
}