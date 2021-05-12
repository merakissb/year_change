module ExcelValidator
  OUTPUT_FILE_SHEETS_NAMES = ["Reporte Estudiantes", "CEL AP2 = AP1", "RUT INVALIDOS DE ESTUDIANTES"]
  INVALID_DATA_SECOND_GUARDIAN = 39..45  

  def self.process(file)
    setup(file)
    @sheet = @input_file.sheet(0)
    set_headers(@sheet)
    #copy_base_sheet
    validate_guardians(@sheet)
    @output_file.serialize('output.xlsx')
    @output_file
  end

  private_class_method def self.setup(input_file)
   url = Rails.application.routes.url_helpers.url_for(input_file)
   @input_file = Roo::Spreadsheet.open(url, extension: :xlsx)
   @output_file = Axlsx::Package.new
   OUTPUT_FILE_SHEETS_NAMES.each do |name|
     @output_file.workbook.add_worksheet(name: name)
   end
  end

  private_class_method def self.set_headers(sheet)
   @headers = {}
   sheet.row(1).each_with_index {|header,i|
     @headers[header] = i
   }
  end

  private_class_method def self.copy_base_sheet
   output_sheet = find_sheet(@output_file, "Reporte Estudiantes")
   @sheet.parse(headers: true) do |row|
     output_sheet.add_row(row.values)
   end
  end

  private_class_method def self.validate_guardians(sheet)
   first_guardian_phones = sheet.column(@headers["Celular Apoderado"] + 1).drop(1)
   second_guardian_phones = sheet.column(@headers["Celular Apoderado Secundario"] + 1).drop(1)
   main_sheet = find_sheet(@output_file, "Reporte Estudiantes")    
   error_sheet = find_sheet(@output_file, "CEL AP2 = AP1")
   error_sheet.add_row(sheet.row(1)) #header
   main_sheet.add_row(sheet.row(1)) #header
    #debugger
   msheet = sheet.parse#.sort_by{|item| parse_nil(item[33])}.reverse #main sheet
   esheet = sheet.parse#.sort_by{|item| parse_nil(item[33])}.reverse #errors sheet
    
   first_guardian_phones.each_with_index do |first_guardian_phone, findex|
     @same_row_error = false      
     if first_guardian_phone.nil? || first_guardian_phone.to_s.empty? && second_guardian_phones[findex].nil?
       next main_sheet.add_row(msheet[findex]) unless @same_row_error 
     end
      
     second_guardian_phones.each_with_index do |second_guardian_phone, sindex|       
        next if sindex.zero?
        #debugger if findex == 3 && sindex == 4
        #debugger if findex == 122 && sindex == 58
       next if second_guardian_phone.nil? || second_guardian_phone.to_s.empty?
        
       if second_guardian_phone.to_s.strip == first_guardian_phone.to_s.strip && sindex == findex
           error_row = esheet[sindex]
           error_sheet.add_row(error_row)
           INVALID_DATA_SECOND_GUARDIAN.each do |range|
             msheet[findex][range - 1] = nil
           end
           main_sheet.add_row(msheet[findex])
           second_guardian_phones[sindex] = nil
           next @same_row_error = true
       end
        
       if second_guardian_phone.to_s.strip == first_guardian_phone.to_s.strip
         error_row = esheet[sindex]
         error_sheet.add_row(error_row)
         INVALID_DATA_SECOND_GUARDIAN.each do |range|
           msheet[sindex][range - 1] = nil
           msheet[findex][range - 1] = nil
         end
         second_guardian_phones[sindex] = nil
       end
     end
     main_sheet.add_row(msheet[findex]) unless @same_row_error
   end
 end

  def self.parse_nil(arg)
   return "" if arg.nil?
   arg
  end

 private_class_method def self.find_sheet(file, sheet_name)
   file.workbook.worksheets.each do |worksheet|
     next unless worksheet.name == sheet_name
     return worksheet
   end
 end

end