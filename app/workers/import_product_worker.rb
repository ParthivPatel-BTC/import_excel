class ImportProductWorker < SidekiqWorker
  def perform(original_filename, file_path)
    Product.import(original_filename, file_path, self.jid)
  end
end