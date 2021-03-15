module ExcelValidator
  OUTPUT_FILE_SHEETS_NAMES = ["Reporte Estudiantes", "CEL AP2 = AP1", "RUT INVALIDOS DE ESTUDIANTES"]
  FIRST_GUARDIAN_PHONE_NUMBER_RANGE = 0..33
  

  def self.process(file)
    setup(file)
    @sheet = @input_file.sheet(0)
    set_headers(@sheet)
    validate_guardians(@sheet)
    @output_file.serialize('output.xlsx')
    @output_file
  end

  private_class_method def self.set_headers(sheet)
    @headers = {}
    sheet.row(1).each_with_index {|header,i|
      @headers[header] = i
    }
  end

  private_class_method def self.validate_guardians(sheet)
    @first_guardian_phones = sheet.column(@headers["Celular Apoderado"] + 1)
    @second_guardian_phones = sheet.column(@headers["Celular Apoderado Secundario"] + 1) 

    @first_guardian_phones.each_with_index do |first_guardian_phone, index|
      next if index.zero?

      @second_guardian_phones.each do |second_guardian_phone|
        if first_guardian_phone == second_guardian_phone and first_guardian_phone != nil
          
          row = sheet.row(index + 1)
          row2 = row[FIRST_GUARDIAN_PHONE_NUMBER_RANGE]
          worksheet = find_sheet(@output_file, "CEL AP2 = AP1")
          worksheet.add_row(row)
        end
      end
    end
  end

  private_class_method def self.copy_base_sheet
    @sheet.rows.each do |row|
      output_sheet = find_sheet(@output_file, "Reporte Estudiantes")
      output_sheet.add_row(row)
    end
  end

  private_class_method def self.setup(input_file)
    @input_file = Roo::Spreadsheet.open(input_file.service_url, extension: :xlsx)
    @output_file = Axlsx::Package.new
    OUTPUT_FILE_SHEETS_NAMES.each do |name|
      @output_file.workbook.add_worksheet(name: name)
    end
  end

  private_class_method def self.find_sheet(file, sheet_name)
    file.workbook.worksheets.each do |worksheet|
      next unless worksheet.name == sheet_name

      return worksheet
    end
  end

end