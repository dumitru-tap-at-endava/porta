# frozen_string_literal: true

class DeleteContractHierarchyWorker < DeleteObjectHierarchyWorker
  def perform(*)
    DeletionLock.call_with_lock(lock_key: id, debug_info: caller_worker_hierarchy) { super }
  end
end
