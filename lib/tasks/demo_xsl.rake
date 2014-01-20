task :xsl_demo => :environment do
  require 'roo'
  s = Roo::Excelx.new("db/myspreadsheet.xlsx")
    @rows = s.last_row
    s.default_sheet = s.sheets[1]
    table_name_hash = Hash.new{|h,k| h[k]=[]}
    fields_name_hash = Hash.new{|h,k| h[k]=[]}
    2.upto(@rows) do |sheet1_count|
      unless s.cell(sheet1_count,7,s.sheets[0]).blank?
       table_name_hash[s.cell(sheet1_count,3,s.sheets[0])] << [s.cell(sheet1_count,4,s.sheets[0]), s.cell(sheet1_count,7,s.sheets[0]).to_i]
      end
    end
    puts table_name_hash.delete_if { |key| key.blank? }
    table_name = table_name_hash.keys
    temp_arr = []
    table_name.each do |table|
      fields = table_name_hash[table]
      fields.each do |segment_type|
        2.upto(s.last_row) do |line|
            if (!temp_arr.include? segment_type.last.to_i and  (s.cell(line,'A').to_i == segment_type.last.to_i))
              size = s.cell(line,'E').blank? ? '' : (s.cell(line,'E').class == Float ? s.cell(line,'E').to_i : s.cell(line,'E'))
              fields_name_hash[s.cell(line,'B')] << [s.cell(line,'C')+':'+s.cell(line,'D')+size.to_s]
              #puts "#{s.cell(line,'B')}  #{s.cell(line,'C')}:#{s.cell(line,'D')}#{s.cell(line,'E').blank? ? '' : (s.cell(line,'E').class == Float ? s.cell(line,'E').to_i : s.cell(line,'E')) }"
            end
        end
        temp_arr << segment_type.last.to_i
      end
    end
    table_name =  fields_name_hash.keys
    table_name.each do |table|
      debugger
      if !ActiveRecord::Base.connection.table_exists? table.pluralize.to_underscore

      end
    end
end