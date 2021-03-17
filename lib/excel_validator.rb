module ExcelValidator
  OUTPUT_FILE_SHEETS_NAMES = ["Reporte Estudiantes", "CEL AP2 = AP1", "RUT INVALIDOS DE ESTUDIANTES"]
  INVALID_DATA_SECOND_GUARDIAN = 39..45
  

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
    main_sheet = find_sheet(@output_file, "Reporte Estudiantes")
    error_sheet = find_sheet(@output_file, "CEL AP2 = AP1")
    @first_guardian_phones.each_with_index do |first_guardian_phone, index|
      next if index.zero?
      
      @second_guardian_phones.each_with_index do |second_guardian_phone, index|
        next if index.zero?

        row = sheet.row(index + 1)        
        
        if first_guardian_phone == second_guardian_phone && first_guardian_phone != nil
          
          INVALID_DATA_SECOND_GUARDIAN.each do |range|
            row[range - 1] = nil
          end

          error_sheet.add_row(row)
          main_sheet.add_row(row)
          @second_guardian_phones[index] = nil
        else
          main_sheet.add_row(row)
        end
      end
    end
  end

  private_class_method def self.copy_base_sheet
    output_sheet = find_sheet(@output_file, "Reporte Estudiantes")
    @sheet.parse(headers: true) do |row|
      output_sheet.add_row(row.values)
    end
  end

  private_class_method def self.setup(input_file)
    url = Rails.application.routes.url_helpers.url_for(input_file)
    @input_file = Roo::Spreadsheet.open(url, extension: :xlsx)
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