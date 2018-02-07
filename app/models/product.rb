class Product < ActiveRecord::Base

  def self.import(original_filename, file_path, process_id)
    spreadsheet = open_spreadsheet(original_filename, file_path)
    header = spreadsheet.row(1)
    Polling.create!(process_id: process_id)
    puts "Start Process>>>>#{process_id}"
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = Product.find_or_initialize_by(title: row['title'], description: row['description'])
      product.attributes = row.to_hash.slice(*row.to_hash.keys)
      product.save!
    end
    polling_process = Polling.find_by(process_id: process_id)
    polling_process.update_attribute(:is_running, false)
    puts "End Process>>>>>#{process_id}"
  end

  def self.open_spreadsheet(original_filename, path)
  	case File.extname(original_filename)
	  when '.xls' then Roo::Excel.new(path)
	  when '.xlsx' then Roo::Excelx.new(path)
    else raise "Unknown file type: #{original_filename}"
    end
	end
end
